Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C28151CCF0
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 01:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386964AbiEEXxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 19:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386983AbiEEXxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 19:53:15 -0400
Received: from smtp6.emailarray.com (smtp6.emailarray.com [65.39.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCE360D9F
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 16:49:32 -0700 (PDT)
Received: (qmail 81919 invoked by uid 89); 5 May 2022 23:49:30 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp6.emailarray.com with SMTP; 5 May 2022 23:49:30 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, kernel-team@fb.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
Subject: [PATCH net-next v1 06/10] ptp: ocp: vectorize the sma accessor functions
Date:   Thu,  5 May 2022 16:49:17 -0700
Message-Id: <20220505234921.3728-7-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220505234921.3728-1-jonathan.lemon@gmail.com>
References: <20220505234921.3728-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the SMA get and set functions into an operations vector for
different boards.

Create inline wrappers for the accessor functions.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 199 ++++++++++++++++++++++++------------------
 1 file changed, 112 insertions(+), 87 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 3892e519de71..4091f74d2d16 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -331,7 +331,7 @@ struct ptp_ocp {
 	u64			fw_cap;
 	struct ptp_ocp_signal	signal[4];
 	struct ptp_ocp_sma_connector sma[4];
-	u8			sma_tbl;
+	const struct ocp_sma_op *sma_op;
 };
 
 #define OCP_REQ_TIMESTAMP	BIT(0)
@@ -362,6 +362,7 @@ static int ptp_ocp_signal_enable(void *priv, u32 req, bool enable);
 static int ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr);
 
 static const struct ocp_attr_group fb_timecard_groups[];
+static const struct ocp_sma_op ocp_fb_sma_op;
 
 struct ptp_ocp_eeprom_map {
 	u16	off;
@@ -710,10 +711,31 @@ static const struct ocp_selector ptp_ocp_sma_out[] = {
 	{ }
 };
 
-static const struct ocp_selector *ocp_sma_tbl[][2] = {
-	{ ptp_ocp_sma_in, ptp_ocp_sma_out },
+struct ocp_sma_op {
+	const struct ocp_selector *tbl[2];
+	u32 (*get)(struct ptp_ocp *bp, int sma_nr);
+	int (*set_inputs)(struct ptp_ocp *bp, int sma_nr, u32 val);
+	int (*set_output)(struct ptp_ocp *bp, int sma_nr, u32 val);
 };
 
+static inline u32
+ptp_ocp_sma_get(struct ptp_ocp *bp, int sma_nr)
+{
+	return bp->sma_op->get(bp, sma_nr);
+}
+
+static inline int
+ptp_ocp_sma_set_inputs(struct ptp_ocp *bp, int sma_nr, u32 val)
+{
+	return bp->sma_op->set_inputs(bp, sma_nr, val);
+}
+
+static inline int
+ptp_ocp_sma_set_output(struct ptp_ocp *bp, int sma_nr, u32 val)
+{
+	return bp->sma_op->set_output(bp, sma_nr, val);
+}
+
 static const char *
 ptp_ocp_select_name_from_val(const struct ocp_selector *tbl, int val)
 {
@@ -1952,6 +1974,7 @@ ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
 	bp->eeprom_map = fb_eeprom_map;
 	bp->fw_version = ioread32(&bp->image->version);
 	bp->attr_tbl = fb_timecard_groups;
+	bp->sma_op = &ocp_fb_sma_op;
 
 	ptp_ocp_fb_set_version(bp);
 
@@ -2056,13 +2079,82 @@ __handle_signal_inputs(struct ptp_ocp *bp, u32 val)
 	ptp_ocp_dcf_in(bp, val & 0x00200020);
 }
 
-/*
- * ANT0 == gps	(in)
- * ANT1 == sma1 (in)
- * ANT2 == sma2 (in)
- * ANT3 == sma3 (out)
- * ANT4 == sma4 (out)
- */
+static u32
+ptp_ocp_sma_fb_get(struct ptp_ocp *bp, int sma_nr)
+{
+	u32 __iomem *gpio;
+	u32 shift;
+
+	if (bp->sma[sma_nr - 1].fixed_fcn)
+		return (sma_nr - 1) & 1;
+
+	if (bp->sma[sma_nr - 1].mode == SMA_MODE_IN)
+		gpio = sma_nr > 2 ? &bp->sma_map2->gpio1 : &bp->sma_map1->gpio1;
+	else
+		gpio = sma_nr > 2 ? &bp->sma_map1->gpio2 : &bp->sma_map2->gpio2;
+	shift = sma_nr & 1 ? 0 : 16;
+
+	return (ioread32(gpio) >> shift) & 0xffff;
+}
+
+static int
+ptp_ocp_sma_fb_set_output(struct ptp_ocp *bp, int sma_nr, u32 val)
+{
+	u32 reg, mask, shift;
+	unsigned long flags;
+	u32 __iomem *gpio;
+
+	gpio = sma_nr > 2 ? &bp->sma_map1->gpio2 : &bp->sma_map2->gpio2;
+	shift = sma_nr & 1 ? 0 : 16;
+
+	mask = 0xffff << (16 - shift);
+
+	spin_lock_irqsave(&bp->lock, flags);
+
+	reg = ioread32(gpio);
+	reg = (reg & mask) | (val << shift);
+
+	__handle_signal_outputs(bp, reg);
+
+	iowrite32(reg, gpio);
+
+	spin_unlock_irqrestore(&bp->lock, flags);
+
+	return 0;
+}
+
+static int
+ptp_ocp_sma_fb_set_inputs(struct ptp_ocp *bp, int sma_nr, u32 val)
+{
+	u32 reg, mask, shift;
+	unsigned long flags;
+	u32 __iomem *gpio;
+
+	gpio = sma_nr > 2 ? &bp->sma_map2->gpio1 : &bp->sma_map1->gpio1;
+	shift = sma_nr & 1 ? 0 : 16;
+
+	mask = 0xffff << (16 - shift);
+
+	spin_lock_irqsave(&bp->lock, flags);
+
+	reg = ioread32(gpio);
+	reg = (reg & mask) | (val << shift);
+
+	__handle_signal_inputs(bp, reg);
+
+	iowrite32(reg, gpio);
+
+	spin_unlock_irqrestore(&bp->lock, flags);
+
+	return 0;
+}
+
+static const struct ocp_sma_op ocp_fb_sma_op = {
+	.tbl		= { ptp_ocp_sma_in, ptp_ocp_sma_out },
+	.get		= ptp_ocp_sma_fb_get,
+	.set_inputs	= ptp_ocp_sma_fb_set_inputs,
+	.set_output	= ptp_ocp_sma_fb_set_output,
+};
 
 static ssize_t
 ptp_ocp_show_output(const struct ocp_selector *tbl, u32 val, char *buf,
@@ -2143,24 +2235,6 @@ sma_parse_inputs(const struct ocp_selector * const tbl[], const char *buf,
 	return ret;
 }
 
-static u32
-ptp_ocp_sma_get(struct ptp_ocp *bp, int sma_nr, enum ptp_ocp_sma_mode mode)
-{
-	u32 __iomem *gpio;
-	u32 shift;
-
-	if (bp->sma[sma_nr - 1].fixed_fcn)
-		return (sma_nr - 1) & 1;
-
-	if (mode == SMA_MODE_IN)
-		gpio = sma_nr > 2 ? &bp->sma_map2->gpio1 : &bp->sma_map1->gpio1;
-	else
-		gpio = sma_nr > 2 ? &bp->sma_map1->gpio2 : &bp->sma_map2->gpio2;
-	shift = sma_nr & 1 ? 0 : 16;
-
-	return (ioread32(gpio) >> shift) & 0xffff;
-}
-
 static ssize_t
 ptp_ocp_sma_show(struct ptp_ocp *bp, int sma_nr, char *buf,
 		 int default_in_val, int default_out_val)
@@ -2169,9 +2243,8 @@ ptp_ocp_sma_show(struct ptp_ocp *bp, int sma_nr, char *buf,
 	const struct ocp_selector * const *tbl;
 	u32 val;
 
-	tbl = ocp_sma_tbl[bp->sma_tbl];
-
-	val = ptp_ocp_sma_get(bp, sma_nr, sma->mode) & SMA_SELECT_MASK;
+	tbl = bp->sma_op->tbl;
+	val = ptp_ocp_sma_get(bp, sma_nr) & SMA_SELECT_MASK;
 
 	if (sma->mode == SMA_MODE_IN) {
 		if (sma->disabled)
@@ -2214,54 +2287,6 @@ sma4_show(struct device *dev, struct device_attribute *attr, char *buf)
 	return ptp_ocp_sma_show(bp, 4, buf, -1, 1);
 }
 
-static void
-ptp_ocp_sma_store_output(struct ptp_ocp *bp, int sma_nr, u32 val)
-{
-	u32 reg, mask, shift;
-	unsigned long flags;
-	u32 __iomem *gpio;
-
-	gpio = sma_nr > 2 ? &bp->sma_map1->gpio2 : &bp->sma_map2->gpio2;
-	shift = sma_nr & 1 ? 0 : 16;
-
-	mask = 0xffff << (16 - shift);
-
-	spin_lock_irqsave(&bp->lock, flags);
-
-	reg = ioread32(gpio);
-	reg = (reg & mask) | (val << shift);
-
-	__handle_signal_outputs(bp, reg);
-
-	iowrite32(reg, gpio);
-
-	spin_unlock_irqrestore(&bp->lock, flags);
-}
-
-static void
-ptp_ocp_sma_store_inputs(struct ptp_ocp *bp, int sma_nr, u32 val)
-{
-	u32 reg, mask, shift;
-	unsigned long flags;
-	u32 __iomem *gpio;
-
-	gpio = sma_nr > 2 ? &bp->sma_map2->gpio1 : &bp->sma_map1->gpio1;
-	shift = sma_nr & 1 ? 0 : 16;
-
-	mask = 0xffff << (16 - shift);
-
-	spin_lock_irqsave(&bp->lock, flags);
-
-	reg = ioread32(gpio);
-	reg = (reg & mask) | (val << shift);
-
-	__handle_signal_inputs(bp, reg);
-
-	iowrite32(reg, gpio);
-
-	spin_unlock_irqrestore(&bp->lock, flags);
-}
-
 static int
 ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
 {
@@ -2270,7 +2295,7 @@ ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
 	int val;
 
 	mode = sma->mode;
-	val = sma_parse_inputs(ocp_sma_tbl[bp->sma_tbl], buf, &mode);
+	val = sma_parse_inputs(bp->sma_op->tbl, buf, &mode);
 	if (val < 0)
 		return val;
 
@@ -2287,9 +2312,9 @@ ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
 
 	if (mode != sma->mode) {
 		if (mode == SMA_MODE_IN)
-			ptp_ocp_sma_store_output(bp, sma_nr, 0);
+			ptp_ocp_sma_set_output(bp, sma_nr, 0);
 		else
-			ptp_ocp_sma_store_inputs(bp, sma_nr, 0);
+			ptp_ocp_sma_set_inputs(bp, sma_nr, 0);
 		sma->mode = mode;
 	}
 
@@ -2300,11 +2325,11 @@ ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
 		val = 0;
 
 	if (mode == SMA_MODE_IN)
-		ptp_ocp_sma_store_inputs(bp, sma_nr, val);
+		val = ptp_ocp_sma_set_inputs(bp, sma_nr, val);
 	else
-		ptp_ocp_sma_store_output(bp, sma_nr, val);
+		val = ptp_ocp_sma_set_output(bp, sma_nr, val);
 
-	return 0;
+	return val;
 }
 
 static ssize_t
@@ -2361,7 +2386,7 @@ available_sma_inputs_show(struct device *dev,
 {
 	struct ptp_ocp *bp = dev_get_drvdata(dev);
 
-	return ptp_ocp_select_table_show(ocp_sma_tbl[bp->sma_tbl][0], buf);
+	return ptp_ocp_select_table_show(bp->sma_op->tbl[0], buf);
 }
 static DEVICE_ATTR_RO(available_sma_inputs);
 
@@ -2371,7 +2396,7 @@ available_sma_outputs_show(struct device *dev,
 {
 	struct ptp_ocp *bp = dev_get_drvdata(dev);
 
-	return ptp_ocp_select_table_show(ocp_sma_tbl[bp->sma_tbl][1], buf);
+	return ptp_ocp_select_table_show(bp->sma_op->tbl[1], buf);
 }
 static DEVICE_ATTR_RO(available_sma_outputs);
 
-- 
2.31.1

