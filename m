Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEBA3DE478
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 04:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233546AbhHCCjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 22:39:54 -0400
Received: from smtpbg704.qq.com ([203.205.195.105]:51479 "EHLO
        smtpproxy21.qq.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233197AbhHCCjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 22:39:53 -0400
X-QQ-mid: bizesmtp54t1627958365tg9a9fs1
Received: from localhost.localdomain (unknown [113.57.152.160])
        by esmtp6.qq.com (ESMTP) with 
        id ; Tue, 03 Aug 2021 10:39:24 +0800 (CST)
X-QQ-SSF: 0140000000200050B000C00A0000000
X-QQ-FEAT: QSPOcZ5XRR88uEGwvvxIcz97lq5ebdAr2D+x+HQKeogB61KJ0rsk+Ozr3ZDDW
        jRuVLSj7j4nmnu7d6pOs0Ms6+urIUBBpgoz08rLLfd8RowFi0ftMsyDhRj19q872qD9HUbN
        QWwu9ifwZ51taEP6SAuWb/ewTj522t+Ez3YYvYy7BCkpxNURkC9xgtHCxRR8x4T0Fy0EWC1
        V2VidfUWNoaT3sGYX6yvQbWQrSomgcM1vEAbXb+pOftVmjykaek/8ELgCy99S4GQ7kOySA2
        4Mvh3pl7mcMEcllB31XqKSpbSG0zbju3ls1v0plhSYv41kQEVn9zBI4NkkO0rE+zGmr/jIe
        oMre8hATxOD2+PYI5J945ZncxCJOEdMlD0uS2qa8hSQVP8JecFvLZepgVYCJw==
X-QQ-GoodBg: 2
From:   Hao Chen <chenhaoa@uniontech.com>
To:     netdev@vger.kernel.org
Cc:     Hao Chen <chenhaoa@uniontech.com>
Subject: [net-next,v8] net: stmmac: optimize check in ops '.begin'
Date:   Tue,  3 Aug 2021 10:38:36 +0800
Message-Id: <20210803023836.6244-1-chenhaoa@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign2
X-QQ-Bgrelay: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I want to get permanent MAC address when the interface is down. And I think
it is more convenient to get statistics in the down state by 'ethtool -S'.
But current all of the ethool command return -EBUSY.

I don't think we should check that the network interface is up in '.begin',
which will cause that all the ethtool commands can't be used when the
network interface is down. If some ethtool commands can only be used in the
up state, check it in the corresponding ethool OPS function is better.
This is too rude and unreasonable.

Compile-tested on arm64. Tested on an arm64 system with an on-board
STMMAC chip.

Changes v7 ... v8:
- Optimize commit description information, optimization parameters of
  pm_runtime function.

Changes v6 ... v7:
- fix arg type error of 'dev' to 'priv->device'.

Changes v5 ... v6:
- The 4.19.90 kernel not support pm_runtime, so implemente '.begin' and
  '.complete' again. Add return value check of pm_runtime function.

Changes v4 ... v5:
- test the '.begin' will return -13 error on my machine based on 4.19.90
  kernel. The platform driver does not supported pm_runtime. So remove the
  implementation of '.begin' and '.complete'.

Changes v3 ... v4:
- implement '.complete' ethtool OPS.

Changes v2 ... v3:
- add linux/pm_runtime.h head file.

Changes v1 ... v2:
- fix spell error of dev.

Signed-off-by: Hao Chen <chenhaoa@uniontech.com>
---
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c    | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index d0ce608b81c3..8e2ae0ff7f8f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -12,8 +12,9 @@
 #include <linux/ethtool.h>
 #include <linux/interrupt.h>
 #include <linux/mii.h>
-#include <linux/phylink.h>
 #include <linux/net_tstamp.h>
+#include <linux/phylink.h>
+#include <linux/pm_runtime.h>
 #include <asm/io.h>
 
 #include "stmmac.h"
@@ -410,11 +411,14 @@ static void stmmac_ethtool_setmsglevel(struct net_device *dev, u32 level)
 
 }
 
-static int stmmac_check_if_running(struct net_device *dev)
+static int stmmac_ethtool_begin(struct net_device *dev)
 {
-	if (!netif_running(dev))
-		return -EBUSY;
-	return 0;
+	return pm_runtime_resume_and_get(dev->dev);
+}
+
+static void stmmac_ethtool_complete(struct net_device *dev)
+{
+	pm_runtime_put(dev->dev);
 }
 
 static int stmmac_ethtool_get_regs_len(struct net_device *dev)
@@ -1073,7 +1077,8 @@ static int stmmac_set_tunable(struct net_device *dev,
 static const struct ethtool_ops stmmac_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES,
-	.begin = stmmac_check_if_running,
+	.begin = stmmac_ethtool_begin,
+	.complete = stmmac_ethtool_complete,
 	.get_drvinfo = stmmac_ethtool_getdrvinfo,
 	.get_msglevel = stmmac_ethtool_getmsglevel,
 	.set_msglevel = stmmac_ethtool_setmsglevel,
-- 
2.20.1



