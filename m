Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D667D602CAD
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 15:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiJRNRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 09:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJRNRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 09:17:14 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75770BE2C1
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 06:17:11 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MsDmd0ZFFzVhp9;
        Tue, 18 Oct 2022 21:12:33 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 21:17:08 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 18 Oct
 2022 21:17:08 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <loic.poulain@linaro.org>, <ryazanov.s.a@gmail.com>,
        <johannes@sipsolutions.net>, <davem@davemloft.net>
Subject: [PATCH net] wwan_hwsim: fix possible memory leak in wwan_hwsim_dev_new()
Date:   Tue, 18 Oct 2022 21:16:07 +0800
Message-ID: <20221018131607.1901641-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Inject fault while probing module, if device_register() fails,
but the refcount of kobject is not decreased to 0, the name
allocated in dev_set_name() is leaked. Fix this by calling
put_device(), so that name can be freed in callback function
kobject_cleanup().

unreferenced object 0xffff88810152ad20 (size 8):
  comm "modprobe", pid 252, jiffies 4294849206 (age 22.713s)
  hex dump (first 8 bytes):
    68 77 73 69 6d 30 00 ff                          hwsim0..
  backtrace:
    [<000000009c3504ed>] __kmalloc_node_track_caller+0x44/0x1b0
    [<00000000c0228a5e>] kvasprintf+0xb5/0x140
    [<00000000cff8c21f>] kvasprintf_const+0x55/0x180
    [<0000000055a1e073>] kobject_set_name_vargs+0x56/0x150
    [<000000000a80b139>] dev_set_name+0xab/0xe0

Fixes: f36a111a74e7 ("wwan_hwsim: WWAN device simulator")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/wwan/wwan_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/wwan_hwsim.c b/drivers/net/wwan/wwan_hwsim.c
index ff09a8cedf93..2397a903d8f5 100644
--- a/drivers/net/wwan/wwan_hwsim.c
+++ b/drivers/net/wwan/wwan_hwsim.c
@@ -311,7 +311,7 @@ static struct wwan_hwsim_dev *wwan_hwsim_dev_new(void)
 	return ERR_PTR(err);
 
 err_free_dev:
-	kfree(dev);
+	put_device(&dev->dev);
 
 	return ERR_PTR(err);
 }
-- 
2.25.1

