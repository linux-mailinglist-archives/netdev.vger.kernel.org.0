Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7670C39903
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 00:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731832AbfFGWih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 18:38:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731772AbfFGWiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 18:38:21 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C02D721479;
        Fri,  7 Jun 2019 22:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559947100;
        bh=y4GgxUE4lF8iag2yMAV9jIFARkru1PQ3cXDUPVGDn2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WvrqqUxJSVs8fKFb2Dorbk/uydnl3SzTOloq8u3XLmu5nwvzWKx0JhSFAoDB1Mszk
         T0byvR/EKKe2ApFcOgfKvlwKH/v3iitEpY0Qb3BRzIYFoVP67SzCWtmYwWA/vu7wnj
         5n+h6R+R1Nh1TXPRVrNj/JlmYkTQZrBpZ8K68B14=
From:   David Ahern <dsahern@kernel.org>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 iproute-next 10/10] ipmonitor: Add nexthop option to monitor
Date:   Fri,  7 Jun 2019 15:38:16 -0700
Message-Id: <20190607223816.27512-11-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190607223816.27512-1-dsahern@kernel.org>
References: <20190607223816.27512-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add capability to ip-monitor to listen and dump nexthop messages.
Since the nexthop group = 32 which exceeds the max groups bit
field, 2 separate flags are needed - one that defaults on to indicate
nexthop group is joined by default and a second that indicates a
specific selection by the user (e.g, ip mon nexthop route).

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 ip/ipmonitor.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/ip/ipmonitor.c b/ip/ipmonitor.c
index 9ecc7fd2011a..685be52cfe64 100644
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
@@ -161,6 +167,7 @@ static int accept_msg(struct rtnl_ctrl_data *ctrl,
 
 int do_ipmonitor(int argc, char **argv)
 {
+	int lnexthop = 0, nh_set = 1;
 	char *file = NULL;
 	unsigned int groups = 0;
 	int llink = 0;
@@ -202,30 +209,42 @@ int do_ipmonitor(int argc, char **argv)
 		} else if (matches(*argv, "link") == 0) {
 			llink = 1;
 			groups = 0;
+			nh_set = 0;
 		} else if (matches(*argv, "address") == 0) {
 			laddr = 1;
 			groups = 0;
+			nh_set = 0;
 		} else if (matches(*argv, "route") == 0) {
 			lroute = 1;
 			groups = 0;
+			nh_set = 0;
 		} else if (matches(*argv, "mroute") == 0) {
 			lmroute = 1;
 			groups = 0;
+			nh_set = 0;
 		} else if (matches(*argv, "prefix") == 0) {
 			lprefix = 1;
 			groups = 0;
+			nh_set = 0;
 		} else if (matches(*argv, "neigh") == 0) {
 			lneigh = 1;
 			groups = 0;
+			nh_set = 0;
 		} else if (matches(*argv, "netconf") == 0) {
 			lnetconf = 1;
 			groups = 0;
+			nh_set = 0;
 		} else if (matches(*argv, "rule") == 0) {
 			lrule = 1;
 			groups = 0;
+			nh_set = 0;
 		} else if (matches(*argv, "nsid") == 0) {
 			lnsid = 1;
 			groups = 0;
+			nh_set = 0;
+		} else if (matches(*argv, "nexthop") == 0) {
+			lnexthop = 1;
+			groups = 0;
 		} else if (strcmp(*argv, "all") == 0) {
 			prefix_banner = 1;
 		} else if (matches(*argv, "all-nsid") == 0) {
@@ -297,6 +316,9 @@ int do_ipmonitor(int argc, char **argv)
 	if (lnsid) {
 		groups |= nl_mgrp(RTNLGRP_NSID);
 	}
+	if (nh_set)
+		lnexthop = 1;
+
 	if (file) {
 		FILE *fp;
 		int err;
@@ -313,6 +335,12 @@ int do_ipmonitor(int argc, char **argv)
 
 	if (rtnl_open(&rth, groups) < 0)
 		exit(1);
+
+	if (lnexthop && rtnl_add_nl_group(&rth, RTNLGRP_NEXTHOP) < 0) {
+		fprintf(stderr, "Failed to add nexthop group to list\n");
+		exit(1);
+	}
+
 	if (listen_all_nsid && rtnl_listen_all_nsid(&rth) < 0)
 		exit(1);
 
-- 
2.11.0

