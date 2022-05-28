Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F16536AC1
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 06:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239596AbiE1EdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 00:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238534AbiE1EdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 00:33:15 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF14E5D5FE;
        Fri, 27 May 2022 21:33:13 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4L981F0KGDzDqSf;
        Sat, 28 May 2022 12:33:05 +0800 (CST)
Received: from dggpemm500018.china.huawei.com (7.185.36.111) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 28 May 2022 12:33:11 +0800
Received: from localhost.localdomain (10.175.112.125) by
 dggpemm500018.china.huawei.com (7.185.36.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 28 May 2022 12:33:11 +0800
From:   Ke Liu <liuke94@huawei.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Ke Liu <liuke94@huawei.com>
Subject: [PATCH] net: phy: Directly use ida_alloc()/free()
Date:   Sat, 28 May 2022 04:54:37 +0000
Message-ID: <20220528045437.102232-1-liuke94@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500018.china.huawei.com (7.185.36.111)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use ida_alloc()/ida_free() instead of deprecated
ida_simple_get()/ida_simple_remove().

Signed-off-by: Ke Liu <liuke94@huawei.com>
---
 drivers/net/phy/fixed_phy.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
index c65fb5f5d2dc..03abe6233bbb 100644
--- a/drivers/net/phy/fixed_phy.c
+++ b/drivers/net/phy/fixed_phy.c
@@ -180,7 +180,7 @@ static void fixed_phy_del(int phy_addr)
 			if (fp->link_gpiod)
 				gpiod_put(fp->link_gpiod);
 			kfree(fp);
-			ida_simple_remove(&phy_fixed_ida, phy_addr);
+			ida_free(&phy_fixed_ida, phy_addr);
 			return;
 		}
 	}
@@ -244,13 +244,13 @@ static struct phy_device *__fixed_phy_register(unsigned int irq,
 	}
 
 	/* Get the next available PHY address, up to PHY_MAX_ADDR */
-	phy_addr = ida_simple_get(&phy_fixed_ida, 0, PHY_MAX_ADDR, GFP_KERNEL);
+	phy_addr = ida_alloc_max(&phy_fixed_ida, PHY_MAX_ADDR - 1, GFP_KERNEL);
 	if (phy_addr < 0)
 		return ERR_PTR(phy_addr);
 
 	ret = fixed_phy_add_gpiod(irq, phy_addr, status, gpiod);
 	if (ret < 0) {
-		ida_simple_remove(&phy_fixed_ida, phy_addr);
+		ida_free(&phy_fixed_ida, phy_addr);
 		return ERR_PTR(ret);
 	}
 
-- 
2.25.1

