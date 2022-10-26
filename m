Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D5E60D8EF
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 03:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbiJZBqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 21:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232488AbiJZBqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 21:46:30 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4648EA8374
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 18:46:30 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Mxs3g72srzmVNc;
        Wed, 26 Oct 2022 09:41:35 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 26 Oct
 2022 09:46:28 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <jiri@mellanox.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net] netdevsim: fix memory leak in nsim_bus_dev_new()
Date:   Wed, 26 Oct 2022 09:54:05 +0800
Message-ID: <20221026015405.128795-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If device_register() failed in nsim_bus_dev_new(), the value of reference
in nsim_bus_dev->dev is 1. obj->name in nsim_bus_dev->dev will not be
released.

unreferenced object 0xffff88810352c480 (size 16):
  comm "echo", pid 5691, jiffies 4294945921 (age 133.270s)
  hex dump (first 16 bytes):
    6e 65 74 64 65 76 73 69 6d 31 00 00 00 00 00 00  netdevsim1......
  backtrace:
    [<000000005e2e5e26>] __kmalloc_node_track_caller+0x3a/0xb0
    [<0000000094ca4fc8>] kvasprintf+0xc3/0x160
    [<00000000aad09bcc>] kvasprintf_const+0x55/0x180
    [<000000009bac868d>] kobject_set_name_vargs+0x56/0x150
    [<000000007c1a5d70>] dev_set_name+0xbb/0xf0
    [<00000000ad0d126b>] device_add+0x1f8/0x1cb0
    [<00000000c222ae24>] new_device_store+0x3b6/0x5e0
    [<0000000043593421>] bus_attr_store+0x72/0xa0
    [<00000000cbb1833a>] sysfs_kf_write+0x106/0x160
    [<00000000d0dedb8a>] kernfs_fop_write_iter+0x3a8/0x5a0
    [<00000000770b66e2>] vfs_write+0x8f0/0xc80
    [<0000000078bb39be>] ksys_write+0x106/0x210
    [<00000000005e55a4>] do_syscall_64+0x35/0x80
    [<00000000eaa40bbc>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

Fixes: 40e4fe4ce115 ("netdevsim: move device registration and related code to bus.c")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 drivers/net/netdevsim/bus.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index b5f4df1a07a3..0052968e881e 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -117,6 +117,10 @@ static const struct attribute_group *nsim_bus_dev_attr_groups[] = {
 
 static void nsim_bus_dev_release(struct device *dev)
 {
+	struct nsim_bus_dev *nsim_bus_dev;
+
+	nsim_bus_dev = container_of(dev, struct nsim_bus_dev, dev);
+	kfree(nsim_bus_dev);
 }
 
 static struct device_type nsim_bus_dev_type = {
@@ -291,6 +295,8 @@ nsim_bus_dev_new(unsigned int id, unsigned int port_count, unsigned int num_queu
 
 err_nsim_bus_dev_id_free:
 	ida_free(&nsim_bus_dev_ids, nsim_bus_dev->dev.id);
+	put_device(&nsim_bus_dev->dev);
+	nsim_bus_dev = NULL;
 err_nsim_bus_dev_free:
 	kfree(nsim_bus_dev);
 	return ERR_PTR(err);
@@ -300,9 +306,8 @@ static void nsim_bus_dev_del(struct nsim_bus_dev *nsim_bus_dev)
 {
 	/* Disallow using nsim_bus_dev */
 	smp_store_release(&nsim_bus_dev->init, false);
-	device_unregister(&nsim_bus_dev->dev);
 	ida_free(&nsim_bus_dev_ids, nsim_bus_dev->dev.id);
-	kfree(nsim_bus_dev);
+	device_unregister(&nsim_bus_dev->dev);
 }
 
 static struct device_driver nsim_driver = {
-- 
2.17.1

