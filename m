Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA9CB2F07A
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 06:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388020AbfE3EEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 00:04:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731289AbfE3DRv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 23:17:51 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7D6724718;
        Thu, 30 May 2019 03:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186270;
        bh=QwG3ZJppL2g5avXanItwvvXBW0RsH5H0/GmNgisSARE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VynfEerpG9jX03Z/CklKvjCTw7IWw2d+cnFFahuXYj1MNJuECY9V8ZfeofnI7G2sm
         fBK8wDvAdP8IPjc8NdNGWjwDRYPBLQTcRi45kbUEx11M2y91+jypng0J0gcmRg81yI
         T9CxzRY+zy8Ml5lrocZHVh1VBVG2tznSesheFxP4=
From:   David Ahern <dsahern@kernel.org>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next 8/9] ip route: Add option to use nexthop objects
Date:   Wed, 29 May 2019 20:17:45 -0700
Message-Id: <20190530031746.2040-9-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190530031746.2040-1-dsahern@kernel.org>
References: <20190530031746.2040-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add nhid option for routes to use nexthop objects by id.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 ip/iproute.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/ip/iproute.c b/ip/iproute.c
index c5a473704d95..68f7f75f2336 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -80,7 +80,7 @@ static void usage(void)
 		"             [ table TABLE_ID ] [ proto RTPROTO ]\n"
 		"             [ scope SCOPE ] [ metric METRIC ]\n"
 		"             [ ttl-propagate { enabled | disabled } ]\n"
-		"INFO_SPEC := NH OPTIONS FLAGS [ nexthop NH ]...\n"
+		"INFO_SPEC := { NH | nhid ID } OPTIONS FLAGS [ nexthop NH ]...\n"
 		"NH := [ encap ENCAPTYPE ENCAPHDR ] [ via [ FAMILY ] ADDRESS ]\n"
 		"	    [ dev STRING ] [ weight NUMBER ] NHFLAGS\n"
 		"FAMILY := [ inet | inet6 | mpls | bridge | link ]\n"
@@ -809,6 +809,10 @@ int print_route(struct nlmsghdr *n, void *arg)
 		print_string(PRINT_ANY, "src", "from %s ", b1);
 	}
 
+	if (tb[RTA_NH_ID])
+		print_uint(PRINT_ANY, "nhid", "nhid %u ",
+			   rta_getattr_u32(tb[RTA_NH_ID]));
+
 	if (tb[RTA_NEWDST])
 		print_rta_newdst(fp, r, tb[RTA_NEWDST]);
 
@@ -1080,6 +1084,7 @@ static int iproute_modify(int cmd, unsigned int flags, int argc, char **argv)
 	int table_ok = 0;
 	int raw = 0;
 	int type_ok = 0;
+	__u32 nhid = 0;
 
 	if (cmd != RTM_DELROUTE) {
 		req.r.rtm_protocol = RTPROT_BOOT;
@@ -1358,6 +1363,11 @@ static int iproute_modify(int cmd, unsigned int flags, int argc, char **argv)
 		} else if (strcmp(*argv, "nexthop") == 0) {
 			nhs_ok = 1;
 			break;
+		} else if (!strcmp(*argv, "nhid")) {
+			NEXT_ARG();
+			if (get_u32(&nhid, *argv, 0))
+				invarg("\"id\" value is invalid\n", *argv);
+			addattr32(&req.n, sizeof(req), RTA_NH_ID, nhid);
 		} else if (matches(*argv, "protocol") == 0) {
 			__u32 prot;
 
@@ -1520,7 +1530,7 @@ static int iproute_modify(int cmd, unsigned int flags, int argc, char **argv)
 			 req.r.rtm_type == RTN_UNSPEC) {
 			if (cmd == RTM_DELROUTE)
 				req.r.rtm_scope = RT_SCOPE_NOWHERE;
-			else if (!gw_ok && !nhs_ok)
+			else if (!gw_ok && !nhs_ok && !nhid)
 				req.r.rtm_scope = RT_SCOPE_LINK;
 		}
 	}
-- 
2.11.0

