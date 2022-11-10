Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0D5624CDC
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 22:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbiKJVWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 16:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbiKJVWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 16:22:33 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986AE31DFD;
        Thu, 10 Nov 2022 13:22:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CtmGvO+Y27LomRwiSBbwQG3+4u8RGeKxNxvjoDf6oK0=; b=qR6c6Ftx4P7oFmkPrhdd+peSoP
        BxtW50Whwo8o809uTCr9IIfuR9gXdcXwuFV1Ss47zVkVXdFuJCpCcEe0i9rxQZJkOJVNPTfeWnNA0
        3ouYXYqmJe6cexCLB0AHJvd8gAGCZoNk65YQstBtkrfnUVQoJyxqaoBzaO8/BO3gBDj4=;
Received: from p200300daa72ee10c199752172ce6dd7a.dip0.t-ipconnect.de ([2003:da:a72e:e10c:1997:5217:2ce6:dd7a] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1otF05-0011Om-UX; Thu, 10 Nov 2022 22:22:18 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 4/4] net: ethernet: mtk_eth_soc: enable hardware DSA untagging
Date:   Thu, 10 Nov 2022 22:22:11 +0100
Message-Id: <20221110212212.96825-5-nbd@nbd.name>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221110212212.96825-1-nbd@nbd.name>
References: <20221110212212.96825-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- pass the tag to DSA via metadata dst
- disabled on 7986 for now, since it's not working yet
- disabled if a MAC is enabled that does not use DSA

This improves performance by bypassing the DSA tag driver and avoiding extra
skb data mangling

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 66 ++++++++++++++++++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  8 +++
 2 files changed, 67 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index a118c715b09b..991ffa0b02f5 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -23,6 +23,7 @@
 #include <linux/jhash.h>
 #include <linux/bitfield.h>
 #include <net/dsa.h>
+#include <net/dst_metadata.h>
 
 #include "mtk_eth_soc.h"
 #include "mtk_wed.h"
@@ -1939,13 +1940,19 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 				__vlan_hwaccel_put_tag(skb, htons(RX_DMA_VPID(trxd.rxd3)),
 						       RX_DMA_VID(trxd.rxd3));
 			}
+		}
+
+		/* When using VLAN untagging in combination with DSA, the
+		 * hardware treats the MTK special tag as a VLAN and untags it.
+		 */
+		if (skb_vlan_tag_present(skb) && netdev_uses_dsa(netdev)) {
+			unsigned int port = ntohs(skb->vlan_proto) & GENMASK(2, 0);
 
-			/* If the device is attached to a dsa switch, the special
-			 * tag inserted in VLAN field by hw switch can * be offloaded
-			 * by RX HW VLAN offload. Clear vlan info.
-			 */
-			if (netdev_uses_dsa(netdev))
-				__vlan_hwaccel_clear_tag(skb);
+			if (port < ARRAY_SIZE(eth->dsa_meta) &&
+			    eth->dsa_meta[port])
+				skb_dst_set_noref(skb, &eth->dsa_meta[port]->dst);
+
+			__vlan_hwaccel_clear_tag(skb);
 		}
 
 		skb_record_rx_queue(skb, 0);
@@ -2990,11 +2997,46 @@ static void mtk_gdm_config(struct mtk_eth *eth, u32 config)
 	mtk_w32(eth, 0, MTK_RST_GL);
 }
 
+
+static bool mtk_uses_dsa(struct net_device *dev)
+{
+#if IS_ENABLED(CONFIG_NET_DSA)
+	return netdev_uses_dsa(dev) &&
+	       dev->dsa_ptr->tag_ops->proto == DSA_TAG_PROTO_MTK;
+#else
+	return false;
+#endif
+}
+
 static int mtk_open(struct net_device *dev)
 {
 	struct mtk_mac *mac = netdev_priv(dev);
 	struct mtk_eth *eth = mac->hw;
-	int err;
+	int i, err;
+
+	if (mtk_uses_dsa(dev)) {
+		for (i = 0; i < ARRAY_SIZE(eth->dsa_meta); i++) {
+			struct metadata_dst *md_dst = eth->dsa_meta[i];
+
+			if (md_dst)
+				continue;
+
+			md_dst = metadata_dst_alloc(0, METADATA_HW_PORT_MUX,
+						    GFP_KERNEL);
+			if (!md_dst)
+				return -ENOMEM;
+
+			md_dst->u.port_info.port_id = i;
+			eth->dsa_meta[i] = md_dst;
+		}
+	} else {
+		/* Hardware special tag parsing needs to be disabled if at least
+		 * one MAC does not use DSA.
+		 */
+		u32 val = mtk_r32(eth, MTK_CDMP_IG_CTRL);
+		val &= ~MTK_CDMP_STAG_EN;
+		mtk_w32(eth, val, MTK_CDMP_IG_CTRL);
+	}
 
 	err = phylink_of_phy_connect(mac->phylink, mac->of_node, 0);
 	if (err) {
@@ -3321,6 +3363,10 @@ static int mtk_hw_init(struct mtk_eth *eth)
 	 */
 	val = mtk_r32(eth, MTK_CDMQ_IG_CTRL);
 	mtk_w32(eth, val | MTK_CDMQ_STAG_EN, MTK_CDMQ_IG_CTRL);
+	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+		val = mtk_r32(eth, MTK_CDMP_IG_CTRL);
+		mtk_w32(eth, val | MTK_CDMP_STAG_EN, MTK_CDMP_IG_CTRL);
+	}
 
 	/* Enable RX VLan Offloading */
 	mtk_w32(eth, 1, MTK_CDMP_EG_CTRL);
@@ -3538,6 +3584,12 @@ static int mtk_free_dev(struct mtk_eth *eth)
 		free_netdev(eth->netdev[i]);
 	}
 
+	for (i = 0; i < ARRAY_SIZE(eth->dsa_meta); i++) {
+		if (!eth->dsa_meta[i])
+			break;
+		metadata_dst_free(eth->dsa_meta[i]);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 589f27ddc401..a572416e25de 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -22,6 +22,9 @@
 #include <linux/bpf_trace.h>
 #include "mtk_ppe.h"
 
+#define MTK_MAX_DSA_PORTS	7
+#define MTK_DSA_PORT_MASK	GENMASK(2, 0)
+
 #define MTK_QDMA_PAGE_SIZE	2048
 #define MTK_MAX_RX_LENGTH	1536
 #define MTK_MAX_RX_LENGTH_2K	2048
@@ -91,6 +94,9 @@
 #define MTK_CDMQ_IG_CTRL	0x1400
 #define MTK_CDMQ_STAG_EN	BIT(0)
 
+/* CDMQ Exgress Control Register */
+#define MTK_CDMQ_EG_CTRL	0x1404
+
 /* CDMP Ingress Control Register */
 #define MTK_CDMP_IG_CTRL	0x400
 #define MTK_CDMP_STAG_EN	BIT(0)
@@ -1121,6 +1127,8 @@ struct mtk_eth {
 
 	int				ip_align;
 
+	struct metadata_dst		*dsa_meta[MTK_MAX_DSA_PORTS];
+
 	struct mtk_ppe			*ppe[2];
 	struct rhashtable		flow_table;
 
-- 
2.38.1

