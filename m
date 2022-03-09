Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E46A4D3D02
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 23:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238635AbiCIWdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 17:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238678AbiCIWdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 17:33:46 -0500
Received: from smtp6.emailarray.com (smtp6.emailarray.com [65.39.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A1B2E0A9
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 14:32:42 -0800 (PST)
Received: (qmail 70890 invoked by uid 89); 9 Mar 2022 22:32:41 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp6.emailarray.com with SMTP; 9 Mar 2022 22:32:41 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com,
        kernel-team@fb.com
Subject: [PATCH net-next v1 02/10] ptp: ocp: Add ability to disable input selectors.
Date:   Wed,  9 Mar 2022 14:32:29 -0800
Message-Id: <20220309223237.34507-3-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220309223237.34507-1-jonathan.lemon@gmail.com>
References: <20220309223237.34507-1-jonathan.lemon@gmail.com>
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

This adds support for the "IN: None" selector, which disables
the input on a sma pin.  This should be compatible with old firmware
(the firmware will ignore it if not supported).

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index b776b4f02a2b..53b11c7f8fa0 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -215,6 +215,7 @@ struct ptp_ocp_sma_connector {
 	enum	ptp_ocp_sma_mode mode;
 	bool	fixed_fcn;
 	bool	fixed_dir;
+	bool	disabled;
 };
 
 #define OCP_BOARD_ID_LEN		13
@@ -521,6 +522,7 @@ static struct ocp_selector ptp_ocp_clock[] = {
 
 #define SMA_ENABLE		BIT(15)
 #define SMA_SELECT_MASK		((1U << 15) - 1)
+#define SMA_DISABLE		0x10000
 
 static struct ocp_selector ptp_ocp_sma_in[] = {
 	{ .name = "10Mhz",	.value = 0x00 },
@@ -530,6 +532,7 @@ static struct ocp_selector ptp_ocp_sma_in[] = {
 	{ .name = "TS2",	.value = 0x08 },
 	{ .name = "IRIG",	.value = 0x10 },
 	{ .name = "DCF",	.value = 0x20 },
+	{ .name = "None",	.value = SMA_DISABLE },
 	{ }
 };
 
@@ -1627,7 +1630,7 @@ __handle_signal_inputs(struct ptp_ocp *bp, u32 val)
  */
 
 static ssize_t
-ptp_ocp_show_output(u32 val, char *buf, int default_idx)
+ptp_ocp_show_output(u32 val, char *buf, int def_val)
 {
 	const char *name;
 	ssize_t count;
@@ -1635,13 +1638,13 @@ ptp_ocp_show_output(u32 val, char *buf, int default_idx)
 	count = sysfs_emit(buf, "OUT: ");
 	name = ptp_ocp_select_name_from_val(ptp_ocp_sma_out, val);
 	if (!name)
-		name = ptp_ocp_sma_out[default_idx].name;
+		name = ptp_ocp_select_name_from_val(ptp_ocp_sma_out, def_val);
 	count += sysfs_emit_at(buf, count, "%s\n", name);
 	return count;
 }
 
 static ssize_t
-ptp_ocp_show_inputs(u32 val, char *buf, int default_idx)
+ptp_ocp_show_inputs(u32 val, char *buf, int def_val)
 {
 	const char *name;
 	ssize_t count;
@@ -1654,9 +1657,10 @@ ptp_ocp_show_inputs(u32 val, char *buf, int default_idx)
 			count += sysfs_emit_at(buf, count, "%s ", name);
 		}
 	}
-	if (!val && default_idx >= 0)
-		count += sysfs_emit_at(buf, count, "%s ",
-				       ptp_ocp_sma_in[default_idx].name);
+	if (!val && def_val >= 0) {
+		name = ptp_ocp_select_name_from_val(ptp_ocp_sma_in, def_val);
+		count += sysfs_emit_at(buf, count, "%s ", name);
+	}
 	if (count)
 		count--;
 	count += sysfs_emit_at(buf, count, "\n");
@@ -1722,17 +1726,20 @@ ptp_ocp_sma_get(struct ptp_ocp *bp, int sma_nr, enum ptp_ocp_sma_mode mode)
 
 static ssize_t
 ptp_ocp_sma_show(struct ptp_ocp *bp, int sma_nr, char *buf,
-		 int default_in_idx, int default_out_idx)
+		 int default_in_val, int default_out_val)
 {
 	struct ptp_ocp_sma_connector *sma = &bp->sma[sma_nr - 1];
 	u32 val;
 
 	val = ptp_ocp_sma_get(bp, sma_nr, sma->mode) & SMA_SELECT_MASK;
 
-	if (sma->mode == SMA_MODE_IN)
-		return ptp_ocp_show_inputs(val, buf, default_in_idx);
+	if (sma->mode == SMA_MODE_IN) {
+		if (sma->disabled)
+			val = SMA_DISABLE;
+		return ptp_ocp_show_inputs(val, buf, default_in_val);
+	}
 
-	return ptp_ocp_show_output(val, buf, default_out_idx);
+	return ptp_ocp_show_output(val, buf, default_out_val);
 }
 
 static ssize_t
@@ -1827,7 +1834,7 @@ ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
 	if (val < 0)
 		return val;
 
-	if (mode != sma->mode && sma->fixed_dir)
+	if (sma->fixed_dir && (mode != sma->mode || val & SMA_DISABLE))
 		return -EOPNOTSUPP;
 
 	if (sma->fixed_fcn) {
@@ -1836,6 +1843,8 @@ ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
 		return 0;
 	}
 
+	sma->disabled = !!(val & SMA_DISABLE);
+
 	if (mode != sma->mode) {
 		if (mode == SMA_MODE_IN)
 			ptp_ocp_sma_store_output(bp, sma_nr, 0);
@@ -1847,6 +1856,9 @@ ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
 	if (!sma->fixed_dir)
 		val |= SMA_ENABLE;		/* add enable bit */
 
+	if (sma->disabled)
+		val = 0;
+
 	if (mode == SMA_MODE_IN)
 		ptp_ocp_sma_store_inputs(bp, sma_nr, val);
 	else
-- 
2.31.1

