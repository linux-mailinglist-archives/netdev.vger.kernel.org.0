Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C6540BDA7
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 04:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236173AbhIOCSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 22:18:32 -0400
Received: from smtp6.emailarray.com ([65.39.216.46]:34595 "EHLO
        smtp6.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236133AbhIOCSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 22:18:16 -0400
Received: (qmail 28592 invoked by uid 89); 15 Sep 2021 02:16:57 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp6.emailarray.com with SMTP; 15 Sep 2021 02:16:57 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 17/18] ptp: ocp: Add timestamp window adjustment
Date:   Tue, 14 Sep 2021 19:16:35 -0700
Message-Id: <20210915021636.153754-18-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915021636.153754-1-jonathan.lemon@gmail.com>
References: <20210915021636.153754-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following process is used to read the PHC clock and correlate
the reading with the "correct" system time.

- get starting timestamp
- issue PCI write command
- issue PCI read command
- get ending timestamp
- read latched sec/nsec registers

The write command is posted to PCI bus and returns.  When the write
arrives at the FPGA, the PHC time is latched into the sec/nsec registers,
and a flag is set indicating the registers are valid.  The read command
returns this flag, and the time retrieval proceeds.

Below is a non-scaled picture of the timing diagram involved.  The
PHC time corresponds to some SYS time between [start, end].  Userspace
usually uses the midpoint between [start, end] to estimate the PCI
delay and match this with the PHC time.

 [start] |                |
   write |-------+        |
	 |        \       |
    read |----+    +----->|
	 |     \          * PHC time latched into register
	 |      \         |
midpoint |       +------->|
	 |                |
	 |                |
	 |           +----|
	 |          /     |
	 |<--------+      |
   [end] |                |

As the diagram indicates, the PHC time is latched before the midpoint,
so the system clock time is slightly off the real PHC time.  This shows
up as a phase error with an oscilliscope.

The workaround here is to provide a tunable which reduces (shrinks)
the end time in the above diagram.  This in turn moves the calculated
midpoint so the system time and PHC time are in agreemment.

Currently, the adjustment reduces the end time by 3/16th of the entire
window.  E.g.:  [start, end] ==> [start, (end - (3/16 * end)], which
produces reasonably good results.

Also reduce delays by just writing to the clock control register
instead of performing a read/modify/write sequence, as the contents
of the control register are known.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 77 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 66 insertions(+), 11 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index e6779a712bbb..844b1401cc5d 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -240,6 +240,7 @@ struct ptp_ocp {
 	u32			pps_req_map;
 	int			flash_start;
 	u32			utc_tai_offset;
+	u32			ts_window_adjust;
 };
 
 #define OCP_REQ_TIMESTAMP	BIT(0)
@@ -528,10 +529,9 @@ __ptp_ocp_gettime_locked(struct ptp_ocp *bp, struct timespec64 *ts,
 	u32 ctrl, time_sec, time_ns;
 	int i;
 
-	ctrl = ioread32(&bp->reg->ctrl);
-	ctrl |= OCP_CTRL_READ_TIME_REQ;
-
 	ptp_read_system_prets(sts);
+
+	ctrl = OCP_CTRL_READ_TIME_REQ | OCP_CTRL_ENABLE;
 	iowrite32(ctrl, &bp->reg->ctrl);
 
 	for (i = 0; i < 100; i++) {
@@ -541,6 +541,12 @@ __ptp_ocp_gettime_locked(struct ptp_ocp *bp, struct timespec64 *ts,
 	}
 	ptp_read_system_postts(sts);
 
+	if (sts && bp->ts_window_adjust) {
+		s64 ns = timespec64_to_ns(&sts->post_ts);
+
+		sts->post_ts = ns_to_timespec64(ns - bp->ts_window_adjust);
+	}
+
 	time_ns = ioread32(&bp->reg->time_ns);
 	time_sec = ioread32(&bp->reg->time_sec);
 
@@ -580,8 +586,7 @@ __ptp_ocp_settime_locked(struct ptp_ocp *bp, const struct timespec64 *ts)
 	iowrite32(time_ns, &bp->reg->adjust_ns);
 	iowrite32(time_sec, &bp->reg->adjust_sec);
 
-	ctrl = ioread32(&bp->reg->ctrl);
-	ctrl |= OCP_CTRL_ADJUST_TIME;
+	ctrl = OCP_CTRL_ADJUST_TIME | OCP_CTRL_ENABLE;
 	iowrite32(ctrl, &bp->reg->ctrl);
 
 	/* restore clock selection */
@@ -726,8 +731,7 @@ __ptp_ocp_clear_drift_locked(struct ptp_ocp *bp)
 
 	iowrite32(0, &bp->reg->drift_ns);
 
-	ctrl = ioread32(&bp->reg->ctrl);
-	ctrl |= OCP_CTRL_ADJUST_DRIFT;
+	ctrl = OCP_CTRL_ADJUST_DRIFT | OCP_CTRL_ENABLE;
 	iowrite32(ctrl, &bp->reg->ctrl);
 
 	/* restore clock selection */
@@ -759,6 +763,28 @@ ptp_ocp_watchdog(struct timer_list *t)
 	mod_timer(&bp->watchdog, jiffies + HZ);
 }
 
+static void
+ptp_ocp_estimate_pci_timing(struct ptp_ocp *bp)
+{
+	ktime_t start, end;
+	ktime_t delay;
+	u32 ctrl;
+
+	ctrl = ioread32(&bp->reg->ctrl);
+	ctrl = OCP_CTRL_READ_TIME_REQ | OCP_CTRL_ENABLE;
+
+	iowrite32(ctrl, &bp->reg->ctrl);
+
+	start = ktime_get_ns();
+
+	ctrl = ioread32(&bp->reg->ctrl);
+
+	end = ktime_get_ns();
+
+	delay = end - start;
+	bp->ts_window_adjust = (delay >> 5) * 3;
+}
+
 static int
 ptp_ocp_init_clock(struct ptp_ocp *bp)
 {
@@ -766,9 +792,7 @@ ptp_ocp_init_clock(struct ptp_ocp *bp)
 	bool sync;
 	u32 ctrl;
 
-	/* make sure clock is enabled */
-	ctrl = ioread32(&bp->reg->ctrl);
-	ctrl |= OCP_CTRL_ENABLE;
+	ctrl = OCP_CTRL_ENABLE;
 	iowrite32(ctrl, &bp->reg->ctrl);
 
 	/* NO DRIFT Correction */
@@ -787,6 +811,8 @@ ptp_ocp_init_clock(struct ptp_ocp *bp)
 		return -ENODEV;
 	}
 
+	ptp_ocp_estimate_pci_timing(bp);
+
 	sync = ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
 	if (!sync) {
 		ktime_get_clocktai_ts64(&ts);
@@ -1217,7 +1243,7 @@ ptp_ocp_ts_irq(int irq, void *priv)
 
 	ev.type = PTP_CLOCK_EXTTS;
 	ev.index = ext->info->index;
-	ev.timestamp = sec * 1000000000ULL + nsec;
+	ev.timestamp = sec * NSEC_PER_SEC + nsec;
 
 	ptp_clock_event(ext->bp->ptp, &ev);
 
@@ -1817,6 +1843,34 @@ utc_tai_offset_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(utc_tai_offset);
 
+static ssize_t
+ts_window_adjust_show(struct device *dev,
+		      struct device_attribute *attr, char *buf)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%d\n", bp->ts_window_adjust);
+}
+
+static ssize_t
+ts_window_adjust_store(struct device *dev,
+		       struct device_attribute *attr,
+		       const char *buf, size_t count)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	int err;
+	u32 val;
+
+	err = kstrtou32(buf, 0, &val);
+	if (err)
+		return err;
+
+	bp->ts_window_adjust = val;
+
+	return count;
+}
+static DEVICE_ATTR_RW(ts_window_adjust);
+
 static ssize_t
 irig_b_mode_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -1911,6 +1965,7 @@ static struct attribute *timecard_attrs[] = {
 	&dev_attr_available_sma_outputs.attr,
 	&dev_attr_irig_b_mode.attr,
 	&dev_attr_utc_tai_offset.attr,
+	&dev_attr_ts_window_adjust.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(timecard);
-- 
2.31.1

