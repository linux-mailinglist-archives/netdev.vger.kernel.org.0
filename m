Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A72A7346E16
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 01:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbhCXAD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 20:03:57 -0400
Received: from mga17.intel.com ([192.55.52.151]:37587 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234353AbhCXADZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 20:03:25 -0400
IronPort-SDR: tpYKHhLTf/TsHVdzYSvQVHEci9ii1VK2EMztqEU/5bDWTbXKm6IdtEuTYTWaMSzRLVHIDaM5TR
 MefZjIq25t3Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9932"; a="170556561"
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="170556561"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 17:03:24 -0700
IronPort-SDR: BLIjnca5IwdflBQiAsGTVW5OkHWsEGkHn2fOzX9u4ihm0MiTNzTtBWWJRLOpa7uR7v5E66aerD
 wq80FhMHUOSw==
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="381542203"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.209.103.207])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 17:03:23 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH v2 05/23] ice: Add devlink params support
Date:   Tue, 23 Mar 2021 18:59:49 -0500
Message-Id: <20210324000007.1450-6-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210324000007.1450-1-shiraz.saleem@intel.com>
References: <20210324000007.1450-1-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add two new runtime RDMA related devlink parameters to ice
driver. 'rdma_resource_limits_sel' is driver-specific
while 'rdma_protocol' is generic. Configuration changes
result in unplugging the auxiliary RDMA device and re-plugging
it with updated values for irdma auxiiary driver to consume at
drv.probe()

Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 .../networking/devlink/devlink-params.rst          |   6 +
 Documentation/networking/devlink/ice.rst           |  35 +++++
 drivers/net/ethernet/intel/ice/ice_devlink.c       | 146 ++++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_devlink.h       |   6 +
 drivers/net/ethernet/intel/ice/ice_main.c          |   2 +
 include/net/devlink.h                              |   4 +
 net/core/devlink.c                                 |   5 +
 7 files changed, 202 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index 54c9f10..0b454c3 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -114,3 +114,9 @@ own name.
        will NACK any attempt of other host to reset the device. This parameter
        is useful for setups where a device is shared by different hosts, such
        as multi-host setup.
+   * - ``rdma_protocol``
+     - string
+     - Selects the RDMA protocol selected for multi-protocol devices.
+        - ``iwarp`` iWARP
+	- ``roce`` RoCE
+	- ``ib`` Infiniband
diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
index a432dc4..28ac332 100644
--- a/Documentation/networking/devlink/ice.rst
+++ b/Documentation/networking/devlink/ice.rst
@@ -193,3 +193,38 @@ Users can request an immediate capture of a snapshot via the
     0000000000000210 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 
     $ devlink region delete pci/0000:01:00.0/device-caps snapshot 1
+
+Parameters
+==========
+
+The ``ice`` driver implements the following generic and driver-specific
+parameters.
+
+.. list-table:: Generic parameters implemented
+
+   * - Name
+     - Mode
+   * - ``rdma_protocol``
+     - runtime
+
+.. list-table:: Driver-specific parameters implemented
+   :widths: 5 5 5 85
+
+   * - Name
+     - Type
+     - Mode
+     - Description
+   * - ``rdma_resource_limits_sel``
+     - string
+     - runtime
+     - Selector to limit the RDMA resources configured for the device. The range
+       is between 0 and 7 with a default value equal to 3. Each selector supports
+       up to the value specified in the table.
+          - 0: 128 QPs
+          - 1: 1K QPs
+          - 2: 2K QPs
+          - 3: 4K QPs
+          - 4: 16K QPs
+          - 5: 64K QPs
+          - 6: 128K QPs
+          - 7: 256K QPs
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index cf685ee..3e53cc4 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -449,6 +449,113 @@ static int ice_devlink_info_get(struct devlink *devlink,
 	.flash_update = ice_devlink_flash_update,
 };
 
+static int
+ice_devlink_rdma_limits_sel_get(struct devlink *devlink, u32 id,
+				struct devlink_param_gset_ctx *ctx)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+	struct iidc_core_dev_info *cdev_info =
+		ice_find_cdev_info_by_id(pf, IIDC_RDMA_ID);
+
+	ctx->val.vu8 = cdev_info->rdma_limits_sel;
+
+	return 0;
+}
+
+static int
+ice_devlink_rdma_limits_sel_set(struct devlink *devlink, u32 id,
+				struct devlink_param_gset_ctx *ctx)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+	struct iidc_core_dev_info *cdev_info =
+		ice_find_cdev_info_by_id(pf, IIDC_RDMA_ID);
+
+	if (ctx->val.vu8 != cdev_info->rdma_limits_sel) {
+		ice_unplug_aux_devs(pf);
+		cdev_info->rdma_limits_sel = ctx->val.vu8;
+		ice_plug_aux_devs(pf);
+	}
+
+	return 0;
+}
+
+static int
+ice_devlink_rdma_limits_sel_validate(struct devlink *devlink, u32 id,
+				     union devlink_param_value val,
+				     struct netlink_ext_ack *extack)
+{
+	if (val.vu8 > IIDC_RDMA_LIMITS_SEL_7) {
+		NL_SET_ERR_MSG_MOD(extack, "RDMA resource limits selector range is (0-7)");
+		return -ERANGE;
+	}
+
+	return 0;
+}
+
+static int
+ice_devlink_rdma_prot_get(struct devlink *devlink, u32 id,
+			  struct devlink_param_gset_ctx *ctx)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+	struct iidc_core_dev_info *cdev_info =
+		ice_find_cdev_info_by_id(pf, IIDC_RDMA_ID);
+
+	if (cdev_info->rdma_protocol == IIDC_RDMA_PROTOCOL_IWARP)
+		strcpy(ctx->val.vstr, "iwarp");
+	else
+		strcpy(ctx->val.vstr, "roce");
+
+	return 0;
+}
+
+static int
+ice_devlink_rdma_prot_set(struct devlink *devlink, u32 id,
+			  struct devlink_param_gset_ctx *ctx)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+	struct iidc_core_dev_info *cdev_info =
+		ice_find_cdev_info_by_id(pf, IIDC_RDMA_ID);
+	enum iidc_rdma_protocol prot = !strcmp(ctx->val.vstr, "iwarp") ?
+					IIDC_RDMA_PROTOCOL_IWARP :
+					IIDC_RDMA_PROTOCOL_ROCEV2;
+
+	if (cdev_info->rdma_protocol != prot) {
+		ice_unplug_aux_devs(pf);
+		cdev_info->rdma_protocol = prot;
+		ice_plug_aux_devs(pf);
+	}
+
+	return 0;
+}
+
+static int
+ice_devlink_rdma_prot_validate(struct devlink *devlink, u32 id,
+			       union devlink_param_value val,
+			       struct netlink_ext_ack *extack)
+{
+	char *value = val.vstr;
+
+	if (!strcmp(value, "iwarp") || !strcmp(value, "roce"))
+		return 0;
+
+	NL_SET_ERR_MSG_MOD(extack, "\"iwarp\" and \"roce\" are the only supported values");
+
+	return -EINVAL;
+}
+
+static const struct devlink_param ice_devlink_params[] = {
+	DEVLINK_PARAM_DRIVER(ICE_DEVLINK_PARAM_ID_RDMA_LIMITS_SELECTOR,
+			     "rdma_resource_limits_sel", DEVLINK_PARAM_TYPE_U8,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     ice_devlink_rdma_limits_sel_get,
+			     ice_devlink_rdma_limits_sel_set,
+			     ice_devlink_rdma_limits_sel_validate),
+	DEVLINK_PARAM_GENERIC(RDMA_PROTOCOL, BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			      ice_devlink_rdma_prot_get,
+			      ice_devlink_rdma_prot_set,
+			      ice_devlink_rdma_prot_validate),
+};
+
 static void ice_devlink_free(void *devlink_ptr)
 {
 	devlink_free((struct devlink *)devlink_ptr);
@@ -491,15 +598,36 @@ int ice_devlink_register(struct ice_pf *pf)
 {
 	struct devlink *devlink = priv_to_devlink(pf);
 	struct device *dev = ice_pf_to_dev(pf);
+	union devlink_param_value value;
 	int err;
 
 	err = devlink_register(devlink, dev);
+	if (err)
+		goto err;
+
+	err = devlink_params_register(devlink, ice_devlink_params,
+				      ARRAY_SIZE(ice_devlink_params));
 	if (err) {
-		dev_err(dev, "devlink registration failed: %d\n", err);
-		return err;
+		devlink_unregister(devlink);
+		goto err;
 	}
 
+	value.vu8 = IIDC_RDMA_LIMITS_SEL_3;
+	devlink_param_driverinit_value_set(devlink,
+					   ICE_DEVLINK_PARAM_ID_RDMA_LIMITS_SELECTOR,
+					   value);
+
+	strcpy(value.vstr, "iwarp");
+	devlink_param_driverinit_value_set(devlink,
+					   DEVLINK_PARAM_GENERIC_ID_RDMA_PROTOCOL,
+					   value);
+
 	return 0;
+
+err:
+	dev_err(dev, "devlink registration failed: %d\n", err);
+
+	return err;
 }
 
 /**
@@ -510,10 +638,24 @@ int ice_devlink_register(struct ice_pf *pf)
  */
 void ice_devlink_unregister(struct ice_pf *pf)
 {
+	devlink_params_unregister(priv_to_devlink(pf), ice_devlink_params,
+				  ARRAY_SIZE(ice_devlink_params));
 	devlink_unregister(priv_to_devlink(pf));
 }
 
 /**
+ * ice_devlink_params_publish - Publish devlink param
+ * @pf: the PF structure to cleanup
+ *
+ * Publish previously registered devlink parameters after driver
+ * is initialized
+ */
+void ice_devlink_params_publish(struct ice_pf *pf)
+{
+	devlink_params_publish(priv_to_devlink(pf));
+}
+
+/**
  * ice_devlink_create_port - Create a devlink port for this VSI
  * @vsi: the VSI to create a port for
  *
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.h b/drivers/net/ethernet/intel/ice/ice_devlink.h
index e07e744..865f797 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.h
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.h
@@ -4,10 +4,16 @@
 #ifndef _ICE_DEVLINK_H_
 #define _ICE_DEVLINK_H_
 
+enum ice_devlink_param_id {
+	ICE_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	ICE_DEVLINK_PARAM_ID_RDMA_LIMITS_SELECTOR,
+};
+
 struct ice_pf *ice_allocate_pf(struct device *dev);
 
 int ice_devlink_register(struct ice_pf *pf);
 void ice_devlink_unregister(struct ice_pf *pf);
+void ice_devlink_params_publish(struct ice_pf *pf);
 int ice_devlink_create_port(struct ice_vsi *vsi);
 void ice_devlink_destroy_port(struct ice_vsi *vsi);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 4b03157..789aa39 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4346,6 +4346,8 @@ static void ice_print_wake_reason(struct ice_pf *pf)
 		dev_warn(dev, "RDMA is not supported on this device\n");
 	}
 
+	ice_devlink_params_publish(pf);
+
 	return 0;
 
 err_init_aux_unroll:
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 853420d..09e4d76 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -498,6 +498,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_RESET_DEV_ON_DRV_PROBE,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_REMOTE_DEV_RESET,
+	DEVLINK_PARAM_GENERIC_ID_RDMA_PROTOCOL,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -538,6 +539,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_ENABLE_REMOTE_DEV_RESET_NAME "enable_remote_dev_reset"
 #define DEVLINK_PARAM_GENERIC_ENABLE_REMOTE_DEV_RESET_TYPE DEVLINK_PARAM_TYPE_BOOL
 
+#define DEVLINK_PARAM_GENERIC_RDMA_PROTOCOL_NAME "rdma_protocol"
+#define DEVLINK_PARAM_GENERIC_RDMA_PROTOCOL_TYPE DEVLINK_PARAM_TYPE_STRING
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 737b61c..1bb3865 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3766,6 +3766,11 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 		.name = DEVLINK_PARAM_GENERIC_ENABLE_REMOTE_DEV_RESET_NAME,
 		.type = DEVLINK_PARAM_GENERIC_ENABLE_REMOTE_DEV_RESET_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_RDMA_PROTOCOL,
+		.name = DEVLINK_PARAM_GENERIC_RDMA_PROTOCOL_NAME,
+		.type = DEVLINK_PARAM_GENERIC_RDMA_PROTOCOL_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
1.8.3.1

