Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D38760D8DF
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 03:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbiJZBjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 21:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbiJZBjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 21:39:12 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD32CC806
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 18:39:09 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Mxs0b2vnMzHvJD;
        Wed, 26 Oct 2022 09:38:55 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 26 Oct
 2022 09:39:07 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <dsa@cumulusnetworks.com>, <jiri@mellanox.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net,v3 1/2] netdevsim: fix memory leak in nsim_drv_probe() when nsim_dev_resources_register() failed
Date:   Wed, 26 Oct 2022 09:46:41 +0800
Message-ID: <20221026014642.116261-2-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221026014642.116261-1-shaozhengchao@huawei.com>
References: <20221026014642.116261-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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

Fixes: 37923ed6b8ce ("netdevsim: Add simple FIB resource controller via devlink")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 drivers/net/netdevsim/dev.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 794fc0cc73b8..81c3e14af063 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -442,7 +442,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 				     &params);
 	if (err) {
 		pr_err("Failed to register IPv4 top resource\n");
-		goto out;
+		goto err_out;
 	}
 
 	err = devl_resource_register(devlink, "fib", (u64)-1,
@@ -450,7 +450,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 				     NSIM_RESOURCE_IPV4, &params);
 	if (err) {
 		pr_err("Failed to register IPv4 FIB resource\n");
-		return err;
+		goto err_out;
 	}
 
 	err = devl_resource_register(devlink, "fib-rules", (u64)-1,
@@ -458,7 +458,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 				     NSIM_RESOURCE_IPV4, &params);
 	if (err) {
 		pr_err("Failed to register IPv4 FIB rules resource\n");
-		return err;
+		goto err_out;
 	}
 
 	/* Resources for IPv6 */
@@ -468,7 +468,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 				     &params);
 	if (err) {
 		pr_err("Failed to register IPv6 top resource\n");
-		goto out;
+		goto err_out;
 	}
 
 	err = devl_resource_register(devlink, "fib", (u64)-1,
@@ -476,7 +476,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 				     NSIM_RESOURCE_IPV6, &params);
 	if (err) {
 		pr_err("Failed to register IPv6 FIB resource\n");
-		return err;
+		goto err_out;
 	}
 
 	err = devl_resource_register(devlink, "fib-rules", (u64)-1,
@@ -484,7 +484,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 				     NSIM_RESOURCE_IPV6, &params);
 	if (err) {
 		pr_err("Failed to register IPv6 FIB rules resource\n");
-		return err;
+		goto err_out;
 	}
 
 	/* Resources for nexthops */
@@ -492,8 +492,14 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 				     NSIM_RESOURCE_NEXTHOPS,
 				     DEVLINK_RESOURCE_ID_PARENT_TOP,
 				     &params);
+	if (err) {
+		pr_err("Failed to register NEXTHOPS resource\n");
+		goto err_out;
+	}
+	return 0;
 
-out:
+err_out:
+	devl_resources_unregister(devlink);
 	return err;
 }
 
-- 
2.17.1

