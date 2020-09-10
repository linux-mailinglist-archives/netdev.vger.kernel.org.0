Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA29265158
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgIJUxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:53:10 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:59268 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbgIJUwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:52:43 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08AKqcEd034925;
        Thu, 10 Sep 2020 15:52:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599771158;
        bh=t7k46oT9pdpc2te28RZVzUBs6yLYoN9qqxmc9rN0uSU=;
        h=From:To:CC:Subject:Date;
        b=undEP0rsph6DlL2R+xPaLD+9BEhykMfEuAMAd6MROCbwOSHDWlrrnxbB2P5w7PM7S
         NYHBw2TKvjWRWN7pRFQzEzdgP4qtgc5lGZeobOXAJ3oND4Gwv90iwbMjpGviciHhTO
         NfwwqW5fkZ9i0gdky4FFT9Fu/kM0rtmzQm1Evst4=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08AKqc5J089725;
        Thu, 10 Sep 2020 15:52:38 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 10
 Sep 2020 15:52:38 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 10 Sep 2020 15:52:38 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08AKqbEN070224;
        Thu, 10 Sep 2020 15:52:37 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH] net: ethernet: ti: cpsw_new: fix suspend/resume
Date:   Thu, 10 Sep 2020 23:52:29 +0300
Message-ID: <20200910205229.21288-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missed suspend/resume callbacks to properly restore networking after
suspend/resume cycle.

Fixes: ed3525eda4c4 ("net: ethernet: ti: introduce cpsw switchdev based driver part 1 - dual-emac")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw_new.c | 53 ++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 8ed78577cded..15672d0a4de6 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -17,6 +17,7 @@
 #include <linux/phy.h>
 #include <linux/phy/phy.h>
 #include <linux/delay.h>
+#include <linux/pinctrl/consumer.h>
 #include <linux/pm_runtime.h>
 #include <linux/gpio/consumer.h>
 #include <linux/of.h>
@@ -2070,9 +2071,61 @@ static int cpsw_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static int __maybe_unused cpsw_suspend(struct device *dev)
+{
+	struct cpsw_common *cpsw = dev_get_drvdata(dev);
+	int i;
+
+	rtnl_lock();
+
+	for (i = 0; i < cpsw->data.slaves; i++) {
+		struct net_device *ndev = cpsw->slaves[i].ndev;
+
+		if (!(ndev && netif_running(ndev)))
+			continue;
+
+		cpsw_ndo_stop(ndev);
+	}
+
+	rtnl_unlock();
+
+	/* Select sleep pin state */
+	pinctrl_pm_select_sleep_state(dev);
+
+	return 0;
+}
+
+static int __maybe_unused cpsw_resume(struct device *dev)
+{
+	struct cpsw_common *cpsw = dev_get_drvdata(dev);
+	int i;
+
+	/* Select default pin state */
+	pinctrl_pm_select_default_state(dev);
+
+	/* shut up ASSERT_RTNL() warning in netif_set_real_num_tx/rx_queues */
+	rtnl_lock();
+
+	for (i = 0; i < cpsw->data.slaves; i++) {
+		struct net_device *ndev = cpsw->slaves[i].ndev;
+
+		if (!(ndev && netif_running(ndev)))
+			continue;
+
+		cpsw_ndo_open(ndev);
+	}
+
+	rtnl_unlock();
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(cpsw_pm_ops, cpsw_suspend, cpsw_resume);
+
 static struct platform_driver cpsw_driver = {
 	.driver = {
 		.name	 = "cpsw-switch",
+		.pm	 = &cpsw_pm_ops,
 		.of_match_table = cpsw_of_mtable,
 	},
 	.probe = cpsw_probe,
-- 
2.17.1

