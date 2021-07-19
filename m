Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3225E3CCEB2
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 09:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234904AbhGSHo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 03:44:59 -0400
Received: from lucky1.263xmail.com ([211.157.147.135]:46116 "EHLO
        lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234861AbhGSHo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 03:44:58 -0400
Received: from localhost (unknown [192.168.167.224])
        by lucky1.263xmail.com (Postfix) with ESMTP id A154EB1E2B;
        Mon, 19 Jul 2021 15:41:47 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-SKE-CHECKED: 1
X-ANTISPAM-LEVEL: 2
Received: from localhost.localdomain (unknown [113.57.152.160])
        by smtp.263.net (postfix) whith ESMTP id P4529T140205484918528S1626680507152669_;
        Mon, 19 Jul 2021 15:41:47 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <64e0872b634c955f01fe8d3d28d83891>
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
Subject: [PATCH] net: stmmac: fix 'ethtool -P' return -EBUSY
Date:   Mon, 19 Jul 2021 15:41:06 +0800
Message-Id: <20210719074106.4251-1-chenhaoa@uniontech.com>
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
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index d0ce608b81c3..ef99b9533612 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -412,8 +412,10 @@ static void stmmac_ethtool_setmsglevel(struct net_device *dev, u32 level)
 
 static int stmmac_check_if_running(struct net_device *dev)
 {
-	if (!netif_running(dev))
-		return -EBUSY;
+	struct stmmac_priv *priv = netdev_priv(ndev);
+
+	pm_runtime_get_sync(priv->device);
+
 	return 0;
 }
 
-- 
2.20.1



