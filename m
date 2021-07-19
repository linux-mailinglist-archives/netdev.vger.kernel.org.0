Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEE63CCFB8
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235875AbhGSITm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:19:42 -0400
Received: from lucky1.263xmail.com ([211.157.147.131]:45448 "EHLO
        lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235807AbhGSITe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 04:19:34 -0400
Received: from localhost (unknown [192.168.167.235])
        by lucky1.263xmail.com (Postfix) with ESMTP id BE585C2116;
        Mon, 19 Jul 2021 16:53:46 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-SKE-CHECKED: 1
X-ANTISPAM-LEVEL: 2
Received: from localhost.localdomain (unknown [113.57.152.160])
        by smtp.263.net (postfix) whith ESMTP id P4547T140388981532416S1626684826149785_;
        Mon, 19 Jul 2021 16:53:46 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <cd2d5452c41b1d359dbae504a2dc1045>
X-RL-SENDER: chenhaoa@uniontech.com
X-SENDER: chenhaoa@uniontech.com
X-LOGIN-NAME: chenhaoa@uniontech.com
X-FST-TO: peppe.cavallaro@st.com
X-RCPT-COUNT: 11
X-SENDER-IP: 113.57.152.160
X-ATTACHMENT-NUM: 0
X-System-Flag: 0
From:   Hao Chen <chenhaoa@uniontech.com>
To:     peppe.cavallaro@st.com
Cc:     alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org, Hao Chen <chenhaoa@uniontech.com>
Subject: [PATCH v3] net: stmmac: fix 'ethtool -P' return -EBUSY
Date:   Mon, 19 Jul 2021 16:53:06 +0800
Message-Id: <20210719085306.30820-1-chenhaoa@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The permanent mac address should be available for query when the device
is not up.
NetworkManager, the system network daemon, uses 'ethtool -P' to obtain
the permanent address after the kernel start. When the network device
is not up, it will return the device busy error with 'ethtool -P'. At
that time, it is unable to access the Internet through the permanent
address by NetworkManager.
I think that the '.begin' is not used to check if the device is up.

Signed-off-by: Hao Chen <chenhaoa@uniontech.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index d0ce608b81c3..8fbb58c95507 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -15,6 +15,7 @@
 #include <linux/phylink.h>
 #include <linux/net_tstamp.h>
 #include <asm/io.h>
+#include <linux/pm_runtime.h>
 
 #include "stmmac.h"
 #include "dwmac_dma.h"
@@ -412,8 +413,10 @@ static void stmmac_ethtool_setmsglevel(struct net_device *dev, u32 level)
 
 static int stmmac_check_if_running(struct net_device *dev)
 {
-	if (!netif_running(dev))
-		return -EBUSY;
+	struct stmmac_priv *priv = netdev_priv(dev);
+
+	pm_runtime_get_sync(priv->device);
+
 	return 0;
 }
 
-- 
2.20.1



