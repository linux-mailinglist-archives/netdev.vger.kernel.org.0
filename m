Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0082EC0A
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 05:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731303AbfE3DRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 23:17:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731277AbfE3DRu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 23:17:50 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02ACC24718;
        Thu, 30 May 2019 03:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186270;
        bh=v7bpd8jgnSr2idUWxcnwBTFRhZC+Jp1p0sNQKJ2hAoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZP/l34fwsSahwNYSEKP6Aee6yqShiwpb6saxBZUoiArE0UOTqDtTzGb94abSVSTcA
         Uh7eVTAT41pRdPfuyBOtie+yhUfP1UmwfOKgOTpNgP9/SW6RaIbwtMFIOrbKYNLF8o
         sdRtUwxa2dteGNFHKBp3WDNoM7rXFUoIpctx/1PE=
From:   David Ahern <dsahern@kernel.org>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next 5/9] libnetlink: Add helper to create nexthop dump request
Date:   Wed, 29 May 2019 20:17:42 -0700
Message-Id: <20190530031746.2040-6-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190530031746.2040-1-dsahern@kernel.org>
References: <20190530031746.2040-1-dsahern@kernel.org>
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
index eb85bbdf01ee..c1cdda3b8d4e 100644
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
+		.nlh.nlmsg_len = NLMSG_LENGTH(sizeof(struct ifaddrmsg)),
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

