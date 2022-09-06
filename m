Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463BA5ADEF0
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 07:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbiIFFVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 01:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiIFFVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 01:21:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E426CF65
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 22:21:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46B2AB81623
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 05:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3918C433D7;
        Tue,  6 Sep 2022 05:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662441700;
        bh=2owWQWjWtfde5EdVR7Zzq8JF1ma5aDEiLVXu5NZRtO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IhrAWH/yf0rfDKYYOsqhcokOxcEpaLYeQ5+QOp3WrBmR0sAHYrALJH88ofu0r68Ri
         ExzxSDhTZCqx8NvSnpFclW3Nd9UFsT5XSHtnd2ZRJth4OJ5GcO/GP929FQJ+oHITlt
         cPwEbv6lTjjUffuLmv94OfRuCi2h6oRmb/AnMNKBNcBsm7kl9442ZXzB5WXBHtnXXO
         cuUE16UDmxCm0wibyqJqfeIH50krTMLJXAWHzrDaS9XuKyjT+aI8KZz9OO6IIl++sb
         immjgC5160B3HtoSdrkftO31rwkGnDXuxI7rL87nqJ8QagAgc7+XZSyIspMYnplKC+
         PKr2w+G9S2DPQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next V2 01/17] net/macsec: Add MACsec skb_metadata_dst Tx Data path support
Date:   Mon,  5 Sep 2022 22:21:13 -0700
Message-Id: <20220906052129.104507-2-saeed@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220906052129.104507-1-saeed@kernel.org>
References: <20220906052129.104507-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lior Nahmanson <liorna@nvidia.com>

In the current MACsec offload implementation, MACsec interfaces shares
the same MAC address by default.
Therefore, HW can't distinguish from which MACsec interface the traffic
originated from.

MACsec stack will use skb_metadata_dst to store the SCI value, which is
unique per Macsec interface, skb_metadat_dst will be used by the
offloading device driver to associate the SKB with the corresponding
offloaded interface (SCI).

Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/macsec.c       | 15 +++++++++++++++
 include/net/dst_metadata.h | 10 ++++++++++
 include/net/macsec.h       |  4 ++++
 3 files changed, 29 insertions(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index adf448a8162b..c190dc019717 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -18,6 +18,7 @@
 #include <net/sock.h>
 #include <net/gro_cells.h>
 #include <net/macsec.h>
+#include <net/dst_metadata.h>
 #include <linux/phy.h>
 #include <linux/byteorder/generic.h>
 #include <linux/if_arp.h>
@@ -3416,6 +3417,11 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
 	int ret, len;
 
 	if (macsec_is_offloaded(netdev_priv(dev))) {
+		struct metadata_dst *md_dst = secy->tx_sc.md_dst;
+
+		skb_dst_drop(skb);
+		dst_hold(&md_dst->dst);
+		skb_dst_set(skb, &md_dst->dst);
 		skb->dev = macsec->real_dev;
 		return dev_queue_xmit(skb);
 	}
@@ -3743,6 +3749,7 @@ static void macsec_free_netdev(struct net_device *dev)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
 
+	metadata_dst_free(macsec->secy.tx_sc.md_dst);
 	free_percpu(macsec->stats);
 	free_percpu(macsec->secy.tx_sc.stats);
 
@@ -4015,6 +4022,13 @@ static int macsec_add_dev(struct net_device *dev, sci_t sci, u8 icv_len)
 		return -ENOMEM;
 	}
 
+	secy->tx_sc.md_dst = metadata_dst_alloc(0, METADATA_MACSEC, GFP_KERNEL);
+	if (!secy->tx_sc.md_dst) {
+		free_percpu(secy->tx_sc.stats);
+		free_percpu(macsec->stats);
+		return -ENOMEM;
+	}
+
 	if (sci == MACSEC_UNDEF_SCI)
 		sci = dev_to_sci(dev, MACSEC_PORT_ES);
 
@@ -4028,6 +4042,7 @@ static int macsec_add_dev(struct net_device *dev, sci_t sci, u8 icv_len)
 	secy->xpn = DEFAULT_XPN;
 
 	secy->sci = sci;
+	secy->tx_sc.md_dst->u.macsec_info.sci = sci;
 	secy->tx_sc.active = true;
 	secy->tx_sc.encoding_sa = DEFAULT_ENCODING_SA;
 	secy->tx_sc.encrypt = DEFAULT_ENCRYPT;
diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index adab27ba1ecb..22a6924bf6da 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -4,11 +4,13 @@
 
 #include <linux/skbuff.h>
 #include <net/ip_tunnels.h>
+#include <net/macsec.h>
 #include <net/dst.h>
 
 enum metadata_type {
 	METADATA_IP_TUNNEL,
 	METADATA_HW_PORT_MUX,
+	METADATA_MACSEC,
 };
 
 struct hw_port_info {
@@ -16,12 +18,17 @@ struct hw_port_info {
 	u32 port_id;
 };
 
+struct macsec_info {
+	sci_t sci;
+};
+
 struct metadata_dst {
 	struct dst_entry		dst;
 	enum metadata_type		type;
 	union {
 		struct ip_tunnel_info	tun_info;
 		struct hw_port_info	port_info;
+		struct macsec_info	macsec_info;
 	} u;
 };
 
@@ -82,6 +89,9 @@ static inline int skb_metadata_dst_cmp(const struct sk_buff *skb_a,
 		return memcmp(&a->u.tun_info, &b->u.tun_info,
 			      sizeof(a->u.tun_info) +
 					 a->u.tun_info.options_len);
+	case METADATA_MACSEC:
+		return memcmp(&a->u.macsec_info, &b->u.macsec_info,
+			      sizeof(a->u.macsec_info));
 	default:
 		return 1;
 	}
diff --git a/include/net/macsec.h b/include/net/macsec.h
index 73780aa73644..8494953fb0de 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -19,6 +19,8 @@
 typedef u64 __bitwise sci_t;
 typedef u32 __bitwise ssci_t;
 
+struct metadata_dst;
+
 typedef union salt {
 	struct {
 		u32 ssci;
@@ -182,6 +184,7 @@ struct macsec_tx_sa {
  * @scb: single copy broadcast flag
  * @sa: array of secure associations
  * @stats: stats for this TXSC
+ * @md_dst: MACsec offload metadata dst
  */
 struct macsec_tx_sc {
 	bool active;
@@ -192,6 +195,7 @@ struct macsec_tx_sc {
 	bool scb;
 	struct macsec_tx_sa __rcu *sa[MACSEC_NUM_AN];
 	struct pcpu_tx_sc_stats __percpu *stats;
+	struct metadata_dst *md_dst;
 };
 
 /**
-- 
2.37.2

