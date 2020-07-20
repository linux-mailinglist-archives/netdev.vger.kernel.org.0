Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869B5226E5A
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730829AbgGTSdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:33:25 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48462 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730570AbgGTSdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:33:24 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KIFx1s021903;
        Mon, 20 Jul 2020 11:33:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=R/OCgPGFdHDNTiDzB26f+ySGDazzmXgcnlL2nQ314sA=;
 b=tx7Gi2lEunASD9D4bmgE0YfaSmmEmaAux/j+aJUSF3k3Gx8MCTfI23ikFxcM29uOMmZK
 J4Uz3eRc2b4PtZcxkCXUQPJfLiSt9CQGC5vpCI5CgacnBHB9yEnT3WMf4MnS+o2QmWKe
 hxCn1JHHembqXXMIbZLlafwHUC7KEhhP9XiHVWopgkvPTurGfA0L28Y+Flqhoh6lWFE6
 4d1oCAWpHWDFk0IQBrasTqQEBzybNMb9s/Jut9Nu0BHAIVsoSpoM7lHOeSedFbeqQoL8
 Qd818N3mYYxCtyN7X5yj+B4v24k0Xc/pm0vi1zx1PmRZz1J2Po7uXg/TWhxnr68X2JEP qg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkfba9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:33:20 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:33:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 11:33:19 -0700
Received: from NN-LT0044.marvell.com (NN-LT0044.marvell.com [10.193.54.8])
        by maili.marvell.com (Postfix) with ESMTP id B68653F7041;
        Mon, 20 Jul 2020 11:33:17 -0700 (PDT)
From:   Mark Starovoytov <mstarovoitov@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>, <netdev@vger.kernel.org>,
        "Mark Starovoytov" <mstarovoitov@marvell.com>
Subject: [PATCH v3 net-next 13/13] net: atlantic: add hwmon getter for MAC temperature
Date:   Mon, 20 Jul 2020 21:32:44 +0300
Message-ID: <20200720183244.10029-14-mstarovoitov@marvell.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20200720183244.10029-1-mstarovoitov@marvell.com>
References: <20200720183244.10029-1-mstarovoitov@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the possibility to obtain MAC temperature via hwmon.
On A1 there are two separate temperature sensors.
On A2 there's only one temperature sensor, which is used for reporting
both MAC and PHY temperature.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../ethernet/aquantia/atlantic/aq_drvinfo.c   | 62 ++++++++++++++-----
 .../ethernet/aquantia/atlantic/aq_drvinfo.h   | 10 +--
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  4 ++
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 44 +++++++++++++
 .../aquantia/atlantic/hw_atl/hw_atl_llh.c     | 44 +++++++++++++
 .../aquantia/atlantic/hw_atl/hw_atl_llh.h     | 18 ++++++
 .../atlantic/hw_atl/hw_atl_llh_internal.h     | 30 +++++++++
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   |  1 +
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       |  3 +-
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       | 21 +++++++
 10 files changed, 215 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_drvinfo.c b/drivers/net/ethernet/aquantia/atlantic/aq_drvinfo.c
index 6da65099047d..d3526cd38f3d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_drvinfo.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_drvinfo.c
@@ -1,5 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Copyright (C) 2014-2019 aQuantia Corporation. */
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
+ */
 
 /* File aq_drvinfo.c: Definition of common code for firmware info in sys.*/
 
@@ -12,32 +16,51 @@
 #include <linux/uaccess.h>
 
 #include "aq_drvinfo.h"
+#include "aq_nic.h"
 
 #if IS_REACHABLE(CONFIG_HWMON)
+static const char * const atl_temp_label[] = {
+	"PHY Temperature",
+	"MAC Temperature",
+};
+
 static int aq_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
 			 u32 attr, int channel, long *value)
 {
 	struct aq_nic_s *aq_nic = dev_get_drvdata(dev);
+	int err = 0;
 	int temp;
-	int err;
 
 	if (!aq_nic)
 		return -EIO;
 
-	if (type != hwmon_temp)
+	if (type != hwmon_temp || attr != hwmon_temp_input)
 		return -EOPNOTSUPP;
 
-	if (!aq_nic->aq_fw_ops->get_phy_temp)
-		return -EOPNOTSUPP;
+	switch (channel) {
+	case 0:
+		if (!aq_nic->aq_fw_ops->get_phy_temp)
+			return -EOPNOTSUPP;
 
-	switch (attr) {
-	case hwmon_temp_input:
 		err = aq_nic->aq_fw_ops->get_phy_temp(aq_nic->aq_hw, &temp);
 		*value = temp;
-		return err;
+		break;
+	case 1:
+		if (!aq_nic->aq_fw_ops->get_mac_temp &&
+		    !aq_nic->aq_hw_ops->hw_get_mac_temp)
+			return -EOPNOTSUPP;
+
+		if (aq_nic->aq_fw_ops->get_mac_temp)
+			err = aq_nic->aq_fw_ops->get_mac_temp(aq_nic->aq_hw, &temp);
+		else
+			err = aq_nic->aq_hw_ops->hw_get_mac_temp(aq_nic->aq_hw, &temp);
+		*value = temp;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
+
+	return err;
 }
 
 static int aq_hwmon_read_string(struct device *dev,
@@ -49,28 +72,32 @@ static int aq_hwmon_read_string(struct device *dev,
 	if (!aq_nic)
 		return -EIO;
 
-	if (type != hwmon_temp)
+	if (type != hwmon_temp || attr != hwmon_temp_label)
 		return -EOPNOTSUPP;
 
-	if (!aq_nic->aq_fw_ops->get_phy_temp)
+	if (channel < ARRAY_SIZE(atl_temp_label))
+		*str = atl_temp_label[channel];
+	else
 		return -EOPNOTSUPP;
 
-	switch (attr) {
-	case hwmon_temp_label:
-		*str = "PHY Temperature";
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
+	return 0;
 }
 
 static umode_t aq_hwmon_is_visible(const void *data,
 				   enum hwmon_sensor_types type,
 				   u32 attr, int channel)
 {
+	const struct aq_nic_s *nic = data;
+
 	if (type != hwmon_temp)
 		return 0;
 
+	if (channel == 0 && !nic->aq_fw_ops->get_phy_temp)
+		return 0;
+	else if (channel == 1 && !nic->aq_fw_ops->get_mac_temp &&
+		 !nic->aq_hw_ops->hw_get_mac_temp)
+		return 0;
+
 	switch (attr) {
 	case hwmon_temp_input:
 	case hwmon_temp_label:
@@ -87,6 +114,7 @@ static const struct hwmon_ops aq_hwmon_ops = {
 };
 
 static u32 aq_hwmon_temp_config[] = {
+	HWMON_T_INPUT | HWMON_T_LABEL,
 	HWMON_T_INPUT | HWMON_T_LABEL,
 	0,
 };
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_drvinfo.h b/drivers/net/ethernet/aquantia/atlantic/aq_drvinfo.h
index 23a0487893a7..59113a20622a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_drvinfo.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_drvinfo.h
@@ -1,14 +1,16 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* Copyright (C) 2014-2017 aQuantia Corporation. */
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
+ */
 
 /* File aq_drvinfo.h: Declaration of common code for firmware info in sys.*/
 
 #ifndef AQ_DRVINFO_H
 #define AQ_DRVINFO_H
 
-#include "aq_nic.h"
-#include "aq_hw.h"
-#include "hw_atl/hw_atl_utils.h"
+struct net_device;
 
 int aq_drvinfo_init(struct net_device *ndev);
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index 96d59ee3eb70..95ee1336ac79 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -333,6 +333,8 @@ struct aq_hw_ops {
 	int (*hw_set_fc)(struct aq_hw_s *self, u32 fc, u32 tc);
 
 	int (*hw_set_loopback)(struct aq_hw_s *self, u32 mode, bool enable);
+
+	int (*hw_get_mac_temp)(struct aq_hw_s *self, u32 *temp);
 };
 
 struct aq_fw_ops {
@@ -355,6 +357,8 @@ struct aq_fw_ops {
 
 	int (*update_stats)(struct aq_hw_s *self);
 
+	int (*get_mac_temp)(struct aq_hw_s *self, int *temp);
+
 	int (*get_phy_temp)(struct aq_hw_s *self, int *temp);
 
 	u32 (*get_flow_control)(struct aq_hw_s *self, u32 *fcmode);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index ee74cad4a168..34626eef2909 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -1581,6 +1581,48 @@ int hw_atl_b0_set_loopback(struct aq_hw_s *self, u32 mode, bool enable)
 	return 0;
 }
 
+static u32 hw_atl_b0_ts_ready_and_latch_high_get(struct aq_hw_s *self)
+{
+	if (hw_atl_ts_ready_get(self) && hw_atl_ts_ready_latch_high_get(self))
+		return 1;
+
+	return 0;
+}
+
+static int hw_atl_b0_get_mac_temp(struct aq_hw_s *self, u32 *temp)
+{
+	bool ts_disabled;
+	int err;
+	u32 val;
+	u32 ts;
+
+	ts_disabled = (hw_atl_ts_power_down_get(self) == 1U);
+
+	if (ts_disabled) {
+		// Set AFE Temperature Sensor to on (off by default)
+		hw_atl_ts_power_down_set(self, 0U);
+
+		// Reset internal capacitors, biasing, and counters
+		hw_atl_ts_reset_set(self, 1);
+		hw_atl_ts_reset_set(self, 0);
+	}
+
+	err = readx_poll_timeout_atomic(hw_atl_b0_ts_ready_and_latch_high_get,
+					self, val, val == 1, 10000U, 500000U);
+	if (err)
+		return err;
+
+	ts = hw_atl_ts_data_get(self);
+	*temp = ts * ts * 16 / 100000 + 60 * ts - 83410;
+
+	if (ts_disabled) {
+		// Set AFE Temperature Sensor back to off
+		hw_atl_ts_power_down_set(self, 1U);
+	}
+
+	return 0;
+}
+
 const struct aq_hw_ops hw_atl_ops_b0 = {
 	.hw_soft_reset        = hw_atl_utils_soft_reset,
 	.hw_prepare           = hw_atl_utils_initfw,
@@ -1637,4 +1679,6 @@ const struct aq_hw_ops hw_atl_ops_b0 = {
 	.hw_set_offload          = hw_atl_b0_hw_offload_set,
 	.hw_set_loopback         = hw_atl_b0_set_loopback,
 	.hw_set_fc               = hw_atl_b0_set_fc,
+
+	.hw_get_mac_temp         = hw_atl_b0_get_mac_temp,
 };
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
index 9c3debae425f..7b67bdd8a258 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
@@ -13,6 +13,50 @@
 #include "hw_atl_llh_internal.h"
 #include "../aq_hw_utils.h"
 
+void hw_atl_ts_reset_set(struct aq_hw_s *aq_hw, u32 val)
+{
+	aq_hw_write_reg_bit(aq_hw, HW_ATL_TS_RESET_ADR,
+			    HW_ATL_TS_RESET_MSK,
+			    HW_ATL_TS_RESET_SHIFT,
+			    val);
+}
+
+void hw_atl_ts_power_down_set(struct aq_hw_s *aq_hw, u32 val)
+{
+	aq_hw_write_reg_bit(aq_hw, HW_ATL_TS_POWER_DOWN_ADR,
+			    HW_ATL_TS_POWER_DOWN_MSK,
+			    HW_ATL_TS_POWER_DOWN_SHIFT,
+			    val);
+}
+
+u32 hw_atl_ts_power_down_get(struct aq_hw_s *aq_hw)
+{
+	return aq_hw_read_reg_bit(aq_hw, HW_ATL_TS_POWER_DOWN_ADR,
+				  HW_ATL_TS_POWER_DOWN_MSK,
+				  HW_ATL_TS_POWER_DOWN_SHIFT);
+}
+
+u32 hw_atl_ts_ready_get(struct aq_hw_s *aq_hw)
+{
+	return aq_hw_read_reg_bit(aq_hw, HW_ATL_TS_READY_ADR,
+				  HW_ATL_TS_READY_MSK,
+				  HW_ATL_TS_READY_SHIFT);
+}
+
+u32 hw_atl_ts_ready_latch_high_get(struct aq_hw_s *aq_hw)
+{
+	return aq_hw_read_reg_bit(aq_hw, HW_ATL_TS_READY_LATCH_HIGH_ADR,
+				  HW_ATL_TS_READY_LATCH_HIGH_MSK,
+				  HW_ATL_TS_READY_LATCH_HIGH_SHIFT);
+}
+
+u32 hw_atl_ts_data_get(struct aq_hw_s *aq_hw)
+{
+	return aq_hw_read_reg_bit(aq_hw, HW_ATL_TS_DATA_OUT_ADR,
+				  HW_ATL_TS_DATA_OUT_MSK,
+				  HW_ATL_TS_DATA_OUT_SHIFT);
+}
+
 /* global */
 void hw_atl_reg_glb_cpu_sem_set(struct aq_hw_s *aq_hw, u32 glb_cpu_sem,
 				u32 semaphore)
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
index f0954711df24..58f5ee0a6214 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
@@ -16,6 +16,24 @@
 
 struct aq_hw_s;
 
+/* set temperature sense reset */
+void hw_atl_ts_reset_set(struct aq_hw_s *aq_hw, u32 val);
+
+/* set temperature sense power down */
+void hw_atl_ts_power_down_set(struct aq_hw_s *aq_hw, u32 val);
+
+/* get temperature sense power down */
+u32 hw_atl_ts_power_down_get(struct aq_hw_s *aq_hw);
+
+/* get temperature sense ready */
+u32 hw_atl_ts_ready_get(struct aq_hw_s *aq_hw);
+
+/* get temperature sense ready latch high */
+u32 hw_atl_ts_ready_latch_high_get(struct aq_hw_s *aq_hw);
+
+/* get temperature sense data */
+u32 hw_atl_ts_data_get(struct aq_hw_s *aq_hw);
+
 /* global */
 
 /* set global microprocessor semaphore */
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
index ee11cb88325e..4a6467031b9e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
@@ -12,6 +12,36 @@
 #ifndef HW_ATL_LLH_INTERNAL_H
 #define HW_ATL_LLH_INTERNAL_H
 
+/* COM Temperature Sense Reset Bitfield Definitions */
+#define HW_ATL_TS_RESET_ADR 0x00003100
+#define HW_ATL_TS_RESET_MSK 0x00000004
+#define HW_ATL_TS_RESET_SHIFT 2
+#define HW_ATL_TS_RESET_WIDTH 1
+
+/* COM Temperature Sense Power Down Bitfield Definitions */
+#define HW_ATL_TS_POWER_DOWN_ADR 0x00003100
+#define HW_ATL_TS_POWER_DOWN_MSK 0x00000001
+#define HW_ATL_TS_POWER_DOWN_SHIFT 0
+#define HW_ATL_TS_POWER_DOWN_WIDTH 1
+
+/* COM Temperature Sense Ready Bitfield Definitions */
+#define HW_ATL_TS_READY_ADR 0x00003120
+#define HW_ATL_TS_READY_MSK 0x80000000
+#define HW_ATL_TS_READY_SHIFT 31
+#define HW_ATL_TS_READY_WIDTH 1
+
+/*  COM Temperature Sense Ready Latch High Bitfield Definitions */
+#define HW_ATL_TS_READY_LATCH_HIGH_ADR 0x00003120
+#define HW_ATL_TS_READY_LATCH_HIGH_MSK 0x40000000
+#define HW_ATL_TS_READY_LATCH_HIGH_SHIFT 30
+#define HW_ATL_TS_READY_LATCH_HIGH_WIDTH 1
+
+/* COM Temperature Sense Data Out [B:0] Bitfield Definitions */
+#define HW_ATL_TS_DATA_OUT_ADR 0x00003120
+#define HW_ATL_TS_DATA_OUT_MSK 0x00000FFF
+#define HW_ATL_TS_DATA_OUT_SHIFT 0
+#define HW_ATL_TS_DATA_OUT_WIDTH 12
+
 /* global microprocessor semaphore  definitions
  * base address: 0x000003a0
  * parameter: semaphore {s} | stride size 0x4 | range [0, 15]
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index cacab3352cb8..404cbf60d3f2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -1066,6 +1066,7 @@ const struct aq_fw_ops aq_fw_1x_ops = {
 	.set_state = hw_atl_utils_mpi_set_state,
 	.update_link_status = hw_atl_utils_mpi_get_link_status,
 	.update_stats = hw_atl_utils_update_stats,
+	.get_mac_temp = NULL,
 	.get_phy_temp = NULL,
 	.set_power = aq_fw1x_set_power,
 	.set_eee_rate = NULL,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
index 013676cd38e4..93c06dfa6c55 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
@@ -353,7 +353,7 @@ static int aq_fw2x_get_phy_temp(struct aq_hw_s *self, int *temp)
 	/* Convert PHY temperature from 1/256 degree Celsius
 	 * to 1/1000 degree Celsius.
 	 */
-	*temp = (temp_res & 0xFFFF) * 1000 / 256;
+	*temp = (int16_t)(temp_res & 0xFFFF) * 1000 / 256;
 
 	return 0;
 }
@@ -681,6 +681,7 @@ const struct aq_fw_ops aq_fw_2x_ops = {
 	.set_state          = aq_fw2x_set_state,
 	.update_link_status = aq_fw2x_update_link_status,
 	.update_stats       = aq_fw2x_update_stats,
+	.get_mac_temp       = NULL,
 	.get_phy_temp       = aq_fw2x_get_phy_temp,
 	.set_power          = aq_fw2x_set_power,
 	.set_eee_rate       = aq_fw2x_set_eee_rate,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
index a8ce9a2c1c51..85628acbcc1d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
@@ -379,6 +379,25 @@ static int aq_a2_fw_update_stats(struct aq_hw_s *self)
 	return 0;
 }
 
+static int aq_a2_fw_get_phy_temp(struct aq_hw_s *self, int *temp)
+{
+	struct phy_health_monitor_s phy_health_monitor;
+
+	hw_atl2_shared_buffer_read_safe(self, phy_health_monitor,
+					&phy_health_monitor);
+
+	*temp = (int8_t)phy_health_monitor.phy_temperature * 1000;
+	return 0;
+}
+
+static int aq_a2_fw_get_mac_temp(struct aq_hw_s *self, int *temp)
+{
+	/* There's only one temperature sensor on A2, use it for
+	 * both MAC and PHY.
+	 */
+	return aq_a2_fw_get_phy_temp(self, temp);
+}
+
 static int aq_a2_fw_set_eee_rate(struct aq_hw_s *self, u32 speed)
 {
 	struct link_options_s link_options;
@@ -510,6 +529,8 @@ const struct aq_fw_ops aq_a2_fw_ops = {
 	.set_state          = aq_a2_fw_set_state,
 	.update_link_status = aq_a2_fw_update_link_status,
 	.update_stats       = aq_a2_fw_update_stats,
+	.get_mac_temp       = aq_a2_fw_get_mac_temp,
+	.get_phy_temp       = aq_a2_fw_get_phy_temp,
 	.set_eee_rate       = aq_a2_fw_set_eee_rate,
 	.get_eee_rate       = aq_a2_fw_get_eee_rate,
 	.set_flow_control   = aq_a2_fw_set_flow_control,
-- 
2.25.1

