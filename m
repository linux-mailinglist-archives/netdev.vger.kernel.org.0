Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0DAA52DF26
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 23:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245159AbiESVWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 17:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245133AbiESVWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 17:22:08 -0400
Received: from smtp4.emailarray.com (smtp4.emailarray.com [65.39.216.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71690ED795
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 14:22:06 -0700 (PDT)
Received: (qmail 9058 invoked by uid 89); 19 May 2022 21:22:05 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp4.emailarray.com with SMTP; 19 May 2022 21:22:05 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, kernel-team@fb.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next v4 08/10] ptp: ocp: add .init function for sma_op vector
Date:   Thu, 19 May 2022 14:21:51 -0700
Message-Id: <20220519212153.450437-9-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220519212153.450437-1-jonathan.lemon@gmail.com>
References: <20220519212153.450437-1-jonathan.lemon@gmail.com>
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

Create an .init function for the op vector, and a corresponding
wrapper function, for different sma mapping setups.

Add a default_fcn to the sma information, and use it when displaying
information for pins which have fixed functions.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 82fefd588add..3856e9c24333 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -243,6 +243,7 @@ struct ptp_ocp_sma_connector {
 	bool	fixed_fcn;
 	bool	fixed_dir;
 	bool	disabled;
+	u8	default_fcn;
 };
 
 struct ocp_attr_group {
@@ -702,11 +703,18 @@ static const struct ocp_selector ptp_ocp_sma_out[] = {
 
 struct ocp_sma_op {
 	const struct ocp_selector *tbl[2];
+	void (*init)(struct ptp_ocp *bp);
 	u32 (*get)(struct ptp_ocp *bp, int sma_nr);
 	int (*set_inputs)(struct ptp_ocp *bp, int sma_nr, u32 val);
 	int (*set_output)(struct ptp_ocp *bp, int sma_nr, u32 val);
 };
 
+static void
+ptp_ocp_sma_init(struct ptp_ocp *bp)
+{
+	return bp->sma_op->init(bp);
+}
+
 static u32
 ptp_ocp_sma_get(struct ptp_ocp *bp, int sma_nr)
 {
@@ -2023,15 +2031,8 @@ ptp_ocp_sma_fb_set_inputs(struct ptp_ocp *bp, int sma_nr, u32 val)
 	return 0;
 }
 
-static const struct ocp_sma_op ocp_fb_sma_op = {
-	.tbl		= { ptp_ocp_sma_in, ptp_ocp_sma_out },
-	.get		= ptp_ocp_sma_fb_get,
-	.set_inputs	= ptp_ocp_sma_fb_set_inputs,
-	.set_output	= ptp_ocp_sma_fb_set_output,
-};
-
 static void
-ptp_ocp_sma_init(struct ptp_ocp *bp)
+ptp_ocp_sma_fb_init(struct ptp_ocp *bp)
 {
 	u32 reg;
 	int i;
@@ -2041,6 +2042,8 @@ ptp_ocp_sma_init(struct ptp_ocp *bp)
 	bp->sma[1].mode = SMA_MODE_IN;
 	bp->sma[2].mode = SMA_MODE_OUT;
 	bp->sma[3].mode = SMA_MODE_OUT;
+	for (i = 0; i < 4; i++)
+		bp->sma[i].default_fcn = i & 1;
 
 	/* If no SMA1 map, the pin functions and directions are fixed. */
 	if (!bp->sma_map1) {
@@ -2069,6 +2072,14 @@ ptp_ocp_sma_init(struct ptp_ocp *bp)
 	}
 }
 
+static const struct ocp_sma_op ocp_fb_sma_op = {
+	.tbl		= { ptp_ocp_sma_in, ptp_ocp_sma_out },
+	.init		= ptp_ocp_sma_fb_init,
+	.get		= ptp_ocp_sma_fb_get,
+	.set_inputs	= ptp_ocp_sma_fb_set_inputs,
+	.set_output	= ptp_ocp_sma_fb_set_output,
+};
+
 static int
 ptp_ocp_fb_set_pins(struct ptp_ocp *bp)
 {
@@ -2330,7 +2341,7 @@ ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
 		return -EOPNOTSUPP;
 
 	if (sma->fixed_fcn) {
-		if (val != ((sma_nr - 1) & 1))
+		if (val != sma->default_fcn)
 			return -EOPNOTSUPP;
 		return 0;
 	}
-- 
2.31.1

