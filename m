Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDBE271E24
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 10:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbgIUIjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 04:39:24 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:20078 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgIUIjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 04:39:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600677563; x=1632213563;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5A41ukSj9aF1KvKQoPIyJzfST6U+Ky+PgDpifhLqQ20=;
  b=KC1Lbae8HD6dALD9qmNPyyxzcqrQuZfWTHInOpkJJ/1RpJF6jzYTEVIN
   1TvGEls8vtBPl3upBTRR/wG9hHZphqHyCx08e1ckP1ANrhU6VjNrZkj6m
   IO260flONkSou55kYX3axFH0rv+Fk3BNEpLmMYYOEJZ5WQfJZHSOKTzzR
   w=;
X-IronPort-AV: E=Sophos;i="5.77,286,1596499200"; 
   d="scan'208";a="55015137"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 21 Sep 2020 08:39:22 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id 328E9A187D;
        Mon, 21 Sep 2020 08:39:21 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.162.38) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 21 Sep 2020 08:39:12 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>, Ido Segev <idose@amazon.com>
Subject: [PATCH V2 net-next 6/7] net: ena: Fix all static chekers' warnings
Date:   Mon, 21 Sep 2020 11:37:41 +0300
Message-ID: <20200921083742.6454-7-shayagr@amazon.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921083742.6454-1-shayagr@amazon.com>
References: <20200921083742.6454-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.38]
X-ClientProxiedBy: EX13D31UWC003.ant.amazon.com (10.43.162.34) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After running Sparse checker on the driver using
    make C=1 M=drivers/net/ethernet/amazon/ena

the only error that is thrown is:
    sparse: sparse: Using plain integer as NULL pointer
about the line
    struct ena_calc_queue_size_ctx calc_queue_ctx = { 0 };

This patch fixes this warning, thus making our driver free (for now) of
Sparse errors/warnings.

To make a more complete work, this patch also fixes all static warnings
that were found using an internal static checker.

Signed-off-by: Ido Segev <idose@amazon.com>
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c     |  2 ++
 drivers/net/ethernet/amazon/ena/ena_eth_com.c | 17 ++++++++++-------
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  2 +-
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 2e2366d406f6..34434c6b6000 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -513,6 +513,8 @@ static int ena_com_comp_status_to_errno(u8 comp_status)
 	case ENA_ADMIN_ILLEGAL_PARAMETER:
 	case ENA_ADMIN_UNKNOWN_ERROR:
 		return -EINVAL;
+	case ENA_ADMIN_RESOURCE_BUSY:
+		return -EAGAIN;
 	}
 
 	return -EINVAL;
diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.c b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
index 8abaf3cbb5b9..ad30cacc1622 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
@@ -266,6 +266,9 @@ static int ena_com_create_meta(struct ena_com_io_sq *io_sq,
 	struct ena_eth_io_tx_meta_desc *meta_desc = NULL;
 
 	meta_desc = get_sq_desc(io_sq);
+	if (unlikely(!meta_desc))
+		return -EFAULT;
+
 	memset(meta_desc, 0x0, sizeof(struct ena_eth_io_tx_meta_desc));
 
 	meta_desc->len_ctrl |= ENA_ETH_IO_TX_META_DESC_META_DESC_MASK;
@@ -273,7 +276,7 @@ static int ena_com_create_meta(struct ena_com_io_sq *io_sq,
 	meta_desc->len_ctrl |= ENA_ETH_IO_TX_META_DESC_EXT_VALID_MASK;
 
 	/* bits 0-9 of the mss */
-	meta_desc->word2 |= (ena_meta->mss <<
+	meta_desc->word2 |= ((u32)ena_meta->mss <<
 		ENA_ETH_IO_TX_META_DESC_MSS_LO_SHIFT) &
 		ENA_ETH_IO_TX_META_DESC_MSS_LO_MASK;
 	/* bits 10-13 of the mss */
@@ -283,7 +286,7 @@ static int ena_com_create_meta(struct ena_com_io_sq *io_sq,
 
 	/* Extended meta desc */
 	meta_desc->len_ctrl |= ENA_ETH_IO_TX_META_DESC_ETH_META_TYPE_MASK;
-	meta_desc->len_ctrl |= (io_sq->phase <<
+	meta_desc->len_ctrl |= ((u32)io_sq->phase <<
 		ENA_ETH_IO_TX_META_DESC_PHASE_SHIFT) &
 		ENA_ETH_IO_TX_META_DESC_PHASE_MASK;
 
@@ -296,7 +299,7 @@ static int ena_com_create_meta(struct ena_com_io_sq *io_sq,
 		ENA_ETH_IO_TX_META_DESC_L3_HDR_OFF_SHIFT) &
 		ENA_ETH_IO_TX_META_DESC_L3_HDR_OFF_MASK;
 
-	meta_desc->word2 |= (ena_meta->l4_hdr_len <<
+	meta_desc->word2 |= ((u32)ena_meta->l4_hdr_len <<
 		ENA_ETH_IO_TX_META_DESC_L4_HDR_LEN_IN_WORDS_SHIFT) &
 		ENA_ETH_IO_TX_META_DESC_L4_HDR_LEN_IN_WORDS_MASK;
 
@@ -422,16 +425,16 @@ int ena_com_prepare_tx(struct ena_com_io_sq *io_sq,
 	if (!have_meta)
 		desc->len_ctrl |= ENA_ETH_IO_TX_DESC_FIRST_MASK;
 
-	desc->buff_addr_hi_hdr_sz |= (header_len <<
+	desc->buff_addr_hi_hdr_sz |= ((u32)header_len <<
 		ENA_ETH_IO_TX_DESC_HEADER_LENGTH_SHIFT) &
 		ENA_ETH_IO_TX_DESC_HEADER_LENGTH_MASK;
-	desc->len_ctrl |= (io_sq->phase << ENA_ETH_IO_TX_DESC_PHASE_SHIFT) &
+	desc->len_ctrl |= ((u32)io_sq->phase << ENA_ETH_IO_TX_DESC_PHASE_SHIFT) &
 		ENA_ETH_IO_TX_DESC_PHASE_MASK;
 
 	desc->len_ctrl |= ENA_ETH_IO_TX_DESC_COMP_REQ_MASK;
 
 	/* Bits 0-9 */
-	desc->meta_ctrl |= (ena_tx_ctx->req_id <<
+	desc->meta_ctrl |= ((u32)ena_tx_ctx->req_id <<
 		ENA_ETH_IO_TX_DESC_REQ_ID_LO_SHIFT) &
 		ENA_ETH_IO_TX_DESC_REQ_ID_LO_MASK;
 
@@ -477,7 +480,7 @@ int ena_com_prepare_tx(struct ena_com_io_sq *io_sq,
 
 			memset(desc, 0x0, sizeof(struct ena_eth_io_tx_desc));
 
-			desc->len_ctrl |= (io_sq->phase <<
+			desc->len_ctrl |= ((u32)io_sq->phase <<
 				ENA_ETH_IO_TX_DESC_PHASE_SHIFT) &
 				ENA_ETH_IO_TX_DESC_PHASE_MASK;
 		}
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 97e701222226..e8131dadc22c 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4149,7 +4149,7 @@ static int ena_calc_io_queue_size(struct ena_calc_queue_size_ctx *ctx)
  */
 static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	struct ena_calc_queue_size_ctx calc_queue_ctx = { 0 };
+	struct ena_calc_queue_size_ctx calc_queue_ctx = {};
 	struct ena_com_dev_get_features_ctx get_feat_ctx;
 	struct ena_com_dev *ena_dev = NULL;
 	struct ena_adapter *adapter;
-- 
2.17.1

