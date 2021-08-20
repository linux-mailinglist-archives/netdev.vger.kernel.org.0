Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6293F2C60
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 14:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240403AbhHTMok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 08:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240375AbhHTMok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 08:44:40 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088A5C061575
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 05:44:02 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id n12so13823873edx.8
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 05:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BSvSK2EMVTyxOMr00jtLnQ1ikGyqchiRiv43Dyt1avM=;
        b=KEsLk3DVjSha4HWbKjFSYT2KqIpjJ91lGWN3qrcOPxzwK68jjeY7yD+f1s8Kz6B/Kj
         aXAwkEHGGR2aAlSZuaJPfH21UkGH1C5CNo30xWV3IXFXR2XHkdlZI9lx/0ysEpEtm50o
         UEukkY7dA9yuNMbErStkLE22KBNBAs+ySj5kB4bdRuLmmxfNFgYRgbxxk3w4mGdMufA/
         w50nYGzspJC2CDwGT0eLjuOJq2QlxGpiibo/zOlSB0815dzOUohYovgErMojXGWHq1MJ
         vXaJSZqpNgDf2VWrKFC9MIf//CvCadax7tnkr+SEJQ0zjiJ9PugOT6YmbbeRqwsr4oE6
         qm3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BSvSK2EMVTyxOMr00jtLnQ1ikGyqchiRiv43Dyt1avM=;
        b=Tmbh/o0zau66E2mXPfO4cdPDMKnIfH7ucpZ9rrvrx35W9F4m0xgVjixgpyHiP6BX8+
         P3aH47HXzFINh1pSj8nb54jzy4HRDBqVf4n2f8o4OuSGf5V0JratdWASUsIJ260pzcO8
         yRrv3eX2/jGUdriK8kKlQbEPCKGVAKOVdCMT3/OSmX14hap/70z93FZq0/tOuiFHtw4Z
         PAY3sfTgQasvBycFQYMIv5Xo8QX3+ZExNDxBx/3+PfQeLPk4U6cT6lbT4vtjM9ksZ5Tg
         9+5Kq6tYv3orme4Fe3iu5JBCwqozVTiKCzamB1jWrCzQvVd/R+3H3LY/bLWL+I+9UH6S
         +X7A==
X-Gm-Message-State: AOAM5333MURJypZq/tGi4b2uUFKEsKIEgI0+eqvRNdt0/eqfqAXwKl9D
        fUWIgh6OvyaM1hPfZ7cxKeAaq6qlYF04CbwZ
X-Google-Smtp-Source: ABdhPJwWVGgIs0ZLYyotXjD0ItAnDDLywudA3DCVB2fIA3c/1u82W83wMjjo9QJ61Vc5TDN8TFSpUA==
X-Received: by 2002:a05:6402:384:: with SMTP id o4mr22653524edv.128.1629463440318;
        Fri, 20 Aug 2021 05:44:00 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id ci19sm676627ejc.109.2021.08.20.05.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 05:43:59 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 2/2] net: bridge: vlan: convert mcast router global option to per-vlan entry
Date:   Fri, 20 Aug 2021 15:42:55 +0300
Message-Id: <20210820124255.1465672-3-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210820124255.1465672-1-razor@blackwall.org>
References: <20210820124255.1465672-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

The per-vlan router option controls the port/vlan and host vlan entries'
mcast router config. The global option controlled only the host vlan
config, but that is unnecessary and incosistent as it's not really a
global vlan option, but rather bridge option to control host router
config, so convert BRIDGE_VLANDB_GOPTS_MCAST_ROUTER to
BRIDGE_VLANDB_ENTRY_MCAST_ROUTER which can be used to control both host
vlan and port vlan mcast router config.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/uapi/linux/if_bridge.h |  2 +-
 net/bridge/br_multicast.c      | 13 +++++++++
 net/bridge/br_private.h        | 15 ++++++++++
 net/bridge/br_vlan.c           |  1 +
 net/bridge/br_vlan_options.c   | 51 ++++++++++++++++++++++------------
 5 files changed, 63 insertions(+), 19 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index f71a81fdbbc6..2711c3522010 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -506,6 +506,7 @@ enum {
 	BRIDGE_VLANDB_ENTRY_STATE,
 	BRIDGE_VLANDB_ENTRY_TUNNEL_INFO,
 	BRIDGE_VLANDB_ENTRY_STATS,
+	BRIDGE_VLANDB_ENTRY_MCAST_ROUTER,
 	__BRIDGE_VLANDB_ENTRY_MAX,
 };
 #define BRIDGE_VLANDB_ENTRY_MAX (__BRIDGE_VLANDB_ENTRY_MAX - 1)
@@ -561,7 +562,6 @@ enum {
 	BRIDGE_VLANDB_GOPTS_MCAST_QUERY_RESPONSE_INTVL,
 	BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_INTVL,
 	BRIDGE_VLANDB_GOPTS_MCAST_QUERIER,
-	BRIDGE_VLANDB_GOPTS_MCAST_ROUTER,
 	BRIDGE_VLANDB_GOPTS_MCAST_ROUTER_PORTS,
 	BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_STATE,
 	__BRIDGE_VLANDB_GOPTS_MAX
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index be9d1376e249..2c437d4bf632 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -4310,6 +4310,19 @@ int br_multicast_set_port_router(struct net_bridge_mcast_port *pmctx,
 	return err;
 }
 
+int br_multicast_set_vlan_router(struct net_bridge_vlan *v, u8 mcast_router)
+{
+	int err;
+
+	if (br_vlan_is_master(v))
+		err = br_multicast_set_router(&v->br_mcast_ctx, mcast_router);
+	else
+		err = br_multicast_set_port_router(&v->port_mcast_ctx,
+						   mcast_router);
+
+	return err;
+}
+
 static void br_multicast_start_querier(struct net_bridge_mcast *brmctx,
 				       struct bridge_mcast_own_query *query)
 {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index fcc0fcf44a95..b4cef3a97f12 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -676,6 +676,20 @@ static inline bool br_vlan_valid_range(const struct bridge_vlan_info *cur,
 	return true;
 }
 
+static inline u8 br_vlan_multicast_router(const struct net_bridge_vlan *v)
+{
+	u8 mcast_router = MDB_RTR_TYPE_DISABLED;
+
+#ifdef CONFIG_BRIDGE_IGMP_SNOOPING
+	if (!br_vlan_is_master(v))
+		mcast_router = v->port_mcast_ctx.multicast_router;
+	else
+		mcast_router = v->br_mcast_ctx.multicast_router;
+#endif
+
+	return mcast_router;
+}
+
 static inline int br_afspec_cmd_to_rtm(int cmd)
 {
 	switch (cmd) {
@@ -881,6 +895,7 @@ void br_multicast_flood(struct net_bridge_mdb_entry *mdst, struct sk_buff *skb,
 int br_multicast_set_router(struct net_bridge_mcast *brmctx, unsigned long val);
 int br_multicast_set_port_router(struct net_bridge_mcast_port *pmctx,
 				 unsigned long val);
+int br_multicast_set_vlan_router(struct net_bridge_vlan *v, u8 mcast_router);
 int br_multicast_toggle(struct net_bridge *br, unsigned long val,
 			struct netlink_ext_ack *extack);
 int br_multicast_set_querier(struct net_bridge_mcast *brmctx, unsigned long val);
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index e25e288e7a85..19f65ab91a02 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -2136,6 +2136,7 @@ static const struct nla_policy br_vlan_db_policy[BRIDGE_VLANDB_ENTRY_MAX + 1] =
 	[BRIDGE_VLANDB_ENTRY_RANGE]	= { .type = NLA_U16 },
 	[BRIDGE_VLANDB_ENTRY_STATE]	= { .type = NLA_U8 },
 	[BRIDGE_VLANDB_ENTRY_TUNNEL_INFO] = { .type = NLA_NESTED },
+	[BRIDGE_VLANDB_ENTRY_MCAST_ROUTER]	= { .type = NLA_U8 },
 };
 
 static int br_vlan_rtm_process_one(struct net_device *dev,
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index a3b8a086284b..8ffd4ed2563c 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -40,22 +40,38 @@ static bool __vlan_tun_can_enter_range(const struct net_bridge_vlan *v_curr,
 bool br_vlan_opts_eq_range(const struct net_bridge_vlan *v_curr,
 			   const struct net_bridge_vlan *range_end)
 {
+	u8 range_mc_rtr = br_vlan_multicast_router(range_end);
+	u8 curr_mc_rtr = br_vlan_multicast_router(v_curr);
+
 	return v_curr->state == range_end->state &&
-	       __vlan_tun_can_enter_range(v_curr, range_end);
+	       __vlan_tun_can_enter_range(v_curr, range_end) &&
+	       curr_mc_rtr == range_mc_rtr;
 }
 
 bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v)
 {
-	return !nla_put_u8(skb, BRIDGE_VLANDB_ENTRY_STATE,
-			   br_vlan_get_state(v)) &&
-	       __vlan_tun_put(skb, v);
+	if (nla_put_u8(skb, BRIDGE_VLANDB_ENTRY_STATE, br_vlan_get_state(v)) ||
+	    !__vlan_tun_put(skb, v))
+		return false;
+
+#ifdef CONFIG_BRIDGE_IGMP_SNOOPING
+	if (nla_put_u8(skb, BRIDGE_VLANDB_ENTRY_MCAST_ROUTER,
+		       br_vlan_multicast_router(v)))
+		return false;
+#endif
+
+	return true;
 }
 
 size_t br_vlan_opts_nl_size(void)
 {
 	return nla_total_size(sizeof(u8)) /* BRIDGE_VLANDB_ENTRY_STATE */
 	       + nla_total_size(0) /* BRIDGE_VLANDB_ENTRY_TUNNEL_INFO */
-	       + nla_total_size(sizeof(u32)); /* BRIDGE_VLANDB_TINFO_ID */
+	       + nla_total_size(sizeof(u32)) /* BRIDGE_VLANDB_TINFO_ID */
+#ifdef CONFIG_BRIDGE_IGMP_SNOOPING
+	       + nla_total_size(sizeof(u8)) /* BRIDGE_VLANDB_ENTRY_MCAST_ROUTER */
+#endif
+	       + 0;
 }
 
 static int br_vlan_modify_state(struct net_bridge_vlan_group *vg,
@@ -181,6 +197,18 @@ static int br_vlan_process_one_opts(const struct net_bridge *br,
 			return err;
 	}
 
+#ifdef CONFIG_BRIDGE_IGMP_SNOOPING
+	if (tb[BRIDGE_VLANDB_ENTRY_MCAST_ROUTER]) {
+		u8 val;
+
+		val = nla_get_u8(tb[BRIDGE_VLANDB_ENTRY_MCAST_ROUTER]);
+		err = br_multicast_set_vlan_router(v, val);
+		if (err)
+			return err;
+		*changed = true;
+	}
+#endif
+
 	return 0;
 }
 
@@ -298,8 +326,6 @@ bool br_vlan_global_opts_fill(struct sk_buff *skb, u16 vid, u16 vid_range,
 			v_opts->br_mcast_ctx.multicast_startup_query_count) ||
 	    nla_put_u8(skb, BRIDGE_VLANDB_GOPTS_MCAST_QUERIER,
 		       v_opts->br_mcast_ctx.multicast_querier) ||
-	    nla_put_u8(skb, BRIDGE_VLANDB_GOPTS_MCAST_ROUTER,
-		       v_opts->br_mcast_ctx.multicast_router) ||
 	    br_multicast_dump_querier_state(skb, &v_opts->br_mcast_ctx,
 					    BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_STATE))
 		goto out_err;
@@ -380,7 +406,6 @@ static size_t rtnl_vlan_global_opts_nlmsg_size(const struct net_bridge_vlan *v)
 		+ nla_total_size(sizeof(u64)) /* BRIDGE_VLANDB_GOPTS_MCAST_QUERY_RESPONSE_INTVL */
 		+ nla_total_size(sizeof(u64)) /* BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_INTVL */
 		+ nla_total_size(sizeof(u8)) /* BRIDGE_VLANDB_GOPTS_MCAST_QUERIER */
-		+ nla_total_size(sizeof(u8)) /* BRIDGE_VLANDB_GOPTS_MCAST_ROUTER */
 		+ br_multicast_querier_state_size() /* BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_STATE */
 		+ nla_total_size(0) /* BRIDGE_VLANDB_GOPTS_MCAST_ROUTER_PORTS */
 		+ br_rports_size(&v->br_mcast_ctx) /* BRIDGE_VLANDB_GOPTS_MCAST_ROUTER_PORTS */
@@ -522,15 +547,6 @@ static int br_vlan_process_global_one_opts(const struct net_bridge *br,
 			return err;
 		*changed = true;
 	}
-	if (tb[BRIDGE_VLANDB_GOPTS_MCAST_ROUTER]) {
-		u8 val;
-
-		val = nla_get_u8(tb[BRIDGE_VLANDB_GOPTS_MCAST_ROUTER]);
-		err = br_multicast_set_router(&v->br_mcast_ctx, val);
-		if (err)
-			return err;
-		*changed = true;
-	}
 #if IS_ENABLED(CONFIG_IPV6)
 	if (tb[BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION]) {
 		u8 ver;
@@ -554,7 +570,6 @@ static const struct nla_policy br_vlan_db_gpol[BRIDGE_VLANDB_GOPTS_MAX + 1] = {
 	[BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION]	= { .type = NLA_U8 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_QUERY_INTVL]	= { .type = NLA_U64 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_QUERIER]	= { .type = NLA_U8 },
-	[BRIDGE_VLANDB_GOPTS_MCAST_ROUTER]	= { .type = NLA_U8 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_IGMP_VERSION]	= { .type = NLA_U8 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_CNT]	= { .type = NLA_U32 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_CNT]	= { .type = NLA_U32 },
-- 
2.31.1

