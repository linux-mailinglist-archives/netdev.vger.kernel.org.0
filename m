Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D76A40BD9F
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 04:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236116AbhIOCSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 22:18:13 -0400
Received: from smtp5.emailarray.com ([65.39.216.39]:44112 "EHLO
        smtp5.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbhIOCSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 22:18:05 -0400
Received: (qmail 83522 invoked by uid 89); 15 Sep 2021 02:16:46 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 15 Sep 2021 02:16:46 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 08/18] ptp: ocp: Add IRIG-B and DCF blocks
Date:   Tue, 14 Sep 2021 19:16:26 -0700
Message-Id: <20210915021636.153754-9-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915021636.153754-1-jonathan.lemon@gmail.com>
References: <20210915021636.153754-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IRIG (Inter-range Instrumentation Group) timecode format on
one of the SMA output channels is provided by the IRIG master
FPGA block.  Enable the master when the IRIG output format is
selected on either one of the output channels.

By default, the output is in B007 format.

DCF output format is provided by the DCF master block.

Also enable the IRIG and DCF slaves, which parse an incoming
signal from the external SMA connectors, and may be used to
adjust the PHC.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 129 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 129 insertions(+)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 7441dac4e9c5..1a210b77744c 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -131,6 +131,48 @@ struct gpio_reg {
 	u32	__pad1;
 };
 
+struct irig_master_reg {
+	u32	ctrl;
+	u32	status;
+	u32	__pad0;
+	u32	version;
+	u32	adj_sec;
+	u32	mode_ctrl;
+};
+
+#define IRIG_M_CTRL_ENABLE	BIT(0)
+
+struct irig_slave_reg {
+	u32	ctrl;
+	u32	status;
+	u32	__pad0;
+	u32	version;
+	u32	adj_sec;
+	u32	mode_ctrl;
+};
+
+#define IRIG_S_CTRL_ENABLE	BIT(0)
+
+struct dcf_master_reg {
+	u32	ctrl;
+	u32	status;
+	u32	__pad0;
+	u32	version;
+	u32	adj_sec;
+};
+
+#define DCF_M_CTRL_ENABLE	BIT(0)
+
+struct dcf_slave_reg {
+	u32	ctrl;
+	u32	status;
+	u32	__pad0;
+	u32	version;
+	u32	adj_sec;
+};
+
+#define DCF_S_CTRL_ENABLE	BIT(0)
+
 struct ptp_ocp_flash_info {
 	const char *name;
 	int pci_offset;
@@ -167,6 +209,10 @@ struct ptp_ocp {
 	struct pps_reg __iomem	*pps_to_ext;
 	struct pps_reg __iomem	*pps_to_clk;
 	struct gpio_reg __iomem	*sma;
+	struct irig_master_reg	__iomem *irig_out;
+	struct irig_slave_reg	__iomem *irig_in;
+	struct dcf_master_reg	__iomem *dcf_out;
+	struct dcf_slave_reg	__iomem *dcf_in;
 	struct ptp_ocp_ext_src	*pps;
 	struct ptp_ocp_ext_src	*ts0;
 	struct ptp_ocp_ext_src	*ts1;
@@ -287,6 +333,22 @@ static struct ocp_resource ocp_fb_resource[] = {
 		OCP_MEM_RESOURCE(tod),
 		.offset = 0x01050000, .size = 0x10000,
 	},
+	{
+		OCP_MEM_RESOURCE(irig_in),
+		.offset = 0x01070000, .size = 0x10000,
+	},
+	{
+		OCP_MEM_RESOURCE(irig_out),
+		.offset = 0x01080000, .size = 0x10000,
+	},
+	{
+		OCP_MEM_RESOURCE(dcf_in),
+		.offset = 0x01090000, .size = 0x10000,
+	},
+	{
+		OCP_MEM_RESOURCE(dcf_out),
+		.offset = 0x010A0000, .size = 0x10000,
+	},
 	{
 		OCP_MEM_RESOURCE(image),
 		.offset = 0x00020000, .size = 0x1000,
@@ -366,6 +428,8 @@ static struct ocp_selector ptp_ocp_sma_in[] = {
 	{ .name = "PPS2",	.value = 0x02 },
 	{ .name = "TS1",	.value = 0x04 },
 	{ .name = "TS2",	.value = 0x08 },
+	{ .name = "IRIG",	.value = 0x10 },
+	{ .name = "DCF",	.value = 0x20 },
 	{ }
 };
 
@@ -375,6 +439,8 @@ static struct ocp_selector ptp_ocp_sma_out[] = {
 	{ .name = "MAC",	.value = 0x02 },
 	{ .name = "GNSS",	.value = 0x04 },
 	{ .name = "GNSS2",	.value = 0x08 },
+	{ .name = "IRIG",	.value = 0x10 },
+	{ .name = "DCF",	.value = 0x20 },
 	{ }
 };
 
@@ -1229,6 +1295,63 @@ ptp_ocp_register_resources(struct ptp_ocp *bp, kernel_ulong_t driver_data)
 	return err;
 }
 
+static void
+ptp_ocp_enable_fpga(u32 __iomem *reg, u32 bit, bool enable)
+{
+	u32 ctrl;
+	bool on;
+
+	ctrl = ioread32(reg);
+	on = ctrl & bit;
+	if (on ^ enable) {
+		ctrl &= ~bit;
+		ctrl |= enable ? bit : 0;
+		iowrite32(ctrl, reg);
+	}
+}
+
+static void
+ptp_ocp_irig_out(struct ptp_ocp *bp, bool enable)
+{
+	return ptp_ocp_enable_fpga(&bp->irig_out->ctrl,
+				   IRIG_M_CTRL_ENABLE, enable);
+}
+
+static void
+ptp_ocp_irig_in(struct ptp_ocp *bp, bool enable)
+{
+	return ptp_ocp_enable_fpga(&bp->irig_in->ctrl,
+				   IRIG_S_CTRL_ENABLE, enable);
+}
+
+static void
+ptp_ocp_dcf_out(struct ptp_ocp *bp, bool enable)
+{
+	return ptp_ocp_enable_fpga(&bp->dcf_out->ctrl,
+				   DCF_M_CTRL_ENABLE, enable);
+}
+
+static void
+ptp_ocp_dcf_in(struct ptp_ocp *bp, bool enable)
+{
+	return ptp_ocp_enable_fpga(&bp->dcf_in->ctrl,
+				   DCF_S_CTRL_ENABLE, enable);
+}
+
+static void
+__handle_signal_outputs(struct ptp_ocp *bp, u32 val)
+{
+	ptp_ocp_irig_out(bp, val & 0x00100010);
+	ptp_ocp_dcf_out(bp, val & 0x00200020);
+}
+
+static void
+__handle_signal_inputs(struct ptp_ocp *bp, u32 val)
+{
+	ptp_ocp_irig_in(bp, val & 0x00100010);
+	ptp_ocp_dcf_in(bp, val & 0x00200020);
+}
+
 /*
  * ANT0 == gps	(in)
  * ANT1 == sma1 (in)
@@ -1406,6 +1529,9 @@ ptp_ocp_sma_store_output(struct ptp_ocp *bp, u32 val, u32 shift)
 
 	gpio = ioread32(&bp->sma->gpio2);
 	gpio = (gpio & mask) | (val << shift);
+
+	__handle_signal_outputs(bp, gpio);
+
 	iowrite32(gpio, &bp->sma->gpio2);
 
 	spin_unlock_irqrestore(&bp->lock, flags);
@@ -1423,6 +1549,9 @@ ptp_ocp_sma_store_inputs(struct ptp_ocp *bp, u32 val, u32 shift)
 
 	gpio = ioread32(&bp->sma->gpio1);
 	gpio = (gpio & mask) | (val << shift);
+
+	__handle_signal_inputs(bp, gpio);
+
 	iowrite32(gpio, &bp->sma->gpio1);
 
 	spin_unlock_irqrestore(&bp->lock, flags);
-- 
2.31.1

