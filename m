Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB1551CCF5
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 01:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386944AbiEEXxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 19:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386984AbiEEXxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 19:53:15 -0400
Received: from smtp5.emailarray.com (smtp5.emailarray.com [65.39.216.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83A460DA3
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 16:49:33 -0700 (PDT)
Received: (qmail 59228 invoked by uid 89); 5 May 2022 23:49:32 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 5 May 2022 23:49:32 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, kernel-team@fb.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
Subject: [PATCH net-next v1 07/10] ptp: ocp: add .init function for sma_op vector
Date:   Thu,  5 May 2022 16:49:18 -0700
Message-Id: <20220505234921.3728-8-jonathan.lemon@gmail.com>
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

Create an .init function for the op vector, and a corresponding
wrapper function, for different sma mapping setups.

Add a default_fcn to the sma information, and use it when displaying
information for pins which have fixed functions.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 93 ++++++++++++++++++++++++-------------------
 1 file changed, 52 insertions(+), 41 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 4091f74d2d16..4e22c445dad4 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -253,6 +253,7 @@ struct ptp_ocp_sma_connector {
 	bool	fixed_fcn;
 	bool	fixed_dir;
 	bool	disabled;
+	u8	default_fcn;
 };
 
 struct ocp_attr_group {
@@ -713,11 +714,18 @@ static const struct ocp_selector ptp_ocp_sma_out[] = {
 
 struct ocp_sma_op {
 	const struct ocp_selector *tbl[2];
+	void (*init)(struct ptp_ocp *bp);
 	u32 (*get)(struct ptp_ocp *bp, int sma_nr);
 	int (*set_inputs)(struct ptp_ocp *bp, int sma_nr, u32 val);
 	int (*set_output)(struct ptp_ocp *bp, int sma_nr, u32 val);
 };
 
+static inline void
+ptp_ocp_sma_init(struct ptp_ocp *bp)
+{
+	return bp->sma_op->init(bp);
+}
+
 static inline u32
 ptp_ocp_sma_get(struct ptp_ocp *bp, int sma_nr)
 {
@@ -1872,45 +1880,6 @@ ptp_ocp_signal_init(struct ptp_ocp *bp)
 					     bp->signal_out[i]->mem);
 }
 
-static void
-ptp_ocp_sma_init(struct ptp_ocp *bp)
-{
-	u32 reg;
-	int i;
-
-	/* defaults */
-	bp->sma[0].mode = SMA_MODE_IN;
-	bp->sma[1].mode = SMA_MODE_IN;
-	bp->sma[2].mode = SMA_MODE_OUT;
-	bp->sma[3].mode = SMA_MODE_OUT;
-
-	/* If no SMA1 map, the pin functions and directions are fixed. */
-	if (!bp->sma_map1) {
-		for (i = 0; i < 4; i++) {
-			bp->sma[i].fixed_fcn = true;
-			bp->sma[i].fixed_dir = true;
-		}
-		return;
-	}
-
-	/* If SMA2 GPIO output map is all 1, it is not present.
-	 * This indicates the firmware has fixed direction SMA pins.
-	 */
-	reg = ioread32(&bp->sma_map2->gpio2);
-	if (reg == 0xffffffff) {
-		for (i = 0; i < 4; i++)
-			bp->sma[i].fixed_dir = true;
-	} else {
-		reg = ioread32(&bp->sma_map1->gpio1);
-		bp->sma[0].mode = reg & BIT(15) ? SMA_MODE_IN : SMA_MODE_OUT;
-		bp->sma[1].mode = reg & BIT(31) ? SMA_MODE_IN : SMA_MODE_OUT;
-
-		reg = ioread32(&bp->sma_map1->gpio2);
-		bp->sma[2].mode = reg & BIT(15) ? SMA_MODE_OUT : SMA_MODE_IN;
-		bp->sma[3].mode = reg & BIT(31) ? SMA_MODE_OUT : SMA_MODE_IN;
-	}
-}
-
 static int
 ptp_ocp_fb_set_pins(struct ptp_ocp *bp)
 {
@@ -2079,6 +2048,47 @@ __handle_signal_inputs(struct ptp_ocp *bp, u32 val)
 	ptp_ocp_dcf_in(bp, val & 0x00200020);
 }
 
+static void
+ptp_ocp_sma_fb_init(struct ptp_ocp *bp)
+{
+	u32 reg;
+	int i;
+
+	/* defaults */
+	bp->sma[0].mode = SMA_MODE_IN;
+	bp->sma[1].mode = SMA_MODE_IN;
+	bp->sma[2].mode = SMA_MODE_OUT;
+	bp->sma[3].mode = SMA_MODE_OUT;
+	for (i = 0; i < 4; i++)
+		bp->sma[i].default_fcn = i & 1;
+
+	/* If no SMA1 map, the pin functions and directions are fixed. */
+	if (!bp->sma_map1) {
+		for (i = 0; i < 4; i++) {
+			bp->sma[i].fixed_fcn = true;
+			bp->sma[i].fixed_dir = true;
+		}
+		return;
+	}
+
+	/* If SMA2 GPIO output map is all 1, it is not present.
+	 * This indicates the firmware has fixed direction SMA pins.
+	 */
+	reg = ioread32(&bp->sma_map2->gpio2);
+	if (reg == 0xffffffff) {
+		for (i = 0; i < 4; i++)
+			bp->sma[i].fixed_dir = true;
+	} else {
+		reg = ioread32(&bp->sma_map1->gpio1);
+		bp->sma[0].mode = reg & BIT(15) ? SMA_MODE_IN : SMA_MODE_OUT;
+		bp->sma[1].mode = reg & BIT(31) ? SMA_MODE_IN : SMA_MODE_OUT;
+
+		reg = ioread32(&bp->sma_map1->gpio2);
+		bp->sma[2].mode = reg & BIT(15) ? SMA_MODE_OUT : SMA_MODE_IN;
+		bp->sma[3].mode = reg & BIT(31) ? SMA_MODE_OUT : SMA_MODE_IN;
+	}
+}
+
 static u32
 ptp_ocp_sma_fb_get(struct ptp_ocp *bp, int sma_nr)
 {
@@ -2086,7 +2096,7 @@ ptp_ocp_sma_fb_get(struct ptp_ocp *bp, int sma_nr)
 	u32 shift;
 
 	if (bp->sma[sma_nr - 1].fixed_fcn)
-		return (sma_nr - 1) & 1;
+		return bp->sma[sma_nr - 1].default_fcn;
 
 	if (bp->sma[sma_nr - 1].mode == SMA_MODE_IN)
 		gpio = sma_nr > 2 ? &bp->sma_map2->gpio1 : &bp->sma_map1->gpio1;
@@ -2151,6 +2161,7 @@ ptp_ocp_sma_fb_set_inputs(struct ptp_ocp *bp, int sma_nr, u32 val)
 
 static const struct ocp_sma_op ocp_fb_sma_op = {
 	.tbl		= { ptp_ocp_sma_in, ptp_ocp_sma_out },
+	.init		= ptp_ocp_sma_fb_init,
 	.get		= ptp_ocp_sma_fb_get,
 	.set_inputs	= ptp_ocp_sma_fb_set_inputs,
 	.set_output	= ptp_ocp_sma_fb_set_output,
@@ -2303,7 +2314,7 @@ ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
 		return -EOPNOTSUPP;
 
 	if (sma->fixed_fcn) {
-		if (val != ((sma_nr - 1) & 1))
+		if (val != sma->default_fcn)
 			return -EOPNOTSUPP;
 		return 0;
 	}
-- 
2.31.1

