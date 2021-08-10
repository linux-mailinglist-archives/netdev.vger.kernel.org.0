Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4433E7C50
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 17:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243342AbhHJPbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 11:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243105AbhHJPaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 11:30:24 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51563C0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 08:30:01 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id w21-20020a7bc1150000b02902e69ba66ce6so2825402wmi.1
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 08:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0U8ioPcKzi2jt/DpEgccopIlJARByWOltx48kXuPcYI=;
        b=kh5L/JWBjVVX4qw5w0ujY9XuKUAA07r7Ic8m9ki46oKaf5YlGdAEMySZlKZgUbRi3f
         eLwBWw9M4TM+6HB+b8qpu0bC6jQgO8MWZqsbQM2mgBa9ZLfGx+98t07ah13JqfnuyR2r
         Lb9YtCbNJD1sDLzN4hcoTjRZZ8lsqRuvLhSNja9Ny3ZAVd9jilDt96cBJfMTw+KL6n0g
         EOY5zVt36u07rbleTpuvtCD6cb0M5HEFFgo9r1WUQarzEiTZCF3RFf6hXKF15MXhYcSS
         +hl4SO7x1yCOuCNNi7dkHVDY+KO4KR+zoAUSoHoH1ujbK/9YZ3BcoBwSNo6m8znFUO1J
         M5Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0U8ioPcKzi2jt/DpEgccopIlJARByWOltx48kXuPcYI=;
        b=YYHiKkFW+MMKVPhPyy+eugNIxtBRCgVZ+amXmNPxcgeP4YZg4pYqxnPBAOu8L1JGkO
         zp6kuvOBq/gpgSbUaXUqh21cxrJnUY7UEDo/yzsBn7h6Ks9JYMp8I6CYBJbxBEspRkAt
         KsSFfAWsAGfupZSYDEFWMtUhsxwnsjNgCNyKabdam2PqKgxxvU6JvQq2ow/xDJcqnahh
         1NAEd+ZoelzYweX5fyufmfpeDebQC57OCEZuYFAH303Zyr1MnRThSnH0itgo8GgKhGQL
         9TSlZEK8b/TU/C7MhtCMco4o5PqDYnUzreTn0QJ5rldQvBFrbUJlhygpe0O/MHOwbQ5W
         rHBw==
X-Gm-Message-State: AOAM530sTHVRu4zWJlfmzK69cj2qU5V2F+qwupJUGz3bUC413gSxNE+a
        BMozmEpLdWGaG7y/Fwm/rE1Aj4/4owCXbx3X
X-Google-Smtp-Source: ABdhPJz40ns1utPPP7KryyUQIlGnjnhCNIYvVZBTqha+LY0zDCnYn3WSnzqmu42ZcLbEGELUPqpxVg==
X-Received: by 2002:a05:600c:4eca:: with SMTP id g10mr22571013wmq.16.1628609399520;
        Tue, 10 Aug 2021 08:29:59 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f15sm22848219wrp.12.2021.08.10.08.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 08:29:59 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 15/15] net: bridge: vlan: use br_rports_fill_info() to export mcast router ports
Date:   Tue, 10 Aug 2021 18:29:33 +0300
Message-Id: <20210810152933.178325-16-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810152933.178325-1-razor@blackwall.org>
References: <20210810152933.178325-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Embed the standard multicast router port export by br_rports_fill_info()
into a new global vlan attribute BRIDGE_VLANDB_GOPTS_MCAST_ROUTER_PORTS.
In order to have the same format for the global bridge mcast context and
the per-vlan mcast context we need a double-nesting:
 - BRIDGE_VLANDB_GOPTS_MCAST_ROUTER_PORTS
   - MDBA_ROUTER

Currently we don't compare router lists, if any router port exists in
the bridge mcast contexts we consider their option sets as different and
export them separately.

In addition we export the router port vlan id when dumping similar to
the router port notification format.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/br_mdb.c            | 17 ++++-------------
 net/bridge/br_private.h        | 15 +++++++++++++++
 net/bridge/br_vlan_options.c   | 18 ++++++++++++++++++
 4 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 716ce30b3ca8..4a57d063768d 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -562,6 +562,7 @@ enum {
 	BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_INTVL,
 	BRIDGE_VLANDB_GOPTS_MCAST_QUERIER,
 	BRIDGE_VLANDB_GOPTS_MCAST_ROUTER,
+	BRIDGE_VLANDB_GOPTS_MCAST_ROUTER_PORTS,
 	__BRIDGE_VLANDB_GOPTS_MAX
 };
 #define BRIDGE_VLANDB_GOPTS_MAX (__BRIDGE_VLANDB_GOPTS_MAX - 1)
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 7c16e2c76220..389ff3c1e9d9 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -16,16 +16,6 @@
 
 #include "br_private.h"
 
-static bool br_rports_have_mc_router(const struct net_bridge_mcast *brmctx)
-{
-#if IS_ENABLED(CONFIG_IPV6)
-	return !hlist_empty(&brmctx->ip4_mc_router_list) ||
-	       !hlist_empty(&brmctx->ip6_mc_router_list);
-#else
-	return !hlist_empty(&brmctx->ip4_mc_router_list);
-#endif
-}
-
 static bool
 br_ip4_rports_get_timer(struct net_bridge_mcast_port *pmctx,
 			unsigned long *timer)
@@ -47,8 +37,8 @@ br_ip6_rports_get_timer(struct net_bridge_mcast_port *pmctx,
 #endif
 }
 
-static int br_rports_fill_info(struct sk_buff *skb,
-			       const struct net_bridge_mcast *brmctx)
+int br_rports_fill_info(struct sk_buff *skb,
+			const struct net_bridge_mcast *brmctx)
 {
 	u16 vid = brmctx->vlan ? brmctx->vlan->vid : 0;
 	bool have_ip4_mc_rtr, have_ip6_mc_rtr;
@@ -97,7 +87,8 @@ static int br_rports_fill_info(struct sk_buff *skb,
 				 ip4_timer)) ||
 		    (have_ip6_mc_rtr &&
 		     nla_put_u32(skb, MDBA_ROUTER_PATTR_INET6_TIMER,
-				 ip6_timer))) {
+				 ip6_timer)) ||
+		    (vid && nla_put_u16(skb, MDBA_ROUTER_PATTR_VID, vid))) {
 			nla_nest_cancel(skb, port_nest);
 			goto fail;
 		}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index f5af6b56be8f..6f5106ab6f20 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -958,6 +958,8 @@ bool br_multicast_toggle_global_vlan(struct net_bridge_vlan *vlan, bool on);
 int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
 		  const void *ctx, bool adding, struct notifier_block *nb,
 		  struct netlink_ext_ack *extack);
+int br_rports_fill_info(struct sk_buff *skb,
+			const struct net_bridge_mcast *brmctx);
 
 static inline bool br_group_is_l2(const struct br_ip *group)
 {
@@ -1181,6 +1183,17 @@ br_multicast_port_ctx_state_stopped(const struct net_bridge_mcast_port *pmctx)
 		pmctx->vlan->state == BR_STATE_BLOCKING);
 }
 
+static inline bool
+br_rports_have_mc_router(const struct net_bridge_mcast *brmctx)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	return !hlist_empty(&brmctx->ip4_mc_router_list) ||
+	       !hlist_empty(&brmctx->ip6_mc_router_list);
+#else
+	return !hlist_empty(&brmctx->ip4_mc_router_list);
+#endif
+}
+
 static inline bool
 br_multicast_ctx_options_equal(const struct net_bridge_mcast *brmctx1,
 			       const struct net_bridge_mcast *brmctx2)
@@ -1205,6 +1218,8 @@ br_multicast_ctx_options_equal(const struct net_bridge_mcast *brmctx1,
 	       brmctx2->multicast_startup_query_interval &&
 	       brmctx1->multicast_querier == brmctx2->multicast_querier &&
 	       brmctx1->multicast_router == brmctx2->multicast_router &&
+	       !br_rports_have_mc_router(brmctx1) &&
+	       !br_rports_have_mc_router(brmctx2) &&
 #if IS_ENABLED(CONFIG_IPV6)
 	       brmctx1->multicast_mld_version ==
 	       brmctx2->multicast_mld_version &&
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index 6ba45b73931f..b4fd5fa441b7 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -272,6 +272,7 @@ bool br_vlan_global_opts_can_enter_range(const struct net_bridge_vlan *v_curr,
 bool br_vlan_global_opts_fill(struct sk_buff *skb, u16 vid, u16 vid_range,
 			      const struct net_bridge_vlan *v_opts)
 {
+	struct nlattr *nest2 __maybe_unused;
 	u64 clockval __maybe_unused;
 	struct nlattr *nest;
 
@@ -326,6 +327,23 @@ bool br_vlan_global_opts_fill(struct sk_buff *skb, u16 vid, u16 vid_range,
 			      clockval, BRIDGE_VLANDB_GOPTS_PAD))
 		goto out_err;
 
+	if (br_rports_have_mc_router(&v_opts->br_mcast_ctx)) {
+		nest2 = nla_nest_start(skb,
+				       BRIDGE_VLANDB_GOPTS_MCAST_ROUTER_PORTS);
+		if (!nest2)
+			goto out_err;
+
+		rcu_read_lock();
+		if (br_rports_fill_info(skb, &v_opts->br_mcast_ctx)) {
+			rcu_read_unlock();
+			nla_nest_cancel(skb, nest2);
+			goto out_err;
+		}
+		rcu_read_unlock();
+
+		nla_nest_end(skb, nest2);
+	}
+
 #if IS_ENABLED(CONFIG_IPV6)
 	if (nla_put_u8(skb, BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION,
 		       v_opts->br_mcast_ctx.multicast_mld_version))
-- 
2.31.1

