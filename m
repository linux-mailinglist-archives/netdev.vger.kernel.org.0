Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A407A4EFBE4
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 22:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352686AbiDAU4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 16:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351348AbiDAU4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 16:56:49 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8032C1B989C
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 13:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648846499; x=1680382499;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FMI6ydfBoFNN0UVg1WgZWdrL+sFm//OISGLXOEbPfoU=;
  b=KKY9fdh5D+J3wB6HG+Li9x6mqlNXD7UcDMWLwV72sacdoc0NotN0mSDI
   gEmWnDnH81kb13Gm29zFdG5W9090et45IPqthkjdwcZHVFWnOgVkoE7m4
   m22erdvorpgQJw9wVXmHjqEvi0NyxNQY88MNkqQUYGY9FCSwQ4qAW0wI6
   dkvVw9j9skiE2CZNNprUoMzKj0BipLZtbyT/iAiGYqs6I8dhUPKyJscer
   Rsx5t6RHHgvV0Vh20Ialf5wcVlUqquzWBCdBYHvsmqwClZG70wRJe563y
   g9pvwANRYc5CrlCbcxBf8VkJCOwSTRgUiG7DUXaG/og+AWjB0E5tvIzh9
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10304"; a="260408782"
X-IronPort-AV: E=Sophos;i="5.90,228,1643702400"; 
   d="scan'208";a="260408782"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 13:54:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,228,1643702400"; 
   d="scan'208";a="844523406"
Received: from alicemic-1.jf.intel.com ([10.166.17.62])
  by fmsmga005.fm.intel.com with ESMTP; 01 Apr 2022 13:54:58 -0700
From:   Alice Michael <alice.michael@intel.com>
To:     alice.michael@intel.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        netdev@vger.kernel.org,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [net PATCH 2/2] ice: Do not skip not enabled queues in ice_vc_dis_qs_msg
Date:   Fri,  1 Apr 2022 05:14:53 -0700
Message-Id: <20220401121453.48415-3-alice.michael@intel.com>
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
        sleep 0.065 # adjust delay value for your machine
        ip link set dev ens785f0v0 down
done

Fixes: 77ca27c41705 ("ice: add support for virtchnl_queue_select.[tx|rx]_queues bitmap")

Signed-off-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Alice Michael <alice.michael@intel.com>
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

