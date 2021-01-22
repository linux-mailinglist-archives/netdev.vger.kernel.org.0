Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDFDD30115A
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 01:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbhAWAD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 19:03:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:38713 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbhAWACE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 19:02:04 -0500
IronPort-SDR: jo6JgHmgsn9DM3V/Xe3M+tmpMTNhFp+Gemmc3kFz40SUzoENPMuU/hf9aNunNuqxIGjJnGKyDx
 wJ8wmfAnaIOg==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="179670516"
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="179670516"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 15:57:02 -0800
IronPort-SDR: T/rfF3/yvPJBqVjjMGzwwffPCK7pDVSnatoTRgcQJAngblGg3KDvDHL3ffAgIu0hVTZFoc0sNs
 vf/dpCSBKEtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="428258693"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 22 Jan 2021 15:57:02 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 6/7] ice: Fix MSI-X vector fallback logic
Date:   Fri, 22 Jan 2021 15:57:33 -0800
Message-Id: <20210122235734.447240-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122235734.447240-1-anthony.l.nguyen@intel.com>
References: <20210122235734.447240-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

The current MSI-X enablement logic tries to enable best-case MSI-X
vectors and if that fails we only support a bare-minimum set. This
includes a single MSI-X for 1 Tx and 1 Rx queue and a single MSI-X
for the OICR interrupt. Unfortunately, the driver fails to load when we
don't get as many MSI-X as requested for a couple reasons.

First, the code to allocate MSI-X in the driver tries to allocate
num_online_cpus() MSI-X for LAN traffic without caring about the number
of MSI-X actually enabled/requested from the kernel for LAN traffic.
So, when calling ice_get_res() for the PF VSI, it returns failure
because the number of available vectors is less than requested. Fix
this by not allowing the PF VSI to allocation  more than
pf->num_lan_msix MSI-X vectors and pf->num_lan_msix Rx/Tx queues.
Limiting the number of queues is done because we don't want more than
1 Tx/Rx queue per interrupt due to performance conerns.

Second, the driver assigns pf->num_lan_msix = 2, to account for LAN
traffic and the OICR. However, pf->num_lan_msix is only meant for LAN
MSI-X. This is causing a failure when the PF VSI tries to
allocate/reserve the minimum pf->num_lan_msix because the OICR MSI-X has
already been reserved, so there may not be enough MSI-X vectors left.
Fix this by setting pf->num_lan_msix = 1 for the failure case. Then the
ICE_MIN_MSIX accounts for the LAN MSI-X and the OICR MSI-X needed for
the failure case.

Update the related defines used in ice_ena_msix_range() to align with
the above behavior and remove the unused RDMA defines because RDMA is
currently not supported. Also, remove the now incorrect comment.

Fixes: 152b978a1f90 ("ice: Rework ice_ena_msix_range")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      |  4 +++-
 drivers/net/ethernet/intel/ice/ice_lib.c  | 14 +++++++++-----
 drivers/net/ethernet/intel/ice/ice_main.c |  8 ++------
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 56725356a17b..fa1e128c24ec 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -68,7 +68,9 @@
 #define ICE_INT_NAME_STR_LEN	(IFNAMSIZ + 16)
 #define ICE_AQ_LEN		64
 #define ICE_MBXSQ_LEN		64
-#define ICE_MIN_MSIX		2
+#define ICE_MIN_LAN_TXRX_MSIX	1
+#define ICE_MIN_LAN_OICR_MSIX	1
+#define ICE_MIN_MSIX		(ICE_MIN_LAN_TXRX_MSIX + ICE_MIN_LAN_OICR_MSIX)
 #define ICE_FDIR_MSIX		1
 #define ICE_NO_VSI		0xffff
 #define ICE_VSI_MAP_CONTIG	0
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 3df67486d42d..ad9c22a1b97a 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -161,8 +161,9 @@ static void ice_vsi_set_num_qs(struct ice_vsi *vsi, u16 vf_id)
 
 	switch (vsi->type) {
 	case ICE_VSI_PF:
-		vsi->alloc_txq = min_t(int, ice_get_avail_txq_count(pf),
-				       num_online_cpus());
+		vsi->alloc_txq = min3(pf->num_lan_msix,
+				      ice_get_avail_txq_count(pf),
+				      (u16)num_online_cpus());
 		if (vsi->req_txq) {
 			vsi->alloc_txq = vsi->req_txq;
 			vsi->num_txq = vsi->req_txq;
@@ -174,8 +175,9 @@ static void ice_vsi_set_num_qs(struct ice_vsi *vsi, u16 vf_id)
 		if (!test_bit(ICE_FLAG_RSS_ENA, pf->flags)) {
 			vsi->alloc_rxq = 1;
 		} else {
-			vsi->alloc_rxq = min_t(int, ice_get_avail_rxq_count(pf),
-					       num_online_cpus());
+			vsi->alloc_rxq = min3(pf->num_lan_msix,
+					      ice_get_avail_rxq_count(pf),
+					      (u16)num_online_cpus());
 			if (vsi->req_rxq) {
 				vsi->alloc_rxq = vsi->req_rxq;
 				vsi->num_rxq = vsi->req_rxq;
@@ -184,7 +186,9 @@ static void ice_vsi_set_num_qs(struct ice_vsi *vsi, u16 vf_id)
 
 		pf->num_lan_rx = vsi->alloc_rxq;
 
-		vsi->num_q_vectors = max_t(int, vsi->alloc_rxq, vsi->alloc_txq);
+		vsi->num_q_vectors = min_t(int, pf->num_lan_msix,
+					   max_t(int, vsi->alloc_rxq,
+						 vsi->alloc_txq));
 		break;
 	case ICE_VSI_VF:
 		vf = &pf->vf[vsi->vf_id];
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index fb81aa5979e3..e10ca8929f85 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3430,18 +3430,14 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 	if (v_actual < v_budget) {
 		dev_warn(dev, "not enough OS MSI-X vectors. requested = %d, obtained = %d\n",
 			 v_budget, v_actual);
-/* 2 vectors each for LAN and RDMA (traffic + OICR), one for flow director */
-#define ICE_MIN_LAN_VECS 2
-#define ICE_MIN_RDMA_VECS 2
-#define ICE_MIN_VECS (ICE_MIN_LAN_VECS + ICE_MIN_RDMA_VECS + 1)
 
-		if (v_actual < ICE_MIN_LAN_VECS) {
+		if (v_actual < ICE_MIN_MSIX) {
 			/* error if we can't get minimum vectors */
 			pci_disable_msix(pf->pdev);
 			err = -ERANGE;
 			goto msix_err;
 		} else {
-			pf->num_lan_msix = ICE_MIN_LAN_VECS;
+			pf->num_lan_msix = ICE_MIN_LAN_TXRX_MSIX;
 		}
 	}
 
-- 
2.26.2

