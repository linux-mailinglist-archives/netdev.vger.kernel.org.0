Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49FDB11610
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 11:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfEBJG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 05:06:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:47594 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbfEBJGZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 05:06:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 02:06:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,421,1549958400"; 
   d="scan'208";a="147615347"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 02 May 2019 02:06:23 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/15] ice: Use ice_for_each_q_vector macro where possible
Date:   Thu,  2 May 2019 02:06:11 -0700
Message-Id: <20190502090620.21281-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190502090620.21281-1-jeffrey.t.kirsher@intel.com>
References: <20190502090620.21281-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

There are many places in the code where we do the following:

for (i = 0; i < vsi->num_q_vectors; i++)

Instead use the macro mentioned in the commit title:

ice_for_each_q_vector(vsi, i)

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c  |  6 +++---
 drivers/net/ethernet/intel/ice/ice_main.c | 10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 57b2873a6123..e75d8c4fadc6 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1054,7 +1054,7 @@ void ice_vsi_free_q_vectors(struct ice_vsi *vsi)
 {
 	int v_idx;
 
-	for (v_idx = 0; v_idx < vsi->num_q_vectors; v_idx++)
+	ice_for_each_q_vector(vsi, v_idx)
 		ice_free_q_vector(vsi, v_idx);
 }
 
@@ -2409,7 +2409,7 @@ void ice_vsi_free_irq(struct ice_vsi *vsi)
 			return;
 
 		vsi->irqs_ready = false;
-		for (i = 0; i < vsi->num_q_vectors; i++) {
+		ice_for_each_q_vector(vsi, i) {
 			u16 vector = i + base;
 			int irq_num;
 
@@ -2633,7 +2633,7 @@ void ice_vsi_dis_irq(struct ice_vsi *vsi)
 			wr32(hw, GLINT_DYN_CTL(i), 0);
 
 		ice_flush(hw);
-		for (i = 0; i < vsi->num_q_vectors; i++)
+		ice_for_each_q_vector(vsi, i)
 			synchronize_irq(pf->msix_entries[i + base].vector);
 	}
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 8bdd311c1b4c..a32782be7f88 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1338,7 +1338,7 @@ static int ice_vsi_ena_irq(struct ice_vsi *vsi)
 	if (test_bit(ICE_FLAG_MSIX_ENA, pf->flags)) {
 		int i;
 
-		for (i = 0; i < vsi->num_q_vectors; i++)
+		ice_for_each_q_vector(vsi, i)
 			ice_irq_dynamic_ena(hw, vsi, vsi->q_vectors[i]);
 	}
 
@@ -1705,7 +1705,7 @@ void ice_napi_del(struct ice_vsi *vsi)
 	if (!vsi->netdev)
 		return;
 
-	for (v_idx = 0; v_idx < vsi->num_q_vectors; v_idx++)
+	ice_for_each_q_vector(vsi, v_idx)
 		netif_napi_del(&vsi->q_vectors[v_idx]->napi);
 }
 
@@ -1724,7 +1724,7 @@ static void ice_napi_add(struct ice_vsi *vsi)
 	if (!vsi->netdev)
 		return;
 
-	for (v_idx = 0; v_idx < vsi->num_q_vectors; v_idx++)
+	ice_for_each_q_vector(vsi, v_idx)
 		netif_napi_add(vsi->netdev, &vsi->q_vectors[v_idx]->napi,
 			       ice_napi_poll, NAPI_POLL_WEIGHT);
 }
@@ -2960,7 +2960,7 @@ static void ice_napi_enable_all(struct ice_vsi *vsi)
 	if (!vsi->netdev)
 		return;
 
-	for (q_idx = 0; q_idx < vsi->num_q_vectors; q_idx++) {
+	ice_for_each_q_vector(vsi, q_idx)  {
 		struct ice_q_vector *q_vector = vsi->q_vectors[q_idx];
 
 		if (q_vector->rx.ring || q_vector->tx.ring)
@@ -3334,7 +3334,7 @@ static void ice_napi_disable_all(struct ice_vsi *vsi)
 	if (!vsi->netdev)
 		return;
 
-	for (q_idx = 0; q_idx < vsi->num_q_vectors; q_idx++) {
+	ice_for_each_q_vector(vsi, q_idx) {
 		struct ice_q_vector *q_vector = vsi->q_vectors[q_idx];
 
 		if (q_vector->rx.ring || q_vector->tx.ring)
-- 
2.20.1

