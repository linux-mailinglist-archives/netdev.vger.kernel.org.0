Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7620E123BF5
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 01:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfLRAva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 19:51:30 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34408 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfLRAv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 19:51:28 -0500
Received: by mail-pf1-f195.google.com with SMTP id l127so220821pfl.1;
        Tue, 17 Dec 2019 16:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UEz81YOfOgBDrXB7OBw3GPro4KGLJ3XN1bscFo4nSHA=;
        b=t97yb1vxXkG/djwdLbRKjohBeoTRhDeleTGCVfTIsT66NGa7/Hj6kggSMaDYkEkLZE
         gm0vNCjv9LrCx24Y+RcpcmWZgEgllgLic6S2qC1J54vgW+Ps2O/sGYXjVc5RBgig7rFq
         sRZZ828iU512CrFzwP2+7wCQVzkpiZ2AptC1kaNwoYmLtpiwvyzuwEWKR8Bwu1RLsxgr
         96ecoDCxx2yESbCKafJb9jI+phvMIMM0DRSPI850zIVsCFpPXwC9fEmBaKFuCf9ffIiA
         ZygVILRlS0om3jTk2eYfmVlR3XfhRZ0ibbfpEW+E2T445UcqfjK8erDFtUdTBH438OCE
         nMyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UEz81YOfOgBDrXB7OBw3GPro4KGLJ3XN1bscFo4nSHA=;
        b=bh+JNt2uNg36v0vFWQHImM7kRnzYJ8+v5wyEfeZpPePfwidejxeGI18QsBtsHh+BNE
         Jb8lZxVDA5okG6Oa9ZEtI2kCo2Ypd8vaYNoJ8mT7sLcEIIL9ppVznh28p6MFaODTxsKh
         wAYMzaiJwSBu6QlmNsB7uj1EU/qyXA+yZ85w4uLb5vDJMNbYR7dpUFQqZioi2sfMEymM
         3LFTlSvvgmUyjGjfFT0s25f9OOTp4SxhR/ddkTgBiuS6IAT8WuYtA9Zni/EeWuHmsXjl
         FvWkUpTRE/jPlLHXxh4E51YIjvyrgOxXDYa/Gx2Ftd4ztsgbhDoOWu5BLQacJfr+xlL9
         Xm1g==
X-Gm-Message-State: APjAAAVDwdm0BhgD1wseD0Y8V+VxT7kcQ4yqB3hXanQbU8PoHPvITxxP
        xpi56nrgeOmIKAr2nG61IJk=
X-Google-Smtp-Source: APXvYqy1SksUaSH0FAzwZ+sGR52I7r4GRshE/GnUS0YdrVHXPt78pgU4IGx7cz0x/uA2W5uOwCGQKA==
X-Received: by 2002:a62:1c88:: with SMTP id c130mr668902pfc.195.1576630288050;
        Tue, 17 Dec 2019 16:51:28 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 81sm274819pfx.30.2019.12.17.16.51.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 16:51:27 -0800 (PST)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next v2 2/8] net: bcmgenet: enable NETIF_F_HW_CSUM feature
Date:   Tue, 17 Dec 2019 16:51:09 -0800
Message-Id: <1576630275-17591-3-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576630275-17591-1-git-send-email-opendmb@gmail.com>
References: <1576630275-17591-1-git-send-email-opendmb@gmail.com>
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

