Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469802B3143
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 23:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgKNWyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 17:54:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgKNWyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 17:54:32 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE60C0613D2
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 14:54:32 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4CYVyY3TK2zQkKG;
        Sat, 14 Nov 2020 23:54:29 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1605394467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O1BS2wlJd+j4COExWE0BCzIjS6OYumVtlSK9jSU49P4=;
        b=eqqfE3FN/PvKPfx5qh+nV1PMvli2Zr6QCZwqhsRuUhLFQijztTG4QEOTfqExqRid9jxn6K
        rHe0ZOcuoYgnOgcYLbHg6YuddEUOr/02fjJ3KQuD59jhYpfbu4gtDsT+4Hn08jPmuX+wBT
        TLaG9nJUQIskgtAT3+lLLmRTM2T8vpiLYtyesqXM/uZ2SkM/ggbZtfSBEVZaGjL/PYrRKn
        fkRQxkW51WfZ1ojYGq8NoCq+up8aOXm9THM2JC+QJ9bjpFIfWGI6/6Is9c3ER2AY0XlNSx
        /TwtFdX4HsSRl3Y/7OVNsfL20HLOcBmOQdmQdFFy1X++ygGYo/v15h3MyPoPiQ==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id vT4cFwxNwo34; Sat, 14 Nov 2020 23:54:26 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 3/7] ip: iplink: Convert to use parse_on_off()
Date:   Sat, 14 Nov 2020 23:53:57 +0100
Message-Id: <972a28d826eb677c3884aed70f893e7d257b1328.1605393324.git.me@pmachata.org>
In-Reply-To: <cover.1605393324.git.me@pmachata.org>
References: <cover.1605393324.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -0.36 / 15.00 / 15.00
X-Rspamd-Queue-Id: 74F5017DD
X-Rspamd-UID: 8a6274
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Invoke parse_on_off() instead of rolling a custom function.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 ip/iplink.c | 47 +++++++++++++++++------------------------------
 1 file changed, 17 insertions(+), 30 deletions(-)

diff --git a/ip/iplink.c b/ip/iplink.c
index d6b766de1fcf..f5766c39507b 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -352,6 +352,7 @@ static int iplink_parse_vf(int vf, int *argcp, char ***argvp,
 	int len, argc = *argcp;
 	char **argv = *argvp;
 	struct rtattr *vfinfo;
+	int ret;
 
 	tivt.min_tx_rate = -1;
 	tivt.max_tx_rate = -1;
@@ -464,12 +465,9 @@ static int iplink_parse_vf(int vf, int *argcp, char ***argvp,
 			struct ifla_vf_spoofchk ivs;
 
 			NEXT_ARG();
-			if (matches(*argv, "on") == 0)
-				ivs.setting = 1;
-			else if (matches(*argv, "off") == 0)
-				ivs.setting = 0;
-			else
-				return on_off("spoofchk", *argv);
+			ivs.setting = parse_on_off("spoofchk", *argv, &ret);
+			if (ret)
+				return ret;
 			ivs.vf = vf;
 			addattr_l(&req->n, sizeof(*req), IFLA_VF_SPOOFCHK,
 				  &ivs, sizeof(ivs));
@@ -478,12 +476,9 @@ static int iplink_parse_vf(int vf, int *argcp, char ***argvp,
 			struct ifla_vf_rss_query_en ivs;
 
 			NEXT_ARG();
-			if (matches(*argv, "on") == 0)
-				ivs.setting = 1;
-			else if (matches(*argv, "off") == 0)
-				ivs.setting = 0;
-			else
-				return on_off("query_rss", *argv);
+			ivs.setting = parse_on_off("query_rss", *argv, &ret);
+			if (ret)
+				return ret;
 			ivs.vf = vf;
 			addattr_l(&req->n, sizeof(*req), IFLA_VF_RSS_QUERY_EN,
 				  &ivs, sizeof(ivs));
@@ -492,12 +487,9 @@ static int iplink_parse_vf(int vf, int *argcp, char ***argvp,
 			struct ifla_vf_trust ivt;
 
 			NEXT_ARG();
-			if (matches(*argv, "on") == 0)
-				ivt.setting = 1;
-			else if (matches(*argv, "off") == 0)
-				ivt.setting = 0;
-			else
-				invarg("Invalid \"trust\" value\n", *argv);
+			ivt.setting = parse_on_off("trust", *argv, &ret);
+			if (ret)
+				return ret;
 			ivt.vf = vf;
 			addattr_l(&req->n, sizeof(*req), IFLA_VF_TRUST,
 				  &ivt, sizeof(ivt));
@@ -595,6 +587,7 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 	int index = 0;
 	int group = -1;
 	int addr_len = 0;
+	int err;
 
 	ret = argc;
 
@@ -738,12 +731,9 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 			int carrier;
 
 			NEXT_ARG();
-			if (strcmp(*argv, "on") == 0)
-				carrier = 1;
-			else if (strcmp(*argv, "off") == 0)
-				carrier = 0;
-			else
-				return on_off("carrier", *argv);
+			carrier = parse_on_off("carrier", *argv, &err);
+			if (err)
+				return err;
 
 			addattr8(&req->n, sizeof(*req), IFLA_CARRIER, carrier);
 		} else if (strcmp(*argv, "vf") == 0) {
@@ -896,12 +886,9 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 			unsigned int proto_down;
 
 			NEXT_ARG();
-			if (strcmp(*argv, "on") == 0)
-				proto_down = 1;
-			else if (strcmp(*argv, "off") == 0)
-				proto_down = 0;
-			else
-				return on_off("protodown", *argv);
+			proto_down = parse_on_off("protodown", *argv, &err);
+			if (err)
+				return err;
 			addattr8(&req->n, sizeof(*req), IFLA_PROTO_DOWN,
 				 proto_down);
 		} else if (strcmp(*argv, "protodown_reason") == 0) {
-- 
2.25.1

