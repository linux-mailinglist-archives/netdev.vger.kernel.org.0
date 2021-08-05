Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1AF3E1D1B
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 21:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243070AbhHET7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 15:59:54 -0400
Received: from smtp3.emailarray.com ([65.39.216.17]:46488 "EHLO
        smtp3.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242999AbhHET7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 15:59:50 -0400
Received: (qmail 35052 invoked by uid 89); 5 Aug 2021 19:52:53 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 5 Aug 2021 19:52:53 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 4/6] ptp: ocp: Use 'gnss' naming instead of 'gps'
Date:   Thu,  5 Aug 2021 12:52:46 -0700
Message-Id: <20210805195248.35665-5-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210805195248.35665-1-jonathan.lemon@gmail.com>
References: <20210805195248.35665-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GPS is not the only available positioning system.  Use the generic
naming of "GNSS" instead.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 33cbd3135a00..f744bb42f48f 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -163,10 +163,10 @@ struct ptp_ocp {
 	struct platform_device	*spi_flash;
 	struct clk_hw		*i2c_clk;
 	struct timer_list	watchdog;
-	time64_t		gps_lost;
+	time64_t		gnss_lost;
 	int			id;
 	int			n_irqs;
-	int			gps_port;
+	int			gnss_port;
 	int			mac_port;	/* miniature atomic clock */
 	u8			serial[6];
 	int			flash_start;
@@ -272,7 +272,7 @@ static struct ocp_resource ocp_fb_resource[] = {
 		.offset = 0x00150000, .size = 0x10000, .irq_vec = 7,
 	},
 	{
-		OCP_SERIAL_RESOURCE(gps_port),
+		OCP_SERIAL_RESOURCE(gnss_port),
 		.offset = 0x00160000 + 0x1000, .irq_vec = 3,
 	},
 	{
@@ -546,15 +546,15 @@ ptp_ocp_watchdog(struct timer_list *t)
 
 	if (status & PPS_STATUS_SUPERV_ERR) {
 		iowrite32(status, &bp->pps_to_clk->status);
-		if (!bp->gps_lost) {
+		if (!bp->gnss_lost) {
 			spin_lock_irqsave(&bp->lock, flags);
 			__ptp_ocp_clear_drift_locked(bp);
 			spin_unlock_irqrestore(&bp->lock, flags);
-			bp->gps_lost = ktime_get_real_seconds();
+			bp->gnss_lost = ktime_get_real_seconds();
 		}
 
-	} else if (bp->gps_lost) {
-		bp->gps_lost = 0;
+	} else if (bp->gnss_lost) {
+		bp->gnss_lost = 0;
 	}
 
 	mod_timer(&bp->watchdog, jiffies + HZ);
@@ -1195,19 +1195,19 @@ serialnum_show(struct device *dev, struct device_attribute *attr, char *buf)
 static DEVICE_ATTR_RO(serialnum);
 
 static ssize_t
-gps_sync_show(struct device *dev, struct device_attribute *attr, char *buf)
+gnss_sync_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct ptp_ocp *bp = dev_get_drvdata(dev);
 	ssize_t ret;
 
-	if (bp->gps_lost)
-		ret = sysfs_emit(buf, "LOST @ %ptT\n", &bp->gps_lost);
+	if (bp->gnss_lost)
+		ret = sysfs_emit(buf, "LOST @ %ptT\n", &bp->gnss_lost);
 	else
 		ret = sysfs_emit(buf, "SYNC\n");
 
 	return ret;
 }
-static DEVICE_ATTR_RO(gps_sync);
+static DEVICE_ATTR_RO(gnss_sync);
 
 static ssize_t
 clock_source_show(struct device *dev, struct device_attribute *attr, char *buf)
@@ -1264,7 +1264,7 @@ static DEVICE_ATTR_RO(available_clock_sources);
 
 static struct attribute *timecard_attrs[] = {
 	&dev_attr_serialnum.attr,
-	&dev_attr_gps_sync.attr,
+	&dev_attr_gnss_sync.attr,
 	&dev_attr_clock_source.attr,
 	&dev_attr_available_clock_sources.attr,
 	NULL,
@@ -1297,7 +1297,7 @@ ptp_ocp_device_init(struct ptp_ocp *bp, struct pci_dev *pdev)
 
 	bp->ptp_info = ptp_ocp_clock_info;
 	spin_lock_init(&bp->lock);
-	bp->gps_port = -1;
+	bp->gnss_port = -1;
 	bp->mac_port = -1;
 	bp->pdev = pdev;
 
@@ -1356,9 +1356,9 @@ ptp_ocp_complete(struct ptp_ocp *bp)
 	struct pps_device *pps;
 	char buf[32];
 
-	if (bp->gps_port != -1) {
-		sprintf(buf, "ttyS%d", bp->gps_port);
-		ptp_ocp_link_child(bp, buf, "ttyGPS");
+	if (bp->gnss_port != -1) {
+		sprintf(buf, "ttyS%d", bp->gnss_port);
+		ptp_ocp_link_child(bp, buf, "ttyGNSS");
 	}
 	if (bp->mac_port != -1) {
 		sprintf(buf, "ttyS%d", bp->mac_port);
@@ -1393,8 +1393,8 @@ ptp_ocp_resource_summary(struct ptp_ocp *bp)
 			dev_info(dev, "golden image, version %d\n",
 				 ver >> 16);
 	}
-	if (bp->gps_port != -1)
-		dev_info(dev, "GPS @ /dev/ttyS%d  115200\n", bp->gps_port);
+	if (bp->gnss_port != -1)
+		dev_info(dev, "GNSS @ /dev/ttyS%d 115200\n", bp->gnss_port);
 	if (bp->mac_port != -1)
 		dev_info(dev, "MAC @ /dev/ttyS%d   57600\n", bp->mac_port);
 }
@@ -1404,7 +1404,7 @@ ptp_ocp_detach_sysfs(struct ptp_ocp *bp)
 {
 	struct device *dev = &bp->dev;
 
-	sysfs_remove_link(&dev->kobj, "ttyGPS");
+	sysfs_remove_link(&dev->kobj, "ttyGNSS");
 	sysfs_remove_link(&dev->kobj, "ttyMAC");
 	sysfs_remove_link(&dev->kobj, "ptp");
 	sysfs_remove_link(&dev->kobj, "pps");
@@ -1423,8 +1423,8 @@ ptp_ocp_detach(struct ptp_ocp *bp)
 		ptp_ocp_unregister_ext(bp->ts1);
 	if (bp->pps)
 		ptp_ocp_unregister_ext(bp->pps);
-	if (bp->gps_port != -1)
-		serial8250_unregister_port(bp->gps_port);
+	if (bp->gnss_port != -1)
+		serial8250_unregister_port(bp->gnss_port);
 	if (bp->mac_port != -1)
 		serial8250_unregister_port(bp->mac_port);
 	if (bp->spi_flash)
-- 
2.31.1

