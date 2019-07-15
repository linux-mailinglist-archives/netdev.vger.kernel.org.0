Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70BDD697EE
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730459AbfGONsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:48:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731546AbfGONsj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 09:48:39 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F17F20896;
        Mon, 15 Jul 2019 13:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198518;
        bh=OpOsLOSWHTYl/Z1oKwxTfZB+zZtDvt09ioVEEvxshGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zKhxUS7AmSWpgvs7/THPNqS4K76HpJ6pym86CI1YYzxorILIE3rf2Oh191ZIdHTCQ
         6LxIjKKpOVWvMME3JnakH4CVQzQF5clCosdcMpNRhGLc9oO3Z5L2KPbVRSKtmkr1/U
         74tIrAS7ItoJx3vEuCXFuqXbP7S4Wg7O1njylTU8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 033/249] ice: Fix couple of issues in ice_vsi_release
Date:   Mon, 15 Jul 2019 09:43:18 -0400
Message-Id: <20190715134655.4076-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

[ Upstream commit aa6ccf3f2d7042f94c4e91538956ce7051e7856e ]

Currently the driver is calling ice_napi_del() and then
unregister_netdev(). The call to unregister_netdev() will result in a
call to ice_stop() and then ice_vsi_close(). This is where we call
napi_disable() for all the MSI-X vectors. This flow is reversed so make
the changes to ensure napi_disable() happens prior to napi_del().

Before calling napi_del() and free_netdev() make sure
unregister_netdev() was called. This is done by making sure the
__ICE_DOWN bit is set in the vsi->state for the interested VSI.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice.h      |  1 -
 drivers/net/ethernet/intel/ice/ice_lib.c  | 24 ++++++++++++-----------
 drivers/net/ethernet/intel/ice/ice_main.c |  2 +-
 3 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 792e6e42030e..754c7080c3fc 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -451,7 +451,6 @@ int ice_set_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size);
 int ice_get_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size);
 void ice_fill_rss_lut(u8 *lut, u16 rss_table_size, u16 rss_size);
 void ice_print_link_msg(struct ice_vsi *vsi, bool isup);
-void ice_napi_del(struct ice_vsi *vsi);
 #ifdef CONFIG_DCB
 int ice_pf_ena_all_vsi(struct ice_pf *pf, bool locked);
 void ice_pf_dis_all_vsi(struct ice_pf *pf, bool locked);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index fbf1eba0cc2a..f14fa51cc704 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2754,19 +2754,14 @@ int ice_vsi_release(struct ice_vsi *vsi)
 
 	if (vsi->type == ICE_VSI_VF)
 		vf = &pf->vf[vsi->vf_id];
-	/* do not unregister and free netdevs while driver is in the reset
-	 * recovery pending state. Since reset/rebuild happens through PF
-	 * service task workqueue, its not a good idea to unregister netdev
-	 * that is associated to the PF that is running the work queue items
-	 * currently. This is done to avoid check_flush_dependency() warning
-	 * on this wq
+	/* do not unregister while driver is in the reset recovery pending
+	 * state. Since reset/rebuild happens through PF service task workqueue,
+	 * it's not a good idea to unregister netdev that is associated to the
+	 * PF that is running the work queue items currently. This is done to
+	 * avoid check_flush_dependency() warning on this wq
 	 */
-	if (vsi->netdev && !ice_is_reset_in_progress(pf->state)) {
-		ice_napi_del(vsi);
+	if (vsi->netdev && !ice_is_reset_in_progress(pf->state))
 		unregister_netdev(vsi->netdev);
-		free_netdev(vsi->netdev);
-		vsi->netdev = NULL;
-	}
 
 	if (test_bit(ICE_FLAG_RSS_ENA, pf->flags))
 		ice_rss_clean(vsi);
@@ -2799,6 +2794,13 @@ int ice_vsi_release(struct ice_vsi *vsi)
 	ice_rm_vsi_lan_cfg(vsi->port_info, vsi->idx);
 	ice_vsi_delete(vsi);
 	ice_vsi_free_q_vectors(vsi);
+
+	/* make sure unregister_netdev() was called by checking __ICE_DOWN */
+	if (vsi->netdev && test_bit(__ICE_DOWN, vsi->state)) {
+		free_netdev(vsi->netdev);
+		vsi->netdev = NULL;
+	}
+
 	ice_vsi_clear_rings(vsi);
 
 	ice_vsi_put_qs(vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 7843abf4d44d..dbf3d39ad8b1 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1667,7 +1667,7 @@ static int ice_req_irq_msix_misc(struct ice_pf *pf)
  * ice_napi_del - Remove NAPI handler for the VSI
  * @vsi: VSI for which NAPI handler is to be removed
  */
-void ice_napi_del(struct ice_vsi *vsi)
+static void ice_napi_del(struct ice_vsi *vsi)
 {
 	int v_idx;
 
-- 
2.20.1

