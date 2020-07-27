Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9555122F4E8
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 18:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgG0QUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 12:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgG0QUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 12:20:35 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433C9C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 09:20:35 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id 88so15487939wrh.3
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 09:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s66hvz79ScDXNBFQIg99RoUIjiDMzoVc+szzIRjW8yU=;
        b=WkmsHmIX78vB9eF6Pu8mEaihfm7f/5ydgGt6i0Kjnid5XadE2yO88VAJ+Jz4GsO3RP
         cczMgmVPsdZUAw8E+EpaUEwKrK6wZyjx2QB3ERMQI0HdhWk64BbpzYbxvUQIjNkrhtmS
         ZDKReHBCLCuUJ+L2PIJoScZJYPNhcPSbtvmO0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s66hvz79ScDXNBFQIg99RoUIjiDMzoVc+szzIRjW8yU=;
        b=Y7BwfzOALx39yJn6uWYcOaN6LPv8HGo8WMeXseY3eg5IeAgCcHeUk22Zf+oqW1dn3l
         6Xx2yU1h/s0Xi53GEMsdigzOzgcmpF+QmoJ0eqDCse1jtRczpAofDtWIOHKm8wqrMxXf
         auw7Vxeli/Ug4Lh00C7NGPyXSXfOxCKVYlMb7u//hYOwOt6yvBm8108v55LDn7De+N9h
         mCCUYIMMVf1F/kHGgSiO4aYsPKiXvU6D7709qhDsRQ4SD/7mm3awXAPaBroq8+io68Tr
         3e3StDsZkdGbOuR7jWwkB9L555ZYgNu0R+hSlIPWfsFHc4qWMoc9THJ2bGahEUpXBKNN
         yTQg==
X-Gm-Message-State: AOAM530NKLRjKk1JNyBXwHiQ3Ye64NEnCEphfZbaKLLcTb0rZQj5guYv
        xcPHhvwJQrcB+jtuySe65T0wkGf3rQ==
X-Google-Smtp-Source: ABdhPJyVSite1pPGTTftSDTK7l36VHDV4isRe9O0zCSKKB0eZf7aoJv+25qyfCaDRyboBUcN8r/wAA==
X-Received: by 2002:a05:6000:1288:: with SMTP id f8mr20590161wrx.62.1595866833575;
        Mon, 27 Jul 2020 09:20:33 -0700 (PDT)
Received: from localhost.localdomain (82-64-1-127.subs.proxad.net. [82.64.1.127])
        by smtp.googlemail.com with ESMTPSA id w16sm14657662wrg.95.2020.07.27.09.20.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jul 2020 09:20:32 -0700 (PDT)
From:   Julien Fortin <julien@cumulusnetworks.com>
X-Google-Original-From: Julien Fortin
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, dsahern@gmail.com,
        Julien Fortin <julien@cumulusnetworks.com>
Subject: [PATCH iproute2-next master v2] bridge: fdb show: fix fdb entry state output (+ add json support)
Date:   Mon, 27 Jul 2020 18:20:09 +0200
Message-Id: <20200727162009.7618-1-julien@cumulusnetworks.com>
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

This patch also fixes the non-json output, from:
    state=0x42
to:
    state 0x42

This will only be displayed if the FDB entry has an unknown value.

Fixes: c7c1a1ef51aea7c ("bridge: colorize output and use JSON print library")

Signed-off-by: Julien Fortin <julien@cumulusnetworks.com>
---
 bridge/fdb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/bridge/fdb.c b/bridge/fdb.c
index d1f8afbe..765f4e51 100644
--- a/bridge/fdb.c
+++ b/bridge/fdb.c
@@ -62,7 +62,10 @@ static const char *state_n2a(unsigned int s)
 	if (s & NUD_REACHABLE)
 		return "";
 
-	sprintf(buf, "state=%#x", s);
+	if (is_json_context())
+		sprintf(buf, "%#x", s);
+	else
+		sprintf(buf, "state %#x", s);
 	return buf;
 }
 
-- 
2.27.0

