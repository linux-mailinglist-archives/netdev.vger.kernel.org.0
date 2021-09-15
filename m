Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4F740BD96
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 04:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbhIOCSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 22:18:03 -0400
Received: from smtp7.emailarray.com ([65.39.216.66]:33233 "EHLO
        smtp7.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbhIOCSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 22:18:01 -0400
Received: (qmail 8681 invoked by uid 89); 15 Sep 2021 02:16:38 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 15 Sep 2021 02:16:38 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 01/18] ptp: ocp: parameterize the i2c driver used
Date:   Tue, 14 Sep 2021 19:16:19 -0700
Message-Id: <20210915021636.153754-2-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915021636.153754-1-jonathan.lemon@gmail.com>
References: <20210915021636.153754-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the xilinx i2c driver parameters to the resource block instead
of hardcoding things in the registration functions.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index caf9b37c5eb1..d37eac69150a 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -131,6 +131,13 @@ struct ptp_ocp_flash_info {
 	void *data;
 };
 
+struct ptp_ocp_i2c_info {
+	const char *name;
+	unsigned long fixed_rate;
+	size_t data_size;
+	void *data;
+};
+
 struct ptp_ocp_ext_info {
 	const char *name;
 	int index;
@@ -269,6 +276,10 @@ static struct ocp_resource ocp_fb_resource[] = {
 	{
 		OCP_I2C_RESOURCE(i2c_ctrl),
 		.offset = 0x00150000, .size = 0x10000, .irq_vec = 7,
+		.extra = &(struct ptp_ocp_i2c_info) {
+			.name = "xiic-i2c",
+			.fixed_rate = 50000000,
+		},
 	},
 	{
 		OCP_SERIAL_RESOURCE(gnss_port),
@@ -944,21 +955,25 @@ ptp_ocp_register_spi(struct ptp_ocp *bp, struct ocp_resource *r)
 static struct platform_device *
 ptp_ocp_i2c_bus(struct pci_dev *pdev, struct ocp_resource *r, int id)
 {
+	struct ptp_ocp_i2c_info *info;
 	struct resource res[2];
 	unsigned long start;
 
+	info = r->extra;
 	start = pci_resource_start(pdev, 0) + r->offset;
 	ptp_ocp_set_mem_resource(&res[0], start, r->size);
 	ptp_ocp_set_irq_resource(&res[1], pci_irq_vector(pdev, r->irq_vec));
 
-	return platform_device_register_resndata(&pdev->dev, "xiic-i2c",
-						 id, res, 2, NULL, 0);
+	return platform_device_register_resndata(&pdev->dev, info->name,
+						 id, res, 2,
+						 info->data, info->data_size);
 }
 
 static int
 ptp_ocp_register_i2c(struct ptp_ocp *bp, struct ocp_resource *r)
 {
 	struct pci_dev *pdev = bp->pdev;
+	struct ptp_ocp_i2c_info *info;
 	struct platform_device *p;
 	struct clk_hw *clk;
 	char buf[32];
@@ -970,15 +985,17 @@ ptp_ocp_register_i2c(struct ptp_ocp *bp, struct ocp_resource *r)
 		return 0;
 	}
 
+	info = r->extra;
 	id = pci_dev_id(bp->pdev);
 
 	sprintf(buf, "AXI.%d", id);
-	clk = clk_hw_register_fixed_rate(&pdev->dev, buf, NULL, 0, 50000000);
+	clk = clk_hw_register_fixed_rate(&pdev->dev, buf, NULL, 0,
+					 info->fixed_rate);
 	if (IS_ERR(clk))
 		return PTR_ERR(clk);
 	bp->i2c_clk = clk;
 
-	sprintf(buf, "xiic-i2c.%d", id);
+	sprintf(buf, "%s.%d", info->name, id);
 	devm_clk_hw_register_clkdev(&pdev->dev, clk, NULL, buf);
 	p = ptp_ocp_i2c_bus(bp->pdev, r, id);
 	if (IS_ERR(p))
-- 
2.31.1

