Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296A9380521
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 10:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbhENIZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 04:25:02 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:2981 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhENIZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 04:25:00 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FhM1q42bczlbR6;
        Fri, 14 May 2021 16:21:35 +0800 (CST)
Received: from ubuntu1804.huawei.com (10.67.174.98) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Fri, 14 May 2021 16:23:37 +0800
From:   Pu Lehui <pulehui@huawei.com>
To:     <chris.snook@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <johannes@sipsolutions.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pulehui@huawei.com>
Subject: [PATCH net-next] alx: fix missing unlock on error in alx_set_pauseparam()
Date:   Fri, 14 May 2021 16:24:05 +0800
Message-ID: <20210514082405.91011-1-pulehui@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.98]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missing unlock before return from function alx_set_pauseparam()
in the error handling case.

Fixes: 4a5fe57e7751 ("alx: use fine-grained locking instead of RTNL")
Signed-off-by: Pu Lehui <pulehui@huawei.com>
---
 drivers/net/ethernet/atheros/alx/ethtool.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/alx/ethtool.c b/drivers/net/ethernet/atheros/alx/ethtool.c
index f3627157a38a..b716adacd815 100644
--- a/drivers/net/ethernet/atheros/alx/ethtool.c
+++ b/drivers/net/ethernet/atheros/alx/ethtool.c
@@ -253,8 +253,10 @@ static int alx_set_pauseparam(struct net_device *netdev,
 
 	if (reconfig_phy) {
 		err = alx_setup_speed_duplex(hw, hw->adv_cfg, fc);
-		if (err)
+		if (err) {
+			mutex_unlock(&alx->mtx);
 			return err;
+		}
 	}
 
 	/* flow control on mac */
-- 
2.17.1

