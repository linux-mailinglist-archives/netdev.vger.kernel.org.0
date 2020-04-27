Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1A21BA1B5
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 12:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgD0KvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 06:51:24 -0400
Received: from mga04.intel.com ([192.55.52.120]:53864 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726938AbgD0KvX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 06:51:23 -0400
IronPort-SDR: RhHeks+9KTdPNkfb3xmWSH3Ad724VTvhausKbns4Rp0HSvsrAzvDXSPhMfW63u10VOKl6GXSGN
 qU5ROCIIpFEg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 03:51:23 -0700
IronPort-SDR: jCXnJrbxB2CHyo2y1o4VDaszzW168Ji7tLn3D6ppkDIe7YEU3lasL+560qDsRV5fk+sVDdSDTq
 pejK527xJozw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,323,1583222400"; 
   d="scan'208";a="458328818"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 27 Apr 2020 03:51:22 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 337011ED; Mon, 27 Apr 2020 13:51:21 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v1] net: macb: Fix runtime PM refcounting
Date:   Mon, 27 Apr 2020 13:51:20 +0300
Message-Id: <20200427105120.77892-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit e6a41c23df0d, while trying to fix an issue,

    ("net: macb: ensure interface is not suspended on at91rm9200")

introduced a refcounting regression, because in error case refcounter
must be balanced. Fix it by calling pm_runtime_put_noidle() in error case.

While here, fix the same mistake in other couple of places.

Fixes: e6a41c23df0d ("net: macb: ensure interface is not suspended on at91rm9200")
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index a0e8c5bbabc01..f739d16d29b1d 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -334,8 +334,10 @@ static int macb_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 	int status;
 
 	status = pm_runtime_get_sync(&bp->pdev->dev);
-	if (status < 0)
+	if (status < 0) {
+		pm_runtime_put_noidle(&bp->pdev->dev);
 		goto mdio_pm_exit;
+	}
 
 	status = macb_mdio_wait_for_idle(bp);
 	if (status < 0)
@@ -386,8 +388,10 @@ static int macb_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 	int status;
 
 	status = pm_runtime_get_sync(&bp->pdev->dev);
-	if (status < 0)
+	if (status < 0) {
+		pm_runtime_put_noidle(&bp->pdev->dev);
 		goto mdio_pm_exit;
+	}
 
 	status = macb_mdio_wait_for_idle(bp);
 	if (status < 0)
@@ -3816,8 +3820,10 @@ static int at91ether_open(struct net_device *dev)
 	int ret;
 
 	ret = pm_runtime_get_sync(&lp->pdev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(&lp->pdev->dev);
 		return ret;
+	}
 
 	/* Clear internal statistics */
 	ctl = macb_readl(lp, NCR);
-- 
2.26.2

