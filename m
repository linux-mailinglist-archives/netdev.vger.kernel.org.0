Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 556A538E89
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 17:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729839AbfFGPKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 11:10:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729574AbfFGPJp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 11:09:45 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60DF021537;
        Fri,  7 Jun 2019 15:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559920185;
        bh=FKPXAyqAf0Dd56JKUk7zWEyhIQwH60p6mKcJvEoFwc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IqKj86/UjI+vNELRLCiH5izwBJkuR3d5ajR8Dm++PYSArikc+0nsr7isKXl2AbxEa
         VHfx3czt2/KmrLkIcf1Ffdr7J3Gv+6yyJAgvAquM+OODLaRW9hAkMJJfcJ49lKhu+A
         3fDY+yOL2e/M5zgROg/naXj3qG4Ea+cl/p74V6CU=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 net-next 11/20] ipv4: Allow routes to use nexthop objects
Date:   Fri,  7 Jun 2019 08:09:32 -0700
Message-Id: <20190607150941.11371-12-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190607150941.11371-1-dsahern@kernel.org>
References: <20190607150941.11371-1-dsahern@kernel.org>
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
index 071d280de389..74891397f694 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -44,6 +44,7 @@ struct fib_config {
 	u32			fc_flags;
 	u32			fc_priority;
 	__be32			fc_prefsrc;
+	u32			fc_nh_id;
 	struct nlattr		*fc_mx;
 	struct rtnexthop	*fc_mp;
 	int			fc_mx_len;
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 5ea2750982f2..b8cbe50abead 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -675,6 +675,7 @@ const struct nla_policy rtm_ipv4_policy[RTA_MAX + 1] = {
 	[RTA_IP_PROTO]		= { .type = NLA_U8 },
 	[RTA_SPORT]		= { .type = NLA_U16 },
 	[RTA_DPORT]		= { .type = NLA_U16 },
+	[RTA_NH_ID]		= { .type = NLA_U32 },
 };
 
 int fib_gw_from_via(struct fib_config *cfg, struct nlattr *nla,
@@ -812,6 +813,18 @@ static int rtm_to_fib_config(struct net *net, struct sk_buff *skb,
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
 
@@ -838,6 +851,12 @@ static int inet_rtm_delroute(struct sk_buff *skb, struct nlmsghdr *nlh,
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
index 4282bdcacf96..3e0b7c15e1fa 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -793,6 +793,12 @@ int fib_nh_match(struct fib_config *cfg, struct fib_info *fi,
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
 
@@ -1306,6 +1312,15 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
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

