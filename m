Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFCB339904
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 00:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731828AbfFGWil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 18:38:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731755AbfFGWiU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 18:38:20 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6E0C20868;
        Fri,  7 Jun 2019 22:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559947099;
        bh=hefFaO5llMPR2l4B0U1XpbdcfUiRpqZKAfXbnOf7l4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NbN7FLrJL8KHNOZhwlM8l7gcTa282x8ox90hMUH72T3dROX0W3cEjjG1JBsyx5M47
         XielpsM2hB0895HiT4KqLdmOUR4oM9j2EF70UR1K5NyAZ/LJKqss1O1Y3Je3A3/Kej
         QpjLYzJ5kSEdUHfrFVOFgY6aGLvlTFwDagUNAlxM=
From:   David Ahern <dsahern@kernel.org>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 iproute-next 05/10] libnetlink: Add helper to create nexthop dump request
Date:   Fri,  7 Jun 2019 15:38:11 -0700
Message-Id: <20190607223816.27512-6-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190607223816.27512-1-dsahern@kernel.org>
References: <20190607223816.27512-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add rtnl_nexthopdump_req to initiate a dump request of nexthop objects.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/libnetlink.h |  4 ++++
 lib/libnetlink.c     | 27 +++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/libnetlink.h b/include/libnetlink.h
index 599b2c592f68..1ddba8dcd220 100644
--- a/include/libnetlink.h
+++ b/include/libnetlink.h
@@ -93,6 +93,10 @@ int rtnl_dump_request(struct rtnl_handle *rth, int type, void *req,
 int rtnl_dump_request_n(struct rtnl_handle *rth, struct nlmsghdr *n)
 	__attribute__((warn_unused_result));
 
+int rtnl_nexthopdump_req(struct rtnl_handle *rth, int family,
+			 req_filter_fn_t filter_fn)
+	__attribute__((warn_unused_result));
+
 struct rtnl_ctrl_data {
 	int	nsid;
 };
diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index eb85bbdf01ee..af2a3bbfd29b 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -25,6 +25,7 @@
 #include <linux/fib_rules.h>
 #include <linux/if_addrlabel.h>
 #include <linux/if_bridge.h>
+#include <linux/nexthop.h>
 
 #include "libnetlink.h"
 
@@ -252,6 +253,32 @@ int rtnl_open(struct rtnl_handle *rth, unsigned int subscriptions)
 	return rtnl_open_byproto(rth, subscriptions, NETLINK_ROUTE);
 }
 
+int rtnl_nexthopdump_req(struct rtnl_handle *rth, int family,
+			 req_filter_fn_t filter_fn)
+{
+	struct {
+		struct nlmsghdr nlh;
+		struct nhmsg nhm;
+		char buf[128];
+	} req = {
+		.nlh.nlmsg_len = NLMSG_LENGTH(sizeof(struct nhmsg)),
+		.nlh.nlmsg_type = RTM_GETNEXTHOP,
+		.nlh.nlmsg_flags = NLM_F_DUMP | NLM_F_REQUEST,
+		.nlh.nlmsg_seq = rth->dump = ++rth->seq,
+		.nhm.nh_family = family,
+	};
+
+	if (filter_fn) {
+		int err;
+
+		err = filter_fn(&req.nlh, sizeof(req));
+		if (err)
+			return err;
+	}
+
+	return send(rth->fd, &req, sizeof(req), 0);
+}
+
 int rtnl_addrdump_req(struct rtnl_handle *rth, int family,
 		      req_filter_fn_t filter_fn)
 {
-- 
2.11.0

