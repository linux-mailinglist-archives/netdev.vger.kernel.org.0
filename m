Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC183ED952
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 16:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbhHPO6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 10:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbhHPO5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 10:57:52 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86239C0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 07:57:20 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id v2so16492100edq.10
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 07:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gu3qPVqazrfPsLrdaA6zNjrUNMRsdA16rRPDc2bNkUw=;
        b=FuV+Ic3USr2PZi1PnKLkMugVAAt5b6+5NCSahnq3tBRmBe/bcNvT2wFZVSDo+FzS8D
         cM5uGmbJq7o1jfdbiMacajfbGNb1f5R+Smvdjtzrv5N0gitZG+KFycHfxnQWU3eQrLRB
         6dd6lfis26okjtBo811z5I8wcdLqoIVkrBaMuwHmp8CTl0GsaIy5JWFL8X5SxWM36hqG
         o2w6cQecfztfIUAS9pd0m0xmUPAzuu2HMUj1Uq1StplPP9WUozgBq7wwXYmgcA2PMVUc
         tcnvz1IL9FhSnI2v0GR3HBY3541g2J988f3/Cjq2nyQ8wXz4b1/FSZhSZGinCEHG+XQj
         Lyww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gu3qPVqazrfPsLrdaA6zNjrUNMRsdA16rRPDc2bNkUw=;
        b=cgBstoI0sH9FHGjI5m6KKXgFVWpD6Jz+WX7XZ3QRQ4815bDO9TcRCCgDIUTrgtL68D
         2klX0GObzvMqQaEkljKqJ9J8LKbc5Uc7WAa53Z+penVf0Kc6rB7tytJyWLe25Fu+PLgE
         fv1OK6vZWlm02j6/zThMstYrtEenRj5BaZqamBHwX8CqJy2gtrXBKVpoN2xqi2k25/+1
         2jYVk78wzSKzCe6Jf2l8u+M69qTeCawiUnBYTJqncajKJwpE+rKs7+aPUSP/uI3dUtOm
         Hg6v+1303FawC0uBz5siInOzO5SYXsf2HuPrBO44qszYAvIkqTtVASXRP5cJMwCRltDv
         vR5w==
X-Gm-Message-State: AOAM5300i6ldGnzITBv7R7k1Ddzz5Bo/WA5gZsd3coGqH60phx/mvuru
        8s+j/HeNc+jp9m8l85EhiECgPVbPp7zgkgw0
X-Google-Smtp-Source: ABdhPJyfgtxQkZ0H+1ivIO/PeQ3LyKrGyE4V8lSLn5Iir/ILYPFes8w0JiOPJ/cwAAoZX6yFwfbx8w==
X-Received: by 2002:a05:6402:14d1:: with SMTP id f17mr20183567edx.167.1629125838855;
        Mon, 16 Aug 2021 07:57:18 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id t25sm4946076edi.65.2021.08.16.07.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 07:57:18 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 2/4] net: bridge: vlan: account for router port lists when notifying
Date:   Mon, 16 Aug 2021 17:57:05 +0300
Message-Id: <20210816145707.671901-3-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816145707.671901-1-razor@blackwall.org>
References: <20210816145707.671901-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

When sending a global vlan notification we should account for the number
of router ports when allocating the skb, otherwise we might end up
losing notifications.

Fixes: dc002875c22b ("net: bridge: vlan: use br_rports_fill_info() to export mcast router ports")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_mdb.c          | 30 ++++++++++++++++++++++++++++++
 net/bridge/br_private.h      |  1 +
 net/bridge/br_vlan_options.c | 17 +++++++++--------
 3 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 389ff3c1e9d9..0281453f7766 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -37,6 +37,36 @@ br_ip6_rports_get_timer(struct net_bridge_mcast_port *pmctx,
 #endif
 }
 
+static size_t __br_rports_one_size(void)
+{
+	return nla_total_size(sizeof(u32)) + /* MDBA_ROUTER_PORT */
+	       nla_total_size(sizeof(u32)) + /* MDBA_ROUTER_PATTR_TIMER */
+	       nla_total_size(sizeof(u8)) +  /* MDBA_ROUTER_PATTR_TYPE */
+	       nla_total_size(sizeof(u32)) + /* MDBA_ROUTER_PATTR_INET_TIMER */
+	       nla_total_size(sizeof(u32)) + /* MDBA_ROUTER_PATTR_INET6_TIMER */
+	       nla_total_size(sizeof(u32));  /* MDBA_ROUTER_PATTR_VID */
+}
+
+size_t br_rports_size(const struct net_bridge_mcast *brmctx)
+{
+	struct net_bridge_mcast_port *pmctx;
+	size_t size = nla_total_size(0); /* MDBA_ROUTER */
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(pmctx, &brmctx->ip4_mc_router_list,
+				 ip4_rlist)
+		size += __br_rports_one_size();
+
+#if IS_ENABLED(CONFIG_IPV6)
+	hlist_for_each_entry_rcu(pmctx, &brmctx->ip6_mc_router_list,
+				 ip6_rlist)
+		size += __br_rports_one_size();
+#endif
+	rcu_read_unlock();
+
+	return size;
+}
+
 int br_rports_fill_info(struct sk_buff *skb,
 			const struct net_bridge_mcast *brmctx)
 {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 9b1bf98a2c5a..df0fa246c80c 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -952,6 +952,7 @@ int br_multicast_dump_querier_state(struct sk_buff *skb,
 				    const struct net_bridge_mcast *brmctx,
 				    int nest_attr);
 size_t br_multicast_querier_state_size(void);
+size_t br_rports_size(const struct net_bridge_mcast *brmctx);
 
 static inline bool br_group_is_l2(const struct br_ip *group)
 {
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index 49dec53a4a74..a3b8a086284b 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -362,7 +362,7 @@ bool br_vlan_global_opts_fill(struct sk_buff *skb, u16 vid, u16 vid_range,
 	return false;
 }
 
-static size_t rtnl_vlan_global_opts_nlmsg_size(void)
+static size_t rtnl_vlan_global_opts_nlmsg_size(const struct net_bridge_vlan *v)
 {
 	return NLMSG_ALIGN(sizeof(struct br_vlan_msg))
 		+ nla_total_size(0) /* BRIDGE_VLANDB_GLOBAL_OPTIONS */
@@ -382,6 +382,8 @@ static size_t rtnl_vlan_global_opts_nlmsg_size(void)
 		+ nla_total_size(sizeof(u8)) /* BRIDGE_VLANDB_GOPTS_MCAST_QUERIER */
 		+ nla_total_size(sizeof(u8)) /* BRIDGE_VLANDB_GOPTS_MCAST_ROUTER */
 		+ br_multicast_querier_state_size() /* BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_STATE */
+		+ nla_total_size(0) /* BRIDGE_VLANDB_GOPTS_MCAST_ROUTER_PORTS */
+		+ br_rports_size(&v->br_mcast_ctx) /* BRIDGE_VLANDB_GOPTS_MCAST_ROUTER_PORTS */
 #endif
 		+ nla_total_size(sizeof(u16)); /* BRIDGE_VLANDB_GOPTS_RANGE */
 }
@@ -398,7 +400,12 @@ static void br_vlan_global_opts_notify(const struct net_bridge *br,
 	/* right now notifications are done only with rtnl held */
 	ASSERT_RTNL();
 
-	skb = nlmsg_new(rtnl_vlan_global_opts_nlmsg_size(), GFP_KERNEL);
+	/* need to find the vlan due to flags/options */
+	v = br_vlan_find(br_vlan_group(br), vid);
+	if (!v)
+		return;
+
+	skb = nlmsg_new(rtnl_vlan_global_opts_nlmsg_size(v), GFP_KERNEL);
 	if (!skb)
 		goto out_err;
 
@@ -411,11 +418,6 @@ static void br_vlan_global_opts_notify(const struct net_bridge *br,
 	bvm->family = AF_BRIDGE;
 	bvm->ifindex = br->dev->ifindex;
 
-	/* need to find the vlan due to flags/options */
-	v = br_vlan_find(br_vlan_group(br), vid);
-	if (!v)
-		goto out_kfree;
-
 	if (!br_vlan_global_opts_fill(skb, vid, vid_range, v))
 		goto out_err;
 
@@ -425,7 +427,6 @@ static void br_vlan_global_opts_notify(const struct net_bridge *br,
 
 out_err:
 	rtnl_set_sk_err(dev_net(br->dev), RTNLGRP_BRVLAN, err);
-out_kfree:
 	kfree_skb(skb);
 }
 
-- 
2.31.1

