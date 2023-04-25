Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A746EE64C
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 19:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234894AbjDYRE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 13:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234888AbjDYRE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 13:04:27 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FCF5BB1
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 10:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682442265; x=1713978265;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9e014WTFJa41wnT4wPnZzj69gR5gjNJCjmSI5wsiu60=;
  b=ej5CDcEh/kvz4Fvget2LaUbFabG6/gzYyRY5mQKKVWEDeuAW7mgRlDfi
   40LetBC3fc0jQh114EDiLoOwTsfzJF+EvGKLf7a5OyIIsv4+C6/ZRvWzZ
   Q2Wh6u99Ar1I2vtUXC0TG+14K+o4HMrxWLFlX9GNaCEx1TjGLz4wHyAi5
   /VW7Qq//FBd7WlyAsI261Xp5ZPiSo2hmBsay+wy2NVqfX7JR3fGBUU/xn
   SiVgu0jXsTmNIcMaDqUXWVPPG5dZfQmcoQYUl5DJRbi0jaOpki4s9GZGY
   Wjrp0aSPiE1Vle6MPDIWmj4pOJ19A17cp9ybZU+sJJlMCRldI7ZxSz13h
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="326436779"
X-IronPort-AV: E=Sophos;i="5.99,226,1677571200"; 
   d="scan'208";a="326436779"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 10:04:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="724085194"
X-IronPort-AV: E=Sophos;i="5.99,226,1677571200"; 
   d="scan'208";a="724085194"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga008.jf.intel.com with ESMTP; 25 Apr 2023 10:04:23 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Dawid Wesierski <dawidx.wesierski@intel.com>,
        anthony.l.nguyen@intel.com,
        Kamil Maziarz <kamil.maziarz@intel.com>,
        Jacob Keller <Jacob.e.keller@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>
Subject: [PATCH net 2/3] ice: Fix ice VF reset during iavf initialization
Date:   Tue, 25 Apr 2023 10:01:26 -0700
Message-Id: <20230425170127.2522312-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230425170127.2522312-1-anthony.l.nguyen@intel.com>
References: <20230425170127.2522312-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dawid Wesierski <dawidx.wesierski@intel.com>

Fix the current implementation that causes ice_trigger_vf_reset()
to start resetting the VF even when the VF is still resetting itself
and initializing adminq. This leads to a series of -53 errors
(failed to init adminq) from the IAVF.

Change the state of the vf_state field to be not active when the IAVF
asks for a reset. To avoid issues caused by the VF being reset too
early, make sure to wait until receiving the message on the message
box to know the exact state of the IAVF driver.

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
index 0cc05e54a781..d4206db7d6d5 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1181,7 +1181,7 @@ int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena)
 	if (!vf)
 		return -EINVAL;
 
-	ret = ice_check_vf_ready_for_cfg(vf);
+	ret = ice_check_vf_ready_for_reset(vf);
 	if (ret)
 		goto out_put_vf;
 
@@ -1296,7 +1296,7 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 		goto out_put_vf;
 	}
 
-	ret = ice_check_vf_ready_for_cfg(vf);
+	ret = ice_check_vf_ready_for_reset(vf);
 	if (ret)
 		goto out_put_vf;
 
@@ -1350,7 +1350,7 @@ int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
 		return -EOPNOTSUPP;
 	}
 
-	ret = ice_check_vf_ready_for_cfg(vf);
+	ret = ice_check_vf_ready_for_reset(vf);
 	if (ret)
 		goto out_put_vf;
 
@@ -1663,7 +1663,7 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 	if (!vf)
 		return -EINVAL;
 
-	ret = ice_check_vf_ready_for_cfg(vf);
+	ret = ice_check_vf_ready_for_reset(vf);
 	if (ret)
 		goto out_put_vf;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 0e57bd1b85fd..59524a7c88c5 100644
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
index ef30f05b5d02..3fc6a0a8d955 100644
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
index e24e3f5017ca..d8c66baf4eb4 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -3908,6 +3908,7 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 		ice_vc_notify_vf_link_state(vf);
 		break;
 	case VIRTCHNL_OP_RESET_VF:
+		clear_bit(ICE_VF_STATE_ACTIVE, vf->vf_states);
 		ops->reset_vf(vf);
 		break;
 	case VIRTCHNL_OP_ADD_ETH_ADDR:
-- 
2.38.1

