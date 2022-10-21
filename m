Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F0360773B
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 14:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiJUMqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 08:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiJUMqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 08:46:14 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780AE2623F5;
        Fri, 21 Oct 2022 05:46:08 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 109686000D;
        Fri, 21 Oct 2022 12:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666356367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BWIttCv+dbZStcHkYFj6C9jesdq+NfZgxdYYVY+DyQE=;
        b=UQqwCn0w/AMNqvp07Brxwiha8rElG8QmG8kFbI3hzELVXtFzMeTBK+vbAJfB9jWCevqkh7
        nw0mreAp34M41F5k5XGTkJvAgvU0NLrP9ebjtHNFBvbYP38OuDqZ2A983aroJ1PbJF8glK
        2+CKpaGUx1i05BmYyifVCToXMjWv/2JKhNj32pCGDoVxXHdP45xL4HPOVjJrY9RVO5X03Y
        JOV6BP4rtrQaSAJ/8+4Vc2KrnVoW5sYesBwj5HhMkAENv7Lo+bHTJBrmUT4Q6EMMYG+GxV
        kkc7N3NRx9iNuOEwdyseMp27NTKSZKK5euXJUBNEwlCfutudg2n+jLawysSUaA==
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
Subject: [PATCH net-next v5 4/5] net: ipqess: Add out-of-band DSA tagging support
Date:   Fri, 21 Oct 2022 14:45:55 +0200
Message-Id: <20221021124556.100445-5-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221021124556.100445-1-maxime.chevallier@bootlin.com>
References: <20221021124556.100445-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On the IPQ4019, there's an 5 ports switch connected to the CPU through
the IPQESS Ethernet controller. The way the DSA tag is sent-out to that
switch is through the DMA descriptor, due to how tightly it is
integrated with the switch.

We use the out-of-band tagging protocol by getting the source
port from the descriptor, push it into the skb extensions, and have the
tagger pull it to infer the destination netdev. The reverse process is
done on the TX side, where the driver pulls the tag from the skb and
builds the descriptor accordingly.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
V4->V5:
 - Rework the CHANGEUPPER event handling
V3->V4:
 - No changes
V2->V3:
 - No changes
V1->V2:
 - Use the new tagger, and the dsa_oob_tag_* helpers
 drivers/net/ethernet/qualcomm/Kconfig         |  3 +-
 drivers/net/ethernet/qualcomm/ipqess/ipqess.c | 63 ++++++++++++++++++-
 drivers/net/ethernet/qualcomm/ipqess/ipqess.h |  4 ++
 3 files changed, 68 insertions(+), 2 deletions(-)

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
index b23e7d776cd0..8e24e599f9be 100644
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
 
+		if (rx_ring->ess->dsa_ports) {
+			tag_info.dp = FIELD_GET(IPQESS_RRD_PORT_ID_MASK, rd->rrd1);
+			tag_info.proto = DSA_TAG_PROTO_OOB;
+			dsa_oob_tag_push(skb, &tag_info);
+		}
+
 		napi_gro_receive(&rx_ring->napi_rx, skb);
 
 		rx_ring->ess->stats.rx_packets++;
@@ -709,6 +718,22 @@ static void ipqess_rollback_tx(struct ipqess *eth,
 	tx_ring->head = start_index;
 }
 
+static void ipqess_process_dsa_tag_sh(struct ipqess *ess, struct sk_buff *skb,
+				      u32 *word3)
+{
+	struct dsa_oob_tag_info tag_info;
+
+	if (!ess->dsa_ports)
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
@@ -719,6 +744,8 @@ static int ipqess_tx_map_and_fill(struct ipqess_tx_ring *tx_ring,
 	u16 len;
 	int i;
 
+	ipqess_process_dsa_tag_sh(tx_ring->ess, skb, &word3);
+
 	if (skb_is_gso(skb)) {
 		if (skb_shinfo(skb)->gso_type & SKB_GSO_TCPV4) {
 			lso_word1 |= IPQESS_TPD_IPV4_EN;
@@ -920,6 +947,33 @@ static const struct net_device_ops ipqess_axi_netdev_ops = {
 	.ndo_tx_timeout		= ipqess_tx_timeout,
 };
 
+static int ipqess_netdevice_event(struct notifier_block *nb,
+				  unsigned long event, void *ptr)
+{
+	struct ipqess *ess = container_of(nb, struct ipqess, netdev_notifier);
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct netdev_notifier_changeupper_info *info;
+
+	switch (event) {
+	case NETDEV_CHANGEUPPER:
+		info = ptr;
+
+		if (dev->netdev_ops != &ipqess_axi_netdev_ops)
+			return NOTIFY_DONE;
+
+		if (!dsa_slave_dev_check(info->upper_dev))
+			return NOTIFY_DONE;
+
+		if (info->linking)
+			ess->dsa_ports++;
+		else
+			ess->dsa_ports--;
+
+		return NOTIFY_DONE;
+	}
+	return NOTIFY_OK;
+}
+
 static void ipqess_hw_stop(struct ipqess *ess)
 {
 	int i;
@@ -1201,12 +1255,19 @@ static int ipqess_axi_probe(struct platform_device *pdev)
 		netif_napi_add(netdev, &ess->rx_ring[i].napi_rx, ipqess_rx_napi);
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
index 9a4ab6ce282a..33cccaf6f143 100644
--- a/drivers/net/ethernet/qualcomm/ipqess/ipqess.h
+++ b/drivers/net/ethernet/qualcomm/ipqess/ipqess.h
@@ -171,6 +171,10 @@ struct ipqess {
 	struct platform_device *pdev;
 	struct phylink *phylink;
 	struct phylink_config phylink_config;
+
+	struct notifier_block netdev_notifier;
+	int dsa_ports;
+
 	struct ipqess_tx_ring tx_ring[IPQESS_NETDEV_QUEUES];
 
 	struct ipqess_statistics ipqess_stats;
-- 
2.37.3

