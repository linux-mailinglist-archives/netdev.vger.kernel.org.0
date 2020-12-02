Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1EB42CB9BB
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 10:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388273AbgLBJyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 04:54:16 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:8920 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgLBJyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 04:54:16 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CmDmg5X3vz6ty0;
        Wed,  2 Dec 2020 17:53:07 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Wed, 2 Dec 2020 17:53:32 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <jeff@garzik.org>,
        <olof@lixom.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: pasemi: fix error return code in pasemi_mac_open()
Date:   Wed, 2 Dec 2020 17:57:15 +0800
Message-ID: <1606903035-1838-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 72b05b9940f0 ("pasemi_mac: RX/TX ring management cleanup")
Fixes: 8d636d8bc5ff ("pasemi_mac: jumbo frame support")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/pasemi/pasemi_mac.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pasemi/pasemi_mac.c b/drivers/net/ethernet/pasemi/pasemi_mac.c
index be66601..040a15a 100644
--- a/drivers/net/ethernet/pasemi/pasemi_mac.c
+++ b/drivers/net/ethernet/pasemi/pasemi_mac.c
@@ -1078,16 +1078,20 @@ static int pasemi_mac_open(struct net_device *dev)
 
 	mac->tx = pasemi_mac_setup_tx_resources(dev);
 
-	if (!mac->tx)
+	if (!mac->tx) {
+		ret = -ENOMEM;
 		goto out_tx_ring;
+	}
 
 	/* We might already have allocated rings in case mtu was changed
 	 * before interface was brought up.
 	 */
 	if (dev->mtu > 1500 && !mac->num_cs) {
 		pasemi_mac_setup_csrings(mac);
-		if (!mac->num_cs)
+		if (!mac->num_cs) {
+			ret = -ENOMEM;
 			goto out_tx_ring;
+		}
 	}
 
 	/* Zero out rmon counters */
-- 
2.9.5

