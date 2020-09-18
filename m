Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375C6270857
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 23:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgIRVeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 17:34:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:65029 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726154AbgIRVeD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 17:34:03 -0400
IronPort-SDR: kbJo5MpkshwM8MVh/DILBx+99B8VqwC/uub0lFyDv6j4thh0G37mCMjNcGW0QlZc85MK8Eu1lF
 TR/irs5eiEFw==
X-IronPort-AV: E=McAfee;i="6000,8403,9748"; a="178128526"
X-IronPort-AV: E=Sophos;i="5.77,274,1596524400"; 
   d="scan'208";a="178128526"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 14:27:15 -0700
IronPort-SDR: Gvzup48mO64orYAMfJxkIYrfRGS54l35bzUkN1HRRe3gTdS37WIO2MN3eE/G+D1nf3rGACuc9I
 oVz3mynMibng==
X-IronPort-AV: E=Sophos;i="5.77,274,1596524400"; 
   d="scan'208";a="508299898"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 14:27:14 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net 4/4] ice: fix memory leak in ice_vsi_setup
Date:   Fri, 18 Sep 2020 14:27:03 -0700
Message-Id: <20200918212703.3398038-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918212703.3398038-1-anthony.l.nguyen@intel.com>
References: <20200918212703.3398038-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

During ice_vsi_setup, if ice_cfg_vsi_lan fails, it does not properly
release memory associated with the VSI rings. If we had used devres
allocations for the rings, this would be ok. However, we use kzalloc and
kfree_rcu for these ring structures.

Using the correct label to cleanup the rings during ice_vsi_setup
highlights an issue in the ice_vsi_clear_rings function: it can leave
behind stale ring pointers in the q_vectors structure.

When releasing rings, we must also ensure that no q_vector associated
with the VSI will point to this ring again. To resolve this, loop over
all q_vectors and release their ring mapping. Because we are about to
free all rings, no q_vector should remain pointing to any of the rings
in this VSI.

Fixes: 5513b920a4f7 ("ice: Update Tx scheduler tree for VSI multi-Tx queue support")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 65cc78279501..ebbb8f54871c 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1196,6 +1196,18 @@ static void ice_vsi_clear_rings(struct ice_vsi *vsi)
 {
 	int i;
 
+	/* Avoid stale references by clearing map from vector to ring */
+	if (vsi->q_vectors) {
+		ice_for_each_q_vector(vsi, i) {
+			struct ice_q_vector *q_vector = vsi->q_vectors[i];
+
+			if (q_vector) {
+				q_vector->tx.ring = NULL;
+				q_vector->rx.ring = NULL;
+			}
+		}
+	}
+
 	if (vsi->tx_rings) {
 		for (i = 0; i < vsi->alloc_txq; i++) {
 			if (vsi->tx_rings[i]) {
@@ -2291,7 +2303,7 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 	if (status) {
 		dev_err(dev, "VSI %d failed lan queue config, error %s\n",
 			vsi->vsi_num, ice_stat_str(status));
-		goto unroll_vector_base;
+		goto unroll_clear_rings;
 	}
 
 	/* Add switch rule to drop all Tx Flow Control Frames, of look up
-- 
2.26.2

