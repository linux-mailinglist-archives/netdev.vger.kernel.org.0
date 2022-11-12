Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E891B62674B
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 07:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbiKLGHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 01:07:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiKLGHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 01:07:47 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259411A394
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 22:07:46 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N8Q8Z70vyz15MMX;
        Sat, 12 Nov 2022 14:07:26 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 12 Nov 2022 14:07:42 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <pabeni@redhat.com>, Wang Yufen <wangyufen@huawei.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH] netdevsim: Fix memory leak of nsim_dev->fa_cookie
Date:   Sat, 12 Nov 2022 14:28:05 +0800
Message-ID: <1668234485-27635-1-git-send-email-wangyufen@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmemleak reports this issue:

unreferenced object 0xffff8881bac872d0 (size 8):
  comm "sh", pid 58603, jiffies 4481524462 (age 68.065s)
  hex dump (first 8 bytes):
    04 00 00 00 de ad be ef                          ........
  backtrace:
    [<00000000c80b8577>] __kmalloc+0x49/0x150
    [<000000005292b8c6>] nsim_dev_trap_fa_cookie_write+0xc1/0x210 [netdevsim]
    [<0000000093d78e77>] full_proxy_write+0xf3/0x180
    [<000000005a662c16>] vfs_write+0x1c5/0xaf0
    [<000000007aabf84a>] ksys_write+0xed/0x1c0
    [<000000005f1d2e47>] do_syscall_64+0x3b/0x90
    [<000000006001c6ec>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

The issue occurs in the following scenarios:

nsim_dev_trap_fa_cookie_write()
  kmalloc() fa_cookie
  nsim_dev->fa_cookie = fa_cookie
..
nsim_drv_remove()

nsim_dev->fa_cookie alloced, but the nsim_dev_trap_report_work()
job has not been done, the flow action cookie has not been assigned
to the metadata. To fix, add kfree(nsim_dev->fa_cookie) to
nsim_drv_remove().

Fixes: d3cbb907ae57 ("netdevsim: add ACL trap reporting cookie as a metadata")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Cc: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/netdevsim/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index a7880c7..68e56e4 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1683,6 +1683,7 @@ void nsim_drv_remove(struct nsim_bus_dev *nsim_bus_dev)
 				  ARRAY_SIZE(nsim_devlink_params));
 	devl_resources_unregister(devlink);
 	kfree(nsim_dev->vfconfigs);
+	kfree(nsim_dev->fa_cookie);
 	devl_unlock(devlink);
 	devlink_free(devlink);
 	dev_set_drvdata(&nsim_bus_dev->dev, NULL);
-- 
1.8.3.1

