Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8485A40BD95
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 04:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhIOCSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 22:18:02 -0400
Received: from smtp5.emailarray.com ([65.39.216.39]:44045 "EHLO
        smtp5.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbhIOCSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 22:18:00 -0400
Received: (qmail 83457 invoked by uid 89); 15 Sep 2021 02:16:41 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 15 Sep 2021 02:16:41 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 04/18] ptp: ocp: Skip resources with out of range irqs
Date:   Tue, 14 Sep 2021 19:16:22 -0700
Message-Id: <20210915021636.153754-5-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915021636.153754-1-jonathan.lemon@gmail.com>
References: <20210915021636.153754-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TimeCard exposes different resources, which may have their
own irqs.  Space for the irqs is allocated through a MSI or MSI-X
interrupt vector.  On some platforms, the interrupt allocation
fails.

Rather than making this fatal, just skip exposing those resources.

The main timecard functionality (that of a PTP clock) will work
without the additional resources.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 47 +++++++++++++++++--------------------------
 1 file changed, 18 insertions(+), 29 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 196a457929f0..ad8b794fa7e6 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -139,7 +139,6 @@ struct ptp_ocp_i2c_info {
 };
 
 struct ptp_ocp_ext_info {
-	const char *name;
 	int index;
 	irqreturn_t (*irq_fcn)(int irq, void *priv);
 	int (*enable)(void *priv, bool enable);
@@ -187,6 +186,7 @@ struct ocp_resource {
 	int (*setup)(struct ptp_ocp *bp, struct ocp_resource *r);
 	void *extra;
 	unsigned long bp_offset;
+	const char * const name;
 };
 
 static int ptp_ocp_register_mem(struct ptp_ocp *bp, struct ocp_resource *r);
@@ -204,7 +204,7 @@ static int ptp_ocp_ts_enable(void *priv, bool enable);
 })
 
 #define OCP_RES_LOCATION(member) \
-	.bp_offset = offsetof(struct ptp_ocp, member)
+	.name = #member, .bp_offset = offsetof(struct ptp_ocp, member)
 
 #define OCP_MEM_RESOURCE(member) \
 	OCP_RES_LOCATION(member), .setup = ptp_ocp_register_mem
@@ -243,7 +243,7 @@ static struct ocp_resource ocp_fb_resource[] = {
 		OCP_EXT_RESOURCE(ts0),
 		.offset = 0x01010000, .size = 0x10000, .irq_vec = 1,
 		.extra = &(struct ptp_ocp_ext_info) {
-			.name = "ts0", .index = 0,
+			.index = 0,
 			.irq_fcn = ptp_ocp_ts_irq,
 			.enable = ptp_ocp_ts_enable,
 		},
@@ -252,7 +252,7 @@ static struct ocp_resource ocp_fb_resource[] = {
 		OCP_EXT_RESOURCE(ts1),
 		.offset = 0x01020000, .size = 0x10000, .irq_vec = 2,
 		.extra = &(struct ptp_ocp_ext_info) {
-			.name = "ts1", .index = 1,
+			.index = 1,
 			.irq_fcn = ptp_ocp_ts_irq,
 			.enable = ptp_ocp_ts_enable,
 		},
@@ -925,18 +925,6 @@ ptp_ocp_register_spi(struct ptp_ocp *bp, struct ocp_resource *r)
 	unsigned long start;
 	int id;
 
-	/* XXX hack to work around old FPGA */
-	if (bp->n_irqs < 10) {
-		dev_err(&bp->pdev->dev, "FPGA does not have SPI devices\n");
-		return 0;
-	}
-
-	if (r->irq_vec > bp->n_irqs) {
-		dev_err(&bp->pdev->dev, "spi device irq %d out of range\n",
-			r->irq_vec);
-		return 0;
-	}
-
 	start = pci_resource_start(pdev, 0) + r->offset;
 	ptp_ocp_set_mem_resource(&res[0], start, r->size);
 	ptp_ocp_set_irq_resource(&res[1], pci_irq_vector(pdev, r->irq_vec));
@@ -983,12 +971,6 @@ ptp_ocp_register_i2c(struct ptp_ocp *bp, struct ocp_resource *r)
 	char buf[32];
 	int id;
 
-	if (r->irq_vec > bp->n_irqs) {
-		dev_err(&bp->pdev->dev, "i2c device irq %d out of range\n",
-			r->irq_vec);
-		return 0;
-	}
-
 	info = r->extra;
 	id = pci_dev_id(bp->pdev);
 
@@ -1080,7 +1062,7 @@ ptp_ocp_register_ext(struct ptp_ocp *bp, struct ocp_resource *r)
 	ext->irq_vec = r->irq_vec;
 
 	err = pci_request_irq(pdev, r->irq_vec, ext->info->irq_fcn, NULL,
-			      ext, "ocp%d.%s", bp->id, ext->info->name);
+			      ext, "ocp%d.%s", bp->id, r->name);
 	if (err) {
 		dev_err(&pdev->dev, "Could not get irq %d\n", r->irq_vec);
 		goto out;
@@ -1122,12 +1104,6 @@ ptp_ocp_register_serial(struct ptp_ocp *bp, struct ocp_resource *r)
 {
 	int port;
 
-	if (r->irq_vec > bp->n_irqs) {
-		dev_err(&bp->pdev->dev, "serial device irq %d out of range\n",
-			r->irq_vec);
-		return 0;
-	}
-
 	port = ptp_ocp_serial_line(bp, r);
 	if (port < 0)
 		return port;
@@ -1160,6 +1136,17 @@ ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
 	return ptp_ocp_init_clock(bp);
 }
 
+static bool
+ptp_ocp_allow_irq(struct ptp_ocp *bp, struct ocp_resource *r)
+{
+	bool allow = !r->irq_vec || r->irq_vec < bp->n_irqs;
+
+	if (!allow)
+		dev_err(&bp->pdev->dev, "irq %d out of range, skipping %s\n",
+			r->irq_vec, r->name);
+	return allow;
+}
+
 static int
 ptp_ocp_register_resources(struct ptp_ocp *bp, kernel_ulong_t driver_data)
 {
@@ -1168,6 +1155,8 @@ ptp_ocp_register_resources(struct ptp_ocp *bp, kernel_ulong_t driver_data)
 
 	table = (struct ocp_resource *)driver_data;
 	for (r = table; r->setup; r++) {
+		if (!ptp_ocp_allow_irq(bp, r))
+			continue;
 		err = r->setup(bp, r);
 		if (err)
 			break;
-- 
2.31.1

