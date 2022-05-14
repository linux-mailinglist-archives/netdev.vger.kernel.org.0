Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20BE352726D
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 17:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233791AbiENPHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 11:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233760AbiENPHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 11:07:09 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767CCBFC;
        Sat, 14 May 2022 08:07:07 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id BB05FC000F;
        Sat, 14 May 2022 15:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652540826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ydoSh74ikRQ+KrSB6hvdSYJm/v/GZpAyytdCl5yEqRY=;
        b=k0GAgprS7wa+EVUxZi9Fkar5QEDvpnZQMZGdBwTEZ0SePJfnK9FpgtQQwy6gIXdEGahBCA
        3T3FrVCP6hEQBl3yqlBYZGvfUZSdQOTN8Kqo7fGl76NRUFHpvYRpotwYN1h0+qB1YMOano
        3347DStUc5TbmG6kg+SPG+vLad6UUrj/Cx/Os4rJ3NgphfGAVanED3mFXhlEaXIc5+QCb+
        8HK50F+cEuYkVXxn3ONo72o4nK5ar2ZSVPujvdBrDkfyIvaCEv8XHdJgNLgMho1eKEoikV
        iMfps8kPKSqztOO5sOiWBMRB0R1GIruhyOzRmQudL1yH9sQLiNuiehkVwqrE3Q==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
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
Subject: [PATCH net-next v2 3/5] net: ipqess: Add out-of-band DSA tagging support
Date:   Sat, 14 May 2022 17:06:54 +0200
Message-Id: <20220514150656.122108-4-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220514150656.122108-1-maxime.chevallier@bootlin.com>
References: <20220514150656.122108-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
V1->V2:
 - Use the new tagger, and the dsa_oob_tag_* helpers

 drivers/net/ethernet/qualcomm/Kconfig         |  3 ++-
 drivers/net/ethernet/qualcomm/ipqess/ipqess.c | 27 +++++++++++++++++++
 2 files changed, 29 insertions(+), 1 deletion(-)

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
index b11f11f23c11..a068dff19943 100644
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
@@ -334,6 +336,7 @@ static int ipqess_rx_poll(struct ipqess_rx_ring *rx_ring, int budget)
 	tail &= IPQESS_RFD_CONS_IDX_MASK;
 
 	while (done < budget) {
+		struct dsa_oob_tag_info tag_info;
 		struct ipqess_rx_desc *rd;
 		struct sk_buff *skb;
 
@@ -413,6 +416,12 @@ static int ipqess_rx_poll(struct ipqess_rx_ring *rx_ring, int budget)
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021AD),
 					       rd->rrd4);
 
+		if (netdev_uses_dsa(rx_ring->ess->netdev)) {
+			tag_info.dp = FIELD_GET(IPQESS_RRD_PORT_ID_MASK, rd->rrd1);
+			tag_info.proto = DSA_TAG_PROTO_OOB;
+			dsa_oob_tag_push(skb, &tag_info);
+		}
+
 		napi_gro_receive(&rx_ring->napi_rx, skb);
 
 		rx_ring->ess->stats.rx_packets++;
@@ -727,6 +736,22 @@ static void ipqess_rollback_tx(struct ipqess *eth,
 	tx_ring->head = start_index;
 }
 
+static void ipqess_process_dsa_tag_sh(struct ipqess *ess, struct sk_buff *skb,
+				      u32 *word3)
+{
+	struct dsa_oob_tag_info tag_info;
+
+	if (!netdev_uses_dsa(ess->netdev))
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
@@ -737,6 +762,8 @@ static int ipqess_tx_map_and_fill(struct ipqess_tx_ring *tx_ring,
 	u16 len;
 	int i;
 
+	ipqess_process_dsa_tag_sh(tx_ring->ess, skb, &word3);
+
 	if (skb_is_gso(skb)) {
 		if (skb_shinfo(skb)->gso_type & SKB_GSO_TCPV4) {
 			lso_word1 |= IPQESS_TPD_IPV4_EN;
-- 
2.36.1

