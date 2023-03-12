Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C82B6B62EC
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 03:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjCLC2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 21:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjCLC2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 21:28:49 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870C934327;
        Sat, 11 Mar 2023 18:28:46 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32BK7wL0004410;
        Sat, 11 Mar 2023 18:28:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=ggbvdIb1jxpDfp7KaumFFjElGm6Nvg9XcVu+wvvPnlQ=;
 b=SEoc4CB3+fNTGaIaWPpJVLU1m9ctfuLFAOcHJDnGNqyysDZr4DQHNv8H/Jiv0z7yIi2w
 61ipbKy0vhmY4OIapNuo467PAH6piZFNuc9pEhkp2QgOH+h/758n44TjJEhtdBdBiof/
 UUcoODGL+/GTouGIWjlVxwvEEOnxXJwb0xD54hNKkapUF4XtLZWggIfvDhObUvvrwgVl
 mtLy5cUhzALYU06TjVIGdQqv2JOqVr09YqjbvjBsACGmCy4JRkRD6l2tbR2CTVx8TlCs
 //U0lo7RyaudzP4csRmUCe4JywrfgMIZS+SZ6TTD8gKqdIAdfRji1Putq7mVVGWAVFlN kA== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3p8r25h4bd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 11 Mar 2023 18:28:31 -0800
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Sat, 11 Mar 2023 18:28:30 -0800
Received: from devvm1736.cln0.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server id
 15.1.2507.17; Sat, 11 Mar 2023 18:28:28 -0800
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        Vadim Fedorenko <vadfed@meta.com>, <poros@redhat.com>,
        <mschmidt@redhat.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-clk@vger.kernel.org>
Subject: [PATCH RFC v6 6/6] ptp_ocp: implement DPLL ops
Date:   Sat, 11 Mar 2023 18:28:07 -0800
Message-ID: <20230312022807.278528-7-vadfed@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230312022807.278528-1-vadfed@meta.com>
References: <20230312022807.278528-1-vadfed@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c0a8:1b::d]
X-Proofpoint-GUID: LGcuQrBwPad_9xncnzpnhpW2xR2RN_Jf
X-Proofpoint-ORIG-GUID: LGcuQrBwPad_9xncnzpnhpW2xR2RN_Jf
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

Implement basic DPLL operations in ptp_ocp driver as the
simplest example of using new subsystem.

Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
---
 drivers/ptp/Kconfig   |   1 +
 drivers/ptp/ptp_ocp.c | 209 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 200 insertions(+), 10 deletions(-)

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index fe4971b65c64..8c4cfabc1bfa 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -177,6 +177,7 @@ config PTP_1588_CLOCK_OCP
 	depends on COMMON_CLK
 	select NET_DEVLINK
 	select CRC16
+	select DPLL
 	help
 	  This driver adds support for an OpenCompute time card.
 
diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 4bbaccd543ad..02c95e724ec8 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -23,6 +23,8 @@
 #include <linux/mtd/mtd.h>
 #include <linux/nvmem-consumer.h>
 #include <linux/crc16.h>
+#include <linux/dpll.h>
+#include <uapi/linux/dpll.h>
 
 #define PCI_VENDOR_ID_FACEBOOK			0x1d9b
 #define PCI_DEVICE_ID_FACEBOOK_TIMECARD		0x0400
@@ -267,6 +269,7 @@ struct ptp_ocp_sma_connector {
 	bool	fixed_dir;
 	bool	disabled;
 	u8	default_fcn;
+	struct dpll_pin *dpll_pin;
 };
 
 struct ocp_attr_group {
@@ -353,6 +356,7 @@ struct ptp_ocp {
 	struct ptp_ocp_signal	signal[4];
 	struct ptp_ocp_sma_connector sma[4];
 	const struct ocp_sma_op *sma_op;
+	struct dpll_device *dpll;
 };
 
 #define OCP_REQ_TIMESTAMP	BIT(0)
@@ -2689,16 +2693,9 @@ sma4_show(struct device *dev, struct device_attribute *attr, char *buf)
 }
 
 static int
-ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
+ptp_ocp_sma_store_val(struct ptp_ocp *bp, int val, enum ptp_ocp_sma_mode mode, int sma_nr)
 {
 	struct ptp_ocp_sma_connector *sma = &bp->sma[sma_nr - 1];
-	enum ptp_ocp_sma_mode mode;
-	int val;
-
-	mode = sma->mode;
-	val = sma_parse_inputs(bp->sma_op->tbl, buf, &mode);
-	if (val < 0)
-		return val;
 
 	if (sma->fixed_dir && (mode != sma->mode || val & SMA_DISABLE))
 		return -EOPNOTSUPP;
@@ -2733,6 +2730,21 @@ ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
 	return val;
 }
 
+static int
+ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
+{
+	struct ptp_ocp_sma_connector *sma = &bp->sma[sma_nr - 1];
+	enum ptp_ocp_sma_mode mode;
+	int val;
+
+	mode = sma->mode;
+	val = sma_parse_inputs(bp->sma_op->tbl, buf, &mode);
+	if (val < 0)
+		return val;
+
+	return ptp_ocp_sma_store_val(bp, val, mode, sma_nr);
+}
+
 static ssize_t
 sma1_store(struct device *dev, struct device_attribute *attr,
 	   const char *buf, size_t count)
@@ -4171,12 +4183,151 @@ ptp_ocp_detach(struct ptp_ocp *bp)
 	device_unregister(&bp->dev);
 }
 
+static int ptp_ocp_dpll_pin_to_sma(const struct ptp_ocp *bp, const struct dpll_pin *pin)
+{
+	int i;
+
+	for (i = 0; i < 4; i++) {
+		if (bp->sma[i].dpll_pin == pin)
+			return i;
+	}
+	return -1;
+}
+
+static int ptp_ocp_dpll_lock_status_get(const struct dpll_device *dpll,
+				    enum dpll_lock_status *status,
+				    struct netlink_ext_ack *extack)
+{
+	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
+	int sync;
+
+	sync = ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
+	*status = sync ? DPLL_LOCK_STATUS_LOCKED : DPLL_LOCK_STATUS_UNLOCKED;
+
+	return 0;
+}
+
+static int ptp_ocp_dpll_source_idx_get(const struct dpll_device *dpll,
+				    u32 *idx, struct netlink_ext_ack *extack)
+{
+	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
+
+	if (bp->pps_select) {
+		*idx = ioread32(&bp->pps_select->gpio1);
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static int ptp_ocp_dpll_mode_get(const struct dpll_device *dpll,
+				    u32 *mode, struct netlink_ext_ack *extack)
+{
+	*mode = DPLL_MODE_AUTOMATIC;
+
+	return 0;
+}
+
+static bool ptp_ocp_dpll_mode_supported(const struct dpll_device *dpll,
+				    const enum dpll_mode mode,
+				    struct netlink_ext_ack *extack)
+{
+	if (mode == DPLL_MODE_AUTOMATIC)
+		return true;
+
+	return false;
+}
+
+static int ptp_ocp_dpll_direction_get(const struct dpll_pin *pin,
+				     const struct dpll_device *dpll,
+				     enum dpll_pin_direction *direction,
+				     struct netlink_ext_ack *extack)
+{
+	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
+	int sma_nr = ptp_ocp_dpll_pin_to_sma(bp, pin);
+
+	if (sma_nr < 0)
+		return -EINVAL;
+
+	*direction = bp->sma[sma_nr].mode == SMA_MODE_IN ? DPLL_PIN_DIRECTION_SOURCE :
+							   DPLL_PIN_DIRECTION_OUTPUT;
+	return 0;
+}
+
+static int ptp_ocp_dpll_direction_set(const struct dpll_pin *pin,
+				     const struct dpll_device *dpll,
+				     enum dpll_pin_direction direction,
+				     struct netlink_ext_ack *extack)
+{
+	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
+	int sma_nr = ptp_ocp_dpll_pin_to_sma(bp, pin);
+	enum ptp_ocp_sma_mode mode;
+
+	if (sma_nr < 0)
+		return -EINVAL;
+
+	mode = direction == DPLL_PIN_DIRECTION_SOURCE ? SMA_MODE_IN : SMA_MODE_OUT;
+	return ptp_ocp_sma_store_val(bp, 0, mode, sma_nr);
+}
+
+static int ptp_ocp_dpll_frequency_set(const struct dpll_pin *pin,
+			      const struct dpll_device *dpll,
+			      const u32 frequency,
+			      struct netlink_ext_ack *extack)
+{
+	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
+	int sma_nr = ptp_ocp_dpll_pin_to_sma(bp, pin);
+	int val = frequency == 10000000 ? 0 : 1;
+
+	if (sma_nr < 0)
+		return -EINVAL;
+
+
+	return ptp_ocp_sma_store_val(bp, val, bp->sma[sma_nr].mode, sma_nr);
+}
+
+static int ptp_ocp_dpll_frequency_get(const struct dpll_pin *pin,
+			      const struct dpll_device *dpll,
+			      u32 *frequency,
+			      struct netlink_ext_ack *extack)
+{
+	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
+	int sma_nr = ptp_ocp_dpll_pin_to_sma(bp, pin);
+	u32 val;
+
+	if (sma_nr < 0)
+		return -EINVAL;
+
+	val = bp->sma_op->get(bp, sma_nr);
+	if (!val)
+		*frequency = 1000000;
+	else
+		*frequency = 0;
+	return 0;
+}
+
+static struct dpll_device_ops dpll_ops = {
+	.lock_status_get = ptp_ocp_dpll_lock_status_get,
+	.source_pin_idx_get = ptp_ocp_dpll_source_idx_get,
+	.mode_get = ptp_ocp_dpll_mode_get,
+	.mode_supported = ptp_ocp_dpll_mode_supported,
+};
+
+static struct dpll_pin_ops dpll_pins_ops = {
+	.frequency_get = ptp_ocp_dpll_frequency_get,
+	.frequency_set = ptp_ocp_dpll_frequency_set,
+	.direction_get = ptp_ocp_dpll_direction_get,
+	.direction_set = ptp_ocp_dpll_direction_set,
+};
+
 static int
 ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
+	struct dpll_pin_properties prop;
 	struct devlink *devlink;
+	char sma[4] = "SMA0";
 	struct ptp_ocp *bp;
-	int err;
+	int err, i;
+	u64 clkid;
 
 	devlink = devlink_alloc(&ptp_ocp_devlink_ops, sizeof(*bp), &pdev->dev);
 	if (!devlink) {
@@ -4226,8 +4377,44 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ptp_ocp_info(bp);
 	devlink_register(devlink);
-	return 0;
 
+	clkid = pci_get_dsn(pdev);
+	bp->dpll = dpll_device_get(clkid, 0, THIS_MODULE);
+	if (!bp->dpll) {
+		dev_err(&pdev->dev, "dpll_device_alloc failed\n");
+		goto out;
+	}
+
+	err = dpll_device_register(bp->dpll, DPLL_TYPE_PPS, &dpll_ops, bp, &pdev->dev);
+	if (err)
+		goto out;
+
+	prop.description = &sma[0];
+	prop.freq_supported = DPLL_PIN_FREQ_SUPP_MAX;
+	prop.type = DPLL_PIN_TYPE_EXT;
+	prop.any_freq_max = 10000000;
+	prop.any_freq_min = 0;
+	prop.capabilities = DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE;
+
+	for (i = 0; i < 4; i++) {
+		sma[3] = 0x31 + i;
+		bp->sma[i].dpll_pin = dpll_pin_get(clkid, i, THIS_MODULE, &prop);
+		if (IS_ERR_OR_NULL(bp->sma[i].dpll_pin)) {
+			bp->sma[i].dpll_pin = NULL;
+			goto out_dpll;
+		}
+		err = dpll_pin_register(bp->dpll, bp->sma[i].dpll_pin, &dpll_pins_ops, bp, NULL);
+		if (err)
+			goto out_dpll;
+	}
+
+	return 0;
+out_dpll:
+	for (i = 0; i < 4; i++) {
+		if (bp->sma[i].dpll_pin)
+			dpll_pin_put(bp->sma[i].dpll_pin);
+	}
+	dpll_device_put(bp->dpll);
 out:
 	ptp_ocp_detach(bp);
 out_disable:
@@ -4243,6 +4430,8 @@ ptp_ocp_remove(struct pci_dev *pdev)
 	struct ptp_ocp *bp = pci_get_drvdata(pdev);
 	struct devlink *devlink = priv_to_devlink(bp);
 
+	dpll_device_unregister(bp->dpll);
+	dpll_device_put(bp->dpll);
 	devlink_unregister(devlink);
 	ptp_ocp_detach(bp);
 	pci_disable_device(pdev);
-- 
2.34.1

