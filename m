Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 512FD4ED8BC
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 13:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234501AbiCaLzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 07:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232730AbiCaLzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 07:55:42 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936814199E;
        Thu, 31 Mar 2022 04:53:54 -0700 (PDT)
Received: from kwepemi500022.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KThRv59lXzBrtJ;
        Thu, 31 Mar 2022 19:49:47 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500022.china.huawei.com (7.221.188.64) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 31 Mar 2022 19:53:52 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 31 Mar 2022 19:53:51 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <andrew@lunn.ch>, <davem@davemloft.net>, <kuba@kernel.org>,
        <o.rempel@pengutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH] net: phy: genphy_loopback: fix loopback failed when speed is unknown
Date:   Thu, 31 Mar 2022 19:48:19 +0800
Message-ID: <20220331114819.14929-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If phy link status is down because link partner goes down, the phy speed
will be updated to SPEED_UNKNOWN when autoneg on with general phy driver.
If test loopback in this case, the phy speed will be set to 10M. However,
the speed of mac may not be 10M, it causes loopback test failed.

To fix this problem, if speed is SPEED_UNKNOWN, don't configure link speed.

Fixes: 014068dcb5b1 ("net: phy: genphy_loopback: add link speed configuration")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/phy/phy_device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8406ac739def..5001bb1a019c 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2618,6 +2618,9 @@ int genphy_loopback(struct phy_device *phydev, bool enable)
 			ctl |= BMCR_SPEED1000;
 		else if (phydev->speed == SPEED_100)
 			ctl |= BMCR_SPEED100;
+		else if (phydev->speed == SPEED_UNKNOWN)
+			return phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
+					  BMCR_LOOPBACK);
 
 		if (phydev->duplex == DUPLEX_FULL)
 			ctl |= BMCR_FULLDPLX;
-- 
2.33.0

