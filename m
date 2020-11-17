Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23FE2B7005
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbgKQUZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgKQUZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:25:53 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4957C0613CF
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 12:25:52 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id p22so4703605wmg.3
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 12:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=dA5ORCixvDnHt8lZ+8efwT8Ww5B3A4OyTdr+7FHfaeI=;
        b=ehP1Kk8GttGRKsMhjNLhnvpebYQvBh4AcPNTVW5qv9GhaaRWS4Q/a0c+m3pAGJUjf1
         S3Gf+RPEvWq99E+cmbCfIXFps3WWrAfKbgTnV0XF1ZOBE259TTk5dsFjX0LJ2+ghwNSo
         y9/NgmtSrypzcnSPlBxzGtUm4T8fi1AcTvOuLsRkTrgaL25eXp4Yt+Fnj3uBJYpdAn5b
         z9yUft7fqN7tzTEMPybLxKMm43bMBDh4df7Sw3gUwv4HvHk7YwuaECI4DeVq9lkZlfE/
         xNhWZ6fUcipIHueGax4vY/wlCmawTdXzdf9EF9RknjZLKZ2syUXmRlNX8ecJVzYJHdFP
         UK6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=dA5ORCixvDnHt8lZ+8efwT8Ww5B3A4OyTdr+7FHfaeI=;
        b=MxAFW1QpZRh2h9IwludJdKIKKB1Xxrb6c5zE8zvyDCzIYGzLdSmLZG4VnLKVDZKHSb
         AfwsJ/Jy2zj+6eapmc//1/H3reIoYNOBnvR0BPes9o1YTvOVIn8hT91McpWC/vxMAfpA
         TMCDi+7/GdReQDyaO4VvpWtdLc6vriTdaUMWg8rJ5RkR4P1bUUyfq6Jw2C1LM5lWAfFV
         wjIYZthaMJv0Y5zayxq0jncyzv/MgnetauOPMzBDdePzt0rwtu0ciCQeFPj0FlECt72J
         Rgw61b/VD9RIns1ZrGE7X/Uq45ayPKMoo6PDmc3HCE037odGAavnrAQVWTYiNdb/2ZgD
         zusQ==
X-Gm-Message-State: AOAM531JUheOaa0a72IL4ldvKwsjtOIMI6PE2+UvlhvsbHi0Igvr3ENC
        LRcRPBsNxdnj2dIub08dwHL5CvHHtYysrg==
X-Google-Smtp-Source: ABdhPJy9ukEa00ey3D0FGlDYRZUZTpvTS/i2DYSPoFS4OHQigWofzDjPQ/ajwr0lNM0a74h6m80pyQ==
X-Received: by 2002:a1c:230e:: with SMTP id j14mr799504wmj.187.1605644751300;
        Tue, 17 Nov 2020 12:25:51 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:44e4:5b02:13:99de? (p200300ea8f23280044e45b02001399de.dip0.t-ipconnect.de. [2003:ea:8f23:2800:44e4:5b02:13:99de])
        by smtp.googlemail.com with ESMTPSA id i16sm29923191wru.92.2020.11.17.12.25.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2020 12:25:50 -0800 (PST)
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     bridge@lists.linux-foundation.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: bridge: replace struct br_vlan_stats with
 pcpu_sw_netstats
Message-ID: <04d25c3d-c5f6-3611-6d37-c2f40243dae2@gmail.com>
Date:   Tue, 17 Nov 2020 21:25:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Struct br_vlan_stats duplicates pcpu_sw_netstats (apart from
br_vlan_stats not defining an alignment requirement), therefore
switch to using the latter one.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 net/bridge/br_netlink.c |  2 +-
 net/bridge/br_private.h | 14 +++-----------
 net/bridge/br_vlan.c    | 15 ++++++++-------
 3 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 6952d4852..49700ce0e 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1724,7 +1724,7 @@ static int br_fill_linkxstats(struct sk_buff *skb,
 		pvid = br_get_pvid(vg);
 		list_for_each_entry(v, &vg->vlan_list, vlist) {
 			struct bridge_vlan_xstats vxi;
-			struct br_vlan_stats stats;
+			struct pcpu_sw_netstats stats;
 
 			if (++vl_idx < *prividx)
 				continue;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 9a99af59b..d538ccec0 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -89,14 +89,6 @@ struct bridge_mcast_stats {
 };
 #endif
 
-struct br_vlan_stats {
-	u64 rx_bytes;
-	u64 rx_packets;
-	u64 tx_bytes;
-	u64 tx_packets;
-	struct u64_stats_sync syncp;
-};
-
 struct br_tunnel_info {
 	__be64			tunnel_id;
 	struct metadata_dst	*tunnel_dst;
@@ -137,7 +129,7 @@ struct net_bridge_vlan {
 	u16				flags;
 	u16				priv_flags;
 	u8				state;
-	struct br_vlan_stats __percpu	*stats;
+	struct pcpu_sw_netstats __percpu *stats;
 	union {
 		struct net_bridge	*br;
 		struct net_bridge_port	*port;
@@ -1092,7 +1084,7 @@ void nbp_vlan_flush(struct net_bridge_port *port);
 int nbp_vlan_init(struct net_bridge_port *port, struct netlink_ext_ack *extack);
 int nbp_get_num_vlan_infos(struct net_bridge_port *p, u32 filter_mask);
 void br_vlan_get_stats(const struct net_bridge_vlan *v,
-		       struct br_vlan_stats *stats);
+		       struct pcpu_sw_netstats *stats);
 void br_vlan_port_event(struct net_bridge_port *p, unsigned long event);
 int br_vlan_bridge_event(struct net_device *dev, unsigned long event,
 			 void *ptr);
@@ -1288,7 +1280,7 @@ static inline struct net_bridge_vlan_group *nbp_vlan_group_rcu(
 }
 
 static inline void br_vlan_get_stats(const struct net_bridge_vlan *v,
-				     struct br_vlan_stats *stats)
+				     struct pcpu_sw_netstats *stats)
 {
 }
 
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 3e493eb85..11f54a7c0 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -270,7 +270,8 @@ static int __vlan_add(struct net_bridge_vlan *v, u16 flags,
 			goto out_filt;
 		v->brvlan = masterv;
 		if (br_opt_get(br, BROPT_VLAN_STATS_PER_PORT)) {
-			v->stats = netdev_alloc_pcpu_stats(struct br_vlan_stats);
+			v->stats =
+			     netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
 			if (!v->stats) {
 				err = -ENOMEM;
 				goto out_filt;
@@ -421,7 +422,7 @@ struct sk_buff *br_handle_vlan(struct net_bridge *br,
 			       struct net_bridge_vlan_group *vg,
 			       struct sk_buff *skb)
 {
-	struct br_vlan_stats *stats;
+	struct pcpu_sw_netstats *stats;
 	struct net_bridge_vlan *v;
 	u16 vid;
 
@@ -474,7 +475,7 @@ static bool __allowed_ingress(const struct net_bridge *br,
 			      struct sk_buff *skb, u16 *vid,
 			      u8 *state)
 {
-	struct br_vlan_stats *stats;
+	struct pcpu_sw_netstats *stats;
 	struct net_bridge_vlan *v;
 	bool tagged;
 
@@ -708,7 +709,7 @@ int br_vlan_add(struct net_bridge *br, u16 vid, u16 flags, bool *changed,
 	if (!vlan)
 		return -ENOMEM;
 
-	vlan->stats = netdev_alloc_pcpu_stats(struct br_vlan_stats);
+	vlan->stats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
 	if (!vlan->stats) {
 		kfree(vlan);
 		return -ENOMEM;
@@ -1262,14 +1263,14 @@ void nbp_vlan_flush(struct net_bridge_port *port)
 }
 
 void br_vlan_get_stats(const struct net_bridge_vlan *v,
-		       struct br_vlan_stats *stats)
+		       struct pcpu_sw_netstats *stats)
 {
 	int i;
 
 	memset(stats, 0, sizeof(*stats));
 	for_each_possible_cpu(i) {
 		u64 rxpackets, rxbytes, txpackets, txbytes;
-		struct br_vlan_stats *cpu_stats;
+		struct pcpu_sw_netstats *cpu_stats;
 		unsigned int start;
 
 		cpu_stats = per_cpu_ptr(v->stats, i);
@@ -1585,7 +1586,7 @@ void br_vlan_port_event(struct net_bridge_port *p, unsigned long event)
 static bool br_vlan_stats_fill(struct sk_buff *skb,
 			       const struct net_bridge_vlan *v)
 {
-	struct br_vlan_stats stats;
+	struct pcpu_sw_netstats stats;
 	struct nlattr *nest;
 
 	nest = nla_nest_start(skb, BRIDGE_VLANDB_ENTRY_STATS);
-- 
2.29.2

