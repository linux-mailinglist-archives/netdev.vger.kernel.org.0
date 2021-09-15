Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D972940BD9E
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 04:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236104AbhIOCSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 22:18:12 -0400
Received: from smtp8.emailarray.com ([65.39.216.67]:60901 "EHLO
        smtp8.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235899AbhIOCSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 22:18:06 -0400
Received: (qmail 92145 invoked by uid 89); 15 Sep 2021 02:16:47 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 15 Sep 2021 02:16:47 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 09/18] ptp: ocp: Add IRIG-B output mode control
Date:   Tue, 14 Sep 2021 19:16:27 -0700
Message-Id: <20210915021636.153754-10-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915021636.153754-1-jonathan.lemon@gmail.com>
References: <20210915021636.153754-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IRIG-B has several different output formats, the timecard defaults
to using B007.  Add a control which selects different output modes.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 1a210b77744c..2b3d4282d77a 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1676,6 +1676,46 @@ gnss_sync_show(struct device *dev, struct device_attribute *attr, char *buf)
 }
 static DEVICE_ATTR_RO(gnss_sync);
 
+static ssize_t
+irig_b_mode_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	u32 val;
+
+	val = ioread32(&bp->irig_out->ctrl);
+	val = (val >> 16) & 0x07;
+	return sysfs_emit(buf, "%d\n", val);
+}
+
+static ssize_t
+irig_b_mode_store(struct device *dev,
+		  struct device_attribute *attr,
+		  const char *buf, size_t count)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	unsigned long flags;
+	int err;
+	u32 reg;
+	u8 val;
+
+	err = kstrtou8(buf, 0, &val);
+	if (err)
+		return err;
+	if (val > 7)
+		return -EINVAL;
+
+	reg = ((val & 0x7) << 16);
+
+	spin_lock_irqsave(&bp->lock, flags);
+	iowrite32(0, &bp->irig_out->ctrl);		/* disable */
+	iowrite32(reg, &bp->irig_out->ctrl);		/* change mode */
+	iowrite32(reg | IRIG_M_CTRL_ENABLE, &bp->irig_out->ctrl);
+	spin_unlock_irqrestore(&bp->lock, flags);
+
+	return count;
+}
+static DEVICE_ATTR_RW(irig_b_mode);
+
 static ssize_t
 clock_source_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -1728,6 +1768,7 @@ static struct attribute *timecard_attrs[] = {
 	&dev_attr_sma4.attr,
 	&dev_attr_available_sma_inputs.attr,
 	&dev_attr_available_sma_outputs.attr,
+	&dev_attr_irig_b_mode.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(timecard);
-- 
2.31.1

