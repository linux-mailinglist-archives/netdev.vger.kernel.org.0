Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D24A32643E0
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 12:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730748AbgIJKZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 06:25:11 -0400
Received: from inva020.nxp.com ([92.121.34.13]:57096 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730166AbgIJKZG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 06:25:06 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 483271A07E7;
        Thu, 10 Sep 2020 12:24:58 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 0BF831A08BE;
        Thu, 10 Sep 2020 12:24:55 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id DEDB3402E2;
        Thu, 10 Sep 2020 12:24:50 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [v2, 1/5] dpaa2-eth: add APIs of 1588 single step timestamping
Date:   Thu, 10 Sep 2020 18:16:51 +0800
Message-Id: <20200910101655.13904-2-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910101655.13904-1-yangbo.lu@nxp.com>
References: <20200910101655.13904-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add APIs of 1588 single step timestamping.

- dpni_set_single_step_cfg
- dpni_get_single_step_cfg

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- None.
---
 drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h | 21 +++++++
 drivers/net/ethernet/freescale/dpaa2/dpni.c     | 73 +++++++++++++++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpni.h     | 31 +++++++++++
 3 files changed, 125 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
index 593e381..1222a4e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
 /* Copyright 2013-2016 Freescale Semiconductor Inc.
  * Copyright 2016 NXP
+ * Copyright 2020 NXP
  */
 #ifndef _FSL_DPNI_CMD_H
 #define _FSL_DPNI_CMD_H
@@ -90,6 +91,9 @@
 #define DPNI_CMDID_SET_RX_HASH_DIST			DPNI_CMD(0x274)
 #define DPNI_CMDID_GET_LINK_CFG				DPNI_CMD(0x278)
 
+#define DPNI_CMDID_SET_SINGLE_STEP_CFG			DPNI_CMD(0x279)
+#define DPNI_CMDID_GET_SINGLE_STEP_CFG			DPNI_CMD(0x27a)
+
 /* Macros for accessing command fields smaller than 1byte */
 #define DPNI_MASK(field)	\
 	GENMASK(DPNI_##field##_SHIFT + DPNI_##field##_SIZE - 1, \
@@ -639,4 +643,21 @@ struct dpni_cmd_set_tx_shaping {
 	u8 coupled;
 };
 
+#define DPNI_PTP_ENABLE_SHIFT			0
+#define DPNI_PTP_ENABLE_SIZE			1
+#define DPNI_PTP_CH_UPDATE_SHIFT		1
+#define DPNI_PTP_CH_UPDATE_SIZE			1
+
+struct dpni_cmd_single_step_cfg {
+	__le16 flags;
+	__le16 offset;
+	__le32 peer_delay;
+};
+
+struct dpni_rsp_single_step_cfg {
+	__le16 flags;
+	__le16 offset;
+	__le32 peer_delay;
+};
+
 #endif /* _FSL_DPNI_CMD_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.c b/drivers/net/ethernet/freescale/dpaa2/dpni.c
index 68ed4c4..6a36d47 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
 /* Copyright 2013-2016 Freescale Semiconductor Inc.
  * Copyright 2016 NXP
+ * Copyright 2020 NXP
  */
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -1999,3 +2000,75 @@ int dpni_set_tx_shaping(struct fsl_mc_io *mc_io,
 	/* send command to mc*/
 	return mc_send_command(mc_io, &cmd);
 }
+
+/**
+ * dpni_get_single_step_cfg() - return current configuration for
+ *                              single step PTP
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPNI object
+ * @ptp_cfg:	ptp single step configuration
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ *
+ */
+int dpni_get_single_step_cfg(struct fsl_mc_io *mc_io,
+			     u32 cmd_flags,
+			     u16 token,
+			     struct dpni_single_step_cfg *ptp_cfg)
+{
+	struct dpni_rsp_single_step_cfg *rsp_params;
+	struct fsl_mc_command cmd = { 0 };
+	int err;
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPNI_CMDID_GET_SINGLE_STEP_CFG,
+					  cmd_flags, token);
+	/* send command to mc*/
+	err =  mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	/* read command response */
+	rsp_params = (struct dpni_rsp_single_step_cfg *)cmd.params;
+	ptp_cfg->offset = le16_to_cpu(rsp_params->offset);
+	ptp_cfg->en = dpni_get_field(rsp_params->flags, PTP_ENABLE);
+	ptp_cfg->ch_update = dpni_get_field(rsp_params->flags, PTP_CH_UPDATE);
+	ptp_cfg->peer_delay = le32_to_cpu(rsp_params->peer_delay);
+
+	return err;
+}
+
+/**
+ * dpni_set_single_step_cfg() - enable/disable and configure single step PTP
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPNI object
+ * @ptp_cfg:	ptp single step configuration
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ *
+ * The function has effect only when dpni object is connected to a dpmac
+ * object. If the dpni is not connected to a dpmac the configuration will
+ * be stored inside and applied when connection is made.
+ */
+int dpni_set_single_step_cfg(struct fsl_mc_io *mc_io,
+			     u32 cmd_flags,
+			     u16 token,
+			     struct dpni_single_step_cfg *ptp_cfg)
+{
+	struct dpni_cmd_single_step_cfg *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPNI_CMDID_SET_SINGLE_STEP_CFG,
+					  cmd_flags, token);
+	cmd_params = (struct dpni_cmd_single_step_cfg *)cmd.params;
+	cmd_params->offset = cpu_to_le16(ptp_cfg->offset);
+	cmd_params->peer_delay = cpu_to_le32(ptp_cfg->peer_delay);
+	dpni_set_field(cmd_params->flags, PTP_ENABLE, !!ptp_cfg->en);
+	dpni_set_field(cmd_params->flags, PTP_CH_UPDATE, !!ptp_cfg->ch_update);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.h b/drivers/net/ethernet/freescale/dpaa2/dpni.h
index 3938799..74456a3 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
 /* Copyright 2013-2016 Freescale Semiconductor Inc.
  * Copyright 2016 NXP
+ * Copyright 2020 NXP
  */
 #ifndef __FSL_DPNI_H
 #define __FSL_DPNI_H
@@ -1079,4 +1080,34 @@ int dpni_set_tx_shaping(struct fsl_mc_io *mc_io,
 			const struct dpni_tx_shaping_cfg *tx_er_shaper,
 			int coupled);
 
+/**
+ * struct dpni_single_step_cfg - configure single step PTP (IEEE 1588)
+ * @en:		enable single step PTP. When enabled the PTPv1 functionality
+ *		will not work. If the field is zero, offset and ch_update
+ *		parameters will be ignored
+ * @offset:	start offset from the beginning of the frame where
+ *		timestamp field is found. The offset must respect all MAC
+ *		headers, VLAN tags and other protocol headers
+ * @ch_update:	when set UDP checksum will be updated inside packet
+ * @peer_delay:	For peer-to-peer transparent clocks add this value to the
+ *		correction field in addition to the transient time update.
+ *		The value expresses nanoseconds.
+ */
+struct dpni_single_step_cfg {
+	u8	en;
+	u8	ch_update;
+	u16	offset;
+	u32	peer_delay;
+};
+
+int dpni_set_single_step_cfg(struct fsl_mc_io *mc_io,
+			     u32 cmd_flags,
+			     u16 token,
+			     struct dpni_single_step_cfg *ptp_cfg);
+
+int dpni_get_single_step_cfg(struct fsl_mc_io *mc_io,
+			     u32 cmd_flags,
+			     u16 token,
+			     struct dpni_single_step_cfg *ptp_cfg);
+
 #endif /* __FSL_DPNI_H */
-- 
2.7.4

