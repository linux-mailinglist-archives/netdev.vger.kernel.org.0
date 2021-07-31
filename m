Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71003DC372
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 07:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbhGaFJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 01:09:50 -0400
Received: from smtpbgsg3.qq.com ([54.179.177.220]:53336 "EHLO smtpbgsg3.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231558AbhGaFJu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Jul 2021 01:09:50 -0400
X-Greylist: delayed 5843 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Jul 2021 01:09:49 EDT
X-QQ-mid: bizesmtp36t1627708170tp8owyx0
Received: from localhost.localdomain (unknown [117.152.154.62])
        by esmtp6.qq.com (ESMTP) with 
        id ; Sat, 31 Jul 2021 13:09:30 +0800 (CST)
X-QQ-SSF: 0140000000200050B000B00A0000000
X-QQ-FEAT: D8iNkgpwlC/FzaGUSadZ2qTyEowyhJsrDG96RyxigN1lvbBHRl1aOKguN/4ho
        hD03LUQkY+IBu+ZRVdEezhuypQD5QfO5w+2j/S8v0p1LLEK5awd/tFmVH2HVUDiBEKDhrsi
        OqYSyIXuxAuj6LMY+ZmtzwueHPR5UCif4KomF/Ig5qPtQSL3Ql3EIAIzIh2TrmXSBsYhwaO
        oGdl5fa6RZwLJ/7ieYKP5vtzCDgdNHwTUPG0TFzC/g1c03smgxPzDsVLNRzvv1uC9aU8RuW
        RRuaXjJRyE2sJU8jjJOIe5CInFzVmP4CQu65+gRqdT1aci3sMrkv3BI5kNtlTRrwPwQ6jpu
        kxd5/6hKQe0QHDN4bnm3xvp9sxEQyqWV7Wb21F0MK3nFaXC5etdmoeGU5Ml5Q==
X-QQ-GoodBg: 2
From:   Hao Chen <chenhaoa@uniontech.com>
To:     netdev@vger.kernel.org
Cc:     Hao Chen <chenhaoa@uniontech.com>
Subject: [net,v7] net: stmmac: fix 'ethtool -P' return -EBUSY
Date:   Sat, 31 Jul 2021 13:09:28 +0800
Message-Id: <20210731050928.32242-1-chenhaoa@uniontech.com>
X-Mailer: git-send-email 2.32.0.452.g940fe202ad
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign5
X-QQ-Bgrelay: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I want to get permanent MAC address when the card is down. And I think
it is more convenient to get statistics in the down state by 'ethtool -S'.
But current all of the ethool command return -EBUSY.

I don't think we should detect that the network card is up in '. Begin',
which will cause that all the ethtool commands can't be used when the
network card is down. If some ethtool commands can only be used in the
up state, check it in the corresponding ethool OPS function is better.
This is too rude and unreasonable.

I have checked the '.begin' implementation of other drivers, most of which
support the submission of NIC driver for the first time.
They are too old to know why '.begin' is implemented. I suspect that they
have not noticed the usage of '.begin'.

Fixes: 47dd7a540b8a ("net: add support for STMicroelectronics Ethernet
		     controllers.")

Compile-tested on arm64. Tested on an arm64 system with an on-board
STMMAC chip.

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
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  | 21 +++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index d0ce608b81c3..fd5b68f6bf53 100644
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
@@ -410,11 +411,18 @@ static void stmmac_ethtool_setmsglevel(struct net_device *dev, u32 level)
 
 }
 
-static int stmmac_check_if_running(struct net_device *dev)
+static int stmmac_ethtool_begin(struct net_device *dev)
 {
-	if (!netif_running(dev))
-		return -EBUSY;
-	return 0;
+	struct stmmac_priv *priv = netdev_priv(dev);
+
+	return pm_runtime_resume_and_get(priv->device);
+}
+
+static void stmmac_ethtool_complete(struct net_device *dev)
+{
+	struct stmmac_priv *priv = netdev_priv(dev);
+
+	pm_runtime_put(priv->device);
 }
 
 static int stmmac_ethtool_get_regs_len(struct net_device *dev)
@@ -1073,7 +1081,8 @@ static int stmmac_set_tunable(struct net_device *dev,
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



