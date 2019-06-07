Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDDAC3977D
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 23:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731234AbfFGVPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 17:15:51 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:48681 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730373AbfFGVPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 17:15:49 -0400
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <mkl@pengutronix.de>)
        id 1hZMDD-00006I-DZ; Fri, 07 Jun 2019 23:15:47 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        linux-stable <stable@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 2/9] can: flexcan: fix timeout when set small bitrate
Date:   Fri,  7 Jun 2019 23:15:34 +0200
Message-Id: <20190607211541.16095-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190607211541.16095-1-mkl@pengutronix.de>
References: <20190607211541.16095-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

Current we can meet timeout issue when setting a small bitrate like
10000 as follows on i.MX6UL EVK board (ipg clock = 66MHZ, per clock =
30MHZ):

| root@imx6ul7d:~# ip link set can0 up type can bitrate 10000

A link change request failed with some changes committed already.
Interface can0 may have been left with an inconsistent configuration,
please check.

| RTNETLINK answers: Connection timed out

It is caused by calling of flexcan_chip_unfreeze() timeout.

Originally the code is using usleep_range(10, 20) for unfreeze
operation, but the patch (8badd65 can: flexcan: avoid calling
usleep_range from interrupt context) changed it into udelay(10) which is
only a half delay of before, there're also some other delay changes.

After double to FLEXCAN_TIMEOUT_US to 100 can fix the issue.

Meanwhile, Rasmus Villemoes reported that even with a timeout of 100,
flexcan_probe() fails on the MPC8309, which requires a value of at least
140 to work reliably. 250 works for everyone.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Reviewed-by: Dong Aisheng <aisheng.dong@nxp.com>
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 1c66fb2ad76b..f97c628eb2ad 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -166,7 +166,7 @@
 #define FLEXCAN_MB_CNT_LENGTH(x)	(((x) & 0xf) << 16)
 #define FLEXCAN_MB_CNT_TIMESTAMP(x)	((x) & 0xffff)
 
-#define FLEXCAN_TIMEOUT_US		(50)
+#define FLEXCAN_TIMEOUT_US		(250)
 
 /* FLEXCAN hardware feature flags
  *
-- 
2.20.1

