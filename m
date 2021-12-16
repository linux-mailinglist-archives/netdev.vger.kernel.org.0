Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E5B477D14
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241221AbhLPUHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:07:47 -0500
Received: from smtp5.emailarray.com ([65.39.216.39]:27082 "EHLO
        smtp5.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241099AbhLPUHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:07:47 -0500
Received: (qmail 30794 invoked by uid 89); 16 Dec 2021 20:01:06 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 16 Dec 2021 20:01:06 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     kernel-team@fb.com
Subject: [PATCH 2/5] ptp: ocp: Expose clock status drift and offset
Date:   Thu, 16 Dec 2021 12:01:01 -0800
Message-Id: <20211216200104.266433-2-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211216200104.266433-1-jonathan.lemon@gmail.com>
References: <20211216200104.266433-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vadfed@fb.com>

Monitoring of clock variance could be done through checking
the offset and the drift updates that are applied to atomic
clocks. Expose these values as attributes for timecard.

Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 17ad5f0d13b2..2ac5ef54fada 100644
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
@@ -1974,6 +1976,36 @@ available_clock_sources_show(struct device *dev,
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
@@ -1985,6 +2017,8 @@ static struct attribute *timecard_attrs[] = {
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

