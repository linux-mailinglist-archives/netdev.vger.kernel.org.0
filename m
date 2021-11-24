Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEDA45B699
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 09:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241372AbhKXIhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 03:37:34 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:15861 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241362AbhKXIhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 03:37:05 -0500
Received: from dggpeml500020.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HzZ5x4JvLz8xwD;
        Wed, 24 Nov 2021 16:33:25 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggpeml500020.china.huawei.com (7.185.36.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 24 Nov 2021 16:33:52 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Wed, 24 Nov
 2021 16:33:51 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <gerhard@engleder-embedded.com>, <kuba@kernel.org>,
        <davem@davemloft.net>
Subject: [PATCH -next] tsnep: Add missing of_node_put() in tsnep_mdio_init()
Date:   Wed, 24 Nov 2021 16:40:48 +0800
Message-ID: <20211124084048.175456-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The node pointer is returned by of_get_child_by_name() with
refcount incremented in tsnep_mdio_init(). Calling of_node_put()
to aovid the refcount leak in tsnep_mdio_init().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 8333313dd706..d7d436d6aed2 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1089,9 +1089,10 @@ static int tsnep_mdio_init(struct tsnep_adapter *adapter)
 	adapter->mdiobus->phy_mask = 0x0000001;
 
 	retval = of_mdiobus_register(adapter->mdiobus, np);
+
+out:
 	if (np)
 		of_node_put(np);
-out:
 
 	return retval;
 }
-- 
2.25.1

