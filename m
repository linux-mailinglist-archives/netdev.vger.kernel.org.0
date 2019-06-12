Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2747742598
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 14:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731089AbfFLM0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 08:26:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:47758 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727079AbfFLM0A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 08:26:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8A7D6AD3E;
        Wed, 12 Jun 2019 12:25:59 +0000 (UTC)
From:   Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
To:     linux-kernel@vger.kernel.org
Cc:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH v2 1/2] net: ethernet: wiznet: w5X00 add device tree support
Date:   Wed, 12 Jun 2019 14:25:25 +0200
Message-Id: <20190612122526.14332-1-nsaenzjulienne@suse.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The w5X00 chip provides an SPI to Ethernet inteface. This patch allows
platform devices to be defined through the device tree.

Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
---
 drivers/net/ethernet/wiznet/w5100-spi.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/wiznet/w5100-spi.c b/drivers/net/ethernet/wiznet/w5100-spi.c
index 918b3e50850a..2b4126d2427d 100644
--- a/drivers/net/ethernet/wiznet/w5100-spi.c
+++ b/drivers/net/ethernet/wiznet/w5100-spi.c
@@ -15,6 +15,7 @@
 #include <linux/delay.h>
 #include <linux/netdevice.h>
 #include <linux/of_net.h>
+#include <linux/of_device.h>
 #include <linux/spi/spi.h>
 
 #include "w5100.h"
@@ -409,14 +410,32 @@ static const struct w5100_ops w5500_ops = {
 	.init = w5500_spi_init,
 };
 
+static const struct of_device_id w5100_of_match[] = {
+	{ .compatible = "wiznet,w5100", .data = (const void*)W5100, },
+	{ .compatible = "wiznet,w5200", .data = (const void*)W5200, },
+	{ .compatible = "wiznet,w5500", .data = (const void*)W5500, },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, w5100_of_match);
+
 static int w5100_spi_probe(struct spi_device *spi)
 {
-	const struct spi_device_id *id = spi_get_device_id(spi);
+	const struct of_device_id *of_id;
 	const struct w5100_ops *ops;
+	kernel_ulong_t driver_data;
 	int priv_size;
 	const void *mac = of_get_mac_address(spi->dev.of_node);
 
-	switch (id->driver_data) {
+	if (spi->dev.of_node) {
+		of_id = of_match_device(w5100_of_match, &spi->dev);
+		if (!of_id)
+			return -ENODEV;
+		driver_data = (kernel_ulong_t)of_id->data;
+	} else {
+		driver_data = spi_get_device_id(spi)->driver_data;
+	}
+
+	switch (driver_data) {
 	case W5100:
 		ops = &w5100_spi_ops;
 		priv_size = 0;
@@ -453,6 +472,7 @@ static struct spi_driver w5100_spi_driver = {
 	.driver		= {
 		.name	= "w5100",
 		.pm	= &w5100_pm_ops,
+		.of_match_table = w5100_of_match,
 	},
 	.probe		= w5100_spi_probe,
 	.remove		= w5100_spi_remove,
-- 
2.21.0

