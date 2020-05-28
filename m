Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D612A1E5888
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 09:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbgE1HZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 03:25:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:14688 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbgE1HZp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 03:25:45 -0400
IronPort-SDR: 4RLVcOjphaGO2eWYt+NPv4trArYdrhxAXRYPEefydsXApRpvHaTM4xKz0GznHJ7538IutHK1Ty
 /hDlxO4MGG2w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 00:25:44 -0700
IronPort-SDR: bpYPRlX7oQimGXlu5upw0KrlviNwEpLrOMQUe7RdiIkdc4NRHiuHeOB6NEF+3fjBPrjBFSN4Wx
 qdyDc3wQRShQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,443,1583222400"; 
   d="scan'208";a="310831138"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 28 May 2020 00:25:43 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Marta Plantykow <marta.a.plantykow@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 12/15] ice: Change number of XDP Tx queues to match number of Rx queues
Date:   Thu, 28 May 2020 00:25:35 -0700
Message-Id: <20200528072538.1621790-13-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
References: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marta Plantykow <marta.a.plantykow@intel.com>

In current implementation number of XDP Tx queues is the same as
the number of transmit queues, which is not always true. This
patch changes this number to match the number of receive queues.
XDP programs are running on Rx rings, so what we actually need to
provide is the XDP Tx ring per each Rx ring so that the whole XDP
ecosystem is functional, e.g. if the result of XDP prog is XDP_TX
then you have the need to access the XDP Tx ring.

Signed-off-by: Marta Plantykow <marta.a.plantykow@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c  | 2 +-
 drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 89962c14e31f..6f3ee8ac11ce 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2785,7 +2785,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 
 		ice_vsi_map_rings_to_vectors(vsi);
 		if (ice_is_xdp_ena_vsi(vsi)) {
-			vsi->num_xdp_txq = vsi->alloc_txq;
+			vsi->num_xdp_txq = vsi->alloc_rxq;
 			ret = ice_prepare_xdp_rings(vsi, vsi->xdp_prog);
 			if (ret)
 				goto err_vectors;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 81c5f0ce5b8f..b64c4e796636 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1935,7 +1935,7 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 	}
 
 	if (!ice_is_xdp_ena_vsi(vsi) && prog) {
-		vsi->num_xdp_txq = vsi->alloc_txq;
+		vsi->num_xdp_txq = vsi->alloc_rxq;
 		xdp_ring_err = ice_prepare_xdp_rings(vsi, prog);
 		if (xdp_ring_err)
 			NL_SET_ERR_MSG_MOD(extack, "Setting up XDP Tx resources failed");
-- 
2.26.2

