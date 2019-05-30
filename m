Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B94812F078
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 06:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731273AbfE3EE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 00:04:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731296AbfE3DRv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 23:17:51 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA9702472C;
        Thu, 30 May 2019 03:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186271;
        bh=q4XWgk94DHiQSOHFmy9YG86ewVtVksqDQpele2P0ixQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UGI3fwQjezdHRGFwPyzqHc+ibHdxfWSktv/ucZRfWvdzy47lsxwxcpMF7khUEs49Z
         23Kt2h0QwIeXE0xazoLl468lCkE1WvM3EuAMQycakC80MNC8HCfq6JjGVDqX3p1h1+
         GSnvcTILpUAGeAPrKjErUVb9ykQfrVzyQeubCd3M=
From:   David Ahern <dsahern@kernel.org>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, David Ahern <dsa@cumulusnetworks.com>
Subject: [PATCH iproute2-next 9/9] ipmonitor: Add nexthop option to monitor
Date:   Wed, 29 May 2019 20:17:46 -0700
Message-Id: <20190530031746.2040-10-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190530031746.2040-1-dsahern@kernel.org>
References: <20190530031746.2040-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsa@cumulusnetworks.com>

Add capability to ip-monitor to listen and dump nexthop messages

Signed-off-by: David Ahern <dsa@cumulusnetworks.com>
---
 ip/ipmonitor.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/ip/ipmonitor.c b/ip/ipmonitor.c
index 9ecc7fd2011a..5da1256450b3 100644
--- a/ip/ipmonitor.c
+++ b/ip/ipmonitor.c
@@ -84,6 +84,12 @@ static int accept_msg(struct rtnl_ctrl_data *ctrl,
 		}
 	}
 
+	case RTM_NEWNEXTHOP:
+	case RTM_DELNEXTHOP:
+		print_headers(fp, "[NEXTHOP]", ctrl);
+		print_nexthop(n, arg);
+		return 0;
+
 	case RTM_NEWLINK:
 	case RTM_DELLINK:
 		ll_remember_index(n, NULL);
@@ -173,6 +179,7 @@ int do_ipmonitor(int argc, char **argv)
 	int lrule = 0;
 	int lnsid = 0;
 	int ifindex = 0;
+	int lnexthop = 1;
 
 	groups |= nl_mgrp(RTNLGRP_LINK);
 	groups |= nl_mgrp(RTNLGRP_IPV4_IFADDR);
@@ -202,30 +209,42 @@ int do_ipmonitor(int argc, char **argv)
 		} else if (matches(*argv, "link") == 0) {
 			llink = 1;
 			groups = 0;
+			lnexthop = 0;
 		} else if (matches(*argv, "address") == 0) {
 			laddr = 1;
 			groups = 0;
+			lnexthop = 0;
 		} else if (matches(*argv, "route") == 0) {
 			lroute = 1;
 			groups = 0;
+			lnexthop = 0;
 		} else if (matches(*argv, "mroute") == 0) {
 			lmroute = 1;
 			groups = 0;
+			lnexthop = 0;
 		} else if (matches(*argv, "prefix") == 0) {
 			lprefix = 1;
 			groups = 0;
+			lnexthop = 0;
 		} else if (matches(*argv, "neigh") == 0) {
 			lneigh = 1;
 			groups = 0;
+			lnexthop = 0;
 		} else if (matches(*argv, "netconf") == 0) {
 			lnetconf = 1;
 			groups = 0;
+			lnexthop = 0;
 		} else if (matches(*argv, "rule") == 0) {
 			lrule = 1;
 			groups = 0;
+			lnexthop = 0;
 		} else if (matches(*argv, "nsid") == 0) {
 			lnsid = 1;
 			groups = 0;
+			lnexthop = 0;
+		} else if (matches(*argv, "nexthop") == 0) {
+			groups = 0;
+			lnexthop = 1;
 		} else if (strcmp(*argv, "all") == 0) {
 			prefix_banner = 1;
 		} else if (matches(*argv, "all-nsid") == 0) {
@@ -313,6 +332,11 @@ int do_ipmonitor(int argc, char **argv)
 
 	if (rtnl_open(&rth, groups) < 0)
 		exit(1);
+	if (lnexthop && rtnl_add_nl_group(&rth, RTNLGRP_NEXTHOP) < 0) {
+		fprintf(stderr, "Failed to add nexthop group to list\n");
+		exit(1);
+	}
+
 	if (listen_all_nsid && rtnl_listen_all_nsid(&rth) < 0)
 		exit(1);
 
-- 
2.11.0

