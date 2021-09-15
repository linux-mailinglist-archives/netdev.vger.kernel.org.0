Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADD140BDA3
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 04:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236225AbhIOCST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 22:18:19 -0400
Received: from smtp5.emailarray.com ([65.39.216.39]:44261 "EHLO
        smtp5.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235649AbhIOCSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 22:18:11 -0400
Received: (qmail 83667 invoked by uid 89); 15 Sep 2021 02:16:52 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 15 Sep 2021 02:16:52 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 13/18] ptp: ocp: Add NMEA output
Date:   Tue, 14 Sep 2021 19:16:31 -0700
Message-Id: <20210915021636.153754-14-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915021636.153754-1-jonathan.lemon@gmail.com>
References: <20210915021636.153754-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The timecard can provide a NMEA-1083 ZDA (time and date) output
string on a serial port, which can be used to drive other devices.

Add the NMEA resources, and the serial port as a sysfs attribute.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 57 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 36924423444e..74b5561fbdae 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -215,6 +215,7 @@ struct ptp_ocp {
 	struct irig_slave_reg	__iomem *irig_in;
 	struct dcf_master_reg	__iomem *dcf_out;
 	struct dcf_slave_reg	__iomem *dcf_in;
+	struct tod_reg		__iomem *nmea_out;
 	struct ptp_ocp_ext_src	*pps;
 	struct ptp_ocp_ext_src	*ts0;
 	struct ptp_ocp_ext_src	*ts1;
@@ -232,6 +233,7 @@ struct ptp_ocp {
 	int			n_irqs;
 	int			gnss_port;
 	int			mac_port;	/* miniature atomic clock */
+	int			nmea_port;
 	u8			serial[6];
 	bool			has_serial;
 	int			flash_start;
@@ -289,8 +291,9 @@ static int ptp_ocp_ts_enable(void *priv, bool enable);
  * 5: MAC
  * 6: TS2
  * 7: I2C controller
- * 8: HWICAP
+ * 8: HWICAP (notused)
  * 9: SPI Flash
+ * 10: NMEA
  */
 
 static struct ocp_resource ocp_fb_resource[] = {
@@ -353,6 +356,10 @@ static struct ocp_resource ocp_fb_resource[] = {
 		OCP_MEM_RESOURCE(dcf_out),
 		.offset = 0x010A0000, .size = 0x10000,
 	},
+	{
+		OCP_MEM_RESOURCE(nmea_out),
+		.offset = 0x010B0000, .size = 0x10000,
+	},
 	{
 		OCP_MEM_RESOURCE(image),
 		.offset = 0x00020000, .size = 0x1000,
@@ -381,6 +388,10 @@ static struct ocp_resource ocp_fb_resource[] = {
 		OCP_SERIAL_RESOURCE(mac_port),
 		.offset = 0x00180000 + 0x1000, .irq_vec = 5,
 	},
+	{
+		OCP_SERIAL_RESOURCE(nmea_port),
+		.offset = 0x00190000 + 0x1000, .irq_vec = 10,
+	},
 	{
 		OCP_SPI_RESOURCE(spi_flash),
 		.offset = 0x00310000, .size = 0x10000, .irq_vec = 9,
@@ -761,6 +772,8 @@ ptp_ocp_utc_distribute(struct ptp_ocp *bp, u32 val)
 		iowrite32(val, &bp->irig_out->adj_sec);
 	if (bp->dcf_out)
 		iowrite32(val, &bp->dcf_out->adj_sec);
+	if (bp->nmea_out)
+		iowrite32(val, &bp->nmea_out->adj_sec);
 
 	spin_unlock_irqrestore(&bp->lock, flags);
 }
@@ -1272,6 +1285,17 @@ ptp_ocp_register_mem(struct ptp_ocp *bp, struct ocp_resource *r)
 	return 0;
 }
 
+static void
+ptp_ocp_nmea_out_init(struct ptp_ocp *bp)
+{
+	if (!bp->nmea_out)
+		return;
+
+	iowrite32(0, &bp->nmea_out->ctrl);		/* disable */
+	iowrite32(7, &bp->nmea_out->uart_baud);		/* 115200 */
+	iowrite32(1, &bp->nmea_out->ctrl);		/* enable */
+}
+
 /* FB specific board initializers; last "resource" registered. */
 static int
 ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
@@ -1279,6 +1303,7 @@ ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
 	bp->flash_start = 1024 * 4096;
 
 	ptp_ocp_tod_init(bp);
+	ptp_ocp_nmea_out_init(bp);
 
 	return ptp_ocp_init_clock(bp);
 }
@@ -1941,6 +1966,13 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 			   on ? " ON" : "OFF", val, src);
 	}
 
+	if (bp->nmea_out) {
+		on = ioread32(&bp->nmea_out->ctrl) & 1;
+		val = ioread32(&bp->nmea_out->status);
+		seq_printf(s, "%7s: %s, error: %d\n", "NMEA",
+			   on ? " ON" : "OFF", val);
+	}
+
 	/* compute src for PPS1, used below. */
 	if (bp->pps_select) {
 		val = ioread32(&bp->pps_select->gpio1);
@@ -2069,6 +2101,7 @@ ptp_ocp_device_init(struct ptp_ocp *bp, struct pci_dev *pdev)
 	spin_lock_init(&bp->lock);
 	bp->gnss_port = -1;
 	bp->mac_port = -1;
+	bp->nmea_port = -1;
 	bp->pdev = pdev;
 
 	device_initialize(&bp->dev);
@@ -2134,6 +2167,10 @@ ptp_ocp_complete(struct ptp_ocp *bp)
 		sprintf(buf, "ttyS%d", bp->mac_port);
 		ptp_ocp_link_child(bp, buf, "ttyMAC");
 	}
+	if (bp->nmea_port != -1) {
+		sprintf(buf, "ttyS%d", bp->nmea_port);
+		ptp_ocp_link_child(bp, buf, "ttyNMEA");
+	}
 	sprintf(buf, "ptp%d", ptp_clock_index(bp->ptp));
 	ptp_ocp_link_child(bp, buf, "ptp");
 
@@ -2180,7 +2217,13 @@ ptp_ocp_serial_info(struct device *dev, const char *name, int port, int baud)
 static void
 ptp_ocp_info(struct ptp_ocp *bp)
 {
+	static int nmea_baud[] = {
+		1200, 2400, 4800, 9600, 19200, 38400,
+		57600, 115200, 230400, 460800, 921600,
+		1000000, 2000000
+	};
 	struct device *dev = &bp->pdev->dev;
+	u32 reg;
 
 	ptp_ocp_phc_info(bp);
 	if (bp->tod)
@@ -2199,6 +2242,14 @@ ptp_ocp_info(struct ptp_ocp *bp)
 	}
 	ptp_ocp_serial_info(dev, "GNSS", bp->gnss_port, 115200);
 	ptp_ocp_serial_info(dev, "MAC", bp->mac_port, 57600);
+	if (bp->nmea_out && bp->nmea_port != -1) {
+		int baud = -1;
+
+		reg = ioread32(&bp->nmea_out->uart_baud);
+		if (reg < ARRAY_SIZE(nmea_baud))
+			baud = nmea_baud[reg];
+		ptp_ocp_serial_info(dev, "NMEA", bp->nmea_port, baud);
+	}
 }
 
 static void
@@ -2232,6 +2283,8 @@ ptp_ocp_detach(struct ptp_ocp *bp)
 		serial8250_unregister_port(bp->gnss_port);
 	if (bp->mac_port != -1)
 		serial8250_unregister_port(bp->mac_port);
+	if (bp->nmea_port != -1)
+		serial8250_unregister_port(bp->nmea_port);
 	if (bp->spi_flash)
 		platform_device_unregister(bp->spi_flash);
 	if (bp->i2c_ctrl)
@@ -2278,7 +2331,7 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	 * allow this - if not all of the IRQ's are returned, skip the
 	 * extra devices and just register the clock.
 	 */
-	err = pci_alloc_irq_vectors(pdev, 1, 10, PCI_IRQ_MSI | PCI_IRQ_MSIX);
+	err = pci_alloc_irq_vectors(pdev, 1, 11, PCI_IRQ_MSI | PCI_IRQ_MSIX);
 	if (err < 0) {
 		dev_err(&pdev->dev, "alloc_irq_vectors err: %d\n", err);
 		goto out;
-- 
2.31.1

