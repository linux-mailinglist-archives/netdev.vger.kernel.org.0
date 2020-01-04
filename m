Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE15313003D
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 03:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbgADCuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 21:50:10 -0500
Received: from mga12.intel.com ([192.55.52.136]:64696 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727509AbgADCt5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 21:49:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jan 2020 18:49:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,393,1571727600"; 
   d="scan'208";a="369757889"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga004.jf.intel.com with ESMTP; 03 Jan 2020 18:49:54 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 14/16] ice: Add a boundary check in ice_xsk_umem()
Date:   Fri,  3 Jan 2020 18:49:51 -0800
Message-Id: <20200104024953.2336731-15-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200104024953.2336731-1-jeffrey.t.kirsher@intel.com>
References: <20200104024953.2336731-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>

In ice_xsk_umem(), variable qid which is later used as an array index,
is not validated for a possible boundary exceedance. Because of that,
a calling function might receive an invalid address, which causes
general protection fault when dereferenced.

To address this, add a boundary check to see if qid is greater than the
size of a UMEM array. Also, don't let user change vsi->num_xsk_umems
just by trying to setup a second UMEM if its value is already set up
(i.e. UMEM region has already been allocated for this VSI).

While at it, make sure that ring->zca.free pointer is always zeroed out
if there is no UMEM on a specified ring.

Signed-off-by: Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      | 5 +++--
 drivers/net/ethernet/intel/ice/ice_base.c | 1 +
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 1376219a6c7e..cb10abb14e11 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -465,12 +465,13 @@ static inline void ice_set_ring_xdp(struct ice_ring *ring)
 static inline struct xdp_umem *ice_xsk_umem(struct ice_ring *ring)
 {
 	struct xdp_umem **umems = ring->vsi->xsk_umems;
-	int qid = ring->q_index;
+	u16 qid = ring->q_index;
 
 	if (ice_ring_is_xdp(ring))
 		qid -= ring->vsi->num_xdp_txq;
 
-	if (!umems || !umems[qid] || !ice_is_xdp_ena_vsi(ring->vsi))
+	if (qid >= ring->vsi->num_xsk_umems || !umems || !umems[qid] ||
+	    !ice_is_xdp_ena_vsi(ring->vsi))
 		return NULL;
 
 	return umems[qid];
diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index d4559d45288f..25f2e0fb3833 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -326,6 +326,7 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 			dev_info(&vsi->back->pdev->dev, "Registered XDP mem model MEM_TYPE_ZERO_COPY on Rx ring %d\n",
 				 ring->q_index);
 		} else {
+			ring->zca.free = NULL;
 			if (!xdp_rxq_info_is_reg(&ring->xdp_rxq))
 				xdp_rxq_info_reg(&ring->xdp_rxq,
 						 ring->netdev,
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 0af1f0b951c0..0e401f116d54 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -414,7 +414,8 @@ ice_xsk_umem_enable(struct ice_vsi *vsi, struct xdp_umem *umem, u16 qid)
 	if (vsi->type != ICE_VSI_PF)
 		return -EINVAL;
 
-	vsi->num_xsk_umems = min_t(u16, vsi->num_rxq, vsi->num_txq);
+	if (!vsi->num_xsk_umems)
+		vsi->num_xsk_umems = min_t(u16, vsi->num_rxq, vsi->num_txq);
 	if (qid >= vsi->num_xsk_umems)
 		return -EINVAL;
 
-- 
2.24.1

