Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35B4F4EFBE2
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 22:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352548AbiDAU4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 16:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351348AbiDAU4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 16:56:48 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C861B1B98A4
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 13:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648846498; x=1680382498;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AmKzgv9tavYzGg0lCV3kJoDlb2z+Lszuu9ifTZ9nSYo=;
  b=AB+yp6n+k25sPvu5rCvbpKk3qZALISJi3Hb2LA89gPZhvsXA5yyE+GT9
   Q81GiyFnIJmRUWjCNQKyerntQD5VnyHvqBdxKW4GE2/VNI5DOgl77aEGJ
   Bady2mKADjWaFmmsXYRQLVG82vMzYFvRqigDqqt0G1zC1ITk5p6FkiRup
   Hd8UnXO8RjtyKX3+sQQi8tlwiIxJskntm4mDuoQ9cgho+ypAp2uPqvV9h
   nPRvX0U4nBpNO/bt2YQSUUyoxjcbhbvAI70+klmnrHMS5ghCyjTk6+uYJ
   O+TSWstwed0y0wsTPU8IpRq1YKV4dY4RREnNHEje3/F56Cw1LzdDYoL8S
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10304"; a="260408780"
X-IronPort-AV: E=Sophos;i="5.90,228,1643702400"; 
   d="scan'208";a="260408780"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 13:54:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,228,1643702400"; 
   d="scan'208";a="844523394"
Received: from alicemic-1.jf.intel.com ([10.166.17.62])
  by fmsmga005.fm.intel.com with ESMTP; 01 Apr 2022 13:54:57 -0700
From:   Alice Michael <alice.michael@intel.com>
To:     alice.michael@intel.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        netdev@vger.kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [net PATCH 1/2] ice: Set txq_teid to ICE_INVAL_TEID on ring creation
Date:   Fri,  1 Apr 2022 05:14:52 -0700
Message-Id: <20220401121453.48415-2-alice.michael@intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220401121453.48415-1-alice.michael@intel.com>
References: <20220401121453.48415-1-alice.michael@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

