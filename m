Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8744F4B5E22
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 00:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiBNXPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 18:15:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiBNXPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 18:15:52 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED383177E7B
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 15:15:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644880542; x=1676416542;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uXZGqvRuptiBX68kyK75Ozqdzy/0Qmj5t0J6GXY7lgY=;
  b=Dk2ciE7+EZVVt5KQNYXb8595r/mZE/l0HAfep4puPy9l2ystxtZDqc0m
   dgxsV+wwHKXxA0xPUwtBxWOLxm+fyPEZDRL5Yc+rgVJSB/57hzx1BU0HH
   Q39XkdyC2cH0WKTdHEwZ7LH0jXkoMlDRxTEC4nLVh2zQYhFgpIGhgsUbT
   aVAwW1zaweRLeCiODmqWhuZ7o8SXElV7JmmCOm/haj8kunnBd3JI56ulZ
   l8jydKrLIc23Ki9I9jWh2nxvYAPHAQBkFUpYsLXOLO96hkxYv9i4HNjw3
   IajcUtT6xvPqUtVAiMkyHTg+yB/bJt3gEBceHQugfWqUCbeSN454Wqw69
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="230843838"
X-IronPort-AV: E=Sophos;i="5.88,368,1635231600"; 
   d="scan'208";a="230843838"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 15:15:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,368,1635231600"; 
   d="scan'208";a="543978398"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 14 Feb 2022 15:15:42 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Karol Kolacinski <karol.kolacinski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com,
        Sudhansu Sekhar Mishra <sudhansu.mishra@intel.com>,
        Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: [PATCH net-next 1/1] ice: add TTY for GNSS module for E810T device
Date:   Mon, 14 Feb 2022 15:15:36 -0800
Message-Id: <20220214231536.1603051-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karol Kolacinski <karol.kolacinski@intel.com>

Add a new ice_gnss.c file for holding the basic GNSS module functions.
If the device supports GNSS module, call the new ice_gnss_init and
ice_gnss_release functions where appropriate.

Implement basic functionality for reading the data from GNSS module
using TTY device.

Add I2C read AQ command. It is now required for controlling the external
physical connectors via external I2C port expander on E810-T adapters.

Future changes will introduce write functionality.

Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Signed-off-by: Sudhansu Sekhar Mishra <sudhansu.mishra@intel.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/Makefile       |   1 +
 drivers/net/ethernet/intel/ice/ice.h          |   6 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  21 +
 drivers/net/ethernet/intel/ice/ice_common.c   |  54 +++
 drivers/net/ethernet/intel/ice/ice_common.h   |   4 +
 drivers/net/ethernet/intel/ice/ice_gnss.c     | 376 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_gnss.h     |  51 +++
 drivers/net/ethernet/intel/ice/ice_lib.c      |   5 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  11 +
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c   |  31 ++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h   |   7 +
 11 files changed, 566 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_gnss.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_gnss.h

diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 389fff70d22e..44b8464b7663 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -40,6 +40,7 @@ ice-$(CONFIG_PCI_IOV) +=	\
 	ice_vf_vsi_vlan_ops.o	\
 	ice_virtchnl_pf.o
 ice-$(CONFIG_PTP_1588_CLOCK) += ice_ptp.o ice_ptp_hw.o
+ice-$(CONFIG_TTY) += ice_gnss.o
 ice-$(CONFIG_DCB) += ice_dcb.o ice_dcb_nl.o ice_dcb_lib.o
 ice-$(CONFIG_RFS_ACCEL) += ice_arfs.o
 ice-$(CONFIG_XDP_SOCKETS) += ice_xsk.o
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 8f40f6f9b8eb..98cf0f4bff64 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -73,6 +73,7 @@
 #include "ice_eswitch.h"
 #include "ice_lag.h"
 #include "ice_vsi_vlan_ops.h"
+#include "ice_gnss.h"
 
 #define ICE_BAR0		0
 #define ICE_REQ_DESC_MULTIPLE	32
@@ -184,6 +185,7 @@
 enum ice_feature {
 	ICE_F_DSCP,
 	ICE_F_SMA_CTRL,
+	ICE_F_GNSS,
 	ICE_F_MAX
 };
 
@@ -487,6 +489,7 @@ enum ice_pf_flags {
 	ICE_FLAG_VF_VLAN_PRUNING,
 	ICE_FLAG_LINK_LENIENT_MODE_ENA,
 	ICE_FLAG_PLUG_AUX_DEV,
+	ICE_FLAG_GNSS,			/* GNSS successfully initialized */
 	ICE_PF_FLAGS_NBITS		/* must be last */
 };
 
@@ -550,6 +553,9 @@ struct ice_pf {
 	struct mutex tc_mutex;		/* lock to protect TC changes */
 	u32 msg_enable;
 	struct ice_ptp ptp;
+	struct tty_driver *ice_gnss_tty_driver;
+	struct tty_port gnss_tty_port;
+	struct gnss_serial *gnss_serial;
 	u16 num_rdma_msix;		/* Total MSIX vectors for RDMA driver */
 	u16 rdma_base_vector;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index fd8ee5b7f596..a23a9ea10751 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1401,6 +1401,24 @@ struct ice_aqc_get_link_topo {
 	u8 rsvd[9];
 };
 
+/* Read I2C (direct, 0x06E2) */
+struct ice_aqc_i2c {
+	struct ice_aqc_link_topo_addr topo_addr;
+	__le16 i2c_addr;
+	u8 i2c_params;
+#define ICE_AQC_I2C_DATA_SIZE_S		0
+#define ICE_AQC_I2C_DATA_SIZE_M		(0xF << ICE_AQC_I2C_DATA_SIZE_S)
+#define ICE_AQC_I2C_USE_REPEATED_START	BIT(7)
+	u8 rsvd;
+	__le16 i2c_bus_addr;
+	u8 rsvd2[4];
+};
+
+/* Read I2C Response (direct, 0x06E2) */
+struct ice_aqc_read_i2c_resp {
+	u8 i2c_data[16];
+};
+
 /* Set Port Identification LED (direct, 0x06E9) */
 struct ice_aqc_set_port_id_led {
 	u8 lport_num;
@@ -2112,6 +2130,8 @@ struct ice_aq_desc {
 		struct ice_aqc_get_link_status get_link_status;
 		struct ice_aqc_event_lan_overflow lan_overflow;
 		struct ice_aqc_get_link_topo get_link_topo;
+		struct ice_aqc_i2c read_i2c;
+		struct ice_aqc_read_i2c_resp read_i2c_resp;
 	} params;
 };
 
@@ -2226,6 +2246,7 @@ enum ice_adminq_opc {
 	ice_aqc_opc_set_event_mask			= 0x0613,
 	ice_aqc_opc_set_mac_lb				= 0x0620,
 	ice_aqc_opc_get_link_topo			= 0x06E0,
+	ice_aqc_opc_read_i2c				= 0x06E2,
 	ice_aqc_opc_set_port_id_led			= 0x06E9,
 	ice_aqc_opc_set_gpio				= 0x06EC,
 	ice_aqc_opc_get_gpio				= 0x06ED,
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index c57e5fc41cf8..5e155d49bd9e 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -4797,6 +4797,60 @@ ice_sched_query_elem(struct ice_hw *hw, u32 node_teid,
 	return status;
 }
 
+/**
+ * ice_aq_read_i2c
+ * @hw: pointer to the hw struct
+ * @topo_addr: topology address for a device to communicate with
+ * @bus_addr: 7-bit I2C bus address
+ * @addr: I2C memory address (I2C offset) with up to 16 bits
+ * @params: I2C parameters: bit [7] - Repeated start,
+ *			    bits [6:5] data offset size,
+ *			    bit [4] - I2C address type,
+ *			    bits [3:0] - data size to read (0-16 bytes)
+ * @data: pointer to data (0 to 16 bytes) to be read from the I2C device
+ * @cd: pointer to command details structure or NULL
+ *
+ * Read I2C (0x06E2)
+ */
+int
+ice_aq_read_i2c(struct ice_hw *hw, struct ice_aqc_link_topo_addr topo_addr,
+		u16 bus_addr, __le16 addr, u8 params, u8 *data,
+		struct ice_sq_cd *cd)
+{
+	struct ice_aq_desc desc = { 0 };
+	struct ice_aqc_i2c *cmd;
+	u8 data_size;
+	int status;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_read_i2c);
+	cmd = &desc.params.read_i2c;
+
+	if (!data)
+		return -EINVAL;
+
+	data_size = (params & ICE_AQC_I2C_DATA_SIZE_M) >>
+		    ICE_AQC_I2C_DATA_SIZE_S;
+
+	cmd->i2c_bus_addr = cpu_to_le16(bus_addr);
+	cmd->topo_addr = topo_addr;
+	cmd->i2c_params = params;
+	cmd->i2c_addr = addr;
+
+	status = ice_aq_send_cmd(hw, &desc, NULL, 0, cd);
+	if (!status) {
+		struct ice_aqc_read_i2c_resp *resp;
+		u8 i;
+
+		resp = &desc.params.read_i2c_resp;
+		for (i = 0; i < data_size; i++) {
+			*data = resp->i2c_data[i];
+			data++;
+		}
+	}
+
+	return status;
+}
+
 /**
  * ice_aq_set_driver_param - Set driver parameter to share via firmware
  * @hw: pointer to the HW struct
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index d28749edd92f..9a721d5545f3 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -208,5 +208,9 @@ ice_aq_set_lldp_mib(struct ice_hw *hw, u8 mib_type, void *buf, u16 buf_size,
 bool ice_fw_supports_lldp_fltr_ctrl(struct ice_hw *hw);
 int
 ice_lldp_fltr_add_remove(struct ice_hw *hw, u16 vsi_num, bool add);
+int
+ice_aq_read_i2c(struct ice_hw *hw, struct ice_aqc_link_topo_addr topo_addr,
+		u16 bus_addr, __le16 addr, u8 params, u8 *data,
+		struct ice_sq_cd *cd);
 bool ice_fw_supports_report_dflt_cfg(struct ice_hw *hw);
 #endif /* _ICE_COMMON_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
new file mode 100644
index 000000000000..bbcb49a0c9cc
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
@@ -0,0 +1,376 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2018-2021, Intel Corporation. */
+
+#include "ice.h"
+#include "ice_lib.h"
+#include <linux/tty_driver.h>
+
+/**
+ * ice_gnss_read - Read data from internal GNSS module
+ * @work: GNSS read work structure
+ *
+ * Read the data from internal GNSS receiver, number of bytes read will be
+ * returned in *read_data parameter.
+ */
+static void ice_gnss_read(struct kthread_work *work)
+{
+	struct gnss_serial *gnss = container_of(work, struct gnss_serial,
+						read_work.work);
+	struct ice_aqc_link_topo_addr link_topo;
+	u8 i2c_params, bytes_read;
+	struct tty_port *port;
+	struct ice_pf *pf;
+	struct ice_hw *hw;
+	__be16 data_len_b;
+	char *buf = NULL;
+	u16 i, data_len;
+	int err = 0;
+
+	pf = gnss->back;
+	if (!pf || !gnss->tty || !gnss->tty->port) {
+		err = -EFAULT;
+		goto exit;
+	}
+
+	hw = &pf->hw;
+	port = gnss->tty->port;
+
+	buf = (char *)get_zeroed_page(GFP_KERNEL);
+	if (!buf) {
+		err = -ENOMEM;
+		goto exit;
+	}
+
+	memset(&link_topo, 0, sizeof(struct ice_aqc_link_topo_addr));
+	link_topo.topo_params.index = ICE_E810T_GNSS_I2C_BUS;
+	link_topo.topo_params.node_type_ctx |=
+		ICE_AQC_LINK_TOPO_NODE_CTX_OVERRIDE <<
+		ICE_AQC_LINK_TOPO_NODE_CTX_S;
+
+	i2c_params = ICE_GNSS_UBX_DATA_LEN_WIDTH |
+		     ICE_AQC_I2C_USE_REPEATED_START;
+
+	/* Read data length in a loop, when it's not 0 the data is ready */
+	for (i = 0; i < ICE_MAX_UBX_READ_TRIES; i++) {
+		err = ice_aq_read_i2c(hw, link_topo, ICE_GNSS_UBX_I2C_BUS_ADDR,
+				      cpu_to_le16(ICE_GNSS_UBX_DATA_LEN_H),
+				      i2c_params, (u8 *)&data_len_b, NULL);
+		if (err)
+			goto exit_buf;
+
+		data_len = be16_to_cpu(data_len_b);
+		if (data_len != 0 && data_len != U16_MAX)
+			break;
+
+		mdelay(10);
+	}
+
+	data_len = min(data_len, (u16)PAGE_SIZE);
+	data_len = tty_buffer_request_room(port, data_len);
+	if (!data_len) {
+		err = -ENOMEM;
+		goto exit_buf;
+	}
+
+	/* Read received data */
+	for (i = 0; i < data_len; i += bytes_read) {
+		u16 bytes_left = data_len - i;
+
+		bytes_read = bytes_left < ICE_MAX_I2C_DATA_SIZE ? bytes_left :
+					  ICE_MAX_I2C_DATA_SIZE;
+
+		err = ice_aq_read_i2c(hw, link_topo, ICE_GNSS_UBX_I2C_BUS_ADDR,
+				      cpu_to_le16(ICE_GNSS_UBX_EMPTY_DATA),
+				      bytes_read, &buf[i], NULL);
+		if (err)
+			goto exit_buf;
+	}
+
+	/* Send the data to the tty layer for users to read. This doesn't
+	 * actually push the data through unless tty->low_latency is set.
+	 */
+	tty_insert_flip_string(port, buf, i);
+	tty_flip_buffer_push(port);
+
+exit_buf:
+	free_page((unsigned long)buf);
+	kthread_queue_delayed_work(gnss->kworker, &gnss->read_work,
+				   ICE_GNSS_TIMER_DELAY_TIME);
+exit:
+	if (err)
+		dev_dbg(ice_pf_to_dev(pf), "GNSS failed to read err=%d\n", err);
+}
+
+/**
+ * ice_gnss_struct_init - Initialize GNSS structure for the TTY
+ * @pf: Board private structure
+ */
+static struct gnss_serial *ice_gnss_struct_init(struct ice_pf *pf)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	struct kthread_worker *kworker;
+	struct gnss_serial *gnss;
+
+	gnss = kzalloc(sizeof(*gnss), GFP_KERNEL);
+	if (!gnss)
+		return NULL;
+
+	mutex_init(&gnss->gnss_mutex);
+	gnss->open_count = 0;
+	gnss->back = pf;
+	pf->gnss_serial = gnss;
+
+	kthread_init_delayed_work(&gnss->read_work, ice_gnss_read);
+	/* Allocate a kworker for handling work required for the GNSS TTY
+	 * writes.
+	 */
+	kworker = kthread_create_worker(0, "ice-gnss-%s", dev_name(dev));
+	if (!kworker) {
+		kfree(gnss);
+		return NULL;
+	}
+
+	gnss->kworker = kworker;
+
+	return gnss;
+}
+
+/**
+ * ice_gnss_tty_open - Initialize GNSS structures on TTY device open
+ * @tty: pointer to the tty_struct
+ * @filp: pointer to the file
+ *
+ * This routine is mandatory. If this routine is not filled in, the attempted
+ * open will fail with ENODEV.
+ */
+static int ice_gnss_tty_open(struct tty_struct *tty, struct file *filp)
+{
+	struct gnss_serial *gnss;
+	struct ice_pf *pf;
+
+	pf = (struct ice_pf *)tty->driver->driver_state;
+	if (!pf)
+		return -EFAULT;
+
+	/* Clear the pointer in case something fails */
+	tty->driver_data = NULL;
+
+	/* Get the serial object associated with this tty pointer */
+	gnss = pf->gnss_serial;
+	if (!gnss) {
+		/* Initialize GNSS struct on the first device open */
+		gnss = ice_gnss_struct_init(pf);
+		if (!gnss)
+			return -ENOMEM;
+	}
+
+	mutex_lock(&gnss->gnss_mutex);
+
+	/* Save our structure within the tty structure */
+	tty->driver_data = gnss;
+	gnss->tty = tty;
+	gnss->open_count++;
+	kthread_queue_delayed_work(gnss->kworker, &gnss->read_work, 0);
+
+	mutex_unlock(&gnss->gnss_mutex);
+
+	return 0;
+}
+
+/**
+ * ice_gnss_tty_close - Cleanup GNSS structures on tty device close
+ * @tty: pointer to the tty_struct
+ * @filp: pointer to the file
+ */
+static void ice_gnss_tty_close(struct tty_struct *tty, struct file *filp)
+{
+	struct gnss_serial *gnss = tty->driver_data;
+	struct ice_pf *pf;
+
+	if (!gnss)
+		return;
+
+	pf = (struct ice_pf *)tty->driver->driver_state;
+	if (!pf)
+		return;
+
+	mutex_lock(&gnss->gnss_mutex);
+
+	if (!gnss->open_count) {
+		/* Port was never opened */
+		dev_err(ice_pf_to_dev(pf), "GNSS port not opened\n");
+		goto exit;
+	}
+
+	gnss->open_count--;
+	if (gnss->open_count <= 0) {
+		/* Port is in shutdown state */
+		kthread_cancel_delayed_work_sync(&gnss->read_work);
+	}
+exit:
+	mutex_unlock(&gnss->gnss_mutex);
+}
+
+/**
+ * ice_gnss_tty_write - Dummy TTY write function to avoid kernel panic
+ * @tty: pointer to the tty_struct
+ * @buf: pointer to the user data
+ * @cnt: the number of characters that was able to be sent to the hardware (or
+ *       queued to be sent at a later time)
+ */
+static int
+ice_gnss_tty_write(struct tty_struct *tty, const unsigned char *buf, int cnt)
+{
+	return 0;
+}
+
+/**
+ * ice_gnss_tty_write_room - Dummy TTY write_room function to avoid kernel panic
+ * @tty: pointer to the tty_struct
+ */
+static unsigned int ice_gnss_tty_write_room(struct tty_struct *tty)
+{
+	return 0;
+}
+
+static const struct tty_operations tty_gps_ops = {
+	.open =		ice_gnss_tty_open,
+	.close =	ice_gnss_tty_close,
+	.write =	ice_gnss_tty_write,
+	.write_room =	ice_gnss_tty_write_room,
+};
+
+/**
+ * ice_gnss_create_tty_driver - Create a TTY driver for GNSS
+ * @pf: Board private structure
+ */
+static struct tty_driver *ice_gnss_create_tty_driver(struct ice_pf *pf)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	const int ICE_TTYDRV_NAME_MAX = 14;
+	struct tty_driver *tty_driver;
+	char *ttydrv_name;
+	int err;
+
+	tty_driver = tty_alloc_driver(1, TTY_DRIVER_REAL_RAW);
+	if (!tty_driver) {
+		dev_err(ice_pf_to_dev(pf), "Failed to allocate memory for GNSS TTY\n");
+		return NULL;
+	}
+
+	ttydrv_name = kzalloc(ICE_TTYDRV_NAME_MAX, GFP_KERNEL);
+	if (!ttydrv_name) {
+		tty_driver_kref_put(tty_driver);
+		return NULL;
+	}
+
+	snprintf(ttydrv_name, ICE_TTYDRV_NAME_MAX, "ttyGNSS_%02x%02x_",
+		 (u8)pf->pdev->bus->number, (u8)PCI_SLOT(pf->pdev->devfn));
+
+	/* Initialize the tty driver*/
+	tty_driver->owner = THIS_MODULE;
+	tty_driver->driver_name = dev_driver_string(dev);
+	tty_driver->name = (const char *)ttydrv_name;
+	tty_driver->type = TTY_DRIVER_TYPE_SERIAL;
+	tty_driver->subtype = SERIAL_TYPE_NORMAL;
+	tty_driver->init_termios = tty_std_termios;
+	tty_driver->init_termios.c_iflag &= ~INLCR;
+	tty_driver->init_termios.c_iflag |= IGNCR;
+	tty_driver->init_termios.c_oflag &= ~OPOST;
+	tty_driver->init_termios.c_lflag &= ~ICANON;
+	tty_driver->init_termios.c_cflag &= ~(CSIZE | CBAUD | CBAUDEX);
+	/* baud rate 9600 */
+	tty_termios_encode_baud_rate(&tty_driver->init_termios, 9600, 9600);
+	tty_driver->driver_state = pf;
+	tty_set_operations(tty_driver, &tty_gps_ops);
+
+	pf->gnss_serial = NULL;
+
+	tty_port_init(&pf->gnss_tty_port);
+	tty_port_link_device(&pf->gnss_tty_port, tty_driver, 0);
+
+	err = tty_register_driver(tty_driver);
+	if (err) {
+		dev_err(ice_pf_to_dev(pf), "Failed to register TTY driver err=%d\n",
+			err);
+
+		tty_port_destroy(&pf->gnss_tty_port);
+		kfree(ttydrv_name);
+		tty_driver_kref_put(pf->ice_gnss_tty_driver);
+
+		return NULL;
+	}
+
+	return tty_driver;
+}
+
+/**
+ * ice_gnss_init - Initialize GNSS TTY support
+ * @pf: Board private structure
+ */
+void ice_gnss_init(struct ice_pf *pf)
+{
+	struct tty_driver *tty_driver;
+
+	tty_driver = ice_gnss_create_tty_driver(pf);
+	if (!tty_driver)
+		return;
+
+	pf->ice_gnss_tty_driver = tty_driver;
+
+	set_bit(ICE_FLAG_GNSS, pf->flags);
+	dev_info(ice_pf_to_dev(pf), "GNSS TTY init successful\n");
+}
+
+/**
+ * ice_gnss_exit - Disable GNSS TTY support
+ * @pf: Board private structure
+ */
+void ice_gnss_exit(struct ice_pf *pf)
+{
+	if (!test_bit(ICE_FLAG_GNSS, pf->flags) || !pf->ice_gnss_tty_driver)
+		return;
+
+	tty_port_destroy(&pf->gnss_tty_port);
+
+	if (pf->gnss_serial) {
+		struct gnss_serial *gnss = pf->gnss_serial;
+
+		kthread_cancel_delayed_work_sync(&gnss->read_work);
+		kfree(gnss);
+		pf->gnss_serial = NULL;
+	}
+
+	tty_unregister_driver(pf->ice_gnss_tty_driver);
+	kfree(pf->ice_gnss_tty_driver->name);
+	tty_driver_kref_put(pf->ice_gnss_tty_driver);
+	pf->ice_gnss_tty_driver = NULL;
+}
+
+/**
+ * ice_gnss_is_gps_present - Check if GPS HW is present
+ * @hw: pointer to HW struct
+ */
+bool ice_gnss_is_gps_present(struct ice_hw *hw)
+{
+	if (!hw->func_caps.ts_func_info.src_tmr_owned)
+		return false;
+
+#if IS_ENABLED(CONFIG_PTP_1588_CLOCK)
+	if (ice_is_e810t(hw)) {
+		int err;
+		u8 data;
+
+		err = ice_read_pca9575_reg_e810t(hw, ICE_PCA9575_P0_IN, &data);
+		if (err || !!(data & ICE_E810T_P0_GNSS_PRSNT_N))
+			return false;
+	} else {
+		return false;
+	}
+#else
+	if (!ice_is_e810t(hw))
+		return false;
+#endif /* IS_ENABLED(CONFIG_PTP_1588_CLOCK) */
+
+	return true;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.h b/drivers/net/ethernet/intel/ice/ice_gnss.h
new file mode 100644
index 000000000000..a53af4b59175
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.h
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2018-2021, Intel Corporation. */
+
+#ifndef _ICE_GNSS_H_
+#define _ICE_GNSS_H_
+
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
+
+#define ICE_E810T_GNSS_I2C_BUS		0x2
+#define ICE_GNSS_UBX_I2C_BUS_ADDR	0x42
+/* Data length register is big endian */
+#define ICE_GNSS_UBX_DATA_LEN_H		0xFD
+#define ICE_GNSS_UBX_DATA_LEN_WIDTH	2
+#define ICE_GNSS_UBX_EMPTY_DATA		0xFF
+#define ICE_GNSS_TIMER_DELAY_TIME	(HZ / 10) /* 0.1 second per message */
+#define ICE_MAX_I2C_DATA_SIZE		(ICE_AQC_I2C_DATA_SIZE_M >> \
+					ICE_AQC_I2C_DATA_SIZE_S)
+#define ICE_MAX_UBX_READ_TRIES		255
+
+/**
+ * struct gnss_serial - data used to initialize GNSS TTY port
+ * @back: back pointer to PF
+ * @tty: pointer to the tty for this device
+ * @open_count: number of times this port has been opened
+ * @gnss_mutex: gnss_mutex used to protect GNSS serial operations
+ * @kworker: kwork thread for handling periodic work
+ * @read_work: read_work function for handling GNSS reads
+ */
+struct gnss_serial {
+	struct ice_pf *back;
+	struct tty_struct *tty;
+	int open_count;
+	struct mutex gnss_mutex; /* protects GNSS serial structure */
+	struct kthread_worker *kworker;
+	struct kthread_delayed_work read_work;
+};
+
+#if IS_ENABLED(CONFIG_TTY)
+void ice_gnss_init(struct ice_pf *pf);
+void ice_gnss_exit(struct ice_pf *pf);
+bool ice_gnss_is_gps_present(struct ice_hw *hw);
+#else
+static inline void ice_gnss_init(struct ice_pf *pf) { }
+static inline void ice_gnss_exit(struct ice_pf *pf) { }
+static inline bool ice_gnss_is_gps_present(struct ice_hw *hw)
+{
+	return false;
+}
+#endif /* IS_ENABLED(CONFIG_TTY) */
+#endif /* _ICE_GNSS_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 7a1cb29e5bcb..4e9efd49c149 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -4088,8 +4088,11 @@ void ice_init_feature_support(struct ice_pf *pf)
 	case ICE_DEV_ID_E810C_QSFP:
 	case ICE_DEV_ID_E810C_SFP:
 		ice_set_feature_support(pf, ICE_F_DSCP);
-		if (ice_is_e810t(&pf->hw))
+		if (ice_is_e810t(&pf->hw)) {
 			ice_set_feature_support(pf, ICE_F_SMA_CTRL);
+			if (ice_gnss_is_gps_present(&pf->hw))
+				ice_set_feature_support(pf, ICE_F_GNSS);
+		}
 		break;
 	default:
 		break;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index cff476f735ef..1e4c6adf4ee4 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -568,6 +568,9 @@ ice_prepare_for_reset(struct ice_pf *pf, enum ice_reset_req reset_type)
 	if (test_bit(ICE_FLAG_PTP_SUPPORTED, pf->flags))
 		ice_ptp_prepare_for_reset(pf);
 
+	if (ice_is_feature_supported(pf, ICE_F_GNSS))
+		ice_gnss_exit(pf);
+
 	if (hw->port_info)
 		ice_sched_clear_port(hw->port_info);
 
@@ -4700,6 +4703,9 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	if (test_bit(ICE_FLAG_PTP_SUPPORTED, pf->flags))
 		ice_ptp_init(pf);
 
+	if (ice_is_feature_supported(pf, ICE_F_GNSS))
+		ice_gnss_init(pf);
+
 	/* Note: Flow director init failure is non-fatal to load */
 	if (ice_init_fdir(pf))
 		dev_err(dev, "could not initialize flow director\n");
@@ -4875,6 +4881,8 @@ static void ice_remove(struct pci_dev *pdev)
 	ice_deinit_lag(pf);
 	if (test_bit(ICE_FLAG_PTP_SUPPORTED, pf->flags))
 		ice_ptp_release(pf);
+	if (ice_is_feature_supported(pf, ICE_F_GNSS))
+		ice_gnss_exit(pf);
 	if (!ice_is_safe_mode(pf))
 		ice_remove_arfs(pf);
 	ice_setup_mc_magic_wake(pf);
@@ -6918,6 +6926,9 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 	if (test_bit(ICE_FLAG_PTP_SUPPORTED, pf->flags))
 		ice_ptp_reset(pf);
 
+	if (ice_is_feature_supported(pf, ICE_F_GNSS))
+		ice_gnss_init(pf);
+
 	/* rebuild PF VSI */
 	err = ice_vsi_rebuild_by_type(pf, ICE_VSI_PF);
 	if (err) {
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
index ec8450f034e6..26f6462f9d0d 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
@@ -3250,6 +3250,37 @@ int ice_write_sma_ctrl_e810t(struct ice_hw *hw, u8 data)
 	return status;
 }
 
+/**
+ * ice_read_pca9575_reg_e810t
+ * @hw: pointer to the hw struct
+ * @offset: GPIO controller register offset
+ * @data: pointer to data to be read from the GPIO controller
+ *
+ * Read the register from the GPIO controller
+ */
+int ice_read_pca9575_reg_e810t(struct ice_hw *hw, u8 offset, u8 *data)
+{
+	struct ice_aqc_link_topo_addr link_topo;
+	__le16 addr;
+	u16 handle;
+	int err;
+
+	memset(&link_topo, 0, sizeof(link_topo));
+
+	err = ice_get_pca9575_handle(hw, &handle);
+	if (err)
+		return err;
+
+	link_topo.handle = cpu_to_le16(handle);
+	link_topo.topo_params.node_type_ctx =
+		(ICE_AQC_LINK_TOPO_NODE_CTX_PROVIDED <<
+		 ICE_AQC_LINK_TOPO_NODE_CTX_S);
+
+	addr = cpu_to_le16((u16)offset);
+
+	return ice_aq_read_i2c(hw, link_topo, 0, addr, 1, data, NULL);
+}
+
 /**
  * ice_is_pca9575_present
  * @hw: pointer to the hw struct
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
index 519e75462e67..1246e4ee4b5d 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
@@ -191,6 +191,7 @@ int ice_phy_exit_bypass_e822(struct ice_hw *hw, u8 port);
 int ice_ptp_init_phy_e810(struct ice_hw *hw);
 int ice_read_sma_ctrl_e810t(struct ice_hw *hw, u8 *data);
 int ice_write_sma_ctrl_e810t(struct ice_hw *hw, u8 data);
+int ice_read_pca9575_reg_e810t(struct ice_hw *hw, u8 offset, u8 *data);
 bool ice_is_pca9575_present(struct ice_hw *hw);
 
 #define PFTSYN_SEM_BYTES	4
@@ -443,4 +444,10 @@ bool ice_is_pca9575_present(struct ice_hw *hw);
 #define ICE_SMA_MAX_BIT_E810T	7
 #define ICE_PCA9575_P1_OFFSET	8
 
+/* E810T PCA9575 IO controller registers */
+#define ICE_PCA9575_P0_IN	0x0
+
+/* E810T PCA9575 IO controller pin control */
+#define ICE_E810T_P0_GNSS_PRSNT_N	BIT(4)
+
 #endif /* _ICE_PTP_HW_H_ */
-- 
2.31.1

