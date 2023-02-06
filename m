Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 805C268C8EF
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 22:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjBFVtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 16:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjBFVs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 16:48:57 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C753E2DE55
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675720136; x=1707256136;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JkFZUI7YirhwWiZS0/apv6TEmIiY6P1sZ6JLrSNSEuU=;
  b=mjxZB2iHv7YL/IcP8xIdHtcWK2o1WW/9cDz8mp1jJB1o+KoNq7mM6/O4
   JSTqlq/F0MGobA2ooFfNvAeNpu1Y1lBCXo7HljcyV9fyHOxRJvqUlKhPY
   Lhr0QeWC+BLEBy82XdfoJFqrzkjY52uKholNoi5ET2KchHIzSD+ZTtT/x
   Q33pzmmmdInkoAbK6D4M0hbrXKXkzOZBr0rmeXE8lWyU1AvmUpkM7TgXb
   EpczdxP09YqfqGcm7eqhvdwnlmFSUuDcUM3pvFzVVhTO3uEd9fx5OzH80
   GIUYJwksgPIypn6UuA7TMeAnr+jtID9pC12R+Llyasz1asu1H5m7HOpbP
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="317338121"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="317338121"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 13:48:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="616576199"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="616576199"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga003.jf.intel.com with ESMTP; 06 Feb 2023 13:48:33 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 07/13] ice: Pull common tasks into ice_vf_post_vsi_rebuild
Date:   Mon,  6 Feb 2023 13:48:07 -0800
Message-Id: <20230206214813.20107-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230206214813.20107-1-anthony.l.nguyen@intel.com>
References: <20230206214813.20107-1-anthony.l.nguyen@intel.com>
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

From: Jacob Keller <jacob.e.keller@intel.com>

The Single Root IOV implementation of .post_vsi_rebuild performs some tasks
that will ultimately need to be shared with the Scalable IOV implementation
such as rebuilding the host configuration.

Refactor by introducing a new wrapper function, ice_vf_post_vsi_rebuild
which performs the tasks that will be shared between SR-IOV and Scalable
IOV. Move the ice_vf_rebuild_host_cfg and ice_vf_set_initialized calls into
this wrapper. Then call the implementation specific post_vsi_rebuild
handler afterwards.

This ensures that we will properly re-initialize filters and expected
settings for both SR-IOV and Scalable IOV.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c  |  2 --
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 19 +++++++++++++++++--
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index de20e50623d7..6ff29be974c5 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -816,8 +816,6 @@ static int ice_sriov_vsi_rebuild(struct ice_vf *vf)
  */
 static void ice_sriov_post_vsi_rebuild(struct ice_vf *vf)
 {
-	ice_vf_rebuild_host_cfg(vf);
-	ice_vf_set_initialized(vf);
 	ice_ena_vf_mappings(vf);
 	wr32(&vf->pf->hw, VFGEN_RSTAT(vf->vf_id), VIRTCHNL_VFR_VFACTIVE);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 5fecbec55f54..624c7de8b205 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -270,6 +270,21 @@ static int ice_vf_rebuild_vsi(struct ice_vf *vf)
 	return 0;
 }
 
+/**
+ * ice_vf_post_vsi_rebuild - Reset tasks that occur after VSI rebuild
+ * @vf: the VF being reset
+ *
+ * Perform reset tasks which must occur after the VSI has been re-created or
+ * rebuilt during a VF reset.
+ */
+static void ice_vf_post_vsi_rebuild(struct ice_vf *vf)
+{
+	ice_vf_rebuild_host_cfg(vf);
+	ice_vf_set_initialized(vf);
+
+	vf->vf_ops->post_vsi_rebuild(vf);
+}
+
 /**
  * ice_is_any_vf_in_unicast_promisc - check if any VF(s)
  * are in unicast promiscuous mode
@@ -495,7 +510,7 @@ void ice_reset_all_vfs(struct ice_pf *pf)
 
 		ice_vf_pre_vsi_rebuild(vf);
 		ice_vf_rebuild_vsi(vf);
-		vf->vf_ops->post_vsi_rebuild(vf);
+		ice_vf_post_vsi_rebuild(vf);
 
 		mutex_unlock(&vf->cfg_lock);
 	}
@@ -646,7 +661,7 @@ int ice_reset_vf(struct ice_vf *vf, u32 flags)
 		goto out_unlock;
 	}
 
-	vf->vf_ops->post_vsi_rebuild(vf);
+	ice_vf_post_vsi_rebuild(vf);
 	vsi = ice_get_vf_vsi(vf);
 	if (WARN_ON(!vsi)) {
 		err = -EINVAL;
-- 
2.38.1

