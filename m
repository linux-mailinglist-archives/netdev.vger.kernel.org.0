Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D39345057
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 01:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfFMX4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 19:56:34 -0400
Received: from inva021.nxp.com ([92.121.34.21]:34618 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726879AbfFMX4e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 19:56:34 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 5243A200512;
        Fri, 14 Jun 2019 01:56:32 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 45122200503;
        Fri, 14 Jun 2019 01:56:32 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id D02FB205DC;
        Fri, 14 Jun 2019 01:56:31 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     linux@armlinux.org.uk, hkallweit1@gmail.com, f.fainelli@gmail.com,
        andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org, alexandru.marginean@nxp.com,
        ruxandra.radulescu@nxp.com,
        Valentin Catalin Neacsu <valentin-catalin.neacsu@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH RFC 2/6] dpaa2-eth: add support for new link state APIs
Date:   Fri, 14 Jun 2019 02:55:49 +0300
Message-Id: <1560470153-26155-3-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
References: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Radulescu <ruxandra.radulescu@nxp.com>

Add v2 of dpni_get_link_state() and dpni_set_link_cfg() commands.  The
new version allows setting and getting advertised and supported link
options. This will allow adding autoneg support in an following patch.

Signed-off-by: Valentin Catalin Neacsu <valentin-catalin.neacsu@nxp.com>
Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h | 35 +++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpni.c     | 70 +++++++++++++++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpni.h     | 27 ++++++++++
 3 files changed, 132 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
index 7b44d7d9b19a..3fb17b35a8df 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
@@ -11,9 +11,11 @@
 #define DPNI_VER_MAJOR				7
 #define DPNI_VER_MINOR				0
 #define DPNI_CMD_BASE_VERSION			1
+#define DPNI_CMD_2ND_VERSION			2
 #define DPNI_CMD_ID_OFFSET			4
 
 #define DPNI_CMD(id)	(((id) << DPNI_CMD_ID_OFFSET) | DPNI_CMD_BASE_VERSION)
+#define DPNI_CMD_V2(id)	(((id) << DPNI_CMD_ID_OFFSET) | DPNI_CMD_2ND_VERSION)
 
 #define DPNI_CMDID_OPEN					DPNI_CMD(0x801)
 #define DPNI_CMDID_CLOSE				DPNI_CMD(0x800)
@@ -42,9 +44,11 @@
 #define DPNI_CMDID_GET_QDID				DPNI_CMD(0x210)
 #define DPNI_CMDID_GET_TX_DATA_OFFSET			DPNI_CMD(0x212)
 #define DPNI_CMDID_GET_LINK_STATE			DPNI_CMD(0x215)
+#define DPNI_CMDID_GET_LINK_STATE_V2			DPNI_CMD_V2(0x215)
 #define DPNI_CMDID_SET_MAX_FRAME_LENGTH			DPNI_CMD(0x216)
 #define DPNI_CMDID_GET_MAX_FRAME_LENGTH			DPNI_CMD(0x217)
 #define DPNI_CMDID_SET_LINK_CFG				DPNI_CMD(0x21A)
+#define DPNI_CMDID_SET_LINK_CFG_V2			DPNI_CMD_V2(0x21A)
 #define DPNI_CMDID_SET_TX_SHAPING			DPNI_CMD(0x21B)
 
 #define DPNI_CMDID_SET_MCAST_PROMISC			DPNI_CMD(0x220)
@@ -294,8 +298,22 @@ struct dpni_cmd_set_link_cfg {
 	__le64 options;
 };
 
+struct dpni_cmd_set_link_cfg_v2 {
+	/* cmd word 0 */
+	__le64 pad0;
+	/* cmd word 1 */
+	__le32 rate;
+	__le32 pad1;
+	/* cmd word 2 */
+	__le64 options;
+	/* cmd word 3 */
+	__le64 advertising;
+};
+
 #define DPNI_LINK_STATE_SHIFT		0
 #define DPNI_LINK_STATE_SIZE		1
+#define DPNI_STATE_VALID_SHIFT		1
+#define DPNI_STATE_VALID_SIZE		1
 
 struct dpni_rsp_get_link_state {
 	/* response word 0 */
@@ -310,6 +328,23 @@ struct dpni_rsp_get_link_state {
 	__le64 options;
 };
 
+struct dpni_rsp_get_link_state_v2 {
+	/* response word 0 */
+	__le32 pad0;
+	/* from LSB: up:1, valid:1 */
+	u8 flags;
+	u8 pad1[3];
+	/* response word 1 */
+	__le32 rate;
+	__le32 pad2;
+	/* response word 2 */
+	__le64 options;
+	/* cmd word 3 */
+	__le64 supported;
+	/* cmd word 4 */
+	__le64 advertising;
+};
+
 struct dpni_cmd_set_max_frame_length {
 	__le16 max_frame_length;
 };
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.c b/drivers/net/ethernet/freescale/dpaa2/dpni.c
index 220dfc806a24..e7f318e0b41f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.c
@@ -853,6 +853,36 @@ int dpni_set_link_cfg(struct fsl_mc_io *mc_io,
 }
 
 /**
+ * dpni_set_link_cfg_v2() - set the link configuration.
+ * @mc_io:      Pointer to MC portal's I/O object
+ * @cmd_flags:  Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:      Token of DPNI object
+ * @cfg:        Link configuration
+ *
+ * Return:      '0' on Success; Error code otherwise.
+ */
+int dpni_set_link_cfg_v2(struct fsl_mc_io *mc_io,
+			 u32 cmd_flags,
+			 u16 token,
+			 const struct dpni_link_cfg *cfg)
+{
+	struct fsl_mc_command cmd = { 0 };
+	struct dpni_cmd_set_link_cfg_v2 *cmd_params;
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPNI_CMDID_SET_LINK_CFG_V2,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dpni_cmd_set_link_cfg_v2 *)cmd.params;
+	cmd_params->rate = cpu_to_le32(cfg->rate);
+	cmd_params->options = cpu_to_le64(cfg->options);
+	cmd_params->advertising = cpu_to_le64(cfg->advertising);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+
+/**
  * dpni_get_link_state() - Return the link state (either up or down)
  * @mc_io:	Pointer to MC portal's I/O object
  * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
@@ -890,6 +920,46 @@ int dpni_get_link_state(struct fsl_mc_io *mc_io,
 }
 
 /**
+ * dpni_get_link_state_v2() - Return the link state (either up or down)
+ * @mc_io:      Pointer to MC portal's I/O object
+ * @cmd_flags:  Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:      Token of DPNI object
+ * @state:      Returned link state;
+ *
+ * Return:      '0' on Success; Error code otherwise.
+ */
+int dpni_get_link_state_v2(struct fsl_mc_io *mc_io,
+			   u32 cmd_flags,
+			   u16 token,
+			   struct dpni_link_state *state)
+{
+	struct fsl_mc_command cmd = { 0 };
+	struct dpni_rsp_get_link_state_v2 *rsp_params;
+	int err;
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPNI_CMDID_GET_LINK_STATE_V2,
+					  cmd_flags,
+					  token);
+
+	/* send command to mc*/
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	/* retrieve response parameters */
+	rsp_params = (struct dpni_rsp_get_link_state_v2 *)cmd.params;
+	state->up = dpni_get_field(rsp_params->flags, LINK_STATE);
+	state->state_valid = dpni_get_field(rsp_params->flags, STATE_VALID);
+	state->rate = le32_to_cpu(rsp_params->rate);
+	state->options = le64_to_cpu(rsp_params->options);
+	state->supported = le64_to_cpu(rsp_params->supported);
+	state->advertising = le64_to_cpu(rsp_params->advertising);
+
+	return 0;
+}
+
+/**
  * dpni_set_max_frame_length() - Set the maximum received frame length.
  * @mc_io:	Pointer to MC portal's I/O object
  * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.h b/drivers/net/ethernet/freescale/dpaa2/dpni.h
index a521242e2353..ad12e670c6e2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.h
@@ -471,6 +471,19 @@ int dpni_get_statistics(struct fsl_mc_io	*mc_io,
 #define DPNI_LINK_OPT_ASYM_PAUSE	0x0000000000000008ULL
 
 /**
+ * Advertised link speeds
+ */
+#define DPNI_ADVERTISED_10BASET_FULL           BIT_ULL(0)
+#define DPNI_ADVERTISED_100BASET_FULL          BIT_ULL(1)
+#define DPNI_ADVERTISED_1000BASET_FULL         BIT_ULL(2)
+#define DPNI_ADVERTISED_10000BASET_FULL        BIT_ULL(4)
+
+/**
+ * Advertise auto-negotiation enabled
+ */
+#define DPNI_ADVERTISED_AUTONEG                BIT_ULL(3)
+
+/**
  * struct - Structure representing DPNI link configuration
  * @rate: Rate
  * @options: Mask of available options; use 'DPNI_LINK_OPT_<X>' values
@@ -478,6 +491,7 @@ int dpni_get_statistics(struct fsl_mc_io	*mc_io,
 struct dpni_link_cfg {
 	u32 rate;
 	u64 options;
+	u64 advertising;
 };
 
 int dpni_set_link_cfg(struct fsl_mc_io			*mc_io,
@@ -485,6 +499,11 @@ int dpni_set_link_cfg(struct fsl_mc_io			*mc_io,
 		      u16				token,
 		      const struct dpni_link_cfg	*cfg);
 
+int dpni_set_link_cfg_v2(struct fsl_mc_io		*mc_io,
+			 u32				cmd_flags,
+			 u16				token,
+			 const struct dpni_link_cfg	*cfg);
+
 /**
  * struct dpni_link_state - Structure representing DPNI link state
  * @rate: Rate
@@ -494,7 +513,10 @@ int dpni_set_link_cfg(struct fsl_mc_io			*mc_io,
 struct dpni_link_state {
 	u32	rate;
 	u64	options;
+	u64	supported;
+	u64	advertising;
 	int	up;
+	int	state_valid;
 };
 
 int dpni_get_link_state(struct fsl_mc_io	*mc_io,
@@ -502,6 +524,11 @@ int dpni_get_link_state(struct fsl_mc_io	*mc_io,
 			u16			token,
 			struct dpni_link_state	*state);
 
+int dpni_get_link_state_v2(struct fsl_mc_io	*mc_io,
+			   u32			cmd_flags,
+			   u16			token,
+			   struct dpni_link_state	*state);
+
 int dpni_set_max_frame_length(struct fsl_mc_io	*mc_io,
 			      u32		cmd_flags,
 			      u16		token,
-- 
1.9.1

