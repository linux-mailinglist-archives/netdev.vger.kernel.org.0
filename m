Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47EC8613589
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 13:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbiJaMOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 08:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbiJaMOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 08:14:47 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CFAE02E
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 05:14:46 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N1Bm875Gwz15MGr;
        Mon, 31 Oct 2022 20:09:44 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 20:14:44 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 31 Oct
 2022 20:14:44 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <isdn@linux-pingi.de>, <davem@davemloft.net>
Subject: [PATCH 2/2] isdn: mISDN: netjet: fix wrong check of device registration
Date:   Mon, 31 Oct 2022 20:13:41 +0800
Message-ID: <20221031121341.1293978-3-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221031121341.1293978-1-yangyingliang@huawei.com>
References: <20221031121341.1293978-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The class is set in mISDN_register_device(), but if device_add() returns
error, it will lead to delete a device without added, fix this by using
device_is_registered() to check if the device is registered.

Fixes: a900845e5661 ("mISDN: Add support for Traverse Technologies NETJet PCI cards")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/isdn/hardware/mISDN/netjet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/netjet.c b/drivers/isdn/hardware/mISDN/netjet.c
index a52f275f8263..f8447135a902 100644
--- a/drivers/isdn/hardware/mISDN/netjet.c
+++ b/drivers/isdn/hardware/mISDN/netjet.c
@@ -956,7 +956,7 @@ nj_release(struct tiger_hw *card)
 	}
 	if (card->irq > 0)
 		free_irq(card->irq, card);
-	if (card->isac.dch.dev.dev.class)
+	if (device_is_registered(&card->isac.dch.dev.dev))
 		mISDN_unregister_device(&card->isac.dch.dev);
 
 	for (i = 0; i < 2; i++) {
-- 
2.25.1

