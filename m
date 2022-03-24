Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0AB4E62AC
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 12:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349842AbiCXLuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 07:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbiCXLux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 07:50:53 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E84E90248;
        Thu, 24 Mar 2022 04:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648122561; x=1679658561;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fECszOYEZOUyl14+HZj9rYJBYIJYg6fObv2pkVS8d9o=;
  b=B5sOk4XyQj0Lpwo50B9gjIhJQ6aaPuld4gpjmuC0hZLzp0pwN3nQFu5y
   eaIado3IGjGAIkALWxZDX02LjOLWNFdYxVUyWYc7QMN8Sw/8iqGBIkGxd
   Fj5V878OuUdTLtaPslHKrkw4kzlLd4Q+AsdOGWJQLQ/sIdWqSxzibacvJ
   8svquKQi+TwahJr4W028LU24rrjgv4T2u2z0byzmiP0BIRCS9ygdPB0Zg
   IQIxzmrE5np1vDb5JYTLpVXg/aJOESwNYQVSj6yRVFnprY5sIy/KRJBoD
   vqKOSmOOgHVZomQCbgQugEyYHVzq/kiaqWKl68mG7mfEVHSveNXtEN4hz
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10295"; a="238297364"
X-IronPort-AV: E=Sophos;i="5.90,207,1643702400"; 
   d="scan'208";a="238297364"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2022 04:49:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,207,1643702400"; 
   d="scan'208";a="717788188"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga005.jf.intel.com with ESMTP; 24 Mar 2022 04:49:17 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, davem@davemloft.net,
        magnus.karlsson@intel.com, alexandr.lobakin@intel.com,
        pabeni@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH intel-next] ice: introduce common helper for retrieving VSI by vsi_num
Date:   Thu, 24 Mar 2022 12:49:07 +0100
Message-Id: <20220324114907.73459-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both ice_idc.c and ice_virtchnl.c carry their own implementation of a
helper function that is looking for a given VSI based on provided
vsi_num. Their functionality is the same, so let's introduce the common
function in ice.h that both of the mentioned sites will use.

This is a strictly cleanup thing, no functionality is changed.

Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          | 15 +++++++++++++
 drivers/net/ethernet/intel/ice/ice_idc.c      | 15 -------------
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 22 ++-----------------
 3 files changed, 17 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index e9aa1fb43c3a..a541446b96e8 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -756,6 +756,21 @@ static inline struct ice_vsi *ice_get_ctrl_vsi(struct ice_pf *pf)
 	return pf->vsi[pf->ctrl_vsi_idx];
 }
 
+/**
+ * ice_find_vsi - Find the VSI from VSI ID
+ * @pf: The PF pointer to search in
+ * @vsi_num: The VSI ID to search for
+ */
+static inline struct ice_vsi *ice_find_vsi(struct ice_pf *pf, u16 vsi_num)
+{
+	int i;
+
+	ice_for_each_vsi(pf, i)
+		if (pf->vsi[i] && pf->vsi[i]->vsi_num == vsi_num)
+			return  pf->vsi[i];
+	return NULL;
+}
+
 /**
  * ice_is_switchdev_running - check if switchdev is configured
  * @pf: pointer to PF structure
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index 73aa520317d4..56e03d0e319f 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -44,21 +44,6 @@ void ice_send_event_to_aux(struct ice_pf *pf, struct iidc_event *event)
 	device_unlock(&pf->adev->dev);
 }
 
-/**
- * ice_find_vsi - Find the VSI from VSI ID
- * @pf: The PF pointer to search in
- * @vsi_num: The VSI ID to search for
- */
-static struct ice_vsi *ice_find_vsi(struct ice_pf *pf, u16 vsi_num)
-{
-	int i;
-
-	ice_for_each_vsi(pf, i)
-		if (pf->vsi[i] && pf->vsi[i]->vsi_num == vsi_num)
-			return  pf->vsi[i];
-	return NULL;
-}
-
 /**
  * ice_add_rdma_qset - Add Leaf Node for RDMA Qset
  * @pf: PF struct
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 3f1a63815bac..8ddb462e1af2 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -514,24 +514,6 @@ static void ice_vc_reset_vf_msg(struct ice_vf *vf)
 		ice_reset_vf(vf, 0);
 }
 
-/**
- * ice_find_vsi_from_id
- * @pf: the PF structure to search for the VSI
- * @id: ID of the VSI it is searching for
- *
- * searches for the VSI with the given ID
- */
-static struct ice_vsi *ice_find_vsi_from_id(struct ice_pf *pf, u16 id)
-{
-	int i;
-
-	ice_for_each_vsi(pf, i)
-		if (pf->vsi[i] && pf->vsi[i]->vsi_num == id)
-			return pf->vsi[i];
-
-	return NULL;
-}
-
 /**
  * ice_vc_isvalid_vsi_id
  * @vf: pointer to the VF info
@@ -544,7 +526,7 @@ bool ice_vc_isvalid_vsi_id(struct ice_vf *vf, u16 vsi_id)
 	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
 
-	vsi = ice_find_vsi_from_id(pf, vsi_id);
+	vsi = ice_find_vsi(pf, vsi_id);
 
 	return (vsi && (vsi->vf == vf));
 }
@@ -559,7 +541,7 @@ bool ice_vc_isvalid_vsi_id(struct ice_vf *vf, u16 vsi_id)
  */
 static bool ice_vc_isvalid_q_id(struct ice_vf *vf, u16 vsi_id, u8 qid)
 {
-	struct ice_vsi *vsi = ice_find_vsi_from_id(vf->pf, vsi_id);
+	struct ice_vsi *vsi = ice_find_vsi(vf->pf, vsi_id);
 	/* allocated Tx and Rx queues should be always equal for VF VSI */
 	return (vsi && (qid < vsi->alloc_txq));
 }
-- 
2.27.0

