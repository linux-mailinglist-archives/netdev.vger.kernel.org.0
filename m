Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898153FBF98
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 01:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239186AbhH3Xxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 19:53:42 -0400
Received: from smtp1.emailarray.com ([65.39.216.14]:34525 "EHLO
        smtp1.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239141AbhH3Xxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 19:53:38 -0400
Received: (qmail 25347 invoked by uid 89); 30 Aug 2021 23:52:43 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 30 Aug 2021 23:52:43 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, abyagowi@fb.com
Subject: [PATCH net-next 05/11] ptp: ocp: Add third timestamper
Date:   Mon, 30 Aug 2021 16:52:30 -0700
Message-Id: <20210830235236.309993-6-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210830235236.309993-1-jonathan.lemon@gmail.com>
References: <20210830235236.309993-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The firmware may provide a third signal timestamper, so make it
available for use.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index ad8b794fa7e6..c5fbccab57a8 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -162,6 +162,7 @@ struct ptp_ocp {
 	struct ptp_ocp_ext_src	*pps;
 	struct ptp_ocp_ext_src	*ts0;
 	struct ptp_ocp_ext_src	*ts1;
+	struct ptp_ocp_ext_src	*ts2;
 	struct img_reg __iomem	*image;
 	struct ptp_clock	*ptp;
 	struct ptp_clock_info	ptp_info;
@@ -228,7 +229,7 @@ static int ptp_ocp_ts_enable(void *priv, bool enable);
  * 3: GPS
  * 4: GPS2 (n/c)
  * 5: MAC
- * 6: N/C
+ * 6: TS2
  * 7: I2C controller
  * 8: HWICAP
  * 9: SPI Flash
@@ -257,6 +258,15 @@ static struct ocp_resource ocp_fb_resource[] = {
 			.enable = ptp_ocp_ts_enable,
 		},
 	},
+	{
+		OCP_EXT_RESOURCE(ts2),
+		.offset = 0x01060000, .size = 0x10000, .irq_vec = 6,
+		.extra = &(struct ptp_ocp_ext_info) {
+			.index = 2,
+			.irq_fcn = ptp_ocp_ts_irq,
+			.enable = ptp_ocp_ts_enable,
+		},
+	},
 	{
 		OCP_MEM_RESOURCE(pps_to_ext),
 		.offset = 0x01030000, .size = 0x10000,
@@ -497,6 +507,9 @@ ptp_ocp_enable(struct ptp_clock_info *ptp_info, struct ptp_clock_request *rq,
 		case 1:
 			ext = bp->ts1;
 			break;
+		case 2:
+			ext = bp->ts2;
+			break;
 		}
 		break;
 	case PTP_CLK_REQ_PPS:
@@ -524,7 +537,7 @@ static const struct ptp_clock_info ptp_ocp_clock_info = {
 	.adjphase	= ptp_ocp_adjphase,
 	.enable		= ptp_ocp_enable,
 	.pps		= true,
-	.n_ext_ts	= 2,
+	.n_ext_ts	= 3,
 };
 
 static void
@@ -1403,6 +1416,8 @@ ptp_ocp_detach(struct ptp_ocp *bp)
 		ptp_ocp_unregister_ext(bp->ts0);
 	if (bp->ts1)
 		ptp_ocp_unregister_ext(bp->ts1);
+	if (bp->ts2)
+		ptp_ocp_unregister_ext(bp->ts2);
 	if (bp->pps)
 		ptp_ocp_unregister_ext(bp->pps);
 	if (bp->gnss_port != -1)
-- 
2.31.1

