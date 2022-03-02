Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0FAB4CB15E
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 22:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245310AbiCBVfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 16:35:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236190AbiCBVft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 16:35:49 -0500
Received: from smtp6.emailarray.com (smtp6.emailarray.com [65.39.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E6D243ECE
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 13:35:03 -0800 (PST)
Received: (qmail 77655 invoked by uid 89); 2 Mar 2022 21:35:02 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp6.emailarray.com with SMTP; 2 Mar 2022 21:35:02 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        kernel-team@fb.com
Subject: [PATCH net-next 2/5] ptp: ocp: Expose clock status drift and offset
Date:   Wed,  2 Mar 2022 13:34:56 -0800
Message-Id: <20220302213459.6565-3-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220302213459.6565-1-jonathan.lemon@gmail.com>
References: <20220302213459.6565-1-jonathan.lemon@gmail.com>
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

From: Vadim Fedorenko <vadfed@fb.com>

Monitoring of clock variance could be done through checking
the offset and the drift updates that are applied to atomic
clocks.  Expose these values as attributes for the timecard.

Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 600b5f539d7d..803b67a3659a 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -52,6 +52,8 @@ struct ocp_reg {
 	u32	servo_offset_i;
 	u32	servo_drift_p;
 	u32	servo_drift_i;
+	u32	status_offset;
+	u32	status_drift;
 };
 
 #define OCP_CTRL_ENABLE		BIT(0)
@@ -1956,6 +1958,36 @@ available_clock_sources_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(available_clock_sources);
 
+static ssize_t
+clock_status_drift_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	u32 val;
+	int res;
+
+	val = ioread32(&bp->reg->status_drift);
+	res = (val & ~INT_MAX) ? -1 : 1;
+	res *= (val & INT_MAX);
+	return sysfs_emit(buf, "%d\n", res);
+}
+static DEVICE_ATTR_RO(clock_status_drift);
+
+static ssize_t
+clock_status_offset_show(struct device *dev,
+			 struct device_attribute *attr, char *buf)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	u32 val;
+	int res;
+
+	val = ioread32(&bp->reg->status_offset);
+	res = (val & ~INT_MAX) ? -1 : 1;
+	res *= (val & INT_MAX);
+	return sysfs_emit(buf, "%d\n", res);
+}
+static DEVICE_ATTR_RO(clock_status_offset);
+
 static struct attribute *timecard_attrs[] = {
 	&dev_attr_serialnum.attr,
 	&dev_attr_gnss_sync.attr,
@@ -1967,6 +1999,8 @@ static struct attribute *timecard_attrs[] = {
 	&dev_attr_sma4.attr,
 	&dev_attr_available_sma_inputs.attr,
 	&dev_attr_available_sma_outputs.attr,
+	&dev_attr_clock_status_drift.attr,
+	&dev_attr_clock_status_offset.attr,
 	&dev_attr_irig_b_mode.attr,
 	&dev_attr_utc_tai_offset.attr,
 	&dev_attr_ts_window_adjust.attr,
-- 
2.31.1

