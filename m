Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321D04F1B22
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbiDDVTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380000AbiDDShF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 14:37:05 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66BC31377
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 11:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649097308; x=1680633308;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9i5N2kdovrMjkJVJ8OpJnREa2a4QPnvunObS4Bu8G2w=;
  b=mqsfPMZjDp/DwJIzCWXvzInYEcpjDZvX09NLByKrSzyvSeJlPj/2btue
   0S95w+JDlOkAENyRus5xOrpyt481SEz+gZTGHqJt5lFlTpGVsODDhCYiv
   81gxRBK/srbwLpgYhnV0Rmk0ua2Gp1DPkhVViCumHGNQtqcklEF+7Xjki
   qx3YOkJz/mTdxVZ8axRuzeMr6Cx8JjtCL97UV/+MPu0BaHkQs6YihDiza
   onKS2hYmZR2UV47XzvZlG304iIhs+umy1fTI8w500KEUhWMGO/nEv/zym
   NuAgSYQkRoI7U/sUuKqvjeNztZhKFY6xT/kdllGBoBdmpLg3vkjU843Nq
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="242726701"
X-IronPort-AV: E=Sophos;i="5.90,235,1643702400"; 
   d="scan'208";a="242726701"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 11:35:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,235,1643702400"; 
   d="scan'208";a="789578305"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 04 Apr 2022 11:35:06 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Alice Michael <alice.michael@intel.com>
Subject: [PATCH net v2 1/2] ice: Set txq_teid to ICE_INVAL_TEID on ring creation
Date:   Mon,  4 Apr 2022 11:35:47 -0700
Message-Id: <20220404183548.3422851-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220404183548.3422851-1-anthony.l.nguyen@intel.com>
References: <20220404183548.3422851-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>

When VF is freshly created, but not brought up, ring->txq_teid
value is by default set to 0.
But 0 is a valid TEID. On some platforms the Root Node of
Tx scheduler has a TEID = 0. This can cause issues as shown below.

The proper way is to set ring->txq_teid to ICE_INVAL_TEID (0xFFFFFFFF).

Testing Hints:
echo 1 > /sys/class/net/ens785f0/device/sriov_numvfs
ip link set dev ens785f0v0 up
ip link set dev ens785f0v0 down

If we have freshly created VF and quickly turn it on and off, so there
would be no time to reach VIRTCHNL_OP_CONFIG_VSI_QUEUES stage, then
VIRTCHNL_OP_DISABLE_QUEUES stage will fail with error:
[  639.531454] disable queue 89 failed 14
[  639.532233] Failed to disable LAN Tx queues, error: ICE_ERR_AQ_ERROR
[  639.533107] ice 0000:02:00.0: Failed to stop Tx ring 0 on VSI 5

The reason for the fail is that we are trying to send AQ command to
delete queue 89, which has never been created and receive an "invalid
argument" error from firmware.

As this queue has never been created, it's teid and ring->txq_teid
have default value 0.
ice_dis_vsi_txq has a check against non-existent queues:

node = ice_sched_find_node_by_teid(pi->root, q_teids[i]);
if (!node)
	continue;

But on some platforms the Root Node of Tx scheduler has a teid = 0.
Hence, ice_sched_find_node_by_teid finds a node with teid = 0 (it is
pi->root), and we go further to submit an erroneous request to firmware.

Fixes: 37bb83901286 ("ice: Move common functions out of ice_main.c part 7/7")
Signed-off-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Alice Michael <alice.michael@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 6d6233204388..2774cbd5b12a 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1480,6 +1480,7 @@ static int ice_vsi_alloc_rings(struct ice_vsi *vsi)
 		ring->tx_tstamps = &pf->ptp.port.tx;
 		ring->dev = dev;
 		ring->count = vsi->num_tx_desc;
+		ring->txq_teid = ICE_INVAL_TEID;
 		if (dvm_ena)
 			ring->flags |= ICE_TX_FLAGS_RING_VLAN_L2TAG2;
 		else
-- 
2.31.1

