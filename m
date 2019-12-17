Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CED8123830
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbfLQVDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:03:23 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38766 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727906AbfLQVDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:03:22 -0500
Received: by mail-wr1-f68.google.com with SMTP id y17so12834201wrh.5;
        Tue, 17 Dec 2019 13:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UEz81YOfOgBDrXB7OBw3GPro4KGLJ3XN1bscFo4nSHA=;
        b=UW7u8lc4UrnlQsYqvTM5O8wp4aApvF3HHuSPVVE8kShJFzS9keNU+nrzSJ/OIakMz7
         fCrtDfUlR1zsDjKHEIpaVvTNeM3vjeypRhfqoKgIHZ2gTcqzrhFCN9tqiKsZFAtxLS6T
         h8Z2uh3tmJTwO6zMVd5R/k65XLu+Nav5giW9RrR84PT6KD8qcfvm5YzgyzC20naOrRb5
         AHrMMr5+D/m5l81BkzXcmZqnfTMrViHbyjCFdeHM+7D8BCCxel0sXOzzQ0WCv25XcVcG
         jXBV1E9s5D5Wjy/7XoCmLLTgVX68T7ucxh+yo2aztUUQ/dvzLUvfDMwHdXrGhyr0KKB6
         EyQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UEz81YOfOgBDrXB7OBw3GPro4KGLJ3XN1bscFo4nSHA=;
        b=LXErbKSA4RmbMJ1BKYKI0hvhRZMZJJW9PP4tDy5o1BywPiY1Pqxe0DfIbblyBK5vQ/
         DhU+YqfedgLhYOdull+erHwFmQlYH5GcrjDim/QyB2yx0037zH3d1CZoAbb6+dwAph0L
         kP5R+qKUdtb4BgyItj+9mt3/pJH2et+aobnfiFdFiv8VlasemWlX39s8D6VWZ5yQ0Dd2
         QnaqsOa2zUPUy8wcpa280Ty+pbyCnwrxB7a7L8qLU4dpSWyrsYaESr8bLaBaLuFsYbO7
         KSg+PNEuqvgZlkZeKiBK62DOG8clijrq80pij4xG0AO7c4SqEX/mTwNbYyTK5bojxjha
         GHDw==
X-Gm-Message-State: APjAAAU6GV67p56s0scNgirpQgAYhD03KOhYu5bFopetz+AmbiqzuBfl
        uwYzKqt7aD3ygxdmqiBzEXg=
X-Google-Smtp-Source: APXvYqwkOwdxPepwdqVfFroGEWL76TWFApWlfrJJioALoFLCcNgqmUhPw1gYUlzqbe8/6KUp+pULmg==
X-Received: by 2002:adf:bc87:: with SMTP id g7mr40599814wrh.121.1576616600781;
        Tue, 17 Dec 2019 13:03:20 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i5sm37856wml.31.2019.12.17.13.03.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 13:03:20 -0800 (PST)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next 2/8] net: bcmgenet: enable NETIF_F_HW_CSUM feature
Date:   Tue, 17 Dec 2019 13:02:23 -0800
Message-Id: <1576616549-39097-3-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576616549-39097-1-git-send-email-opendmb@gmail.com>
References: <1576616549-39097-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GENET hardware should be capable of generating IP checksums
using the NETIF_F_HW_CSUM feature, so switch to using that feature
instead of the depricated NETIF_F_IP_CSUM and NETIF_F_IPV6_CSUM.

Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 29 +++++++++++---------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index d9defb8b1e5f..cd07b3ad1d53 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -549,7 +549,7 @@ static int bcmgenet_set_tx_csum(struct net_device *dev,
 	tbuf_ctrl = bcmgenet_tbuf_ctrl_get(priv);
 	rbuf_ctrl = bcmgenet_rbuf_readl(priv, RBUF_CTRL);
 
-	desc_64b_en = !!(wanted & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM));
+	desc_64b_en = !!(wanted & NETIF_F_HW_CSUM);
 
 	/* enable 64 bytes descriptor in both directions (RBUF and TBUF) */
 	if (desc_64b_en) {
@@ -574,7 +574,7 @@ static int bcmgenet_set_features(struct net_device *dev,
 	netdev_features_t wanted = dev->wanted_features;
 	int ret = 0;
 
-	if (changed & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM))
+	if (changed & NETIF_F_HW_CSUM)
 		ret = bcmgenet_set_tx_csum(dev, wanted);
 	if (changed & (NETIF_F_RXCSUM))
 		ret = bcmgenet_set_rx_csum(dev, wanted);
@@ -1516,24 +1516,19 @@ static struct sk_buff *bcmgenet_put_tx_csum(struct net_device *dev,
 			ip_proto = ipv6_hdr(skb)->nexthdr;
 			break;
 		default:
-			return skb;
+			/* don't use UDP flag */
+			ip_proto = 0;
+			break;
 		}
 
 		offset = skb_checksum_start_offset(skb) - sizeof(*status);
 		tx_csum_info = (offset << STATUS_TX_CSUM_START_SHIFT) |
-				(offset + skb->csum_offset);
+				(offset + skb->csum_offset) |
+				STATUS_TX_CSUM_LV;
 
-		/* Set the length valid bit for TCP and UDP and just set
-		 * the special UDP flag for IPv4, else just set to 0.
-		 */
-		if (ip_proto == IPPROTO_TCP || ip_proto == IPPROTO_UDP) {
-			tx_csum_info |= STATUS_TX_CSUM_LV;
-			if (ip_proto == IPPROTO_UDP &&
-			    ip_ver == htons(ETH_P_IP))
-				tx_csum_info |= STATUS_TX_CSUM_PROTO_UDP;
-		} else {
-			tx_csum_info = 0;
-		}
+		/* Set the special UDP flag for UDP */
+		if (ip_proto == IPPROTO_UDP)
+			tx_csum_info |= STATUS_TX_CSUM_PROTO_UDP;
 
 		status->tx_csum_info = tx_csum_info;
 	}
@@ -3536,8 +3531,8 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	priv->msg_enable = netif_msg_init(-1, GENET_MSG_DEFAULT);
 
 	/* Set hardware features */
-	dev->hw_features |= NETIF_F_SG | NETIF_F_IP_CSUM |
-		NETIF_F_IPV6_CSUM | NETIF_F_HIGHDMA | NETIF_F_RXCSUM;
+	dev->hw_features |= NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_HW_CSUM |
+		NETIF_F_RXCSUM;
 
 	/* Request the WOL interrupt and advertise suspend if available */
 	priv->wol_irq_disabled = true;
-- 
2.7.4

