Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0FC118EB5
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfLJROO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:14:14 -0500
Received: from rcdn-iport-6.cisco.com ([173.37.86.77]:53962 "EHLO
        rcdn-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbfLJRON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:14:13 -0500
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Dec 2019 12:14:12 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=5523; q=dns/txt; s=iport;
  t=1575998052; x=1577207652;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eNVCvjZblmuoLfwPQjChR2q6aFn7eOlpCTR4qcOhLY8=;
  b=WyiCfv2M9qoL5ICkC5mwMuSNr6ItJlPOR3sIfuITKINUsC77UYBvKm+j
   pxvDpm/7t+lo9NicyvEx6F0K6M04ApbcEMlHg0v9+eADi+RfHTPSxQFaS
   I1mLsxJeirKzP8Uh20FXUGpgbxHQlsIxAfzCTR9p6d8D+xgV4dUrMlKKu
   Y=;
X-IronPort-AV: E=Sophos;i="5.69,300,1571702400"; 
   d="scan'208";a="682214336"
Received: from alln-core-10.cisco.com ([173.36.13.132])
  by rcdn-iport-6.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 10 Dec 2019 17:07:05 +0000
Received: from sjc-ads-7483.cisco.com (sjc-ads-7483.cisco.com [10.30.221.19])
        by alln-core-10.cisco.com (8.15.2/8.15.2) with ESMTP id xBAH747M030221;
        Tue, 10 Dec 2019 17:07:04 GMT
Received: by sjc-ads-7483.cisco.com (Postfix, from userid 838444)
        id C2BBD156D; Tue, 10 Dec 2019 09:07:03 -0800 (PST)
From:   Aviraj CJ <acj@cisco.com>
To:     peppe.cavallaro@st.com, netdev@vger.kernel.org,
        gregkh@linuxfoundation.org, xe-linux-external@cisco.com
Cc:     Aviraj CJ <acj@cisco.com>
Subject: [PATCH 1/2] net: stmmac: use correct DMA buffer size in the RX descriptor
Date:   Tue, 10 Dec 2019 09:06:58 -0800
Message-Id: <20191210170659.61829-1-acj@cisco.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Outbound-SMTP-Client: 10.30.221.19, sjc-ads-7483.cisco.com
X-Outbound-Node: alln-core-10.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We always program the maximum DMA buffer size into the receive descriptor,
although the allocated size may be less. E.g. with the default MTU size
we allocate only 1536 bytes. If somebody sends us a bigger frame, then
memory may get corrupted.

Program DMA using exact buffer sizes.

[Adopted based on upstream commit c13a936f46e3321ad2426443296571fab2feda44
("net: stmmac: use correct DMA buffer size in the RX descriptor")
by Aaro Koskinen <aaro.koskinen@nokia.com> ]

Signed-off-by: Aviraj CJ <acj@cisco.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h      |  2 +-
 drivers/net/ethernet/stmicro/stmmac/descs_com.h   | 14 ++++++++++----
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c    | 10 +++++++---
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c   | 10 +++++++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  4 ++--
 5 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 623c6ed8764a..803df6a32ba9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -301,7 +301,7 @@ struct dma_features {
 struct stmmac_desc_ops {
 	/* DMA RX descriptor ring initialization */
 	void (*init_rx_desc) (struct dma_desc *p, int disable_rx_ic, int mode,
-			      int end);
+			      int end, int bfsize);
 	/* DMA TX descriptor ring initialization */
 	void (*init_tx_desc) (struct dma_desc *p, int mode, int end);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/descs_com.h b/drivers/net/ethernet/stmicro/stmmac/descs_com.h
index 6f2cc78c5cf5..6b83fc8e6fbe 100644
--- a/drivers/net/ethernet/stmicro/stmmac/descs_com.h
+++ b/drivers/net/ethernet/stmicro/stmmac/descs_com.h
@@ -33,9 +33,10 @@
 /* Specific functions used for Ring mode */
 
 /* Enhanced descriptors */
-static inline void ehn_desc_rx_set_on_ring(struct dma_desc *p, int end)
+static inline void ehn_desc_rx_set_on_ring(struct dma_desc *p, int end, int bfsize)
 {
-	p->des01.erx.buffer2_size = BUF_SIZE_8KiB - 1;
+	if (bfsize == BUF_SIZE_16KiB)
+		p->des01.erx.buffer2_size = BUF_SIZE_8KiB - 1;
 	if (end)
 		p->des01.erx.end_ring = 1;
 }
@@ -61,9 +62,14 @@ static inline void enh_set_tx_desc_len_on_ring(struct dma_desc *p, int len)
 }
 
 /* Normal descriptors */
-static inline void ndesc_rx_set_on_ring(struct dma_desc *p, int end)
+static inline void ndesc_rx_set_on_ring(struct dma_desc *p, int end, int bfsize)
 {
-	p->des01.rx.buffer2_size = BUF_SIZE_2KiB - 1;
+	int size;
+
+	if (bfsize >= BUF_SIZE_2KiB) {
+		size = min(bfsize - BUF_SIZE_2KiB + 1, BUF_SIZE_2KiB - 1);
+		p->des01.rx.buffer2_size = size;
+	}
 	if (end)
 		p->des01.rx.end_ring = 1;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
index 7d944449f5ef..9ecb3a948f86 100644
--- a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
@@ -238,16 +238,20 @@ static int enh_desc_get_rx_status(void *data, struct stmmac_extra_stats *x,
 }
 
 static void enh_desc_init_rx_desc(struct dma_desc *p, int disable_rx_ic,
-				  int mode, int end)
+				  int mode, int end, int bfsize)
 {
+	int bfsize1;
+
 	p->des01.all_flags = 0;
 	p->des01.erx.own = 1;
-	p->des01.erx.buffer1_size = BUF_SIZE_8KiB - 1;
+
+	bfsize1 = min(bfsize, BUF_SIZE_8KiB - 1);
+	p->des01.erx.buffer1_size = bfsize1;
 
 	if (mode == STMMAC_CHAIN_MODE)
 		ehn_desc_rx_set_on_chain(p, end);
 	else
-		ehn_desc_rx_set_on_ring(p, end);
+		ehn_desc_rx_set_on_ring(p, end, bfsize);
 
 	if (disable_rx_ic)
 		p->des01.erx.disable_ic = 1;
diff --git a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
index 48c3456445b2..07e0c03cfb10 100644
--- a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
@@ -121,16 +121,20 @@ static int ndesc_get_rx_status(void *data, struct stmmac_extra_stats *x,
 }
 
 static void ndesc_init_rx_desc(struct dma_desc *p, int disable_rx_ic, int mode,
-			       int end)
+			       int end, int bfsize)
 {
+	int bfsize1;
+
 	p->des01.all_flags = 0;
 	p->des01.rx.own = 1;
-	p->des01.rx.buffer1_size = BUF_SIZE_2KiB - 1;
+
+	bfsize1 = min(bfsize, (BUF_SIZE_2KiB - 1));
+	p->des01.rx.buffer1_size = bfsize1;
 
 	if (mode == STMMAC_CHAIN_MODE)
 		ndesc_rx_set_on_chain(p, end);
 	else
-		ndesc_rx_set_on_ring(p, end);
+		ndesc_rx_set_on_ring(p, end, bfsize);
 
 	if (disable_rx_ic)
 		p->des01.rx.disable_ic = 1;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index f4d6512f066c..e9d41e03121c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -964,11 +964,11 @@ static void stmmac_clear_descriptors(struct stmmac_priv *priv)
 		if (priv->extend_desc)
 			priv->hw->desc->init_rx_desc(&priv->dma_erx[i].basic,
 						     priv->use_riwt, priv->mode,
-						     (i == rxsize - 1));
+						     (i == rxsize - 1), priv->dma_buf_sz);
 		else
 			priv->hw->desc->init_rx_desc(&priv->dma_rx[i],
 						     priv->use_riwt, priv->mode,
-						     (i == rxsize - 1));
+						     (i == rxsize - 1), priv->dma_buf_sz);
 	for (i = 0; i < txsize; i++)
 		if (priv->extend_desc)
 			priv->hw->desc->init_tx_desc(&priv->dma_etx[i].basic,
-- 
2.19.1

