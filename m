Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F7952DF21
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 23:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245127AbiESVWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 17:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245132AbiESVWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 17:22:05 -0400
Received: from smtp3.emailarray.com (smtp3.emailarray.com [65.39.216.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40409ED8E0
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 14:22:02 -0700 (PDT)
Received: (qmail 76882 invoked by uid 89); 19 May 2022 21:22:01 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 19 May 2022 21:22:01 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, kernel-team@fb.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next v4 05/10] ptp: ocp: parameterize input/output sma selectors
Date:   Thu, 19 May 2022 14:21:48 -0700
Message-Id: <20220519212153.450437-6-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220519212153.450437-1-jonathan.lemon@gmail.com>
References: <20220519212153.450437-1-jonathan.lemon@gmail.com>
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

Group the sma input/output tables together and select the correct
group from the bp information.  This allows adding new groups with
different sma mappings.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index f44269e3d3c8..26f7830388b0 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -321,6 +321,7 @@ struct ptp_ocp {
 	u64			fw_cap;
 	struct ptp_ocp_signal	signal[4];
 	struct ptp_ocp_sma_connector sma[4];
+	u8			sma_tbl;
 };
 
 #define OCP_REQ_TIMESTAMP	BIT(0)
@@ -699,6 +700,10 @@ static struct ocp_selector ptp_ocp_sma_out[] = {
 	{ }
 };
 
+static struct ocp_selector *ocp_sma_tbl[][2] = {
+	{ ptp_ocp_sma_in, ptp_ocp_sma_out },
+};
+
 static const char *
 ptp_ocp_select_name_from_val(struct ocp_selector *tbl, int val)
 {
@@ -2088,35 +2093,35 @@ __handle_signal_inputs(struct ptp_ocp *bp, u32 val)
  */
 
 static ssize_t
-ptp_ocp_show_output(u32 val, char *buf, int def_val)
+ptp_ocp_show_output(struct ocp_selector *tbl, u32 val, char *buf, int def_val)
 {
 	const char *name;
 	ssize_t count;
 
 	count = sysfs_emit(buf, "OUT: ");
-	name = ptp_ocp_select_name_from_val(ptp_ocp_sma_out, val);
+	name = ptp_ocp_select_name_from_val(tbl, val);
 	if (!name)
-		name = ptp_ocp_select_name_from_val(ptp_ocp_sma_out, def_val);
+		name = ptp_ocp_select_name_from_val(tbl, def_val);
 	count += sysfs_emit_at(buf, count, "%s\n", name);
 	return count;
 }
 
 static ssize_t
-ptp_ocp_show_inputs(u32 val, char *buf, int def_val)
+ptp_ocp_show_inputs(struct ocp_selector *tbl, u32 val, char *buf, int def_val)
 {
 	const char *name;
 	ssize_t count;
 	int i;
 
 	count = sysfs_emit(buf, "IN: ");
-	for (i = 0; i < ARRAY_SIZE(ptp_ocp_sma_in); i++) {
-		if (val & ptp_ocp_sma_in[i].value) {
-			name = ptp_ocp_sma_in[i].name;
+	for (i = 0; tbl[i].name; i++) {
+		if (val & tbl[i].value) {
+			name = tbl[i].name;
 			count += sysfs_emit_at(buf, count, "%s ", name);
 		}
 	}
 	if (!val && def_val >= 0) {
-		name = ptp_ocp_select_name_from_val(ptp_ocp_sma_in, def_val);
+		name = ptp_ocp_select_name_from_val(tbl, def_val);
 		count += sysfs_emit_at(buf, count, "%s ", name);
 	}
 	if (count)
@@ -2126,9 +2131,9 @@ ptp_ocp_show_inputs(u32 val, char *buf, int def_val)
 }
 
 static int
-sma_parse_inputs(const char *buf, enum ptp_ocp_sma_mode *mode)
+sma_parse_inputs(struct ocp_selector *tbl[], const char *buf,
+		 enum ptp_ocp_sma_mode *mode)
 {
-	struct ocp_selector *tbl[] = { ptp_ocp_sma_in, ptp_ocp_sma_out };
 	int idx, count, dir;
 	char **argv;
 	int ret;
@@ -2187,17 +2192,20 @@ ptp_ocp_sma_show(struct ptp_ocp *bp, int sma_nr, char *buf,
 		 int default_in_val, int default_out_val)
 {
 	struct ptp_ocp_sma_connector *sma = &bp->sma[sma_nr - 1];
+	struct ocp_selector **tbl;
 	u32 val;
 
+	tbl = ocp_sma_tbl[bp->sma_tbl];
+
 	val = ptp_ocp_sma_get(bp, sma_nr, sma->mode) & SMA_SELECT_MASK;
 
 	if (sma->mode == SMA_MODE_IN) {
 		if (sma->disabled)
 			val = SMA_DISABLE;
-		return ptp_ocp_show_inputs(val, buf, default_in_val);
+		return ptp_ocp_show_inputs(tbl[0], val, buf, default_in_val);
 	}
 
-	return ptp_ocp_show_output(val, buf, default_out_val);
+	return ptp_ocp_show_output(tbl[1], val, buf, default_out_val);
 }
 
 static ssize_t
@@ -2288,7 +2296,7 @@ ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr)
 	int val;
 
 	mode = sma->mode;
-	val = sma_parse_inputs(buf, &mode);
+	val = sma_parse_inputs(ocp_sma_tbl[bp->sma_tbl], buf, &mode);
 	if (val < 0)
 		return val;
 
@@ -2377,7 +2385,9 @@ static ssize_t
 available_sma_inputs_show(struct device *dev,
 			  struct device_attribute *attr, char *buf)
 {
-	return ptp_ocp_select_table_show(ptp_ocp_sma_in, buf);
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+
+	return ptp_ocp_select_table_show(ocp_sma_tbl[bp->sma_tbl][0], buf);
 }
 static DEVICE_ATTR_RO(available_sma_inputs);
 
@@ -2385,7 +2395,9 @@ static ssize_t
 available_sma_outputs_show(struct device *dev,
 			   struct device_attribute *attr, char *buf)
 {
-	return ptp_ocp_select_table_show(ptp_ocp_sma_out, buf);
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+
+	return ptp_ocp_select_table_show(ocp_sma_tbl[bp->sma_tbl][1], buf);
 }
 static DEVICE_ATTR_RO(available_sma_outputs);
 
-- 
2.31.1

