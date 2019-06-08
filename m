Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D45233A256
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 00:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbfFHWWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 18:22:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727391AbfFHWWY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 18:22:24 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97DAA217D7;
        Sat,  8 Jun 2019 21:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560030826;
        bh=zDNdZ0ZKELsMgesNGghK3qAZT/FSD2vVr62ptGSQ+zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z/qKpA7UOaq34cntERw4GRNMQUl2d2D4fBWvkJKVNkBOKl/FszUT3wIoEipl3mDJ6
         l5P73Nt/dJI1yCfxmwZKNtCgmSpoSY01rANO1ZdpHiZECzytz6RGixZw7bbapvb7AJ
         e7hPTmzVEwZEJhXjVawFMlfQGkBikwJ/F1TXEqng=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v4 net-next 11/20] ipv4: Allow routes to use nexthop objects
Date:   Sat,  8 Jun 2019 14:53:32 -0700
Message-Id: <20190608215341.26592-12-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190608215341.26592-1-dsahern@kernel.org>
References: <20190608215341.26592-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add support for RTA_NH_ID attribute to allow a user to specify a
nexthop id to use with a route. fc_nh_id is added to fib_config to
hold the value passed in the RTA_NH_ID attribute. If a nexthop id
is given, the gateway, device, encap and multipath attributes can
not be set.

Update fib_nh_match to check ids on a route delete.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/ip_fib.h     |  1 +
 net/ipv4/fib_frontend.c  | 19 +++++++++++++++++++
 net/ipv4/fib_semantics.c | 15 +++++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 4cdf8bc22efd..7e1e621a56df 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -40,6 +40,7 @@ struct fib_config {
 	u32			fc_flags;
 	u32			fc_priority;
 	__be32			fc_prefsrc;
+	u32			fc_nh_id;
 	struct nlattr		*fc_mx;
 	struct rtnexthop	*fc_mp;
 	int			fc_mx_len;
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 33b0dbe84aa6..108191667531 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -671,6 +671,7 @@ const struct nla_policy rtm_ipv4_policy[RTA_MAX + 1] = {
 	[RTA_IP_PROTO]		= { .type = NLA_U8 },
 	[RTA_SPORT]		= { .type = NLA_U16 },
 	[RTA_DPORT]		= { .type = NLA_U16 },
+	[RTA_NH_ID]		= { .type = NLA_U32 },
 };
 
 int fib_gw_from_via(struct fib_config *cfg, struct nlattr *nla,
@@ -808,6 +809,18 @@ static int rtm_to_fib_config(struct net *net, struct sk_buff *skb,
 			if (err < 0)
 				goto errout;
 			break;
+		case RTA_NH_ID:
+			cfg->fc_nh_id = nla_get_u32(attr);
+			break;
+		}
+	}
+
+	if (cfg->fc_nh_id) {
+		if (cfg->fc_oif || cfg->fc_gw_family ||
+		    cfg->fc_encap || cfg->fc_mp) {
+			NL_SET_ERR_MSG(extack,
+				       "Nexthop specification and nexthop id are mutually exclusive");
+			return -EINVAL;
 		}
 	}
 
@@ -834,6 +847,12 @@ static int inet_rtm_delroute(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err < 0)
 		goto errout;
 
+	if (cfg.fc_nh_id && !nexthop_find_by_id(net, cfg.fc_nh_id)) {
+		NL_SET_ERR_MSG(extack, "Nexthop id does not exist");
+		err = -EINVAL;
+		goto errout;
+	}
+
 	tb = fib_get_table(net, cfg.fc_table);
 	if (!tb) {
 		NL_SET_ERR_MSG(extack, "FIB table does not exist");
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index afa4af1f9326..2c24d8e3b126 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -789,6 +789,12 @@ int fib_nh_match(struct fib_config *cfg, struct fib_info *fi,
 	if (cfg->fc_priority && cfg->fc_priority != fi->fib_priority)
 		return 1;
 
+	if (cfg->fc_nh_id) {
+		if (fi->nh && cfg->fc_nh_id == fi->nh->id)
+			return 0;
+		return 1;
+	}
+
 	if (cfg->fc_oif || cfg->fc_gw_family) {
 		struct fib_nh *nh = fib_info_nh(fi, 0);
 
@@ -1302,6 +1308,15 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 		goto err_inval;
 	}
 
+	if (cfg->fc_nh_id) {
+		nh = nexthop_find_by_id(net, cfg->fc_nh_id);
+		if (!nh) {
+			NL_SET_ERR_MSG(extack, "Nexthop id does not exist");
+			goto err_inval;
+		}
+		nhs = 0;
+	}
+
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
 	if (cfg->fc_mp) {
 		nhs = fib_count_nexthops(cfg->fc_mp, cfg->fc_mp_len, extack);
-- 
2.11.0

