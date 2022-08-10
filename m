Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24B1558E556
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbiHJDOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiHJDNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:13:54 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D45882F8F
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:13:51 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4M2Zfr3Yy2zXdT6;
        Wed, 10 Aug 2022 11:09:40 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 10 Aug 2022 11:13:46 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv7 PATCH net-next 14/36] net: simplify the netdev features expressions for xxx_gso_segment
Date:   Wed, 10 Aug 2022 11:06:02 +0800
Message-ID: <20220810030624.34711-15-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220810030624.34711-1-shenjian15@huawei.com>
References: <20220810030624.34711-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The xxx_gso_segment functions use netdev_features as input
parameters. There are soma features handling for this parameter.
Simplify these expreesions, so it can be replaced by netdev
features helpers later.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 4 +++-
 drivers/net/ethernet/sfc/siena/tx_common.c       | 2 +-
 drivers/net/ethernet/sfc/tx_common.c             | 2 +-
 drivers/net/ethernet/sun/sunvnet_common.c        | 4 +++-
 drivers/net/wireguard/device.c                   | 2 +-
 net/core/dev.c                                   | 5 +++--
 net/ipv4/tcp_offload.c                           | 3 ++-
 net/mac80211/tx.c                                | 2 +-
 net/netfilter/nfnetlink_queue.c                  | 2 +-
 net/nsh/nsh.c                                    | 4 +++-
 net/openvswitch/datapath.c                       | 4 +++-
 net/sctp/offload.c                               | 9 +++++++--
 net/xfrm/xfrm_device.c                           | 3 ++-
 net/xfrm/xfrm_output.c                           | 2 +-
 14 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index cffe22b5f5f3..e1a5e80e1704 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -2898,10 +2898,12 @@ static netdev_tx_t myri10ge_sw_tso(struct sk_buff *skb,
 {
 	struct sk_buff *segs, *curr, *next;
 	struct myri10ge_priv *mgp = netdev_priv(dev);
+	netdev_features_t features = dev->features;
 	struct myri10ge_slice_state *ss;
 	netdev_tx_t status;
 
-	segs = skb_gso_segment(skb, dev->features & ~NETIF_F_TSO6);
+	features &= ~NETIF_F_TSO6;
+	segs = skb_gso_segment(skb, features);
 	if (IS_ERR(segs))
 		goto drop;
 
diff --git a/drivers/net/ethernet/sfc/siena/tx_common.c b/drivers/net/ethernet/sfc/siena/tx_common.c
index 93a32d61944f..60c7b72be822 100644
--- a/drivers/net/ethernet/sfc/siena/tx_common.c
+++ b/drivers/net/ethernet/sfc/siena/tx_common.c
@@ -433,7 +433,7 @@ int efx_siena_tx_tso_fallback(struct efx_tx_queue *tx_queue,
 {
 	struct sk_buff *segments, *next;
 
-	segments = skb_gso_segment(skb, 0);
+	segments = skb_gso_segment(skb, netdev_empty_features);
 	if (IS_ERR(segments))
 		return PTR_ERR(segments);
 
diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
index 67e789b96c43..4d0c4d3a2231 100644
--- a/drivers/net/ethernet/sfc/tx_common.c
+++ b/drivers/net/ethernet/sfc/tx_common.c
@@ -450,7 +450,7 @@ int efx_tx_tso_fallback(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
 {
 	struct sk_buff *segments, *next;
 
-	segments = skb_gso_segment(skb, 0);
+	segments = skb_gso_segment(skb, netdev_empty_features);
 	if (IS_ERR(segments))
 		return PTR_ERR(segments);
 
diff --git a/drivers/net/ethernet/sun/sunvnet_common.c b/drivers/net/ethernet/sun/sunvnet_common.c
index 80fde5f06fce..f8aced92d2a9 100644
--- a/drivers/net/ethernet/sun/sunvnet_common.c
+++ b/drivers/net/ethernet/sun/sunvnet_common.c
@@ -1228,6 +1228,7 @@ vnet_handle_offloads(struct vnet_port *port, struct sk_buff *skb,
 	int status;
 	int gso_size, gso_type, gso_segs;
 	int hlen = skb_transport_header(skb) - skb_mac_header(skb);
+	netedv_features_t features = dev->features;
 	int proto = IPPROTO_IP;
 
 	if (skb->protocol == htons(ETH_P_IP))
@@ -1274,7 +1275,8 @@ vnet_handle_offloads(struct vnet_port *port, struct sk_buff *skb,
 		skb_shinfo(skb)->gso_size = datalen;
 		skb_shinfo(skb)->gso_segs = gso_segs;
 	}
-	segs = skb_gso_segment(skb, dev->features & ~NETIF_F_TSO);
+	features &= ~NETIF_F_TSO;
+	segs = skb_gso_segment(skb, features);
 	if (IS_ERR(segs))
 		goto out_dropped;
 
diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index aeed694110d4..f78f910e113e 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -175,7 +175,7 @@ static netdev_tx_t wg_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (!skb_is_gso(skb)) {
 		skb_mark_not_on_list(skb);
 	} else {
-		struct sk_buff *segs = skb_gso_segment(skb, 0);
+		struct sk_buff *segs = skb_gso_segment(skb, netdev_empty_features);
 
 		if (IS_ERR(segs)) {
 			ret = PTR_ERR(segs);
diff --git a/net/core/dev.c b/net/core/dev.c
index 101a9d63d2fc..7a57d8b4f307 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3395,10 +3395,11 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 	 * work.
 	 */
 	if (features & NETIF_F_GSO_PARTIAL) {
-		netdev_features_t partial_features = NETIF_F_GSO_ROBUST;
+		netdev_features_t partial_features;
 		struct net_device *dev = skb->dev;
 
-		partial_features |= dev->features & dev->gso_partial_features;
+		partial_features = dev->features & dev->gso_partial_features;
+		partial_features |= NETIF_F_GSO_ROBUST;
 		if (!skb_gso_ok(skb, features | partial_features))
 			features &= ~NETIF_F_GSO_PARTIAL;
 	}
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 30abde86db45..3f3c158a5ac5 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -82,7 +82,8 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 	if (unlikely(skb->len <= mss))
 		goto out;
 
-	if (skb_gso_ok(skb, features | NETIF_F_GSO_ROBUST)) {
+	features |= NETIF_F_GSO_ROBUST;
+	if (skb_gso_ok(skb, features)) {
 		/* Packet is from an untrusted source, reset gso_segs. */
 
 		skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(skb->len, mss);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 45df9932d0ba..c8753e61e76e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4168,7 +4168,7 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 	if (skb_is_gso(skb)) {
 		struct sk_buff *segs;
 
-		segs = skb_gso_segment(skb, 0);
+		segs = skb_gso_segment(skb, netdev_empty_features);
 		if (IS_ERR(segs)) {
 			goto out_free;
 		} else if (segs) {
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 87a9009d5234..40d95d227805 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -812,7 +812,7 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 		return __nfqnl_enqueue_packet(net, queue, entry);
 
 	nf_bridge_adjust_skb_data(skb);
-	segs = skb_gso_segment(skb, 0);
+	segs = skb_gso_segment(skb, netdev_empty_features);
 	/* Does not use PTR_ERR to limit the number of error codes that can be
 	 * returned by nf_queue.  For instance, callers rely on -ESRCH to
 	 * mean 'ignore this hook'.
diff --git a/net/nsh/nsh.c b/net/nsh/nsh.c
index e9ca007718b7..ba98ac8e31c8 100644
--- a/net/nsh/nsh.c
+++ b/net/nsh/nsh.c
@@ -76,6 +76,7 @@ EXPORT_SYMBOL_GPL(nsh_pop);
 static struct sk_buff *nsh_gso_segment(struct sk_buff *skb,
 				       netdev_features_t features)
 {
+	netdev_features_t tmp = netdev_empty_features;
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	unsigned int nsh_len, mac_len;
 	__be16 proto;
@@ -104,7 +105,8 @@ static struct sk_buff *nsh_gso_segment(struct sk_buff *skb,
 	skb->mac_len = proto == htons(ETH_P_TEB) ? ETH_HLEN : 0;
 	skb->protocol = proto;
 
-	features &= NETIF_F_SG;
+	tmp |= NETIF_F_SG;
+	features &= tmp;
 	segs = skb_mac_gso_segment(skb, features);
 	if (IS_ERR_OR_NULL(segs)) {
 		skb_gso_error_unwind(skb, htons(ETH_P_NSH), nsh_len,
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 7e8a39a35627..0780c418a971 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -318,13 +318,15 @@ static int queue_gso_packets(struct datapath *dp, struct sk_buff *skb,
 			     const struct dp_upcall_info *upcall_info,
 			     uint32_t cutlen)
 {
+	netdev_features_t features = netdev_empty_features;
 	unsigned int gso_type = skb_shinfo(skb)->gso_type;
 	struct sw_flow_key later_key;
 	struct sk_buff *segs, *nskb;
 	int err;
 
 	BUILD_BUG_ON(sizeof(*OVS_CB(skb)) > SKB_GSO_CB_OFFSET);
-	segs = __skb_gso_segment(skb, NETIF_F_SG, false);
+	features |= NETIF_F_SG;
+	segs = __skb_gso_segment(skb, features, false);
 	if (IS_ERR(segs))
 		return PTR_ERR(segs);
 	if (segs == NULL)
diff --git a/net/sctp/offload.c b/net/sctp/offload.c
index eb874e3c399a..1433fcc0977d 100644
--- a/net/sctp/offload.c
+++ b/net/sctp/offload.c
@@ -39,6 +39,7 @@ static struct sk_buff *sctp_gso_segment(struct sk_buff *skb,
 					netdev_features_t features)
 {
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
+	netdev_features_t tmp = features;
 	struct sctphdr *sh;
 
 	if (!skb_is_gso_sctp(skb))
@@ -50,7 +51,8 @@ static struct sk_buff *sctp_gso_segment(struct sk_buff *skb,
 
 	__skb_pull(skb, sizeof(*sh));
 
-	if (skb_gso_ok(skb, features | NETIF_F_GSO_ROBUST)) {
+	tmp |= NETIF_F_GSO_ROBUST;
+	if (skb_gso_ok(skb, tmp)) {
 		/* Packet is from an untrusted source, reset gso_segs. */
 		struct skb_shared_info *pinfo = skb_shinfo(skb);
 		struct sk_buff *frag_iter;
@@ -68,7 +70,10 @@ static struct sk_buff *sctp_gso_segment(struct sk_buff *skb,
 		goto out;
 	}
 
-	segs = skb_segment(skb, (features | NETIF_F_HW_CSUM) & ~NETIF_F_SG);
+	tmp = features;
+	tmp |= NETIF_F_HW_CSUM;
+	tmp &= ~NETIF_F_SG;
+	segs = skb_segment(skb, tmp);
 	if (IS_ERR(segs))
 		goto out;
 
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 637ca8838436..96ffd287ae9a 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -138,7 +138,8 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 		struct sk_buff *segs;
 
 		/* Packet got rerouted, fixup features and segment it. */
-		esp_features = esp_features & ~(NETIF_F_HW_ESP | NETIF_F_GSO_ESP);
+		esp_features &= ~NETIF_F_HW_ESP;
+		esp_features &= ~NETIF_F_GSO_ESP;
 
 		segs = skb_gso_segment(skb, esp_features);
 		if (IS_ERR(segs)) {
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 555ab35cd119..85be950abae9 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -622,7 +622,7 @@ static int xfrm_output_gso(struct net *net, struct sock *sk, struct sk_buff *skb
 
 	BUILD_BUG_ON(sizeof(*IPCB(skb)) > SKB_GSO_CB_OFFSET);
 	BUILD_BUG_ON(sizeof(*IP6CB(skb)) > SKB_GSO_CB_OFFSET);
-	segs = skb_gso_segment(skb, 0);
+	segs = skb_gso_segment(skb, netdev_empty_features);
 	kfree_skb(skb);
 	if (IS_ERR(segs))
 		return PTR_ERR(segs);
-- 
2.33.0

