Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4BBC1247E9
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 14:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfLRNRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 08:17:38 -0500
Received: from alln-iport-8.cisco.com ([173.37.142.95]:58280 "EHLO
        alln-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbfLRNRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 08:17:38 -0500
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Dec 2019 08:17:38 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=7026; q=dns/txt; s=iport;
  t=1576675058; x=1577884658;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=F3cDQIADnWNpBJp8ht9AXIzCzHOG3ebhsjj61ZykWjk=;
  b=YtRSN7VKe2woX5vQGQou4TNGBID8xacMJLUIdZzvMkms6dST7ySyYHor
   g9Ol/L6rxUYCAGad+0CV02TCiR6Hpupqb9ReOKbKk5N5Y9YGBNRZ6fQjy
   2sRilbaD79iDagWrnrc+luNFLu6U0KtpTY6+jwnRt5WMOnAzutdC9zVXp
   o=;
X-IronPort-AV: E=Sophos;i="5.69,329,1571702400"; 
   d="scan'208";a="395326752"
Received: from rcdn-core-2.cisco.com ([173.37.93.153])
  by alln-iport-8.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 18 Dec 2019 13:17:37 +0000
Received: from sjc-ads-7483.cisco.com (sjc-ads-7483.cisco.com [10.30.221.19])
        by rcdn-core-2.cisco.com (8.15.2/8.15.2) with ESMTP id xBIDHbQ9017077;
        Wed, 18 Dec 2019 13:17:37 GMT
Received: by sjc-ads-7483.cisco.com (Postfix, from userid 838444)
        id E5952159D; Wed, 18 Dec 2019 05:17:36 -0800 (PST)
From:   Aviraj CJ <acj@cisco.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xe-linux-external@cisco.com,
        acj@cisco.com
Subject: [PATCH stable v4.14 1/2] net: stmmac: use correct DMA buffer size in the RX descriptor
Date:   Wed, 18 Dec 2019 05:17:19 -0800
Message-Id: <20191218131720.12270-1-acj@cisco.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Outbound-SMTP-Client: 10.30.221.19, sjc-ads-7483.cisco.com
X-Outbound-Node: rcdn-core-2.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

upstream 583e6361414903c5206258a30e5bd88cb03c0254 commit

We always program the maximum DMA buffer size into the receive descriptor,
although the allocated size may be less. E.g. with the default MTU size
we allocate only 1536 bytes. If somebody sends us a bigger frame, then
memory may get corrupted.

Program DMA using exact buffer sizes.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[acj: backport v4.14 -stable
- adjust context
- skipped the section modifying non-existent functions in dwxgmac2_descs.c and
hwif.h ]
Signed-off-by: Aviraj CJ <acj@cisco.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h  |  2 +-
 .../net/ethernet/stmicro/stmmac/descs_com.h   | 22 ++++++++++++-------
 .../ethernet/stmicro/stmmac/dwmac4_descs.c    |  2 +-
 .../net/ethernet/stmicro/stmmac/enh_desc.c    | 10 ++++++---
 .../net/ethernet/stmicro/stmmac/norm_desc.c   | 10 ++++++---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  8 ++++---
 6 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index d824bf942a8f..efc4a1a8343a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -367,7 +367,7 @@ struct dma_features {
 struct stmmac_desc_ops {
 	/* DMA RX descriptor ring initialization */
 	void (*init_rx_desc) (struct dma_desc *p, int disable_rx_ic, int mode,
-			      int end);
+			      int end, int bfsize);
 	/* DMA TX descriptor ring initialization */
 	void (*init_tx_desc) (struct dma_desc *p, int mode, int end);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/descs_com.h b/drivers/net/ethernet/stmicro/stmmac/descs_com.h
index 40d6356a7e73..3dfb07a78952 100644
--- a/drivers/net/ethernet/stmicro/stmmac/descs_com.h
+++ b/drivers/net/ethernet/stmicro/stmmac/descs_com.h
@@ -29,11 +29,13 @@
 /* Specific functions used for Ring mode */
 
 /* Enhanced descriptors */
-static inline void ehn_desc_rx_set_on_ring(struct dma_desc *p, int end)
+static inline void ehn_desc_rx_set_on_ring(struct dma_desc *p, int end,
+					   int bfsize)
 {
-	p->des1 |= cpu_to_le32((BUF_SIZE_8KiB
-			<< ERDES1_BUFFER2_SIZE_SHIFT)
-		   & ERDES1_BUFFER2_SIZE_MASK);
+	if (bfsize == BUF_SIZE_16KiB)
+		p->des1 |= cpu_to_le32((BUF_SIZE_8KiB
+				<< ERDES1_BUFFER2_SIZE_SHIFT)
+			   & ERDES1_BUFFER2_SIZE_MASK);
 
 	if (end)
 		p->des1 |= cpu_to_le32(ERDES1_END_RING);
@@ -59,11 +61,15 @@ static inline void enh_set_tx_desc_len_on_ring(struct dma_desc *p, int len)
 }
 
 /* Normal descriptors */
-static inline void ndesc_rx_set_on_ring(struct dma_desc *p, int end)
+static inline void ndesc_rx_set_on_ring(struct dma_desc *p, int end, int bfsize)
 {
-	p->des1 |= cpu_to_le32(((BUF_SIZE_2KiB - 1)
-				<< RDES1_BUFFER2_SIZE_SHIFT)
-		    & RDES1_BUFFER2_SIZE_MASK);
+	if (bfsize >= BUF_SIZE_2KiB) {
+		int bfsize2;
+
+		bfsize2 = min(bfsize - BUF_SIZE_2KiB + 1, BUF_SIZE_2KiB - 1);
+		p->des1 |= cpu_to_le32((bfsize2 << RDES1_BUFFER2_SIZE_SHIFT)
+			    & RDES1_BUFFER2_SIZE_MASK);
+	}
 
 	if (end)
 		p->des1 |= cpu_to_le32(RDES1_END_RING);
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
index 37b77e7da132..2896ec100c75 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
@@ -293,7 +293,7 @@ static int dwmac4_wrback_get_rx_timestamp_status(void *desc, void *next_desc,
 }
 
 static void dwmac4_rd_init_rx_desc(struct dma_desc *p, int disable_rx_ic,
-				   int mode, int end)
+				   int mode, int end, int bfsize)
 {
 	p->des3 = cpu_to_le32(RDES3_OWN | RDES3_BUFFER1_VALID_ADDR);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
index f2150efddc88..dfa6599ca1a7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
@@ -265,15 +265,19 @@ static int enh_desc_get_rx_status(void *data, struct stmmac_extra_stats *x,
 }
 
 static void enh_desc_init_rx_desc(struct dma_desc *p, int disable_rx_ic,
-				  int mode, int end)
+				  int mode, int end, int bfsize)
 {
+	int bfsize1;
+
 	p->des0 |= cpu_to_le32(RDES0_OWN);
-	p->des1 |= cpu_to_le32(BUF_SIZE_8KiB & ERDES1_BUFFER1_SIZE_MASK);
+
+	bfsize1 = min(bfsize, BUF_SIZE_8KiB);
+	p->des1 |= cpu_to_le32(bfsize1 & ERDES1_BUFFER1_SIZE_MASK);
 
 	if (mode == STMMAC_CHAIN_MODE)
 		ehn_desc_rx_set_on_chain(p);
 	else
-		ehn_desc_rx_set_on_ring(p, end);
+		ehn_desc_rx_set_on_ring(p, end, bfsize);
 
 	if (disable_rx_ic)
 		p->des1 |= cpu_to_le32(ERDES1_DISABLE_IC);
diff --git a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
index 66c17bab5997..44a4666290da 100644
--- a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
@@ -133,15 +133,19 @@ static int ndesc_get_rx_status(void *data, struct stmmac_extra_stats *x,
 }
 
 static void ndesc_init_rx_desc(struct dma_desc *p, int disable_rx_ic, int mode,
-			       int end)
+			       int end, int bfsize)
 {
+	int bfsize1;
+
 	p->des0 |= cpu_to_le32(RDES0_OWN);
-	p->des1 |= cpu_to_le32((BUF_SIZE_2KiB - 1) & RDES1_BUFFER1_SIZE_MASK);
+
+	bfsize1 = min(bfsize, BUF_SIZE_2KiB - 1);
+	p->des1 |= cpu_to_le32(bfsize1 & RDES1_BUFFER1_SIZE_MASK);
 
 	if (mode == STMMAC_CHAIN_MODE)
 		ndesc_rx_set_on_chain(p, end);
 	else
-		ndesc_rx_set_on_ring(p, end);
+		ndesc_rx_set_on_ring(p, end, bfsize);
 
 	if (disable_rx_ic)
 		p->des1 |= cpu_to_le32(RDES1_DISABLE_IC);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 612773b94ae3..da5b5fc99c04 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1072,11 +1072,13 @@ static void stmmac_clear_rx_descriptors(struct stmmac_priv *priv, u32 queue)
 		if (priv->extend_desc)
 			priv->hw->desc->init_rx_desc(&rx_q->dma_erx[i].basic,
 						     priv->use_riwt, priv->mode,
-						     (i == DMA_RX_SIZE - 1));
+						     (i == DMA_RX_SIZE - 1),
+						     priv->dma_buf_sz);
 		else
 			priv->hw->desc->init_rx_desc(&rx_q->dma_rx[i],
 						     priv->use_riwt, priv->mode,
-						     (i == DMA_RX_SIZE - 1));
+						     (i == DMA_RX_SIZE - 1),
+						     priv->dma_buf_sz);
 }
 
 /**
@@ -3299,7 +3301,7 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 		dma_wmb();
 
 		if (unlikely(priv->synopsys_id >= DWMAC_CORE_4_00))
-			priv->hw->desc->init_rx_desc(p, priv->use_riwt, 0, 0);
+			priv->hw->desc->init_rx_desc(p, priv->use_riwt, 0, 0, priv->dma_buf_sz);
 		else
 			priv->hw->desc->set_rx_owner(p);
 
-- 
2.19.1

