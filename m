Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3ED41C917
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345630AbhI2QBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:01:30 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24139 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345469AbhI2P7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:49 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKLbH6zSjz1DHLW;
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
Subject: [RFCv2 net-next 048/167] net: ipv4: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:35 +0800
Message-ID: <20210929155334.12454-49-shenjian15@huawei.com>
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
 include/net/udp.h        |  8 ++++++--
 include/net/udp_tunnel.h | 12 ++++++++----
 net/ipv4/af_inet.c       |  3 ++-
 net/ipv4/esp4_offload.c  | 28 +++++++++++++++++-----------
 net/ipv4/gre_offload.c   |  8 +++++---
 net/ipv4/ip_gre.c        | 36 ++++++++++++++++++++++--------------
 net/ipv4/ip_output.c     | 23 +++++++++++++++--------
 net/ipv4/ip_tunnel.c     |  4 +++-
 net/ipv4/ip_vti.c        |  2 +-
 net/ipv4/ipip.c          |  6 +++---
 net/ipv4/ipmr.c          |  2 +-
 net/ipv4/tcp_offload.c   |  5 ++++-
 net/ipv4/udp_offload.c   | 28 +++++++++++++++++-----------
 13 files changed, 104 insertions(+), 61 deletions(-)

diff --git a/include/net/udp.h b/include/net/udp.h
index 360df454356c..3855b9775cbf 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -481,14 +481,18 @@ void udpv6_encap_enable(void);
 static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 					      struct sk_buff *skb, bool ipv4)
 {
-	netdev_features_t features = NETIF_F_SG;
+	netdev_features_t features;
 	struct sk_buff *segs;
 
+	netdev_feature_zero(&features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, &features);
+
 	/* Avoid csum recalculation by skb_segment unless userspace explicitly
 	 * asks for the final checksum values
 	 */
 	if (!inet_get_convert_csum(sk))
-		features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
+					&features);
 
 	/* UDP segmentation expects packets of type CHECKSUM_PARTIAL or
 	 * CHECKSUM_NONE in __udp_gso_segment. UDP GRO indeed builds partial
diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index afc7ce713657..68c1a540a733 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -129,7 +129,8 @@ void udp_tunnel_notify_del_rx_port(struct socket *sock, unsigned short type);
 static inline void udp_tunnel_get_rx_info(struct net_device *dev)
 {
 	ASSERT_RTNL();
-	if (!(dev->features & NETIF_F_RX_UDP_TUNNEL_PORT))
+	if (!netdev_feature_test_bit(NETIF_F_RX_UDP_TUNNEL_PORT_BIT,
+				     dev->features))
 		return;
 	call_netdevice_notifiers(NETDEV_UDP_TUNNEL_PUSH_INFO, dev);
 }
@@ -137,7 +138,8 @@ static inline void udp_tunnel_get_rx_info(struct net_device *dev)
 static inline void udp_tunnel_drop_rx_info(struct net_device *dev)
 {
 	ASSERT_RTNL();
-	if (!(dev->features & NETIF_F_RX_UDP_TUNNEL_PORT))
+	if (!netdev_feature_test_bit(NETIF_F_RX_UDP_TUNNEL_PORT_BIT,
+				     dev->features))
 		return;
 	call_netdevice_notifiers(NETDEV_UDP_TUNNEL_DROP_INFO, dev);
 }
@@ -326,7 +328,8 @@ udp_tunnel_nic_set_port_priv(struct net_device *dev, unsigned int table,
 static inline void
 udp_tunnel_nic_add_port(struct net_device *dev, struct udp_tunnel_info *ti)
 {
-	if (!(dev->features & NETIF_F_RX_UDP_TUNNEL_PORT))
+	if (!netdev_feature_test_bit(NETIF_F_RX_UDP_TUNNEL_PORT_BIT,
+				     dev->features))
 		return;
 	if (udp_tunnel_nic_ops)
 		udp_tunnel_nic_ops->add_port(dev, ti);
@@ -335,7 +338,8 @@ udp_tunnel_nic_add_port(struct net_device *dev, struct udp_tunnel_info *ti)
 static inline void
 udp_tunnel_nic_del_port(struct net_device *dev, struct udp_tunnel_info *ti)
 {
-	if (!(dev->features & NETIF_F_RX_UDP_TUNNEL_PORT))
+	if (!netdev_feature_test_bit(NETIF_F_RX_UDP_TUNNEL_PORT_BIT,
+				     dev->features))
 		return;
 	if (udp_tunnel_nic_ops)
 		udp_tunnel_nic_ops->del_port(dev, ti);
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 40558033f857..aeff7736f260 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1357,7 +1357,8 @@ struct sk_buff *inet_gso_segment(struct sk_buff *skb,
 
 	encap = SKB_GSO_CB(skb)->encap_level > 0;
 	if (encap)
-		features &= skb->dev->hw_enc_features;
+		netdev_feature_and(&features, features,
+				   skb->dev->hw_enc_features);
 	SKB_GSO_CB(skb)->encap_level += ihl;
 
 	skb_reset_transport_header(skb);
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 8e4e9aa12130..f7e77a9176d6 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -189,8 +189,8 @@ static struct sk_buff *esp4_gso_segment(struct sk_buff *skb,
 	struct xfrm_state *x;
 	struct ip_esp_hdr *esph;
 	struct crypto_aead *aead;
-	netdev_features_t esp_features = features;
 	struct xfrm_offload *xo = xfrm_offload(skb);
+	netdev_features_t esp_features;
 	struct sec_path *sp;
 
 	if (!xo)
@@ -214,14 +214,19 @@ static struct sk_buff *esp4_gso_segment(struct sk_buff *skb,
 
 	skb->encap_hdr_csum = 1;
 
-	if ((!(skb->dev->gso_partial_features & NETIF_F_HW_ESP) &&
-	     !(features & NETIF_F_HW_ESP)) || x->xso.dev != skb->dev)
-		esp_features = features & ~(NETIF_F_SG | NETIF_F_CSUM_MASK |
-					    NETIF_F_SCTP_CRC);
-	else if (!(features & NETIF_F_HW_ESP_TX_CSUM) &&
-		 !(skb->dev->gso_partial_features & NETIF_F_HW_ESP_TX_CSUM))
-		esp_features = features & ~(NETIF_F_CSUM_MASK |
-					    NETIF_F_SCTP_CRC);
+	netdev_feature_copy(&esp_features, features);
+	if ((!netdev_feature_test_bit(NETIF_F_HW_ESP_BIT,
+				      skb->dev->gso_partial_features) &&
+	     !netdev_feature_test_bit(NETIF_F_HW_ESP_BIT, features)) ||
+	    x->xso.dev != skb->dev)
+		netdev_feature_clear_bits(NETIF_F_SG | NETIF_F_CSUM_MASK |
+					  NETIF_F_SCTP_CRC, &esp_features);
+	else if (!netdev_feature_test_bit(NETIF_F_HW_ESP_TX_CSUM_BIT,
+					  features) &&
+		 !netdev_feature_test_bit(NETIF_F_HW_ESP_TX_CSUM_BIT,
+					  skb->dev->gso_partial_features))
+		netdev_feature_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_SCTP_CRC,
+					  &esp_features);
 
 	xo->flags |= XFRM_GSO_SEGMENT;
 
@@ -261,8 +266,9 @@ static int esp_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features_
 	if (!xo)
 		return -EINVAL;
 
-	if ((!(features & NETIF_F_HW_ESP) &&
-	     !(skb->dev->gso_partial_features & NETIF_F_HW_ESP)) ||
+	if ((!netdev_feature_test_bit(NETIF_F_HW_ESP_BIT, features) &&
+	     !netdev_feature_test_bit(NETIF_F_HW_ESP_BIT,
+				      skb->dev->gso_partial_features)) ||
 	    x->xso.dev != skb->dev) {
 		xo->flags |= CRYPTO_FALLBACK;
 		hw_offload = false;
diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index 1121a9d5fed9..65f22fa749be 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -43,14 +43,16 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 	need_csum = !!(skb_shinfo(skb)->gso_type & SKB_GSO_GRE_CSUM);
 	skb->encap_hdr_csum = need_csum;
 
-	features &= skb->dev->hw_enc_features;
+	netdev_feature_and(&features, features, skb->dev->hw_enc_features);
+
 	if (need_csum)
-		features &= ~NETIF_F_SCTP_CRC;
+		netdev_feature_clear_bit(NETIF_F_SCTP_CRC_BIT, &features);
 
 	need_ipsec = skb_dst(skb) && dst_xfrm(skb_dst(skb));
 	/* Try to offload checksum if possible */
 	offload_csum = !!(need_csum && !need_ipsec &&
-			  (skb->dev->features & NETIF_F_HW_CSUM));
+			  netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT,
+						  skb->dev->features));
 
 	/* segment inner packet. */
 	segs = skb_mac_gso_segment(skb, features);
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 0fe6c936dc54..e083ef6a8454 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -767,16 +767,22 @@ static void ipgre_link_update(struct net_device *dev, bool set_mtu)
 	if (!(tunnel->parms.o_flags & TUNNEL_SEQ)) {
 		if (!(tunnel->parms.o_flags & TUNNEL_CSUM) ||
 		    tunnel->encap.type == TUNNEL_ENCAP_NONE) {
-			dev->features |= NETIF_F_GSO_SOFTWARE;
-			dev->hw_features |= NETIF_F_GSO_SOFTWARE;
+			netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE,
+						&dev->features);
+			netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE,
+						&dev->hw_features);
 		} else {
-			dev->features &= ~NETIF_F_GSO_SOFTWARE;
-			dev->hw_features &= ~NETIF_F_GSO_SOFTWARE;
+			netdev_feature_clear_bits(NETIF_F_GSO_SOFTWARE,
+						  &dev->features);
+			netdev_feature_clear_bits(NETIF_F_GSO_SOFTWARE,
+						  &dev->hw_features);
 		}
-		dev->features |= NETIF_F_LLTX;
+		netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
 	} else {
-		dev->hw_features &= ~NETIF_F_GSO_SOFTWARE;
-		dev->features &= ~(NETIF_F_LLTX | NETIF_F_GSO_SOFTWARE);
+		netdev_feature_clear_bits(NETIF_F_GSO_SOFTWARE,
+					  &dev->hw_features);
+		netdev_feature_clear_bits(NETIF_F_LLTX | NETIF_F_GSO_SOFTWARE,
+					  &dev->features);
 	}
 }
 
@@ -958,8 +964,8 @@ static void __gre_tunnel_init(struct net_device *dev)
 	tunnel->hlen = tunnel->tun_hlen + tunnel->encap_hlen;
 	dev->needed_headroom = tunnel->hlen + sizeof(tunnel->parms.iph);
 
-	dev->features		|= GRE_FEATURES;
-	dev->hw_features	|= GRE_FEATURES;
+	netdev_feature_set_bits(GRE_FEATURES, &dev->features);
+	netdev_feature_set_bits(GRE_FEATURES, &dev->hw_features);
 
 	if (!(tunnel->parms.o_flags & TUNNEL_SEQ)) {
 		/* TCP offload with GRE SEQ is not supported, nor
@@ -968,14 +974,16 @@ static void __gre_tunnel_init(struct net_device *dev)
 		 */
 		if (!(tunnel->parms.o_flags & TUNNEL_CSUM) ||
 		    (tunnel->encap.type == TUNNEL_ENCAP_NONE)) {
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
 
@@ -1303,8 +1311,8 @@ static int erspan_tunnel_init(struct net_device *dev)
 	tunnel->hlen = tunnel->tun_hlen + tunnel->encap_hlen +
 		       erspan_hdr_len(tunnel->erspan_ver);
 
-	dev->features		|= GRE_FEATURES;
-	dev->hw_features	|= GRE_FEATURES;
+	netdev_feature_set_bits(GRE_FEATURES, &dev->features);
+	netdev_feature_set_bits(GRE_FEATURES, &dev->hw_features);
 	dev->priv_flags		|= IFF_LIVE_ADDR_CHANGE;
 	netif_keep_dst(dev);
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 8d552f1b7f62..60a693c7ae79 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -257,7 +257,8 @@ static int ip_finish_output_gso(struct net *net, struct sock *sk,
 	 */
 	netif_skb_features(skb, &features);
 	BUILD_BUG_ON(sizeof(*IPCB(skb)) > SKB_GSO_CB_OFFSET);
-	segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
+	netdev_feature_clear_bits(NETIF_F_GSO_MASK, &features);
+	segs = skb_gso_segment(skb, features);
 	if (IS_ERR_OR_NULL(segs)) {
 		kfree_skb(skb);
 		return -ENOMEM;
@@ -996,9 +997,11 @@ static int __ip_append_data(struct sock *sk,
 	 */
 	if (transhdrlen &&
 	    length + fragheaderlen <= mtu &&
-	    rt->dst.dev->features & (NETIF_F_HW_CSUM | NETIF_F_IP_CSUM) &&
+	    netdev_feature_test_bits(NETIF_F_HW_CSUM | NETIF_F_IP_CSUM,
+				     rt->dst.dev->features) &&
 	    (!(flags & MSG_MORE) || cork->gso_size) &&
-	    (!exthdrlen || (rt->dst.dev->features & NETIF_F_HW_ESP_TX_CSUM)))
+	    (!exthdrlen || netdev_feature_test_bit(NETIF_F_HW_ESP_TX_CSUM_BIT,
+						   rt->dst.dev->features)))
 		csummode = CHECKSUM_PARTIAL;
 
 	if (flags & MSG_ZEROCOPY && length && sock_flag(sk, SOCK_ZEROCOPY)) {
@@ -1006,7 +1009,8 @@ static int __ip_append_data(struct sock *sk,
 		if (!uarg)
 			return -ENOBUFS;
 		extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
-		if (rt->dst.dev->features & NETIF_F_SG &&
+		if (netdev_feature_test_bit(NETIF_F_SG_BIT,
+					    rt->dst.dev->features) &&
 		    csummode == CHECKSUM_PARTIAL) {
 			paged = true;
 		} else {
@@ -1069,11 +1073,13 @@ static int __ip_append_data(struct sock *sk,
 				alloc_extra += rt->dst.trailer_len;
 
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
@@ -1161,7 +1167,8 @@ static int __ip_append_data(struct sock *sk,
 		if (copy > length)
 			copy = length;
 
-		if (!(rt->dst.dev->features&NETIF_F_SG) &&
+		if (!netdev_feature_test_bit(NETIF_F_SG_BIT,
+					     rt->dst.dev->features) &&
 		    skb_tailroom(skb) >= copy) {
 			unsigned int off;
 
@@ -1340,7 +1347,7 @@ ssize_t	ip_append_page(struct sock *sk, struct flowi4 *fl4, struct page *page,
 	if (cork->flags & IPCORK_OPT)
 		opt = cork->opt;
 
-	if (!(rt->dst.dev->features & NETIF_F_SG))
+	if (!netdev_feature_test_bit(NETIF_F_SG_BIT, rt->dst.dev->features))
 		return -EOPNOTSUPP;
 
 	hh_len = LL_RESERVED_SPACE(rt->dst.dev);
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index fe9101d3d69e..ac5671e5ea28 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -1072,7 +1072,9 @@ int ip_tunnel_init_net(struct net *net, unsigned int ip_tnl_net_id,
 	 * Allowing to move it to another netns is clearly unsafe.
 	 */
 	if (!IS_ERR(itn->fb_tunnel_dev)) {
-		itn->fb_tunnel_dev->features |= NETIF_F_NETNS_LOCAL;
+		netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT,
+				       &itn->fb_tunnel_dev->features);
+
 		itn->fb_tunnel_dev->mtu = ip_tunnel_bind_dev(itn->fb_tunnel_dev);
 		ip_tunnel_add(itn, netdev_priv(itn->fb_tunnel_dev));
 		itn->type = itn->fb_tunnel_dev->type;
diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index efe25a0172e6..bf94ef6a1f2c 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -430,7 +430,7 @@ static int vti_tunnel_init(struct net_device *dev)
 
 	dev->flags		= IFF_NOARP;
 	dev->addr_len		= 4;
-	dev->features		|= NETIF_F_LLTX;
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
 	netif_keep_dst(dev);
 
 	return ip_tunnel_init(dev);
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 3aa78ccbec3e..b587d472fad5 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -368,11 +368,11 @@ static void ipip_tunnel_setup(struct net_device *dev)
 	dev->type		= ARPHRD_TUNNEL;
 	dev->flags		= IFF_NOARP;
 	dev->addr_len		= 4;
-	dev->features		|= NETIF_F_LLTX;
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
 	netif_keep_dst(dev);
 
-	dev->features		|= IPIP_FEATURES;
-	dev->hw_features	|= IPIP_FEATURES;
+	netdev_feature_set_bits(IPIP_FEATURES, &dev->features);
+	netdev_feature_set_bits(IPIP_FEATURES, &dev->hw_features);
 	ip_tunnel_setup(dev, ipip_net_id);
 }
 
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 2dda856ca260..750a4a102014 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -532,7 +532,7 @@ static void reg_vif_setup(struct net_device *dev)
 	dev->flags		= IFF_NOARP;
 	dev->netdev_ops		= &reg_vif_netdev_ops;
 	dev->needs_free_netdev	= true;
-	dev->features		|= NETIF_F_NETNS_LOCAL;
+	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, &dev->features);
 }
 
 static struct net_device *ipmr_reg_vif(struct net *net, struct mr_table *mrt)
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index fc61cd3fea65..4bf0a0d382f6 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -65,6 +65,7 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 	struct sk_buff *gso_skb = skb;
 	__sum16 newcheck;
 	bool ooo_okay, copy_destructor;
+	netdev_features_t tmp;
 
 	th = tcp_hdr(skb);
 	thlen = th->doff * 4;
@@ -81,7 +82,9 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 	if (unlikely(skb->len <= mss))
 		goto out;
 
-	if (skb_gso_ok(skb, features | NETIF_F_GSO_ROBUST)) {
+	netdev_feature_copy(&tmp, features);
+	netdev_feature_set_bit(NETIF_F_GSO_ROBUST_BIT, &tmp);
+	if (skb_gso_ok(skb, tmp)) {
 		/* Packet is from an untrusted source, reset gso_segs. */
 
 		skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(skb->len, mss);
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 86d32a1e62ac..e4c14e142bde 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -63,22 +63,26 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 	/* Try to offload checksum if possible */
 	offload_csum = !!(need_csum &&
 			  !need_ipsec &&
-			  (skb->dev->features &
-			   (is_ipv6 ? (NETIF_F_HW_CSUM | NETIF_F_IPV6_CSUM) :
-				      (NETIF_F_HW_CSUM | NETIF_F_IP_CSUM))));
-
-	features &= skb->dev->hw_enc_features;
+			  is_ipv6 ?
+			  netdev_feature_test_bits(NETIF_F_HW_CSUM |
+						   NETIF_F_IPV6_CSUM,
+						   skb->dev->features) :
+			  netdev_feature_test_bits(NETIF_F_HW_CSUM |
+						   NETIF_F_IP_CSUM,
+						   skb->dev->features));
+
+	netdev_feature_and(&features, features, skb->dev->hw_enc_features);
 	if (need_csum)
-		features &= ~NETIF_F_SCTP_CRC;
+		netdev_feature_clear_bit(NETIF_F_SCTP_CRC_BIT, &features);
 
 	/* The only checksum offload we care about from here on out is the
 	 * outer one so strip the existing checksum feature flags and
 	 * instead set the flag based on our outer checksum offload value.
 	 */
 	if (remcsum) {
-		features &= ~NETIF_F_CSUM_MASK;
+		netdev_feature_clear_bits(NETIF_F_CSUM_MASK, &features);
 		if (!need_csum || offload_csum)
-			features |= NETIF_F_HW_CSUM;
+			netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &features);
 	}
 
 	/* segment inner packet. */
@@ -414,7 +418,7 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
 	 * software prior to segmenting the frame.
 	 */
 	if (!skb->encap_hdr_csum)
-		features |= NETIF_F_HW_CSUM;
+		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &features);
 
 	/* Fragment the skb. IP headers of the fragments are updated in
 	 * inet_gso_segment()
@@ -520,10 +524,12 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
 	 */
 	NAPI_GRO_CB(skb)->is_flist = 0;
 	if (!sk || !udp_sk(sk)->gro_receive) {
-		if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
+		if (netdev_feature_test_bit(NETIF_F_GRO_FRAGLIST_BIT,
+					    skb->dev->features))
 			NAPI_GRO_CB(skb)->is_flist = sk ? !udp_sk(sk)->gro_enabled : 1;
 
-		if ((!sk && (skb->dev->features & NETIF_F_GRO_UDP_FWD)) ||
+		if ((!sk && netdev_feature_test_bit(NETIF_F_GRO_UDP_FWD_BIT,
+						    skb->dev->features)) ||
 		    (sk && udp_sk(sk)->gro_enabled) || NAPI_GRO_CB(skb)->is_flist)
 			return call_gro_receive(udp_gro_receive_segment, head, skb);
 
-- 
2.33.0

