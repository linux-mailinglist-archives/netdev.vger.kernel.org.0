Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC63262B38
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 23:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404869AbfGHVxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 17:53:20 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34772 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732730AbfGHVxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 17:53:19 -0400
Received: by mail-pl1-f193.google.com with SMTP id i2so8954692plt.1
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 14:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4O5aspyx5OimyGxeX8eb3B1GAEIT/6+xSCbV71+CSM8=;
        b=M9d4MrNUiKklhfwS8SuAj4pRj4BjdD9NYlbgkYnH8O+UaIslzLi0F9zIgDcyPgV4SQ
         ANPBLGjzg/Yfn5E3sWaNnEL+EQpQgMEehqiC/TYkO0BofMgmdlNNwgdQjX28pd3/yV3p
         OWEhwJ+LoYrQQANGq90zCruFPaUvJf7e1z7LM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4O5aspyx5OimyGxeX8eb3B1GAEIT/6+xSCbV71+CSM8=;
        b=FjIv+HdI9CatB3FAicuPI7cnG7zjcnEVSM7L1Csk9T0UPNsH23odcWLNdXIiERZnY/
         WUgFsWhwXxe2Wcembe2nFSEVkabrO9uiTFiVkXGtHTFtkmJtIRmQhrzySgbEOnYmRsR3
         BWX6Y7mPAuV8PuGd9TbArHCILDpojoOQUtS0l/GtQfQdb5qMF6oW1eRHlKhXs+3D/gGP
         HuT42z9s+uSQB/5zOUPYh3auaX9oz/gJ3W3yCi/kBlVrjWKf8LxuRJFRV3QPIEPoKtFy
         UvMucZ97Fhd4FJkTY9+RVnybWayNZ46wAq7MDVBlkHlEBUidGgoCwIMsrN1iRWIB16N9
         I3Rg==
X-Gm-Message-State: APjAAAWy+hrdGkgzooE5mF6M2F/F24IwoPgloTKrXGOOdq3lt1WTpmAs
        iyi111wShtlaPo6nbuM1G7DyLg==
X-Google-Smtp-Source: APXvYqxBGxvIuSVnxt8Vrh66KoQuUdU85229V4zyJGs8tfrf37KCFiFESdekHv2tOfG3p1uv6zQSiA==
X-Received: by 2002:a17:902:b70c:: with SMTP id d12mr26633533pls.314.1562622798218;
        Mon, 08 Jul 2019 14:53:18 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x9sm11352157pfn.177.2019.07.08.14.53.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 14:53:17 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net, gospo@broadcom.com
Cc:     netdev@vger.kernel.org, hawk@kernel.org, ast@kernel.org,
        ilias.apalodimas@linaro.org
Subject: [PATCH net-next v2 2/4] bnxt_en: Refactor __bnxt_xmit_xdp().
Date:   Mon,  8 Jul 2019 17:53:02 -0400
Message-Id: <1562622784-29918-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562622784-29918-1-git-send-email-michael.chan@broadcom.com>
References: <1562622784-29918-1-git-send-email-michael.chan@broadcom.com>
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

