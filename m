Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32E9D3655C
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 22:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfFEUXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 16:23:50 -0400
Received: from mga18.intel.com ([134.134.136.126]:4313 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726527AbfFEUXs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 16:23:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 13:23:46 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga005.jf.intel.com with ESMTP; 05 Jun 2019 13:23:45 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jan Sokolowski <jan.sokolowski@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/15] ixgbe: add tracking of AF_XDP zero-copy state for each queue pair
Date:   Wed,  5 Jun 2019 13:23:44 -0700
Message-Id: <20190605202358.2767-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605202358.2767-1-jeffrey.t.kirsher@intel.com>
References: <20190605202358.2767-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jan Sokolowski <jan.sokolowski@intel.com>

Here, we add a bitmap to the ixgbe_adapter that tracks if a
certain queue pair has been "zero-copy enabled" via the ndo_bpf.
The bitmap is used in ixgbe_xsk_umem, and enables zero-copy if
and only if XDP is enabled, the corresponding qid in the bitmap
is set, and the umem is non-NULL;

Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      | 1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 6 ++++++
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 5 ++++-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index 08d85e336bd4..5f5db6eb261e 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -635,6 +635,7 @@ struct ixgbe_adapter {
 	/* XDP */
 	int num_xdp_queues;
 	struct ixgbe_ring *xdp_ring[MAX_XDP_QUEUES];
+	unsigned long *af_xdp_zc_qps; /* tracks AF_XDP ZC enabled rings */
 
 	/* TX */
 	struct ixgbe_ring *tx_ring[MAX_TX_QUEUES] ____cacheline_aligned_in_smp;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 57fd9ee6de66..b613e72c8ee4 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6288,6 +6288,10 @@ static int ixgbe_sw_init(struct ixgbe_adapter *adapter,
 	if (ixgbe_init_rss_key(adapter))
 		return -ENOMEM;
 
+	adapter->af_xdp_zc_qps = bitmap_zalloc(MAX_XDP_QUEUES, GFP_KERNEL);
+	if (!adapter->af_xdp_zc_qps)
+		return -ENOMEM;
+
 	/* Set MAC specific capability flags and exceptions */
 	switch (hw->mac.type) {
 	case ixgbe_mac_82598EB:
@@ -11161,6 +11165,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	kfree(adapter->jump_tables[0]);
 	kfree(adapter->mac_table);
 	kfree(adapter->rss_key);
+	bitmap_free(adapter->af_xdp_zc_qps);
 err_ioremap:
 	disable_dev = !test_and_set_bit(__IXGBE_DISABLED, &adapter->state);
 	free_netdev(netdev);
@@ -11249,6 +11254,7 @@ static void ixgbe_remove(struct pci_dev *pdev)
 
 	kfree(adapter->mac_table);
 	kfree(adapter->rss_key);
+	bitmap_free(adapter->af_xdp_zc_qps);
 	disable_dev = !test_and_set_bit(__IXGBE_DISABLED, &adapter->state);
 	free_netdev(netdev);
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index bfe95ce0bd7f..b9f05fbdbf67 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -15,7 +15,8 @@ struct xdp_umem *ixgbe_xsk_umem(struct ixgbe_adapter *adapter,
 	int qid = ring->ring_idx;
 
 	if (!adapter->xsk_umems || !adapter->xsk_umems[qid] ||
-	    qid >= adapter->num_xsk_umems || !xdp_on)
+	    qid >= adapter->num_xsk_umems || !xdp_on ||
+	    !test_bit(qid, adapter->af_xdp_zc_qps))
 		return NULL;
 
 	return adapter->xsk_umems[qid];
@@ -143,6 +144,7 @@ static int ixgbe_xsk_umem_enable(struct ixgbe_adapter *adapter,
 	if (if_running)
 		ixgbe_txrx_ring_disable(adapter, qid);
 
+	set_bit(qid, adapter->af_xdp_zc_qps);
 	err = ixgbe_add_xsk_umem(adapter, umem, qid);
 	if (err)
 		return err;
@@ -173,6 +175,7 @@ static int ixgbe_xsk_umem_disable(struct ixgbe_adapter *adapter, u16 qid)
 	if (if_running)
 		ixgbe_txrx_ring_disable(adapter, qid);
 
+	clear_bit(qid, adapter->af_xdp_zc_qps);
 	ixgbe_xsk_umem_dma_unmap(adapter, adapter->xsk_umems[qid]);
 	ixgbe_remove_xsk_umem(adapter, qid);
 
-- 
2.21.0

