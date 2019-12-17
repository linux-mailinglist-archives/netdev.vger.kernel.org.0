Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDEE12382C
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbfLQVDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:03:25 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37110 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbfLQVDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:03:24 -0500
Received: by mail-wr1-f67.google.com with SMTP id w15so12870668wru.4;
        Tue, 17 Dec 2019 13:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NP+Ttt9H3Ex0HBO5rDc8Vmumcq1LoDHKpxYSLTwm1P0=;
        b=NsZ6qiSCk+Z0J0Or9c6jYCMK5yMn2LzlesEWp/9oKIUaym28dH+2omB2g3Jn7G0G4b
         Dq8TzJm8zcp+uHfM7e2dmjMN44ixOx6vl1RjJ216dzRBQCsis6+KKEiy4m4tmLA4QtLu
         xNk1ZFYHjIm6O7lVBXWnSeBqUYY6YDgJhlBysiJDGTSxIrLwQVUFrd3KhskDkPYHEzKh
         1b7WW2xL+5mRS/b92z89O+/vXjc7IrL+FG93cjeE36x3zkezYmZiDwaMnhF/bHCUS2RP
         GeuACJduejzSf1ec8un6gG/UDd+5c8I7kBDsYvw6ypbsB0E9rB5z8fjvDEshlaYZr46l
         0s2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NP+Ttt9H3Ex0HBO5rDc8Vmumcq1LoDHKpxYSLTwm1P0=;
        b=a/9HVdZVFWZZDxj9+pq1hFukrfpgGN6hVOwidwr3+P+sohkS6uX6gcOwTNCJKU7KuM
         cQnJ4WoEv4yRfZX49NPRLZa+OMPxuzRH52zitsuMULCrIGwHwgs3iYPQrVEs8uJ1m6Jj
         nISeInroNsmJDx6jtc18VjTmn7sltqFCyEerpR+u8EgZeOAN2iB7G9AcbBfGMaldGwGu
         ULJvagJXeB2XGiJyA1dGc7rBVuICVDZOzXqO4N64Y+7Vtt8iaEk7Hi9ydHfyMjhG3uWb
         2UaumAiT7VrGFKlkhN2rd86BKiULkUCxoVtOT74WHz0TVGrGZpNkVlX+ml5uNw0y0rPA
         DuFg==
X-Gm-Message-State: APjAAAWYKSj6+zGtgpEY3AR4jg1UlAougQEzuZwyCXikpGyle09e2MKo
        8bbDuFYOUdSTRAX5Pzd9K64KnMBt
X-Google-Smtp-Source: APXvYqwTl5T93JBbBujZpQbJJ87DKzF3MndmVunsjotBOKrFeCBbWfmP5Pz+VPaD44oRAqDS/xVenw==
X-Received: by 2002:adf:f103:: with SMTP id r3mr38126416wro.295.1576616602771;
        Tue, 17 Dec 2019 13:03:22 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i5sm37856wml.31.2019.12.17.13.03.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 13:03:22 -0800 (PST)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next 3/8] net: bcmgenet: use CHECKSUM_COMPLETE for NETIF_F_RXCSUM
Date:   Tue, 17 Dec 2019 13:02:24 -0800
Message-Id: <1576616549-39097-4-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576616549-39097-1-git-send-email-opendmb@gmail.com>
References: <1576616549-39097-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit updates the Rx checksum offload behavior of the driver
to use the more generic CHECKSUM_COMPLETE method that supports all
protocols over the CHECKSUM_UNNECESSARY method that only applies
to some protocols known by the hardware.

This behavior is perceived to be superior.

Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 13 +++++--------
 drivers/net/ethernet/broadcom/genet/bcmgenet.h |  1 +
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index cd07b3ad1d53..5674dc304032 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -521,7 +521,7 @@ static int bcmgenet_set_rx_csum(struct net_device *dev,
 
 	/* enable rx checksumming */
 	if (rx_csum_en)
-		rbuf_chk_ctrl |= RBUF_RXCHK_EN;
+		rbuf_chk_ctrl |= RBUF_RXCHK_EN | RBUF_L3_PARSE_DIS;
 	else
 		rbuf_chk_ctrl &= ~RBUF_RXCHK_EN;
 	priv->desc_rxchk_en = rx_csum_en;
@@ -1739,7 +1739,6 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
 	unsigned int bytes_processed = 0;
 	unsigned int p_index, mask;
 	unsigned int discards;
-	unsigned int chksum_ok = 0;
 
 	/* Clear status before servicing to reduce spurious interrupts */
 	if (ring->index == DESC_INDEX) {
@@ -1793,6 +1792,10 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
 
 			status = (struct status_64 *)skb->data;
 			dma_length_status = status->length_status;
+			if (priv->desc_rxchk_en) {
+				skb->csum = ntohs(status->rx_csum & 0xffff);
+				skb->ip_summed = CHECKSUM_COMPLETE;
+			}
 		}
 
 		/* DMA flags and length are still valid no matter how
@@ -1835,18 +1838,12 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
 			goto next;
 		} /* error packet */
 
-		chksum_ok = (dma_flag & priv->dma_rx_chk_bit) &&
-			     priv->desc_rxchk_en;
-
 		skb_put(skb, len);
 		if (priv->desc_64b_en) {
 			skb_pull(skb, 64);
 			len -= 64;
 		}
 
-		if (likely(chksum_ok))
-			skb->ip_summed = CHECKSUM_UNNECESSARY;
-
 		/* remove hardware 2bytes added for IP alignment */
 		skb_pull(skb, 2);
 		len -= 2;
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index a5659197598f..11645cccc207 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -251,6 +251,7 @@ struct bcmgenet_mib_counters {
 #define RBUF_CHK_CTRL			0x14
 #define  RBUF_RXCHK_EN			(1 << 0)
 #define  RBUF_SKIP_FCS			(1 << 4)
+#define  RBUF_L3_PARSE_DIS		(1 << 5)
 
 #define RBUF_ENERGY_CTRL		0x9c
 #define  RBUF_EEE_EN			(1 << 0)
-- 
2.7.4

