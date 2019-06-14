Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A42BC45AB1
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 12:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbfFNKju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 06:39:50 -0400
Received: from inva021.nxp.com ([92.121.34.21]:36076 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726784AbfFNKjP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 06:39:15 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 539C4200E7C;
        Fri, 14 Jun 2019 12:39:13 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 9710D200E7F;
        Fri, 14 Jun 2019 12:39:08 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 6EE5F402DD;
        Fri, 14 Jun 2019 18:39:02 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>
Subject: [v2, 2/6] dpaa2-ptp: reuse ptp_qoriq driver
Date:   Fri, 14 Jun 2019 18:40:51 +0800
Message-Id: <20190614104055.43998-3-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190614104055.43998-1-yangbo.lu@nxp.com>
References: <20190614104055.43998-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although dpaa2-ptp.c driver is a fsl_mc_driver which
is using MC APIs for register accessing, it's same IP
block with eTSEC/DPAA/ENETC 1588 timer.
This patch is to convert to reuse ptp_qoriq driver by
using register ioremap and dropping related MC APIs.
However the interrupts could only be handled by MC which
fires MSIs to ARM cores. So the interrupt enabling and
handling still rely on MC APIs.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- None.
---
 drivers/net/ethernet/freescale/dpaa2/Kconfig     |   3 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c | 160 +++++------------------
 drivers/net/ethernet/freescale/dpaa2/dprtc-cmd.h |  13 --
 drivers/net/ethernet/freescale/dpaa2/dprtc.c     | 120 -----------------
 drivers/net/ethernet/freescale/dpaa2/dprtc.h     |  20 ---
 5 files changed, 34 insertions(+), 282 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/Kconfig b/drivers/net/ethernet/freescale/dpaa2/Kconfig
index 8bd3847..fbef282 100644
--- a/drivers/net/ethernet/freescale/dpaa2/Kconfig
+++ b/drivers/net/ethernet/freescale/dpaa2/Kconfig
@@ -10,8 +10,7 @@ config FSL_DPAA2_ETH
 
 config FSL_DPAA2_PTP_CLOCK
 	tristate "Freescale DPAA2 PTP Clock"
-	depends on FSL_DPAA2_ETH
-	imply PTP_1588_CLOCK
+	depends on FSL_DPAA2_ETH && PTP_1588_CLOCK_QORIQ
 	default y
 	help
 	  This driver adds support for using the DPAA2 1588 timer module
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
index 9b150db..6c57e17 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
@@ -5,114 +5,14 @@
  */
 
 #include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/ptp_clock_kernel.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/fsl/mc.h>
+#include <linux/fsl/ptp_qoriq.h>
 
 #include "dpaa2-ptp.h"
 
-struct ptp_dpaa2_priv {
-	struct fsl_mc_device *ptp_mc_dev;
-	struct ptp_clock *clock;
-	struct ptp_clock_info caps;
-	u32 freq_comp;
-};
-
-/* PTP clock operations */
-static int ptp_dpaa2_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
-{
-	struct ptp_dpaa2_priv *ptp_dpaa2 =
-		container_of(ptp, struct ptp_dpaa2_priv, caps);
-	struct fsl_mc_device *mc_dev = ptp_dpaa2->ptp_mc_dev;
-	struct device *dev = &mc_dev->dev;
-	u64 adj;
-	u32 diff, tmr_add;
-	int neg_adj = 0;
-	int err = 0;
-
-	if (ppb < 0) {
-		neg_adj = 1;
-		ppb = -ppb;
-	}
-
-	tmr_add = ptp_dpaa2->freq_comp;
-	adj = tmr_add;
-	adj *= ppb;
-	diff = div_u64(adj, 1000000000ULL);
-
-	tmr_add = neg_adj ? tmr_add - diff : tmr_add + diff;
-
-	err = dprtc_set_freq_compensation(mc_dev->mc_io, 0,
-					  mc_dev->mc_handle, tmr_add);
-	if (err)
-		dev_err(dev, "dprtc_set_freq_compensation err %d\n", err);
-	return err;
-}
-
-static int ptp_dpaa2_adjtime(struct ptp_clock_info *ptp, s64 delta)
-{
-	struct ptp_dpaa2_priv *ptp_dpaa2 =
-		container_of(ptp, struct ptp_dpaa2_priv, caps);
-	struct fsl_mc_device *mc_dev = ptp_dpaa2->ptp_mc_dev;
-	struct device *dev = &mc_dev->dev;
-	s64 now;
-	int err = 0;
-
-	err = dprtc_get_time(mc_dev->mc_io, 0, mc_dev->mc_handle, &now);
-	if (err) {
-		dev_err(dev, "dprtc_get_time err %d\n", err);
-		return err;
-	}
-
-	now += delta;
-
-	err = dprtc_set_time(mc_dev->mc_io, 0, mc_dev->mc_handle, now);
-	if (err)
-		dev_err(dev, "dprtc_set_time err %d\n", err);
-	return err;
-}
-
-static int ptp_dpaa2_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
-{
-	struct ptp_dpaa2_priv *ptp_dpaa2 =
-		container_of(ptp, struct ptp_dpaa2_priv, caps);
-	struct fsl_mc_device *mc_dev = ptp_dpaa2->ptp_mc_dev;
-	struct device *dev = &mc_dev->dev;
-	u64 ns;
-	u32 remainder;
-	int err = 0;
-
-	err = dprtc_get_time(mc_dev->mc_io, 0, mc_dev->mc_handle, &ns);
-	if (err) {
-		dev_err(dev, "dprtc_get_time err %d\n", err);
-		return err;
-	}
-
-	ts->tv_sec = div_u64_rem(ns, 1000000000, &remainder);
-	ts->tv_nsec = remainder;
-	return err;
-}
-
-static int ptp_dpaa2_settime(struct ptp_clock_info *ptp,
-			     const struct timespec64 *ts)
-{
-	struct ptp_dpaa2_priv *ptp_dpaa2 =
-		container_of(ptp, struct ptp_dpaa2_priv, caps);
-	struct fsl_mc_device *mc_dev = ptp_dpaa2->ptp_mc_dev;
-	struct device *dev = &mc_dev->dev;
-	u64 ns;
-	int err = 0;
-
-	ns = ts->tv_sec * 1000000000ULL;
-	ns += ts->tv_nsec;
-
-	err = dprtc_set_time(mc_dev->mc_io, 0, mc_dev->mc_handle, ns);
-	if (err)
-		dev_err(dev, "dprtc_set_time err %d\n", err);
-	return err;
-}
-
-static const struct ptp_clock_info ptp_dpaa2_caps = {
+static const struct ptp_clock_info dpaa2_ptp_caps = {
 	.owner		= THIS_MODULE,
 	.name		= "DPAA2 PTP Clock",
 	.max_adj	= 512000,
@@ -121,21 +21,22 @@ static const struct ptp_clock_info ptp_dpaa2_caps = {
 	.n_per_out	= 3,
 	.n_pins		= 0,
 	.pps		= 1,
-	.adjfreq	= ptp_dpaa2_adjfreq,
-	.adjtime	= ptp_dpaa2_adjtime,
-	.gettime64	= ptp_dpaa2_gettime,
-	.settime64	= ptp_dpaa2_settime,
+	.adjfine	= ptp_qoriq_adjfine,
+	.adjtime	= ptp_qoriq_adjtime,
+	.gettime64	= ptp_qoriq_gettime,
+	.settime64	= ptp_qoriq_settime,
 };
 
 static int dpaa2_ptp_probe(struct fsl_mc_device *mc_dev)
 {
 	struct device *dev = &mc_dev->dev;
-	struct ptp_dpaa2_priv *ptp_dpaa2;
-	u32 tmr_add = 0;
+	struct ptp_qoriq *ptp_qoriq;
+	struct device_node *node;
+	void __iomem *base;
 	int err;
 
-	ptp_dpaa2 = devm_kzalloc(dev, sizeof(*ptp_dpaa2), GFP_KERNEL);
-	if (!ptp_dpaa2)
+	ptp_qoriq = devm_kzalloc(dev, sizeof(*ptp_qoriq), GFP_KERNEL);
+	if (!ptp_qoriq)
 		return -ENOMEM;
 
 	err = fsl_mc_portal_allocate(mc_dev, 0, &mc_dev->mc_io);
@@ -154,30 +55,33 @@ static int dpaa2_ptp_probe(struct fsl_mc_device *mc_dev)
 		goto err_free_mcp;
 	}
 
-	ptp_dpaa2->ptp_mc_dev = mc_dev;
+	ptp_qoriq->dev = dev;
 
-	err = dprtc_get_freq_compensation(mc_dev->mc_io, 0,
-					  mc_dev->mc_handle, &tmr_add);
-	if (err) {
-		dev_err(dev, "dprtc_get_freq_compensation err %d\n", err);
+	node = of_find_compatible_node(NULL, NULL, "fsl,dpaa2-ptp");
+	if (!node) {
+		err = -ENODEV;
 		goto err_close;
 	}
 
-	ptp_dpaa2->freq_comp = tmr_add;
-	ptp_dpaa2->caps = ptp_dpaa2_caps;
+	dev->of_node = node;
 
-	ptp_dpaa2->clock = ptp_clock_register(&ptp_dpaa2->caps, dev);
-	if (IS_ERR(ptp_dpaa2->clock)) {
-		err = PTR_ERR(ptp_dpaa2->clock);
+	base = of_iomap(node, 0);
+	if (!base) {
+		err = -ENOMEM;
 		goto err_close;
 	}
 
-	dpaa2_phc_index = ptp_clock_index(ptp_dpaa2->clock);
+	err = ptp_qoriq_init(ptp_qoriq, base, &dpaa2_ptp_caps);
+	if (err)
+		goto err_unmap;
 
-	dev_set_drvdata(dev, ptp_dpaa2);
+	dpaa2_phc_index = ptp_qoriq->phc_index;
+	dev_set_drvdata(dev, ptp_qoriq);
 
 	return 0;
 
+err_unmap:
+	iounmap(base);
 err_close:
 	dprtc_close(mc_dev->mc_io, 0, mc_dev->mc_handle);
 err_free_mcp:
@@ -188,11 +92,13 @@ static int dpaa2_ptp_probe(struct fsl_mc_device *mc_dev)
 
 static int dpaa2_ptp_remove(struct fsl_mc_device *mc_dev)
 {
-	struct ptp_dpaa2_priv *ptp_dpaa2;
 	struct device *dev = &mc_dev->dev;
+	struct ptp_qoriq *ptp_qoriq;
+
+	ptp_qoriq = dev_get_drvdata(dev);
 
-	ptp_dpaa2 = dev_get_drvdata(dev);
-	ptp_clock_unregister(ptp_dpaa2->clock);
+	dpaa2_phc_index = -1;
+	ptp_qoriq_free(ptp_qoriq);
 
 	dprtc_close(mc_dev->mc_io, 0, mc_dev->mc_handle);
 	fsl_mc_portal_free(mc_dev->mc_io);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dprtc-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dprtc-cmd.h
index 9af4ac7..dd74aa9 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dprtc-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dprtc-cmd.h
@@ -17,24 +17,11 @@
 #define DPRTC_CMDID_CLOSE			DPRTC_CMD(0x800)
 #define DPRTC_CMDID_OPEN			DPRTC_CMD(0x810)
 
-#define DPRTC_CMDID_SET_FREQ_COMPENSATION	DPRTC_CMD(0x1d1)
-#define DPRTC_CMDID_GET_FREQ_COMPENSATION	DPRTC_CMD(0x1d2)
-#define DPRTC_CMDID_GET_TIME			DPRTC_CMD(0x1d3)
-#define DPRTC_CMDID_SET_TIME			DPRTC_CMD(0x1d4)
-
 #pragma pack(push, 1)
 struct dprtc_cmd_open {
 	__le32 dprtc_id;
 };
 
-struct dprtc_get_freq_compensation {
-	__le32 freq_compensation;
-};
-
-struct dprtc_time {
-	__le64 time;
-};
-
 #pragma pack(pop)
 
 #endif /* _FSL_DPRTC_CMD_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dprtc.c b/drivers/net/ethernet/freescale/dpaa2/dprtc.c
index c13e09b..1ae303e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dprtc.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dprtc.c
@@ -72,123 +72,3 @@ int dprtc_close(struct fsl_mc_io *mc_io,
 
 	return mc_send_command(mc_io, &cmd);
 }
-
-/**
- * dprtc_set_freq_compensation() - Sets a new frequency compensation value.
- *
- * @mc_io:		Pointer to MC portal's I/O object
- * @cmd_flags:		Command flags; one or more of 'MC_CMD_FLAG_'
- * @token:		Token of DPRTC object
- * @freq_compensation:	The new frequency compensation value to set.
- *
- * Return:	'0' on Success; Error code otherwise.
- */
-int dprtc_set_freq_compensation(struct fsl_mc_io *mc_io,
-				u32 cmd_flags,
-				u16 token,
-				u32 freq_compensation)
-{
-	struct dprtc_get_freq_compensation *cmd_params;
-	struct fsl_mc_command cmd = { 0 };
-
-	cmd.header = mc_encode_cmd_header(DPRTC_CMDID_SET_FREQ_COMPENSATION,
-					  cmd_flags,
-					  token);
-	cmd_params = (struct dprtc_get_freq_compensation *)cmd.params;
-	cmd_params->freq_compensation = cpu_to_le32(freq_compensation);
-
-	return mc_send_command(mc_io, &cmd);
-}
-
-/**
- * dprtc_get_freq_compensation() - Retrieves the frequency compensation value
- *
- * @mc_io:		Pointer to MC portal's I/O object
- * @cmd_flags:		Command flags; one or more of 'MC_CMD_FLAG_'
- * @token:		Token of DPRTC object
- * @freq_compensation:	Frequency compensation value
- *
- * Return:	'0' on Success; Error code otherwise.
- */
-int dprtc_get_freq_compensation(struct fsl_mc_io *mc_io,
-				u32 cmd_flags,
-				u16 token,
-				u32 *freq_compensation)
-{
-	struct dprtc_get_freq_compensation *rsp_params;
-	struct fsl_mc_command cmd = { 0 };
-	int err;
-
-	cmd.header = mc_encode_cmd_header(DPRTC_CMDID_GET_FREQ_COMPENSATION,
-					  cmd_flags,
-					  token);
-
-	err = mc_send_command(mc_io, &cmd);
-	if (err)
-		return err;
-
-	rsp_params = (struct dprtc_get_freq_compensation *)cmd.params;
-	*freq_compensation = le32_to_cpu(rsp_params->freq_compensation);
-
-	return 0;
-}
-
-/**
- * dprtc_get_time() - Returns the current RTC time.
- *
- * @mc_io:	Pointer to MC portal's I/O object
- * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
- * @token:	Token of DPRTC object
- * @time:	Current RTC time.
- *
- * Return:	'0' on Success; Error code otherwise.
- */
-int dprtc_get_time(struct fsl_mc_io *mc_io,
-		   u32 cmd_flags,
-		   u16 token,
-		   uint64_t *time)
-{
-	struct dprtc_time *rsp_params;
-	struct fsl_mc_command cmd = { 0 };
-	int err;
-
-	cmd.header = mc_encode_cmd_header(DPRTC_CMDID_GET_TIME,
-					  cmd_flags,
-					  token);
-
-	err = mc_send_command(mc_io, &cmd);
-	if (err)
-		return err;
-
-	rsp_params = (struct dprtc_time *)cmd.params;
-	*time = le64_to_cpu(rsp_params->time);
-
-	return 0;
-}
-
-/**
- * dprtc_set_time() - Updates current RTC time.
- *
- * @mc_io:	Pointer to MC portal's I/O object
- * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
- * @token:	Token of DPRTC object
- * @time:	New RTC time.
- *
- * Return:	'0' on Success; Error code otherwise.
- */
-int dprtc_set_time(struct fsl_mc_io *mc_io,
-		   u32 cmd_flags,
-		   u16 token,
-		   uint64_t time)
-{
-	struct dprtc_time *cmd_params;
-	struct fsl_mc_command cmd = { 0 };
-
-	cmd.header = mc_encode_cmd_header(DPRTC_CMDID_SET_TIME,
-					  cmd_flags,
-					  token);
-	cmd_params = (struct dprtc_time *)cmd.params;
-	cmd_params->time = cpu_to_le64(time);
-
-	return mc_send_command(mc_io, &cmd);
-}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dprtc.h b/drivers/net/ethernet/freescale/dpaa2/dprtc.h
index fe19618..c2d508b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dprtc.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dprtc.h
@@ -22,24 +22,4 @@ int dprtc_close(struct fsl_mc_io *mc_io,
 		u32 cmd_flags,
 		u16 token);
 
-int dprtc_set_freq_compensation(struct fsl_mc_io *mc_io,
-				u32 cmd_flags,
-				u16 token,
-				u32 freq_compensation);
-
-int dprtc_get_freq_compensation(struct fsl_mc_io *mc_io,
-				u32 cmd_flags,
-				u16 token,
-				u32 *freq_compensation);
-
-int dprtc_get_time(struct fsl_mc_io *mc_io,
-		   u32 cmd_flags,
-		   u16 token,
-		   uint64_t *time);
-
-int dprtc_set_time(struct fsl_mc_io *mc_io,
-		   u32 cmd_flags,
-		   u16 token,
-		   uint64_t time);
-
 #endif /* __FSL_DPRTC_H */
-- 
2.7.4

