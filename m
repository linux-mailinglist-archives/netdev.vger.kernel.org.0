Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD42152ADA3
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 23:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiEQVqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 17:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiEQVqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 17:46:06 -0400
Received: from smtp1.emailarray.com (smtp1.emailarray.com [65.39.216.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BED61260B
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 14:46:03 -0700 (PDT)
Received: (qmail 26435 invoked by uid 89); 17 May 2022 21:46:01 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 17 May 2022 21:46:01 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     zheyuma97@gmail.com, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, kernel-team@fb.com
Subject: [PATCH net] ptp: ocp: change sysfs attr group handling
Date:   Tue, 17 May 2022 14:46:00 -0700
Message-Id: <20220517214600.10606-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
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

In the detach path, the driver calls sysfs_remove_group() for the
groups it believes has been registered.  However, if the group was
never previously registered, then this causes a splat.

Instead, compute the groups that should be registered in advance,
and then call sysfs_create_groups(), which registers them all at once.

Update the error handling appropriately.

Fixes: c205d53c4923 ("ptp: ocp: Add firmware capability bits for feature gating")
Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 57 +++++++++++++++++++++++++++++++------------
 1 file changed, 42 insertions(+), 15 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 36c0e188216b..860672d6a03c 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -300,7 +300,7 @@ struct ptp_ocp {
 	struct platform_device	*spi_flash;
 	struct clk_hw		*i2c_clk;
 	struct timer_list	watchdog;
-	const struct ocp_attr_group *attr_tbl;
+	const struct attribute_group **attr_group;
 	const struct ptp_ocp_eeprom_map *eeprom_map;
 	struct dentry		*debug_root;
 	time64_t		gnss_lost;
@@ -1836,6 +1836,42 @@ ptp_ocp_signal_init(struct ptp_ocp *bp)
 					     bp->signal_out[i]->mem);
 }
 
+static void
+ptp_ocp_attr_group_del(struct ptp_ocp *bp)
+{
+	sysfs_remove_groups(&bp->dev.kobj, bp->attr_group);
+	kfree(bp->attr_group);
+}
+
+static int
+ptp_ocp_attr_group_add(struct ptp_ocp *bp,
+		       const struct ocp_attr_group *attr_tbl)
+{
+	int count, i;
+	int err;
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
+	err = sysfs_create_groups(&bp->dev.kobj, bp->attr_group);
+	if (err)
+		bp->attr_group[0] = NULL;
+
+	return err;
+}
+
 static void
 ptp_ocp_sma_init(struct ptp_ocp *bp)
 {
@@ -1905,7 +1941,6 @@ ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
 	bp->flash_start = 1024 * 4096;
 	bp->eeprom_map = fb_eeprom_map;
 	bp->fw_version = ioread32(&bp->image->version);
-	bp->attr_tbl = fb_timecard_groups;
 	bp->fw_cap = OCP_CAP_BASIC;
 
 	ver = bp->fw_version & 0xffff;
@@ -1919,6 +1954,10 @@ ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
 	ptp_ocp_sma_init(bp);
 	ptp_ocp_signal_init(bp);
 
+	err = ptp_ocp_attr_group_add(bp, fb_timecard_groups);
+	if (err)
+		return err;
+
 	err = ptp_ocp_fb_set_pins(bp);
 	if (err)
 		return err;
@@ -3389,7 +3428,6 @@ ptp_ocp_complete(struct ptp_ocp *bp)
 {
 	struct pps_device *pps;
 	char buf[32];
-	int i, err;
 
 	if (bp->gnss_port != -1) {
 		sprintf(buf, "ttyS%d", bp->gnss_port);
@@ -3414,14 +3452,6 @@ ptp_ocp_complete(struct ptp_ocp *bp)
 	if (pps)
 		ptp_ocp_symlink(bp, pps->dev, "pps");
 
-	for (i = 0; bp->attr_tbl[i].cap; i++) {
-		if (!(bp->attr_tbl[i].cap & bp->fw_cap))
-			continue;
-		err = sysfs_create_group(&bp->dev.kobj, bp->attr_tbl[i].group);
-		if (err)
-			return err;
-	}
-
 	ptp_ocp_debugfs_add_device(bp);
 
 	return 0;
@@ -3493,15 +3523,11 @@ static void
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
@@ -3511,6 +3537,7 @@ ptp_ocp_detach(struct ptp_ocp *bp)
 
 	ptp_ocp_debugfs_remove_device(bp);
 	ptp_ocp_detach_sysfs(bp);
+	ptp_ocp_attr_group_del(bp);
 	if (timer_pending(&bp->watchdog))
 		del_timer_sync(&bp->watchdog);
 	if (bp->ts0)
-- 
2.31.1

