Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745112306E1
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgG1Jsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:48:30 -0400
Received: from inva021.nxp.com ([92.121.34.21]:40912 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728345AbgG1Js3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:48:29 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 307DD200BA3;
        Tue, 28 Jul 2020 11:48:28 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 24B68200B94;
        Tue, 28 Jul 2020 11:48:28 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id EB84C20328;
        Tue, 28 Jul 2020 11:48:27 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 1/2] dpaa2-eth: add API for stats clear
Date:   Tue, 28 Jul 2020 12:48:11 +0300
Message-Id: <20200728094812.29002-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200728094812.29002-1-ioana.ciornei@nxp.com>
References: <20200728094812.29002-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the necessary MC API for resetting the DPNI HW counters.
This new function - dpni_reset_statistics - will be used in a subsequent
patch that adds the debugfs controls.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpni-cmd.h   |  1 +
 drivers/net/ethernet/freescale/dpaa2/dpni.c   | 23 +++++++++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpni.h   |  4 ++++
 3 files changed, 28 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
index 593e3812af93..a7c0a37c96d7 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
@@ -68,6 +68,7 @@
 #define DPNI_CMDID_CLR_FS_ENT				DPNI_CMD(0x246)
 
 #define DPNI_CMDID_GET_STATISTICS			DPNI_CMD(0x25D)
+#define DPNI_CMDID_RESET_STATISTICS			DPNI_CMD(0x25E)
 #define DPNI_CMDID_GET_QUEUE				DPNI_CMD(0x25F)
 #define DPNI_CMDID_SET_QUEUE				DPNI_CMD(0x260)
 #define DPNI_CMDID_GET_TAILDROP				DPNI_CMD(0x261)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.c b/drivers/net/ethernet/freescale/dpaa2/dpni.c
index 68ed4c41b282..5a01451b04a6 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.c
@@ -1552,6 +1552,29 @@ int dpni_get_statistics(struct fsl_mc_io *mc_io,
 	return 0;
 }
 
+/**
+ * dpni_reset_statistics() - Clears DPNI statistics
+ * @mc_io:		Pointer to MC portal's I/O object
+ * @cmd_flags:		Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:		Token of DPNI object
+ *
+ * Return:  '0' on Success; Error code otherwise.
+ */
+int dpni_reset_statistics(struct fsl_mc_io *mc_io,
+			  u32 cmd_flags,
+			  u16 token)
+{
+	struct fsl_mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPNI_CMDID_RESET_STATISTICS,
+					  cmd_flags,
+					  token);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+
 /**
  * dpni_set_taildrop() - Set taildrop per queue or TC
  * @mc_io:	Pointer to MC portal's I/O object
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.h b/drivers/net/ethernet/freescale/dpaa2/dpni.h
index 39387991a1f9..bd95c597be3e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.h
@@ -496,6 +496,10 @@ int dpni_get_statistics(struct fsl_mc_io	*mc_io,
 			u8			page,
 			union dpni_statistics	*stat);
 
+int dpni_reset_statistics(struct fsl_mc_io *mc_io,
+			  u32 cmd_flags,
+			  u16 token);
+
 /**
  * Enable auto-negotiation
  */
-- 
2.25.1

