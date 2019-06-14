Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E26045A92
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 12:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbfFNKjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 06:39:21 -0400
Received: from inva020.nxp.com ([92.121.34.13]:55802 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727365AbfFNKjT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 06:39:19 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 3BAB41A061A;
        Fri, 14 Jun 2019 12:39:17 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 7DCEB1A0629;
        Fri, 14 Jun 2019 12:39:12 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 4BE6140319;
        Fri, 14 Jun 2019 18:39:06 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>
Subject: [v2, 5/6] dpaa2-ptp: add interrupt support
Date:   Fri, 14 Jun 2019 18:40:54 +0800
Message-Id: <20190614104055.43998-6-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190614104055.43998-1-yangbo.lu@nxp.com>
References: <20190614104055.43998-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add interrupt support for dpaa2 ptp clock,
including MC APIs and PPS interrupt support. Other events
haven't been supported in MC by now.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- None.
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c | 110 +++++++++++-
 drivers/net/ethernet/freescale/dpaa2/dprtc-cmd.h |  45 +++++
 drivers/net/ethernet/freescale/dpaa2/dprtc.c     | 219 +++++++++++++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dprtc.h     |  44 +++++
 4 files changed, 417 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
index 6c57e17..a9503ae 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
@@ -7,11 +7,55 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/msi.h>
 #include <linux/fsl/mc.h>
 #include <linux/fsl/ptp_qoriq.h>
 
 #include "dpaa2-ptp.h"
 
+static int dpaa2_ptp_enable(struct ptp_clock_info *ptp,
+			    struct ptp_clock_request *rq, int on)
+{
+	struct ptp_qoriq *ptp_qoriq = container_of(ptp, struct ptp_qoriq, caps);
+	struct fsl_mc_device *mc_dev;
+	struct device *dev;
+	u32 mask = 0;
+	u32 bit;
+	int err;
+
+	dev = ptp_qoriq->dev;
+	mc_dev = to_fsl_mc_device(dev);
+
+	switch (rq->type) {
+	case PTP_CLK_REQ_PPS:
+		bit = DPRTC_EVENT_PPS;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	err = dprtc_get_irq_mask(mc_dev->mc_io, 0, mc_dev->mc_handle,
+				 DPRTC_IRQ_INDEX, &mask);
+	if (err < 0) {
+		dev_err(dev, "dprtc_get_irq_mask(): %d\n", err);
+		return err;
+	}
+
+	if (on)
+		mask |= bit;
+	else
+		mask &= ~bit;
+
+	err = dprtc_set_irq_mask(mc_dev->mc_io, 0, mc_dev->mc_handle,
+				 DPRTC_IRQ_INDEX, mask);
+	if (err < 0) {
+		dev_err(dev, "dprtc_set_irq_mask(): %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
 static const struct ptp_clock_info dpaa2_ptp_caps = {
 	.owner		= THIS_MODULE,
 	.name		= "DPAA2 PTP Clock",
@@ -25,11 +69,47 @@ static const struct ptp_clock_info dpaa2_ptp_caps = {
 	.adjtime	= ptp_qoriq_adjtime,
 	.gettime64	= ptp_qoriq_gettime,
 	.settime64	= ptp_qoriq_settime,
+	.enable		= dpaa2_ptp_enable,
 };
 
+static irqreturn_t dpaa2_ptp_irq_handler_thread(int irq, void *priv)
+{
+	struct ptp_qoriq *ptp_qoriq = priv;
+	struct ptp_clock_event event;
+	struct fsl_mc_device *mc_dev;
+	struct device *dev;
+	u32 status = 0;
+	int err;
+
+	dev = ptp_qoriq->dev;
+	mc_dev = to_fsl_mc_device(dev);
+
+	err = dprtc_get_irq_status(mc_dev->mc_io, 0, mc_dev->mc_handle,
+				   DPRTC_IRQ_INDEX, &status);
+	if (unlikely(err)) {
+		dev_err(dev, "dprtc_get_irq_status err %d\n", err);
+		return IRQ_NONE;
+	}
+
+	if (status & DPRTC_EVENT_PPS) {
+		event.type = PTP_CLOCK_PPS;
+		ptp_clock_event(ptp_qoriq->clock, &event);
+	}
+
+	err = dprtc_clear_irq_status(mc_dev->mc_io, 0, mc_dev->mc_handle,
+				     DPRTC_IRQ_INDEX, status);
+	if (unlikely(err)) {
+		dev_err(dev, "dprtc_clear_irq_status err %d\n", err);
+		return IRQ_NONE;
+	}
+
+	return IRQ_HANDLED;
+}
+
 static int dpaa2_ptp_probe(struct fsl_mc_device *mc_dev)
 {
 	struct device *dev = &mc_dev->dev;
+	struct fsl_mc_device_irq *irq;
 	struct ptp_qoriq *ptp_qoriq;
 	struct device_node *node;
 	void __iomem *base;
@@ -71,15 +151,42 @@ static int dpaa2_ptp_probe(struct fsl_mc_device *mc_dev)
 		goto err_close;
 	}
 
+	err = fsl_mc_allocate_irqs(mc_dev);
+	if (err) {
+		dev_err(dev, "MC irqs allocation failed\n");
+		goto err_unmap;
+	}
+
+	irq = mc_dev->irqs[0];
+	ptp_qoriq->irq = irq->msi_desc->irq;
+
+	err = devm_request_threaded_irq(dev, ptp_qoriq->irq, NULL,
+					dpaa2_ptp_irq_handler_thread,
+					IRQF_NO_SUSPEND | IRQF_ONESHOT,
+					dev_name(dev), ptp_qoriq);
+	if (err < 0) {
+		dev_err(dev, "devm_request_threaded_irq(): %d\n", err);
+		goto err_free_mc_irq;
+	}
+
+	err = dprtc_set_irq_enable(mc_dev->mc_io, 0, mc_dev->mc_handle,
+				   DPRTC_IRQ_INDEX, 1);
+	if (err < 0) {
+		dev_err(dev, "dprtc_set_irq_enable(): %d\n", err);
+		goto err_free_mc_irq;
+	}
+
 	err = ptp_qoriq_init(ptp_qoriq, base, &dpaa2_ptp_caps);
 	if (err)
-		goto err_unmap;
+		goto err_free_mc_irq;
 
 	dpaa2_phc_index = ptp_qoriq->phc_index;
 	dev_set_drvdata(dev, ptp_qoriq);
 
 	return 0;
 
+err_free_mc_irq:
+	fsl_mc_free_irqs(mc_dev);
 err_unmap:
 	iounmap(base);
 err_close:
@@ -100,6 +207,7 @@ static int dpaa2_ptp_remove(struct fsl_mc_device *mc_dev)
 	dpaa2_phc_index = -1;
 	ptp_qoriq_free(ptp_qoriq);
 
+	fsl_mc_free_irqs(mc_dev);
 	dprtc_close(mc_dev->mc_io, 0, mc_dev->mc_handle);
 	fsl_mc_portal_free(mc_dev->mc_io);
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dprtc-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dprtc-cmd.h
index dd74aa9..720cd50 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dprtc-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dprtc-cmd.h
@@ -17,11 +17,56 @@
 #define DPRTC_CMDID_CLOSE			DPRTC_CMD(0x800)
 #define DPRTC_CMDID_OPEN			DPRTC_CMD(0x810)
 
+#define DPRTC_CMDID_SET_IRQ_ENABLE		DPRTC_CMD(0x012)
+#define DPRTC_CMDID_GET_IRQ_ENABLE		DPRTC_CMD(0x013)
+#define DPRTC_CMDID_SET_IRQ_MASK		DPRTC_CMD(0x014)
+#define DPRTC_CMDID_GET_IRQ_MASK		DPRTC_CMD(0x015)
+#define DPRTC_CMDID_GET_IRQ_STATUS		DPRTC_CMD(0x016)
+#define DPRTC_CMDID_CLEAR_IRQ_STATUS		DPRTC_CMD(0x017)
+
 #pragma pack(push, 1)
 struct dprtc_cmd_open {
 	__le32 dprtc_id;
 };
 
+struct dprtc_cmd_get_irq {
+	__le32 pad;
+	u8 irq_index;
+};
+
+struct dprtc_cmd_set_irq_enable {
+	u8 en;
+	u8 pad[3];
+	u8 irq_index;
+};
+
+struct dprtc_rsp_get_irq_enable {
+	u8 en;
+};
+
+struct dprtc_cmd_set_irq_mask {
+	__le32 mask;
+	u8 irq_index;
+};
+
+struct dprtc_rsp_get_irq_mask {
+	__le32 mask;
+};
+
+struct dprtc_cmd_get_irq_status {
+	__le32 status;
+	u8 irq_index;
+};
+
+struct dprtc_rsp_get_irq_status {
+	__le32 status;
+};
+
+struct dprtc_cmd_clear_irq_status {
+	__le32 status;
+	u8 irq_index;
+};
+
 #pragma pack(pop)
 
 #endif /* _FSL_DPRTC_CMD_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dprtc.c b/drivers/net/ethernet/freescale/dpaa2/dprtc.c
index 1ae303e..ed52a34 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dprtc.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dprtc.c
@@ -72,3 +72,222 @@ int dprtc_close(struct fsl_mc_io *mc_io,
 
 	return mc_send_command(mc_io, &cmd);
 }
+
+/**
+ * dprtc_set_irq_enable() - Set overall interrupt state.
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPRTC object
+ * @irq_index:	The interrupt index to configure
+ * @en:		Interrupt state - enable = 1, disable = 0
+ *
+ * Allows GPP software to control when interrupts are generated.
+ * Each interrupt can have up to 32 causes.  The enable/disable control's the
+ * overall interrupt state. if the interrupt is disabled no causes will cause
+ * an interrupt.
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dprtc_set_irq_enable(struct fsl_mc_io *mc_io,
+			 u32 cmd_flags,
+			 u16 token,
+			 u8 irq_index,
+			 u8 en)
+{
+	struct dprtc_cmd_set_irq_enable *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPRTC_CMDID_SET_IRQ_ENABLE,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dprtc_cmd_set_irq_enable *)cmd.params;
+	cmd_params->irq_index = irq_index;
+	cmd_params->en = en;
+
+	return mc_send_command(mc_io, &cmd);
+}
+
+/**
+ * dprtc_get_irq_enable() - Get overall interrupt state
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPRTC object
+ * @irq_index:	The interrupt index to configure
+ * @en:		Returned interrupt state - enable = 1, disable = 0
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dprtc_get_irq_enable(struct fsl_mc_io *mc_io,
+			 u32 cmd_flags,
+			 u16 token,
+			 u8 irq_index,
+			 u8 *en)
+{
+	struct dprtc_rsp_get_irq_enable *rsp_params;
+	struct dprtc_cmd_get_irq *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+	int err;
+
+	cmd.header = mc_encode_cmd_header(DPRTC_CMDID_GET_IRQ_ENABLE,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dprtc_cmd_get_irq *)cmd.params;
+	cmd_params->irq_index = irq_index;
+
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	rsp_params = (struct dprtc_rsp_get_irq_enable *)cmd.params;
+	*en = rsp_params->en;
+
+	return 0;
+}
+
+/**
+ * dprtc_set_irq_mask() - Set interrupt mask.
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPRTC object
+ * @irq_index:	The interrupt index to configure
+ * @mask:	Event mask to trigger interrupt;
+ *		each bit:
+ *			0 = ignore event
+ *			1 = consider event for asserting IRQ
+ *
+ * Every interrupt can have up to 32 causes and the interrupt model supports
+ * masking/unmasking each cause independently
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dprtc_set_irq_mask(struct fsl_mc_io *mc_io,
+		       u32 cmd_flags,
+		       u16 token,
+		       u8 irq_index,
+		       u32 mask)
+{
+	struct dprtc_cmd_set_irq_mask *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPRTC_CMDID_SET_IRQ_MASK,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dprtc_cmd_set_irq_mask *)cmd.params;
+	cmd_params->mask = cpu_to_le32(mask);
+	cmd_params->irq_index = irq_index;
+
+	return mc_send_command(mc_io, &cmd);
+}
+
+/**
+ * dprtc_get_irq_mask() - Get interrupt mask.
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPRTC object
+ * @irq_index:	The interrupt index to configure
+ * @mask:	Returned event mask to trigger interrupt
+ *
+ * Every interrupt can have up to 32 causes and the interrupt model supports
+ * masking/unmasking each cause independently
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dprtc_get_irq_mask(struct fsl_mc_io *mc_io,
+		       u32 cmd_flags,
+		       u16 token,
+		       u8 irq_index,
+		       u32 *mask)
+{
+	struct dprtc_rsp_get_irq_mask *rsp_params;
+	struct dprtc_cmd_get_irq *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+	int err;
+
+	cmd.header = mc_encode_cmd_header(DPRTC_CMDID_GET_IRQ_MASK,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dprtc_cmd_get_irq *)cmd.params;
+	cmd_params->irq_index = irq_index;
+
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	rsp_params = (struct dprtc_rsp_get_irq_mask *)cmd.params;
+	*mask = le32_to_cpu(rsp_params->mask);
+
+	return 0;
+}
+
+/**
+ * dprtc_get_irq_status() - Get the current status of any pending interrupts.
+ *
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPRTC object
+ * @irq_index:	The interrupt index to configure
+ * @status:	Returned interrupts status - one bit per cause:
+ *			0 = no interrupt pending
+ *			1 = interrupt pending
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dprtc_get_irq_status(struct fsl_mc_io *mc_io,
+			 u32 cmd_flags,
+			 u16 token,
+			 u8 irq_index,
+			 u32 *status)
+{
+	struct dprtc_cmd_get_irq_status *cmd_params;
+	struct dprtc_rsp_get_irq_status *rsp_params;
+	struct fsl_mc_command cmd = { 0 };
+	int err;
+
+	cmd.header = mc_encode_cmd_header(DPRTC_CMDID_GET_IRQ_STATUS,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dprtc_cmd_get_irq_status *)cmd.params;
+	cmd_params->status = cpu_to_le32(*status);
+	cmd_params->irq_index = irq_index;
+
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	rsp_params = (struct dprtc_rsp_get_irq_status *)cmd.params;
+	*status = le32_to_cpu(rsp_params->status);
+
+	return 0;
+}
+
+/**
+ * dprtc_clear_irq_status() - Clear a pending interrupt's status
+ *
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPRTC object
+ * @irq_index:	The interrupt index to configure
+ * @status:	Bits to clear (W1C) - one bit per cause:
+ *			0 = don't change
+ *			1 = clear status bit
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dprtc_clear_irq_status(struct fsl_mc_io *mc_io,
+			   u32 cmd_flags,
+			   u16 token,
+			   u8 irq_index,
+			   u32 status)
+{
+	struct dprtc_cmd_clear_irq_status *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPRTC_CMDID_CLEAR_IRQ_STATUS,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dprtc_cmd_clear_irq_status *)cmd.params;
+	cmd_params->irq_index = irq_index;
+	cmd_params->status = cpu_to_le32(status);
+
+	return mc_send_command(mc_io, &cmd);
+}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dprtc.h b/drivers/net/ethernet/freescale/dpaa2/dprtc.h
index c2d508b..be7914c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dprtc.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dprtc.h
@@ -13,6 +13,14 @@
 
 struct fsl_mc_io;
 
+/**
+ * Number of irq's
+ */
+#define DPRTC_MAX_IRQ_NUM	1
+#define DPRTC_IRQ_INDEX		0
+
+#define DPRTC_EVENT_PPS		0x08000000
+
 int dprtc_open(struct fsl_mc_io *mc_io,
 	       u32 cmd_flags,
 	       int dprtc_id,
@@ -22,4 +30,40 @@ int dprtc_close(struct fsl_mc_io *mc_io,
 		u32 cmd_flags,
 		u16 token);
 
+int dprtc_set_irq_enable(struct fsl_mc_io *mc_io,
+			 u32 cmd_flags,
+			 u16 token,
+			 u8 irq_index,
+			 u8 en);
+
+int dprtc_get_irq_enable(struct fsl_mc_io *mc_io,
+			 u32 cmd_flags,
+			 u16 token,
+			 u8 irq_index,
+			 u8 *en);
+
+int dprtc_set_irq_mask(struct fsl_mc_io *mc_io,
+		       u32 cmd_flags,
+		       u16 token,
+		       u8 irq_index,
+		       u32 mask);
+
+int dprtc_get_irq_mask(struct fsl_mc_io *mc_io,
+		       u32 cmd_flags,
+		       u16 token,
+		       u8 irq_index,
+		       u32 *mask);
+
+int dprtc_get_irq_status(struct fsl_mc_io *mc_io,
+			 u32 cmd_flags,
+			 u16 token,
+			 u8 irq_index,
+			 u32 *status);
+
+int dprtc_clear_irq_status(struct fsl_mc_io *mc_io,
+			   u32 cmd_flags,
+			   u16 token,
+			   u8 irq_index,
+			   u32 status);
+
 #endif /* __FSL_DPRTC_H */
-- 
2.7.4

