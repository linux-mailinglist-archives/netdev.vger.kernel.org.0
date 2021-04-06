Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68C5355D6E
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 23:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347309AbhDFVCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 17:02:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:35348 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245660AbhDFVCc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 17:02:32 -0400
IronPort-SDR: /9PRR3MulND4EcFbNgGgMWb/CJjiDmQ9XFffmSRamW5JKewDAqJZqzRyPbmCI/Nk0ayZhBA98j
 1AfVzoePgRhQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9946"; a="213532452"
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="213532452"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 14:02:24 -0700
IronPort-SDR: Vb6W5VuokMf17oj3b1PaaTeowErH/fmK6eXtqC5KV4UdKxYVZfXMpC6wBPEjqlnYmItoY4BUIQ
 1S/8jjHwUBPg==
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="441066746"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.209.60.133])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 14:02:23 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH v4 05/23] ice: Add devlink params support
Date:   Tue,  6 Apr 2021 16:01:07 -0500
Message-Id: <20210406210125.241-6-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210406210125.241-1-shiraz.saleem@intel.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new generic runtime devlink parameter 'rdma_protocol'
and use it in ice PCI driver. Configuration changes
result in unplugging the auxiliary RDMA device and re-plugging
it with updated values for irdma auxiiary driver to consume at
drv.probe()

Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 .../networking/devlink/devlink-params.rst          |  6 ++
 Documentation/networking/devlink/ice.rst           | 13 +++
 drivers/net/ethernet/intel/ice/ice_devlink.c       | 92 +++++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_devlink.h       |  5 ++
 drivers/net/ethernet/intel/ice/ice_main.c          |  2 +
 include/net/devlink.h                              |  4 +
 net/core/devlink.c                                 |  5 ++
 7 files changed, 125 insertions(+), 2 deletions(-)

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
index a432dc4..2e04c99 100644
--- a/Documentation/networking/devlink/ice.rst
+++ b/Documentation/networking/devlink/ice.rst
@@ -193,3 +193,16 @@ Users can request an immediate capture of a snapshot via the
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
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index cf685ee..de03eb8 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -449,6 +449,64 @@ static int ice_devlink_info_get(struct devlink *devlink,
 	.flash_update = ice_devlink_flash_update,
 };
 
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
+	DEVLINK_PARAM_GENERIC(RDMA_PROTOCOL, BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			      ice_devlink_rdma_prot_get,
+			      ice_devlink_rdma_prot_set,
+			      ice_devlink_rdma_prot_validate),
+};
+
 static void ice_devlink_free(void *devlink_ptr)
 {
 	devlink_free((struct devlink *)devlink_ptr);
@@ -491,15 +549,31 @@ int ice_devlink_register(struct ice_pf *pf)
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
@@ -510,10 +584,24 @@ int ice_devlink_register(struct ice_pf *pf)
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
index e07e744..e7239fa 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.h
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.h
@@ -4,10 +4,15 @@
 #ifndef _ICE_DEVLINK_H_
 #define _ICE_DEVLINK_H_
 
+enum ice_devlink_param_id {
+	ICE_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+};
+
 struct ice_pf *ice_allocate_pf(struct device *dev);
 
 int ice_devlink_register(struct ice_pf *pf);
 void ice_devlink_unregister(struct ice_pf *pf);
+void ice_devlink_params_publish(struct ice_pf *pf);
 int ice_devlink_create_port(struct ice_vsi *vsi);
 void ice_devlink_destroy_port(struct ice_vsi *vsi);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 3d750ba..3e3a9cf 100644
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

