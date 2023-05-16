Return-Path: <netdev+bounces-3060-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 87338705527
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:40:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 841691C20B49
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 17:40:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F3DC13AC3;
	Tue, 16 May 2023 17:39:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34760125C9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 17:39:56 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1966582
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 10:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684258794; x=1715794794;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V8fB5ruAIXvfib59eKusUwWoADto7+MLGjcu5Qyein4=;
  b=h29A/SUIRsmCdYy3kFClgzEJnIWgGlAZJkbalkKvaAlUerfpQMXTPjQZ
   RikmGOJetU/CCvaivda5i9G3XVuYXNzyDv47muYxh1fxorTi2S4AtceDN
   rZ0rihF+ljRmMvawpxMhO6bP/gyfexjN4+1xQCTbnVd7tNCY1O6zSk7ut
   +vtctTn5ffzA9hTVlYgnUaMlVBYIaBlGbHSQXSFpNMotzuhP/cBMHo2xs
   VCTogXfiYPQanob2yO8ZZVi4yDHr3OPDUuDZFKoyqtLlzJbWFIvE0WMMw
   JjpLoPdNEEb8hTyRLL3dolDXm8kDImeDxekcWbRV4q6EVuNEOq/Uej1Kj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="379730748"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="379730748"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 10:39:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="704489420"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="704489420"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga007.fm.intel.com with ESMTP; 16 May 2023 10:39:52 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Dawid Wesierski <dawidx.wesierski@intel.com>,
	anthony.l.nguyen@intel.com,
	leonro@nvidia.com,
	Kamil Maziarz <kamil.maziarz@intel.com>,
	Jacob Keller <Jacob.e.keller@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>
Subject: [PATCH net v2 2/3] ice: Fix ice VF reset during iavf initialization
Date: Tue, 16 May 2023 10:36:09 -0700
Message-Id: <20230516173610.2706835-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230516173610.2706835-1-anthony.l.nguyen@intel.com>
References: <20230516173610.2706835-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Dawid Wesierski <dawidx.wesierski@intel.com>

Fix the current implementation that causes ice_trigger_vf_reset()
to start resetting the VF even when the VF-NIC is still initializing.

When we reset NIC with ice driver it can interfere with
iavf-vf initialization e.g. during consecutive resets induced by ice

iavf                ice
  |                  |
  |<-----------------|
  |            ice resets vf
 iavf                |
 reset               |
 start               |
  |<-----------------|
  |             ice resets vf
  |             causing iavf
  |             initialization
  |             error
  |                  |
 iavf
 reset
 end

This leads to a series of -53 errors
(failed to init adminq) from the IAVF.

Change the state of the vf_state field to be not active when the IAVF
is still initializing. Make sure to wait until receiving the message on
the message box to ensure that the vf is ready and initializded.

In simple terms we use the ACTIVE flag to make sure that the ice
driver knows if the iavf is ready for another reset

  iavf                  ice
    |                    |
    |                    |
    |<------------- ice resets vf
  iavf           vf_state != ACTIVE
  reset                  |
  start                  |
    |                    |
    |                    |
  iavf                   |
  reset-------> vf_state == ACTIVE
  end              ice resets vf
    |                    |
    |                    |

Fixes: c54d209c78b8 ("ice: Wait for VF to be reset/ready before configuration")
Signed-off-by: Dawid Wesierski <dawidx.wesierski@intel.com>
Signed-off-by: Kamil Maziarz <kamil.maziarz@intel.com>
Acked-by: Jacob Keller <Jacob.e.keller@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c    |  8 ++++----
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   | 19 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_vf_lib.h   |  1 +
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |  1 +
 4 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index f1dca59bd844..588ad8696756 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1171,7 +1171,7 @@ int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena)
 	if (!vf)
 		return -EINVAL;
 
-	ret = ice_check_vf_ready_for_cfg(vf);
+	ret = ice_check_vf_ready_for_reset(vf);
 	if (ret)
 		goto out_put_vf;
 
@@ -1286,7 +1286,7 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 		goto out_put_vf;
 	}
 
-	ret = ice_check_vf_ready_for_cfg(vf);
+	ret = ice_check_vf_ready_for_reset(vf);
 	if (ret)
 		goto out_put_vf;
 
@@ -1340,7 +1340,7 @@ int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
 		return -EOPNOTSUPP;
 	}
 
-	ret = ice_check_vf_ready_for_cfg(vf);
+	ret = ice_check_vf_ready_for_reset(vf);
 	if (ret)
 		goto out_put_vf;
 
@@ -1653,7 +1653,7 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 	if (!vf)
 		return -EINVAL;
 
-	ret = ice_check_vf_ready_for_cfg(vf);
+	ret = ice_check_vf_ready_for_reset(vf);
 	if (ret)
 		goto out_put_vf;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 89fd6982df09..bf74a2f3a4f8 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -185,6 +185,25 @@ int ice_check_vf_ready_for_cfg(struct ice_vf *vf)
 	return 0;
 }
 
+/**
+ * ice_check_vf_ready_for_reset - check if VF is ready to be reset
+ * @vf: VF to check if it's ready to be reset
+ *
+ * The purpose of this function is to ensure that the VF is not in reset,
+ * disabled, and is both initialized and active, thus enabling us to safely
+ * initialize another reset.
+ */
+int ice_check_vf_ready_for_reset(struct ice_vf *vf)
+{
+	int ret;
+
+	ret = ice_check_vf_ready_for_cfg(vf);
+	if (!ret && !test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states))
+		ret = -EAGAIN;
+
+	return ret;
+}
+
 /**
  * ice_trigger_vf_reset - Reset a VF on HW
  * @vf: pointer to the VF structure
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
index e3cda6fb71ab..a38ef00a3679 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
@@ -215,6 +215,7 @@ u16 ice_get_num_vfs(struct ice_pf *pf);
 struct ice_vsi *ice_get_vf_vsi(struct ice_vf *vf);
 bool ice_is_vf_disabled(struct ice_vf *vf);
 int ice_check_vf_ready_for_cfg(struct ice_vf *vf);
+int ice_check_vf_ready_for_reset(struct ice_vf *vf);
 void ice_set_vf_state_dis(struct ice_vf *vf);
 bool ice_is_any_vf_in_unicast_promisc(struct ice_pf *pf);
 void
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 97243c616d5d..f4a524f80b11 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -3955,6 +3955,7 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event,
 		ice_vc_notify_vf_link_state(vf);
 		break;
 	case VIRTCHNL_OP_RESET_VF:
+		clear_bit(ICE_VF_STATE_ACTIVE, vf->vf_states);
 		ops->reset_vf(vf);
 		break;
 	case VIRTCHNL_OP_ADD_ETH_ADDR:
-- 
2.38.1


