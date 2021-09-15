Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B9F40BDA0
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 04:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbhIOCSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 22:18:14 -0400
Received: from smtp5.emailarray.com ([65.39.216.39]:44170 "EHLO
        smtp5.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235548AbhIOCSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 22:18:07 -0400
Received: (qmail 83593 invoked by uid 89); 15 Sep 2021 02:16:48 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 15 Sep 2021 02:16:48 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 10/18] ptp: ocp: Add sysfs attribute utc_tai_offset
Date:   Tue, 14 Sep 2021 19:16:28 -0700
Message-Id: <20210915021636.153754-11-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915021636.153754-1-jonathan.lemon@gmail.com>
References: <20210915021636.153754-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IRIG and DCF output time in UTC, but the timecard operates
on TAI internally.  Add an attribute node which allows adding
an offset to these modes before output.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 49 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 2b3d4282d77a..2c3af3c9def7 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -230,8 +230,9 @@ struct ptp_ocp {
 	int			gnss_port;
 	int			mac_port;	/* miniature atomic clock */
 	u8			serial[6];
-	int			flash_start;
 	bool			has_serial;
+	int			flash_start;
+	u32			utc_tai_offset;
 };
 
 struct ocp_resource {
@@ -741,6 +742,23 @@ ptp_ocp_init_clock(struct ptp_ocp *bp)
 	return 0;
 }
 
+static void
+ptp_ocp_utc_distribute(struct ptp_ocp *bp, u32 val)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&bp->lock, flags);
+
+	bp->utc_tai_offset = val;
+
+	if (bp->irig_out)
+		iowrite32(val, &bp->irig_out->adj_sec);
+	if (bp->dcf_out)
+		iowrite32(val, &bp->dcf_out->adj_sec);
+
+	spin_unlock_irqrestore(&bp->lock, flags);
+}
+
 static void
 ptp_ocp_tod_info(struct ptp_ocp *bp)
 {
@@ -1676,6 +1694,34 @@ gnss_sync_show(struct device *dev, struct device_attribute *attr, char *buf)
 }
 static DEVICE_ATTR_RO(gnss_sync);
 
+static ssize_t
+utc_tai_offset_show(struct device *dev,
+		    struct device_attribute *attr, char *buf)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%d\n", bp->utc_tai_offset);
+}
+
+static ssize_t
+utc_tai_offset_store(struct device *dev,
+		     struct device_attribute *attr,
+		     const char *buf, size_t count)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	int err;
+	u32 val;
+
+	err = kstrtou32(buf, 0, &val);
+	if (err)
+		return err;
+
+	ptp_ocp_utc_distribute(bp, val);
+
+	return count;
+}
+static DEVICE_ATTR_RW(utc_tai_offset);
+
 static ssize_t
 irig_b_mode_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -1769,6 +1815,7 @@ static struct attribute *timecard_attrs[] = {
 	&dev_attr_available_sma_inputs.attr,
 	&dev_attr_available_sma_outputs.attr,
 	&dev_attr_irig_b_mode.attr,
+	&dev_attr_utc_tai_offset.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(timecard);
-- 
2.31.1

