Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955E55A0005
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 19:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239789AbiHXRD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 13:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239765AbiHXRDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 13:03:54 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9D170E61
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 10:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661360632; x=1692896632;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a09Hs9HH0nUlMfKA0gDs28uAXJlBqDlpVSoC/JOxaf0=;
  b=UxNgOvN4W8ZzoEC4nODNVb5LIoJC/Se2OW9+BmSr3I4qN1XrrfIT056z
   MuNhuRaZnoLCCNK9Kk0iFA+vQgiu3db0LQphweBhmrzgxyyMLHNsRBXhC
   osKSIySeEjPtsatZMIC3pbFvK21Tsrs/UTtBqOfjeQnq1TcKng1sg7vHp
   pIONGhgjbL6DNqvqKjE/wTt7DjO5BFnBB3Ox86XZ6oVb0vlOgHl7lhrVx
   0f8KqGdJ2sWueC8fahzMybuB6uTWs2ZBnV3d66y8imG7acmBcSEttspFS
   k2ixdVacVuZfoApxAsYJP4MZkqEIKSzFgwO4tqaLi1KawHrgQKjd97GX6
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="280995463"
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="280995463"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 10:03:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="937989136"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 24 Aug 2022 10:03:48 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 4/5] ice: Implement devlink port split operations
Date:   Wed, 24 Aug 2022 10:03:39 -0700
Message-Id: <20220824170340.207131-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220824170340.207131-1-anthony.l.nguyen@intel.com>
References: <20220824170340.207131-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>

Allow to configure port split options using the devlink port split
interface. Support port splitting only for port 0, as the FW has
a predefined set of available port split options for the whole device.

Add ice_devlink_port_options_print() function to print the table with
all available FW port split options. It will be printed after each port
split and unsplit command.

Add documentation for devlink port split interface usage for the ice
driver.

Co-developed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 Documentation/networking/devlink/ice.rst     |  36 +++
 drivers/net/ethernet/intel/ice/ice_devlink.c | 288 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_type.h    |   2 +
 3 files changed, 326 insertions(+)

diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
index 8c082b139bbd..0c89ceb8986d 100644
--- a/Documentation/networking/devlink/ice.rst
+++ b/Documentation/networking/devlink/ice.rst
@@ -139,6 +139,42 @@ EMP firmware image.
 The driver does not currently support reloading the driver via
 ``DEVLINK_RELOAD_ACTION_DRIVER_REINIT``.
 
+Port split
+==========
+
+The ``ice`` driver supports port splitting only for port 0, as the FW has
+a predefined set of available port split options for the whole device.
+
+A system reboot is required for port split to be applied.
+
+The following command will select the port split option with 4 ports:
+
+.. code:: shell
+
+    $ devlink port split pci/0000:16:00.0/0 count 4
+
+The list of all available port options will be printed to dynamic debug after
+each ``split`` and ``unsplit`` command. The first option is the default.
+
+.. code:: shell
+
+    ice 0000:16:00.0: Available port split options and max port speeds (Gbps):
+    ice 0000:16:00.0: Status  Split      Quad 0          Quad 1
+    ice 0000:16:00.0:         count  L0  L1  L2  L3  L4  L5  L6  L7
+    ice 0000:16:00.0: Active  2     100   -   -   - 100   -   -   -
+    ice 0000:16:00.0:         2      50   -  50   -   -   -   -   -
+    ice 0000:16:00.0: Pending 4      25  25  25  25   -   -   -   -
+    ice 0000:16:00.0:         4      25  25   -   -  25  25   -   -
+    ice 0000:16:00.0:         8      10  10  10  10  10  10  10  10
+    ice 0000:16:00.0:         1     100   -   -   -   -   -   -   -
+
+There could be multiple FW port options with the same port split count. When
+the same port split count request is issued again, the next FW port option with
+the same port split count will be selected.
+
+``devlink port unsplit`` will select the option with a split count of 1. If
+there is no FW option available with split count 1, you will receive an error.
+
 Regions
 =======
 
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 3337314a7b35..e6ec20079ced 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -9,6 +9,8 @@
 #include "ice_eswitch.h"
 #include "ice_fw_update.h"
 
+static int ice_active_port_option = -1;
+
 /* context for devlink info version reporting */
 struct ice_info_ctx {
 	char buf[128];
@@ -466,12 +468,259 @@ ice_devlink_reload_empr_finish(struct devlink *devlink,
 	return 0;
 }
 
+/**
+ * ice_devlink_port_opt_speed_str - convert speed to a string
+ * @speed: speed value
+ */
+static const char *ice_devlink_port_opt_speed_str(u8 speed)
+{
+	switch (speed & ICE_AQC_PORT_OPT_MAX_LANE_M) {
+	case ICE_AQC_PORT_OPT_MAX_LANE_100M:
+		return "0.1";
+	case ICE_AQC_PORT_OPT_MAX_LANE_1G:
+		return "1";
+	case ICE_AQC_PORT_OPT_MAX_LANE_2500M:
+		return "2.5";
+	case ICE_AQC_PORT_OPT_MAX_LANE_5G:
+		return "5";
+	case ICE_AQC_PORT_OPT_MAX_LANE_10G:
+		return "10";
+	case ICE_AQC_PORT_OPT_MAX_LANE_25G:
+		return "25";
+	case ICE_AQC_PORT_OPT_MAX_LANE_50G:
+		return "50";
+	case ICE_AQC_PORT_OPT_MAX_LANE_100G:
+		return "100";
+	}
+
+	return "-";
+}
+
+#define ICE_PORT_OPT_DESC_LEN	50
+/**
+ * ice_devlink_port_options_print - Print available port split options
+ * @pf: the PF to print split port options
+ *
+ * Prints a table with available port split options and max port speeds
+ */
+static void ice_devlink_port_options_print(struct ice_pf *pf)
+{
+	u8 i, j, options_count, cnt, speed, pending_idx, active_idx;
+	struct ice_aqc_get_port_options_elem *options, *opt;
+	struct device *dev = ice_pf_to_dev(pf);
+	bool active_valid, pending_valid;
+	char desc[ICE_PORT_OPT_DESC_LEN];
+	const char *str;
+	int status;
+
+	options = kcalloc(ICE_AQC_PORT_OPT_MAX * ICE_MAX_PORT_PER_PCI_DEV,
+			  sizeof(*options), GFP_KERNEL);
+	if (!options)
+		return;
+
+	for (i = 0; i < ICE_MAX_PORT_PER_PCI_DEV; i++) {
+		opt = options + i * ICE_AQC_PORT_OPT_MAX;
+		options_count = ICE_AQC_PORT_OPT_MAX;
+		active_valid = 0;
+
+		status = ice_aq_get_port_options(&pf->hw, opt, &options_count,
+						 i, true, &active_idx,
+						 &active_valid, &pending_idx,
+						 &pending_valid);
+		if (status) {
+			dev_dbg(dev, "Couldn't read port option for port %d, err %d\n",
+				i, status);
+			goto err;
+		}
+	}
+
+	dev_dbg(dev, "Available port split options and max port speeds (Gbps):\n");
+	dev_dbg(dev, "Status  Split      Quad 0          Quad 1\n");
+	dev_dbg(dev, "        count  L0  L1  L2  L3  L4  L5  L6  L7\n");
+
+	for (i = 0; i < options_count; i++) {
+		cnt = 0;
+
+		if (i == ice_active_port_option)
+			str = "Active";
+		else if ((i == pending_idx) && pending_valid)
+			str = "Pending";
+		else
+			str = "";
+
+		cnt += snprintf(&desc[cnt], ICE_PORT_OPT_DESC_LEN - cnt,
+				"%-8s", str);
+
+		cnt += snprintf(&desc[cnt], ICE_PORT_OPT_DESC_LEN - cnt,
+				"%-6u", options[i].pmd);
+
+		for (j = 0; j < ICE_MAX_PORT_PER_PCI_DEV; ++j) {
+			speed = options[i + j * ICE_AQC_PORT_OPT_MAX].max_lane_speed;
+			str = ice_devlink_port_opt_speed_str(speed);
+			cnt += snprintf(&desc[cnt], ICE_PORT_OPT_DESC_LEN - cnt,
+					"%3s ", str);
+		}
+
+		dev_dbg(dev, "%s\n", desc);
+	}
+
+err:
+	kfree(options);
+}
+
+/**
+ * ice_devlink_aq_set_port_option - Send set port option admin queue command
+ * @pf: the PF to print split port options
+ * @option_idx: selected port option
+ * @extack: extended netdev ack structure
+ *
+ * Sends set port option admin queue command with selected port option and
+ * calls NVM write activate.
+ */
+static int
+ice_devlink_aq_set_port_option(struct ice_pf *pf, u8 option_idx,
+			       struct netlink_ext_ack *extack)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	int status;
+
+	status = ice_aq_set_port_option(&pf->hw, 0, true, option_idx);
+	if (status) {
+		dev_dbg(dev, "ice_aq_set_port_option, err %d aq_err %d\n",
+			status, pf->hw.adminq.sq_last_status);
+		NL_SET_ERR_MSG_MOD(extack, "Port split request failed");
+		return -EIO;
+	}
+
+	status = ice_acquire_nvm(&pf->hw, ICE_RES_WRITE);
+	if (status) {
+		dev_dbg(dev, "ice_acquire_nvm failed, err %d aq_err %d\n",
+			status, pf->hw.adminq.sq_last_status);
+		NL_SET_ERR_MSG_MOD(extack, "Failed to acquire NVM semaphore");
+		return -EIO;
+	}
+
+	status = ice_nvm_write_activate(&pf->hw, ICE_AQC_NVM_ACTIV_REQ_EMPR, NULL);
+	if (status) {
+		dev_dbg(dev, "ice_nvm_write_activate failed, err %d aq_err %d\n",
+			status, pf->hw.adminq.sq_last_status);
+		NL_SET_ERR_MSG_MOD(extack, "Port split request failed to save data");
+		ice_release_nvm(&pf->hw);
+		return -EIO;
+	}
+
+	ice_release_nvm(&pf->hw);
+
+	NL_SET_ERR_MSG_MOD(extack, "Reboot required to finish port split");
+	return 0;
+}
+
+/**
+ * ice_devlink_port_split - .port_split devlink handler
+ * @devlink: devlink instance structure
+ * @port: devlink port structure
+ * @count: number of ports to split to
+ * @extack: extended netdev ack structure
+ *
+ * Callback for the devlink .port_split operation.
+ *
+ * Unfortunately, the devlink expression of available options is limited
+ * to just a number, so search for an FW port option which supports
+ * the specified number. As there could be multiple FW port options with
+ * the same port split count, allow switching between them. When the same
+ * port split count request is issued again, switch to the next FW port
+ * option with the same port split count.
+ *
+ * Return: zero on success or an error code on failure.
+ */
+static int
+ice_devlink_port_split(struct devlink *devlink, struct devlink_port *port,
+		       unsigned int count, struct netlink_ext_ack *extack)
+{
+	struct ice_aqc_get_port_options_elem options[ICE_AQC_PORT_OPT_MAX];
+	u8 i, j, active_idx, pending_idx, new_option;
+	struct ice_pf *pf = devlink_priv(devlink);
+	u8 option_count = ICE_AQC_PORT_OPT_MAX;
+	struct device *dev = ice_pf_to_dev(pf);
+	bool active_valid, pending_valid;
+	int status;
+
+	status = ice_aq_get_port_options(&pf->hw, options, &option_count,
+					 0, true, &active_idx, &active_valid,
+					 &pending_idx, &pending_valid);
+	if (status) {
+		dev_dbg(dev, "Couldn't read port split options, err = %d\n",
+			status);
+		NL_SET_ERR_MSG_MOD(extack, "Failed to get available port split options");
+		return -EIO;
+	}
+
+	new_option = ICE_AQC_PORT_OPT_MAX;
+	active_idx = pending_valid ? pending_idx : active_idx;
+	for (i = 1; i <= option_count; i++) {
+		/* In order to allow switching between FW port options with
+		 * the same port split count, search for a new option starting
+		 * from the active/pending option (with array wrap around).
+		 */
+		j = (active_idx + i) % option_count;
+
+		if (count == options[j].pmd) {
+			new_option = j;
+			break;
+		}
+	}
+
+	if (new_option == active_idx) {
+		dev_dbg(dev, "request to split: count: %u is already set and there are no other options\n",
+			count);
+		NL_SET_ERR_MSG_MOD(extack, "Requested split count is already set");
+		ice_devlink_port_options_print(pf);
+		return -EINVAL;
+	}
+
+	if (new_option == ICE_AQC_PORT_OPT_MAX) {
+		dev_dbg(dev, "request to split: count: %u not found\n", count);
+		NL_SET_ERR_MSG_MOD(extack, "Port split requested unsupported port config");
+		ice_devlink_port_options_print(pf);
+		return -EINVAL;
+	}
+
+	status = ice_devlink_aq_set_port_option(pf, new_option, extack);
+	if (status)
+		return status;
+
+	ice_devlink_port_options_print(pf);
+
+	return 0;
+}
+
+/**
+ * ice_devlink_port_unsplit - .port_unsplit devlink handler
+ * @devlink: devlink instance structure
+ * @port: devlink port structure
+ * @extack: extended netdev ack structure
+ *
+ * Callback for the devlink .port_unsplit operation.
+ * Calls ice_devlink_port_split with split count set to 1.
+ * There could be no FW option available with split count 1.
+ *
+ * Return: zero on success or an error code on failure.
+ */
+static int
+ice_devlink_port_unsplit(struct devlink *devlink, struct devlink_port *port,
+			 struct netlink_ext_ack *extack)
+{
+	return ice_devlink_port_split(devlink, port, 1, extack);
+}
+
 static const struct devlink_ops ice_devlink_ops = {
 	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
 	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
 	/* The ice driver currently does not support driver reinit */
 	.reload_down = ice_devlink_reload_empr_start,
 	.reload_up = ice_devlink_reload_empr_finish,
+	.port_split = ice_devlink_port_split,
+	.port_unsplit = ice_devlink_port_unsplit,
 	.eswitch_mode_get = ice_eswitch_mode_get,
 	.eswitch_mode_set = ice_eswitch_mode_set,
 	.info_get = ice_devlink_info_get,
@@ -694,6 +943,39 @@ void ice_devlink_unregister_params(struct ice_pf *pf)
 				  ARRAY_SIZE(ice_devlink_params));
 }
 
+/**
+ * ice_devlink_set_port_split_options - Set port split options
+ * @pf: the PF to set port split options
+ * @attrs: devlink attributes
+ *
+ * Sets devlink port split options based on available FW port options
+ */
+static void
+ice_devlink_set_port_split_options(struct ice_pf *pf,
+				   struct devlink_port_attrs *attrs)
+{
+	struct ice_aqc_get_port_options_elem options[ICE_AQC_PORT_OPT_MAX];
+	u8 i, active_idx, pending_idx, option_count = ICE_AQC_PORT_OPT_MAX;
+	bool active_valid, pending_valid;
+	int status;
+
+	status = ice_aq_get_port_options(&pf->hw, options, &option_count,
+					 0, true, &active_idx, &active_valid,
+					 &pending_idx, &pending_valid);
+	if (status) {
+		dev_dbg(ice_pf_to_dev(pf), "Couldn't read port split options, err = %d\n",
+			status);
+		return;
+	}
+
+	/* find the biggest available port split count */
+	for (i = 0; i < option_count; i++)
+		attrs->lanes = max_t(int, attrs->lanes, options[i].pmd);
+
+	attrs->splittable = attrs->lanes ? 1 : 0;
+	ice_active_port_option = active_idx;
+}
+
 /**
  * ice_devlink_create_pf_port - Create a devlink port for this PF
  * @pf: the PF to create a devlink port for
@@ -722,6 +1004,12 @@ int ice_devlink_create_pf_port(struct ice_pf *pf)
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
 	attrs.phys.port_number = pf->hw.bus.func;
 
+	/* As FW supports only port split options for whole device,
+	 * set port split options only for first PF.
+	 */
+	if (pf->hw.pf_id == 0)
+		ice_devlink_set_port_split_options(pf, &attrs);
+
 	ice_devlink_set_switch_id(pf, &attrs.switch_id);
 
 	devlink_port_attrs_set(devlink_port, &attrs);
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 8651f6c735ba..6ea54a3fad2c 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -564,6 +564,8 @@ enum ice_rl_type {
 #define ICE_SCHED_INVAL_PROF_ID		0xFFFF
 #define ICE_SCHED_DFLT_BURST_SIZE	(15 * 1024)	/* in bytes (15k) */
 
+#define ICE_MAX_PORT_PER_PCI_DEV 8
+
  /* Data structure for saving BW information */
 enum ice_bw_type {
 	ICE_BW_TYPE_PRIO,
-- 
2.35.1

