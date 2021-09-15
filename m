Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B5440BDA4
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 04:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236236AbhIOCSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 22:18:20 -0400
Received: from smtp5.emailarray.com ([65.39.216.39]:44300 "EHLO
        smtp5.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236078AbhIOCSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 22:18:12 -0400
Received: (qmail 83692 invoked by uid 89); 15 Sep 2021 02:16:53 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 15 Sep 2021 02:16:53 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 14/18] ptp: ocp: Add second GNSS device
Date:   Tue, 14 Sep 2021 19:16:32 -0700
Message-Id: <20210915021636.153754-15-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915021636.153754-1-jonathan.lemon@gmail.com>
References: <20210915021636.153754-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Upcoming boards may have a second GNSS receiver, getting information
from a different constellation than the first receiver, which provides
some measure of anti-spoofing.

Expose the sysfs attribute for this device, if detected.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 74b5561fbdae..d0e3096f53f6 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -232,6 +232,7 @@ struct ptp_ocp {
 	int			id;
 	int			n_irqs;
 	int			gnss_port;
+	int			gnss2_port;
 	int			mac_port;	/* miniature atomic clock */
 	int			nmea_port;
 	u8			serial[6];
@@ -286,8 +287,8 @@ static int ptp_ocp_ts_enable(void *priv, bool enable);
  * 0: N/C
  * 1: TS0
  * 2: TS1
- * 3: GPS
- * 4: GPS2 (n/c)
+ * 3: GNSS
+ * 4: GNSS2
  * 5: MAC
  * 6: TS2
  * 7: I2C controller
@@ -384,6 +385,10 @@ static struct ocp_resource ocp_fb_resource[] = {
 		OCP_SERIAL_RESOURCE(gnss_port),
 		.offset = 0x00160000 + 0x1000, .irq_vec = 3,
 	},
+	{
+		OCP_SERIAL_RESOURCE(gnss2_port),
+		.offset = 0x00170000 + 0x1000, .irq_vec = 4,
+	},
 	{
 		OCP_SERIAL_RESOURCE(mac_port),
 		.offset = 0x00180000 + 0x1000, .irq_vec = 5,
@@ -2100,6 +2105,7 @@ ptp_ocp_device_init(struct ptp_ocp *bp, struct pci_dev *pdev)
 	bp->ptp_info = ptp_ocp_clock_info;
 	spin_lock_init(&bp->lock);
 	bp->gnss_port = -1;
+	bp->gnss2_port = -1;
 	bp->mac_port = -1;
 	bp->nmea_port = -1;
 	bp->pdev = pdev;
@@ -2163,6 +2169,10 @@ ptp_ocp_complete(struct ptp_ocp *bp)
 		sprintf(buf, "ttyS%d", bp->gnss_port);
 		ptp_ocp_link_child(bp, buf, "ttyGNSS");
 	}
+	if (bp->gnss2_port != -1) {
+		sprintf(buf, "ttyS%d", bp->gnss2_port);
+		ptp_ocp_link_child(bp, buf, "ttyGNSS2");
+	}
 	if (bp->mac_port != -1) {
 		sprintf(buf, "ttyS%d", bp->mac_port);
 		ptp_ocp_link_child(bp, buf, "ttyMAC");
@@ -2241,6 +2251,7 @@ ptp_ocp_info(struct ptp_ocp *bp)
 				 ver >> 16);
 	}
 	ptp_ocp_serial_info(dev, "GNSS", bp->gnss_port, 115200);
+	ptp_ocp_serial_info(dev, "GNSS2", bp->gnss2_port, 115200);
 	ptp_ocp_serial_info(dev, "MAC", bp->mac_port, 57600);
 	if (bp->nmea_out && bp->nmea_port != -1) {
 		int baud = -1;
@@ -2281,6 +2292,8 @@ ptp_ocp_detach(struct ptp_ocp *bp)
 		ptp_ocp_unregister_ext(bp->pps);
 	if (bp->gnss_port != -1)
 		serial8250_unregister_port(bp->gnss_port);
+	if (bp->gnss2_port != -1)
+		serial8250_unregister_port(bp->gnss2_port);
 	if (bp->mac_port != -1)
 		serial8250_unregister_port(bp->mac_port);
 	if (bp->nmea_port != -1)
-- 
2.31.1

