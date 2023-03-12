Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9891B6B62F2
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 03:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjCLC3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 21:29:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjCLC25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 21:28:57 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB78E3401A;
        Sat, 11 Mar 2023 18:28:50 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32C1lZsF021512;
        Sat, 11 Mar 2023 18:28:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=a2Zap7RqAaZ766bVqHe9CUQuTykVExZ83z+3xAgTqIo=;
 b=k8xIgg3ymGepxHoK3Ts4zc3i2LLr59nxZTbPKcKMFQHfBSKpy/Ivap2Cy5lQ6hhR4yBM
 GsrV7hV5tgWClgVMsu9VvVe89FIjZyQNk8sGjY6QL3BAMuH+Vl+1HvME6AVUudb0IAM6
 yGoRICx0hr/RXpMPTtFJo92Z1w675uVC86miyxEvFbCjQK1kf9d9BQ7orj6ByZoPZeFS
 VzQup8cSdlaZaKn5xX5F/fm+58Jrngn3EiMPIGLqW/OJ6egmwoq4tnkT3JfykuOcuykW
 RS2sJtWYB7WkpE4A3GZdtMHMn/ogdzBJS3d2/yEd7oWtfY/bh+SJBjDl198w7UlBbTBG 1A== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3p8qn58ujs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 11 Mar 2023 18:28:30 -0800
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Sat, 11 Mar 2023 18:28:29 -0800
Received: from devvm1736.cln0.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server id
 15.1.2507.17; Sat, 11 Mar 2023 18:28:27 -0800
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        "Arkadiusz Kubalewski" <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Vadim Fedorenko <vadim.fedorenko@linux.dev>, <poros@redhat.com>,
        <mschmidt@redhat.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-clk@vger.kernel.org>,
        "Milena Olech" <milena.olech@intel.com>,
        Michal Michalik <michal.michalik@intel.com>
Subject: [PATCH RFC v6 5/6] ice: implement dpll interface to control cgu
Date:   Sat, 11 Mar 2023 18:28:06 -0800
Message-ID: <20230312022807.278528-6-vadfed@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230312022807.278528-1-vadfed@meta.com>
References: <20230312022807.278528-1-vadfed@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c0a8:1b::d]
X-Proofpoint-GUID: 03h37UsQFpPjpPm2HM9pMPkLlOEMbXNR
X-Proofpoint-ORIG-GUID: 03h37UsQFpPjpPm2HM9pMPkLlOEMbXNR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-11_04,2023-03-10_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

Control over clock generation unit is required for further development
of Synchronous Ethernet feature. Interface provides ability to obtain
current state of a dpll, its sources and outputs which are pins, and
allows their configuration.

Co-developed-by: Milena Olech <milena.olech@intel.com>
Signed-off-by: Milena Olech <milena.olech@intel.com>
Co-developed-by: Michal Michalik <michal.michalik@intel.com>
Signed-off-by: Michal Michalik <michal.michalik@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
---
 drivers/net/ethernet/intel/Kconfig        |    1 +
 drivers/net/ethernet/intel/ice/Makefile   |    3 +-
 drivers/net/ethernet/intel/ice/ice.h      |    4 +
 drivers/net/ethernet/intel/ice/ice_dpll.c | 1845 +++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_dpll.h |   96 ++
 drivers/net/ethernet/intel/ice/ice_main.c |    7 +
 6 files changed, 1955 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_dpll.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_dpll.h

diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index c18c3b373846..d6ea4edd552a 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -301,6 +301,7 @@ config ICE
 	select DIMLIB
 	select NET_DEVLINK
 	select PLDMFW
+	select DPLL
 	help
 	  This driver supports Intel(R) Ethernet Connection E800 Series of
 	  devices.  For more information on how to identify your adapter, go
diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 5d89392f969b..6c198cd92d49 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -33,7 +33,8 @@ ice-y := ice_main.o	\
 	 ice_lag.o	\
 	 ice_ethtool.o  \
 	 ice_repr.o	\
-	 ice_tc_lib.o
+	 ice_tc_lib.o	\
+	 ice_dpll.o
 ice-$(CONFIG_PCI_IOV) +=	\
 	ice_sriov.o		\
 	ice_virtchnl.o		\
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 116eb64db969..5cc2a99f00b7 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -75,6 +75,7 @@
 #include "ice_lag.h"
 #include "ice_vsi_vlan_ops.h"
 #include "ice_gnss.h"
+#include "ice_dpll.h"
 
 #define ICE_BAR0		0
 #define ICE_REQ_DESC_MULTIPLE	32
@@ -202,6 +203,7 @@
 enum ice_feature {
 	ICE_F_DSCP,
 	ICE_F_PTP_EXTTS,
+	ICE_F_PHY_RCLK,
 	ICE_F_SMA_CTRL,
 	ICE_F_CGU,
 	ICE_F_GNSS,
@@ -512,6 +514,7 @@ enum ice_pf_flags {
 	ICE_FLAG_PLUG_AUX_DEV,
 	ICE_FLAG_MTU_CHANGED,
 	ICE_FLAG_GNSS,			/* GNSS successfully initialized */
+	ICE_FLAG_DPLL,			/* SyncE/PTP dplls initialized */
 	ICE_PF_FLAGS_NBITS		/* must be last */
 };
 
@@ -635,6 +638,7 @@ struct ice_pf {
 #define ICE_VF_AGG_NODE_ID_START	65
 #define ICE_MAX_VF_AGG_NODES		32
 	struct ice_agg_node vf_agg_node[ICE_MAX_VF_AGG_NODES];
+	struct ice_dplls dplls;
 };
 
 struct ice_netdev_priv {
diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.c b/drivers/net/ethernet/intel/ice/ice_dpll.c
new file mode 100644
index 000000000000..a97ccf5840d5
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -0,0 +1,1845 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2022, Intel Corporation. */
+
+#include "ice.h"
+#include "ice_lib.h"
+#include "ice_trace.h"
+#include <linux/dpll.h>
+#include <uapi/linux/dpll.h>
+
+#define CGU_STATE_ACQ_ERR_THRESHOLD	50
+#define ICE_DPLL_LOCK_TRIES		1000
+
+/**
+ * dpll_lock_status - map ice cgu states into dpll's subsystem lock status
+ */
+static const enum dpll_lock_status
+ice_dpll_status[__DPLL_LOCK_STATUS_MAX] = {
+	[ICE_CGU_STATE_INVALID] = DPLL_LOCK_STATUS_UNSPEC,
+	[ICE_CGU_STATE_FREERUN] = DPLL_LOCK_STATUS_UNLOCKED,
+	[ICE_CGU_STATE_LOCKED] = DPLL_LOCK_STATUS_CALIBRATING,
+	[ICE_CGU_STATE_LOCKED_HO_ACQ] = DPLL_LOCK_STATUS_LOCKED,
+	[ICE_CGU_STATE_HOLDOVER] = DPLL_LOCK_STATUS_HOLDOVER,
+};
+
+/**
+ * ice_dpll_pin_type - enumerate ice pin types
+ */
+enum ice_dpll_pin_type {
+	ICE_DPLL_PIN_INVALID = 0,
+	ICE_DPLL_PIN_TYPE_SOURCE,
+	ICE_DPLL_PIN_TYPE_OUTPUT,
+	ICE_DPLL_PIN_TYPE_RCLK_SOURCE,
+};
+
+/**
+ * pin_type_name - string names of ice pin types
+ */
+static const char * const pin_type_name[] = {
+	[ICE_DPLL_PIN_TYPE_SOURCE] = "source",
+	[ICE_DPLL_PIN_TYPE_OUTPUT] = "output",
+	[ICE_DPLL_PIN_TYPE_RCLK_SOURCE] = "rclk-source",
+};
+
+/**
+ * ice_find_pin_idx - find ice_dpll_pin index on a pf
+ * @pf: private board structure
+ * @pin: kernel's dpll_pin pointer to be searched for
+ * @pin_type: type of pins to be searched for
+ *
+ * Find and return internal ice pin index of a searched dpll subsystem
+ * pin pointer.
+ *
+ * Return:
+ * * valid index for a given pin & pin type found on pf internal dpll struct
+ * * PIN_IDX_INVALID - if pin was not found.
+ */
+static u32
+ice_find_pin_idx(struct ice_pf *pf, const struct dpll_pin *pin,
+		 enum ice_dpll_pin_type pin_type)
+
+{
+	struct ice_dpll_pin *pins;
+	int pin_num, i;
+
+	if (!pin || !pf)
+		return PIN_IDX_INVALID;
+
+	if (pin_type == ICE_DPLL_PIN_TYPE_SOURCE) {
+		pins = pf->dplls.inputs;
+		pin_num = pf->dplls.num_inputs;
+	} else if (pin_type == ICE_DPLL_PIN_TYPE_OUTPUT) {
+		pins = pf->dplls.outputs;
+		pin_num = pf->dplls.num_outputs;
+	} else {
+		return PIN_IDX_INVALID;
+	}
+
+	for (i = 0; i < pin_num; i++)
+		if (pin == pins[i].pin)
+			return i;
+
+	return PIN_IDX_INVALID;
+}
+
+/**
+ * ice_dpll_cb_lock - lock dplls mutex in callback context
+ * @pf: private board structure
+ *
+ * Lock the mutex from the callback operations invoked by dpll subsystem.
+ * Prevent dead lock caused by `rmmod ice` when dpll callbacks are under stress
+ * tests.
+ *
+ * Return:
+ * 0 - if lock acquired
+ * negative - lock not acquired or dpll was deinitialized
+ */
+static int ice_dpll_cb_lock(struct ice_pf *pf)
+{
+	int i;
+
+	for (i = 0; i < ICE_DPLL_LOCK_TRIES; i++) {
+		if (mutex_trylock(&pf->dplls.lock))
+			return 0;
+		usleep_range(100, 150);
+		if (!test_bit(ICE_FLAG_DPLL, pf->flags))
+			return -EFAULT;
+	}
+
+	return -EBUSY;
+}
+
+/**
+ * ice_dpll_cb_unlock - unlock dplls mutex in callback context
+ * @pf: private board structure
+ *
+ * Unlock the mutex from the callback operations invoked by dpll subsystem.
+ */
+static void ice_dpll_cb_unlock(struct ice_pf *pf)
+{
+	mutex_unlock(&pf->dplls.lock);
+}
+
+/**
+ * ice_find_pin - find ice_dpll_pin on a pf
+ * @pf: private board structure
+ * @pin: kernel's dpll_pin pointer to be searched for
+ * @pin_type: type of pins to be searched for
+ *
+ * Find and return internal ice pin info pointer holding data of given dpll
+ * subsystem pin pointer.
+ *
+ * Return:
+ * * valid 'struct ice_dpll_pin'-type pointer - if given 'pin' pointer was
+ * found in pf internal pin data.
+ * * NULL - if pin was not found.
+ */
+static struct ice_dpll_pin
+*ice_find_pin(struct ice_pf *pf, const struct dpll_pin *pin,
+	      enum ice_dpll_pin_type pin_type)
+
+{
+	struct ice_dpll_pin *pins;
+	int pin_num, i;
+
+	if (!pin || !pf)
+		return NULL;
+
+	if (pin_type == ICE_DPLL_PIN_TYPE_SOURCE) {
+		pins = pf->dplls.inputs;
+		pin_num = pf->dplls.num_inputs;
+	} else if (pin_type == ICE_DPLL_PIN_TYPE_OUTPUT) {
+		pins = pf->dplls.outputs;
+		pin_num = pf->dplls.num_outputs;
+	} else if (pin_type == ICE_DPLL_PIN_TYPE_RCLK_SOURCE) {
+		if (pin == pf->dplls.rclk.pin)
+			return &pf->dplls.rclk;
+	} else {
+		return NULL;
+	}
+
+	for (i = 0; i < pin_num; i++)
+		if (pin == pins[i].pin)
+			return &pins[i];
+
+	return NULL;
+}
+
+/**
+ * ice_dpll_pin_freq_set - set pin's frequency
+ * @pf: Board private structure
+ * @pin: pointer to a pin
+ * @pin_type: type of pin being configured
+ * @freq: frequency to be set
+ *
+ * Set requested frequency on a pin.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - error on AQ or wrong pin type given
+ */
+static int
+ice_dpll_pin_freq_set(struct ice_pf *pf, struct ice_dpll_pin *pin,
+		      const enum ice_dpll_pin_type pin_type, const u32 freq)
+{
+	u8 flags;
+	int ret;
+
+	if (pin_type == ICE_DPLL_PIN_TYPE_SOURCE) {
+		flags = ICE_AQC_SET_CGU_IN_CFG_FLG1_UPDATE_FREQ;
+		ret = ice_aq_set_input_pin_cfg(&pf->hw, pin->idx, flags,
+					       pin->flags[0], freq, 0);
+	} else if (pin_type == ICE_DPLL_PIN_TYPE_OUTPUT) {
+		flags = pin->flags[0] | ICE_AQC_SET_CGU_OUT_CFG_UPDATE_FREQ;
+		ret = ice_aq_set_output_pin_cfg(&pf->hw, pin->idx, flags,
+						0, freq, 0);
+	} else {
+		ret = -EINVAL;
+	}
+
+	if (ret) {
+		dev_dbg(ice_pf_to_dev(pf),
+			"err:%d %s failed to set pin freq:%u on pin:%u\n",
+			ret, ice_aq_str(pf->hw.adminq.sq_last_status),
+			freq, pin->idx);
+	} else {
+		pin->freq = freq;
+	}
+
+	return ret;
+}
+
+/**
+ * ice_dpll_frequency_set - wrapper for pin callback for set frequency
+ * @pin: pointer to a pin
+ * @dpll: pointer to dpll
+ * @frequency: frequency to be set
+ * @extack: netlink extack
+ * @pin_type: type of pin being configured
+ *
+ * Wraps internal set frequency command on a pin.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - error pin not found or couldn't set in hw
+ */
+static int
+ice_dpll_frequency_set(const struct dpll_pin *pin,
+		       const struct dpll_device *dpll,
+		       const u32 frequency,
+		       struct netlink_ext_ack *extack,
+		       const enum ice_dpll_pin_type pin_type)
+{
+	struct ice_pf *pf = dpll_pin_on_dpll_priv(dpll, pin);
+	struct ice_dpll_pin *p;
+	int ret = -EINVAL;
+
+	if (!pf)
+		return ret;
+	if (ice_dpll_cb_lock(pf))
+		return -EBUSY;
+	p = ice_find_pin(pf, pin, pin_type);
+	if (!p) {
+		NL_SET_ERR_MSG(extack, "pin not found");
+		goto unlock;
+	}
+
+	ret = ice_dpll_pin_freq_set(pf, p, pin_type, frequency);
+	if (ret)
+		NL_SET_ERR_MSG_FMT(extack, "freq not set, err:%d", ret);
+unlock:
+	ice_dpll_cb_unlock(pf);
+
+	return ret;
+}
+
+/**
+ * ice_dpll_source_frequency_set - source pin callback for set frequency
+ * @pin: pointer to a pin
+ * @dpll: pointer to dpll
+ * @frequency: frequency to be set
+ * @extack: netlink extack
+ *
+ * Wraps internal set frequency command on a pin.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - error pin not found or couldn't set in hw
+ */
+static int
+ice_dpll_source_frequency_set(const struct dpll_pin *pin,
+			      const struct dpll_device *dpll,
+			      const u32 frequency,
+			      struct netlink_ext_ack *extack)
+{
+	return ice_dpll_frequency_set(pin, dpll, frequency, extack,
+				      ICE_DPLL_PIN_TYPE_SOURCE);
+}
+
+/**
+ * ice_dpll_output_frequency_set - output pin callback for set frequency
+ * @pin: pointer to a pin
+ * @dpll: pointer to dpll
+ * @frequency: frequency to be set
+ * @extack: netlink extack
+ *
+ * Wraps internal set frequency command on a pin.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - error pin not found or couldn't set in hw
+ */
+static int
+ice_dpll_output_frequency_set(const struct dpll_pin *pin,
+			      const struct dpll_device *dpll,
+			      const u32 frequency,
+			      struct netlink_ext_ack *extack)
+{
+	return ice_dpll_frequency_set(pin, dpll, frequency, extack,
+				      ICE_DPLL_PIN_TYPE_OUTPUT);
+}
+
+/**
+ * ice_dpll_frequency_get - wrapper for pin callback for get frequency
+ * @pin: pointer to a pin
+ * @dpll: pointer to dpll
+ * @frequency: on success holds pin's frequency
+ * @extack: netlink extack
+ * @pin_type: type of pin being configured
+ *
+ * Wraps internal get frequency command of a pin.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - error pin not found or couldn't get from hw
+ */
+static int
+ice_dpll_frequency_get(const struct dpll_pin *pin,
+		       const struct dpll_device *dpll,
+		       u32 *frequency,
+		       struct netlink_ext_ack *extack,
+		       const enum ice_dpll_pin_type pin_type)
+{
+	struct ice_pf *pf = dpll_pin_on_dpll_priv(dpll, pin);
+	struct ice_dpll_pin *p;
+	int ret = -EINVAL;
+
+	if (!pf)
+		return ret;
+	if (ice_dpll_cb_lock(pf))
+		return -EBUSY;
+	p = ice_find_pin(pf, pin, pin_type);
+	if (!p) {
+		NL_SET_ERR_MSG(extack, "pin not found");
+		goto unlock;
+	}
+	*frequency = p->freq;
+	ret = 0;
+unlock:
+	ice_dpll_cb_unlock(pf);
+
+	return ret;
+}
+
+/**
+ * ice_dpll_source_frequency_get - source pin callback for get frequency
+ * @pin: pointer to a pin
+ * @dpll: pointer to dpll
+ * @frequency: on success holds pin's frequency
+ * @extack: netlink extack
+ *
+ * Wraps internal get frequency command of a source pin.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - error pin not found or couldn't get from hw
+ */
+static int
+ice_dpll_source_frequency_get(const struct dpll_pin *pin,
+			      const struct dpll_device *dpll,
+			      u32 *frequency,
+			      struct netlink_ext_ack *extack)
+{
+	return ice_dpll_frequency_get(pin, dpll, frequency, extack,
+				      ICE_DPLL_PIN_TYPE_SOURCE);
+}
+
+/**
+ * ice_dpll_output_frequency_get - output pin callback for get frequency
+ * @pin: pointer to a pin
+ * @dpll: pointer to dpll
+ * @frequency: on success holds pin's frequency
+ * @extack: netlink extack
+ *
+ * Wraps internal get frequency command of a pin.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - error pin not found or couldn't get from hw
+ */
+static int
+ice_dpll_output_frequency_get(const struct dpll_pin *pin,
+			      const struct dpll_device *dpll,
+			      u32 *frequency,
+			      struct netlink_ext_ack *extack)
+{
+	return ice_dpll_frequency_get(pin, dpll, frequency, extack,
+				      ICE_DPLL_PIN_TYPE_OUTPUT);
+}
+
+/**
+ * ice_dpll_pin_enable - enable a pin on dplls
+ * @hw: board private hw structure
+ * @pin: pointer to a pin
+ * @pin_type: type of pin being enabled
+ *
+ * Enable a pin on both dplls. Store current state in pin->flags.
+ *
+ * Return:
+ * * 0 - OK
+ * * negative - error
+ */
+static int
+ice_dpll_pin_enable(struct ice_hw *hw, struct ice_dpll_pin *pin,
+		    const enum ice_dpll_pin_type pin_type)
+{
+	u8 flags = pin->flags[0];
+	int ret;
+
+	if (pin_type == ICE_DPLL_PIN_TYPE_SOURCE) {
+		flags |= ICE_AQC_GET_CGU_IN_CFG_FLG2_INPUT_EN;
+		ret = ice_aq_set_input_pin_cfg(hw, pin->idx, 0, flags, 0, 0);
+	} else if (pin_type == ICE_DPLL_PIN_TYPE_OUTPUT) {
+		flags |= ICE_AQC_SET_CGU_OUT_CFG_OUT_EN;
+		ret = ice_aq_set_output_pin_cfg(hw, pin->idx, flags, 0, 0, 0);
+	}
+	if (ret)
+		dev_dbg(ice_pf_to_dev((struct ice_pf *)(hw->back)),
+			"err:%d %s failed to enable %s pin:%u\n",
+			ret, ice_aq_str(hw->adminq.sq_last_status),
+			pin_type_name[pin_type], pin->idx);
+	else
+		pin->flags[0] = flags;
+
+	return ret;
+}
+
+/**
+ * ice_dpll_pin_disable - disable a pin on dplls
+ * @hw: board private hw structure
+ * @pin: pointer to a pin
+ * @pin_type: type of pin being disabled
+ *
+ * Disable a pin on both dplls. Store current state in pin->flags.
+ *
+ * Return:
+ * * 0 - OK
+ * * negative - error
+ */
+static int
+ice_dpll_pin_disable(struct ice_hw *hw, struct ice_dpll_pin *pin,
+		     enum ice_dpll_pin_type pin_type)
+{
+	u8 flags = pin->flags[0];
+	int ret;
+
+	if (pin_type == ICE_DPLL_PIN_TYPE_SOURCE) {
+		flags &= ~(ICE_AQC_GET_CGU_IN_CFG_FLG2_INPUT_EN);
+		ret = ice_aq_set_input_pin_cfg(hw, pin->idx, 0, flags, 0, 0);
+	} else if (pin_type == ICE_DPLL_PIN_TYPE_OUTPUT) {
+		flags &= ~(ICE_AQC_SET_CGU_OUT_CFG_OUT_EN);
+		ret = ice_aq_set_output_pin_cfg(hw, pin->idx, flags, 0, 0, 0);
+	}
+	if (ret)
+		dev_dbg(ice_pf_to_dev((struct ice_pf *)(hw->back)),
+			"err:%d %s failed to disable %s pin:%u\n",
+			ret, ice_aq_str(hw->adminq.sq_last_status),
+			pin_type_name[pin_type], pin->idx);
+	else
+		pin->flags[0] = flags;
+
+	return ret;
+}
+
+/**
+ * ice_dpll_pin_state_update - update pin's state
+ * @hw: private board struct
+ * @pin: structure with pin attributes to be updated
+ * @pin_type: type of pin being updated
+ *
+ * Determine pin current mode, frequency and signal type. Then update struct
+ * holding the pin info.
+ *
+ * Return:
+ * * 0 - OK
+ * * negative - error
+ */
+int
+ice_dpll_pin_state_update(struct ice_pf *pf, struct ice_dpll_pin *pin,
+			  const enum ice_dpll_pin_type pin_type)
+{
+	int ret;
+
+	if (pin_type == ICE_DPLL_PIN_TYPE_SOURCE) {
+		ret = ice_aq_get_input_pin_cfg(&pf->hw, pin->idx, NULL, NULL,
+					       NULL, &pin->flags[0],
+					       &pin->freq, NULL);
+		if (!!(ICE_AQC_GET_CGU_IN_CFG_FLG2_INPUT_EN & pin->flags[0]))
+			pin->state[0] = DPLL_PIN_STATE_CONNECTED;
+		else
+			pin->state[0] = DPLL_PIN_STATE_DISCONNECTED;
+	} else if (pin_type == ICE_DPLL_PIN_TYPE_OUTPUT) {
+		ret = ice_aq_get_output_pin_cfg(&pf->hw, pin->idx,
+						&pin->flags[0], NULL,
+						&pin->freq, NULL);
+		if (!!(ICE_AQC_SET_CGU_OUT_CFG_OUT_EN & pin->flags[0]))
+			pin->state[0] = DPLL_PIN_STATE_CONNECTED;
+		else
+			pin->state[0] = DPLL_PIN_STATE_DISCONNECTED;
+	} else if (pin_type == ICE_DPLL_PIN_TYPE_RCLK_SOURCE) {
+		u8 parent, port_num = ICE_AQC_SET_PHY_REC_CLK_OUT_CURR_PORT;
+
+		for (parent = 0; parent < pf->dplls.rclk.num_parents;
+		     parent++) {
+			ret = ice_aq_get_phy_rec_clk_out(&pf->hw, parent,
+							 &port_num,
+							 &pin->flags[parent],
+							 &pin->freq);
+			if (ret)
+				return ret;
+			if (!!(ICE_AQC_GET_PHY_REC_CLK_OUT_OUT_EN &
+			       pin->flags[parent]))
+				pin->state[parent] = DPLL_PIN_STATE_CONNECTED;
+			else
+				pin->state[parent] =
+					DPLL_PIN_STATE_DISCONNECTED;
+		}
+	}
+
+	return ret;
+}
+
+/**
+ * ice_find_dpll - find ice_dpll on a pf
+ * @pf: private board structure
+ * @dpll: kernel's dpll_device pointer to be searched
+ *
+ * Return:
+ * * pointer if ice_dpll with given device dpll pointer is found
+ * * NULL if not found
+ */
+static struct ice_dpll
+*ice_find_dpll(struct ice_pf *pf, const struct dpll_device *dpll)
+{
+	if (!pf || !dpll)
+		return NULL;
+
+	return dpll == pf->dplls.eec.dpll ? &pf->dplls.eec :
+	       dpll == pf->dplls.pps.dpll ? &pf->dplls.pps : NULL;
+}
+
+/**
+ * ice_dpll_hw_source_prio_set - set source priority value in hardware
+ * @pf: board private structure
+ * @dpll: ice dpll pointer
+ * @pin: ice pin pointer
+ * @prio: priority value being set on a dpll
+ *
+ * Internal wrapper for setting the priority in the hardware.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - failure
+ */
+static int
+ice_dpll_hw_source_prio_set(struct ice_pf *pf, struct ice_dpll *dpll,
+			    struct ice_dpll_pin *pin, const u32 prio)
+{
+	int ret;
+
+	ret = ice_aq_set_cgu_ref_prio(&pf->hw, dpll->dpll_idx, pin->idx,
+				      (u8)prio);
+	if (ret)
+		dev_dbg(ice_pf_to_dev(pf),
+			"err:%d %s failed to set pin prio:%u on pin:%u\n",
+			ret, ice_aq_str(pf->hw.adminq.sq_last_status),
+			prio, pin->idx);
+	else
+		dpll->input_prio[pin->idx] = prio;
+
+	return ret;
+}
+
+/**
+ * ice_dpll_lock_status_get - get dpll lock status callback
+ * @dpll: registered dpll pointer
+ * @status: on success holds dpll's lock status
+ *
+ * Dpll subsystem callback, provides dpll's lock status.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - failure
+ */
+static int ice_dpll_lock_status_get(const struct dpll_device *dpll,
+				    enum dpll_lock_status *status,
+				    struct netlink_ext_ack *extack)
+{
+	struct ice_pf *pf = dpll_priv(dpll);
+	struct ice_dpll *d;
+
+	if (!pf)
+		return -EINVAL;
+	if (ice_dpll_cb_lock(pf))
+		return -EBUSY;
+	d = ice_find_dpll(pf, dpll);
+	if (!d)
+		return -EFAULT;
+	dev_dbg(ice_pf_to_dev(pf), "%s: dpll:%p, pf:%p\n", __func__, dpll, pf);
+	*status = ice_dpll_status[d->dpll_state];
+	ice_dpll_cb_unlock(pf);
+
+	return 0;
+}
+
+/**
+ * ice_dpll_source_idx_get - get dpll's source index
+ * @dpll: registered dpll pointer
+ * @pin_idx: on success holds currently selected source pin index
+ *
+ * Dpll subsystem callback. Provides index of a source dpll is trying to lock
+ * with.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - failure
+ */
+static int ice_dpll_source_idx_get(const struct dpll_device *dpll, u32 *pin_idx,
+				   struct netlink_ext_ack *extack)
+{
+	struct ice_pf *pf = dpll_priv(dpll);
+	struct ice_dpll *d;
+
+	if (!pf)
+		return -EINVAL;
+
+	if (ice_dpll_cb_lock(pf))
+		return -EBUSY;
+	d = ice_find_dpll(pf, dpll);
+	if (!d) {
+		ice_dpll_cb_unlock(pf);
+		return -EFAULT;
+	}
+	if (d->dpll_state == ICE_CGU_STATE_INVALID ||
+	    d->dpll_state == ICE_CGU_STATE_FREERUN)
+		*pin_idx = PIN_IDX_INVALID;
+	else
+		*pin_idx = (u32)d->source_idx;
+	ice_dpll_cb_unlock(pf);
+	dev_dbg(ice_pf_to_dev(pf), "%s: dpll:%p, pf:%p d:%p, idx:%u\n",
+		__func__, dpll, pf, d, *pin_idx);
+
+	return 0;
+}
+
+/**
+ * ice_dpll_mode_get - get dpll's working mode
+ * @dpll: registered dpll pointer
+ * @mode: on success holds current working mode of dpll
+ *
+ * Dpll subsystem callback. Provides working mode of dpll.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - failure
+ */
+static int ice_dpll_mode_get(const struct dpll_device *dpll,
+			     enum dpll_mode *mode,
+			     struct netlink_ext_ack *extack)
+{
+	struct ice_pf *pf = dpll_priv(dpll);
+	struct ice_dpll *d;
+
+	if (!pf)
+		return -EINVAL;
+	if (ice_dpll_cb_lock(pf))
+		return -EBUSY;
+	d = ice_find_dpll(pf, dpll);
+	ice_dpll_cb_unlock(pf);
+	if (!d)
+		return -EFAULT;
+	*mode = DPLL_MODE_AUTOMATIC;
+
+	return 0;
+}
+
+/**
+ * ice_dpll_mode_get - check if dpll's working mode is supported
+ * @dpll: registered dpll pointer
+ * @mode: mode to be checked for support
+ *
+ * Dpll subsystem callback. Provides information if working mode is supported
+ * by dpll.
+ *
+ * Return:
+ * * true - mode is supported
+ * * false - mode is not supported
+ */
+static bool ice_dpll_mode_supported(const struct dpll_device *dpll,
+				    const enum dpll_mode mode,
+				    struct netlink_ext_ack *extack)
+{
+	struct ice_pf *pf = dpll_priv(dpll);
+	struct ice_dpll *d;
+
+	if (!pf)
+		return false;
+
+	if (ice_dpll_cb_lock(pf))
+		return false;
+	d = ice_find_dpll(pf, dpll);
+	ice_dpll_cb_unlock(pf);
+	if (!d)
+		return false;
+	if (mode == DPLL_MODE_AUTOMATIC)
+		return true;
+
+	return false;
+}
+
+/**
+ * ice_dpll_pin_state_set - set pin's state on dpll
+ * @pf: Board private structure
+ * @pin: pointer to a pin
+ * @pin_type: type of modified pin
+ * @mode: requested mode
+ *
+ * Determine requested pin mode set it on a pin.
+ *
+ * Return:
+ * * 0 - OK or no change required
+ * * negative - error
+ */
+static int
+ice_dpll_pin_state_set(const struct dpll_device *dpll,
+		       const struct dpll_pin *pin,
+		       const enum dpll_pin_state state,
+		       struct netlink_ext_ack *extack,
+		       const enum ice_dpll_pin_type pin_type)
+{
+	struct ice_pf *pf = dpll_pin_on_dpll_priv(dpll, pin);
+	struct ice_dpll_pin *p;
+	int ret = -EINVAL;
+
+	if (!pf)
+		return ret;
+	if (ice_dpll_cb_lock(pf))
+		return -EBUSY;
+	p = ice_find_pin(pf, pin, pin_type);
+	if (!p)
+		goto unlock;
+	if (state == DPLL_PIN_STATE_CONNECTED)
+		ret = ice_dpll_pin_enable(&pf->hw, p, pin_type);
+	else
+		ret = ice_dpll_pin_disable(&pf->hw, p, pin_type);
+	if (!ret)
+		ret = ice_dpll_pin_state_update(pf, p, pin_type);
+unlock:
+	ice_dpll_cb_unlock(pf);
+	dev_dbg(ice_pf_to_dev(pf),
+		"%s: dpll:%p, pin:%p, p:%p pf:%p state: %d ret:%d\n",
+		__func__, dpll, pin, p, pf, state, ret);
+
+	return ret;
+}
+
+/**
+ * ice_dpll_output_state_set - enable/disable output pin on dpll device
+ * @dpll: registered dpll pointer
+ * @pin: pointer to a pin
+ * @state: state to be set
+ *
+ * Dpll subsystem callback. Enables given mode on output type pin.
+ *
+ * Return:
+ * * 0 - successfully enabled mode
+ * * negative - failed to enable mode
+ */
+static int ice_dpll_output_state_set(const struct dpll_pin *pin,
+				     const struct dpll_device *dpll,
+				     const enum dpll_pin_state state,
+				     struct netlink_ext_ack *extack)
+{
+	return ice_dpll_pin_state_set(dpll, pin, state, extack,
+				      ICE_DPLL_PIN_TYPE_OUTPUT);
+}
+
+/**
+ * ice_dpll_source_state_set - enable/disable source pin on dpll levice
+ * @dpll: registered dpll pointer
+ * @pin: pointer to a pin
+ * @state: state to be set
+ *
+ * Dpll subsystem callback. Enables given mode on source type pin.
+ *
+ * Return:
+ * * 0 - successfully enabled mode
+ * * negative - failed to enable mode
+ */
+static int ice_dpll_source_state_set(const struct dpll_pin *pin,
+				     const struct dpll_device *dpll,
+				     const enum dpll_pin_state state,
+				     struct netlink_ext_ack *extack)
+{
+	return ice_dpll_pin_state_set(dpll, pin, state, extack,
+				      ICE_DPLL_PIN_TYPE_SOURCE);
+}
+
+/**
+ * ice_dpll_pin_state_get - set pin's state on dpll
+ * @dpll: registered dpll pointer
+ * @pin: pointer to a pin
+ * @state: on success holds state of the pin
+ * @extack: error reporting
+ * @pin_type: type of questioned pin
+ *
+ * Determine pin state set it on a pin.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - failed to get state
+ */
+static int
+ice_dpll_pin_state_get(const struct dpll_device *dpll,
+		       const struct dpll_pin *pin,
+		       enum dpll_pin_state *state,
+		       struct netlink_ext_ack *extack,
+		       const enum ice_dpll_pin_type pin_type)
+{
+	struct ice_pf *pf = dpll_pin_on_dpll_priv(dpll, pin);
+	struct ice_dpll_pin *p;
+	int ret = -EINVAL;
+
+	if (!pf)
+		return ret;
+
+	if (ice_dpll_cb_lock(pf))
+		return -EBUSY;
+	p = ice_find_pin(pf, pin, pin_type);
+	if (!p) {
+		NL_SET_ERR_MSG(extack, "pin not found");
+		goto unlock;
+	}
+	if ((pin_type == ICE_DPLL_PIN_TYPE_SOURCE &&
+	     !!(p->flags[0] & ICE_AQC_GET_CGU_IN_CFG_FLG2_INPUT_EN)) ||
+	    (pin_type == ICE_DPLL_PIN_TYPE_OUTPUT &&
+	     !!(p->flags[0] & ICE_AQC_SET_CGU_OUT_CFG_OUT_EN)))
+		*state = DPLL_PIN_STATE_CONNECTED;
+	else
+		*state = DPLL_PIN_STATE_DISCONNECTED;
+	ret = 0;
+unlock:
+	ice_dpll_cb_unlock(pf);
+	dev_dbg(ice_pf_to_dev(pf),
+		"%s: dpll:%p, pin:%p, pf:%p state: %d ret:%d\n",
+		__func__, dpll, pin, pf, *state, ret);
+
+	return ret;
+}
+
+/**
+ * ice_dpll_output_state_get - get output pin state on dpll device
+ * @pin: pointer to a pin
+ * @dpll: registered dpll pointer
+ * @state: on success holds state of the pin
+ * @extack: error reporting
+ *
+ * Dpll subsystem callback. Check state of a pin.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - failed to get state
+ */
+static int ice_dpll_output_state_get(const struct dpll_pin *pin,
+				     const struct dpll_device *dpll,
+				     enum dpll_pin_state *state,
+				     struct netlink_ext_ack *extack)
+{
+	return ice_dpll_pin_state_get(dpll, pin, state, extack,
+				      ICE_DPLL_PIN_TYPE_OUTPUT);
+}
+
+/**
+ * ice_dpll_source_state_get - get source pin state on dpll device
+ * @pin: pointer to a pin
+ * @dpll: registered dpll pointer
+ * @state: on success holds state of the pin
+ * @extack: error reporting
+ *
+ * Dpll subsystem callback. Check state of a pin.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - failed to get state
+ */
+static int ice_dpll_source_state_get(const struct dpll_pin *pin,
+				     const struct dpll_device *dpll,
+				     enum dpll_pin_state *state,
+				     struct netlink_ext_ack *extack)
+{
+	return ice_dpll_pin_state_get(dpll, pin, state, extack,
+				      ICE_DPLL_PIN_TYPE_SOURCE);
+}
+
+/**
+ * ice_dpll_source_prio_get - get dpll's source prio
+ * @dpll: registered dpll pointer
+ * @pin: pointer to a pin
+ * @prio: on success - returns source priority on dpll
+ *
+ * Dpll subsystem callback. Handler for getting priority of a source pin.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - failure
+ */
+static int ice_dpll_source_prio_get(const struct dpll_pin *pin,
+				    const struct dpll_device *dpll, u32 *prio,
+				    struct netlink_ext_ack *extack)
+{
+	struct ice_pf *pf = dpll_pin_on_dpll_priv(dpll, pin);
+	struct ice_dpll *d = NULL;
+	struct ice_dpll_pin *p;
+	int ret = -EINVAL;
+
+	if (!pf)
+		return ret;
+
+	if (ice_dpll_cb_lock(pf))
+		return -EBUSY;
+	p = ice_find_pin(pf, pin, ICE_DPLL_PIN_TYPE_SOURCE);
+	if (!p) {
+		NL_SET_ERR_MSG(extack, "pin not found");
+		goto unlock;
+	}
+	d = ice_find_dpll(pf, dpll);
+	if (!d) {
+		NL_SET_ERR_MSG(extack, "dpll not found");
+		goto unlock;
+	}
+	*prio = d->input_prio[p->idx];
+	ret = 0;
+unlock:
+	ice_dpll_cb_unlock(pf);
+	dev_dbg(ice_pf_to_dev(pf), "%s: dpll:%p, pin:%p, pf:%p ret:%d\n",
+		__func__, dpll, pin, pf, ret);
+
+	return ret;
+}
+
+/**
+ * ice_dpll_source_prio_set - set dpll source prio
+ * @dpll: registered dpll pointer
+ * @pin: pointer to a pin
+ * @prio: source priority to be set on dpll
+ *
+ * Dpll subsystem callback. Handler for setting priority of a source pin.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - failure
+ */
+static int ice_dpll_source_prio_set(const struct dpll_pin *pin,
+				    const struct dpll_device *dpll,
+				    const u32 prio,
+				    struct netlink_ext_ack *extack)
+{
+	struct ice_pf *pf = dpll_pin_on_dpll_priv(dpll, pin);
+	struct ice_dpll *d = NULL;
+	struct ice_dpll_pin *p;
+	int ret = -EINVAL;
+
+	if (!pf)
+		return ret;
+
+	if (prio > ICE_DPLL_PRIO_MAX) {
+		NL_SET_ERR_MSG(extack, "prio out of range");
+		return ret;
+	}
+
+	if (ice_dpll_cb_lock(pf))
+		return -EBUSY;
+	p = ice_find_pin(pf, pin, ICE_DPLL_PIN_TYPE_SOURCE);
+	if (!p) {
+		NL_SET_ERR_MSG(extack, "pin not found");
+		goto unlock;
+	}
+	d = ice_find_dpll(pf, dpll);
+	if (!d) {
+		NL_SET_ERR_MSG(extack, "dpll not found");
+		goto unlock;
+	}
+	ret = ice_dpll_hw_source_prio_set(pf, d, p, prio);
+	if (ret)
+		NL_SET_ERR_MSG_FMT(extack, "unable to set prio: %d", ret);
+unlock:
+	ice_dpll_cb_unlock(pf);
+	dev_dbg(ice_pf_to_dev(pf), "%s: dpll:%p, pin:%p, pf:%p ret:%d\n",
+		__func__, dpll, pin, pf, ret);
+
+	return ret;
+}
+
+static int ice_dpll_source_direction(const struct dpll_pin *pin,
+				     const struct dpll_device *dpll,
+				     enum dpll_pin_direction *direction,
+				     struct netlink_ext_ack *extack)
+{
+	*direction = DPLL_PIN_DIRECTION_SOURCE;
+
+	return 0;
+}
+
+static int ice_dpll_output_direction(const struct dpll_pin *pin,
+				     const struct dpll_device *dpll,
+				     enum dpll_pin_direction *direction,
+				     struct netlink_ext_ack *extack)
+{
+	*direction = DPLL_PIN_DIRECTION_OUTPUT;
+
+	return 0;
+}
+
+/**
+ * ice_dpll_rclk_state_on_pin_set - set a state on rclk pin
+ * @dpll: registered dpll pointer
+ * @pin: pointer to a pin
+ *
+ * dpll subsystem callback, set a state of a rclk pin
+ *
+ * Return:
+ * * 0 - success
+ * * negative - failure
+ */
+static int ice_dpll_rclk_state_on_pin_set(const struct dpll_pin *pin,
+					  const struct dpll_pin *parent_pin,
+					  const enum dpll_pin_state state,
+					  struct netlink_ext_ack *extack)
+{
+	bool enable = state == DPLL_PIN_STATE_CONNECTED ? true : false;
+	struct ice_pf *pf = dpll_pin_on_pin_priv(parent_pin, pin);
+	u32 parent_idx, hw_idx = PIN_IDX_INVALID, i;
+	struct ice_dpll_pin *p;
+	int ret = -EINVAL;
+
+	if (!pf)
+		return ret;
+	if (ice_dpll_cb_lock(pf))
+		return -EBUSY;
+	p = ice_find_pin(pf, pin, ICE_DPLL_PIN_TYPE_RCLK_SOURCE);
+	if (!p) {
+		ret = -EFAULT;
+		goto unlock;
+	}
+	parent_idx = ice_find_pin_idx(pf, parent_pin,
+				      ICE_DPLL_PIN_TYPE_SOURCE);
+	if (parent_idx == PIN_IDX_INVALID) {
+		ret = -EFAULT;
+		goto unlock;
+	}
+	for (i = 0; i < pf->dplls.rclk.num_parents; i++)
+		if (pf->dplls.rclk.parent_idx[i] == parent_idx)
+			hw_idx = i;
+	if (hw_idx == PIN_IDX_INVALID)
+		goto unlock;
+
+	if ((enable && !!(p->flags[hw_idx] &
+			 ICE_AQC_GET_PHY_REC_CLK_OUT_OUT_EN)) ||
+	    (!enable && !(p->flags[hw_idx] &
+			  ICE_AQC_GET_PHY_REC_CLK_OUT_OUT_EN))) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+	ret = ice_aq_set_phy_rec_clk_out(&pf->hw, hw_idx, enable,
+					 &p->freq);
+unlock:
+	ice_dpll_cb_unlock(pf);
+	dev_dbg(ice_pf_to_dev(pf), "%s: parent:%p, pin:%p, pf:%p ret:%d\n",
+		__func__, parent_pin, pin, pf, ret);
+
+	return ret;
+}
+
+/**
+ * ice_dpll_rclk_state_on_pin_get - get a state of rclk pin
+ * @pin: pointer to a pin
+ * @parent_pin: pointer to a parent pin
+ * @state: on success holds valid pin state
+ * @extack: used for error reporting
+ *
+ * dpll subsystem callback, get a state of a recovered clock pin.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - failure
+ */
+static int ice_dpll_rclk_state_on_pin_get(const struct dpll_pin *pin,
+					  const struct dpll_pin *parent_pin,
+					  enum dpll_pin_state *state,
+					  struct netlink_ext_ack *extack)
+{
+	struct ice_pf *pf = dpll_pin_on_pin_priv(parent_pin, pin);
+	u32 parent_idx, hw_idx = PIN_IDX_INVALID, i;
+	struct ice_dpll_pin *p;
+	int ret = -EFAULT;
+
+	if (!pf)
+		return ret;
+	if (ice_dpll_cb_lock(pf))
+		return -EBUSY;
+	p = ice_find_pin(pf, pin, ICE_DPLL_PIN_TYPE_RCLK_SOURCE);
+	if (!p)
+		goto unlock;
+	parent_idx = ice_find_pin_idx(pf, parent_pin,
+				      ICE_DPLL_PIN_TYPE_SOURCE);
+	if (parent_idx == PIN_IDX_INVALID)
+		goto unlock;
+	for (i = 0; i < pf->dplls.rclk.num_parents; i++)
+		if (pf->dplls.rclk.parent_idx[i] == parent_idx)
+			hw_idx = i;
+	if (hw_idx == PIN_IDX_INVALID)
+		goto unlock;
+
+	ret = ice_dpll_pin_state_update(pf, p, ICE_DPLL_PIN_TYPE_RCLK_SOURCE);
+	if (ret)
+		goto unlock;
+
+	if (!!(p->flags[hw_idx] &
+	    ICE_AQC_GET_PHY_REC_CLK_OUT_OUT_EN))
+		*state = DPLL_PIN_STATE_CONNECTED;
+	else
+		*state = DPLL_PIN_STATE_DISCONNECTED;
+	ret = 0;
+unlock:
+	ice_dpll_cb_unlock(pf);
+	dev_dbg(ice_pf_to_dev(pf), "%s: parent:%p, pin:%p, pf:%p ret:%d\n",
+		__func__, parent_pin, pin, pf, ret);
+
+	return ret;
+}
+
+static struct dpll_pin_ops ice_dpll_rclk_ops = {
+	.state_on_pin_set = ice_dpll_rclk_state_on_pin_set,
+	.state_on_pin_get = ice_dpll_rclk_state_on_pin_get,
+	.direction_get = ice_dpll_source_direction,
+};
+
+static struct dpll_pin_ops ice_dpll_source_ops = {
+	.frequency_get = ice_dpll_source_frequency_get,
+	.frequency_set = ice_dpll_source_frequency_set,
+	.state_on_dpll_get = ice_dpll_source_state_get,
+	.state_on_dpll_set = ice_dpll_source_state_set,
+	.prio_get = ice_dpll_source_prio_get,
+	.prio_set = ice_dpll_source_prio_set,
+	.direction_get = ice_dpll_source_direction,
+};
+
+static struct dpll_pin_ops ice_dpll_output_ops = {
+	.frequency_get = ice_dpll_output_frequency_get,
+	.frequency_set = ice_dpll_output_frequency_set,
+	.state_on_dpll_get = ice_dpll_output_state_get,
+	.state_on_dpll_set = ice_dpll_output_state_set,
+	.direction_get = ice_dpll_output_direction,
+};
+
+static struct dpll_device_ops ice_dpll_ops = {
+	.lock_status_get = ice_dpll_lock_status_get,
+	.source_pin_idx_get = ice_dpll_source_idx_get,
+	.mode_get = ice_dpll_mode_get,
+	.mode_supported = ice_dpll_mode_supported,
+};
+
+/**
+ * ice_dpll_release_info - release memory allocated for pins
+ * @pf: board private structure
+ *
+ * Release memory allocated for pins by ice_dpll_init_info function.
+ */
+static void ice_dpll_release_info(struct ice_pf *pf)
+{
+	kfree(pf->dplls.inputs);
+	pf->dplls.inputs = NULL;
+	kfree(pf->dplls.outputs);
+	pf->dplls.outputs = NULL;
+	kfree(pf->dplls.eec.input_prio);
+	pf->dplls.eec.input_prio = NULL;
+	kfree(pf->dplls.pps.input_prio);
+	pf->dplls.pps.input_prio = NULL;
+}
+
+/**
+ * ice_dpll_release_rclk_pin - release rclk pin from its parents
+ * @pf: board private structure
+ *
+ * Deregister from parent pins and release resources in dpll subsystem.
+ */
+static void
+ice_dpll_release_rclk_pin(struct ice_pf *pf)
+{
+	struct ice_dpll_pin *rclk = &pf->dplls.rclk;
+	struct dpll_pin *parent;
+	int i;
+
+	for (i = 0; i < rclk->num_parents; i++) {
+		parent = pf->dplls.inputs[rclk->parent_idx[i]].pin;
+		if (!parent)
+			continue;
+		dpll_pin_on_pin_unregister(parent, rclk->pin);
+	}
+	dpll_pin_put(rclk->pin);
+	rclk->pin = NULL;
+}
+
+/**
+ * ice_dpll_release_pins - release pin's from dplls registered in subsystem
+ * @dpll_eec: dpll_eec dpll pointer
+ * @dpll_pps: dpll_pps dpll pointer
+ * @pins: pointer to pins array
+ * @count: number of pins
+ *
+ * Deregister and free pins of a given array of pins from dpll devices
+ * registered in dpll subsystem.
+ *
+ * Return:
+ * * 0 - success
+ * * positive - number of errors encounterd on pin's deregistration.
+ */
+static int
+ice_dpll_release_pins(struct dpll_device *dpll_eec,
+		      struct dpll_device *dpll_pps, struct ice_dpll_pin *pins,
+		      int count, bool cgu)
+{
+	int i, ret, err = 0;
+
+	for (i = 0; i < count; i++) {
+		struct ice_dpll_pin *p = &pins[i];
+
+		if (p && !IS_ERR_OR_NULL(p->pin)) {
+			if (cgu && dpll_eec) {
+				ret = dpll_pin_unregister(dpll_eec, p->pin);
+				if (ret)
+					err++;
+			}
+			if (cgu && dpll_pps) {
+				ret = dpll_pin_unregister(dpll_pps, p->pin);
+				if (ret)
+					err++;
+			}
+			dpll_pin_put(p->pin);
+			p->pin = NULL;
+		}
+	}
+
+	return err;
+}
+
+/**
+ * ice_dpll_register_pins - register pins with a dpll
+ * @pf: board private structure
+ * @cgu: if cgu is present and controlled by this NIC
+ *
+ * Register source or output pins within given DPLL in a Linux dpll subsystem.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - error
+ */
+static int ice_dpll_register_pins(struct ice_pf *pf, bool cgu)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_dpll_pin *pins;
+	struct dpll_pin_ops *ops;
+	u32 rclk_idx;
+	int ret, i;
+
+	ops = &ice_dpll_source_ops;
+	pins = pf->dplls.inputs;
+	for (i = 0; i < pf->dplls.num_inputs; i++) {
+		pins[i].pin = dpll_pin_get(pf->dplls.clock_id, i,
+					   THIS_MODULE, &pins[i].prop);
+		if (IS_ERR_OR_NULL(pins[i].pin)) {
+			pins[i].pin = NULL;
+			return -ENOMEM;
+		}
+		if (cgu) {
+			ret = dpll_pin_register(pf->dplls.eec.dpll,
+						pins[i].pin,
+						ops, pf, NULL);
+			if (ret)
+				return ret;
+			ret = dpll_pin_register(pf->dplls.pps.dpll,
+						pins[i].pin,
+						ops, pf, NULL);
+			if (ret)
+				return ret;
+		}
+	}
+	if (cgu) {
+		ops = &ice_dpll_output_ops;
+		pins = pf->dplls.outputs;
+		for (i = 0; i < pf->dplls.num_outputs; i++) {
+			pins[i].pin = dpll_pin_get(pf->dplls.clock_id,
+						   i + pf->dplls.num_inputs,
+						   THIS_MODULE, &pins[i].prop);
+			if (IS_ERR_OR_NULL(pins[i].pin)) {
+				pins[i].pin = NULL;
+				return -ENOMEM;
+			}
+			ret = dpll_pin_register(pf->dplls.eec.dpll, pins[i].pin,
+						ops, pf, NULL);
+			if (ret)
+				return ret;
+			ret = dpll_pin_register(pf->dplls.pps.dpll, pins[i].pin,
+						ops, pf, NULL);
+			if (ret)
+				return ret;
+		}
+	}
+	rclk_idx = pf->dplls.num_inputs + pf->dplls.num_outputs + pf->hw.pf_id;
+	pf->dplls.rclk.pin = dpll_pin_get(pf->dplls.clock_id, rclk_idx,
+					  THIS_MODULE, &pf->dplls.rclk.prop);
+	if (IS_ERR_OR_NULL(pf->dplls.rclk.pin)) {
+		pf->dplls.rclk.pin = NULL;
+		return -ENOMEM;
+	}
+	ops = &ice_dpll_rclk_ops;
+	for (i = 0; i < pf->dplls.rclk.num_parents; i++) {
+		struct dpll_pin *parent =
+			pf->dplls.inputs[pf->dplls.rclk.parent_idx[i]].pin;
+
+		ret = dpll_pin_on_pin_register(parent, pf->dplls.rclk.pin,
+					       ops, pf, dev);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_generate_clock_id - generates unique clock_id for registering dpll.
+ * @pf: board private structure
+ * @clock_id: holds generated clock_id
+ *
+ * Generates unique (per board) clock_id for allocation and search of dpll
+ * devices in Linux dpll subsystem.
+ */
+static void ice_generate_clock_id(struct ice_pf *pf, u64 *clock_id)
+{
+	*clock_id = pci_get_dsn(pf->pdev);
+}
+
+/**
+ * ice_dpll_init_dplls
+ * @pf: board private structure
+ * @cgu: if cgu is present and controlled by this NIC
+ *
+ * Get dplls instances for this board, if cgu is controlled by this NIC,
+ * register dpll with callbacks ops
+ *
+ * Return:
+ * * 0 - success
+ * * negative - allocation fails
+ */
+static int ice_dpll_init_dplls(struct ice_pf *pf, bool cgu)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	int ret = -ENOMEM;
+	u64 clock_id;
+
+	ice_generate_clock_id(pf, &clock_id);
+	pf->dplls.eec.dpll = dpll_device_get(clock_id, pf->dplls.eec.dpll_idx,
+					     THIS_MODULE);
+	if (!pf->dplls.eec.dpll) {
+		dev_err(ice_pf_to_dev(pf), "dpll_device_get failed (eec)\n");
+		return ret;
+	}
+	pf->dplls.pps.dpll = dpll_device_get(clock_id, pf->dplls.pps.dpll_idx,
+					     THIS_MODULE);
+	if (!pf->dplls.pps.dpll) {
+		dev_err(ice_pf_to_dev(pf), "dpll_device_get failed (pps)\n");
+		goto put_eec;
+	}
+
+	if (cgu) {
+		ret = dpll_device_register(pf->dplls.eec.dpll, DPLL_TYPE_EEC,
+					   &ice_dpll_ops, pf, dev);
+		if (ret)
+			goto put_pps;
+		ret = dpll_device_register(pf->dplls.pps.dpll, DPLL_TYPE_PPS,
+					   &ice_dpll_ops, pf, dev);
+		if (ret)
+			goto put_pps;
+	}
+
+	return 0;
+
+put_pps:
+	dpll_device_put(pf->dplls.pps.dpll);
+	pf->dplls.pps.dpll = NULL;
+put_eec:
+	dpll_device_put(pf->dplls.eec.dpll);
+	pf->dplls.eec.dpll = NULL;
+
+	return ret;
+}
+
+/**
+ * ice_dpll_update_state - update dpll state
+ * @hw: board private structure
+ * @d: pointer to queried dpll device
+ *
+ * Poll current state of dpll from hw and update ice_dpll struct.
+ * Return:
+ * * 0 - success
+ * * negative - AQ failure
+ */
+static int ice_dpll_update_state(struct ice_hw *hw, struct ice_dpll *d)
+{
+	int ret;
+
+	ret = ice_get_cgu_state(hw, d->dpll_idx, d->prev_dpll_state,
+				&d->source_idx, &d->ref_state, &d->eec_mode,
+				&d->phase_offset, &d->dpll_state);
+
+	dev_dbg(ice_pf_to_dev((struct ice_pf *)(hw->back)),
+		"update dpll=%d, src_idx:%u, state:%d, prev:%d\n",
+		d->dpll_idx, d->source_idx,
+		d->dpll_state, d->prev_dpll_state);
+
+	if (ret)
+		dev_err(ice_pf_to_dev((struct ice_pf *)(hw->back)),
+			"update dpll=%d state failed, ret=%d %s\n",
+			d->dpll_idx, ret,
+			ice_aq_str(hw->adminq.sq_last_status));
+
+	return ret;
+}
+
+/**
+ * ice_dpll_notify_changes - notify dpll subsystem about changes
+ * @d: pointer do dpll
+ *
+ * Once change detected appropriate event is submitted to the dpll subsystem.
+ */
+static void ice_dpll_notify_changes(struct ice_dpll *d)
+{
+	if (d->prev_dpll_state != d->dpll_state) {
+		d->prev_dpll_state = d->dpll_state;
+		dpll_device_notify(d->dpll, DPLL_A_LOCK_STATUS);
+	}
+	if (d->prev_source_idx != d->source_idx) {
+		d->prev_source_idx = d->source_idx;
+		dpll_device_notify(d->dpll, DPLL_A_SOURCE_PIN_IDX);
+	}
+}
+
+/**
+ * ice_dpll_periodic_work - DPLLs periodic worker
+ * @work: pointer to kthread_work structure
+ *
+ * DPLLs periodic worker is responsible for polling state of dpll.
+ */
+static void ice_dpll_periodic_work(struct kthread_work *work)
+{
+	struct ice_dplls *d = container_of(work, struct ice_dplls, work.work);
+	struct ice_pf *pf = container_of(d, struct ice_pf, dplls);
+	struct ice_dpll *de = &pf->dplls.eec;
+	struct ice_dpll *dp = &pf->dplls.pps;
+	int ret = 0;
+
+	if (!test_bit(ICE_FLAG_DPLL, pf->flags))
+		return;
+	if (ice_dpll_cb_lock(pf))
+		return;
+	ret = ice_dpll_update_state(&pf->hw, de);
+	if (!ret)
+		ret = ice_dpll_update_state(&pf->hw, dp);
+	if (ret) {
+		d->cgu_state_acq_err_num++;
+		/* stop rescheduling this worker */
+		if (d->cgu_state_acq_err_num >
+		    CGU_STATE_ACQ_ERR_THRESHOLD) {
+			dev_err(ice_pf_to_dev(pf),
+				"EEC/PPS DPLLs periodic work disabled\n");
+			return;
+		}
+	}
+	ice_dpll_cb_unlock(pf);
+	ice_dpll_notify_changes(de);
+	ice_dpll_notify_changes(dp);
+	/* Run twice a second or reschedule if update failed */
+	kthread_queue_delayed_work(d->kworker, &d->work,
+				   ret ? msecs_to_jiffies(10) :
+				   msecs_to_jiffies(500));
+}
+
+/**
+ * ice_dpll_init_worker - Initialize DPLLs periodic worker
+ * @pf: board private structure
+ *
+ * Create and start DPLLs periodic worker.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - create worker failure
+ */
+static int ice_dpll_init_worker(struct ice_pf *pf)
+{
+	struct ice_dplls *d = &pf->dplls;
+	struct kthread_worker *kworker;
+
+	ice_dpll_update_state(&pf->hw, &d->eec);
+	ice_dpll_update_state(&pf->hw, &d->pps);
+	kthread_init_delayed_work(&d->work, ice_dpll_periodic_work);
+	kworker = kthread_create_worker(0, "ice-dplls-%s",
+					dev_name(ice_pf_to_dev(pf)));
+	if (IS_ERR(kworker))
+		return PTR_ERR(kworker);
+	d->kworker = kworker;
+	d->cgu_state_acq_err_num = 0;
+	kthread_queue_delayed_work(d->kworker, &d->work, 0);
+
+	return 0;
+}
+
+/**
+ * ice_dpll_release_all - disable support for DPLL and unregister dpll device
+ * @pf: board private structure
+ * @cgu: if cgu is controlled by this driver instance
+ *
+ * This function handles the cleanup work required from the initialization by
+ * freeing resources and unregistering the dpll.
+ *
+ * Context: Called under pf->dplls.lock
+ */
+static void ice_dpll_release_all(struct ice_pf *pf, bool cgu)
+{
+	struct ice_dplls *d = &pf->dplls;
+	struct ice_dpll *de = &d->eec;
+	struct ice_dpll *dp = &d->pps;
+	int ret;
+
+	mutex_lock(&pf->dplls.lock);
+	ice_dpll_release_rclk_pin(pf);
+	ret = ice_dpll_release_pins(de->dpll, dp->dpll, d->inputs,
+				    d->num_inputs, cgu);
+	mutex_unlock(&pf->dplls.lock);
+	if (ret)
+		dev_warn(ice_pf_to_dev(pf),
+			 "source pins release dplls err=%d\n", ret);
+	if (cgu) {
+		mutex_lock(&pf->dplls.lock);
+		ret = ice_dpll_release_pins(de->dpll, dp->dpll, d->outputs,
+					    d->num_outputs, cgu);
+		mutex_unlock(&pf->dplls.lock);
+		if (ret)
+			dev_warn(ice_pf_to_dev(pf),
+				 "output pins release on dplls err=%d\n", ret);
+	}
+	ice_dpll_release_info(pf);
+	if (dp->dpll) {
+		mutex_lock(&pf->dplls.lock);
+		if (cgu)
+			dpll_device_unregister(dp->dpll);
+		dpll_device_put(dp->dpll);
+		mutex_unlock(&pf->dplls.lock);
+		dev_dbg(ice_pf_to_dev(pf), "PPS dpll removed\n");
+	}
+
+	if (de->dpll) {
+		mutex_lock(&pf->dplls.lock);
+		if (cgu)
+			dpll_device_unregister(de->dpll);
+		dpll_device_put(de->dpll);
+		mutex_unlock(&pf->dplls.lock);
+		dev_dbg(ice_pf_to_dev(pf), "EEC dpll removed\n");
+	}
+
+	if (cgu) {
+		mutex_lock(&pf->dplls.lock);
+		kthread_cancel_delayed_work_sync(&d->work);
+		if (d->kworker) {
+			kthread_destroy_worker(d->kworker);
+			d->kworker = NULL;
+			dev_dbg(ice_pf_to_dev(pf), "DPLLs worker removed\n");
+		}
+		mutex_unlock(&pf->dplls.lock);
+	}
+}
+
+/**
+ * ice_dpll_release - Disable the driver/HW support for DPLLs and unregister
+ * the dpll device.
+ * @pf: board private structure
+ *
+ * This function handles the cleanup work required from the initialization by
+ * freeing resources and unregistering the dpll.
+ */
+void ice_dpll_release(struct ice_pf *pf)
+{
+	if (test_bit(ICE_FLAG_DPLL, pf->flags)) {
+		ice_dpll_release_all(pf,
+				     ice_is_feature_supported(pf, ICE_F_CGU));
+		mutex_destroy(&pf->dplls.lock);
+		clear_bit(ICE_FLAG_DPLL, pf->flags);
+	}
+}
+
+/**
+ * ice_dpll_init_direct_pins - initializes source or output pins information
+ * @pf: Board private structure
+ * @pin_type: type of pins being initialized
+ *
+ * Init information about input or output pins, cache them in pins struct.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - init failure
+ */
+static int
+ice_dpll_init_direct_pins(struct ice_pf *pf, enum ice_dpll_pin_type pin_type)
+{
+	struct ice_dpll *de = &pf->dplls.eec, *dp = &pf->dplls.pps;
+	int num_pins, i, ret = -EINVAL;
+	struct ice_hw *hw = &pf->hw;
+	struct ice_dpll_pin *pins;
+	bool input;
+
+	if (pin_type == ICE_DPLL_PIN_TYPE_SOURCE) {
+		pins = pf->dplls.inputs;
+		num_pins = pf->dplls.num_inputs;
+		input = true;
+	} else if (pin_type == ICE_DPLL_PIN_TYPE_OUTPUT) {
+		pins = pf->dplls.outputs;
+		num_pins = pf->dplls.num_outputs;
+		input = false;
+	} else {
+		return -EINVAL;
+	}
+
+	for (i = 0; i < num_pins; i++) {
+		pins[i].idx = i;
+		pins[i].prop.description = ice_cgu_get_pin_name(hw, i, input);
+		pins[i].prop.type = ice_cgu_get_pin_type(hw, i, input);
+		if (input) {
+			ret = ice_aq_get_cgu_ref_prio(hw, de->dpll_idx, i,
+						      &de->input_prio[i]);
+			if (ret)
+				return ret;
+			ret = ice_aq_get_cgu_ref_prio(hw, dp->dpll_idx, i,
+						      &dp->input_prio[i]);
+			if (ret)
+				return ret;
+			pins[i].prop.capabilities +=
+				DPLL_PIN_CAPS_PRIORITY_CAN_CHANGE;
+		}
+		pins[i].prop.capabilities += DPLL_PIN_CAPS_STATE_CAN_CHANGE;
+		ret = ice_dpll_pin_state_update(pf, &pins[i], pin_type);
+		if (ret)
+			return ret;
+		pins[i].prop.any_freq_min = 0;
+		pins[i].prop.any_freq_max = 0;
+		pins[i].prop.freq_supported = ice_cgu_get_pin_freq_mask(hw, i,
+									input);
+	}
+
+	return ret;
+}
+
+/**
+ * ice_dpll_init_rclk_pin - initializes rclk pin information
+ * @pf: Board private structure
+ * @pin_type: type of pins being initialized
+ *
+ * Init information for rclk pin, cache them in pf->dplls.rclk.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - init failure
+ */
+static int ice_dpll_init_rclk_pin(struct ice_pf *pf)
+{
+	struct ice_dpll_pin *pin = &pf->dplls.rclk;
+	struct device *dev = ice_pf_to_dev(pf);
+
+	pin->prop.description = dev_name(dev);
+	pin->prop.type = DPLL_PIN_TYPE_SYNCE_ETH_PORT;
+	pin->prop.capabilities += DPLL_PIN_CAPS_STATE_CAN_CHANGE;
+
+	return ice_dpll_pin_state_update(pf, pin,
+					 ICE_DPLL_PIN_TYPE_RCLK_SOURCE);
+}
+
+/**
+ * ice_dpll_init_pins - init pins wrapper
+ * @pf: Board private structure
+ * @pin_type: type of pins being initialized
+ *
+ * Wraps functions for pin inti.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - init failure
+ */
+static int ice_dpll_init_pins(struct ice_pf *pf,
+			      const enum ice_dpll_pin_type pin_type)
+{
+	if (pin_type == ICE_DPLL_PIN_TYPE_SOURCE)
+		return ice_dpll_init_direct_pins(pf, pin_type);
+	else if (pin_type == ICE_DPLL_PIN_TYPE_OUTPUT)
+		return ice_dpll_init_direct_pins(pf, pin_type);
+	else if (pin_type == ICE_DPLL_PIN_TYPE_RCLK_SOURCE)
+		return ice_dpll_init_rclk_pin(pf);
+	else
+		return -EINVAL;
+}
+
+/**
+ * ice_dpll_init_info - prepare pf's dpll information structure
+ * @pf: board private structure
+ * @cgu: if cgu is present and controlled by this NIC
+ *
+ * Acquire (from HW) and set basic dpll information (on pf->dplls struct).
+ *
+ * Return:
+ *  0 - success
+ *  negative - error
+ */
+static int ice_dpll_init_info(struct ice_pf *pf, bool cgu)
+{
+	struct ice_aqc_get_cgu_abilities abilities;
+	struct ice_dpll *de = &pf->dplls.eec;
+	struct ice_dpll *dp = &pf->dplls.pps;
+	struct ice_dplls *d = &pf->dplls;
+	struct ice_hw *hw = &pf->hw;
+	int ret, alloc_size, i;
+	u8 base_rclk_idx;
+
+	ice_generate_clock_id(pf, &d->clock_id);
+	ret = ice_aq_get_cgu_abilities(hw, &abilities);
+	if (ret) {
+		dev_err(ice_pf_to_dev(pf),
+			"err:%d %s failed to read cgu abilities\n",
+			ret, ice_aq_str(hw->adminq.sq_last_status));
+		return ret;
+	}
+
+	de->dpll_idx = abilities.eec_dpll_idx;
+	dp->dpll_idx = abilities.pps_dpll_idx;
+	d->num_inputs = abilities.num_inputs;
+	d->num_outputs = abilities.num_outputs;
+
+	alloc_size = sizeof(*d->inputs) * d->num_inputs;
+	d->inputs = kzalloc(alloc_size, GFP_KERNEL);
+	if (!d->inputs)
+		return -ENOMEM;
+
+	alloc_size = sizeof(*de->input_prio) * d->num_inputs;
+	de->input_prio = kzalloc(alloc_size, GFP_KERNEL);
+	if (!de->input_prio)
+		return -ENOMEM;
+
+	dp->input_prio = kzalloc(alloc_size, GFP_KERNEL);
+	if (!dp->input_prio)
+		return -ENOMEM;
+
+	ret = ice_dpll_init_pins(pf, ICE_DPLL_PIN_TYPE_SOURCE);
+	if (ret)
+		goto release_info;
+
+	if (cgu) {
+		alloc_size = sizeof(*d->outputs) * d->num_outputs;
+		d->outputs = kzalloc(alloc_size, GFP_KERNEL);
+		if (!d->outputs)
+			goto release_info;
+
+		ret = ice_dpll_init_pins(pf, ICE_DPLL_PIN_TYPE_OUTPUT);
+		if (ret)
+			goto release_info;
+	}
+
+	ret = ice_get_cgu_rclk_pin_info(&pf->hw, &base_rclk_idx,
+					&pf->dplls.rclk.num_parents);
+	if (ret)
+		return ret;
+	for (i = 0; i < pf->dplls.rclk.num_parents; i++)
+		pf->dplls.rclk.parent_idx[i] = base_rclk_idx + i;
+	ret = ice_dpll_init_pins(pf, ICE_DPLL_PIN_TYPE_RCLK_SOURCE);
+	if (ret)
+		return ret;
+
+	dev_dbg(ice_pf_to_dev(pf),
+		"%s - success, inputs:%u, outputs:%u rclk-parents:%u\n",
+		__func__, d->num_inputs, d->num_outputs, d->rclk.num_parents);
+
+	return 0;
+
+release_info:
+	dev_err(ice_pf_to_dev(pf),
+		"%s - fail: d->inputs:%p, de->input_prio:%p, dp->input_prio:%p, d->outputs:%p\n",
+		__func__, d->inputs, de->input_prio,
+		dp->input_prio, d->outputs);
+	ice_dpll_release_info(pf);
+	return ret;
+}
+
+/**
+ * ice_dpll_init - Initialize DPLLs support
+ * @pf: board private structure
+ *
+ * Set up the device dplls registering them and pins connected within Linux dpll
+ * subsystem. Allow userpsace to obtain state of DPLL and handling of DPLL
+ * configuration requests.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - init failure
+ */
+int ice_dpll_init(struct ice_pf *pf)
+{
+	bool cgu_present = ice_is_feature_supported(pf, ICE_F_CGU);
+	struct ice_dplls *d = &pf->dplls;
+	int err = 0;
+
+	mutex_init(&d->lock);
+	mutex_lock(&d->lock);
+	err = ice_dpll_init_info(pf, cgu_present);
+	if (err)
+		goto release;
+	err = ice_dpll_init_dplls(pf, cgu_present);
+	if (err)
+		goto release;
+	err = ice_dpll_register_pins(pf, cgu_present);
+	if (err)
+		goto release;
+	set_bit(ICE_FLAG_DPLL, pf->flags);
+	if (cgu_present) {
+		err = ice_dpll_init_worker(pf);
+		if (err)
+			goto release;
+	}
+	mutex_unlock(&d->lock);
+	dev_info(ice_pf_to_dev(pf), "DPLLs init successful\n");
+
+	return err;
+
+release:
+	ice_dpll_release_all(pf, cgu_present);
+	clear_bit(ICE_FLAG_DPLL, pf->flags);
+	mutex_unlock(&d->lock);
+	mutex_destroy(&d->lock);
+	dev_warn(ice_pf_to_dev(pf), "DPLLs init failure\n");
+
+	return err;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.h b/drivers/net/ethernet/intel/ice/ice_dpll.h
new file mode 100644
index 000000000000..defe54262ab9
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.h
@@ -0,0 +1,96 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2022, Intel Corporation. */
+
+#ifndef _ICE_DPLL_H_
+#define _ICE_DPLL_H_
+
+#include "ice.h"
+
+#define ICE_DPLL_PRIO_MAX	0xF
+#define ICE_DPLL_RCLK_NUM_MAX	4
+/** ice_dpll_pin - store info about pins
+ * @pin: dpll pin structure
+ * @flags: pin flags returned from HW
+ * @idx: ice pin private idx
+ * @state: state of a pin
+ * @type: type of a pin
+ * @freq_mask: mask of supported frequencies
+ * @freq: current frequency of a pin
+ * @caps: capabilities of a pin
+ * @name: pin name
+ */
+struct ice_dpll_pin {
+	struct dpll_pin *pin;
+	u8 idx;
+	u8 num_parents;
+	u8 parent_idx[ICE_DPLL_RCLK_NUM_MAX];
+	u8 flags[ICE_DPLL_RCLK_NUM_MAX];
+	u8 state[ICE_DPLL_RCLK_NUM_MAX];
+	struct dpll_pin_properties prop;
+	u32 freq;
+};
+
+/** ice_dpll - store info required for DPLL control
+ * @dpll: pointer to dpll dev
+ * @dpll_idx: index of dpll on the NIC
+ * @source_idx: source currently selected
+ * @prev_source_idx: source previously selected
+ * @ref_state: state of dpll reference signals
+ * @eec_mode: eec_mode dpll is configured for
+ * @phase_offset: phase delay of a dpll
+ * @input_prio: priorities of each input
+ * @dpll_state: current dpll sync state
+ * @prev_dpll_state: last dpll sync state
+ */
+struct ice_dpll {
+	struct dpll_device *dpll;
+	int dpll_idx;
+	u8 source_idx;
+	u8 prev_source_idx;
+	u8 ref_state;
+	u8 eec_mode;
+	s64 phase_offset;
+	u8 *input_prio;
+	enum ice_cgu_state dpll_state;
+	enum ice_cgu_state prev_dpll_state;
+};
+
+/** ice_dplls - store info required for CCU (clock controlling unit)
+ * @kworker: periodic worker
+ * @work: periodic work
+ * @lock: locks access to configuration of a dpll
+ * @eec: pointer to EEC dpll dev
+ * @pps: pointer to PPS dpll dev
+ * @inputs: input pins pointer
+ * @outputs: output pins pointer
+ * @rclk: recovered pins pointer
+ * @num_inputs: number of input pins available on dpll
+ * @num_outputs: number of output pins available on dpll
+ * @num_rclk: number of recovered clock pins available on dpll
+ * @cgu_state_acq_err_num: number of errors returned during periodic work
+ */
+struct ice_dplls {
+	struct kthread_worker *kworker;
+	struct kthread_delayed_work work;
+	struct mutex lock;
+	struct ice_dpll eec;
+	struct ice_dpll pps;
+	struct ice_dpll_pin *inputs;
+	struct ice_dpll_pin *outputs;
+	struct ice_dpll_pin rclk;
+	u32 num_inputs;
+	u32 num_outputs;
+	int cgu_state_acq_err_num;
+	u8 base_rclk_idx;
+	u64 clock_id;
+};
+
+int ice_dpll_init(struct ice_pf *pf);
+
+void ice_dpll_release(struct ice_pf *pf);
+
+int ice_dpll_rclk_init(struct ice_pf *pf);
+
+void ice_dpll_rclk_release(struct ice_pf *pf);
+
+#endif
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 567694bf098b..1af7b2ba4665 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4810,6 +4810,10 @@ static void ice_init_features(struct ice_pf *pf)
 	if (ice_is_feature_supported(pf, ICE_F_GNSS))
 		ice_gnss_init(pf);
 
+	if (ice_is_feature_supported(pf, ICE_F_CGU) ||
+	    ice_is_feature_supported(pf, ICE_F_PHY_RCLK))
+		ice_dpll_init(pf);
+
 	/* Note: Flow director init failure is non-fatal to load */
 	if (ice_init_fdir(pf))
 		dev_err(dev, "could not initialize flow director\n");
@@ -4836,6 +4840,9 @@ static void ice_deinit_features(struct ice_pf *pf)
 		ice_gnss_exit(pf);
 	if (test_bit(ICE_FLAG_PTP_SUPPORTED, pf->flags))
 		ice_ptp_release(pf);
+	if (ice_is_feature_supported(pf, ICE_F_PHY_RCLK) ||
+	    ice_is_feature_supported(pf, ICE_F_CGU))
+		ice_dpll_release(pf);
 }
 
 static void ice_init_wakeup(struct ice_pf *pf)
-- 
2.34.1

