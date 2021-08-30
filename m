Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6B43FBF9B
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 01:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239192AbhH3Xxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 19:53:49 -0400
Received: from smtp1.emailarray.com ([65.39.216.14]:34592 "EHLO
        smtp1.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239182AbhH3Xxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 19:53:41 -0400
Received: (qmail 25422 invoked by uid 89); 30 Aug 2021 23:52:46 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 30 Aug 2021 23:52:46 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, abyagowi@fb.com
Subject: [PATCH net-next 08/11] ptp: ocp: Add sysfs attribute utc_tai_offset
Date:   Mon, 30 Aug 2021 16:52:33 -0700
Message-Id: <20210830235236.309993-9-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210830235236.309993-1-jonathan.lemon@gmail.com>
References: <20210830235236.309993-1-jonathan.lemon@gmail.com>
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
 drivers/ptp/ptp_ocp.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index fceeee380d9f..093385c6fed0 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -230,8 +230,9 @@ struct ptp_ocp {
 	int			gnss_port;
 	int			mac_port;	/* miniature atomic clock */
 	u8			serial[6];
-	int			flash_start;
 	bool			has_serial;
+	int			flash_start;
+	s32			utc_tai_offset;
 };
 
 struct ocp_resource {
@@ -1592,6 +1593,40 @@ available_sma_outputs_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(available_sma_outputs);
 
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
+	unsigned long flags;
+	int err;
+	s32 val;
+
+	err = kstrtos32(buf, 0, &val);
+	if (err)
+		return err;
+
+	bp->utc_tai_offset = val;
+
+	spin_lock_irqsave(&bp->lock, flags);
+	iowrite32(val, &bp->irig_out->adj_sec);
+	iowrite32(val, &bp->dcf_out->adj_sec);
+	spin_unlock_irqrestore(&bp->lock, flags);
+
+	return count;
+}
+static DEVICE_ATTR_RW(utc_tai_offset);
+
 static ssize_t
 clock_source_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -1644,6 +1679,7 @@ static struct attribute *timecard_attrs[] = {
 	&dev_attr_sma4_in.attr,
 	&dev_attr_available_sma_inputs.attr,
 	&dev_attr_available_sma_outputs.attr,
+	&dev_attr_utc_tai_offset.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(timecard);
-- 
2.31.1

