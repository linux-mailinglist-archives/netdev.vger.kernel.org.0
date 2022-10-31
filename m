Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 765A5613015
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 07:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiJaGBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 02:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiJaGBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 02:01:21 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04654B875
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 23:01:19 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N12Zh6bxpzHtpH;
        Mon, 31 Oct 2022 14:01:00 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 14:01:17 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <afleming@freescale.com>,
        <buytenh@wantstofly.org>, <cuigaosheng1@huawei.com>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH] net: mdio: fix undefined behavior in bit shift for __mdiobus_register
Date:   Mon, 31 Oct 2022 14:01:16 +0800
Message-ID: <20221031060116.3967513-1-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.148.83]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shifting signed 32-bit value by 31 bits is undefined, so changing
significant bit to unsigned. The UBSAN warning calltrace like below:

UBSAN: shift-out-of-bounds in drivers/net/phy/mdio_bus.c:586:27
left shift of 1 by 31 places cannot be represented in type 'int'
Call Trace:
 <TASK>
 dump_stack_lvl+0x7d/0xa5
 dump_stack+0x15/0x1b
 ubsan_epilogue+0xe/0x4e
 __ubsan_handle_shift_out_of_bounds+0x1e7/0x20c
 __mdiobus_register+0x49d/0x4e0
 fixed_mdio_bus_init+0xd8/0x12d
 do_one_initcall+0x76/0x430
 kernel_init_freeable+0x3b3/0x422
 kernel_init+0x24/0x1e0
 ret_from_fork+0x1f/0x30
 </TASK>

Fixes: 4fd5f812c23c ("phylib: allow incremental scanning of an mii bus")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 drivers/net/phy/mdio_bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index f82090bdf7ab..0cbd9ee87514 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -583,7 +583,7 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	}
 
 	for (i = 0; i < PHY_MAX_ADDR; i++) {
-		if ((bus->phy_mask & (1 << i)) == 0) {
+		if ((bus->phy_mask & (1U << i)) == 0) {
 			struct phy_device *phydev;
 
 			phydev = mdiobus_scan(bus, i);
-- 
2.25.1

