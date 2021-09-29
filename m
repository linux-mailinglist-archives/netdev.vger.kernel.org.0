Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3FE241C906
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345813AbhI2QAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:00:52 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12987 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344403AbhI2P7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:46 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLbH6JxRzWJBw;
        Wed, 29 Sep 2021 23:56:43 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:03 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:02 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 049/167] net: ipv6: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:36 +0800
Message-ID: <20210929155334.12454-50-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_feature_xxx helpers to replace the logical operation
for netdev features.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 net/ipv6/esp6_offload.c | 19 +++++++++++--------
 net/ipv6/ip6_gre.c      | 17 ++++++++++-------
 net/ipv6/ip6_offload.c  |  3 ++-
 net/ipv6/ip6_output.c   | 18 ++++++++++++------
 net/ipv6/ip6_tunnel.c   |  9 +++++----
 net/ipv6/ip6mr.c        |  2 +-
 net/ipv6/sit.c          |  9 +++++----
 net/ipv6/udp_offload.c  |  2 +-
 8 files changed, 47 insertions(+), 32 deletions(-)

diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index a349d4798077..5c2e0da49804 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -228,8 +228,8 @@ static struct sk_buff *esp6_gso_segment(struct sk_buff *skb,
 	struct xfrm_state *x;
 	struct ip_esp_hdr *esph;
 	struct crypto_aead *aead;
-	netdev_features_t esp_features = features;
 	struct xfrm_offload *xo = xfrm_offload(skb);
+	netdev_features_t esp_features;
 	struct sec_path *sp;
 
 	if (!xo)
@@ -253,12 +253,14 @@ static struct sk_buff *esp6_gso_segment(struct sk_buff *skb,
 
 	skb->encap_hdr_csum = 1;
 
-	if (!(features & NETIF_F_HW_ESP) || x->xso.dev != skb->dev)
-		esp_features = features & ~(NETIF_F_SG | NETIF_F_CSUM_MASK |
-					    NETIF_F_SCTP_CRC);
-	else if (!(features & NETIF_F_HW_ESP_TX_CSUM))
-		esp_features = features & ~(NETIF_F_CSUM_MASK |
-					    NETIF_F_SCTP_CRC);
+	netdev_feature_copy(&esp_features, features);
+	if (!netdev_feature_test_bit(NETIF_F_HW_ESP_BIT, features) ||
+	    x->xso.dev != skb->dev)
+		netdev_feature_clear_bits(NETIF_F_SG | NETIF_F_CSUM_MASK |
+					  NETIF_F_SCTP_CRC, &esp_features);
+	else if (!netdev_feature_test_bit(NETIF_F_HW_ESP_TX_CSUM_BIT, features))
+		netdev_feature_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_SCTP_CRC,
+					  &esp_features);
 
 	xo->flags |= XFRM_GSO_SEGMENT;
 
@@ -298,7 +300,8 @@ static int esp6_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features
 	if (!xo)
 		return -EINVAL;
 
-	if (!(features & NETIF_F_HW_ESP) || x->xso.dev != skb->dev) {
+	if (!netdev_feature_test_bit(NETIF_F_HW_ESP_BIT, features) ||
+	    x->xso.dev != skb->dev) {
 		xo->flags |= CRYPTO_FALLBACK;
 		hw_offload = false;
 	}
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 3ad201d372d8..336ddf0b3586 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -385,7 +385,7 @@ static struct ip6_tnl *ip6gre_tunnel_locate(struct net *net,
 
 	/* Can use a lockless transmit, unless we generate output sequences */
 	if (!(nt->parms.o_flags & TUNNEL_SEQ))
-		dev->features |= NETIF_F_LLTX;
+		netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
 
 	ip6gre_tunnel_link(ign, nt);
 	return nt;
@@ -1439,8 +1439,8 @@ static void ip6gre_tnl_init_features(struct net_device *dev)
 {
 	struct ip6_tnl *nt = netdev_priv(dev);
 
-	dev->features		|= GRE6_FEATURES;
-	dev->hw_features	|= GRE6_FEATURES;
+	netdev_feature_set_bits(GRE6_FEATURES, &dev->features);
+	netdev_feature_set_bits(GRE6_FEATURES, &dev->hw_features);
 
 	if (!(nt->parms.o_flags & TUNNEL_SEQ)) {
 		/* TCP offload with GRE SEQ is not supported, nor
@@ -1449,14 +1449,16 @@ static void ip6gre_tnl_init_features(struct net_device *dev)
 		 */
 		if (!(nt->parms.o_flags & TUNNEL_CSUM) ||
 		    nt->encap.type == TUNNEL_ENCAP_NONE) {
-			dev->features    |= NETIF_F_GSO_SOFTWARE;
-			dev->hw_features |= NETIF_F_GSO_SOFTWARE;
+			netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE,
+						&dev->features);
+			netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE,
+						&dev->hw_features);
 		}
 
 		/* Can use a lockless transmit, unless we generate
 		 * output sequences
 		 */
-		dev->features |= NETIF_F_LLTX;
+		netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
 	}
 }
 
@@ -1598,7 +1600,8 @@ static int __net_init ip6gre_init_net(struct net *net)
 	/* FB netdevice is special: we have one, and only one per netns.
 	 * Allowing to move it to another netns is clearly unsafe.
 	 */
-	ign->fb_tunnel_dev->features |= NETIF_F_NETNS_LOCAL;
+	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT,
+			       &ign->fb_tunnel_dev->features);
 
 
 	ip6gre_fb_tunnel_init(ign->fb_tunnel_dev);
diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index 1b9827ff8ccf..4c3ba4b4ba51 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -93,7 +93,8 @@ static struct sk_buff *ipv6_gso_segment(struct sk_buff *skb,
 
 	encap = SKB_GSO_CB(skb)->encap_level > 0;
 	if (encap)
-		features &= skb->dev->hw_enc_features;
+		netdev_feature_and(&features, features,
+				   skb->dev->hw_enc_features);
 	SKB_GSO_CB(skb)->encap_level += sizeof(*ipv6h);
 
 	ipv6h = ipv6_hdr(skb);
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 46a0867bcedf..78e01d4faf09 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -147,7 +147,8 @@ ip6_finish_output_gso_slowpath_drop(struct net *net, struct sock *sk,
 	 * egress MTU.
 	 */
 	netif_skb_features(skb, &features);
-	segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
+	netdev_feature_clear_bits(NETIF_F_GSO_MASK, &features);
+	segs = skb_gso_segment(skb, features);
 	if (IS_ERR_OR_NULL(segs)) {
 		kfree_skb(skb);
 		return -ENOMEM;
@@ -1512,7 +1513,8 @@ static int __ip6_append_data(struct sock *sk,
 	    headersize == sizeof(struct ipv6hdr) &&
 	    length <= mtu - headersize &&
 	    (!(flags & MSG_MORE) || cork->gso_size) &&
-	    rt->dst.dev->features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
+	    netdev_feature_test_bits(NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM,
+				     rt->dst.dev->features))
 		csummode = CHECKSUM_PARTIAL;
 
 	if (flags & MSG_ZEROCOPY && length && sock_flag(sk, SOCK_ZEROCOPY)) {
@@ -1520,7 +1522,8 @@ static int __ip6_append_data(struct sock *sk,
 		if (!uarg)
 			return -ENOBUFS;
 		extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
-		if (rt->dst.dev->features & NETIF_F_SG &&
+		if (netdev_feature_test_bit(NETIF_F_SG_BIT,
+					    rt->dst.dev->features) &&
 		    csummode == CHECKSUM_PARTIAL) {
 			paged = true;
 		} else {
@@ -1598,11 +1601,13 @@ static int __ip6_append_data(struct sock *sk,
 			alloc_extra += sizeof(struct frag_hdr);
 
 			if ((flags & MSG_MORE) &&
-			    !(rt->dst.dev->features&NETIF_F_SG))
+			    !netdev_feature_test_bit(NETIF_F_SG_BIT,
+						     rt->dst.dev->features))
 				alloclen = mtu;
 			else if (!paged &&
 				 (fraglen + alloc_extra < SKB_MAX_ALLOC ||
-				  !(rt->dst.dev->features & NETIF_F_SG)))
+				  !netdev_feature_test_bit(NETIF_F_SG_BIT,
+							   rt->dst.dev->features)))
 				alloclen = fraglen;
 			else {
 				alloclen = min_t(int, fraglen, MAX_HEADER);
@@ -1705,7 +1710,8 @@ static int __ip6_append_data(struct sock *sk,
 		if (copy > length)
 			copy = length;
 
-		if (!(rt->dst.dev->features&NETIF_F_SG) &&
+		if (!netdev_feature_test_bit(NETIF_F_SG_BIT,
+					     rt->dst.dev->features) &&
 		    skb_tailroom(skb) >= copy) {
 			unsigned int off;
 
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 20a67efda47f..012f3ad0e7c0 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1833,11 +1833,11 @@ static void ip6_tnl_dev_setup(struct net_device *dev)
 	dev->type = ARPHRD_TUNNEL6;
 	dev->flags |= IFF_NOARP;
 	dev->addr_len = sizeof(struct in6_addr);
-	dev->features |= NETIF_F_LLTX;
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
 	netif_keep_dst(dev);
 
-	dev->features		|= IPXIPX_FEATURES;
-	dev->hw_features	|= IPXIPX_FEATURES;
+	netdev_feature_set_bits(IPXIPX_FEATURES, &dev->features);
+	netdev_feature_set_bits(IPXIPX_FEATURES, &dev->hw_features);
 
 	/* This perm addr will be used as interface identifier by IPv6 */
 	dev->addr_assign_type = NET_ADDR_RANDOM;
@@ -2279,7 +2279,8 @@ static int __net_init ip6_tnl_init_net(struct net *net)
 	/* FB netdevice is special: we have one, and only one per netns.
 	 * Allowing to move it to another netns is clearly unsafe.
 	 */
-	ip6n->fb_tnl_dev->features |= NETIF_F_NETNS_LOCAL;
+	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT,
+			       &ip6n->fb_tnl_dev->features);
 
 	err = ip6_fb_tnl_dev_init(ip6n->fb_tnl_dev);
 	if (err < 0)
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 36ed9efb8825..daf2a4b13112 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -636,7 +636,7 @@ static void reg_vif_setup(struct net_device *dev)
 	dev->flags		= IFF_NOARP;
 	dev->netdev_ops		= &reg_vif_netdev_ops;
 	dev->needs_free_netdev	= true;
-	dev->features		|= NETIF_F_NETNS_LOCAL;
+	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, &dev->features);
 }
 
 static struct net_device *ip6mr_reg_vif(struct net *net, struct mr_table *mrt)
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index ef0c7a7c18e2..58aa23267d41 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1438,9 +1438,9 @@ static void ipip6_tunnel_setup(struct net_device *dev)
 	dev->flags		= IFF_NOARP;
 	netif_keep_dst(dev);
 	dev->addr_len		= 4;
-	dev->features		|= NETIF_F_LLTX;
-	dev->features		|= SIT_FEATURES;
-	dev->hw_features	|= SIT_FEATURES;
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
+	netdev_feature_set_bits(SIT_FEATURES, &dev->features);
+	netdev_feature_set_bits(SIT_FEATURES, &dev->hw_features);
 }
 
 static int ipip6_tunnel_init(struct net_device *dev)
@@ -1918,7 +1918,8 @@ static int __net_init sit_init_net(struct net *net)
 	/* FB netdevice is special: we have one, and only one per netns.
 	 * Allowing to move it to another netns is clearly unsafe.
 	 */
-	sitn->fb_tunnel_dev->features |= NETIF_F_NETNS_LOCAL;
+	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT,
+			       &sitn->fb_tunnel_dev->features);
 
 	err = register_netdev(sitn->fb_tunnel_dev);
 	if (err)
diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index b3d9ed96e5ea..5911c603bd0b 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -69,7 +69,7 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
 		 * software prior to segmenting the frame.
 		 */
 		if (!skb->encap_hdr_csum)
-			features |= NETIF_F_HW_CSUM;
+			netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &features);
 
 		/* Check if there is enough headroom to insert fragment header. */
 		tnl_hlen = skb_tnl_header_len(skb);
-- 
2.33.0

