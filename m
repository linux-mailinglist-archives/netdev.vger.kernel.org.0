Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237464F1AE9
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377412AbiDDVTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380001AbiDDShF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 14:37:05 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E0F31376
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 11:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649097308; x=1680633308;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=biTM2SmOvlrxeQgHG3zR2GdaQG8fMTcaC3ngr3+5o54=;
  b=DflhD4UmUYlm00cFWonnZ/+SJmZJKbZKf0eP4RxkOr+zFgIg1q0g2lgU
   JHO+1pHKc7nUydC2khtMhPTXOSRjTQQUVkZwwR/eCUVBRCQFNUPieqJ6B
   qG43UZOelCUFsOsgKciAIgKNc6F3EpL7N5LaYfSMeeCTmbbdqpY2CGjNr
   UO1Hp0mtI0EhgiTbhdpKF24zW26KXtFJcuk8V32jYGoLyDIRUjno0Ir6q
   Z4nx3o31QQb9+Z8TGzf3E1JOLtooxyFyl56dtxZJhZaUit9Z9YzIA3zhs
   Oq+8xSCWMbpdixwxTxt7m2wpjse1MF0Lg8sv7ggMGLWFeuC/Qy003Th1K
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="242726702"
X-IronPort-AV: E=Sophos;i="5.90,235,1643702400"; 
   d="scan'208";a="242726702"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 11:35:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,235,1643702400"; 
   d="scan'208";a="789578310"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 04 Apr 2022 11:35:06 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Alice Michael <alice.michael@intel.com>
Subject: [PATCH net v2 2/2] ice: Do not skip not enabled queues in ice_vc_dis_qs_msg
Date:   Mon,  4 Apr 2022 11:35:48 -0700
Message-Id: <20220404183548.3422851-3-anthony.l.nguyen@intel.com>
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

Disable check for queue being enabled in ice_vc_dis_qs_msg, because
there could be a case when queues were created, but were not enabled.
We still need to delete those queues.

Normal workflow for VF looks like:
Enable path:
VIRTCHNL_OP_ADD_ETH_ADDR (opcode 10)
VIRTCHNL_OP_CONFIG_VSI_QUEUES (opcode 6)
VIRTCHNL_OP_ENABLE_QUEUES (opcode 8)

Disable path:
VIRTCHNL_OP_DISABLE_QUEUES (opcode 9)
VIRTCHNL_OP_DEL_ETH_ADDR (opcode 11)

The issue appears only in stress conditions when VF is enabled and
disabled very fast.
Eventually there will be a case, when queues are created by
VIRTCHNL_OP_CONFIG_VSI_QUEUES, but are not enabled by
VIRTCHNL_OP_ENABLE_QUEUES.
In turn, these queues are not deleted by VIRTCHNL_OP_DISABLE_QUEUES,
because there is a check whether queues are enabled in
ice_vc_dis_qs_msg.

When we bring up the VF again, we will see the "Failed to set LAN Tx queue
context" error during VIRTCHNL_OP_CONFIG_VSI_QUEUES step. This
happens because old 16 queues were not deleted and VF requests to create
16 more, but ice_sched_get_free_qparent in ice_ena_vsi_txq would fail to
find a parent node for first newly requested queue (because all nodes
are allocated to 16 old queues).

Testing Hints:

Just enable and disable VF fast enough, so it would be disabled before
reaching VIRTCHNL_OP_ENABLE_QUEUES.

while true; do
        ip link set dev ens785f0v0 up
        sleep 0.065 # adjust delay value for you machine
        ip link set dev ens785f0v0 down
done

Fixes: 77ca27c41705 ("ice: add support for virtchnl_queue_select.[tx|rx]_queues bitmap")
Signed-off-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Alice Michael <alice.michael@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 3f1a63815bac..69ff4b929772 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -1358,9 +1358,9 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 				goto error_param;
 			}
 
-			/* Skip queue if not enabled */
 			if (!test_bit(vf_q_id, vf->txq_ena))
-				continue;
+				dev_dbg(ice_pf_to_dev(vsi->back), "Queue %u on VSI %u is not enabled, but stopping it anyway\n",
+					vf_q_id, vsi->vsi_num);
 
 			ice_fill_txq_meta(vsi, ring, &txq_meta);
 
-- 
2.31.1

