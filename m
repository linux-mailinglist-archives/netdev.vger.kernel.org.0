Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A5021AC31
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 02:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgGJAxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 20:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgGJAxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 20:53:07 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55DBC08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 17:53:06 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id n2so3263249edr.5
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 17:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ME603uWCmmkD8OVovg/4mqc1jKvmYcJvuk68cn9yXWw=;
        b=KQyC0iJ3kV6uVuYkZsMMElCk4/lPXb3W3sdp8yjABsothEFHe7IqQ/4Gv+5pTs05EN
         zfzY6XTr6i4rgT89i/+QoBQs5Ph5IJv5TChFznySZu46IcyZcdhaF6HBg0GiAfXX9cpI
         aX0Y8DSuAbN2XWjO4thGSdn3Fy0Epcg61nZ+A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ME603uWCmmkD8OVovg/4mqc1jKvmYcJvuk68cn9yXWw=;
        b=ZwDELFtcoTsGcJEj7MoyCQqzipCSKqVW1YsvfzOehlLSfRrUJ2Zb88wiJqxXOlsoSF
         z++X4KubAEwMyqX3iJsb24wbbcDS+3xrE/lOOZ5JLgrtP0+VFD4mLOKHBQxcpzQHj1qG
         70HayPj4nFQb6vIPzKf9mybQZ+L+oUWX+yvI5bo8zRCx6q136Cdy5lWTMx7vWg5u5Dww
         dDztoOOs7Mfi/Nl9iUiDpGetUSrixNJ6lHhfGe4e7kIBJbn1XAh6An6ddcUEj92dKdzl
         IH8OlWpi6fxNeCP0dfjAToRwyQp7vkeZVlGQRGhSfYRaI+8Bq9ebgzMBVo+a9qZqbizS
         LHWw==
X-Gm-Message-State: AOAM530mDw4j7O/u/S14x0TOcbCtyyMWdSv+Eb791Stql3mBs7ulRnt5
        vlv8mdMD2aKOkGOnKNLIBbZsIWnUUyoX
X-Google-Smtp-Source: ABdhPJwHNiuY7Hd0T8XHmtqZqyEOpbUe+biHhykEoRl7BCjU20XZAStIEMynLSCesWfbTmH/gbyafA==
X-Received: by 2002:a05:6402:21c2:: with SMTP id bi2mr74325807edb.296.1594342385390;
        Thu, 09 Jul 2020 17:53:05 -0700 (PDT)
Received: from jfk18.home (ip565315ca.direct-adsl.nl. [86.83.21.202])
        by smtp.googlemail.com with ESMTPSA id w18sm3131546edv.11.2020.07.09.17.53.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Jul 2020 17:53:04 -0700 (PDT)
From:   Julien Fortin <julien@cumulusnetworks.com>
X-Google-Original-From: Julien Fortin
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, dsahern@gmail.com,
        Julien Fortin <julien@cumulusnetworks.com>
Subject: [PATCH iproute2-next master] bridge: fdb get: add missing json init (new_json_obj)
Date:   Fri, 10 Jul 2020 02:53:02 +0200
Message-Id: <20200710005302.8548-1-julien@cumulusnetworks.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julien Fortin <julien@cumulusnetworks.com>

'bridge fdb get' has json support but the json object is never initialized

before patch:

$ bridge -j fdb get 56:23:28:4f:4f:e5 dev vx0
56:23:28:4f:4f:e5 dev vx0 master br0 permanent
$

after patch:

$ bridge -j fdb get 56:23:28:4f:4f:e5 dev vx0 | \
python -c \
'import sys,json;print(json.dumps(json.loads(sys.stdin.read()),indent=4))'
[
    {
        "master": "br0",
        "mac": "56:23:28:4f:4f:e5",
        "flags": [],
        "ifname": "vx0",
        "state": "permanent"
    }
]
$

Signed-off-by: Julien Fortin <julien@cumulusnetworks.com>
---
 bridge/fdb.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/bridge/fdb.c b/bridge/fdb.c
index 198c51d1..aaee4d7c 100644
--- a/bridge/fdb.c
+++ b/bridge/fdb.c
@@ -638,10 +638,16 @@ static int fdb_get(int argc, char **argv)
 	if (rtnl_talk(&rth, &req.n, &answer) < 0)
 		return -2;
 
+	/*
+	 * Initialize a json_writer and open an array object
+	 * if -json was specified.
+	 */
+	new_json_obj(json);
 	if (print_fdb(answer, stdout) < 0) {
 		fprintf(stderr, "An error :-)\n");
 		return -1;
 	}
+	delete_json_obj();
 
 	return 0;
 }
-- 
2.27.0

