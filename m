Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4211852B048
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 03:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbiERB5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 21:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbiERB47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 21:56:59 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5166030579;
        Tue, 17 May 2022 18:56:56 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4L2wyJ2fvlzGppJ;
        Wed, 18 May 2022 09:54:00 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 18 May 2022 09:56:54 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 09:56:54 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <wellslutw@gmail.com>, <andrew@lunn.ch>, <pabeni@redhat.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH -next v2] net: ethernet: sunplus: add missing of_node_put() in spl2sw_mdio_init()
Date:   Wed, 18 May 2022 10:08:12 +0800
Message-ID: <20220518020812.2626293-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

of_get_child_by_name() returns device node pointer with refcount
incremented. The refcount should be decremented before returning
from spl2sw_mdio_init().

Fixes: fd3040b9394c ("net: ethernet: Add driver for Sunplus SP7021")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
v2:
  add fix tag.
---
 drivers/net/ethernet/sunplus/spl2sw_mdio.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sunplus/spl2sw_mdio.c b/drivers/net/ethernet/sunplus/spl2sw_mdio.c
index 139ac8f2685e..733ae1704269 100644
--- a/drivers/net/ethernet/sunplus/spl2sw_mdio.c
+++ b/drivers/net/ethernet/sunplus/spl2sw_mdio.c
@@ -97,8 +97,10 @@ u32 spl2sw_mdio_init(struct spl2sw_common *comm)
 
 	/* Allocate and register mdio bus. */
 	mii_bus = devm_mdiobus_alloc(&comm->pdev->dev);
-	if (!mii_bus)
-		return -ENOMEM;
+	if (!mii_bus) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	mii_bus->name = "sunplus_mii_bus";
 	mii_bus->parent = &comm->pdev->dev;
@@ -110,10 +112,13 @@ u32 spl2sw_mdio_init(struct spl2sw_common *comm)
 	ret = of_mdiobus_register(mii_bus, mdio_np);
 	if (ret) {
 		dev_err(&comm->pdev->dev, "Failed to register mdiobus!\n");
-		return ret;
+		goto out;
 	}
 
 	comm->mii_bus = mii_bus;
+
+out:
+	of_node_put(mdio_np);
 	return ret;
 }
 
-- 
2.25.1

