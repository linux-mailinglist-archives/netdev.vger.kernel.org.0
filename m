Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54AD945966F
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 22:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239943AbhKVVPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 16:15:52 -0500
Received: from mga17.intel.com ([192.55.52.151]:19479 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238475AbhKVVPs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 16:15:48 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10176"; a="215593736"
X-IronPort-AV: E=Sophos;i="5.87,255,1631602800"; 
   d="scan'208";a="215593736"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2021 13:12:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,255,1631602800"; 
   d="scan'208";a="570478293"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 22 Nov 2021 13:12:41 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, linux-rdma@vger.kernel.org,
        mustafa.ismail@intel.com, jacob.e.keller@intel.com,
        parav@nvidia.com, jiri@nvidia.com,
        Leszek Kaliszczuk <leszek.kaliszczuk@intel.com>
Subject: [PATCH net-next 2/3] net/ice: Add support for enable_iwarp and enable_roce devlink param
Date:   Mon, 22 Nov 2021 13:11:18 -0800
Message-Id: <20211122211119.279885-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211122211119.279885-1-anthony.l.nguyen@intel.com>
References: <20211122211119.279885-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem@intel.com>

Allow support for 'enable_iwarp' and 'enable_roce' devlink params to turn
on/off iWARP or RoCE protocol support for E800 devices.

For example, a user can turn on iWARP functionality with,

devlink dev param set pci/0000:07:00.0 name enable_iwarp value true cmode runtime

This add an iWARP auxiliary rdma device, ice.iwarp.<>, under this PF.

A user request to enable both iWARP and RoCE under the same PF is rejected
since this device does not support both protocols simultaneously on the
same port.

Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Tested-by: Leszek Kaliszczuk <leszek.kaliszczuk@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         |   1 +
 drivers/net/ethernet/intel/ice/ice_devlink.c | 144 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_devlink.h |   6 +
 drivers/net/ethernet/intel/ice/ice_idc.c     |   4 +-
 drivers/net/ethernet/intel/ice/ice_main.c    |   9 +-
 include/linux/net/intel/iidc.h               |   7 +-
 6 files changed, 166 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index b2db39ee5f85..b67ad51cbcc9 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -576,6 +576,7 @@ struct ice_pf {
 	struct ice_hw_port_stats stats_prev;
 	struct ice_hw hw;
 	u8 stat_prev_loaded:1; /* has previous stats been loaded */
+	u8 rdma_mode;
 	u16 dcbx_cap;
 	u32 tx_timeout_count;
 	unsigned long tx_timeout_last_recovery;
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index b9bd9f9472f6..478412b28a76 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -430,6 +430,120 @@ static const struct devlink_ops ice_devlink_ops = {
 	.flash_update = ice_devlink_flash_update,
 };
 
+static int
+ice_devlink_enable_roce_get(struct devlink *devlink, u32 id,
+			    struct devlink_param_gset_ctx *ctx)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+
+	ctx->val.vbool = pf->rdma_mode & IIDC_RDMA_PROTOCOL_ROCEV2;
+
+	return 0;
+}
+
+static int
+ice_devlink_enable_roce_set(struct devlink *devlink, u32 id,
+			    struct devlink_param_gset_ctx *ctx)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+	bool roce_ena = ctx->val.vbool;
+	int ret;
+
+	if (!roce_ena) {
+		ice_unplug_aux_dev(pf);
+		pf->rdma_mode &= ~IIDC_RDMA_PROTOCOL_ROCEV2;
+		return 0;
+	}
+
+	pf->rdma_mode |= IIDC_RDMA_PROTOCOL_ROCEV2;
+	ret = ice_plug_aux_dev(pf);
+	if (ret)
+		pf->rdma_mode &= ~IIDC_RDMA_PROTOCOL_ROCEV2;
+
+	return ret;
+}
+
+static int
+ice_devlink_enable_roce_validate(struct devlink *devlink, u32 id,
+				 union devlink_param_value val,
+				 struct netlink_ext_ack *extack)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+
+	if (!test_bit(ICE_FLAG_RDMA_ENA, pf->flags))
+		return -EOPNOTSUPP;
+
+	if (pf->rdma_mode & IIDC_RDMA_PROTOCOL_IWARP) {
+		NL_SET_ERR_MSG_MOD(extack, "iWARP is currently enabled. This device cannot enable iWARP and RoCEv2 simultaneously");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int
+ice_devlink_enable_iw_get(struct devlink *devlink, u32 id,
+			  struct devlink_param_gset_ctx *ctx)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+
+	ctx->val.vbool = pf->rdma_mode & IIDC_RDMA_PROTOCOL_IWARP;
+
+	return 0;
+}
+
+static int
+ice_devlink_enable_iw_set(struct devlink *devlink, u32 id,
+			  struct devlink_param_gset_ctx *ctx)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+	bool iw_ena = ctx->val.vbool;
+	int ret;
+
+	if (!iw_ena) {
+		ice_unplug_aux_dev(pf);
+		pf->rdma_mode &= ~IIDC_RDMA_PROTOCOL_IWARP;
+		return 0;
+	}
+
+	pf->rdma_mode |= IIDC_RDMA_PROTOCOL_IWARP;
+	ret = ice_plug_aux_dev(pf);
+	if (ret)
+		pf->rdma_mode &= ~IIDC_RDMA_PROTOCOL_IWARP;
+
+	return ret;
+}
+
+static int
+ice_devlink_enable_iw_validate(struct devlink *devlink, u32 id,
+			       union devlink_param_value val,
+			       struct netlink_ext_ack *extack)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+
+	if (!test_bit(ICE_FLAG_RDMA_ENA, pf->flags))
+		return -EOPNOTSUPP;
+
+	if (pf->rdma_mode & IIDC_RDMA_PROTOCOL_ROCEV2) {
+		NL_SET_ERR_MSG_MOD(extack, "RoCEv2 is currently enabled. This device cannot enable iWARP and RoCEv2 simultaneously");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static const struct devlink_param ice_devlink_params[] = {
+	DEVLINK_PARAM_GENERIC(ENABLE_ROCE, BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			      ice_devlink_enable_roce_get,
+			      ice_devlink_enable_roce_set,
+			      ice_devlink_enable_roce_validate),
+	DEVLINK_PARAM_GENERIC(ENABLE_IWARP, BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			      ice_devlink_enable_iw_get,
+			      ice_devlink_enable_iw_set,
+			      ice_devlink_enable_iw_validate),
+
+};
+
 static void ice_devlink_free(void *devlink_ptr)
 {
 	devlink_free((struct devlink *)devlink_ptr);
@@ -484,6 +598,36 @@ void ice_devlink_unregister(struct ice_pf *pf)
 	devlink_unregister(priv_to_devlink(pf));
 }
 
+int ice_devlink_register_params(struct ice_pf *pf)
+{
+	struct devlink *devlink = priv_to_devlink(pf);
+	union devlink_param_value value;
+	int err;
+
+	err = devlink_params_register(devlink, ice_devlink_params,
+				      ARRAY_SIZE(ice_devlink_params));
+	if (err)
+		return err;
+
+	value.vbool = false;
+	devlink_param_driverinit_value_set(devlink,
+					   DEVLINK_PARAM_GENERIC_ID_ENABLE_IWARP,
+					   value);
+
+	value.vbool = test_bit(ICE_FLAG_RDMA_ENA, pf->flags) ? true : false;
+	devlink_param_driverinit_value_set(devlink,
+					   DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
+					   value);
+
+	return 0;
+}
+
+void ice_devlink_unregister_params(struct ice_pf *pf)
+{
+	devlink_params_unregister(priv_to_devlink(pf), ice_devlink_params,
+				  ARRAY_SIZE(ice_devlink_params));
+}
+
 /**
  * ice_devlink_create_pf_port - Create a devlink port for this PF
  * @pf: the PF to create a devlink port for
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.h b/drivers/net/ethernet/intel/ice/ice_devlink.h
index b7f9551e4fc4..faea757fcf5d 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.h
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.h
@@ -4,10 +4,16 @@
 #ifndef _ICE_DEVLINK_H_
 #define _ICE_DEVLINK_H_
 
+enum ice_devlink_param_id {
+	ICE_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+};
+
 struct ice_pf *ice_allocate_pf(struct device *dev);
 
 void ice_devlink_register(struct ice_pf *pf);
 void ice_devlink_unregister(struct ice_pf *pf);
+int ice_devlink_register_params(struct ice_pf *pf);
+void ice_devlink_unregister_params(struct ice_pf *pf);
 int ice_devlink_create_pf_port(struct ice_pf *pf);
 void ice_devlink_destroy_pf_port(struct ice_pf *pf);
 int ice_devlink_create_vf_port(struct ice_vf *vf);
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index adcc9a251595..fc3580167e7b 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -288,7 +288,7 @@ int ice_plug_aux_dev(struct ice_pf *pf)
 	adev->id = pf->aux_idx;
 	adev->dev.release = ice_adev_release;
 	adev->dev.parent = &pf->pdev->dev;
-	adev->name = IIDC_RDMA_ROCE_NAME;
+	adev->name = pf->rdma_mode & IIDC_RDMA_PROTOCOL_ROCEV2 ? "roce" : "iwarp";
 
 	ret = auxiliary_device_init(adev);
 	if (ret) {
@@ -335,6 +335,6 @@ int ice_init_rdma(struct ice_pf *pf)
 		dev_err(dev, "failed to reserve vectors for RDMA\n");
 		return ret;
 	}
-
+	pf->rdma_mode |= IIDC_RDMA_PROTOCOL_ROCEV2;
 	return ice_plug_aux_dev(pf);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index f099797f35e3..f2a5f2f965d1 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4705,6 +4705,10 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	if (err)
 		goto err_netdev_reg;
 
+	err = ice_devlink_register_params(pf);
+	if (err)
+		goto err_netdev_reg;
+
 	/* ready to go, so clear down state bit */
 	clear_bit(ICE_DOWN, pf->state);
 	if (ice_is_aux_ena(pf)) {
@@ -4712,7 +4716,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		if (pf->aux_idx < 0) {
 			dev_err(dev, "Failed to allocate device ID for AUX driver\n");
 			err = -ENOMEM;
-			goto err_netdev_reg;
+			goto err_devlink_reg_param;
 		}
 
 		err = ice_init_rdma(pf);
@@ -4731,6 +4735,8 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 err_init_aux_unroll:
 	pf->adev = NULL;
 	ida_free(&ice_aux_ida, pf->aux_idx);
+err_devlink_reg_param:
+	ice_devlink_unregister_params(pf);
 err_netdev_reg:
 err_send_version_unroll:
 	ice_vsi_release_all(pf);
@@ -4845,6 +4851,7 @@ static void ice_remove(struct pci_dev *pdev)
 	ice_unplug_aux_dev(pf);
 	if (pf->aux_idx >= 0)
 		ida_free(&ice_aux_ida, pf->aux_idx);
+	ice_devlink_unregister_params(pf);
 	set_bit(ICE_DOWN, pf->state);
 
 	mutex_destroy(&(&pf->hw)->fdir_fltr_lock);
diff --git a/include/linux/net/intel/iidc.h b/include/linux/net/intel/iidc.h
index e32f6712aee0..1289593411d3 100644
--- a/include/linux/net/intel/iidc.h
+++ b/include/linux/net/intel/iidc.h
@@ -26,6 +26,11 @@ enum iidc_reset_type {
 	IIDC_GLOBR,
 };
 
+enum iidc_rdma_protocol {
+	IIDC_RDMA_PROTOCOL_IWARP = BIT(0),
+	IIDC_RDMA_PROTOCOL_ROCEV2 = BIT(1),
+};
+
 #define IIDC_MAX_USER_PRIORITY		8
 
 /* Struct to hold per RDMA Qset info */
@@ -70,8 +75,6 @@ int ice_rdma_request_reset(struct ice_pf *pf, enum iidc_reset_type reset_type);
 int ice_rdma_update_vsi_filter(struct ice_pf *pf, u16 vsi_id, bool enable);
 void ice_get_qos_params(struct ice_pf *pf, struct iidc_qos_params *qos);
 
-#define IIDC_RDMA_ROCE_NAME	"roce"
-
 /* Structure representing auxiliary driver tailored information about the core
  * PCI dev, each auxiliary driver using the IIDC interface will have an
  * instance of this struct dedicated to it.
-- 
2.31.1

