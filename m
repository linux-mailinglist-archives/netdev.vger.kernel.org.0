Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48BCB60F52
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 09:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbfGFHgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 03:36:48 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44692 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfGFHgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 03:36:48 -0400
Received: by mail-pl1-f195.google.com with SMTP id t14so2536351plr.11
        for <netdev@vger.kernel.org>; Sat, 06 Jul 2019 00:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4O5aspyx5OimyGxeX8eb3B1GAEIT/6+xSCbV71+CSM8=;
        b=ZCMCuI0/qgihDpkTEZhNnF4n0xBMsafmPVqrlvHQi8I5EFUKcZncbCivHP8ZSVuF8p
         8YaXQkccsvatzld5326SS10qXqzzbScx73S+MiL3NdoJXlgTtmA/aFuRtFDlBrSgQOOF
         gkeEIz8zugdgQNakZHrHm3lZw7QLoYwvjNsq4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4O5aspyx5OimyGxeX8eb3B1GAEIT/6+xSCbV71+CSM8=;
        b=j8vEgvtYRUmv66n6zpXCihfEq99kFq1XzKKpqS2Hn9ioAPfx3vxDbHtMB7kixKgt8P
         kq/PUvT9PozPqFDigTe/QmGlt8FY/sUIPqHzAWLcqScY961jMsIPPAyTqadUVczVtufm
         +6Y5lPSTc2wOT11m7Zb8AOtg0chAtcLkO3wXUod89fhGm62paHvzjZNeJn5VKQTR/3Zb
         J6fF53Gy/9qd+QIksp+JE1y8rop4SkrB2Lmj1ZRqBaiHeoNWEpK39719KxVkJgURKzGZ
         vjNV9vQk7WPhtwH/4C/UbXT2ubhIwq8bi5MBLNqlHJ+tmSKIclPWulJFUsOBTofIBshf
         eO2Q==
X-Gm-Message-State: APjAAAU6wdf2miVVTCqagdmnqAljPP0SCfQPEWuZ4M6KzL1+x0Lq5cWm
        KIzZG7h7eatcsdHzqKoNW+LJ30d/QV4=
X-Google-Smtp-Source: APXvYqyPcNBxuVK4IOunJqaVEZYnmxoJw5EJaJygUG9EaYhhv6ihJjPLuR1FT+fQoCxZafR5XBU+1g==
X-Received: by 2002:a17:902:ba8b:: with SMTP id k11mr10095738pls.107.1562398607126;
        Sat, 06 Jul 2019 00:36:47 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a10sm1520144pfc.162.2019.07.06.00.36.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Jul 2019 00:36:46 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net, gospo@broadcom.com
Cc:     netdev@vger.kernel.org, hawk@kernel.org, ast@kernel.org
Subject: [PATCH net-next 2/4] bnxt_en: Refactor __bnxt_xmit_xdp().
Date:   Sat,  6 Jul 2019 03:36:16 -0400
Message-Id: <1562398578-26020-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562398578-26020-1-git-send-email-michael.chan@broadcom.com>
References: <1562398578-26020-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__bnxt_xmit_xdp() is used by XDP_TX and ethtool loopback packet transmit.
Refactor it so that it can be re-used by the XDP_REDIRECT logic.
Restructure the TX interrupt handler logic to cleanly separate XDP_TX
logic in preparation for XDP_REDIRECT.

Acked-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c     | 33 ++++++++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h     |  5 ++--
 4 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 4b3ae92..bf12cfc 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -596,6 +596,7 @@ struct bnxt_sw_tx_bd {
 	DEFINE_DMA_UNMAP_ADDR(mapping);
 	u8			is_gso;
 	u8			is_push;
+	u8			action;
 	union {
 		unsigned short		nr_frags;
 		u16			rx_prod;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 21a0431..a0f3277 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2799,7 +2799,7 @@ static int bnxt_run_loopback(struct bnxt *bp)
 		dev_kfree_skb(skb);
 		return -EIO;
 	}
-	__bnxt_xmit_xdp(bp, txr, map, pkt_size, 0);
+	bnxt_xmit_bd(bp, txr, map, pkt_size);
 
 	/* Sync BD data before updating doorbell */
 	wmb();
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 4bc9595..41e232e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -19,8 +19,9 @@
 #include "bnxt.h"
 #include "bnxt_xdp.h"
 
-void __bnxt_xmit_xdp(struct bnxt *bp, struct bnxt_tx_ring_info *txr,
-		     dma_addr_t mapping, u32 len, u16 rx_prod)
+struct bnxt_sw_tx_bd *bnxt_xmit_bd(struct bnxt *bp,
+				   struct bnxt_tx_ring_info *txr,
+				   dma_addr_t mapping, u32 len)
 {
 	struct bnxt_sw_tx_bd *tx_buf;
 	struct tx_bd *txbd;
@@ -29,7 +30,6 @@ void __bnxt_xmit_xdp(struct bnxt *bp, struct bnxt_tx_ring_info *txr,
 
 	prod = txr->tx_prod;
 	tx_buf = &txr->tx_buf_ring[prod];
-	tx_buf->rx_prod = rx_prod;
 
 	txbd = &txr->tx_desc_ring[TX_RING(prod)][TX_IDX(prod)];
 	flags = (len << TX_BD_LEN_SHIFT) | (1 << TX_BD_FLAGS_BD_CNT_SHIFT) |
@@ -40,30 +40,43 @@ void __bnxt_xmit_xdp(struct bnxt *bp, struct bnxt_tx_ring_info *txr,
 
 	prod = NEXT_TX(prod);
 	txr->tx_prod = prod;
+	return tx_buf;
+}
+
+static void __bnxt_xmit_xdp(struct bnxt *bp, struct bnxt_tx_ring_info *txr,
+			    dma_addr_t mapping, u32 len, u16 rx_prod)
+{
+	struct bnxt_sw_tx_bd *tx_buf;
+
+	tx_buf = bnxt_xmit_bd(bp, txr, mapping, len);
+	tx_buf->rx_prod = rx_prod;
+	tx_buf->action = XDP_TX;
 }
 
 void bnxt_tx_int_xdp(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 {
 	struct bnxt_tx_ring_info *txr = bnapi->tx_ring;
 	struct bnxt_rx_ring_info *rxr = bnapi->rx_ring;
+	bool rx_doorbell_needed = false;
 	struct bnxt_sw_tx_bd *tx_buf;
 	u16 tx_cons = txr->tx_cons;
 	u16 last_tx_cons = tx_cons;
-	u16 rx_prod;
 	int i;
 
 	for (i = 0; i < nr_pkts; i++) {
-		last_tx_cons = tx_cons;
+		tx_buf = &txr->tx_buf_ring[tx_cons];
+
+		if (tx_buf->action == XDP_TX) {
+			rx_doorbell_needed = true;
+			last_tx_cons = tx_cons;
+		}
 		tx_cons = NEXT_TX(tx_cons);
 	}
 	txr->tx_cons = tx_cons;
-	if (bnxt_tx_avail(bp, txr) == bp->tx_ring_size) {
-		rx_prod = rxr->rx_prod;
-	} else {
+	if (rx_doorbell_needed) {
 		tx_buf = &txr->tx_buf_ring[last_tx_cons];
-		rx_prod = tx_buf->rx_prod;
+		bnxt_db_write(bp, &rxr->rx_db, tx_buf->rx_prod);
 	}
-	bnxt_db_write(bp, &rxr->rx_db, rx_prod);
 }
 
 /* returns the following:
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
index b36087b..20e470c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
@@ -10,8 +10,9 @@
 #ifndef BNXT_XDP_H
 #define BNXT_XDP_H
 
-void __bnxt_xmit_xdp(struct bnxt *bp, struct bnxt_tx_ring_info *txr,
-		     dma_addr_t mapping, u32 len, u16 rx_prod);
+struct bnxt_sw_tx_bd *bnxt_xmit_bd(struct bnxt *bp,
+				   struct bnxt_tx_ring_info *txr,
+				   dma_addr_t mapping, u32 len);
 void bnxt_tx_int_xdp(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts);
 bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 		 struct page *page, u8 **data_ptr, unsigned int *len,
-- 
2.5.1

