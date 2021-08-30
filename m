Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27AB13FBF9A
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 01:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239170AbhH3Xxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 19:53:44 -0400
Received: from smtp.emailarray.com ([69.28.212.198]:18291 "EHLO
        smtp2.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239165AbhH3Xxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 19:53:40 -0400
Received: (qmail 78150 invoked by uid 89); 30 Aug 2021 23:52:45 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp2.emailarray.com with SMTP; 30 Aug 2021 23:52:45 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, abyagowi@fb.com
Subject: [PATCH net-next 07/11] ptp: ocp: Add IRIG-B and DCF blocks
Date:   Mon, 30 Aug 2021 16:52:32 -0700
Message-Id: <20210830235236.309993-8-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210830235236.309993-1-jonathan.lemon@gmail.com>
References: <20210830235236.309993-1-jonathan.lemon@gmail.com>
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
 drivers/ptp/ptp_ocp.c | 123 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 3920bdb1977a..fceeee380d9f 100644
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
@@ -1295,6 +1357,49 @@ sma_show_inputs(u32 val, char *buf)
 	return count;
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
 static int
 sma_parse_inputs(const char *buf)
 {
@@ -1319,6 +1424,20 @@ sma_parse_inputs(const char *buf)
 	return ret;
 }
 
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
 static ssize_t
 sma2_out_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -1355,6 +1474,7 @@ sma2_out_store(struct device *dev, struct device_attribute *attr,
 	spin_lock_irqsave(&bp->lock, flags);
 	gpio = ioread32(&bp->sma->gpio2);
 	gpio = (gpio & 0xffff0000) | val;
+	__handle_signal_outputs(bp, gpio);
 	iowrite32(gpio, &bp->sma->gpio2);
 	spin_unlock_irqrestore(&bp->lock, flags);
 
@@ -1378,6 +1498,7 @@ sma1_out_store(struct device *dev, struct device_attribute *attr,
 	spin_lock_irqsave(&bp->lock, flags);
 	gpio = ioread32(&bp->sma->gpio2);
 	gpio = (gpio & 0xffff) | (val << 16);
+	__handle_signal_outputs(bp, gpio);
 	iowrite32(gpio, &bp->sma->gpio2);
 	spin_unlock_irqrestore(&bp->lock, flags);
 
@@ -1423,6 +1544,7 @@ sma4_in_store(struct device *dev, struct device_attribute *attr,
 	spin_lock_irqsave(&bp->lock, flags);
 	gpio = ioread32(&bp->sma->gpio1);
 	gpio = (gpio & 0xffff0000) | val;
+	__handle_signal_inputs(bp, gpio);
 	iowrite32(gpio, &bp->sma->gpio1);
 	spin_unlock_irqrestore(&bp->lock, flags);
 
@@ -1446,6 +1568,7 @@ sma3_in_store(struct device *dev, struct device_attribute *attr,
 	spin_lock_irqsave(&bp->lock, flags);
 	gpio = ioread32(&bp->sma->gpio1);
 	gpio = (gpio & 0xffff) | (val << 16);
+	__handle_signal_inputs(bp, gpio);
 	iowrite32(gpio, &bp->sma->gpio1);
 	spin_unlock_irqrestore(&bp->lock, flags);
 
-- 
2.31.1

