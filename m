Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE3460557D
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 04:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbiJTC0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 22:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiJTC0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 22:26:09 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441BA18983F
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 19:26:08 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MtBDK2qmTzmVCv;
        Thu, 20 Oct 2022 10:21:21 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 20 Oct
 2022 10:26:05 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <jiri@mellanox.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net 1/2] netdevsim: fix memory leak in nsim_drv_probe() when nsim_dev_resources_register() failed
Date:   Thu, 20 Oct 2022 10:33:57 +0800
Message-ID: <20221020023358.263414-2-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221020023358.263414-1-shaozhengchao@huawei.com>
References: <20221020023358.263414-1-shaozhengchao@huawei.com>
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

If some items in nsim_dev_resources_register() fail, memory leak will
occur. The following is the memory leak information.

unreferenced object 0xffff888074c02600 (size 128):
  comm "echo", pid 8159, jiffies 4294945184 (age 493.530s)
  hex dump (first 32 bytes):
    40 47 ea 89 ff ff ff ff 01 00 00 00 00 00 00 00  @G..............
    ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
  backtrace:
    [<0000000011a31c98>] kmalloc_trace+0x22/0x60
    [<0000000027384c69>] devl_resource_register+0x144/0x4e0
    [<00000000a16db248>] nsim_drv_probe+0x37a/0x1260
    [<000000007d1f448c>] really_probe+0x20b/0xb10
    [<00000000c416848a>] __driver_probe_device+0x1b3/0x4a0
    [<00000000077e0351>] driver_probe_device+0x49/0x140
    [<0000000054f2465a>] __device_attach_driver+0x18c/0x2a0
    [<000000008538f359>] bus_for_each_drv+0x151/0x1d0
    [<0000000038e09747>] __device_attach+0x1c9/0x4e0
    [<00000000dd86e533>] bus_probe_device+0x1d5/0x280
    [<00000000839bea35>] device_add+0xae0/0x1cb0
    [<000000009c2abf46>] new_device_store+0x3b6/0x5f0
    [<00000000fb823d7f>] bus_attr_store+0x72/0xa0
    [<000000007acc4295>] sysfs_kf_write+0x106/0x160
    [<000000005f50cb4d>] kernfs_fop_write_iter+0x3a8/0x5a0
    [<0000000075eb41bf>] vfs_write+0x8f0/0xc80

Fixes: 8fb4bc6fd5bd ("netdevsim: rename devlink.c to dev.c to contain per-dev(asic) items")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 drivers/net/netdevsim/dev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 794fc0cc73b8..39231c5319de 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1554,7 +1554,7 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 
 	err = nsim_dev_resources_register(devlink);
 	if (err)
-		goto err_vfc_free;
+		goto err_dl_unregister;
 
 	err = devlink_params_register(devlink, nsim_devlink_params,
 				      ARRAY_SIZE(nsim_devlink_params));
@@ -1627,7 +1627,6 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 				  ARRAY_SIZE(nsim_devlink_params));
 err_dl_unregister:
 	devl_resources_unregister(devlink);
-err_vfc_free:
 	kfree(nsim_dev->vfconfigs);
 err_devlink_unlock:
 	devl_unlock(devlink);
-- 
2.17.1

