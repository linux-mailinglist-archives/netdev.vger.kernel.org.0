Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9B0398FA
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 00:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731809AbfFGWiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 18:38:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731768AbfFGWiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 18:38:21 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CA742089E;
        Fri,  7 Jun 2019 22:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559947100;
        bh=kgQuroGDZGTjw1UO4m+5RNoHqkWJ4ZBzcuOnFKfkHEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iDdghy6ijwwFWkiAdNfBfzs1pcDxrDb1Xry1tJXN8e0NFXSAJ1urp4j/7eZJmd5FI
         8IUy3cvomKa8uRyJU8Ai5iTUfBz5rr8Zo6Nf1vH3i3fDIol9GfRTH60TIC78dc6SKP
         uR6yWdUwc6pZmTOG0dYv+B4GFXoikUlTAxJDOUu0=
From:   David Ahern <dsahern@kernel.org>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 iproute-next 09/10] ip route: Add option to use nexthop objects
Date:   Fri,  7 Jun 2019 15:38:15 -0700
Message-Id: <20190607223816.27512-10-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190607223816.27512-1-dsahern@kernel.org>
References: <20190607223816.27512-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add nhid option for routes to use nexthop objects by id.

Example:
  $ ip nexthop add id 1 via 10.99.1.2 dev veth1
  $ ip route add 10.100.1.0/24 nhid 1
  $ ip route ls
  ...
  10.100.1.0/24 nhid 1 via 10.99.1.2 dev veth1

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 ip/iproute.c           | 14 ++++++++++++--
 man/man8/ip-route.8.in | 13 ++++++++++++-
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/ip/iproute.c b/ip/iproute.c
index 1c443265d479..6b8142250349 100644
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
diff --git a/man/man8/ip-route.8.in b/man/man8/ip-route.8.in
index b9ae6e30908d..a61b263e75e8 100644
--- a/man/man8/ip-route.8.in
+++ b/man/man8/ip-route.8.in
@@ -89,7 +89,9 @@ replace " } "
 .RB "{ " enabled " | " disabled " } ]"
 
 .ti -8
-.IR INFO_SPEC " := " "NH OPTIONS FLAGS" " ["
+.IR INFO_SPEC " := { " NH " | "
+.B nhid
+.IR ID " } " "OPTIONS FLAGS" " ["
 .B  nexthop
 .IR NH " ] ..."
 
@@ -687,6 +689,10 @@ is a string specifying the route preference as defined in RFC4191 for Router
 .sp
 
 .TP
+.BI nhid " ID"
+use nexthop object with given id as nexthop specification.
+.sp
+.TP
 .BI encap " ENCAPTYPE ENCAPHDR"
 attach tunnel encapsulation attributes to this route.
 .sp
@@ -1154,6 +1160,11 @@ ip -6 route add 2001:db8:1::/64 encap seg6 mode encap segs 2001:db8:42::1,2001:d
 .RS 4
 Adds an IPv6 route with SRv6 encapsulation and two segments attached.
 .RE
+.PP
+ip route add 10.1.1.0/30 nhid 10
+.RS 4
+Adds an ipv4 route using nexthop object with id 10.
+.RE
 .SH SEE ALSO
 .br
 .BR ip (8)
-- 
2.11.0

