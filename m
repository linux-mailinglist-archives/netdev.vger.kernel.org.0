Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F5221AC2A
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 02:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgGJAvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 20:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgGJAvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 20:51:17 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A033FC08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 17:51:16 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id g20so3267155edm.4
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 17:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UJ7FDz4ZttePdy2WT1D1Djok9WjKt+wRrqPoVgEsSqA=;
        b=Zw5HZUuReosPkxZVZBEwu4L5bgueaTnKzWJZ7zA5rh1Iy9eMT+lilb/5Tpg3ZxzbEU
         8pmkY9ww0UkE+sUhpeR++ccRMGt+mwBVg5EMJvub+PTfUDvHie5diPKbL0EKI3jhav7U
         2g0U2zWPSKkDLCsDZlM4Y/2PgaJhXxxVT/UhU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UJ7FDz4ZttePdy2WT1D1Djok9WjKt+wRrqPoVgEsSqA=;
        b=l7VLAw1nX428fE+FKTw70ydMaaDZhCI3EgNLJ8ofY70qC93qfFhK27/9ewx0Ky5TwI
         6xBRZ6Bv+JZVfYIODzLz34PYyIwygWmU4vYMSPVjegDkXqPE6JB98yqNZXTZCkrOPdae
         mv5cdYJoH8CxtfilryWUNr28ELUe4MGQDlSDgEfjSXS9hFRn332JRB8IpDCAQ538gU2u
         Ljv6MxfYtwixu+MyW3KddqzzVazhKoJ8rzfU9Z+ZXICwjEZOEI+ZrCnwksPpE6jBi2TR
         AHFVyQ6enVcM6dKPCTyCsvKiUqjQIBCQyihJiw6qF7Jx08ERET+cayTyq3bKBOnuoTFV
         tbwg==
X-Gm-Message-State: AOAM530g6j8z7o+soNe6Tjcf3/H7tKf5P5NAeIYEFSICIWI3sOZ8Kk64
        Fahuuf0ehcjoJXZZobtgVX2qmUbB4yF7
X-Google-Smtp-Source: ABdhPJyy4Gogm9af8PEMooI9UKWQs3AqwfNSyQuppw/p0L9ysmE9ARCkC0ysfTKXBcJDxwPqBXGLcQ==
X-Received: by 2002:a05:6402:1766:: with SMTP id da6mr72472920edb.48.1594342274935;
        Thu, 09 Jul 2020 17:51:14 -0700 (PDT)
Received: from jfk18.home (ip565315ca.direct-adsl.nl. [86.83.21.202])
        by smtp.googlemail.com with ESMTPSA id mf24sm2678971ejb.58.2020.07.09.17.51.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Jul 2020 17:51:14 -0700 (PDT)
From:   Julien Fortin <julien@cumulusnetworks.com>
X-Google-Original-From: Julien Fortin
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, dsahern@gmail.com,
        Julien Fortin <julien@cumulusnetworks.com>
Subject: [PATCH iproute2-next master] bridge: fdb show: fix fdb entry state output for json context
Date:   Fri, 10 Jul 2020 02:50:55 +0200
Message-Id: <20200710005055.8439-1-julien@cumulusnetworks.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julien Fortin <julien@cumulusnetworks.com>

bridge json fdb show is printing an incorrect / non-machine readable
value, when using -j (json output) we are expecting machine readable
data that shouldn't require special handling/parsing.

$ bridge -j fdb show | \
python -c \
'import sys,json;print(json.dumps(json.loads(sys.stdin.read()),indent=4))'
[
    {
        "master": "br0",
        "mac": "56:23:28:4f:4f:e5",
        "flags": [],
        "ifname": "vx0",
        "state": "state=0x80"  <<<<<<<<< with the patch: "state": "0x80"
    }
]

Fixes: c7c1a1ef51aea7c ("bridge: colorize output and use JSON print library")
Signed-off-by: Julien Fortin <julien@cumulusnetworks.com>
---
 bridge/fdb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/bridge/fdb.c b/bridge/fdb.c
index d2247e80..198c51d1 100644
--- a/bridge/fdb.c
+++ b/bridge/fdb.c
@@ -62,7 +62,10 @@ static const char *state_n2a(unsigned int s)
 	if (s & NUD_REACHABLE)
 		return "";
 
-	sprintf(buf, "state=%#x", s);
+	if (is_json_context())
+		sprintf(buf, "%#x", s);
+	else
+		sprintf(buf, "state=%#x", s);
 	return buf;
 }
 
-- 
2.27.0

