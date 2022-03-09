Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6604D3D21
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 23:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238786AbiCIWke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 17:40:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238779AbiCIWkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 17:40:32 -0500
X-Greylist: delayed 400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Mar 2022 14:39:32 PST
Received: from smtp2.emailarray.com (smtp.emailarray.com [69.28.212.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D6E120F41
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 14:39:32 -0800 (PST)
Received: (qmail 33272 invoked by uid 89); 9 Mar 2022 22:32:51 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp2.emailarray.com with SMTP; 9 Mar 2022 22:32:51 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com,
        kernel-team@fb.com
Subject: [PATCH net-next v1 09/10] ptp: ocp: Add 2 more timestampers
Date:   Wed,  9 Mar 2022 14:32:36 -0800
Message-Id: <20220309223237.34507-10-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220309223237.34507-1-jonathan.lemon@gmail.com>
References: <20220309223237.34507-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The timecard now has 4 general purpose timestampers.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 61 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 56 insertions(+), 5 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index bd03a3cfd251..36c09269a12d 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -290,6 +290,8 @@ struct ptp_ocp {
 	struct ptp_ocp_ext_src	*ts0;
 	struct ptp_ocp_ext_src	*ts1;
 	struct ptp_ocp_ext_src	*ts2;
+	struct ptp_ocp_ext_src	*ts3;
+	struct ptp_ocp_ext_src	*ts4;
 	struct img_reg __iomem	*image;
 	struct ptp_clock	*ptp;
 	struct ptp_clock_info	ptp_info;
@@ -395,7 +397,7 @@ static struct ptp_ocp_eeprom_map fb_eeprom_map[] = {
 	OCP_RES_LOCATION(member), .setup = ptp_ocp_register_ext
 
 /* This is the MSI vector mapping used.
- * 0: TS3 (and PPS)
+ * 0: PPS (TS5)
  * 1: TS0
  * 2: TS1
  * 3: GNSS1
@@ -410,6 +412,8 @@ static struct ptp_ocp_eeprom_map fb_eeprom_map[] = {
  * 12: Signal Generator 2
  * 13: Signal Generator 3
  * 14: Signal Generator 4
+ * 15: TS3
+ * 16: TS4
  */
 
 static struct ocp_resource ocp_fb_resource[] = {
@@ -444,11 +448,30 @@ static struct ocp_resource ocp_fb_resource[] = {
 			.enable = ptp_ocp_ts_enable,
 		},
 	},
+	{
+		OCP_EXT_RESOURCE(ts3),
+		.offset = 0x01110000, .size = 0x10000, .irq_vec = 15,
+		.extra = &(struct ptp_ocp_ext_info) {
+			.index = 3,
+			.irq_fcn = ptp_ocp_ts_irq,
+			.enable = ptp_ocp_ts_enable,
+		},
+	},
+	{
+		OCP_EXT_RESOURCE(ts4),
+		.offset = 0x01120000, .size = 0x10000, .irq_vec = 16,
+		.extra = &(struct ptp_ocp_ext_info) {
+			.index = 4,
+			.irq_fcn = ptp_ocp_ts_irq,
+			.enable = ptp_ocp_ts_enable,
+		},
+	},
+	/* Timestamp for PHC and/or PPS generator */
 	{
 		OCP_EXT_RESOURCE(pps),
 		.offset = 0x010C0000, .size = 0x10000, .irq_vec = 0,
 		.extra = &(struct ptp_ocp_ext_info) {
-			.index = 3,
+			.index = 5,
 			.irq_fcn = ptp_ocp_ts_irq,
 			.enable = ptp_ocp_ts_enable,
 		},
@@ -647,6 +670,8 @@ static struct ocp_selector ptp_ocp_sma_in[] = {
 	{ .name = "TS2",	.value = 0x0008 },
 	{ .name = "IRIG",	.value = 0x0010 },
 	{ .name = "DCF",	.value = 0x0020 },
+	{ .name = "TS3",	.value = 0x0040 },
+	{ .name = "TS4",	.value = 0x0080 },
 	{ .name = "FREQ1",	.value = 0x0100 },
 	{ .name = "FREQ2",	.value = 0x0200 },
 	{ .name = "FREQ3",	.value = 0x0400 },
@@ -890,6 +915,12 @@ ptp_ocp_enable(struct ptp_clock_info *ptp_info, struct ptp_clock_request *rq,
 			ext = bp->ts2;
 			break;
 		case 3:
+			ext = bp->ts3;
+			break;
+		case 4:
+			ext = bp->ts4;
+			break;
+		case 5:
 			ext = bp->pps;
 			break;
 		}
@@ -961,7 +992,7 @@ static const struct ptp_clock_info ptp_ocp_clock_info = {
 	.enable		= ptp_ocp_enable,
 	.verify		= ptp_ocp_verify,
 	.pps		= true,
-	.n_ext_ts	= 4,
+	.n_ext_ts	= 6,
 	.n_per_out	= 5,
 };
 
@@ -3023,12 +3054,28 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 			   on ? " ON" : "OFF", buf);
 	}
 
+	if (bp->ts3) {
+		ts_reg = bp->ts3->mem;
+		on = ioread32(&ts_reg->enable);
+		gpio_input_map(buf, bp, sma_val, 6, NULL);
+		seq_printf(s, "%7s: %s, src: %s\n", "TS3",
+			   on ? " ON" : "OFF", buf);
+	}
+
+	if (bp->ts4) {
+		ts_reg = bp->ts4->mem;
+		on = ioread32(&ts_reg->enable);
+		gpio_input_map(buf, bp, sma_val, 7, NULL);
+		seq_printf(s, "%7s: %s, src: %s\n", "TS4",
+			   on ? " ON" : "OFF", buf);
+	}
+
 	if (bp->pps) {
 		ts_reg = bp->pps->mem;
 		src = "PHC";
 		on = ioread32(&ts_reg->enable);
 		map = !!(bp->pps_req_map & OCP_REQ_TIMESTAMP);
-		seq_printf(s, "%7s: %s, src: %s\n", "TS3",
+		seq_printf(s, "%7s: %s, src: %s\n", "TS5",
 			   on && map ? " ON" : "OFF", src);
 
 		map = !!(bp->pps_req_map & OCP_REQ_PPS);
@@ -3455,6 +3502,10 @@ ptp_ocp_detach(struct ptp_ocp *bp)
 		ptp_ocp_unregister_ext(bp->ts1);
 	if (bp->ts2)
 		ptp_ocp_unregister_ext(bp->ts2);
+	if (bp->ts3)
+		ptp_ocp_unregister_ext(bp->ts3);
+	if (bp->ts4)
+		ptp_ocp_unregister_ext(bp->ts4);
 	if (bp->pps)
 		ptp_ocp_unregister_ext(bp->pps);
 	for (i = 0; i < 4; i++)
@@ -3511,7 +3562,7 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	 * allow this - if not all of the IRQ's are returned, skip the
 	 * extra devices and just register the clock.
 	 */
-	err = pci_alloc_irq_vectors(pdev, 1, 15, PCI_IRQ_MSI | PCI_IRQ_MSIX);
+	err = pci_alloc_irq_vectors(pdev, 1, 17, PCI_IRQ_MSI | PCI_IRQ_MSIX);
 	if (err < 0) {
 		dev_err(&pdev->dev, "alloc_irq_vectors err: %d\n", err);
 		goto out;
-- 
2.31.1

