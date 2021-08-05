Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58BC93E1D19
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 21:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242974AbhHET7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 15:59:48 -0400
Received: from smtp1.emailarray.com ([65.39.216.14]:37240 "EHLO
        smtp1.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240646AbhHET7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 15:59:46 -0400
Received: (qmail 15308 invoked by uid 89); 5 Aug 2021 19:52:51 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 5 Aug 2021 19:52:51 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 2/6] ptp: ocp: Add the mapping for the external PPS registers.
Date:   Thu,  5 Aug 2021 12:52:44 -0700
Message-Id: <20210805195248.35665-3-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210805195248.35665-1-jonathan.lemon@gmail.com>
References: <20210805195248.35665-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two PPS blocks: one handles the external PPS signal output,
with the other handling the PPS signal input to the internal clock.
Add controls for the external PPS block.

Rename the fields so they match their function.

Add cable_delay to the register definitions.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 261713c6e9a7..8804e79477cd 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -113,6 +113,8 @@ struct ts_reg {
 struct pps_reg {
 	u32	ctrl;
 	u32	status;
+	u32	__pad0[6];
+	u32	cable_delay;
 };
 
 #define PPS_STATUS_FILTER_ERR	BIT(0)
@@ -149,7 +151,8 @@ struct ptp_ocp {
 	spinlock_t		lock;
 	struct ocp_reg __iomem	*reg;
 	struct tod_reg __iomem	*tod;
-	struct pps_reg __iomem	*pps_monitor;
+	struct pps_reg __iomem	*pps_to_ext;
+	struct pps_reg __iomem	*pps_to_clk;
 	struct ptp_ocp_ext_src	*pps;
 	struct ptp_ocp_ext_src	*ts0;
 	struct ptp_ocp_ext_src	*ts1;
@@ -251,7 +254,11 @@ static struct ocp_resource ocp_fb_resource[] = {
 		},
 	},
 	{
-		OCP_MEM_RESOURCE(pps_monitor),
+		OCP_MEM_RESOURCE(pps_to_ext),
+		.offset = 0x01030000, .size = 0x10000,
+	},
+	{
+		OCP_MEM_RESOURCE(pps_to_clk),
 		.offset = 0x01040000, .size = 0x10000,
 	},
 	{
@@ -537,10 +544,10 @@ ptp_ocp_watchdog(struct timer_list *t)
 	unsigned long flags;
 	u32 status;
 
-	status = ioread32(&bp->pps_monitor->status);
+	status = ioread32(&bp->pps_to_clk->status);
 
 	if (status & PPS_STATUS_SUPERV_ERR) {
-		iowrite32(status, &bp->pps_monitor->status);
+		iowrite32(status, &bp->pps_to_clk->status);
 		if (!bp->gps_lost) {
 			spin_lock_irqsave(&bp->lock, flags);
 			__ptp_ocp_clear_drift_locked(bp);
-- 
2.31.1

