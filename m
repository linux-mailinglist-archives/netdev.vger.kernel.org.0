Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D53A3FBF9D
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 01:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239210AbhH3Xxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 19:53:50 -0400
Received: from smtp6.emailarray.com ([65.39.216.46]:43819 "EHLO
        smtp6.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239200AbhH3Xxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 19:53:43 -0400
Received: (qmail 11218 invoked by uid 89); 30 Aug 2021 23:52:48 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp6.emailarray.com with SMTP; 30 Aug 2021 23:52:48 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, abyagowi@fb.com
Subject: [PATCH net-next 10/11] ptp: ocp: Add IRIG-B output mode control
Date:   Mon, 30 Aug 2021 16:52:35 -0700
Message-Id: <20210830235236.309993-11-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210830235236.309993-1-jonathan.lemon@gmail.com>
References: <20210830235236.309993-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IRIG-B has several different output formats, the timecard defaults
to using B007.  Add a control which selects different output modes.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 50 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 4 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index daa95f48c39f..3cc1b5e661af 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1634,6 +1634,46 @@ utc_tai_offset_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(utc_tai_offset);
 
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
@@ -1687,6 +1727,7 @@ static struct attribute *timecard_attrs[] = {
 	&dev_attr_available_sma_inputs.attr,
 	&dev_attr_available_sma_outputs.attr,
 	&dev_attr_utc_tai_offset.attr,
+	&dev_attr_irig_b_mode.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(timecard);
@@ -1718,7 +1759,7 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 {
 	struct device *dev = s->private;
 	struct ts_reg __iomem *ts_reg;
-	u32 sma_in, sma_out, val;
+	u32 sma_in, sma_out, ctrl, val;
 	struct timespec64 ts;
 	struct ptp_ocp *bp;
 	char *buf, *src;
@@ -1769,11 +1810,12 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 	}
 
 	if (bp->irig_out) {
-		on = ioread32(&bp->irig_out->ctrl) & IRIG_M_CTRL_ENABLE;
+		ctrl = ioread32(&bp->irig_out->ctrl);
+		on = ctrl & IRIG_M_CTRL_ENABLE;
 		val = ioread32(&bp->irig_out->status);
 		gpio_multi_map(buf, sma_out, 4, "sma1", "sma2", "----");
-		seq_printf(s, "%7s: %s, error: %d, out: %s\n", "IRIG",
-			   on ? " ON" : "OFF", val, buf);
+		seq_printf(s, "%7s: %s, error: %d, mode %d, out: %s\n", "IRIG",
+			   on ? " ON" : "OFF", val, (ctrl >> 16), buf);
 	}
 
 	if (bp->irig_in) {
-- 
2.31.1

