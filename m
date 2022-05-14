Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A92526D44
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 01:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384927AbiEMXAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 19:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384920AbiEMW7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 18:59:51 -0400
Received: from smtp3.emailarray.com (smtp3.emailarray.com [65.39.216.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA29B1DA76
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 15:59:45 -0700 (PDT)
Received: (qmail 80948 invoked by uid 89); 13 May 2022 22:59:39 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 13 May 2022 22:59:39 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, kernel-team@fb.com
Subject: [PATCH net-next v3 10/10] ptp: ocp: change sysfs attr group handling
Date:   Fri, 13 May 2022 15:59:24 -0700
Message-Id: <20220513225924.1655-11-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220513225924.1655-1-jonathan.lemon@gmail.com>
References: <20220513225924.1655-1-jonathan.lemon@gmail.com>
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

In the detach path, the driver calls sysfs_remove_group() for the
groups it believes has been registered.  However, if the group was
never previously registered, then this causes a splat.

Instead, compute the groups that should be registered in advance,
and then use sysfs_create_groups(), which registers them all at once.
Update the error handling appropriately.

Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 67 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 53 insertions(+), 14 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 4ff7f16242cf..6772b1e7e6d2 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -321,7 +321,7 @@ struct ptp_ocp {
 	struct platform_device	*spi_flash;
 	struct clk_hw		*i2c_clk;
 	struct timer_list	watchdog;
-	const struct ocp_attr_group *attr_tbl;
+	const struct attribute_group **attr_group;
 	const struct ptp_ocp_eeprom_map *eeprom_map;
 	struct dentry		*debug_root;
 	time64_t		gnss_lost;
@@ -1946,6 +1946,30 @@ ptp_ocp_signal_init(struct ptp_ocp *bp)
 					     bp->signal_out[i]->mem);
 }
 
+static int
+ptp_ocp_build_attr_group(struct ptp_ocp *bp,
+			 const struct ocp_attr_group *attr_tbl)
+{
+	int count, i;
+
+	count = 0;
+	for (i = 0; attr_tbl[i].cap; i++)
+		if (attr_tbl[i].cap & bp->fw_cap)
+			count++;
+
+	bp->attr_group = kcalloc(count + 1, sizeof(struct attribute_group *),
+				 GFP_KERNEL);
+	if (!bp->attr_group)
+		return -ENOMEM;
+
+	count = 0;
+	for (i = 0; attr_tbl[i].cap; i++)
+		if (attr_tbl[i].cap & bp->fw_cap)
+			bp->attr_group[count++] = attr_tbl[i].group;
+
+	return 0;
+}
+
 static void
 ptp_ocp_enable_fpga(u32 __iomem *reg, u32 bit, bool enable)
 {
@@ -2184,7 +2208,6 @@ ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
 	bp->flash_start = 1024 * 4096;
 	bp->eeprom_map = fb_eeprom_map;
 	bp->fw_version = ioread32(&bp->image->version);
-	bp->attr_tbl = fb_timecard_groups;
 	bp->sma_op = &ocp_fb_sma_op;
 
 	ptp_ocp_fb_set_version(bp);
@@ -2194,6 +2217,10 @@ ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
 	ptp_ocp_sma_init(bp);
 	ptp_ocp_signal_init(bp);
 
+	err = ptp_ocp_build_attr_group(bp, fb_timecard_groups);
+	if (err)
+		return err;
+
 	err = ptp_ocp_fb_set_pins(bp);
 	if (err)
 		return err;
@@ -3539,12 +3566,31 @@ ptp_ocp_link_child(struct ptp_ocp *bp, const char *name, const char *link)
 	put_device(child);
 }
 
+static void
+ptp_ocp_attr_group_del(struct ptp_ocp *bp)
+{
+	sysfs_remove_groups(&bp->dev.kobj, bp->attr_group);
+	kfree(bp->attr_group);
+}
+
+static int
+ptp_ocp_attr_group_add(struct ptp_ocp *bp)
+{
+	int err;
+
+	err = sysfs_create_groups(&bp->dev.kobj, bp->attr_group);
+	if (err)
+		bp->attr_group[0] = NULL;
+
+	return err;
+}
+
 static int
 ptp_ocp_complete(struct ptp_ocp *bp)
 {
 	struct pps_device *pps;
 	char buf[32];
-	int i, err;
+	int err;
 
 	if (bp->gnss_port != -1) {
 		sprintf(buf, "ttyS%d", bp->gnss_port);
@@ -3569,13 +3615,9 @@ ptp_ocp_complete(struct ptp_ocp *bp)
 	if (pps)
 		ptp_ocp_symlink(bp, pps->dev, "pps");
 
-	for (i = 0; bp->attr_tbl[i].cap; i++) {
-		if (!(bp->attr_tbl[i].cap & bp->fw_cap))
-			continue;
-		err = sysfs_create_group(&bp->dev.kobj, bp->attr_tbl[i].group);
-		if (err)
-			return err;
-	}
+	err = ptp_ocp_attr_group_add(bp);
+	if (err)
+		return err;
 
 	ptp_ocp_debugfs_add_device(bp);
 
@@ -3640,15 +3682,11 @@ static void
 ptp_ocp_detach_sysfs(struct ptp_ocp *bp)
 {
 	struct device *dev = &bp->dev;
-	int i;
 
 	sysfs_remove_link(&dev->kobj, "ttyGNSS");
 	sysfs_remove_link(&dev->kobj, "ttyMAC");
 	sysfs_remove_link(&dev->kobj, "ptp");
 	sysfs_remove_link(&dev->kobj, "pps");
-	if (bp->attr_tbl)
-		for (i = 0; bp->attr_tbl[i].cap; i++)
-			sysfs_remove_group(&dev->kobj, bp->attr_tbl[i].group);
 }
 
 static void
@@ -3658,6 +3696,7 @@ ptp_ocp_detach(struct ptp_ocp *bp)
 
 	ptp_ocp_debugfs_remove_device(bp);
 	ptp_ocp_detach_sysfs(bp);
+	ptp_ocp_attr_group_del(bp);
 	if (timer_pending(&bp->watchdog))
 		del_timer_sync(&bp->watchdog);
 	if (bp->ts0)
-- 
2.31.1

