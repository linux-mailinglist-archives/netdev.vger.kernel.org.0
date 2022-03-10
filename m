Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54AC04D5301
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 21:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244886AbiCJUUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 15:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244873AbiCJUUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 15:20:23 -0500
Received: from smtp6.emailarray.com (smtp6.emailarray.com [65.39.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981F817FD0E
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 12:19:21 -0800 (PST)
Received: (qmail 46135 invoked by uid 89); 10 Mar 2022 20:19:20 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp6.emailarray.com with SMTP; 10 Mar 2022 20:19:20 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com,
        kernel-team@fb.com
Subject: [PATCH net-next v2 05/10] ptp: ocp: Add firmware capability bits for feature gating
Date:   Thu, 10 Mar 2022 12:19:07 -0800
Message-Id: <20220310201912.933172-6-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220310201912.933172-1-jonathan.lemon@gmail.com>
References: <20220310201912.933172-1-jonathan.lemon@gmail.com>
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

Add the ability to group sysfs nodes behind a firmware feature
check.  This way non-present sysfs attributes are omitted on
older firmware, which does not have newer features.

This will be used in the upcoming patches which adds more
features to the timecard.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 38 +++++++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index d2df28a52926..e55dc9586ec0 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -218,6 +218,13 @@ struct ptp_ocp_sma_connector {
 	bool	disabled;
 };
 
+struct ocp_attr_group {
+	u64 cap;
+	const struct attribute_group *group;
+};
+
+#define OCP_CAP_BASIC	BIT(0)
+
 #define OCP_BOARD_ID_LEN		13
 #define OCP_SERIAL_LEN			6
 
@@ -248,6 +255,7 @@ struct ptp_ocp {
 	struct platform_device	*spi_flash;
 	struct clk_hw		*i2c_clk;
 	struct timer_list	watchdog;
+	const struct ocp_attr_group *attr_tbl;
 	const struct ptp_ocp_eeprom_map *eeprom_map;
 	struct dentry		*debug_root;
 	time64_t		gnss_lost;
@@ -265,6 +273,7 @@ struct ptp_ocp {
 	int			flash_start;
 	u32			utc_tai_offset;
 	u32			ts_window_adjust;
+	u64			fw_cap;
 	struct ptp_ocp_sma_connector sma[4];
 };
 
@@ -290,6 +299,8 @@ static int ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r);
 static irqreturn_t ptp_ocp_ts_irq(int irq, void *priv);
 static int ptp_ocp_ts_enable(void *priv, u32 req, bool enable);
 
+static const struct ocp_attr_group fb_timecard_groups[];
+
 struct ptp_ocp_eeprom_map {
 	u16	off;
 	u16	len;
@@ -1526,6 +1537,8 @@ ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
 	bp->flash_start = 1024 * 4096;
 	bp->eeprom_map = fb_eeprom_map;
 	bp->fw_version = ioread32(&bp->image->version);
+	bp->attr_tbl = fb_timecard_groups;
+	bp->fw_cap = OCP_CAP_BASIC;
 
 	ptp_ocp_tod_init(bp);
 	ptp_ocp_nmea_out_init(bp);
@@ -2167,7 +2180,7 @@ tod_correction_store(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RW(tod_correction);
 
-static struct attribute *timecard_attrs[] = {
+static struct attribute *fb_timecard_attrs[] = {
 	&dev_attr_serialnum.attr,
 	&dev_attr_gnss_sync.attr,
 	&dev_attr_clock_source.attr,
@@ -2186,7 +2199,13 @@ static struct attribute *timecard_attrs[] = {
 	&dev_attr_tod_correction.attr,
 	NULL,
 };
-ATTRIBUTE_GROUPS(timecard);
+static const struct attribute_group fb_timecard_group = {
+	.attrs = fb_timecard_attrs,
+};
+static const struct ocp_attr_group fb_timecard_groups[] = {
+	{ .cap = OCP_CAP_BASIC,	    .group = &fb_timecard_group },
+	{ },
+};
 
 static void
 gpio_input_map(char *buf, struct ptp_ocp *bp, u16 map[][2], u16 bit,
@@ -2605,6 +2624,7 @@ ptp_ocp_complete(struct ptp_ocp *bp)
 {
 	struct pps_device *pps;
 	char buf[32];
+	int i, err;
 
 	if (bp->gnss_port != -1) {
 		sprintf(buf, "ttyS%d", bp->gnss_port);
@@ -2629,8 +2649,13 @@ ptp_ocp_complete(struct ptp_ocp *bp)
 	if (pps)
 		ptp_ocp_symlink(bp, pps->dev, "pps");
 
-	if (device_add_groups(&bp->dev, timecard_groups))
-		pr_err("device add groups failed\n");
+	for (i = 0; bp->attr_tbl[i].cap; i++) {
+		if (!(bp->attr_tbl[i].cap & bp->fw_cap))
+			continue;
+		err = sysfs_create_group(&bp->dev.kobj, bp->attr_tbl[i].group);
+		if (err)
+			return err;
+	}
 
 	ptp_ocp_debugfs_add_device(bp);
 
@@ -2703,12 +2728,15 @@ static void
 ptp_ocp_detach_sysfs(struct ptp_ocp *bp)
 {
 	struct device *dev = &bp->dev;
+	int i;
 
 	sysfs_remove_link(&dev->kobj, "ttyGNSS");
 	sysfs_remove_link(&dev->kobj, "ttyMAC");
 	sysfs_remove_link(&dev->kobj, "ptp");
 	sysfs_remove_link(&dev->kobj, "pps");
-	device_remove_groups(dev, timecard_groups);
+	if (bp->attr_tbl)
+		for (i = 0; bp->attr_tbl[i].cap; i++)
+			sysfs_remove_group(&dev->kobj, bp->attr_tbl[i].group);
 }
 
 static void
-- 
2.31.1

