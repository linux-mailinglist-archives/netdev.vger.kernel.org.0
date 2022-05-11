Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC9CA522A54
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 05:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234988AbiEKDUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 23:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235565AbiEKDTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 23:19:47 -0400
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1756FA17
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:19:41 -0700 (PDT)
X-QQ-mid: bizesmtp75t1652239174tcsb76h9
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 11 May 2022 11:19:33 +0800 (CST)
X-QQ-SSF: 01400000000000F0O000B00A0000000
X-QQ-FEAT: AYaL7CbwjQ1aslr5EDyfQn4XoLVYomL28V/DSvFmP72qqy0PJMPBe6RYaY2/w
        RCvjSQwyrrRP901YF1N84/qEHM09TUQDuAIvcNbH0QQahnmJX+gBiCJ1ra1eyigFsYkqwJk
        odFBwBsyBw8JIMucw3glvJPspbhfO2tftfQCl5Gpdwo1twLbwYgq5VAMj3szJ7e+IfioZMy
        c8Spww+mrwx1SY92smeRmFLj9OohDJr2UaBIGzXrOZBAz/AkgpyMRbYWc+CJiwEcyaR/yl0
        GBQIO8Ftrce5wpgkjks+GCsyz4+OX/OdOyHdIyedp5PbbFFBg9ac1Nw62be0UN7/YKe+TeY
        JlHvu91USUiB3jc1FCHFa1/qduxA8gBoBALo/cVKHE9QMyo7eM=
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next 14/14] net: txgbe: Support sysfs file system
Date:   Wed, 11 May 2022 11:26:59 +0800
Message-Id: <20220511032659.641834-15-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220511032659.641834-1-jiawenwu@trustnetic.com>
References: <20220511032659.641834-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybgforeign:qybgforeign9
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for sysfs file system.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/Makefile   |   1 +
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  27 +++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c |  59 +++++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   1 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |   9 +
 .../net/ethernet/wangxun/txgbe/txgbe_sysfs.c  | 203 ++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |   1 +
 7 files changed, 301 insertions(+)
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_sysfs.c

diff --git a/drivers/net/ethernet/wangxun/txgbe/Makefile b/drivers/net/ethernet/wangxun/txgbe/Makefile
index c338a84abca8..e29c82cf3c00 100644
--- a/drivers/net/ethernet/wangxun/txgbe/Makefile
+++ b/drivers/net/ethernet/wangxun/txgbe/Makefile
@@ -11,4 +11,5 @@ txgbe-objs := txgbe_main.o txgbe_ethtool.o \
               txgbe_lib.o txgbe_ptp.o
 
 txgbe-$(CONFIG_DEBUG_FS) += txgbe_debugfs.o
+txgbe-${CONFIG_SYSFS} += txgbe_sysfs.o
 txgbe-$(CONFIG_TXGBE_PCI_RECOVER) += txgbe_pcierr.o
\ No newline at end of file
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index 78f4a56d6cff..b7aebff5a5ba 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -296,6 +296,25 @@ struct txgbe_q_vector {
 	struct txgbe_ring ring[0] ____cacheline_internodealigned_in_smp;
 };
 
+#ifdef CONFIG_HWMON
+#define TXGBE_HWMON_TYPE_TEMP           0
+#define TXGBE_HWMON_TYPE_ALARMTHRESH    1
+#define TXGBE_HWMON_TYPE_DALARMTHRESH   2
+
+struct hwmon_attr {
+	struct device_attribute dev_attr;
+	struct txgbe_hw *hw;
+	struct txgbe_thermal_diode_data *sensor;
+	char name[19];
+};
+
+struct hwmon_buff {
+	struct device *device;
+	struct hwmon_attr *hwmon_list;
+	unsigned int n_hwmon;
+};
+#endif /* CONFIG_HWMON */
+
 /* microsecond values for various ITR rates shifted by 2 to fit itr register
  * with the first 3 bits reserved 0
  */
@@ -511,6 +530,9 @@ struct txgbe_adapter {
 
 	__le16 vxlan_port;
 
+#ifdef CONFIG_HWMON
+	struct hwmon_buff txgbe_hwmon_buff;
+#endif
 	struct dentry *txgbe_dbg_adapter;
 
 	unsigned long fwd_bitmask; /* bitmask indicating in use pools */
@@ -610,6 +632,11 @@ void txgbe_write_eitr(struct txgbe_q_vector *q_vector);
 int txgbe_poll(struct napi_struct *napi, int budget);
 void txgbe_disable_rx_queue(struct txgbe_adapter *adapter,
 			    struct txgbe_ring *ring);
+
+#ifdef CONFIG_SYSFS
+void txgbe_sysfs_exit(struct txgbe_adapter *adapter);
+int txgbe_sysfs_init(struct txgbe_adapter *adapter);
+#endif
 #ifdef CONFIG_DEBUG_FS
 void txgbe_dbg_adapter_init(struct txgbe_adapter *adapter);
 void txgbe_dbg_adapter_exit(struct txgbe_adapter *adapter);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index 35279209c51d..1e5343c4ef91 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -2334,6 +2334,63 @@ void txgbe_set_rxpba(struct txgbe_hw *hw, int num_pb, u32 headroom,
 	}
 }
 
+/**
+ *  txgbe_get_thermal_sensor_data - Gathers thermal sensor data
+ *  @hw: pointer to hardware structure
+ *  @data: pointer to the thermal sensor data structure
+ *
+ * algorithm:
+ * T = (-4.8380E+01)N^0 + (3.1020E-01)N^1 + (-1.8201E-04)N^2 +
+		       (8.1542E-08)N^3 + (-1.6743E-11)N^4
+ * algorithm with 5% more deviation, easy for implementation
+ * T = (-50)N^0 + (0.31)N^1 + (-0.0002)N^2 + (0.0000001)N^3
+ *
+ *  Returns the thermal sensor data structure
+ **/
+s32 txgbe_get_thermal_sensor_data(struct txgbe_hw *hw)
+{
+	s64 tsv;
+	int i = 0;
+	struct txgbe_thermal_sensor_data *data = &hw->mac.thermal_sensor_data;
+
+	/* Only support thermal sensors attached to physical port 0 */
+	if (hw->bus.lan_id)
+		return TXGBE_NOT_IMPLEMENTED;
+
+	tsv = (s64)(rd32(hw, TXGBE_TS_ST) &
+		    TXGBE_TS_ST_DATA_OUT_MASK);
+
+	tsv = tsv < 1200 ? tsv : 1200;
+	tsv = -(48380 << 8) / 1000
+		+ tsv * (31020 << 8) / 100000
+		- tsv * tsv * (18201 << 8) / 100000000
+		+ tsv * tsv * tsv * (81542 << 8) / 1000000000000
+		- tsv * tsv * tsv * tsv * (16743 << 8) / 1000000000000000;
+	tsv >>= 8;
+
+	data->sensor.temp = (s16)tsv;
+
+	for (i = 0; i < 100 ; i++) {
+		tsv = (s64)rd32(hw, TXGBE_TS_ST);
+		if (tsv >> 16 == 0x1) {
+			tsv = tsv & TXGBE_TS_ST_DATA_OUT_MASK;
+			tsv = tsv < 1200 ? tsv : 1200;
+			tsv = -(48380 << 8) / 1000
+					+ tsv * (31020 << 8) / 100000
+					- tsv * tsv * (18201 << 8) / 100000000
+					+ tsv * tsv * tsv * (81542 << 8) / 1000000000000
+					- tsv * tsv * tsv * tsv * (16743 << 8) / 1000000000000000;
+			tsv >>= 8;
+
+			data->sensor.temp = (s16)tsv;
+			break;
+		}
+		usleep_range(1000, 2000);
+	}
+
+	return 0;
+}
+
 /**
  *  txgbe_init_thermal_sensor_thresh - Inits thermal sensor thresholds
  *  @hw: pointer to hardware structure
@@ -3074,6 +3131,8 @@ s32 txgbe_init_ops(struct txgbe_hw *hw)
 	/* Manageability interface */
 	mac->ops.set_fw_drv_ver = txgbe_set_fw_drv_ver;
 
+	mac->ops.get_thermal_sensor_data =
+					 txgbe_get_thermal_sensor_data;
 	mac->ops.init_thermal_sensor_thresh =
 				      txgbe_init_thermal_sensor_thresh;
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
index eb1e189fbaa5..fd7c2ffb1e4b 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -148,6 +148,7 @@ s32 txgbe_host_interface_command(struct txgbe_hw *hw, u32 *buffer,
 bool txgbe_mng_present(struct txgbe_hw *hw);
 bool txgbe_check_mng_access(struct txgbe_hw *hw);
 
+s32 txgbe_get_thermal_sensor_data(struct txgbe_hw *hw);
 s32 txgbe_init_thermal_sensor_thresh(struct txgbe_hw *hw);
 void txgbe_enable_rx(struct txgbe_hw *hw);
 void txgbe_disable_rx(struct txgbe_hw *hw);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 1dee2877d346..19e4186a47ed 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -6570,6 +6570,11 @@ static int txgbe_probe(struct pci_dev *pdev,
 	txgbe_info(probe, "WangXun(R) 10 Gigabit Network Connection\n");
 	cards_found++;
 
+#ifdef CONFIG_SYSFS
+	if (txgbe_sysfs_init(adapter))
+		txgbe_err(probe, "failed to allocate sysfs resources\n");
+#endif
+
 #ifdef CONFIG_DEBUG_FS
 	txgbe_dbg_adapter_init(adapter);
 #endif
@@ -6628,6 +6633,10 @@ static void txgbe_remove(struct pci_dev *pdev)
 	set_bit(__TXGBE_REMOVING, &adapter->state);
 	cancel_work_sync(&adapter->service_task);
 
+#ifdef CONFIG_SYSFS
+	txgbe_sysfs_exit(adapter);
+#endif
+
 	/* remove the added san mac */
 	txgbe_del_sanmac_netdev(netdev);
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_sysfs.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_sysfs.c
new file mode 100644
index 000000000000..93a885b5fcc0
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_sysfs.c
@@ -0,0 +1,203 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2015 - 2017 Beijing WangXun Technology Co., Ltd. */
+
+#include "txgbe.h"
+#include "txgbe_hw.h"
+#include "txgbe_type.h"
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/sysfs.h>
+#include <linux/kobject.h>
+#include <linux/device.h>
+#include <linux/netdevice.h>
+#include <linux/time.h>
+#ifdef CONFIG_HWMON
+#include <linux/hwmon.h>
+#endif
+
+#ifdef CONFIG_HWMON
+/* hwmon callback functions */
+static ssize_t txgbe_hwmon_show_temp(struct device __always_unused *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	struct hwmon_attr *txgbe_attr = container_of(attr, struct hwmon_attr,
+						     dev_attr);
+	unsigned int value;
+
+	/* reset the temp field */
+	TCALL(txgbe_attr->hw, mac.ops.get_thermal_sensor_data);
+
+	value = txgbe_attr->sensor->temp;
+
+	/* display millidegree */
+	value *= 1000;
+
+	return sprintf(buf, "%u\n", value);
+}
+
+static ssize_t txgbe_hwmon_show_alarmthresh(struct device __always_unused *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	struct hwmon_attr *txgbe_attr = container_of(attr, struct hwmon_attr,
+						     dev_attr);
+	unsigned int value = txgbe_attr->sensor->alarm_thresh;
+
+	/* display millidegree */
+	value *= 1000;
+
+	return sprintf(buf, "%u\n", value);
+}
+
+static ssize_t txgbe_hwmon_show_dalarmthresh(struct device __always_unused *dev,
+					     struct device_attribute *attr,
+					     char *buf)
+{
+	struct hwmon_attr *txgbe_attr = container_of(attr, struct hwmon_attr,
+						     dev_attr);
+	unsigned int value = txgbe_attr->sensor->dalarm_thresh;
+
+	/* display millidegree */
+	value *= 1000;
+
+	return sprintf(buf, "%u\n", value);
+}
+
+/**
+ * txgbe_add_hwmon_attr - Create hwmon attr table for a hwmon sysfs file.
+ * @adapter: pointer to the adapter structure
+ * @type: type of sensor data to display
+ *
+ * For each file we want in hwmon's sysfs interface we need a device_attribute
+ * This is included in our hwmon_attr struct that contains the references to
+ * the data structures we need to get the data to display.
+ */
+static int txgbe_add_hwmon_attr(struct txgbe_adapter *adapter, int type)
+{
+	int rc;
+	unsigned int n_attr;
+	struct hwmon_attr *txgbe_attr;
+
+	n_attr = adapter->txgbe_hwmon_buff.n_hwmon;
+	txgbe_attr = &adapter->txgbe_hwmon_buff.hwmon_list[n_attr];
+
+	switch (type) {
+	case TXGBE_HWMON_TYPE_TEMP:
+		txgbe_attr->dev_attr.show = txgbe_hwmon_show_temp;
+		snprintf(txgbe_attr->name, sizeof(txgbe_attr->name),
+			 "temp%u_input", 0);
+		break;
+	case TXGBE_HWMON_TYPE_ALARMTHRESH:
+		txgbe_attr->dev_attr.show = txgbe_hwmon_show_alarmthresh;
+		snprintf(txgbe_attr->name, sizeof(txgbe_attr->name),
+			 "temp%u_alarmthresh", 0);
+		break;
+	case TXGBE_HWMON_TYPE_DALARMTHRESH:
+		txgbe_attr->dev_attr.show = txgbe_hwmon_show_dalarmthresh;
+		snprintf(txgbe_attr->name, sizeof(txgbe_attr->name),
+			 "temp%u_dalarmthresh", 0);
+		break;
+	default:
+		rc = -EPERM;
+		return rc;
+	}
+
+	/* These always the same regardless of type */
+	txgbe_attr->sensor =
+		&adapter->hw.mac.thermal_sensor_data.sensor;
+	txgbe_attr->hw = &adapter->hw;
+	txgbe_attr->dev_attr.store = NULL;
+	txgbe_attr->dev_attr.attr.mode = 0x0444;
+	txgbe_attr->dev_attr.attr.name = txgbe_attr->name;
+
+	rc = device_create_file(pci_dev_to_dev(adapter->pdev),
+				&txgbe_attr->dev_attr);
+
+	if (rc == 0)
+		++adapter->txgbe_hwmon_buff.n_hwmon;
+
+	return rc;
+}
+#endif /* CONFIG_HWMON */
+
+static void txgbe_sysfs_del_adapter(struct txgbe_adapter __maybe_unused *adapter)
+{
+#ifdef CONFIG_HWMON
+	int i;
+
+	if (!adapter)
+		return;
+
+	for (i = 0; i < adapter->txgbe_hwmon_buff.n_hwmon; i++) {
+		device_remove_file(pci_dev_to_dev(adapter->pdev),
+				   &adapter->txgbe_hwmon_buff.hwmon_list[i].dev_attr);
+	}
+
+	kfree(adapter->txgbe_hwmon_buff.hwmon_list);
+
+	if (adapter->txgbe_hwmon_buff.device)
+		hwmon_device_unregister(adapter->txgbe_hwmon_buff.device);
+#endif /* CONFIG_HWMON */
+}
+
+/* called from txgbe_main.c */
+void txgbe_sysfs_exit(struct txgbe_adapter *adapter)
+{
+	txgbe_sysfs_del_adapter(adapter);
+}
+
+/* called from txgbe_main.c */
+int txgbe_sysfs_init(struct txgbe_adapter *adapter)
+{
+	int rc = 0;
+#ifdef CONFIG_HWMON
+	struct hwmon_buff *txgbe_hwmon = &adapter->txgbe_hwmon_buff;
+	int n_attrs;
+
+#endif /* CONFIG_HWMON */
+	if (!adapter)
+		goto err;
+
+#ifdef CONFIG_HWMON
+
+	/* Don't create thermal hwmon interface if no sensors present */
+	if (TCALL(&adapter->hw, mac.ops.init_thermal_sensor_thresh))
+		goto no_thermal;
+
+	/* Allocation space for max attributs
+	 * max num sensors * values (temp, alamthresh, dalarmthresh)
+	 */
+	n_attrs = 3;
+	txgbe_hwmon->hwmon_list = kcalloc(n_attrs, sizeof(struct hwmon_attr),
+					  GFP_KERNEL);
+	if (!txgbe_hwmon->hwmon_list) {
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	txgbe_hwmon->device =
+			hwmon_device_register(pci_dev_to_dev(adapter->pdev));
+	if (IS_ERR(txgbe_hwmon->device)) {
+		rc = PTR_ERR(txgbe_hwmon->device);
+		goto err;
+	}
+
+	/* Bail if any hwmon attr struct fails to initialize */
+	rc = txgbe_add_hwmon_attr(adapter, TXGBE_HWMON_TYPE_TEMP);
+	rc |= txgbe_add_hwmon_attr(adapter, TXGBE_HWMON_TYPE_ALARMTHRESH);
+	rc |= txgbe_add_hwmon_attr(adapter, TXGBE_HWMON_TYPE_DALARMTHRESH);
+	if (rc)
+		goto err;
+
+no_thermal:
+#endif /* CONFIG_HWMON */
+	goto exit;
+
+err:
+	txgbe_sysfs_del_adapter(adapter);
+exit:
+	return rc;
+}
+
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 97abd60eabb1..11e9e2b68fdd 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -2552,6 +2552,7 @@ struct txgbe_mac_operations {
 	/* Manageability interface */
 	s32 (*set_fw_drv_ver)(struct txgbe_hw *hw, u8 maj, u8 min,
 			      u8 build, u8 ver);
+	s32 (*get_thermal_sensor_data)(struct txgbe_hw *hw);
 	s32 (*init_thermal_sensor_thresh)(struct txgbe_hw *hw);
 	void (*disable_rx)(struct txgbe_hw *hw);
 	void (*enable_rx)(struct txgbe_hw *hw);
-- 
2.27.0



