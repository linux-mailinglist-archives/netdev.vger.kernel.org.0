Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0BB762DE
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 11:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbfGZJ5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 05:57:10 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:45098 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725815AbfGZJ5K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 05:57:10 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A574AA3A8054CBAEA764;
        Fri, 26 Jul 2019 17:57:07 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Fri, 26 Jul 2019 17:56:59 +0800
From:   Yonglong Liu <liuyonglong@huawei.com>
To:     <andrew@lunn.ch>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <shiju.jose@huawei.com>
Subject: [RFC] net: phy: read link status twice when phy_check_link_status()
Date:   Fri, 26 Jul 2019 17:53:51 +0800
Message-ID: <1564134831-24962-1-git-send-email-liuyonglong@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the datasheet of Marvell phy and Realtek phy, the
copper link status should read twice, or it may get a fake link
up status, and cause up->down->up at the first time when link up.
This happens more oftem at Realtek phy.

I add a fake status read, and can solve this problem.

I also see that in genphy_update_link(), had delete the fake
read in polling mode, so I don't know whether my solution is
correct.

Or provide a phydev->drv->read_status functions for the phy I
used is more acceptable?

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
---
 drivers/net/phy/phy.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index ef7aa73..0c03edc 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1,4 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0+
+	err = phy_read_status(phydev);
+	if (err)
+		return err;
 /* Framework for configuring and reading PHY devices
  * Based on code in sungem_phy.c and gianfar_phy.c
  *
@@ -525,6 +528,11 @@ static int phy_check_link_status(struct phy_device *phydev)
 
 	WARN_ON(!mutex_is_locked(&phydev->lock));
 
+	/* Do a fake read */
+	err = phy_read(phydev, MII_BMSR);
+	if (err < 0)
+		return err;
+
 	err = phy_read_status(phydev);
 	if (err)
 		return err;
-- 
2.8.1

