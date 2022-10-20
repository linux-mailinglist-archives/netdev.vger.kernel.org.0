Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9031D606BF2
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 01:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiJTXNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 19:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiJTXND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 19:13:03 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33973224AB6
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 16:13:02 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id BD22F504EEA;
        Fri, 21 Oct 2022 02:09:20 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru BD22F504EEA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1666307362; bh=mcBZqnZi+rzIBuZv1Kcg2q5X/hQ69dUYVSL3g9OdcTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=delm7JEX3rPcAl68idCvMfB1ptUdYtNed9Ve97xEv1Xf9oigDs2u6YmpWT//eKbQc
         Msyfvm+ONanu8HKPUjgfVYc6plcWr2OG0Ja1uefGDO7iJRq8xp1VjrBkuUc4crvzuG
         DmOJM+wt5RSI+7zJTn8vbJqAP139uwHiSUS+96Sc=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>
Subject: [PATCH net-next v5 1/5] ptp: ocp: upgrade serial line information
Date:   Fri, 21 Oct 2022 02:12:43 +0300
Message-Id: <20221020231247.7243-2-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221020231247.7243-1-vfedorenko@novek.ru>
References: <20221020231247.7243-1-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vadfed@fb.com>

Introduce structure to hold serial port line number and the baud rate
it supports.

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
---
 drivers/ptp/ptp_ocp.c | 110 +++++++++++++++++++++++++-----------------
 1 file changed, 67 insertions(+), 43 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index a48d9b7d2921..1ce0f2989a85 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -278,6 +278,11 @@ struct ptp_ocp_signal {
 	bool		running;
 };
 
+struct ptp_ocp_serial_port {
+	int line;
+	int baud;
+};
+
 #define OCP_BOARD_ID_LEN		13
 #define OCP_SERIAL_LEN			6
 
@@ -318,10 +323,10 @@ struct ptp_ocp {
 	time64_t		gnss_lost;
 	int			id;
 	int			n_irqs;
-	int			gnss_port;
-	int			gnss2_port;
-	int			mac_port;	/* miniature atomic clock */
-	int			nmea_port;
+	struct ptp_ocp_serial_port	gnss_port;
+	struct ptp_ocp_serial_port	gnss2_port;
+	struct ptp_ocp_serial_port	mac_port;   /* miniature atomic clock */
+	struct ptp_ocp_serial_port	nmea_port;
 	bool			fw_loader;
 	u8			fw_tag;
 	u16			fw_version;
@@ -596,14 +601,23 @@ static struct ocp_resource ocp_fb_resource[] = {
 	{
 		OCP_SERIAL_RESOURCE(gnss_port),
 		.offset = 0x00160000 + 0x1000, .irq_vec = 3,
+		.extra = &(struct ptp_ocp_serial_port) {
+			.baud = 115200,
+		},
 	},
 	{
 		OCP_SERIAL_RESOURCE(gnss2_port),
 		.offset = 0x00170000 + 0x1000, .irq_vec = 4,
+		.extra = &(struct ptp_ocp_serial_port) {
+			.baud = 115200,
+		},
 	},
 	{
 		OCP_SERIAL_RESOURCE(mac_port),
 		.offset = 0x00180000 + 0x1000, .irq_vec = 5,
+		.extra = &(struct ptp_ocp_serial_port) {
+			.baud = 57600,
+		},
 	},
 	{
 		OCP_SERIAL_RESOURCE(nmea_port),
@@ -1872,11 +1886,15 @@ ptp_ocp_serial_line(struct ptp_ocp *bp, struct ocp_resource *r)
 static int
 ptp_ocp_register_serial(struct ptp_ocp *bp, struct ocp_resource *r)
 {
-	int port;
+	struct ptp_ocp_serial_port *p = (struct ptp_ocp_serial_port *)r->extra;
+	struct ptp_ocp_serial_port port = {};
+
+	port.line = ptp_ocp_serial_line(bp, r);
+	if (port.line < 0)
+		return port.line;
 
-	port = ptp_ocp_serial_line(bp, r);
-	if (port < 0)
-		return port;
+	if (p)
+		port.baud = p->baud;
 
 	bp_assign_entry(bp, r, port);
 
@@ -3177,14 +3195,16 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 	bp = dev_get_drvdata(dev);
 
 	seq_printf(s, "%7s: /dev/ptp%d\n", "PTP", ptp_clock_index(bp->ptp));
-	if (bp->gnss_port != -1)
-		seq_printf(s, "%7s: /dev/ttyS%d\n", "GNSS1", bp->gnss_port);
-	if (bp->gnss2_port != -1)
-		seq_printf(s, "%7s: /dev/ttyS%d\n", "GNSS2", bp->gnss2_port);
-	if (bp->mac_port != -1)
-		seq_printf(s, "%7s: /dev/ttyS%d\n", "MAC", bp->mac_port);
-	if (bp->nmea_port != -1)
-		seq_printf(s, "%7s: /dev/ttyS%d\n", "NMEA", bp->nmea_port);
+	if (bp->gnss_port.line != -1)
+		seq_printf(s, "%7s: /dev/ttyS%d\n", "GNSS1",
+			   bp->gnss_port.line);
+	if (bp->gnss2_port.line != -1)
+		seq_printf(s, "%7s: /dev/ttyS%d\n", "GNSS2",
+			   bp->gnss2_port.line);
+	if (bp->mac_port.line != -1)
+		seq_printf(s, "%7s: /dev/ttyS%d\n", "MAC", bp->mac_port.line);
+	if (bp->nmea_port.line != -1)
+		seq_printf(s, "%7s: /dev/ttyS%d\n", "NMEA", bp->nmea_port.line);
 
 	memset(sma_val, 0xff, sizeof(sma_val));
 	if (bp->sma_map1) {
@@ -3508,10 +3528,10 @@ ptp_ocp_device_init(struct ptp_ocp *bp, struct pci_dev *pdev)
 
 	bp->ptp_info = ptp_ocp_clock_info;
 	spin_lock_init(&bp->lock);
-	bp->gnss_port = -1;
-	bp->gnss2_port = -1;
-	bp->mac_port = -1;
-	bp->nmea_port = -1;
+	bp->gnss_port.line = -1;
+	bp->gnss2_port.line = -1;
+	bp->mac_port.line = -1;
+	bp->nmea_port.line = -1;
 	bp->pdev = pdev;
 
 	device_initialize(&bp->dev);
@@ -3569,20 +3589,20 @@ ptp_ocp_complete(struct ptp_ocp *bp)
 	struct pps_device *pps;
 	char buf[32];
 
-	if (bp->gnss_port != -1) {
-		sprintf(buf, "ttyS%d", bp->gnss_port);
+	if (bp->gnss_port.line != -1) {
+		sprintf(buf, "ttyS%d", bp->gnss_port.line);
 		ptp_ocp_link_child(bp, buf, "ttyGNSS");
 	}
-	if (bp->gnss2_port != -1) {
-		sprintf(buf, "ttyS%d", bp->gnss2_port);
+	if (bp->gnss2_port.line != -1) {
+		sprintf(buf, "ttyS%d", bp->gnss2_port.line);
 		ptp_ocp_link_child(bp, buf, "ttyGNSS2");
 	}
-	if (bp->mac_port != -1) {
-		sprintf(buf, "ttyS%d", bp->mac_port);
+	if (bp->mac_port.line != -1) {
+		sprintf(buf, "ttyS%d", bp->mac_port.line);
 		ptp_ocp_link_child(bp, buf, "ttyMAC");
 	}
-	if (bp->nmea_port != -1) {
-		sprintf(buf, "ttyS%d", bp->nmea_port);
+	if (bp->nmea_port.line != -1) {
+		sprintf(buf, "ttyS%d", bp->nmea_port.line);
 		ptp_ocp_link_child(bp, buf, "ttyNMEA");
 	}
 	sprintf(buf, "ptp%d", ptp_clock_index(bp->ptp));
@@ -3638,16 +3658,20 @@ ptp_ocp_info(struct ptp_ocp *bp)
 
 	ptp_ocp_phc_info(bp);
 
-	ptp_ocp_serial_info(dev, "GNSS", bp->gnss_port, 115200);
-	ptp_ocp_serial_info(dev, "GNSS2", bp->gnss2_port, 115200);
-	ptp_ocp_serial_info(dev, "MAC", bp->mac_port, 57600);
-	if (bp->nmea_out && bp->nmea_port != -1) {
-		int baud = -1;
+	ptp_ocp_serial_info(dev, "GNSS", bp->gnss_port.line,
+			    bp->gnss_port.baud);
+	ptp_ocp_serial_info(dev, "GNSS2", bp->gnss2_port.line,
+			    bp->gnss2_port.baud);
+	ptp_ocp_serial_info(dev, "MAC", bp->mac_port.line, bp->mac_port.baud);
+	if (bp->nmea_out && bp->nmea_port.line != -1) {
+		bp->nmea_port.baud = -1;
 
 		reg = ioread32(&bp->nmea_out->uart_baud);
 		if (reg < ARRAY_SIZE(nmea_baud))
-			baud = nmea_baud[reg];
-		ptp_ocp_serial_info(dev, "NMEA", bp->nmea_port, baud);
+			bp->nmea_port.baud = nmea_baud[reg];
+
+		ptp_ocp_serial_info(dev, "NMEA", bp->nmea_port.line,
+				    bp->nmea_port.baud);
 	}
 }
 
@@ -3688,14 +3712,14 @@ ptp_ocp_detach(struct ptp_ocp *bp)
 	for (i = 0; i < 4; i++)
 		if (bp->signal_out[i])
 			ptp_ocp_unregister_ext(bp->signal_out[i]);
-	if (bp->gnss_port != -1)
-		serial8250_unregister_port(bp->gnss_port);
-	if (bp->gnss2_port != -1)
-		serial8250_unregister_port(bp->gnss2_port);
-	if (bp->mac_port != -1)
-		serial8250_unregister_port(bp->mac_port);
-	if (bp->nmea_port != -1)
-		serial8250_unregister_port(bp->nmea_port);
+	if (bp->gnss_port.line != -1)
+		serial8250_unregister_port(bp->gnss_port.line);
+	if (bp->gnss2_port.line != -1)
+		serial8250_unregister_port(bp->gnss2_port.line);
+	if (bp->mac_port.line != -1)
+		serial8250_unregister_port(bp->mac_port.line);
+	if (bp->nmea_port.line != -1)
+		serial8250_unregister_port(bp->nmea_port.line);
 	platform_device_unregister(bp->spi_flash);
 	platform_device_unregister(bp->i2c_ctrl);
 	if (bp->i2c_clk)
-- 
2.27.0

