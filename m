Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36812285E6
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 18:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730395AbgGUQih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 12:38:37 -0400
Received: from inva020.nxp.com ([92.121.34.13]:57324 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730375AbgGUQie (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 12:38:34 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 921621A0700;
        Tue, 21 Jul 2020 18:38:32 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 841AD1A06EE;
        Tue, 21 Jul 2020 18:38:32 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 51403202A9;
        Tue, 21 Jul 2020 18:38:32 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 2/3] dpaa2-eth: add API for Tx shaping
Date:   Tue, 21 Jul 2020 19:38:24 +0300
Message-Id: <20200721163825.9462-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721163825.9462-1-ioana.ciornei@nxp.com>
References: <20200721163825.9462-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the necessary API (dpni_set_tx_shaping) for configuring the rate and
burst size of a per port shaper in DPAA2.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpni-cmd.h   | 13 +++++++
 drivers/net/ethernet/freescale/dpaa2/dpni.c   | 36 +++++++++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpni.h   | 16 +++++++++
 3 files changed, 65 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
index fd069f67be9b..593e3812af93 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
@@ -626,4 +626,17 @@ struct dpni_cmd_set_congestion_notification {
 	__le32 threshold_exit;
 };
 
+#define DPNI_COUPLED_SHIFT	0
+#define DPNI_COUPLED_SIZE	1
+
+struct dpni_cmd_set_tx_shaping {
+	__le16 tx_cr_max_burst_size;
+	__le16 tx_er_max_burst_size;
+	__le32 pad;
+	__le32 tx_cr_rate_limit;
+	__le32 tx_er_rate_limit;
+	/* from LSB: coupled:1 */
+	u8 coupled;
+};
+
 #endif /* _FSL_DPNI_CMD_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.c b/drivers/net/ethernet/freescale/dpaa2/dpni.c
index 426100607854..68ed4c41b282 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.c
@@ -1963,3 +1963,39 @@ int dpni_clear_qos_table(struct fsl_mc_io *mc_io,
 	/* send command to mc*/
 	return mc_send_command(mc_io, &cmd);
 }
+
+/**
+ * dpni_set_tx_shaping() - Set the transmit shaping
+ * @mc_io:		Pointer to MC portal's I/O object
+ * @cmd_flags:		Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:		Token of DPNI object
+ * @tx_cr_shaper:	TX committed rate shaping configuration
+ * @tx_er_shaper:	TX excess rate shaping configuration
+ * @coupled:		Committed and excess rate shapers are coupled
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpni_set_tx_shaping(struct fsl_mc_io *mc_io,
+			u32 cmd_flags,
+			u16 token,
+			const struct dpni_tx_shaping_cfg *tx_cr_shaper,
+			const struct dpni_tx_shaping_cfg *tx_er_shaper,
+			int coupled)
+{
+	struct dpni_cmd_set_tx_shaping *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPNI_CMDID_SET_TX_SHAPING,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dpni_cmd_set_tx_shaping *)cmd.params;
+	cmd_params->tx_cr_max_burst_size = cpu_to_le16(tx_cr_shaper->max_burst_size);
+	cmd_params->tx_er_max_burst_size = cpu_to_le16(tx_er_shaper->max_burst_size);
+	cmd_params->tx_cr_rate_limit = cpu_to_le32(tx_cr_shaper->rate_limit);
+	cmd_params->tx_er_rate_limit = cpu_to_le32(tx_er_shaper->rate_limit);
+	dpni_set_field(cmd_params->coupled, COUPLED, coupled);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.h b/drivers/net/ethernet/freescale/dpaa2/dpni.h
index e874d8084142..39387991a1f9 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.h
@@ -1062,5 +1062,21 @@ int dpni_get_api_version(struct fsl_mc_io *mc_io,
 			 u32 cmd_flags,
 			 u16 *major_ver,
 			 u16 *minor_ver);
+/**
+ * struct dpni_tx_shaping - Structure representing DPNI tx shaping configuration
+ * @rate_limit:		Rate in Mbps
+ * @max_burst_size:	Burst size in bytes (up to 64KB)
+ */
+struct dpni_tx_shaping_cfg {
+	u32 rate_limit;
+	u16 max_burst_size;
+};
+
+int dpni_set_tx_shaping(struct fsl_mc_io *mc_io,
+			u32 cmd_flags,
+			u16 token,
+			const struct dpni_tx_shaping_cfg *tx_cr_shaper,
+			const struct dpni_tx_shaping_cfg *tx_er_shaper,
+			int coupled);
 
 #endif /* __FSL_DPNI_H */
-- 
2.25.1

