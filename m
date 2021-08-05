Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58463E1D1A
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 21:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242988AbhHET7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 15:59:52 -0400
Received: from smtp7.emailarray.com ([65.39.216.66]:10851 "EHLO
        smtp7.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242941AbhHET7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 15:59:49 -0400
Received: (qmail 26094 invoked by uid 89); 5 Aug 2021 19:52:52 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 5 Aug 2021 19:52:52 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 3/6] ptp: ocp: Remove devlink health and unused parameters.
Date:   Thu,  5 Aug 2021 12:52:45 -0700
Message-Id: <20210805195248.35665-4-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210805195248.35665-1-jonathan.lemon@gmail.com>
References: <20210805195248.35665-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"devlink health" was used as a way to monitor the GNSS signal
status.  This isn't really the intended use, and the same
functionality can be achived by monitoring the status file.

Remove the devlink heath support entirely, and also remove the
currently unused devlink parameters.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 80 -------------------------------------------
 1 file changed, 80 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 8804e79477cd..33cbd3135a00 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -162,7 +162,6 @@ struct ptp_ocp {
 	struct platform_device	*i2c_ctrl;
 	struct platform_device	*spi_flash;
 	struct clk_hw		*i2c_clk;
-	struct devlink_health_reporter *health;
 	struct timer_list	watchdog;
 	time64_t		gps_lost;
 	int			id;
@@ -184,7 +183,6 @@ struct ocp_resource {
 	unsigned long bp_offset;
 };
 
-static void ptp_ocp_health_update(struct ptp_ocp *bp);
 static int ptp_ocp_register_mem(struct ptp_ocp *bp, struct ocp_resource *r);
 static int ptp_ocp_register_i2c(struct ptp_ocp *bp, struct ocp_resource *r);
 static int ptp_ocp_register_spi(struct ptp_ocp *bp, struct ocp_resource *r);
@@ -553,12 +551,10 @@ ptp_ocp_watchdog(struct timer_list *t)
 			__ptp_ocp_clear_drift_locked(bp);
 			spin_unlock_irqrestore(&bp->lock, flags);
 			bp->gps_lost = ktime_get_real_seconds();
-			ptp_ocp_health_update(bp);
 		}
 
 	} else if (bp->gps_lost) {
 		bp->gps_lost = 0;
-		ptp_ocp_health_update(bp);
 	}
 
 	mod_timer(&bp->watchdog, jiffies + HZ);
@@ -740,14 +736,6 @@ ptp_ocp_info(struct ptp_ocp *bp)
 	ptp_ocp_tod_info(bp);
 }
 
-static const struct devlink_param ptp_ocp_devlink_params[] = {
-};
-
-static void
-ptp_ocp_devlink_set_params_init_values(struct devlink *devlink)
-{
-}
-
 static int
 ptp_ocp_devlink_register(struct devlink *devlink, struct device *dev)
 {
@@ -757,25 +745,12 @@ ptp_ocp_devlink_register(struct devlink *devlink, struct device *dev)
 	if (err)
 		return err;
 
-	err = devlink_params_register(devlink, ptp_ocp_devlink_params,
-				      ARRAY_SIZE(ptp_ocp_devlink_params));
-	ptp_ocp_devlink_set_params_init_values(devlink);
-	if (err)
-		goto out;
-	devlink_params_publish(devlink);
-
 	return 0;
-
-out:
-	devlink_unregister(devlink);
-	return err;
 }
 
 static void
 ptp_ocp_devlink_unregister(struct devlink *devlink)
 {
-	devlink_params_unregister(devlink, ptp_ocp_devlink_params,
-				  ARRAY_SIZE(ptp_ocp_devlink_params));
 	devlink_unregister(devlink);
 }
 
@@ -922,58 +897,6 @@ static const struct devlink_ops ptp_ocp_devlink_ops = {
 	.info_get = ptp_ocp_devlink_info_get,
 };
 
-static int
-ptp_ocp_health_diagnose(struct devlink_health_reporter *reporter,
-			struct devlink_fmsg *fmsg,
-			struct netlink_ext_ack *extack)
-{
-	struct ptp_ocp *bp = devlink_health_reporter_priv(reporter);
-	char buf[32];
-	int err;
-
-	if (!bp->gps_lost)
-		return 0;
-
-	sprintf(buf, "%ptT", &bp->gps_lost);
-	err = devlink_fmsg_string_pair_put(fmsg, "Lost sync at", buf);
-	if (err)
-		return err;
-
-	return 0;
-}
-
-static void
-ptp_ocp_health_update(struct ptp_ocp *bp)
-{
-	int state;
-
-	state = bp->gps_lost ? DEVLINK_HEALTH_REPORTER_STATE_ERROR
-			     : DEVLINK_HEALTH_REPORTER_STATE_HEALTHY;
-
-	if (bp->gps_lost)
-		devlink_health_report(bp->health, "No GPS signal", NULL);
-
-	devlink_health_reporter_state_update(bp->health, state);
-}
-
-static const struct devlink_health_reporter_ops ptp_ocp_health_ops = {
-	.name = "gps_sync",
-	.diagnose = ptp_ocp_health_diagnose,
-};
-
-static void
-ptp_ocp_devlink_health_register(struct devlink *devlink)
-{
-	struct ptp_ocp *bp = devlink_priv(devlink);
-	struct devlink_health_reporter *r;
-
-	r = devlink_health_reporter_create(devlink, &ptp_ocp_health_ops, 0, bp);
-	if (IS_ERR(r))
-		dev_err(&bp->pdev->dev, "Failed to create reporter, err %ld\n",
-			PTR_ERR(r));
-	bp->health = r;
-}
-
 static void __iomem *
 __ptp_ocp_get_mem(struct ptp_ocp *bp, unsigned long start, int size)
 {
@@ -1514,8 +1437,6 @@ ptp_ocp_detach(struct ptp_ocp *bp)
 		pci_free_irq_vectors(bp->pdev);
 	if (bp->ptp)
 		ptp_clock_unregister(bp->ptp);
-	if (bp->health)
-		devlink_health_reporter_destroy(bp->health);
 	device_unregister(&bp->dev);
 }
 
@@ -1578,7 +1499,6 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ptp_ocp_info(bp);
 	ptp_ocp_resource_summary(bp);
-	ptp_ocp_devlink_health_register(devlink);
 
 	return 0;
 
-- 
2.31.1

