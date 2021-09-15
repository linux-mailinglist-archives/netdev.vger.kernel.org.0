Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE59A40BDA1
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 04:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236128AbhIOCSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 22:18:15 -0400
Received: from smtp7.emailarray.com ([65.39.216.66]:33352 "EHLO
        smtp7.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236079AbhIOCSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 22:18:09 -0400
Received: (qmail 8889 invoked by uid 89); 15 Sep 2021 02:16:50 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 15 Sep 2021 02:16:50 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 11/18] ptp: ocp: Separate the init and info logic
Date:   Tue, 14 Sep 2021 19:16:29 -0700
Message-Id: <20210915021636.153754-12-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915021636.153754-1-jonathan.lemon@gmail.com>
References: <20210915021636.153754-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On startup, parts of the FPGA need to be initialized - break these
out into their own functions, separate from the purely informational
blocks.

On startup, distrbute the UTC:TAI offset from the NMEA GNSS parser,
if it is available.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 96 +++++++++++++++++++++++++++----------------
 1 file changed, 60 insertions(+), 36 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 2c3af3c9def7..ea12f685edf6 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -72,7 +72,7 @@ struct tod_reg {
 	u32	status;
 	u32	uart_polarity;
 	u32	version;
-	u32	correction_sec;
+	u32	adj_sec;
 	u32	__pad0[3];
 	u32	uart_baud;
 	u32	__pad1[3];
@@ -728,16 +728,15 @@ ptp_ocp_init_clock(struct ptp_ocp *bp)
 
 	sync = ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
 	if (!sync) {
-		ktime_get_real_ts64(&ts);
+		ktime_get_clocktai_ts64(&ts);
 		ptp_ocp_settime(&bp->ptp_info, &ts);
 	}
-	if (!ptp_ocp_gettimex(&bp->ptp_info, &ts, NULL))
-		dev_info(&bp->pdev->dev, "Time: %lld.%ld, %s\n",
-			 ts.tv_sec, ts.tv_nsec,
-			 sync ? "in-sync" : "UNSYNCED");
 
-	timer_setup(&bp->watchdog, ptp_ocp_watchdog, 0);
-	mod_timer(&bp->watchdog, jiffies + HZ);
+	/* If there is a clock supervisor, then enable the watchdog */
+	if (bp->pps_to_clk) {
+		timer_setup(&bp->watchdog, ptp_ocp_watchdog, 0);
+		mod_timer(&bp->watchdog, jiffies + HZ);
+	}
 
 	return 0;
 }
@@ -759,6 +758,21 @@ ptp_ocp_utc_distribute(struct ptp_ocp *bp, u32 val)
 	spin_unlock_irqrestore(&bp->lock, flags);
 }
 
+static void
+ptp_ocp_tod_init(struct ptp_ocp *bp)
+{
+	u32 ctrl, reg;
+
+	ctrl = ioread32(&bp->tod->ctrl);
+	ctrl |= TOD_CTRL_PROTOCOL | TOD_CTRL_ENABLE;
+	ctrl &= ~(TOD_CTRL_DISABLE_FMT_A | TOD_CTRL_DISABLE_FMT_B);
+	iowrite32(ctrl, &bp->tod->ctrl);
+
+	reg = ioread32(&bp->tod->utc_status);
+	if (reg & TOD_STATUS_UTC_VALID)
+		ptp_ocp_utc_distribute(bp, reg & TOD_STATUS_UTC_MASK);
+}
+
 static void
 ptp_ocp_tod_info(struct ptp_ocp *bp)
 {
@@ -776,11 +790,6 @@ ptp_ocp_tod_info(struct ptp_ocp *bp)
 	dev_info(&bp->pdev->dev, "TOD Version %d.%d.%d\n",
 		 version >> 24, (version >> 16) & 0xff, version & 0xffff);
 
-	ctrl = ioread32(&bp->tod->ctrl);
-	ctrl |= TOD_CTRL_PROTOCOL | TOD_CTRL_ENABLE;
-	ctrl &= ~(TOD_CTRL_DISABLE_FMT_A | TOD_CTRL_DISABLE_FMT_B);
-	iowrite32(ctrl, &bp->tod->ctrl);
-
 	ctrl = ioread32(&bp->tod->ctrl);
 	idx = ctrl & TOD_CTRL_PROTOCOL ? 4 : 0;
 	idx += (ctrl >> 16) & 3;
@@ -795,7 +804,7 @@ ptp_ocp_tod_info(struct ptp_ocp *bp)
 	reg = ioread32(&bp->tod->status);
 	dev_info(&bp->pdev->dev, "status: %x\n", reg);
 
-	reg = ioread32(&bp->tod->correction_sec);
+	reg = ioread32(&bp->tod->adj_sec);
 	dev_info(&bp->pdev->dev, "correction: %d\n", reg);
 
 	reg = ioread32(&bp->tod->utc_status);
@@ -879,22 +888,6 @@ ptp_ocp_get_serial_number(struct ptp_ocp *bp)
 	put_device(dev);
 }
 
-static void
-ptp_ocp_info(struct ptp_ocp *bp)
-{
-	u32 version, select;
-
-	version = ioread32(&bp->reg->version);
-	select = ioread32(&bp->reg->select);
-	dev_info(&bp->pdev->dev, "Version %d.%d.%d, clock %s, device ptp%d\n",
-		 version >> 24, (version >> 16) & 0xff, version & 0xffff,
-		 ptp_ocp_select_name_from_val(ptp_ocp_clock, select >> 16),
-		 ptp_clock_index(bp->ptp));
-
-	if (bp->tod)
-		ptp_ocp_tod_info(bp);
-}
-
 static struct device *
 ptp_ocp_find_flash(struct ptp_ocp *bp)
 {
@@ -1278,6 +1271,8 @@ ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
 {
 	bp->flash_start = 1024 * 4096;
 
+	ptp_ocp_tod_init(bp);
+
 	return ptp_ocp_init_clock(bp);
 }
 
@@ -1927,10 +1922,42 @@ ptp_ocp_complete(struct ptp_ocp *bp)
 }
 
 static void
-ptp_ocp_resource_summary(struct ptp_ocp *bp)
+ptp_ocp_phc_info(struct ptp_ocp *bp)
+{
+	struct timespec64 ts;
+	u32 version, select;
+	bool sync;
+
+	version = ioread32(&bp->reg->version);
+	select = ioread32(&bp->reg->select);
+	dev_info(&bp->pdev->dev, "Version %d.%d.%d, clock %s, device ptp%d\n",
+		 version >> 24, (version >> 16) & 0xff, version & 0xffff,
+		 ptp_ocp_select_name_from_val(ptp_ocp_clock, select >> 16),
+		 ptp_clock_index(bp->ptp));
+
+	sync = ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
+	if (!ptp_ocp_gettimex(&bp->ptp_info, &ts, NULL))
+		dev_info(&bp->pdev->dev, "Time: %lld.%ld, %s\n",
+			 ts.tv_sec, ts.tv_nsec,
+			 sync ? "in-sync" : "UNSYNCED");
+}
+
+static void
+ptp_ocp_serial_info(struct device *dev, const char *name, int port, int baud)
+{
+	if (port != -1)
+		dev_info(dev, "%5s: /dev/ttyS%-2d @ %6d\n", name, port, baud);
+}
+
+static void
+ptp_ocp_info(struct ptp_ocp *bp)
 {
 	struct device *dev = &bp->pdev->dev;
 
+	ptp_ocp_phc_info(bp);
+	if (bp->tod)
+		ptp_ocp_tod_info(bp);
+
 	if (bp->image) {
 		u32 ver = ioread32(&bp->image->version);
 
@@ -1942,10 +1969,8 @@ ptp_ocp_resource_summary(struct ptp_ocp *bp)
 			dev_info(dev, "golden image, version %d\n",
 				 ver >> 16);
 	}
-	if (bp->gnss_port != -1)
-		dev_info(dev, "GNSS @ /dev/ttyS%d 115200\n", bp->gnss_port);
-	if (bp->mac_port != -1)
-		dev_info(dev, "MAC @ /dev/ttyS%d   57600\n", bp->mac_port);
+	ptp_ocp_serial_info(dev, "GNSS", bp->gnss_port, 115200);
+	ptp_ocp_serial_info(dev, "MAC", bp->mac_port, 57600);
 }
 
 static void
@@ -2049,7 +2074,6 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out;
 
 	ptp_ocp_info(bp);
-	ptp_ocp_resource_summary(bp);
 
 	return 0;
 
-- 
2.31.1

