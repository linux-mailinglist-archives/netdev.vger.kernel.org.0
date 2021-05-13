Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4050737F89E
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 15:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234093AbhEMNWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 09:22:50 -0400
Received: from mail.aperture-lab.de ([116.203.183.178]:52814 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233981AbhEMNWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 09:22:25 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 197FA4100A;
        Thu, 13 May 2021 15:21:03 +0200 (CEST)
From:   =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: [net-next v4 05/11] net: bridge: mcast: prepare is-router function for mcast router split
Date:   Thu, 13 May 2021 15:20:47 +0200
Message-Id: <20210513132053.23445-6-linus.luessing@c0d3.blue>
In-Reply-To: <20210513132053.23445-1-linus.luessing@c0d3.blue>
References: <20210513132053.23445-1-linus.luessing@c0d3.blue>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for the upcoming split of multicast router state into
their IPv4 and IPv6 variants make br_multicast_is_router() protocol
family aware.

Note that for now br_ip6_multicast_is_router() uses the currently still
common ip4_mc_router_timer for now. It will be renamed to
ip6_mc_router_timer later when the split is performed.

While at it also renames the "1" and "2" constants in
br_multicast_is_router() to the MDB_RTR_TYPE_TEMP_QUERY and
MDB_RTR_TYPE_PERM enums.

Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
---
 net/bridge/br_input.c     |  2 +-
 net/bridge/br_multicast.c |  5 +++--
 net/bridge/br_private.h   | 37 +++++++++++++++++++++++++++++++++----
 3 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 8875e95..1f50630 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -132,7 +132,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 		if ((mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb)) &&
 		    br_multicast_querier_exists(br, eth_hdr(skb), mdst)) {
 			if ((mdst && mdst->host_joined) ||
-			    br_multicast_is_router(br)) {
+			    br_multicast_is_router(br, skb)) {
 				local_rcv = true;
 				br->dev->stats.multicast++;
 			}
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 7edbbc9..048b5b9 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1391,7 +1391,8 @@ static void br_multicast_local_router_expired(struct timer_list *t)
 	spin_lock(&br->multicast_lock);
 	if (br->multicast_router == MDB_RTR_TYPE_DISABLED ||
 	    br->multicast_router == MDB_RTR_TYPE_PERM ||
-	    timer_pending(&br->ip4_mc_router_timer))
+	    br_ip4_multicast_is_router(br) ||
+	    br_ip6_multicast_is_router(br))
 		goto out;
 
 	br_mc_router_state_change(br, false);
@@ -3622,7 +3623,7 @@ bool br_multicast_router(const struct net_device *dev)
 	bool is_router;
 
 	spin_lock_bh(&br->multicast_lock);
-	is_router = br_multicast_is_router(br);
+	is_router = br_multicast_is_router(br, NULL);
 	spin_unlock_bh(&br->multicast_lock);
 	return is_router;
 }
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index d970ef7..f9a381f 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -874,11 +874,40 @@ br_multicast_rport_from_node_skb(struct hlist_node *rp, struct sk_buff *skb) {
 	return hlist_entry_safe(rp, struct net_bridge_port, ip4_rlist);
 }
 
-static inline bool br_multicast_is_router(struct net_bridge *br)
+static inline bool br_ip4_multicast_is_router(struct net_bridge *br)
 {
-	return br->multicast_router == 2 ||
-	       (br->multicast_router == 1 &&
-		timer_pending(&br->ip4_mc_router_timer));
+	return timer_pending(&br->ip4_mc_router_timer);
+}
+
+static inline bool br_ip6_multicast_is_router(struct net_bridge *br)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	return timer_pending(&br->ip4_mc_router_timer);
+#else
+	return false;
+#endif
+}
+
+static inline bool
+br_multicast_is_router(struct net_bridge *br, struct sk_buff *skb)
+{
+	switch (br->multicast_router) {
+	case MDB_RTR_TYPE_PERM:
+		return true;
+	case MDB_RTR_TYPE_TEMP_QUERY:
+		if (skb) {
+			if (skb->protocol == htons(ETH_P_IP))
+				return br_ip4_multicast_is_router(br);
+			else if (skb->protocol == htons(ETH_P_IPV6))
+				return br_ip6_multicast_is_router(br);
+		} else {
+			return br_ip4_multicast_is_router(br) ||
+			       br_ip6_multicast_is_router(br);
+		}
+		fallthrough;
+	default:
+		return false;
+	}
 }
 
 static inline bool
-- 
2.31.0

