Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE614505C
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 01:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfFMX4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 19:56:42 -0400
Received: from inva020.nxp.com ([92.121.34.13]:37800 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726881AbfFMX4g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 19:56:36 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id CE1D31A00CE;
        Fri, 14 Jun 2019 01:56:32 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id BE9C81A0030;
        Fri, 14 Jun 2019 01:56:32 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 54F67205DC;
        Fri, 14 Jun 2019 01:56:32 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     linux@armlinux.org.uk, hkallweit1@gmail.com, f.fainelli@gmail.com,
        andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org, alexandru.marginean@nxp.com,
        ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH RFC 3/6] dpaa2-mac: add MC API for the DPMAC object
Date:   Fri, 14 Jun 2019 02:55:50 +0300
Message-Id: <1560470153-26155-4-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
References: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the necessary MC API for the DPMAC object. These functions will be
used in the initial patch that adds the dpaa2-mac driver.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h | 107 +++++++
 drivers/net/ethernet/freescale/dpaa2/dpmac.c     | 369 +++++++++++++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpmac.h     | 210 +++++++++++++
 3 files changed, 686 insertions(+)
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpmac.c
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpmac.h

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
new file mode 100644
index 000000000000..d35f05b32275
--- /dev/null
+++ b/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
@@ -0,0 +1,107 @@
+/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
+/* Copyright 2013-2016 Freescale Semiconductor Inc.
+ * Copyright 2019 NXP
+ */
+#ifndef _FSL_DPMAC_CMD_H
+#define _FSL_DPMAC_CMD_H
+
+/* DPMAC Version */
+#define DPMAC_VER_MAJOR				4
+#define DPMAC_VER_MINOR				4
+#define DPMAC_CMD_BASE_VERSION			1
+#define DPMAC_CMD_2ND_VERSION			2
+#define DPMAC_CMD_ID_OFFSET			4
+
+#define DPMAC_CMD(id)	(((id) << DPMAC_CMD_ID_OFFSET) | DPMAC_CMD_BASE_VERSION)
+#define DPMAC_CMD_V2(id) (((id) << DPMAC_CMD_ID_OFFSET) | DPMAC_CMD_2ND_VERSION)
+
+/* Command IDs */
+#define DPMAC_CMDID_CLOSE		DPMAC_CMD(0x800)
+#define DPMAC_CMDID_OPEN		DPMAC_CMD(0x80c)
+#define DPMAC_CMDID_GET_API_VERSION	DPMAC_CMD(0xa0c)
+
+#define DPMAC_CMDID_GET_ATTR		DPMAC_CMD(0x004)
+
+#define DPMAC_CMDID_SET_IRQ_ENABLE	DPMAC_CMD(0x012)
+#define DPMAC_CMDID_SET_IRQ_MASK	DPMAC_CMD(0x014)
+#define DPMAC_CMDID_GET_IRQ_STATUS	DPMAC_CMD(0x016)
+#define DPMAC_CMDID_CLEAR_IRQ_STATUS	DPMAC_CMD(0x017)
+
+#define DPMAC_CMDID_GET_LINK_CFG	DPMAC_CMD_V2(0x0c2)
+#define DPMAC_CMDID_SET_LINK_STATE	DPMAC_CMD_V2(0x0c3)
+
+/* Macros for accessing command fields smaller than 1byte */
+#define DPMAC_MASK(field)        \
+	GENMASK(DPMAC_##field##_SHIFT + DPMAC_##field##_SIZE - 1, \
+		DPMAC_##field##_SHIFT)
+
+#define dpmac_set_field(var, field, val) \
+	((var) |= (((val) << DPMAC_##field##_SHIFT) & DPMAC_MASK(field)))
+#define dpmac_get_field(var, field)      \
+	(((var) & DPMAC_MASK(field)) >> DPMAC_##field##_SHIFT)
+
+struct dpmac_cmd_open {
+	__le32 dpmac_id;
+};
+
+struct dpmac_cmd_set_irq_enable {
+	u8 enable;
+	u8 pad[3];
+	u8 irq_index;
+};
+
+struct dpmac_cmd_set_irq_mask {
+	__le32 mask;
+	u8 irq_index;
+};
+
+struct dpmac_cmd_get_irq_status {
+	__le32 status;
+	u8 irq_index;
+};
+
+struct dpmac_rsp_get_irq_status {
+	__le32 status;
+};
+
+struct dpmac_cmd_clear_irq_status {
+	__le32 status;
+	u8 irq_index;
+};
+
+struct dpmac_rsp_get_attributes {
+	u8 eth_if;
+	u8 link_type;
+	__le16 id;
+	__le32 max_rate;
+};
+
+struct dpmac_rsp_get_link_cfg {
+	__le64 options;
+	__le32 rate;
+	__le32 pad;
+	__le64 advertising;
+};
+
+#define DPMAC_STATE_SIZE	1
+#define DPMAC_STATE_SHIFT	0
+#define DPMAC_STATE_VALID_SIZE	1
+#define DPMAC_STATE_VALID_SHIFT	1
+
+struct dpmac_cmd_set_link_state {
+	__le64 options;
+	__le32 rate;
+	__le32 pad0;
+	/* from lsb: up:1, state_valid:1 */
+	u8 state;
+	u8 pad1[7];
+	__le64 supported;
+	__le64 advertising;
+};
+
+struct dpmac_rsp_get_api_version {
+	__le16 major;
+	__le16 minor;
+};
+
+#endif /* _FSL_DPMAC_CMD_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac.c b/drivers/net/ethernet/freescale/dpaa2/dpmac.c
new file mode 100644
index 000000000000..b45a4bd60efc
--- /dev/null
+++ b/drivers/net/ethernet/freescale/dpaa2/dpmac.c
@@ -0,0 +1,369 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/* Copyright 2013-2016 Freescale Semiconductor Inc.
+ * Copyright 2019 NXP
+ */
+#include <linux/fsl/mc.h>
+#include "dpmac.h"
+#include "dpmac-cmd.h"
+
+/**
+ * dpmac_open() - Open a control session for the specified object.
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @dpmac_id:	DPMAC unique ID
+ * @token:	Returned token; use in subsequent API calls
+ *
+ * This function can be used to open a control session for an
+ * already created object; an object may have been declared in
+ * the DPL or by calling the dpmac_create function.
+ * This function returns a unique authentication token,
+ * associated with the specific object ID and the specific MC
+ * portal; this token must be used in all subsequent commands for
+ * this specific object
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpmac_open(struct fsl_mc_io *mc_io,
+	       u32 cmd_flags,
+	       int dpmac_id,
+	       u16 *token)
+{
+	struct dpmac_cmd_open *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+	int err;
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMAC_CMDID_OPEN,
+					  cmd_flags,
+					  0);
+	cmd_params = (struct dpmac_cmd_open *)cmd.params;
+	cmd_params->dpmac_id = cpu_to_le32(dpmac_id);
+
+	/* send command to mc*/
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	/* retrieve response parameters */
+	*token = mc_cmd_hdr_read_token(&cmd);
+
+	return err;
+}
+
+/**
+ * dpmac_close() - Close the control session of the object
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPMAC object
+ *
+ * After this function is called, no further operations are
+ * allowed on the object without opening a new control session.
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpmac_close(struct fsl_mc_io *mc_io,
+		u32 cmd_flags,
+		u16 token)
+{
+	struct fsl_mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMAC_CMDID_CLOSE, cmd_flags,
+					  token);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+
+/**
+ * dpmac_set_irq_enable() - Set overall interrupt state.
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPMAC object
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
+int dpmac_set_irq_enable(struct fsl_mc_io *mc_io,
+			 u32 cmd_flags,
+			 u16 token,
+			 u8 irq_index,
+			 u8 en)
+{
+	struct dpmac_cmd_set_irq_enable *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMAC_CMDID_SET_IRQ_ENABLE,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dpmac_cmd_set_irq_enable *)cmd.params;
+	cmd_params->irq_index = irq_index;
+	cmd_params->enable = en;
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+
+/**
+ * dpmac_set_irq_mask() - Set interrupt mask.
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPMAC object
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
+int dpmac_set_irq_mask(struct fsl_mc_io *mc_io,
+		       u32 cmd_flags,
+		       u16 token,
+		       u8 irq_index,
+		       u32 mask)
+{
+	struct dpmac_cmd_set_irq_mask *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMAC_CMDID_SET_IRQ_MASK,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dpmac_cmd_set_irq_mask *)cmd.params;
+	cmd_params->mask = cpu_to_le32(mask);
+	cmd_params->irq_index = irq_index;
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+
+/**
+ * dpmac_get_irq_status() - Get the current status of any pending interrupts.
+ *
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPMAC object
+ * @irq_index:	The interrupt index to configure
+ * @status:	Returned interrupts status - one bit per cause:
+ *			0 = no interrupt pending
+ *			1 = interrupt pending
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpmac_get_irq_status(struct fsl_mc_io *mc_io,
+			 u32 cmd_flags,
+			 u16 token,
+			 u8 irq_index,
+			 u32 *status)
+{
+	struct dpmac_cmd_get_irq_status *cmd_params;
+	struct dpmac_rsp_get_irq_status *rsp_params;
+	struct fsl_mc_command cmd = { 0 };
+	int err;
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMAC_CMDID_GET_IRQ_STATUS,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dpmac_cmd_get_irq_status *)cmd.params;
+	cmd_params->status = cpu_to_le32(*status);
+	cmd_params->irq_index = irq_index;
+
+	/* send command to mc*/
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	/* retrieve response parameters */
+	rsp_params = (struct dpmac_rsp_get_irq_status *)cmd.params;
+	*status = le32_to_cpu(rsp_params->status);
+
+	return 0;
+}
+
+/**
+ * dpmac_clear_irq_status() - Clear a pending interrupt's status
+ *
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPMAC object
+ * @irq_index:	The interrupt index to configure
+ * @status:	Bits to clear (W1C) - one bit per cause:
+ *			0 = don't change
+ *			1 = clear status bit
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpmac_clear_irq_status(struct fsl_mc_io *mc_io,
+			   u32 cmd_flags,
+			   u16 token,
+			   u8 irq_index,
+			   u32 status)
+{
+	struct dpmac_cmd_clear_irq_status *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMAC_CMDID_CLEAR_IRQ_STATUS,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dpmac_cmd_clear_irq_status *)cmd.params;
+	cmd_params->status = cpu_to_le32(status);
+	cmd_params->irq_index = irq_index;
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+
+/**
+ * dpmac_get_attributes - Retrieve DPMAC attributes.
+ *
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPMAC object
+ * @attr:	Returned object's attributes
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpmac_get_attributes(struct fsl_mc_io *mc_io,
+			 u32 cmd_flags,
+			 u16 token,
+			 struct dpmac_attr *attr)
+{
+	struct dpmac_rsp_get_attributes *rsp_params;
+	struct fsl_mc_command cmd = { 0 };
+	int err;
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMAC_CMDID_GET_ATTR,
+					  cmd_flags,
+					  token);
+
+	/* send command to mc*/
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	/* retrieve response parameters */
+	rsp_params = (struct dpmac_rsp_get_attributes *)cmd.params;
+	attr->eth_if = rsp_params->eth_if;
+	attr->link_type = rsp_params->link_type;
+	attr->id = le16_to_cpu(rsp_params->id);
+	attr->max_rate = le32_to_cpu(rsp_params->max_rate);
+
+	return 0;
+}
+
+/**
+ * dpmac_get_link_cfg() - Get Ethernet link configuration
+ * @mc_io:      Pointer to opaque I/O object
+ * @cmd_flags:  Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:      Token of DPMAC object
+ * @cfg:        Returned structure with the link configuration
+ *
+ * Return:      '0' on Success; Error code otherwise.
+ */
+int dpmac_get_link_cfg(struct fsl_mc_io *mc_io,
+		       u32 cmd_flags,
+		       u16 token,
+		       struct dpmac_link_cfg *cfg)
+{
+	struct dpmac_rsp_get_link_cfg *rsp_params;
+	struct fsl_mc_command cmd = { 0 };
+	int err = 0;
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMAC_CMDID_GET_LINK_CFG,
+					  cmd_flags,
+					  token);
+
+	/* send command to mc*/
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	rsp_params = (struct dpmac_rsp_get_link_cfg *)cmd.params;
+	cfg->options = le64_to_cpu(rsp_params->options);
+	cfg->rate = le32_to_cpu(rsp_params->rate);
+	cfg->advertising = le64_to_cpu(rsp_params->advertising);
+
+	return 0;
+}
+
+/**
+ * dpmac_set_link_state() - Set the Ethernet link status
+ * @mc_io:      Pointer to opaque I/O object
+ * @cmd_flags:  Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:      Token of DPMAC object
+ * @link_state: Link state configuration
+ *
+ * Return:      '0' on Success; Error code otherwise.
+ */
+int dpmac_set_link_state(struct fsl_mc_io *mc_io,
+			 u32 cmd_flags,
+			 u16 token,
+			 struct dpmac_link_state *link_state)
+{
+	struct dpmac_cmd_set_link_state *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMAC_CMDID_SET_LINK_STATE,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dpmac_cmd_set_link_state *)cmd.params;
+	cmd_params->options = cpu_to_le64(link_state->options);
+	cmd_params->rate = cpu_to_le32(link_state->rate);
+	dpmac_set_field(cmd_params->state, STATE, link_state->up);
+	dpmac_set_field(cmd_params->state, STATE_VALID,
+			link_state->state_valid);
+	cmd_params->supported = cpu_to_le64(link_state->supported);
+	cmd_params->advertising = cpu_to_le64(link_state->advertising);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+
+/**
+ * dpmac_get_api_version() - Get Data Path MAC version
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @major_ver:	Major version of data path mac API
+ * @minor_ver:	Minor version of data path mac API
+ *
+ * Return:  '0' on Success; Error code otherwise.
+ */
+int dpmac_get_api_version(struct fsl_mc_io *mc_io,
+			  u32 cmd_flags,
+			  u16 *major_ver,
+			  u16 *minor_ver)
+{
+	struct dpmac_rsp_get_api_version *rsp_params;
+	struct fsl_mc_command cmd = { 0 };
+	int err;
+
+	cmd.header = mc_encode_cmd_header(DPMAC_CMDID_GET_API_VERSION,
+					  cmd_flags,
+					  0);
+
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	rsp_params = (struct dpmac_rsp_get_api_version *)cmd.params;
+	*major_ver = le16_to_cpu(rsp_params->major);
+	*minor_ver = le16_to_cpu(rsp_params->minor);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac.h b/drivers/net/ethernet/freescale/dpaa2/dpmac.h
new file mode 100644
index 000000000000..de807547321c
--- /dev/null
+++ b/drivers/net/ethernet/freescale/dpaa2/dpmac.h
@@ -0,0 +1,210 @@
+/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
+/* Copyright 2013-2016 Freescale Semiconductor Inc.
+ * Copyright 2019 NXP
+ */
+#ifndef __FSL_DPMAC_H
+#define __FSL_DPMAC_H
+
+/* Data Path MAC API
+ * Contains initialization APIs and runtime control APIs for DPMAC
+ */
+
+struct fsl_mc_io;
+
+int dpmac_open(struct fsl_mc_io *mc_io,
+	       u32 cmd_flags,
+	       int dpmac_id,
+	       u16 *token);
+
+int dpmac_close(struct fsl_mc_io *mc_io,
+		u32 cmd_flags,
+		u16 token);
+
+/**
+ * enum dpmac_link_type -  DPMAC link type
+ * @DPMAC_LINK_TYPE_NONE: No link
+ * @DPMAC_LINK_TYPE_FIXED: Link is fixed type
+ * @DPMAC_LINK_TYPE_PHY: Link by PHY ID
+ * @DPMAC_LINK_TYPE_BACKPLANE: Backplane link type
+ */
+enum dpmac_link_type {
+	DPMAC_LINK_TYPE_NONE,
+	DPMAC_LINK_TYPE_FIXED,
+	DPMAC_LINK_TYPE_PHY,
+	DPMAC_LINK_TYPE_BACKPLANE
+};
+
+/**
+ * enum dpmac_eth_if - DPMAC Ethrnet interface
+ * @DPMAC_ETH_IF_MII: MII interface
+ * @DPMAC_ETH_IF_RMII: RMII interface
+ * @DPMAC_ETH_IF_SMII: SMII interface
+ * @DPMAC_ETH_IF_GMII: GMII interface
+ * @DPMAC_ETH_IF_RGMII: RGMII interface
+ * @DPMAC_ETH_IF_SGMII: SGMII interface
+ * @DPMAC_ETH_IF_QSGMII: QSGMII interface
+ * @DPMAC_ETH_IF_XAUI: XAUI interface
+ * @DPMAC_ETH_IF_XFI: XFI interface
+ * @DPMAC_ETH_IF_CAUI: CAUI interface
+ * @DPMAC_ETH_IF_1000BASEX: 1000BASEX interface
+ * @DPMAC_ETH_IF_USXGMII: USXGMII interface
+ */
+enum dpmac_eth_if {
+	DPMAC_ETH_IF_MII,
+	DPMAC_ETH_IF_RMII,
+	DPMAC_ETH_IF_SMII,
+	DPMAC_ETH_IF_GMII,
+	DPMAC_ETH_IF_RGMII,
+	DPMAC_ETH_IF_SGMII,
+	DPMAC_ETH_IF_QSGMII,
+	DPMAC_ETH_IF_XAUI,
+	DPMAC_ETH_IF_XFI,
+	DPMAC_ETH_IF_CAUI,
+	DPMAC_ETH_IF_1000BASEX,
+	DPMAC_ETH_IF_USXGMII,
+};
+
+/**
+ * DPMAC IRQ Index and Events
+ */
+
+/**
+ * IRQ index
+ */
+#define DPMAC_IRQ_INDEX				0
+/**
+ * IRQ event - indicates a change in link state
+ */
+#define DPMAC_IRQ_EVENT_LINK_CFG_REQ		0x00000001
+/**
+ * IRQ event - Indicates that the link state changed
+ */
+#define DPMAC_IRQ_EVENT_LINK_CHANGED		0x00000002
+
+#define DPMAC_IRQ_EVENT_LINK_UP_REQ		0x00000004
+#define DPMAC_IRQ_EVENT_LINK_DOWN_REQ		0x00000008
+
+int dpmac_set_irq_enable(struct fsl_mc_io *mc_io,
+			 u32 cmd_flags,
+			 u16 token,
+			 u8 irq_index,
+			 u8 en);
+
+int dpmac_set_irq_mask(struct fsl_mc_io *mc_io,
+		       u32 cmd_flags,
+		       u16 token,
+		       u8 irq_index,
+		       u32 mask);
+
+int dpmac_get_irq_status(struct fsl_mc_io *mc_io,
+			 u32 cmd_flags,
+			 u16 token,
+			 u8 irq_index,
+			 u32 *status);
+
+int dpmac_clear_irq_status(struct fsl_mc_io *mc_io,
+			   u32 cmd_flags,
+			   u16 token,
+			   u8 irq_index,
+			   u32 status);
+
+/**
+ * struct dpmac_attr - Structure representing DPMAC attributes
+ * @id:		DPMAC object ID
+ * @max_rate:	Maximum supported rate - in Mbps
+ * @eth_if:	Ethernet interface
+ * @link_type:	link type
+ */
+struct dpmac_attr {
+	u16 id;
+	u32 max_rate;
+	enum dpmac_eth_if eth_if;
+	enum dpmac_link_type link_type;
+};
+
+int dpmac_get_attributes(struct fsl_mc_io *mc_io,
+			 u32 cmd_flags,
+			 u16 token,
+			 struct dpmac_attr *attr);
+
+/**
+ * DPMAC link configuration/state options
+ */
+
+/**
+ * Enable auto-negotiation
+ */
+#define DPMAC_LINK_OPT_AUTONEG			BIT_ULL(0)
+/**
+ * Enable half-duplex mode
+ */
+#define DPMAC_LINK_OPT_HALF_DUPLEX		BIT_ULL(1)
+/**
+ * Enable pause frames
+ */
+#define DPMAC_LINK_OPT_PAUSE			BIT_ULL(2)
+/**
+ * Enable a-symmetric pause frames
+ */
+#define DPMAC_LINK_OPT_ASYM_PAUSE		BIT_ULL(3)
+
+/**
+ * Advertised link speeds
+ */
+#define DPMAC_ADVERTISED_10BASET_FULL		BIT_ULL(0)
+#define DPMAC_ADVERTISED_100BASET_FULL		BIT_ULL(1)
+#define DPMAC_ADVERTISED_1000BASET_FULL		BIT_ULL(2)
+#define DPMAC_ADVERTISED_10000BASET_FULL	BIT_ULL(4)
+#define DPMAC_ADVERTISED_2500BASEX_FULL		BIT_ULL(5)
+
+/**
+ * Advertise auto-negotiation enable
+ */
+#define DPMAC_ADVERTISED_AUTONEG		BIT_ULL(3)
+
+/**
+ * struct dpmac_link_cfg - Structure representing DPMAC link configuration
+ * @rate: Link's rate - in Mbps
+ * @options: Enable/Disable DPMAC link cfg features (bitmap)
+ * @advertising: Speeds that are advertised for autoneg (bitmap)
+ */
+struct dpmac_link_cfg {
+	u32 rate;
+	u64 options;
+	u64 advertising;
+};
+
+int dpmac_get_link_cfg(struct fsl_mc_io *mc_io,
+		       u32 cmd_flags,
+		       u16 token,
+		       struct dpmac_link_cfg *cfg);
+
+/**
+ * struct dpmac_link_state - DPMAC link configuration request
+ * @rate: Rate in Mbps
+ * @options: Enable/Disable DPMAC link cfg features (bitmap)
+ * @up: Link state
+ * @state_valid: Ignore/Update the state of the link
+ * @supported: Speeds capability of the phy (bitmap)
+ * @advertising: Speeds that are advertised for autoneg (bitmap)
+ */
+struct dpmac_link_state {
+	u32 rate;
+	u64 options;
+	int up;
+	int state_valid;
+	u64 supported;
+	u64 advertising;
+};
+
+int dpmac_set_link_state(struct fsl_mc_io *mc_io,
+			 u32 cmd_flags,
+			 u16 token,
+			 struct dpmac_link_state *link_state);
+
+int dpmac_get_api_version(struct fsl_mc_io *mc_io,
+			  u32 cmd_flags,
+			  u16 *major_ver,
+			  u16 *minor_ver);
+
+#endif /* __FSL_DPMAC_H */
-- 
1.9.1

