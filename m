Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 963DA602BAA
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 14:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiJRMZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 08:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiJRMZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 08:25:36 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516FEB7EE1
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 05:25:34 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MsCfZ56XqzpVY7;
        Tue, 18 Oct 2022 20:22:14 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 20:25:32 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 18 Oct
 2022 20:25:31 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>
Subject: [PATCH net] net: hns: fix possible memory leak in hnae_ae_register()
Date:   Tue, 18 Oct 2022 20:24:51 +0800
Message-ID: <20221018122451.1749171-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
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

Inject fault while probing module, if device_register() fails,
but the refcount of kobject is not decreased to 0, the name
allocated in dev_set_name() is leaked. Fix this by calling
put_device(), so that name can be freed in callback function
kobject_cleanup().

unreferenced object 0xffff00c01aba2100 (size 128):
  comm "systemd-udevd", pid 1259, jiffies 4294903284 (age 294.152s)
  hex dump (first 32 bytes):
    68 6e 61 65 30 00 00 00 18 21 ba 1a c0 00 ff ff  hnae0....!......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000034783f26>] slab_post_alloc_hook+0xa0/0x3e0
    [<00000000748188f2>] __kmem_cache_alloc_node+0x164/0x2b0
    [<00000000ab0743e8>] __kmalloc_node_track_caller+0x6c/0x390
    [<000000006c0ffb13>] kvasprintf+0x8c/0x118
    [<00000000fa27bfe1>] kvasprintf_const+0x60/0xc8
    [<0000000083e10ed7>] kobject_set_name_vargs+0x3c/0xc0
    [<000000000b87affc>] dev_set_name+0x7c/0xa0
    [<000000003fd8fe26>] hnae_ae_register+0xcc/0x190 [hnae]
    [<00000000fe97edc9>] hns_dsaf_ae_init+0x9c/0x108 [hns_dsaf]
    [<00000000c36ff1eb>] hns_dsaf_probe+0x548/0x748 [hns_dsaf]

Fixes: 6fe6611ff275 ("net: add Hisilicon Network Subsystem hnae framework support")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns/hnae.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hnae.c b/drivers/net/ethernet/hisilicon/hns/hnae.c
index 00fafc0f8512..430eccea8e5e 100644
--- a/drivers/net/ethernet/hisilicon/hns/hnae.c
+++ b/drivers/net/ethernet/hisilicon/hns/hnae.c
@@ -419,8 +419,10 @@ int hnae_ae_register(struct hnae_ae_dev *hdev, struct module *owner)
 	hdev->cls_dev.release = hnae_release;
 	(void)dev_set_name(&hdev->cls_dev, "hnae%d", hdev->id);
 	ret = device_register(&hdev->cls_dev);
-	if (ret)
+	if (ret) {
+		put_device(&hdev->cls_dev);
 		return ret;
+	}
 
 	__module_get(THIS_MODULE);
 
-- 
2.25.1

