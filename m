Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D84C5B3BD7
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 17:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbiIIPZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 11:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232369AbiIIPZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 11:25:16 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1721491C4;
        Fri,  9 Sep 2022 08:25:10 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B083EFF809;
        Fri,  9 Sep 2022 15:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1662737109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V8wwhQrCmgpjbSaLVlROy+ILWKKLSXmxcfxd4i466SE=;
        b=dCKetW+yu50tuNbo47NEL685F6HCbO8rlj0fiyfrPvqDDg0lV1FxIMq/TfJMTgUaNUf4wa
        DTmSNIAXkqApE4HZ1oDF2CWLeZCsGZIgqIAYq+F5BpJUOVE2aGz9mB4p+kw3FGHB4CBlb8
        7AjS9tDqpN613k2dUVXZlK8JwHJmp6c/9yrxGsfWvXGXQW7ZYRVluhTgQB26OdtOBLOhfj
        mXMv8zNCV9KcPsPHXsWIr3syw+y9NSiWNv1h4mxzSIpb/+dwKeqV/7TWcwUmMmdOUZsgML
        VC+VQggZ2ARamepwcL5GFReBSXoW3Zb4i0UQVB04b7iD9lOpZgdf3n64KMAUEg==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH net-next v4 3/5] net: ipqess: Add out-of-band DSA tagging support
Date:   Fri,  9 Sep 2022 17:24:52 +0200
Message-Id: <20220909152454.7462-4-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220909152454.7462-1-maxime.chevallier@bootlin.com>
References: <20220909152454.7462-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On the IPQ4019, there's an 5 ports switch connected to the CPU through
the IPQESS Ethernet controller. The way the DSA tag is sent-out to that
switch is through the DMA descriptor, due to how tightly it is
integrated with the switch.

This commit uses the out-of-band tagging protocol by getting the source
port from the descriptor, push it into the skb, and have the tagger pull
it to infer the destination netdev. The reverse process is done on the
TX side, where the driver pulls the tag from the skb and builds the
descriptor accordingly.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
V3->V4:
 - No changes
V2->V3:
 - No changes
V1->V2:
 - Use the new tagger, and the dsa_oob_tag_* helpers


 drivers/net/ethernet/qualcomm/Kconfig         |  3 +-
 drivers/net/ethernet/qualcomm/ipqess/ipqess.c | 56 ++++++++++++++++++-
 drivers/net/ethernet/qualcomm/ipqess/ipqess.h |  4 ++
 3 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/Kconfig b/drivers/net/ethernet/qualcomm/Kconfig
index a723ddbea248..eeb2c608d6b9 100644
--- a/drivers/net/ethernet/qualcomm/Kconfig
+++ b/drivers/net/ethernet/qualcomm/Kconfig
@@ -62,8 +62,9 @@ config QCOM_EMAC
 
 config QCOM_IPQ4019_ESS_EDMA
 	tristate "Qualcomm Atheros IPQ4019 ESS EDMA support"
-	depends on OF
+	depends on OF && NET_DSA
 	select PHYLINK
+	select NET_DSA_TAG_OOB
 	help
 	  This driver supports the Qualcomm Atheros IPQ40xx built-in
 	  ESS EDMA ethernet controller.
diff --git a/drivers/net/ethernet/qualcomm/ipqess/ipqess.c b/drivers/net/ethernet/qualcomm/ipqess/ipqess.c
index 4caa2dd3e8b1..26d5856f1276 100644
--- a/drivers/net/ethernet/qualcomm/ipqess/ipqess.c
+++ b/drivers/net/ethernet/qualcomm/ipqess/ipqess.c
@@ -9,6 +9,7 @@
 
 #include <linux/bitfield.h>
 #include <linux/clk.h>
+#include <linux/dsa/oob.h>
 #include <linux/if_vlan.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
@@ -22,6 +23,7 @@
 #include <linux/skbuff.h>
 #include <linux/vmalloc.h>
 #include <net/checksum.h>
+#include <net/dsa.h>
 #include <net/ip6_checksum.h>
 
 #include "ipqess.h"
@@ -330,6 +332,7 @@ static int ipqess_rx_poll(struct ipqess_rx_ring *rx_ring, int budget)
 	tail &= IPQESS_RFD_CONS_IDX_MASK;
 
 	while (done < budget) {
+		struct dsa_oob_tag_info tag_info;
 		struct ipqess_rx_desc *rd;
 		struct sk_buff *skb;
 
@@ -409,6 +412,12 @@ static int ipqess_rx_poll(struct ipqess_rx_ring *rx_ring, int budget)
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021AD),
 					       rd->rrd4);
 
+		if (rx_ring->ess->uses_dsa) {
+			tag_info.dp = FIELD_GET(IPQESS_RRD_PORT_ID_MASK, rd->rrd1);
+			tag_info.proto = DSA_TAG_PROTO_OOB;
+			dsa_oob_tag_push(skb, &tag_info);
+		}
+
 		napi_gro_receive(&rx_ring->napi_rx, skb);
 
 		rx_ring->ess->stats.rx_packets++;
@@ -712,6 +721,22 @@ static void ipqess_rollback_tx(struct ipqess *eth,
 	tx_ring->head = start_index;
 }
 
+static void ipqess_process_dsa_tag_sh(struct ipqess *ess, struct sk_buff *skb,
+				      u32 *word3)
+{
+	struct dsa_oob_tag_info tag_info;
+
+	if (!ess->uses_dsa)
+		return;
+
+	if (dsa_oob_tag_pop(skb, &tag_info))
+		return;
+
+	*word3 |= tag_info.dp << IPQESS_TPD_PORT_BITMAP_SHIFT;
+	*word3 |= BIT(IPQESS_TPD_FROM_CPU_SHIFT);
+	*word3 |= 0x3e << IPQESS_TPD_PORT_BITMAP_SHIFT;
+}
+
 static int ipqess_tx_map_and_fill(struct ipqess_tx_ring *tx_ring,
 				  struct sk_buff *skb)
 {
@@ -722,6 +747,8 @@ static int ipqess_tx_map_and_fill(struct ipqess_tx_ring *tx_ring,
 	u16 len;
 	int i;
 
+	ipqess_process_dsa_tag_sh(tx_ring->ess, skb, &word3);
+
 	if (skb_is_gso(skb)) {
 		if (skb_shinfo(skb)->gso_type & SKB_GSO_TCPV4) {
 			lso_word1 |= IPQESS_TPD_IPV4_EN;
@@ -923,6 +950,26 @@ static const struct net_device_ops ipqess_axi_netdev_ops = {
 	.ndo_tx_timeout		= ipqess_tx_timeout,
 };
 
+static int ipqess_netdevice_event(struct notifier_block *nb,
+				  unsigned long event, void *ptr)
+{
+	struct ipqess *ess = container_of(nb, struct ipqess, netdev_notifier);
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+
+	if (ess->netdev != dev)
+		return NOTIFY_DONE;
+
+	switch (event) {
+	case NETDEV_CHANGEUPPER:
+		if (netdev_uses_dsa(ess->netdev))
+			ess->uses_dsa = true;
+		else
+			ess->uses_dsa = false;
+		return NOTIFY_DONE;
+	}
+	return NOTIFY_OK;
+}
+
 static void ipqess_hw_stop(struct ipqess *ess)
 {
 	int i;
@@ -1194,12 +1241,19 @@ static int ipqess_axi_probe(struct platform_device *pdev)
 			       64);
 	}
 
-	err = register_netdev(netdev);
+	ess->netdev_notifier.notifier_call = ipqess_netdevice_event;
+	err = register_netdevice_notifier(&ess->netdev_notifier);
 	if (err)
 		goto err_hw_stop;
 
+	err = register_netdev(netdev);
+	if (err)
+		goto err_notifier_unregister;
+
 	return 0;
 
+err_notifier_unregister:
+	unregister_netdevice_notifier(&ess->netdev_notifier);
 err_hw_stop:
 	ipqess_hw_stop(ess);
 
diff --git a/drivers/net/ethernet/qualcomm/ipqess/ipqess.h b/drivers/net/ethernet/qualcomm/ipqess/ipqess.h
index 9a4ab6ce282a..f21515df3ded 100644
--- a/drivers/net/ethernet/qualcomm/ipqess/ipqess.h
+++ b/drivers/net/ethernet/qualcomm/ipqess/ipqess.h
@@ -171,6 +171,10 @@ struct ipqess {
 	struct platform_device *pdev;
 	struct phylink *phylink;
 	struct phylink_config phylink_config;
+
+	struct notifier_block netdev_notifier;
+	bool uses_dsa;
+
 	struct ipqess_tx_ring tx_ring[IPQESS_NETDEV_QUEUES];
 
 	struct ipqess_statistics ipqess_stats;
-- 
2.37.2

