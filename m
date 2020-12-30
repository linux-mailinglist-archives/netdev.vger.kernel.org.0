Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8F92E787F
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 13:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgL3MY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 07:24:57 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:53439 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726539AbgL3MY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 07:24:56 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from ayal@mellanox.com)
        with SMTP; 30 Dec 2020 14:24:00 +0200
Received: from dev-l-vrt-210.mtl.labs.mlnx (dev-l-vrt-210.mtl.labs.mlnx [10.234.210.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0BUCNxmX011571;
        Wed, 30 Dec 2020 14:23:59 +0200
Received: from dev-l-vrt-210.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Debian-8ubuntu1) with ESMTP id 0BUCNx3S002609;
        Wed, 30 Dec 2020 14:23:59 +0200
Received: (from ayal@localhost)
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 0BUCNv3c002607;
        Wed, 30 Dec 2020 14:23:57 +0200
From:   Aya Levin <ayal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Daniel Axtens <dja@axtens.net>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>, Aya Levin <ayal@nvidia.com>
Subject: [PATCH net] net: ipv6: Validate GSO SKB before finish IPv6 processing
Date:   Wed, 30 Dec 2020 14:23:48 +0200
Message-Id: <1609331028-2566-1-git-send-email-ayal@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are cases where GSO segment's length exceeds the egress MTU.
If so:
 - Consume the SKB and its segments.
 - Issue an ICMP packet with 'Packet Too Big' message containing the
   MTU, allowing the source host to reduce its Path MTU appropriately.

Note: These cases are handled in the same manner in IPv4 output finish.
This patch aligns the behavior of IPv6 and IPv4.

Fixes: 9e50849054a4 ("netfilter: ipv6: move POSTROUTING invocation before fragmentation")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 net/ipv6/ip6_output.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

Hi,

Please queue to -stable >= v2.6.35.

Daniel Axtens, does this solve the issue referred in your commit?
8914a595110a bnx2x: disable GSO where gso_size is too big for hardware

Thanks,
Aya

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 749ad72386b2..36466f2211bd 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -125,8 +125,43 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 	return -EINVAL;
 }
 
+static int
+ip6_finish_output_gso_slowpath_drop(struct net *net, struct sock *sk,
+				    struct sk_buff *skb, unsigned int mtu)
+{
+	struct sk_buff *segs, *nskb;
+	netdev_features_t features;
+	int ret;
+
+	/* Please see corresponding comment in ip_finish_output_gso
+	 * describing the cases where GSO segment length exceeds the
+	 * egress MTU.
+	 */
+	features = netif_skb_features(skb);
+	segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
+	if (IS_ERR_OR_NULL(segs)) {
+		kfree_skb(skb);
+		return -ENOMEM;
+	}
+
+	consume_skb(skb);
+
+	skb_list_walk_safe(segs, segs, nskb) {
+		int err;
+
+		skb_mark_not_on_list(segs);
+		err = ip6_fragment(net, sk, segs, ip6_finish_output2);
+		if (err && ret == 0)
+			ret = err;
+	}
+
+	return ret;
+}
+
 static int __ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
+	unsigned int mtu;
+
 #if defined(CONFIG_NETFILTER) && defined(CONFIG_XFRM)
 	/* Policy lookup after SNAT yielded a new policy */
 	if (skb_dst(skb)->xfrm) {
@@ -135,7 +170,11 @@ static int __ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff
 	}
 #endif
 
-	if ((skb->len > ip6_skb_dst_mtu(skb) && !skb_is_gso(skb)) ||
+	mtu = ip6_skb_dst_mtu(skb);
+	if (skb_is_gso(skb) && !skb_gso_validate_network_len(skb, mtu))
+		return ip6_finish_output_gso_slowpath_drop(net, sk, skb, mtu);
+
+	if ((skb->len > mtu && !skb_is_gso(skb)) ||
 	    dst_allfrag(skb_dst(skb)) ||
 	    (IP6CB(skb)->frag_max_size && skb->len > IP6CB(skb)->frag_max_size))
 		return ip6_fragment(net, sk, skb, ip6_finish_output2);
-- 
2.14.1

