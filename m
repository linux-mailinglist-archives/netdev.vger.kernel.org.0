Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0518F350A8E
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 01:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbhCaXHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 19:07:53 -0400
Received: from mga14.intel.com ([192.55.52.115]:62994 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231620AbhCaXH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 19:07:27 -0400
IronPort-SDR: HkH1sef/HDdD+UDC5fwo0oJ2Q9ttcoRgvJzaCRGiUJ852lHyuiN120HPmxWyG7Hi6+HSNlkTX+
 RdSYW0jN8FXQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9940"; a="191587985"
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="191587985"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 16:07:25 -0700
IronPort-SDR: +xSv1HoqCKdWZLFDOZW+r+cbXL9exrB3nbMi1S7nMZ+hjapGYgZJb563ZQHT9LSD3anzHn3YYh
 rFJ2ACaDCsIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="610680141"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 31 Mar 2021 16:07:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 12/15] ice: Refactor ice_set/get_rss into LUT and key specific functions
Date:   Wed, 31 Mar 2021 16:08:55 -0700
Message-Id: <20210331230858.782492-13-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
References: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently ice_set/get_rss are used to set/get the RSS LUT and/or RSS
key. However nearly everywhere these functions are called only the LUT
or key are set/get. Also, making this change reduces how many things
ice_set/get_rss are doing. Fix this by adding ice_set/get_rss_lut and
ice_set/get_rss_key functions.

Also, consolidate all calls for setting/getting the RSS LUT and RSS Key
to use ice_set/get_rss_lut() and ice_set/get_rss_key().

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |   6 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  43 +++---
 drivers/net/ethernet/intel/ice/ice_lib.c      |  42 ++----
 drivers/net/ethernet/intel/ice/ice_main.c     | 139 ++++++++++--------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   4 +-
 5 files changed, 117 insertions(+), 117 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index ecbf62eddcc9..17705db51022 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -621,8 +621,10 @@ int ice_destroy_xdp_rings(struct ice_vsi *vsi);
 int
 ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 	     u32 flags);
-int ice_set_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size);
-int ice_get_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size);
+int ice_set_rss_lut(struct ice_vsi *vsi, u8 *lut, u16 lut_size);
+int ice_get_rss_lut(struct ice_vsi *vsi, u8 *lut, u16 lut_size);
+int ice_set_rss_key(struct ice_vsi *vsi, u8 *seed);
+int ice_get_rss_key(struct ice_vsi *vsi, u8 *seed);
 void ice_fill_rss_lut(u8 *lut, u16 rss_table_size, u16 rss_size);
 int ice_schedule_reset(struct ice_pf *pf, enum ice_reset_req reset);
 void ice_print_link_msg(struct ice_vsi *vsi, bool isup);
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 0840fcf2f2cc..998629b9767f 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3140,7 +3140,7 @@ ice_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key, u8 *hfunc)
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
-	int ret = 0, i;
+	int err, i;
 	u8 *lut;
 
 	if (hfunc)
@@ -3159,17 +3159,20 @@ ice_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key, u8 *hfunc)
 	if (!lut)
 		return -ENOMEM;
 
-	if (ice_get_rss(vsi, key, lut, vsi->rss_table_size)) {
-		ret = -EIO;
+	err = ice_get_rss_key(vsi, key);
+	if (err)
+		goto out;
+
+	err = ice_get_rss_lut(vsi, lut, vsi->rss_table_size);
+	if (err)
 		goto out;
-	}
 
 	for (i = 0; i < vsi->rss_table_size; i++)
 		indir[i] = (u32)(lut[i]);
 
 out:
 	kfree(lut);
-	return ret;
+	return err;
 }
 
 /**
@@ -3190,7 +3193,7 @@ ice_set_rxfh(struct net_device *netdev, const u32 *indir, const u8 *key,
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
 	struct device *dev;
-	u8 *seed = NULL;
+	int err;
 
 	dev = ice_pf_to_dev(pf);
 	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
@@ -3211,7 +3214,10 @@ ice_set_rxfh(struct net_device *netdev, const u32 *indir, const u8 *key,
 				return -ENOMEM;
 		}
 		memcpy(vsi->rss_hkey_user, key, ICE_VSIQF_HKEY_ARRAY_SIZE);
-		seed = vsi->rss_hkey_user;
+
+		err = ice_set_rss_key(vsi, vsi->rss_hkey_user);
+		if (err)
+			return err;
 	}
 
 	if (!vsi->rss_lut_user) {
@@ -3232,8 +3238,9 @@ ice_set_rxfh(struct net_device *netdev, const u32 *indir, const u8 *key,
 				 vsi->rss_size);
 	}
 
-	if (ice_set_rss(vsi, seed, vsi->rss_lut_user, vsi->rss_table_size))
-		return -EIO;
+	err = ice_set_rss_lut(vsi, vsi->rss_lut_user, vsi->rss_table_size);
+	if (err)
+		return err;
 
 	return 0;
 }
@@ -3328,12 +3335,10 @@ static int ice_get_valid_rss_size(struct ice_hw *hw, int new_size)
  */
 static int ice_vsi_set_dflt_rss_lut(struct ice_vsi *vsi, int req_rss_size)
 {
-	struct ice_aq_get_set_rss_lut_params set_params = {};
 	struct ice_pf *pf = vsi->back;
-	enum ice_status status;
 	struct device *dev;
 	struct ice_hw *hw;
-	int err = 0;
+	int err;
 	u8 *lut;
 
 	dev = ice_pf_to_dev(pf);
@@ -3354,18 +3359,10 @@ static int ice_vsi_set_dflt_rss_lut(struct ice_vsi *vsi, int req_rss_size)
 
 	/* create/set RSS LUT */
 	ice_fill_rss_lut(lut, vsi->rss_table_size, vsi->rss_size);
-	set_params.vsi_handle = vsi->idx;
-	set_params.lut_size = vsi->rss_table_size;
-	set_params.lut_type = vsi->rss_lut_type;
-	set_params.lut = lut;
-	set_params.global_lut_id = 0;
-	status = ice_aq_set_rss_lut(hw, &set_params);
-	if (status) {
-		dev_err(dev, "Cannot set RSS lut, err %s aq_err %s\n",
-			ice_stat_str(status),
+	err = ice_set_rss_lut(vsi, lut, vsi->rss_table_size);
+	if (err)
+		dev_err(dev, "Cannot set RSS lut, err %d aq_err %s\n", err,
 			ice_aq_str(hw->adminq.sq_last_status));
-		err = -EIO;
-	}
 
 	kfree(lut);
 	return err;
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 22bcccd1073b..d3b99b1ea32a 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1326,7 +1326,7 @@ int ice_vsi_manage_rss_lut(struct ice_vsi *vsi, bool ena)
 					 vsi->rss_size);
 	}
 
-	err = ice_set_rss(vsi, NULL, lut, vsi->rss_table_size);
+	err = ice_set_rss_lut(vsi, lut, vsi->rss_table_size);
 	kfree(lut);
 	return err;
 }
@@ -1337,13 +1337,10 @@ int ice_vsi_manage_rss_lut(struct ice_vsi *vsi, bool ena)
  */
 static int ice_vsi_cfg_rss_lut_key(struct ice_vsi *vsi)
 {
-	struct ice_aq_get_set_rss_lut_params set_params = {};
-	struct ice_aqc_get_set_rss_keys *key;
 	struct ice_pf *pf = vsi->back;
-	enum ice_status status;
 	struct device *dev;
-	int err = 0;
-	u8 *lut;
+	u8 *lut, *key;
+	int err;
 
 	dev = ice_pf_to_dev(pf);
 	vsi->rss_size = min_t(u16, vsi->rss_size, vsi->num_rxq);
@@ -1357,41 +1354,26 @@ static int ice_vsi_cfg_rss_lut_key(struct ice_vsi *vsi)
 	else
 		ice_fill_rss_lut(lut, vsi->rss_table_size, vsi->rss_size);
 
-	set_params.vsi_handle = vsi->idx;
-	set_params.lut_size = vsi->rss_table_size;
-	set_params.lut_type = vsi->rss_lut_type;
-	set_params.lut = lut;
-	set_params.global_lut_id = 0;
-	status = ice_aq_set_rss_lut(&pf->hw, &set_params);
-
-	if (status) {
-		dev_err(dev, "set_rss_lut failed, error %s\n",
-			ice_stat_str(status));
-		err = -EIO;
+	err = ice_set_rss_lut(vsi, lut, vsi->rss_table_size);
+	if (err) {
+		dev_err(dev, "set_rss_lut failed, error %d\n", err);
 		goto ice_vsi_cfg_rss_exit;
 	}
 
-	key = kzalloc(sizeof(*key), GFP_KERNEL);
+	key = kzalloc(ICE_GET_SET_RSS_KEY_EXTEND_KEY_SIZE, GFP_KERNEL);
 	if (!key) {
 		err = -ENOMEM;
 		goto ice_vsi_cfg_rss_exit;
 	}
 
 	if (vsi->rss_hkey_user)
-		memcpy(key,
-		       (struct ice_aqc_get_set_rss_keys *)vsi->rss_hkey_user,
-		       ICE_GET_SET_RSS_KEY_EXTEND_KEY_SIZE);
+		memcpy(key, vsi->rss_hkey_user, ICE_GET_SET_RSS_KEY_EXTEND_KEY_SIZE);
 	else
-		netdev_rss_key_fill((void *)key,
-				    ICE_GET_SET_RSS_KEY_EXTEND_KEY_SIZE);
-
-	status = ice_aq_set_rss_key(&pf->hw, vsi->idx, key);
+		netdev_rss_key_fill((void *)key, ICE_GET_SET_RSS_KEY_EXTEND_KEY_SIZE);
 
-	if (status) {
-		dev_err(dev, "set_rss_key failed, error %s\n",
-			ice_stat_str(status));
-		err = -EIO;
-	}
+	err = ice_set_rss_key(vsi, key);
+	if (err)
+		dev_err(dev, "set_rss_key failed, error %d\n", err);
 
 	kfree(key);
 ice_vsi_cfg_rss_exit:
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 8085f0ab2441..9410af2067d2 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6317,99 +6317,118 @@ const char *ice_stat_str(enum ice_status stat_err)
 }
 
 /**
- * ice_set_rss - Set RSS keys and lut
+ * ice_set_rss_lut - Set RSS LUT
  * @vsi: Pointer to VSI structure
- * @seed: RSS hash seed
  * @lut: Lookup table
  * @lut_size: Lookup table size
  *
  * Returns 0 on success, negative on failure
  */
-int ice_set_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size)
+int ice_set_rss_lut(struct ice_vsi *vsi, u8 *lut, u16 lut_size)
 {
-	struct ice_pf *pf = vsi->back;
-	struct ice_hw *hw = &pf->hw;
+	struct ice_aq_get_set_rss_lut_params params = {};
+	struct ice_hw *hw = &vsi->back->hw;
 	enum ice_status status;
-	struct device *dev;
 
-	dev = ice_pf_to_dev(pf);
-	if (seed) {
-		struct ice_aqc_get_set_rss_keys *buf =
-				  (struct ice_aqc_get_set_rss_keys *)seed;
+	if (!lut)
+		return -EINVAL;
 
-		status = ice_aq_set_rss_key(hw, vsi->idx, buf);
+	params.vsi_handle = vsi->idx;
+	params.lut_size = lut_size;
+	params.lut_type = vsi->rss_lut_type;
+	params.lut = lut;
 
-		if (status) {
-			dev_err(dev, "Cannot set RSS key, err %s aq_err %s\n",
-				ice_stat_str(status),
-				ice_aq_str(hw->adminq.sq_last_status));
-			return -EIO;
-		}
+	status = ice_aq_set_rss_lut(hw, &params);
+	if (status) {
+		dev_err(ice_pf_to_dev(vsi->back), "Cannot set RSS lut, err %s aq_err %s\n",
+			ice_stat_str(status),
+			ice_aq_str(hw->adminq.sq_last_status));
+		return -EIO;
 	}
 
-	if (lut) {
-		struct ice_aq_get_set_rss_lut_params set_params = {
-			.vsi_handle = vsi->idx, .lut_size = lut_size,
-			.lut_type = vsi->rss_lut_type, .lut = lut,
-			.global_lut_id = 0
-		};
+	return 0;
+}
 
-		status = ice_aq_set_rss_lut(hw, &set_params);
-		if (status) {
-			dev_err(dev, "Cannot set RSS lut, err %s aq_err %s\n",
-				ice_stat_str(status),
-				ice_aq_str(hw->adminq.sq_last_status));
-			return -EIO;
-		}
+/**
+ * ice_set_rss_key - Set RSS key
+ * @vsi: Pointer to the VSI structure
+ * @seed: RSS hash seed
+ *
+ * Returns 0 on success, negative on failure
+ */
+int ice_set_rss_key(struct ice_vsi *vsi, u8 *seed)
+{
+	struct ice_hw *hw = &vsi->back->hw;
+	enum ice_status status;
+
+	if (!seed)
+		return -EINVAL;
+
+	status = ice_aq_set_rss_key(hw, vsi->idx, (struct ice_aqc_get_set_rss_keys *)seed);
+	if (status) {
+		dev_err(ice_pf_to_dev(vsi->back), "Cannot set RSS key, err %s aq_err %s\n",
+			ice_stat_str(status),
+			ice_aq_str(hw->adminq.sq_last_status));
+		return -EIO;
 	}
 
 	return 0;
 }
 
 /**
- * ice_get_rss - Get RSS keys and lut
+ * ice_get_rss_lut - Get RSS LUT
  * @vsi: Pointer to VSI structure
- * @seed: Buffer to store the keys
  * @lut: Buffer to store the lookup table entries
  * @lut_size: Size of buffer to store the lookup table entries
  *
  * Returns 0 on success, negative on failure
  */
-int ice_get_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size)
+int ice_get_rss_lut(struct ice_vsi *vsi, u8 *lut, u16 lut_size)
 {
-	struct ice_pf *pf = vsi->back;
-	struct ice_hw *hw = &pf->hw;
+	struct ice_aq_get_set_rss_lut_params params = {};
+	struct ice_hw *hw = &vsi->back->hw;
 	enum ice_status status;
-	struct device *dev;
 
-	dev = ice_pf_to_dev(pf);
-	if (seed) {
-		struct ice_aqc_get_set_rss_keys *buf =
-				  (struct ice_aqc_get_set_rss_keys *)seed;
+	if (!lut)
+		return -EINVAL;
 
-		status = ice_aq_get_rss_key(hw, vsi->idx, buf);
-		if (status) {
-			dev_err(dev, "Cannot get RSS key, err %s aq_err %s\n",
-				ice_stat_str(status),
-				ice_aq_str(hw->adminq.sq_last_status));
-			return -EIO;
-		}
+	params.vsi_handle = vsi->idx;
+	params.lut_size = lut_size;
+	params.lut_type = vsi->rss_lut_type;
+	params.lut = lut;
+
+	status = ice_aq_get_rss_lut(hw, &params);
+	if (status) {
+		dev_err(ice_pf_to_dev(vsi->back), "Cannot get RSS lut, err %s aq_err %s\n",
+			ice_stat_str(status),
+			ice_aq_str(hw->adminq.sq_last_status));
+		return -EIO;
 	}
 
-	if (lut) {
-		struct ice_aq_get_set_rss_lut_params get_params = {
-			.vsi_handle = vsi->idx, .lut_size = lut_size,
-			.lut_type = vsi->rss_lut_type, .lut = lut,
-			.global_lut_id = 0
-		};
+	return 0;
+}
 
-		status = ice_aq_get_rss_lut(hw, &get_params);
-		if (status) {
-			dev_err(dev, "Cannot get RSS lut, err %s aq_err %s\n",
-				ice_stat_str(status),
-				ice_aq_str(hw->adminq.sq_last_status));
-			return -EIO;
-		}
+/**
+ * ice_get_rss_key - Get RSS key
+ * @vsi: Pointer to VSI structure
+ * @seed: Buffer to store the key in
+ *
+ * Returns 0 on success, negative on failure
+ */
+int ice_get_rss_key(struct ice_vsi *vsi, u8 *seed)
+{
+	struct ice_hw *hw = &vsi->back->hw;
+	enum ice_status status;
+
+	if (!seed)
+		return -EINVAL;
+
+	status = ice_aq_get_rss_key(hw, vsi->idx, (struct ice_aqc_get_set_rss_keys *)seed);
+	if (status) {
+		dev_err(ice_pf_to_dev(vsi->back), "Cannot get RSS key, err %s aq_err %s\n",
+			ice_stat_str(status),
+			ice_aq_str(hw->adminq.sq_last_status));
+		return -EIO;
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 78679ece2e08..e68d52a6b11d 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -2233,7 +2233,7 @@ static int ice_vc_config_rss_key(struct ice_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
-	if (ice_set_rss(vsi, vrk->key, NULL, 0))
+	if (ice_set_rss_key(vsi, vrk->key))
 		v_ret = VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
 error_param:
 	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_RSS_KEY, v_ret,
@@ -2280,7 +2280,7 @@ static int ice_vc_config_rss_lut(struct ice_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
-	if (ice_set_rss(vsi, NULL, vrl->lut, ICE_VSIQF_HLUT_ARRAY_SIZE))
+	if (ice_set_rss_lut(vsi, vrl->lut, ICE_VSIQF_HLUT_ARRAY_SIZE))
 		v_ret = VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
 error_param:
 	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_RSS_LUT, v_ret,
-- 
2.26.2

