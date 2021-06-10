Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D403A2B04
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 14:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhFJMHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 08:07:19 -0400
Received: from mail-ed1-f43.google.com ([209.85.208.43]:42592 "EHLO
        mail-ed1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbhFJMHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 08:07:14 -0400
Received: by mail-ed1-f43.google.com with SMTP id i13so32712522edb.9
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 05:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uyvb0KXxpyWq3qgClhEraKLbShn/5Bbg2WwPvVCXfZI=;
        b=R2QTvvFGONS5s4TaVG6tqiMLak2GgyzRPyzHUQhEQBzKk6CebQa1MVhWLTdmy7awPo
         oXL3PmVuZBozjOz1QYWelanvjWtEGY1Vw/nhGnarHMPIkSulq9GZxupTKfdjClHwuxJV
         SdRpGGkT62YSfvM7WYqSmOqwLgSozS5midYQAPk3Y8jNLz9WJs/JIyh1W9Lwinb51oYK
         EY2xfhbcB1mOvPVJ9bY0V/bU6WII+SzMEv1VbYDtv+RtMW5+9Mywh6nILtTbrFGVeOj4
         qay4W7+5ll/pFZNTTvCskx/klF+QVe6jgyTgiiKRgZpPwHtAzWv7MFc/F71g3OdSsNpY
         KyVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uyvb0KXxpyWq3qgClhEraKLbShn/5Bbg2WwPvVCXfZI=;
        b=NaJlXayY2dnsrX1lilSORUDkiyPrW9wjAjFiI5U4Q2GPlDRYr5VergO9hdYyESJBXw
         +d+vm8+8AhgK9dh+HzOYcyzKwWuK558sLkdLBiCLFmwgl1M5Kv6mVuMBUd0nACBu/OE6
         lEAu0SacGWndQVMj7o22xkxia6EIS3lHEg+xH35nVIwZEO0ONUxsdqyqT8FVzgYVFfa8
         RxAKqbLBHePhZFEGZWP9mIoUszRHlOkrq5ejIBEbQeavFNjDQXvqIRtpOMHtu0/ELiqJ
         XPJEVYhffdMLVhPIFQo5/03OJKpq3bdIx+FvDO4vmkvCMTZIFGhyTDQR+4MpQa01nVX4
         7Kmw==
X-Gm-Message-State: AOAM532Mv4q/RHqhte1E6fsLUSrsQcejWkzLUrowodFrDkmXxnBve5uf
        u4lulIjOK9V6eiDfEF4FVrqmDaHxHR4txxdHTPc=
X-Google-Smtp-Source: ABdhPJztlClfs8oow/rAkwsgfiXH4D4o4+lQ7cHv2vO45L2aVCUEctZpKCYGdI+ZBZQQqP6QWzXNtg==
X-Received: by 2002:a05:6402:1a:: with SMTP id d26mr4397408edu.105.1623326657676;
        Thu, 10 Jun 2021 05:04:17 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id e18sm967193ejh.64.2021.06.10.05.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 05:04:17 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        stable@vger.kernel.org
Subject: [PATCH net 1/2 v2] net: bridge: fix vlan tunnel dst null pointer dereference
Date:   Thu, 10 Jun 2021 15:04:10 +0300
Message-Id: <20210610120411.128339-2-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610120411.128339-1-razor@blackwall.org>
References: <20210610120411.128339-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

This patch fixes a tunnel_dst null pointer dereference due to lockless
access in the tunnel egress path. When deleting a vlan tunnel the
tunnel_dst pointer is set to NULL without waiting a grace period (i.e.
while it's still usable) and packets egressing are dereferencing it
without checking. Use READ/WRITE_ONCE to annotate the lockless use of
tunnel_id, use RCU for accessing tunnel_dst and make sure it is read
only once and checked in the egress path. The dst is already properly RCU
protected so we don't need to do anything fancy than to make sure
tunnel_id and tunnel_dst are read only once and checked in the egress path.

Cc: stable@vger.kernel.org
Fixes: 11538d039ac6 ("bridge: vlan dst_metadata hooks in ingress and egress paths")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_private.h     |  4 ++--
 net/bridge/br_vlan_tunnel.c | 38 +++++++++++++++++++++++--------------
 2 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 7ce8a77cc6b6..e013d33f1c7c 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -90,8 +90,8 @@ struct bridge_mcast_stats {
 #endif
 
 struct br_tunnel_info {
-	__be64			tunnel_id;
-	struct metadata_dst	*tunnel_dst;
+	__be64				tunnel_id;
+	struct metadata_dst __rcu	*tunnel_dst;
 };
 
 /* private vlan flags */
diff --git a/net/bridge/br_vlan_tunnel.c b/net/bridge/br_vlan_tunnel.c
index 0d3a8c01552e..03de461a0d44 100644
--- a/net/bridge/br_vlan_tunnel.c
+++ b/net/bridge/br_vlan_tunnel.c
@@ -41,26 +41,33 @@ static struct net_bridge_vlan *br_vlan_tunnel_lookup(struct rhashtable *tbl,
 				      br_vlan_tunnel_rht_params);
 }
 
+static void vlan_tunnel_info_release(struct net_bridge_vlan *vlan)
+{
+	struct metadata_dst *tdst = rtnl_dereference(vlan->tinfo.tunnel_dst);
+
+	WRITE_ONCE(vlan->tinfo.tunnel_id, 0);
+	RCU_INIT_POINTER(vlan->tinfo.tunnel_dst, NULL);
+	dst_release(&tdst->dst);
+}
+
 void vlan_tunnel_info_del(struct net_bridge_vlan_group *vg,
 			  struct net_bridge_vlan *vlan)
 {
-	if (!vlan->tinfo.tunnel_dst)
+	if (!rcu_access_pointer(vlan->tinfo.tunnel_dst))
 		return;
 	rhashtable_remove_fast(&vg->tunnel_hash, &vlan->tnode,
 			       br_vlan_tunnel_rht_params);
-	vlan->tinfo.tunnel_id = 0;
-	dst_release(&vlan->tinfo.tunnel_dst->dst);
-	vlan->tinfo.tunnel_dst = NULL;
+	vlan_tunnel_info_release(vlan);
 }
 
 static int __vlan_tunnel_info_add(struct net_bridge_vlan_group *vg,
 				  struct net_bridge_vlan *vlan, u32 tun_id)
 {
-	struct metadata_dst *metadata = NULL;
+	struct metadata_dst *metadata = rtnl_dereference(vlan->tinfo.tunnel_dst);
 	__be64 key = key32_to_tunnel_id(cpu_to_be32(tun_id));
 	int err;
 
-	if (vlan->tinfo.tunnel_dst)
+	if (metadata)
 		return -EEXIST;
 
 	metadata = __ip_tun_set_dst(0, 0, 0, 0, 0, TUNNEL_KEY,
@@ -69,8 +76,8 @@ static int __vlan_tunnel_info_add(struct net_bridge_vlan_group *vg,
 		return -EINVAL;
 
 	metadata->u.tun_info.mode |= IP_TUNNEL_INFO_TX | IP_TUNNEL_INFO_BRIDGE;
-	vlan->tinfo.tunnel_dst = metadata;
-	vlan->tinfo.tunnel_id = key;
+	rcu_assign_pointer(vlan->tinfo.tunnel_dst, metadata);
+	WRITE_ONCE(vlan->tinfo.tunnel_id, key);
 
 	err = rhashtable_lookup_insert_fast(&vg->tunnel_hash, &vlan->tnode,
 					    br_vlan_tunnel_rht_params);
@@ -79,9 +86,7 @@ static int __vlan_tunnel_info_add(struct net_bridge_vlan_group *vg,
 
 	return 0;
 out:
-	dst_release(&vlan->tinfo.tunnel_dst->dst);
-	vlan->tinfo.tunnel_dst = NULL;
-	vlan->tinfo.tunnel_id = 0;
+	vlan_tunnel_info_release(vlan);
 
 	return err;
 }
@@ -182,12 +187,15 @@ int br_handle_ingress_vlan_tunnel(struct sk_buff *skb,
 int br_handle_egress_vlan_tunnel(struct sk_buff *skb,
 				 struct net_bridge_vlan *vlan)
 {
+	struct metadata_dst *tunnel_dst;
+	__be64 tunnel_id;
 	int err;
 
-	if (!vlan || !vlan->tinfo.tunnel_id)
+	if (!vlan)
 		return 0;
 
-	if (unlikely(!skb_vlan_tag_present(skb)))
+	tunnel_id = READ_ONCE(vlan->tinfo.tunnel_id);
+	if (!tunnel_id || unlikely(!skb_vlan_tag_present(skb)))
 		return 0;
 
 	skb_dst_drop(skb);
@@ -195,7 +203,9 @@ int br_handle_egress_vlan_tunnel(struct sk_buff *skb,
 	if (err)
 		return err;
 
-	skb_dst_set(skb, dst_clone(&vlan->tinfo.tunnel_dst->dst));
+	tunnel_dst = rcu_dereference(vlan->tinfo.tunnel_dst);
+	if (tunnel_dst)
+		skb_dst_set(skb, dst_clone(&tunnel_dst->dst));
 
 	return 0;
 }
-- 
2.31.1

