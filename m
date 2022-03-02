Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A577B4CB15D
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 22:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245094AbiCBVfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 16:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235908AbiCBVfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 16:35:46 -0500
Received: from smtp4.emailarray.com (smtp4.emailarray.com [65.39.216.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CEA24AE17
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 13:35:02 -0800 (PST)
Received: (qmail 50756 invoked by uid 89); 2 Mar 2022 21:35:01 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp4.emailarray.com with SMTP; 2 Mar 2022 21:35:01 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        kernel-team@fb.com
Subject: [PATCH net-next 1/5] ptp: ocp: add TOD debug information
Date:   Wed,  2 Mar 2022 13:34:55 -0800
Message-Id: <20220302213459.6565-2-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220302213459.6565-1-jonathan.lemon@gmail.com>
References: <20220302213459.6565-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vadfed@fb.com>

TOD information is currently displayed only on module load,
which doesn't provide updated information as the system runs.

Create a debug file which provides the current TOD status information,
and move the information display there.

Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 106 ++++++++++++++++++++++++++++--------------
 1 file changed, 70 insertions(+), 36 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 17ad5f0d13b2..600b5f539d7d 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -88,9 +88,10 @@ struct tod_reg {
 #define TOD_CTRL_GNSS_MASK	((1U << 4) - 1)
 #define TOD_CTRL_GNSS_SHIFT	24
 
-#define TOD_STATUS_UTC_MASK	0xff
-#define TOD_STATUS_UTC_VALID	BIT(8)
-#define TOD_STATUS_LEAP_VALID	BIT(16)
+#define TOD_STATUS_UTC_MASK		0xff
+#define TOD_STATUS_UTC_VALID		BIT(8)
+#define TOD_STATUS_LEAP_ANNOUNCE	BIT(12)
+#define TOD_STATUS_LEAP_VALID		BIT(16)
 
 struct ts_reg {
 	u32	enable;
@@ -883,45 +884,26 @@ ptp_ocp_tod_init(struct ptp_ocp *bp)
 		ptp_ocp_utc_distribute(bp, reg & TOD_STATUS_UTC_MASK);
 }
 
-static void
-ptp_ocp_tod_info(struct ptp_ocp *bp)
+static const char *
+ptp_ocp_tod_proto_name(const int idx)
 {
 	static const char * const proto_name[] = {
 		"NMEA", "NMEA_ZDA", "NMEA_RMC", "NMEA_none",
 		"UBX", "UBX_UTC", "UBX_LS", "UBX_none"
 	};
+	return proto_name[idx];
+}
+
+static const char *
+ptp_ocp_tod_gnss_name(int idx)
+{
 	static const char * const gnss_name[] = {
 		"ALL", "COMBINED", "GPS", "GLONASS", "GALILEO", "BEIDOU",
+		"Unknown"
 	};
-	u32 version, ctrl, reg;
-	int idx;
-
-	version = ioread32(&bp->tod->version);
-	dev_info(&bp->pdev->dev, "TOD Version %d.%d.%d\n",
-		 version >> 24, (version >> 16) & 0xff, version & 0xffff);
-
-	ctrl = ioread32(&bp->tod->ctrl);
-	idx = ctrl & TOD_CTRL_PROTOCOL ? 4 : 0;
-	idx += (ctrl >> 16) & 3;
-	dev_info(&bp->pdev->dev, "control: %x\n", ctrl);
-	dev_info(&bp->pdev->dev, "TOD Protocol %s %s\n", proto_name[idx],
-		 ctrl & TOD_CTRL_ENABLE ? "enabled" : "");
-
-	idx = (ctrl >> TOD_CTRL_GNSS_SHIFT) & TOD_CTRL_GNSS_MASK;
-	if (idx < ARRAY_SIZE(gnss_name))
-		dev_info(&bp->pdev->dev, "GNSS %s\n", gnss_name[idx]);
-
-	reg = ioread32(&bp->tod->status);
-	dev_info(&bp->pdev->dev, "status: %x\n", reg);
-
-	reg = ioread32(&bp->tod->adj_sec);
-	dev_info(&bp->pdev->dev, "correction: %d\n", reg);
-
-	reg = ioread32(&bp->tod->utc_status);
-	dev_info(&bp->pdev->dev, "utc_status: %x\n", reg);
-	dev_info(&bp->pdev->dev, "utc_offset: %d  valid:%d  leap_valid:%d\n",
-		 reg & TOD_STATUS_UTC_MASK, reg & TOD_STATUS_UTC_VALID ? 1 : 0,
-		 reg & TOD_STATUS_LEAP_VALID ? 1 : 0);
+	if (idx > ARRAY_SIZE(gnss_name))
+		idx = ARRAY_SIZE(gnss_name) - 1;
+	return gnss_name[idx];
 }
 
 static int
@@ -2200,6 +2182,57 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 }
 DEFINE_SHOW_ATTRIBUTE(ptp_ocp_summary);
 
+static int
+ptp_ocp_tod_status_show(struct seq_file *s, void *data)
+{
+	struct device *dev = s->private;
+	struct ptp_ocp *bp;
+	u32 val;
+	int idx;
+
+	bp = dev_get_drvdata(dev);
+
+	val = ioread32(&bp->tod->ctrl);
+	if (!(val & TOD_CTRL_ENABLE)) {
+		seq_printf(s, "TOD Slave disabled\n");
+		return 0;
+	}
+	seq_printf(s, "TOD Slave enabled, Control Register 0x%08X\n", val);
+
+	idx = val & TOD_CTRL_PROTOCOL ? 4 : 0;
+	idx += (val >> 16) & 3;
+	seq_printf(s, "Protocol %s\n", ptp_ocp_tod_proto_name(idx));
+
+	idx = (val >> TOD_CTRL_GNSS_SHIFT) & TOD_CTRL_GNSS_MASK;
+	seq_printf(s, "GNSS %s\n", ptp_ocp_tod_gnss_name(idx));
+
+	val = ioread32(&bp->tod->version);
+	seq_printf(s, "TOD Version %d.%d.%d\n",
+		val >> 24, (val >> 16) & 0xff, val & 0xffff);
+
+	val = ioread32(&bp->tod->status);
+	seq_printf(s, "Status register: 0x%08X\n", val);
+
+	val = ioread32(&bp->tod->adj_sec);
+	idx = (val & ~INT_MAX) ? -1 : 1;
+	idx *= (val & INT_MAX);
+	seq_printf(s, "Correction seconds: %d\n", idx);
+
+	val = ioread32(&bp->tod->utc_status);
+	seq_printf(s, "UTC status register: 0x%08X\n", val);
+	seq_printf(s, "UTC offset: %d  valid:%d\n",
+		val & TOD_STATUS_UTC_MASK, val & TOD_STATUS_UTC_VALID ? 1 : 0);
+	seq_printf(s, "Leap second info valid:%d, Leap second announce %d\n",
+		val & TOD_STATUS_LEAP_VALID ? 1 : 0,
+		val & TOD_STATUS_LEAP_ANNOUNCE ? 1 : 0);
+
+	val = ioread32(&bp->tod->leap);
+	seq_printf(s, "Time to next leap second (in sec): %d\n", (s32) val);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(ptp_ocp_tod_status);
+
 static struct dentry *ptp_ocp_debugfs_root;
 
 static void
@@ -2211,6 +2244,9 @@ ptp_ocp_debugfs_add_device(struct ptp_ocp *bp)
 	bp->debug_root = d;
 	debugfs_create_file("summary", 0444, bp->debug_root,
 			    &bp->dev, &ptp_ocp_summary_fops);
+	if (bp->tod)
+		debugfs_create_file("tod_status", 0444, bp->debug_root,
+				    &bp->dev, &ptp_ocp_tod_status_fops);
 }
 
 static void
@@ -2389,8 +2425,6 @@ ptp_ocp_info(struct ptp_ocp *bp)
 	u32 reg;
 
 	ptp_ocp_phc_info(bp);
-	if (bp->tod)
-		ptp_ocp_tod_info(bp);
 
 	if (bp->image) {
 		u32 ver = ioread32(&bp->image->version);
-- 
2.31.1

