Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482C6477D15
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241227AbhLPUHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:07:49 -0500
Received: from smtp1.emailarray.com ([65.39.216.14]:15867 "EHLO
        smtp1.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233367AbhLPUHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:07:47 -0500
Received: (qmail 52861 invoked by uid 89); 16 Dec 2021 20:01:07 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 16 Dec 2021 20:01:07 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     kernel-team@fb.com
Subject: [PATCH 3/5] ptp: ocp: add tod_correction attribute
Date:   Thu, 16 Dec 2021 12:01:02 -0800
Message-Id: <20211216200104.266433-3-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211216200104.266433-1-jonathan.lemon@gmail.com>
References: <20211216200104.266433-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vadfed@fb.com>

TOD correction register is used to compensate for leap seconds in
different domains. Export it as attribute with write access.

Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 2ac5ef54fada..2383d1024f0f 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -2006,6 +2006,46 @@ clock_status_offset_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(clock_status_offset);
 
+static ssize_t
+tod_correction_show(struct device *dev,
+		    struct device_attribute *attr, char *buf)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	u32 val;
+	int res;
+
+	val = ioread32(&bp->tod->adj_sec);
+	res = (val & ~INT_MAX) ? -1 : 1;
+	res *= (val & INT_MAX);
+	return sysfs_emit(buf, "%d\n", res);
+}
+
+static ssize_t
+tod_correction_store(struct device *dev, struct device_attribute *attr,
+		     const char *buf, size_t count)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	unsigned long flags;
+	int err, res;
+	u32 val = 0;
+
+	err = kstrtos32(buf, 0, &res);
+	if (err)
+		return err;
+	if (res < 0) {
+		res *= -1;
+		val |= BIT(31);
+	}
+	val |= res;
+
+	spin_lock_irqsave(&bp->lock, flags);
+	iowrite32(val, &bp->tod->adj_sec);
+	spin_unlock_irqrestore(&bp->lock, flags);
+
+	return count;
+}
+static DEVICE_ATTR_RW(tod_correction);
+
 static struct attribute *timecard_attrs[] = {
 	&dev_attr_serialnum.attr,
 	&dev_attr_gnss_sync.attr,
@@ -2022,6 +2062,7 @@ static struct attribute *timecard_attrs[] = {
 	&dev_attr_irig_b_mode.attr,
 	&dev_attr_utc_tai_offset.attr,
 	&dev_attr_ts_window_adjust.attr,
+	&dev_attr_tod_correction.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(timecard);
-- 
2.31.1

