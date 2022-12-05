Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C386436D3
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 22:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbiLEV0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 16:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233584AbiLEV0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 16:26:25 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22A12CCB9
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 13:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670275530; x=1701811530;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bgd6T5fI3q2CL1NnkswbX8lOIUnGss4LcCrtg9G9+60=;
  b=mGmbzZXZQrqYk5xif5DGka104jXUxAXmUI/E6dxcmgls0hWES9a1LaEd
   9ZkwCMeDrvJWC+Ve6uuWp5no6z5SISKK7z+v+u9DbGJu//o3zMCN+GNvX
   iMHLgjsOzqwrU6eg8z3oWt5WzXV2ORHpFkZT67kWsQjRTi9zmNNHwel+p
   G20WVBKczvH+TsaHAJy6uNSRKH8Yk4qBPZlQekhhZGz69zlg03EoBjDZv
   PRDrXQ7t3FLGH01NqHLDD3RLR5ol0+QadGdccd8RdbudOEMw3PiRR2yPq
   gnEM2MipYQqBAQNRO5lP9wbykwv9dIU0OXNpr236+RT47xeZ9RIZOawdL
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="317611109"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="317611109"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 13:25:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="752359272"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="752359272"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 05 Dec 2022 13:25:28 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Jaron <michalx.jaron@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Kamil Maziarz <kamil.maziarz@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net 1/3] i40e: Fix not setting default xps_cpus after reset
Date:   Mon,  5 Dec 2022 13:25:21 -0800
Message-Id: <20221205212523.3197565-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221205212523.3197565-1-anthony.l.nguyen@intel.com>
References: <20221205212523.3197565-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Jaron <michalx.jaron@intel.com>

During tx rings configuration default XPS queue config is set and
__I40E_TX_XPS_INIT_DONE is locked. __I40E_TX_XPS_INIT_DONE state is
cleared and set again with default mapping only during queues build,
it means after first setup or reset with queues rebuild. (i.e.
ethtool -L <interface> combined <number>) After other resets (i.e.
ethtool -t <interface>) XPS_INIT_DONE is not cleared and those default
maps cannot be set again. It results in cleared xps_cpus mapping
until queues are not rebuild or mapping is not set by user.

Add clearing __I40E_TX_XPS_INIT_DONE state during reset to let
the driver set xps_cpus to defaults again after it was cleared.

Fixes: 6f853d4f8e93 ("i40e: allow XPS with QoS enabled")
Signed-off-by: Michal Jaron <michalx.jaron@intel.com>
Signed-off-by: Kamil Maziarz <kamil.maziarz@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index b3cb587a2032..6416322d7c18 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -10654,6 +10654,21 @@ static int i40e_rebuild_channels(struct i40e_vsi *vsi)
 	return 0;
 }
 
+/**
+ * i40e_clean_xps_state - clean xps state for every tx_ring
+ * @vsi: ptr to the VSI
+ **/
+static void i40e_clean_xps_state(struct i40e_vsi *vsi)
+{
+	int i;
+
+	if (vsi->tx_rings)
+		for (i = 0; i < vsi->num_queue_pairs; i++)
+			if (vsi->tx_rings[i])
+				clear_bit(__I40E_TX_XPS_INIT_DONE,
+					  vsi->tx_rings[i]->state);
+}
+
 /**
  * i40e_prep_for_reset - prep for the core to reset
  * @pf: board private structure
@@ -10678,8 +10693,10 @@ static void i40e_prep_for_reset(struct i40e_pf *pf)
 	i40e_pf_quiesce_all_vsi(pf);
 
 	for (v = 0; v < pf->num_alloc_vsi; v++) {
-		if (pf->vsi[v])
+		if (pf->vsi[v]) {
+			i40e_clean_xps_state(pf->vsi[v]);
 			pf->vsi[v]->seid = 0;
+		}
 	}
 
 	i40e_shutdown_adminq(&pf->hw);
-- 
2.35.1

