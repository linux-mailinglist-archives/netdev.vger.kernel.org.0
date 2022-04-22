Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC0A350BF90
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 20:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbiDVSM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 14:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237275AbiDVSGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 14:06:47 -0400
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C72C74A9;
        Fri, 22 Apr 2022 11:03:52 -0700 (PDT)
Received: from relay2-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::222])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id E14BDC3B70;
        Fri, 22 Apr 2022 18:03:35 +0000 (UTC)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 874E24000A;
        Fri, 22 Apr 2022 18:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650650595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3JC08cZE+VNj3BTHyjNtYZ6pb37MrGbgGzOGxJdRevQ=;
        b=iYvPTy5JGGsMZSmUu4ROU/+a5G0T0F0ogIXw6HukaSktm+bKMSBd4lY7fOJQpnKsT0PQlA
        Q0fUpPtNxdeXypCw1ThOPMA97qS0GCznn8FtGopIa9qcEAL/KapFK+/a8OxMQ+7dtLQsyP
        4VNnrVrbjt0vg4rwIOSfT5XTGIJZqr8Q7bEkw4hkIGLqBpA0C271xDKgSS7pZVyAoe8949
        WYh9pSJzrRFRTDnUCBqvo1SMP8ycdqrcxqM9bGI9TlztwH9Qol/XMlMd7u/Hbj6TaftPWx
        b2heQ4MQ7R/x9xVrgA0IAOgVft80kSGZMezwlR0yIeaDlhktV7QSgb6ZKSWiyA==
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
Subject: [PATCH net-next 3/5] net: ipqess: Add out-of-band DSA tagging support
Date:   Fri, 22 Apr 2022 20:03:03 +0200
Message-Id: <20220422180305.301882-4-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220422180305.301882-1-maxime.chevallier@bootlin.com>
References: <20220422180305.301882-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On the IPQ4019, there's an 5 ports switch connected to the CPU through
the IPQESS Ethernet controller. The way the DSA tag is sent-out to that
switch is through the DMA descriptor, due to how tightly it is
integrated with the switch.

This commit uses the out-of-band tagging protocol to get the outgoing
port index for each SKB, and reports it back in the skb->shinfo on the
RX side based on information located in the descriptor.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/ethernet/qualcomm/ipqess/ipqess.c | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/qualcomm/ipqess/ipqess.c b/drivers/net/ethernet/qualcomm/ipqess/ipqess.c
index 4ecb8c65417b..32a5cdd1c063 100644
--- a/drivers/net/ethernet/qualcomm/ipqess/ipqess.c
+++ b/drivers/net/ethernet/qualcomm/ipqess/ipqess.c
@@ -20,6 +20,7 @@
 #include <linux/skbuff.h>
 #include <linux/vmalloc.h>
 #include <net/checksum.h>
+#include <net/dsa.h>
 #include <net/ip6_checksum.h>
 
 #include "ipqess.h"
@@ -399,6 +400,11 @@ static int ipqess_rx_poll(struct ipqess_rx_ring *rx_ring, int budget)
 		skb->protocol = eth_type_trans(skb, rx_ring->ess->netdev);
 		skb_record_rx_queue(skb, rx_ring->ring_id);
 
+		if (netdev_uses_dsa(rx_ring->ess->netdev)) {
+			skb_shinfo(skb)->dsa_tag_info.dp =
+				FIELD_GET(IPQESS_RRD_PORT_ID_MASK, rd->rrd1);
+		}
+
 		if (rd->rrd6 & IPQESS_RRD_CSUM_FAIL_MASK)
 			skb_checksum_none_assert(skb);
 		else
@@ -706,6 +712,21 @@ static void ipqess_rollback_tx(struct ipqess *eth,
 	tx_ring->head = start_index;
 }
 
+static void ipqess_process_dsa_tag_sh(struct ipqess *ess, struct sk_buff *skb,
+				      u32 *word3)
+{
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
+	struct dsa_tag_info *tag_info = &shinfo->dsa_tag_info;
+
+	if (!netdev_uses_dsa(ess->netdev) ||
+	    tag_info->proto != DSA_TAG_PROTO_OOB)
+		return;
+
+	*word3 |= tag_info->dp << IPQESS_TPD_PORT_BITMAP_SHIFT;
+	*word3 |= BIT(IPQESS_TPD_FROM_CPU_SHIFT);
+	*word3 |= 0x3e << IPQESS_TPD_PORT_BITMAP_SHIFT;
+}
+
 static int ipqess_tx_map_and_fill(struct ipqess_tx_ring *tx_ring,
 				  struct sk_buff *skb)
 {
@@ -716,6 +737,8 @@ static int ipqess_tx_map_and_fill(struct ipqess_tx_ring *tx_ring,
 	u16 len;
 	int i;
 
+	ipqess_process_dsa_tag_sh(tx_ring->ess, skb, &word3);
+
 	if (skb_is_gso(skb)) {
 		if (skb_shinfo(skb)->gso_type & SKB_GSO_TCPV4) {
 			lso_word1 |= IPQESS_TPD_IPV4_EN;
-- 
2.35.1

