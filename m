Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04C5269377
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 19:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbgINRdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 13:33:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:61362 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726322AbgINRcl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 13:32:41 -0400
IronPort-SDR: YAFF6n4X9V6Ep0uU/mii9FoWqEXTmOs6UqYFrYSIPWig92LL2Zoyr59dRA1dJ8UpurHwNMRMqW
 cVKnfQXUZ9tw==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="160056115"
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="160056115"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 10:32:31 -0700
IronPort-SDR: z1bVF+38rmvXCrL6adR2DuaLyivDqOGeYI5Z8ATwPW67HR7TBXsuNHd1PfzqKzFMwlBlJySu70
 /nDZV61HqCNA==
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="319137320"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 10:32:31 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v2 4/5] i40e: use 16B HW descriptors instead of 32B
Date:   Mon, 14 Sep 2020 10:32:23 -0700
Message-Id: <20200914173224.692707-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200914173224.692707-1-anthony.l.nguyen@intel.com>
References: <20200914173224.692707-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The i40e NIC supports two flavors of HW descriptors, 16 and 32
byte. The latter has, obviously, room for more offloading
information. However, the only fields of the 32B HW descriptor that is
being used by the driver, is also available in the 16B descriptor.

In other words; Reading and writing 32 bytes instead of 16 byte is a
waste of bus bandwidth.

This commit starts using 16 byte descriptors instead of 32 byte
descriptors.

For AF_XDP the rx_drop benchmark was improved by 2%.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h         |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c | 10 ++++------
 drivers/net/ethernet/intel/i40e/i40e_main.c    |  4 ++--
 drivers/net/ethernet/intel/i40e/i40e_trace.h   |  6 +++---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c    |  6 +++---
 drivers/net/ethernet/intel/i40e/i40e_txrx.h    |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_type.h    |  5 ++++-
 7 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index a7e212d1caa2..ada0e93c38f0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -90,7 +90,7 @@
 #define I40E_OEM_RELEASE_MASK		0x0000ffff
 
 #define I40E_RX_DESC(R, i)	\
-	(&(((union i40e_32byte_rx_desc *)((R)->desc))[i]))
+	(&(((union i40e_rx_desc *)((R)->desc))[i]))
 #define I40E_TX_DESC(R, i)	\
 	(&(((struct i40e_tx_desc *)((R)->desc))[i]))
 #define I40E_TX_CTXTDESC(R, i)	\
diff --git a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
index d3ad2e3aa838..d7c13ca9be7d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
@@ -604,10 +604,9 @@ static void i40e_dbg_dump_desc(int cnt, int vsi_seid, int ring_id, int desc_n,
 			} else {
 				rxd = I40E_RX_DESC(ring, i);
 				dev_info(&pf->pdev->dev,
-					 "   d[%03x] = 0x%016llx 0x%016llx 0x%016llx 0x%016llx\n",
+					 "   d[%03x] = 0x%016llx 0x%016llx\n",
 					 i, rxd->read.pkt_addr,
-					 rxd->read.hdr_addr,
-					 rxd->read.rsvd1, rxd->read.rsvd2);
+					 rxd->read.hdr_addr);
 			}
 		}
 	} else if (cnt == 3) {
@@ -625,10 +624,9 @@ static void i40e_dbg_dump_desc(int cnt, int vsi_seid, int ring_id, int desc_n,
 		} else {
 			rxd = I40E_RX_DESC(ring, desc_n);
 			dev_info(&pf->pdev->dev,
-				 "vsi = %02i rx ring = %02i d[%03x] = 0x%016llx 0x%016llx 0x%016llx 0x%016llx\n",
+				 "vsi = %02i rx ring = %02i d[%03x] = 0x%016llx 0x%016llx\n",
 				 vsi_seid, ring_id, desc_n,
-				 rxd->read.pkt_addr, rxd->read.hdr_addr,
-				 rxd->read.rsvd1, rxd->read.rsvd2);
+				 rxd->read.pkt_addr, rxd->read.hdr_addr);
 		}
 	} else {
 		dev_info(&pf->pdev->dev, "dump desc rx/tx/xdp <vsi_seid> <ring_id> [<desc_n>]\n");
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 9cfaa99da4e6..07207e21874f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3321,8 +3321,8 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 	rx_ctx.base = (ring->dma / 128);
 	rx_ctx.qlen = ring->count;
 
-	/* use 32 byte descriptors */
-	rx_ctx.dsize = 1;
+	/* use 16 byte descriptors */
+	rx_ctx.dsize = 0;
 
 	/* descriptor type is always zero
 	 * rx_ctx.dtype = 0;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_trace.h b/drivers/net/ethernet/intel/i40e/i40e_trace.h
index 424f02077e2e..983f8b98b275 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_trace.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_trace.h
@@ -112,7 +112,7 @@ DECLARE_EVENT_CLASS(
 	i40e_rx_template,
 
 	TP_PROTO(struct i40e_ring *ring,
-		 union i40e_32byte_rx_desc *desc,
+		 union i40e_16byte_rx_desc *desc,
 		 struct sk_buff *skb),
 
 	TP_ARGS(ring, desc, skb),
@@ -140,7 +140,7 @@ DECLARE_EVENT_CLASS(
 DEFINE_EVENT(
 	i40e_rx_template, i40e_clean_rx_irq,
 	TP_PROTO(struct i40e_ring *ring,
-		 union i40e_32byte_rx_desc *desc,
+		 union i40e_16byte_rx_desc *desc,
 		 struct sk_buff *skb),
 
 	TP_ARGS(ring, desc, skb));
@@ -148,7 +148,7 @@ DEFINE_EVENT(
 DEFINE_EVENT(
 	i40e_rx_template, i40e_clean_rx_irq_rx,
 	TP_PROTO(struct i40e_ring *ring,
-		 union i40e_32byte_rx_desc *desc,
+		 union i40e_16byte_rx_desc *desc,
 		 struct sk_buff *skb),
 
 	TP_ARGS(ring, desc, skb));
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index b43bc20f701d..1606ba5318f7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -533,11 +533,11 @@ static void i40e_fd_handle_status(struct i40e_ring *rx_ring, u64 qword0_raw,
 {
 	struct i40e_pf *pf = rx_ring->vsi->back;
 	struct pci_dev *pdev = pf->pdev;
-	struct i40e_32b_rx_wb_qw0 *qw0;
+	struct i40e_16b_rx_wb_qw0 *qw0;
 	u32 fcnt_prog, fcnt_avail;
 	u32 error;
 
-	qw0 = (struct i40e_32b_rx_wb_qw0 *)&qword0_raw;
+	qw0 = (struct i40e_16b_rx_wb_qw0 *)&qword0_raw;
 	error = (qword1 & I40E_RX_PROG_STATUS_DESC_QW1_ERROR_MASK) >>
 		I40E_RX_PROG_STATUS_DESC_QW1_ERROR_SHIFT;
 
@@ -1418,7 +1418,7 @@ int i40e_setup_rx_descriptors(struct i40e_ring *rx_ring)
 	u64_stats_init(&rx_ring->syncp);
 
 	/* Round up to nearest 4K */
-	rx_ring->size = rx_ring->count * sizeof(union i40e_32byte_rx_desc);
+	rx_ring->size = rx_ring->count * sizeof(union i40e_rx_desc);
 	rx_ring->size = ALIGN(rx_ring->size, 4096);
 	rx_ring->desc = dma_alloc_coherent(dev, rx_ring->size,
 					   &rx_ring->dma, GFP_KERNEL);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index 703b644fd71f..66c2b92c0d10 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -110,7 +110,7 @@ enum i40e_dyn_idx_t {
  */
 #define I40E_RX_HDR_SIZE I40E_RXBUFFER_256
 #define I40E_PACKET_HDR_PAD (ETH_HLEN + ETH_FCS_LEN + (VLAN_HLEN * 2))
-#define i40e_rx_desc i40e_32byte_rx_desc
+#define i40e_rx_desc i40e_16byte_rx_desc
 
 #define I40E_RX_DMA_ATTR \
 	(DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_type.h b/drivers/net/ethernet/intel/i40e/i40e_type.h
index 52410d609ba1..97d29df65f9e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_type.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_type.h
@@ -628,7 +628,7 @@ union i40e_16byte_rx_desc {
 		__le64 hdr_addr; /* Header buffer address */
 	} read;
 	struct {
-		struct {
+		struct i40e_16b_rx_wb_qw0 {
 			struct {
 				union {
 					__le16 mirroring_status;
@@ -647,6 +647,9 @@ union i40e_16byte_rx_desc {
 			__le64 status_error_len;
 		} qword1;
 	} wb;  /* writeback */
+	struct {
+		u64 qword[2];
+	} raw;
 };
 
 union i40e_32byte_rx_desc {
-- 
2.26.2

