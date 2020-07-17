Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E41022434A
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 20:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgGQSnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 14:43:55 -0400
Received: from mga17.intel.com ([192.55.52.151]:34695 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728248AbgGQSny (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 14:43:54 -0400
IronPort-SDR: W46Bd0s6576yBXDvZq6fWHitRnhELdDyoht7IsFL4FKULSGPImWt+DMXgTt9RWqe00OGNik+y3
 ypkpfEzqSWzA==
X-IronPort-AV: E=McAfee;i="6000,8403,9685"; a="129736663"
X-IronPort-AV: E=Sophos;i="5.75,364,1589266800"; 
   d="scan'208";a="129736663"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2020 11:35:45 -0700
IronPort-SDR: la6ZeXvm/SyR+cZ/wmLsbSCNxfg8ufp+S/5cySYn0yi2xspzxIINebJxHljXKnLFP2sq90Y83I
 OzoDFPswKWaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,364,1589266800"; 
   d="scan'208";a="486542516"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga006.fm.intel.com with ESMTP; 17 Jul 2020 11:35:45 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kubakici@wp.pl>, Jiri Pirko <jiri@resnulli.us>,
        Tom Herbert <tom@herbertland.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH net-next v2 5/6] ice: implement device flash update via devlink
Date:   Fri, 17 Jul 2020 11:35:40 -0700
Message-Id: <20200717183541.797878-6-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.27.0.353.gb9a2d1a0207f
In-Reply-To: <20200717183541.797878-1-jacob.e.keller@intel.com>
References: <20200717183541.797878-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the newly added pldmfw library to implement device flash update for
the Intel ice networking device driver. This support uses the devlink
flash update interface.

The main parts of the flash include the Option ROM, the netlist module,
and the main NVM data. The PLDM firmware file contains modules for each
of these components.

Using the pldmfw library, the provided firmware file will be scanned for
the three major components, "fw.undi" for the Option ROM, "fw.mgmt" for
the main NVM module containing the primary device firmware, and
"fw.netlist" containing the netlist module.

The flash is separated into two banks, the active bank containing the
running firmware, and the inactive bank which we use for update. Each
module is updated in a staged process. First, the inactive bank is
erased, preparing the device for update. Second, the contents of the
component are copied to the inactive portion of the flash. After all
components are updated, the driver signals the device to switch the
active bank during the next EMP reset (which would usually occur during
the next reboot).

Although the firmware AdminQ interface does report an immediate status
for each command, the NVM erase and NVM write commands receive status
asynchronously. The driver must not continue writing until previous
erase and write commands have finished. The real status of the NVM
commands is returned over the receive AdminQ. Implement a simple
interface that uses a wait queue so that the main update thread can
sleep until the completion status is reported by firmware. For erasing
the inactive banks, this can take quite a while in practice.

To help visualize the process to the devlink application and other
applications based on the devlink netlink interface, status is reported
via the devlink_flash_update_status_notify. While we do report status
after each 4k block when writing, there is no real status we can report
during erasing. We simply must wait for the complete module erasure to
finish.

With this implementation, basic flash update for the ice hardware is
supported.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/intel/Kconfig            |   1 +
 drivers/net/ethernet/intel/ice/Makefile       |   1 +
 drivers/net/ethernet/intel/ice/ice.h          |   9 +
 drivers/net/ethernet/intel/ice/ice_common.c   |   2 +-
 drivers/net/ethernet/intel/ice/ice_common.h   |   2 +
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  54 ++
 .../net/ethernet/intel/ice/ice_fw_update.c    | 780 ++++++++++++++++++
 .../net/ethernet/intel/ice/ice_fw_update.h    |  12 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 154 ++++
 9 files changed, 1014 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_fw_update.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_fw_update.h

diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index c99fe92d4b3c..6aee67276cf5 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -295,6 +295,7 @@ config ICE
 	default n
 	depends on PCI_MSI
 	select NET_DEVLINK
+	select PLDMFW
 	help
 	  This driver supports Intel(R) Ethernet Connection E800 Series of
 	  devices.  For more information on how to identify your adapter, go
diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 229740c3c1e1..3a34e717adf3 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -23,6 +23,7 @@ ice-y := ice_main.o	\
 	 ice_flex_pipe.o \
 	 ice_flow.o	\
 	 ice_devlink.o	\
+	 ice_fw_update.o \
 	 ice_ethtool.o
 ice-$(CONFIG_PCI_IOV) += ice_virtchnl_pf.o ice_sriov.o ice_dcf.o ice_virtchnl_fdir.o
 ice-$(CONFIG_DCB) += ice_dcb.o ice_dcb_nl.o ice_dcb_lib.o
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 9b4c70310c3a..152b1f71045c 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -19,6 +19,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/pci.h>
 #include <linux/workqueue.h>
+#include <linux/wait.h>
 #include <linux/aer.h>
 #include <linux/interrupt.h>
 #include <linux/ethtool.h>
@@ -415,6 +416,12 @@ struct ice_pf {
 	struct mutex sw_mutex;		/* lock for protecting VSI alloc flow */
 	struct mutex tc_mutex;		/* lock to protect TC changes */
 	u32 msg_enable;
+
+	/* spinlock to protect the AdminQ wait list */
+	spinlock_t aq_wait_lock;
+	struct hlist_head aq_wait_list;
+	wait_queue_head_t aq_wait_queue;
+
 	u32 hw_csum_rx_error;
 	u16 oicr_idx;		/* Other interrupt cause MSIX vector index */
 	u16 num_avail_sw_msix;	/* remaining MSIX SW vectors left unclaimed */
@@ -598,6 +605,8 @@ void ice_fdir_release_flows(struct ice_hw *hw);
 void ice_fdir_replay_flows(struct ice_hw *hw);
 void ice_fdir_replay_fltrs(struct ice_pf *pf);
 int ice_fdir_create_dflt_rules(struct ice_pf *pf);
+int ice_aq_wait_for_event(struct ice_pf *pf, u16 opcode, unsigned long timeout,
+			  struct ice_rq_event_info *event);
 int ice_open(struct net_device *netdev);
 int ice_stop(struct net_device *netdev);
 void ice_service_task_schedule(struct ice_pf *pf);
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 2e9a43bae67f..25b654d2d11e 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -2221,7 +2221,7 @@ ice_aq_list_caps(struct ice_hw *hw, void *buf, u16 buf_size, u32 *cap_count,
  * Read the device capabilities and extract them into the dev_caps structure
  * for later use.
  */
-static enum ice_status
+enum ice_status
 ice_discover_dev_caps(struct ice_hw *hw, struct ice_hw_dev_caps *dev_caps)
 {
 	enum ice_status status;
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 485e2ac792b5..3ebb973878c7 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -88,6 +88,8 @@ ice_aq_get_phy_caps(struct ice_port_info *pi, bool qual_mods, u8 report_mode,
 enum ice_status
 ice_aq_list_caps(struct ice_hw *hw, void *buf, u16 buf_size, u32 *cap_count,
 		 enum ice_adminq_opc opc, struct ice_sq_cd *cd);
+enum ice_status
+ice_discover_dev_caps(struct ice_hw *hw, struct ice_hw_dev_caps *dev_caps);
 void
 ice_update_phy_type(u64 *phy_type_low, u64 *phy_type_high,
 		    u16 link_speeds_bitmap);
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 43da2dcb0cbc..dbbd8b6f9d1a 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -4,6 +4,7 @@
 #include "ice.h"
 #include "ice_lib.h"
 #include "ice_devlink.h"
+#include "ice_fw_update.h"
 
 static int ice_info_get_dsn(struct ice_pf *pf, char *buf, size_t len)
 {
@@ -229,8 +230,61 @@ static int ice_devlink_info_get(struct devlink *devlink,
 	return 0;
 }
 
+/**
+ * ice_devlink_flash_update - Update firmware stored in flash on the device
+ * @devlink: pointer to devlink associated with device to update
+ * @path: the path of the firmware file to use via request_firmware
+ * @component: name of the component to update, or NULL
+ * @extack: netlink extended ACK structure
+ *
+ * Perform a device flash update. The bulk of the update logic is contained
+ * within the ice_flash_pldm_image function.
+ *
+ * Returns: zero on success, or an error code on failure.
+ */
+static int
+ice_devlink_flash_update(struct devlink *devlink, const char *path,
+			 const char *component, struct netlink_ext_ack *extack)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+	struct device *dev = &pf->pdev->dev;
+	struct ice_hw *hw = &pf->hw;
+	const struct firmware *fw;
+	int err;
+
+	/* individual component update is not yet supported */
+	if (component)
+		return -EOPNOTSUPP;
+
+	if (!hw->dev_caps.common_cap.nvm_unified_update) {
+		NL_SET_ERR_MSG_MOD(extack, "Current firmware does not support unified update");
+		return -EOPNOTSUPP;
+	}
+
+	err = ice_check_for_pending_update(pf, component, extack);
+	if (err)
+		return err;
+
+	err = request_firmware(&fw, path, dev);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to read file from disk");
+		return err;
+	}
+
+	devlink_flash_update_begin_notify(devlink);
+	devlink_flash_update_status_notify(devlink, "Preparing to flash",
+					   component, 0, 0);
+	err = ice_flash_pldm_image(pf, fw, extack);
+	devlink_flash_update_end_notify(devlink);
+
+	release_firmware(fw);
+
+	return err;
+}
+
 static const struct devlink_ops ice_devlink_ops = {
 	.info_get = ice_devlink_info_get,
+	.flash_update = ice_devlink_flash_update,
 };
 
 static void ice_devlink_free(void *devlink_ptr)
diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.c b/drivers/net/ethernet/intel/ice/ice_fw_update.c
new file mode 100644
index 000000000000..51b575ba197d
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.c
@@ -0,0 +1,780 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2018-2019, Intel Corporation. */
+
+#include <asm/unaligned.h>
+#include <linux/uuid.h>
+#include <linux/crc32.h>
+#include <linux/pldmfw.h>
+#include "ice.h"
+#include "ice_fw_update.h"
+
+struct ice_fwu_priv {
+	struct pldmfw context;
+
+	struct ice_pf *pf;
+	struct netlink_ext_ack *extack;
+
+	/* Track which NVM banks to activate at the end of the update */
+	u8 activate_flags;
+};
+
+/**
+ * ice_send_package_data - Send record package data to firmware
+ * @context: PLDM fw update structure
+ * @data: pointer to the package data
+ * @length: length of the package data
+ *
+ * Send a copy of the package data associated with the PLDM record matching
+ * this device to the firmware.
+ *
+ * Note that this function sends an AdminQ command that will fail unless the
+ * NVM resource has been acquired.
+ *
+ * Returns: zero on success, or a negative error code on failure.
+ */
+static int
+ice_send_package_data(struct pldmfw *context, const u8 *data, u16 length)
+{
+	struct ice_fwu_priv *priv = container_of(context, struct ice_fwu_priv, context);
+	struct netlink_ext_ack *extack = priv->extack;
+	struct device *dev = context->dev;
+	struct ice_pf *pf = priv->pf;
+	struct ice_hw *hw = &pf->hw;
+	enum ice_status status;
+	u8 *package_data;
+
+	package_data = kmemdup(data, length, GFP_KERNEL);
+	if (!package_data)
+		return -ENOMEM;
+
+	status = ice_nvm_set_pkg_data(hw, false, package_data, length, NULL);
+
+	kfree(package_data);
+
+	if (status) {
+		dev_err(dev, "Failed to send record package data to firmware, err %s aq_err %s\n",
+			ice_stat_str(status),
+			ice_aq_str(hw->adminq.sq_last_status));
+		NL_SET_ERR_MSG_MOD(extack, "Failed to record package data to firmware");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_check_component_response - Report firmware response to a component
+ * @pf: device private data structure
+ * @id: component id being checked
+ * @response: indicates whether this component can be updated
+ * @code: code indicating reason for response
+ * @extack: netlink extended ACK structure
+ *
+ * Check whether firmware indicates if this component can be updated. Report
+ * a suitable error message over the netlink extended ACK if the component
+ * cannot be updated.
+ *
+ * Returns: zero if the component can be updated, or -ECANCELED of the
+ * firmware indicates the component cannot be updated.
+ */
+static int
+ice_check_component_response(struct ice_pf *pf, u16 id, u8 response, u8 code,
+			     struct netlink_ext_ack *extack)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	const char *component;
+
+	switch (id) {
+	case NVM_COMP_ID_OROM:
+		component = "fw.undi";
+		break;
+	case NVM_COMP_ID_NVM:
+		component = "fw.mgmt";
+		break;
+	case NVM_COMP_ID_NETLIST:
+		component = "fw.netlist";
+		break;
+	default:
+		WARN(1, "Unexpected unknown component identifier 0x%02x", id);
+		return -EINVAL;
+	}
+
+	dev_dbg(dev, "%s: firmware response 0x%x, code 0x%x\n",
+		component, response, code);
+
+	switch (response) {
+	case ICE_AQ_NVM_PASS_COMP_CAN_BE_UPDATED:
+		/* firmware indicated this update is good to proceed */
+		return 0;
+	case ICE_AQ_NVM_PASS_COMP_CAN_MAY_BE_UPDATEABLE:
+		dev_warn(dev, "firmware recommends not updating %s, as it may result in a downgrade. continuing anyways\n", component);
+		return 0;
+	case ICE_AQ_NVM_PASS_COMP_CAN_NOT_BE_UPDATED:
+		dev_info(dev, "firmware has rejected updating %s\n", component);
+		break;
+	}
+
+	switch (code) {
+	case ICE_AQ_NVM_PASS_COMP_STAMP_IDENTICAL_CODE:
+		dev_err(dev, "Component comparison stamp for %s is identical to the running image\n",
+			component);
+		NL_SET_ERR_MSG_MOD(extack, "Component comparison stamp is identical to running image");
+		break;
+	case ICE_AQ_NVM_PASS_COMP_STAMP_LOWER:
+		dev_err(dev, "Component comparison stamp for %s is lower than the running image\n",
+			component);
+		NL_SET_ERR_MSG_MOD(extack, "Component comparison stamp is lower than running image");
+		break;
+	case ICE_AQ_NVM_PASS_COMP_INVALID_STAMP_CODE:
+		dev_err(dev, "Component comparison stamp for %s is invalid\n",
+			component);
+		NL_SET_ERR_MSG_MOD(extack, "Component comparison stamp is invalid");
+		break;
+	case ICE_AQ_NVM_PASS_COMP_CONFLICT_CODE:
+		dev_err(dev, "%s conflicts with a previous component table\n",
+			component);
+		NL_SET_ERR_MSG_MOD(extack, "Component table conflict occurred");
+		break;
+	case ICE_AQ_NVM_PASS_COMP_PRE_REQ_NOT_MET_CODE:
+		dev_err(dev, "Pre-requisites for component %s have not been met\n",
+			component);
+		NL_SET_ERR_MSG_MOD(extack, "Component pre-requisites not met");
+		break;
+	case ICE_AQ_NVM_PASS_COMP_NOT_SUPPORTED_CODE:
+		dev_err(dev, "%s is not a supported component\n",
+			component);
+		NL_SET_ERR_MSG_MOD(extack, "Component not supported");
+		break;
+	case ICE_AQ_NVM_PASS_COMP_CANNOT_DOWNGRADE_CODE:
+		dev_err(dev, "Security restrictions prevent %s from being downgraded\n",
+			component);
+		NL_SET_ERR_MSG_MOD(extack, "Component cannot be downgraded");
+		break;
+	case ICE_AQ_NVM_PASS_COMP_INCOMPLETE_IMAGE_CODE:
+		dev_err(dev, "Received an incomplete component image for %s\n",
+			component);
+		NL_SET_ERR_MSG_MOD(extack, "Incomplete component image");
+		break;
+	case ICE_AQ_NVM_PASS_COMP_VER_STR_IDENTICAL_CODE:
+		dev_err(dev, "Component version for %s is identical to the running image\n",
+			component);
+		NL_SET_ERR_MSG_MOD(extack, "Component version is identical to running image");
+		break;
+	case ICE_AQ_NVM_PASS_COMP_VER_STR_LOWER_CODE:
+		dev_err(dev, "Component version for %s is lower than the running image\n",
+			component);
+		NL_SET_ERR_MSG_MOD(extack, "Component version is lower than the running image");
+		break;
+	default:
+		dev_err(dev, "Unexpected response code 0x02%x for %s\n",
+			code, component);
+		NL_SET_ERR_MSG_MOD(extack, "Received unexpected response code from firmware");
+		break;
+	}
+
+	return -ECANCELED;
+}
+
+/**
+ * ice_send_component_table - Send PLDM component table to firmware
+ * @context: PLDM fw update structure
+ * @component: the component to process
+ * @transfer_flag: relative transfer order of this component
+ *
+ * Read relevant data from the component and forward it to the device
+ * firmware. Check the response to determine if the firmware indicates that
+ * the update can proceed.
+ *
+ * This function sends AdminQ commands related to the NVM, and assumes that
+ * the NVM resource has been acquired.
+ *
+ * Returns: zero on success, or a negative error code on failure.
+ */
+static int
+ice_send_component_table(struct pldmfw *context, struct pldmfw_component *component,
+			 u8 transfer_flag)
+{
+	struct ice_fwu_priv *priv = container_of(context, struct ice_fwu_priv, context);
+	struct netlink_ext_ack *extack = priv->extack;
+	struct ice_aqc_nvm_comp_tbl *comp_tbl;
+	u8 comp_response, comp_response_code;
+	struct device *dev = context->dev;
+	struct ice_pf *pf = priv->pf;
+	struct ice_hw *hw = &pf->hw;
+	enum ice_status status;
+	size_t length;
+
+	switch (component->identifier) {
+	case NVM_COMP_ID_OROM:
+	case NVM_COMP_ID_NVM:
+	case NVM_COMP_ID_NETLIST:
+		break;
+	default:
+		dev_err(dev, "Unable to update due to a firmware component with unknown ID %u\n",
+			component->identifier);
+		NL_SET_ERR_MSG_MOD(extack, "Unable to update due to unknown firmware component");
+		return -EOPNOTSUPP;
+	}
+
+	length = struct_size(comp_tbl, cvs, component->version_len);
+	comp_tbl = kzalloc(length, GFP_KERNEL);
+	if (!comp_tbl)
+		return -ENOMEM;
+
+	comp_tbl->comp_class = cpu_to_le16(component->classification);
+	comp_tbl->comp_id = cpu_to_le16(component->identifier);
+	comp_tbl->comp_class_idx = FWU_COMP_CLASS_IDX_NOT_USE;
+	comp_tbl->comp_cmp_stamp = cpu_to_le32(component->comparison_stamp);
+	comp_tbl->cvs_type = component->version_type;
+	comp_tbl->cvs_len = component->version_len;
+	memcpy(comp_tbl->cvs, component->version_string, component->version_len);
+
+	status = ice_nvm_pass_component_tbl(hw, (u8 *)comp_tbl, length,
+					    transfer_flag, &comp_response,
+					    &comp_response_code, NULL);
+
+	kfree(comp_tbl);
+
+	if (status) {
+		dev_err(dev, "Failed to transfer component table to firmware, err %s aq_err %s\n",
+			ice_stat_str(status),
+			ice_aq_str(hw->adminq.sq_last_status));
+		NL_SET_ERR_MSG_MOD(extack, "Failed to transfer component table to firmware");
+		return -EIO;
+	}
+
+	return ice_check_component_response(pf, component->identifier, comp_response,
+					    comp_response_code, extack);
+}
+
+/**
+ * ice_write_one_nvm_block - Write an NVM block and await completion response
+ * @pf: the PF data structure
+ * @module: the module to write to
+ * @offset: offset in bytes
+ * @block_size: size of the block to write, up to 4k
+ * @block: pointer to block of data to write
+ * @last_cmd: whether this is the last command
+ * @extack: netlink extended ACK structure
+ *
+ * Write a block of data to a flash module, and await for the completion
+ * response message from firmware.
+ *
+ * Note this function assumes the caller has acquired the NVM resource.
+ *
+ * Returns: zero on success, or a negative error code on failure.
+ */
+static int
+ice_write_one_nvm_block(struct ice_pf *pf, u16 module, u32 offset,
+			u16 block_size, u8 *block, bool last_cmd,
+			struct netlink_ext_ack *extack)
+{
+	u16 completion_module, completion_retval;
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_rq_event_info event;
+	struct ice_hw *hw = &pf->hw;
+	enum ice_status status;
+	u32 completion_offset;
+	int err;
+
+	memset(&event, 0, sizeof(event));
+
+	status = ice_aq_update_nvm(hw, module, offset, block_size, block,
+				   last_cmd, 0, NULL);
+	if (status) {
+		dev_err(dev, "Failed to program flash module 0x%02x at offset %u, err %s aq_err %s\n",
+			module, offset, ice_stat_str(status),
+			ice_aq_str(hw->adminq.sq_last_status));
+		NL_SET_ERR_MSG_MOD(extack, "Failed to program flash module");
+		return -EIO;
+	}
+
+	err = ice_aq_wait_for_event(pf, ice_aqc_opc_nvm_write, HZ, &event);
+	if (err) {
+		dev_err(dev, "Timed out waiting for firmware write completion for module 0x%02x, err %d\n",
+			module, err);
+		NL_SET_ERR_MSG_MOD(extack, "Timed out waiting for firmware");
+		return -EIO;
+	}
+
+	completion_module = le16_to_cpu(event.desc.params.nvm.module_typeid);
+	completion_retval = le16_to_cpu(event.desc.retval);
+
+	completion_offset = le16_to_cpu(event.desc.params.nvm.offset_low);
+	completion_offset |= event.desc.params.nvm.offset_high << 16;
+
+	if (completion_module != module) {
+		dev_err(dev, "Unexpected module_typeid in write completion: got 0x%x, expected 0x%x\n",
+			completion_module, module);
+		NL_SET_ERR_MSG_MOD(extack, "Unexpected firmware response");
+		return -EIO;
+	}
+
+	if (completion_offset != offset) {
+		dev_err(dev, "Unexpected offset in write completion: got %u, expected %u\n",
+			completion_offset, offset);
+		NL_SET_ERR_MSG_MOD(extack, "Unexpected firmware response");
+		return -EIO;
+	}
+
+	if (completion_retval) {
+		dev_err(dev, "Firmware failed to program flash module 0x%02x at offset %u, completion err %s\n",
+			module, offset,
+			ice_aq_str((enum ice_aq_err)completion_retval));
+		NL_SET_ERR_MSG_MOD(extack, "Firmware failed to program flash module");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_write_nvm_module - Write data to an NVM module
+ * @pf: the PF driver structure
+ * @module: the module id to program
+ * @component: the name of the component being updated
+ * @image: buffer of image data to write to the NVM
+ * @length: length of the buffer
+ * @extack: netlink extended ACK structure
+ *
+ * Loop over the data for a given NVM module and program it in 4 Kb
+ * blocks. Notify devlink core of progress after each block is programmed.
+ * Loops over a block of data and programs the NVM in 4k block chunks.
+ *
+ * Note this function assumes the caller has acquired the NVM resource.
+ *
+ * Returns: zero on success, or a negative error code on failure.
+ */
+static int
+ice_write_nvm_module(struct ice_pf *pf, u16 module, const char *component,
+		     const u8 *image, u32 length,
+		     struct netlink_ext_ack *extack)
+{
+	struct devlink *devlink;
+	u32 offset = 0;
+	bool last_cmd;
+	u8 *block;
+	int err;
+
+	devlink = priv_to_devlink(pf);
+
+	devlink_flash_update_status_notify(devlink, "Flashing",
+					   component, 0, length);
+
+	block = kzalloc(ICE_AQ_MAX_BUF_LEN, GFP_KERNEL);
+	if (!block)
+		return -ENOMEM;
+
+	do {
+		u32 block_size;
+
+		block_size = min_t(u32, ICE_AQ_MAX_BUF_LEN, length - offset);
+		last_cmd = !(offset + block_size < length);
+
+		/* ice_aq_update_nvm may copy the firmware response into the
+		 * buffer, so we must make a copy since the source data is
+		 * constant.
+		 */
+		memcpy(block, image + offset, block_size);
+
+		err = ice_write_one_nvm_block(pf, module, offset, block_size,
+					      block, last_cmd, extack);
+		if (err)
+			break;
+
+		offset += block_size;
+
+		devlink_flash_update_status_notify(devlink, "Flashing",
+						   component, offset, length);
+	} while (!last_cmd);
+
+	if (err)
+		devlink_flash_update_status_notify(devlink, "Flashing failed",
+						   component, length, length);
+	else
+		devlink_flash_update_status_notify(devlink, "Flashing done",
+						   component, length, length);
+
+	kfree(block);
+	return err;
+}
+
+/**
+ * ice_erase_nvm_module - Erase an NVM module and await firmware completion
+ * @pf: the PF data structure
+ * @module: the module to erase
+ * @component: name of the component being updated
+ * @extack: netlink extended ACK structure
+ *
+ * Erase the inactive NVM bank associated with this module, and await for
+ * a completion response message from firmware.
+ *
+ * Note this function assumes the caller has acquired the NVM resource.
+ *
+ * Returns: zero on success, or a negative error code on failure.
+ */
+static int
+ice_erase_nvm_module(struct ice_pf *pf, u16 module, const char *component,
+		     struct netlink_ext_ack *extack)
+{
+	u16 completion_module, completion_retval;
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_rq_event_info event;
+	struct ice_hw *hw = &pf->hw;
+	struct devlink *devlink;
+	enum ice_status status;
+	int err;
+
+	memset(&event, 0, sizeof(event));
+
+	devlink = priv_to_devlink(pf);
+
+	devlink_flash_update_status_notify(devlink, "Erasing", component, 0, 0);
+
+	status = ice_aq_erase_nvm(hw, module, NULL);
+	if (status) {
+		dev_err(dev, "Failed to erase %s (module 0x%02x), err %s aq_err %s\n",
+			component, module, ice_stat_str(status),
+			ice_aq_str(hw->adminq.sq_last_status));
+		NL_SET_ERR_MSG_MOD(extack, "Failed to erase flash module");
+		err = -EIO;
+		goto out_notify_devlink;
+	}
+
+	/* Yes, this really can take minutes to complete */
+	err = ice_aq_wait_for_event(pf, ice_aqc_opc_nvm_erase, 300 * HZ, &event);
+	if (err) {
+		dev_err(dev, "Timed out waiting for firmware to respond with erase completion for %s (module 0x%02x), err %d\n",
+			component, module, err);
+		NL_SET_ERR_MSG_MOD(extack, "Timed out waiting for firmware");
+		goto out_notify_devlink;
+	}
+
+	completion_module = le16_to_cpu(event.desc.params.nvm.module_typeid);
+	completion_retval = le16_to_cpu(event.desc.retval);
+
+	if (completion_module != module) {
+		dev_err(dev, "Unexpected module_typeid in erase completion for %s: got 0x%x, expected 0x%x\n",
+			component, completion_module, module);
+		NL_SET_ERR_MSG_MOD(extack, "Unexpected firmware response");
+		err = -EIO;
+		goto out_notify_devlink;
+	}
+
+	if (completion_retval) {
+		dev_err(dev, "Firmware failed to erase %s (module 0x02%x), aq_err %s\n",
+			component, module,
+			ice_aq_str((enum ice_aq_err)completion_retval));
+		NL_SET_ERR_MSG_MOD(extack, "Firmware failed to erase flash");
+		err = -EIO;
+		goto out_notify_devlink;
+	}
+
+out_notify_devlink:
+	if (err)
+		devlink_flash_update_status_notify(devlink, "Erasing failed",
+						   component, 0, 0);
+	else
+		devlink_flash_update_status_notify(devlink, "Erasing done",
+						   component, 0, 0);
+
+	return err;
+}
+
+/**
+ * ice_switch_flash_banks - Tell firmware to switch NVM banks
+ * @pf: Pointer to the PF data structure
+ * @activate_flags: flags used for the activation command
+ * @extack: netlink extended ACK structure
+ *
+ * Notify firmware to activate the newly written flash banks, and wait for the
+ * firmware response.
+ *
+ * Returns: zero on success or an error code on failure.
+ */
+static int ice_switch_flash_banks(struct ice_pf *pf, u8 activate_flags,
+				  struct netlink_ext_ack *extack)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_rq_event_info event;
+	struct ice_hw *hw = &pf->hw;
+	enum ice_status status;
+	u16 completion_retval;
+	int err;
+
+	memset(&event, 0, sizeof(event));
+
+	status = ice_nvm_write_activate(hw, activate_flags);
+	if (status) {
+		dev_err(dev, "Failed to switch active flash banks, err %s aq_err %s\n",
+			ice_stat_str(status),
+			ice_aq_str(hw->adminq.sq_last_status));
+		NL_SET_ERR_MSG_MOD(extack, "Failed to switch active flash banks");
+		return -EIO;
+	}
+
+	err = ice_aq_wait_for_event(pf, ice_aqc_opc_nvm_write_activate, HZ,
+				    &event);
+	if (err) {
+		dev_err(dev, "Timed out waiting for firmware to switch active flash banks, err %d\n",
+			err);
+		NL_SET_ERR_MSG_MOD(extack, "Timed out waiting for firmware");
+		return err;
+	}
+
+	completion_retval = le16_to_cpu(event.desc.retval);
+	if (completion_retval) {
+		dev_err(dev, "Firmware failed to switch active flash banks aq_err %s\n",
+			ice_aq_str((enum ice_aq_err)completion_retval));
+		NL_SET_ERR_MSG_MOD(extack, "Firmware failed to switch active flash banks");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_flash_component - Flash a component of the NVM
+ * @context: PLDM fw update structure
+ * @component: the component table to program
+ *
+ * Program the flash contents for a given component. First, determine the
+ * module id. Then, erase the secondary bank for this module. Finally, write
+ * the contents of the component to the NVM.
+ *
+ * Note this function assumes the caller has acquired the NVM resource.
+ *
+ * Returns: zero on success, or a negative error code on failure.
+ */
+static int
+ice_flash_component(struct pldmfw *context, struct pldmfw_component *component)
+{
+	struct ice_fwu_priv *priv = container_of(context, struct ice_fwu_priv, context);
+	struct netlink_ext_ack *extack = priv->extack;
+	struct ice_pf *pf = priv->pf;
+	const char *name;
+	u16 module;
+	u8 flag;
+	int err;
+
+	switch (component->identifier) {
+	case NVM_COMP_ID_OROM:
+		module = ICE_SR_1ST_OROM_BANK_PTR;
+		flag = ICE_AQC_NVM_ACTIV_SEL_OROM;
+		name = "fw.undi";
+		break;
+	case NVM_COMP_ID_NVM:
+		module = ICE_SR_1ST_NVM_BANK_PTR;
+		flag = ICE_AQC_NVM_ACTIV_SEL_NVM;
+		name = "fw.mgmt";
+		break;
+	case NVM_COMP_ID_NETLIST:
+		module = ICE_SR_NETLIST_BANK_PTR;
+		flag = ICE_AQC_NVM_ACTIV_SEL_NETLIST;
+		name = "fw.netlist";
+		break;
+	default:
+		/* This should not trigger, since we check the id before
+		 * sending the component table to firmware.
+		 */
+		WARN(1, "Unexpected unknown component identifier 0x%02x",
+		     component->identifier);
+		return -EINVAL;
+	}
+
+	/* Mark this component for activating at the end */
+	priv->activate_flags |= flag;
+
+	err = ice_erase_nvm_module(pf, module, name, extack);
+	if (err)
+		return err;
+
+	return ice_write_nvm_module(pf, module, name, component->component_data,
+				    component->component_size, extack);
+}
+
+/**
+ * ice_finalize_update - Perform last steps to complete device update
+ * @context: PLDM fw update structure
+ *
+ * Called as the last step of the update process. Complete the update by
+ * telling the firmware to switch active banks, and perform a reset of
+ * configured.
+ *
+ * Returns: 0 on success, or an error code on failure.
+ */
+static int ice_finalize_update(struct pldmfw *context)
+{
+	struct ice_fwu_priv *priv = container_of(context, struct ice_fwu_priv, context);
+	struct netlink_ext_ack *extack = priv->extack;
+	struct ice_pf *pf = priv->pf;
+	int err;
+
+	/* Finally, notify firmware to activate the written NVM banks */
+	err = ice_switch_flash_banks(pf, priv->activate_flags, extack);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static const struct pldmfw_ops ice_fwu_ops = {
+	.match_record = &pldmfw_op_pci_match_record,
+	.send_package_data = &ice_send_package_data,
+	.send_component_table = &ice_send_component_table,
+	.flash_component = &ice_flash_component,
+	.finalize_update = &ice_finalize_update,
+};
+
+/**
+ * ice_flash_pldm_image - Write a PLDM-formatted firmware image to the device
+ * @pf: private device driver structure
+ * @fw: firmware object pointing to the relevant firmware file
+ * @extack: netlink extended ACK structure
+ *
+ * Parse the data for a given firmware file, verifying that it is a valid PLDM
+ * formatted image that matches this device.
+ *
+ * Extract the device record Package Data and Component Tables and send them
+ * to the firmware. Extract and write the flash data for each of the three
+ * main flash components, "fw.mgmt", "fw.undi", and "fw.netlist". Notify
+ * firmware once the data is written to the inactive banks.
+ *
+ * Returns: zero on success or a negative error code on failure.
+ */
+int ice_flash_pldm_image(struct ice_pf *pf, const struct firmware *fw,
+			 struct netlink_ext_ack *extack)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_hw *hw = &pf->hw;
+	struct ice_fwu_priv priv;
+	enum ice_status status;
+	int err;
+
+	memset(&priv, 0, sizeof(priv));
+
+	priv.context.ops = &ice_fwu_ops;
+	priv.context.dev = dev;
+	priv.extack = extack;
+	priv.pf = pf;
+	priv.activate_flags = ICE_AQC_NVM_PRESERVE_ALL;
+
+	status = ice_acquire_nvm(hw, ICE_RES_WRITE);
+	if (status) {
+		dev_err(dev, "Failed to acquire device flash lock, err %s aq_err %s\n",
+			ice_stat_str(status),
+			ice_aq_str(hw->adminq.sq_last_status));
+		NL_SET_ERR_MSG_MOD(extack, "Failed to acquire device flash lock");
+		return -EIO;
+	}
+
+	err = pldmfw_flash_image(&priv.context, fw);
+
+	ice_release_nvm(hw);
+
+	return err;
+}
+
+/**
+ * ice_check_for_pending_update - Check for a pending flash update
+ * @pf: the PF driver structure
+ * @component: if not NULL, the name of the component being updated
+ * @extack: Netlink extended ACK structure
+ *
+ * Check whether the device already has a pending flash update.
+ *
+ * If `ignore_pending_flash_update` is false, return an error in case of
+ * a pending update.
+ *
+ * If `ignore_pending_flash_update` is true, tell the device to cancel the
+ * pending update and return 0.
+ *
+ * Returns: -EALREADY if `ignore_pending_flash_update` is false and there is
+ * a pending update. Zero if there is no pending update or if the update is
+ * successfully canceled.
+ */
+int ice_check_for_pending_update(struct ice_pf *pf, const char *component,
+				 struct netlink_ext_ack *extack)
+{
+	struct devlink *devlink = priv_to_devlink(pf);
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_hw_dev_caps *dev_caps;
+	struct ice_hw *hw = &pf->hw;
+	enum ice_status status;
+	u8 pending = 0;
+	int err;
+
+	dev_caps = kzalloc(sizeof(*dev_caps), GFP_KERNEL);
+	if (!dev_caps)
+		return -ENOMEM;
+
+	/* Read the most recent device capabilities from firmware. Do not use
+	 * the cached values in hw->dev_caps, because the pending update flag
+	 * may have changed, e.g. if an update was previously completed and
+	 * the system has not yet rebooted.
+	 */
+	status = ice_discover_dev_caps(hw, dev_caps);
+	if (status) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to read device capabilities");
+		kfree(dev_caps);
+		return -EIO;
+	}
+
+	if (dev_caps->common_cap.nvm_update_pending_nvm) {
+		dev_info(dev, "The fw.mgmt flash component has a pending update\n");
+		pending |= ICE_AQC_NVM_ACTIV_SEL_NVM;
+	}
+
+	if (dev_caps->common_cap.nvm_update_pending_orom) {
+		dev_info(dev, "The fw.undi flash component has a pending update\n");
+		pending |= ICE_AQC_NVM_ACTIV_SEL_OROM;
+	}
+
+	if (dev_caps->common_cap.nvm_update_pending_netlist) {
+		dev_info(dev, "The fw.netlist flash component has a pending update\n");
+		pending |= ICE_AQC_NVM_ACTIV_SEL_NETLIST;
+	}
+
+	kfree(dev_caps);
+
+	/* If the flash_update request is for a specific component, ignore all
+	 * of the other components.
+	 */
+	if (component) {
+		if (strcmp(component, "fw.mgmt") == 0)
+			pending &= ICE_AQC_NVM_ACTIV_SEL_NVM;
+		else if (strcmp(component, "fw.undi") == 0)
+			pending &= ICE_AQC_NVM_ACTIV_SEL_OROM;
+		else if (strcmp(component, "fw.netlist") == 0)
+			pending &= ICE_AQC_NVM_ACTIV_SEL_NETLIST;
+		else
+			WARN(1, "Unexpected flash component %s", component);
+	}
+
+	/* There is no previous pending update, so this request may continue */
+	if (!pending)
+		return 0;
+
+	/* In order to allow overwriting a previous pending update, notify
+	 * firmware to cancel that update by issuing the appropriate command.
+	 */
+	devlink_flash_update_status_notify(devlink,
+					   "Canceling previous pending update",
+					   component, 0, 0);
+
+	status = ice_acquire_nvm(hw, ICE_RES_WRITE);
+	if (status) {
+		dev_err(dev, "Failed to acquire device flash lock, err %s aq_err %s\n",
+			ice_stat_str(status),
+			ice_aq_str(hw->adminq.sq_last_status));
+		NL_SET_ERR_MSG_MOD(extack, "Failed to acquire device flash lock");
+		return -EIO;
+	}
+
+	pending |= ICE_AQC_NVM_REVERT_LAST_ACTIV;
+	err = ice_switch_flash_banks(pf, pending, extack);
+
+	ice_release_nvm(hw);
+
+	return err;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.h b/drivers/net/ethernet/intel/ice/ice_fw_update.h
new file mode 100644
index 000000000000..79472cc618b4
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2018-2019, Intel Corporation. */
+
+#ifndef _ICE_FW_UPDATE_H_
+#define _ICE_FW_UPDATE_H_
+
+int ice_flash_pldm_image(struct ice_pf *pf, const struct firmware *fw,
+			 struct netlink_ext_ack *extack);
+int ice_check_for_pending_update(struct ice_pf *pf, const char *component,
+				 struct netlink_ext_ack *extack);
+
+#endif
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 840e35e5f6f3..5dbb18c4359a 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1020,6 +1020,151 @@ ice_handle_link_event(struct ice_pf *pf, struct ice_rq_event_info *event)
 	return status;
 }
 
+enum ice_aq_task_state {
+	ICE_AQ_TASK_WAITING = 0,
+	ICE_AQ_TASK_COMPLETE,
+	ICE_AQ_TASK_CANCELED,
+};
+
+struct ice_aq_task {
+	struct hlist_node entry;
+
+	u16 opcode;
+	struct ice_rq_event_info *event;
+	enum ice_aq_task_state state;
+};
+
+/**
+ * ice_wait_for_aq_event - Wait for an AdminQ event from firmware
+ * @pf: pointer to the PF private structure
+ * @opcode: the opcode to wait for
+ * @timeout: how long to wait, in jiffies
+ * @event: storage for the event info
+ *
+ * Waits for a specific AdminQ completion event on the ARQ for a given PF. The
+ * current thread will be put to sleep until the specified event occurs or
+ * until the given timeout is reached.
+ *
+ * To obtain only the descriptor contents, pass an event without an allocated
+ * msg_buf. If the complete data buffer is desired, allocate the
+ * event->msg_buf with enough space ahead of time.
+ *
+ * Returns: zero on success, or a negative error code on failure.
+ */
+int ice_aq_wait_for_event(struct ice_pf *pf, u16 opcode, unsigned long timeout,
+			  struct ice_rq_event_info *event)
+{
+	struct ice_aq_task *task;
+	long ret;
+	int err;
+
+	task = kzalloc(sizeof(*task), GFP_KERNEL);
+	if (!task)
+		return -ENOMEM;
+
+	INIT_HLIST_NODE(&task->entry);
+	task->opcode = opcode;
+	task->event = event;
+	task->state = ICE_AQ_TASK_WAITING;
+
+	spin_lock_bh(&pf->aq_wait_lock);
+	hlist_add_head(&task->entry, &pf->aq_wait_list);
+	spin_unlock_bh(&pf->aq_wait_lock);
+
+	ret = wait_event_interruptible_timeout(pf->aq_wait_queue, task->state,
+					       timeout);
+	switch (task->state) {
+	case ICE_AQ_TASK_WAITING:
+		err = ret < 0 ? ret : -ETIMEDOUT;
+		break;
+	case ICE_AQ_TASK_CANCELED:
+		err = ret < 0 ? ret : -ECANCELED;
+		break;
+	case ICE_AQ_TASK_COMPLETE:
+		err = ret < 0 ? ret : 0;
+		break;
+	default:
+		WARN(1, "Unexpected AdminQ wait task state %u", task->state);
+		err = -EINVAL;
+		break;
+	}
+
+	spin_lock_bh(&pf->aq_wait_lock);
+	hlist_del(&task->entry);
+	spin_unlock_bh(&pf->aq_wait_lock);
+	kfree(task);
+
+	return err;
+}
+
+/**
+ * ice_aq_check_events - Check if any thread is waiting for an AdminQ event
+ * @pf: pointer to the PF private structure
+ * @opcode: the opcode of the event
+ * @event: the event to check
+ *
+ * Loops over the current list of pending threads waiting for an AdminQ event.
+ * For each matching task, copy the contents of the event into the task
+ * structure and wake up the thread.
+ *
+ * If multiple threads wait for the same opcode, they will all be woken up.
+ *
+ * Note that event->msg_buf will only be duplicated if the event has a buffer
+ * with enough space already allocated. Otherwise, only the descriptor and
+ * message length will be copied.
+ *
+ * Returns: true if an event was found, false otherwise
+ */
+static void ice_aq_check_events(struct ice_pf *pf, u16 opcode,
+				struct ice_rq_event_info *event)
+{
+	struct ice_aq_task *task;
+	bool found = false;
+
+	spin_lock_bh(&pf->aq_wait_lock);
+	hlist_for_each_entry(task, &pf->aq_wait_list, entry) {
+		if (task->state || task->opcode != opcode)
+			continue;
+
+		memcpy(&task->event->desc, &event->desc, sizeof(event->desc));
+		task->event->msg_len = event->msg_len;
+
+		/* Only copy the data buffer if a destination was set */
+		if (task->event->msg_buf &&
+		    task->event->buf_len > event->buf_len) {
+			memcpy(task->event->msg_buf, event->msg_buf,
+			       event->buf_len);
+			task->event->buf_len = event->buf_len;
+		}
+
+		task->state = ICE_AQ_TASK_COMPLETE;
+		found = true;
+	}
+	spin_unlock_bh(&pf->aq_wait_lock);
+
+	if (found)
+		wake_up(&pf->aq_wait_queue);
+}
+
+/**
+ * ice_aq_cancel_waiting_tasks - Immediately cancel all waiting tasks
+ * @pf: the PF private structure
+ *
+ * Set all waiting tasks to ICE_AQ_TASK_CANCELED, and wake up their threads.
+ * This will then cause ice_aq_wait_for_event to exit with -ECANCELED.
+ */
+static void ice_aq_cancel_waiting_tasks(struct ice_pf *pf)
+{
+	struct ice_aq_task *task;
+
+	spin_lock_bh(&pf->aq_wait_lock);
+	hlist_for_each_entry(task, &pf->aq_wait_list, entry)
+		task->state = ICE_AQ_TASK_CANCELED;
+	spin_unlock_bh(&pf->aq_wait_lock);
+
+	wake_up(&pf->aq_wait_queue);
+}
+
 /**
  * __ice_clean_ctrlq - helper function to clean controlq rings
  * @pf: ptr to struct ice_pf
@@ -1116,6 +1261,9 @@ static int __ice_clean_ctrlq(struct ice_pf *pf, enum ice_ctl_q q_type)
 
 		opcode = le16_to_cpu(event.desc.opcode);
 
+		/* Notify any thread that might be waiting for this event */
+		ice_aq_check_events(pf, opcode, &event);
+
 		switch (opcode) {
 		case ice_aqc_opc_get_link_status:
 			if (ice_handle_link_event(pf, &event))
@@ -3202,6 +3350,10 @@ static int ice_init_pf(struct ice_pf *pf)
 	mutex_init(&pf->sw_mutex);
 	mutex_init(&pf->tc_mutex);
 
+	INIT_HLIST_HEAD(&pf->aq_wait_list);
+	spin_lock_init(&pf->aq_wait_lock);
+	init_waitqueue_head(&pf->aq_wait_queue);
+
 	/* setup service timer and periodic service task */
 	timer_setup(&pf->serv_tmr, ice_service_timer, 0);
 	pf->serv_tmr_period = HZ;
@@ -4189,6 +4341,8 @@ static void ice_remove(struct pci_dev *pdev)
 	set_bit(__ICE_DOWN, pf->state);
 	ice_service_task_stop(pf);
 
+	ice_aq_cancel_waiting_tasks(pf);
+
 	mutex_destroy(&(&pf->hw)->fdir_fltr_lock);
 	if (!ice_is_safe_mode(pf))
 		ice_remove_arfs(pf);
-- 
2.27.0.353.gb9a2d1a0207f

