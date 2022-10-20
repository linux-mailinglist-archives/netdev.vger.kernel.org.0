Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8830060557E
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 04:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbiJTC0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 22:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbiJTC0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 22:26:11 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2BA189C16
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 19:26:08 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MtBFz5QmxzpVkm;
        Thu, 20 Oct 2022 10:22:47 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 20 Oct
 2022 10:26:06 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <jiri@mellanox.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net 2/2] netdevsim: remove dir in nsim_dev_debugfs_init() when creating ports dir failed
Date:   Thu, 20 Oct 2022 10:33:58 +0800
Message-ID: <20221020023358.263414-3-shaozhengchao@huawei.com>
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

Remove dir in nsim_dev_debugfs_init() when creating ports dir failed.
Otherwise, the netdevsim device will not be created next time. Kernel
reports an error: debugfs: Directory 'netdevsim1' with parent 'netdevsim'
already present!

Fixes: ab1d0cc004d7 ("netdevsim: change debugfs tree topology")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 drivers/net/netdevsim/dev.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 39231c5319de..e44805715ef8 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -309,8 +309,10 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 	if (IS_ERR(nsim_dev->ddir))
 		return PTR_ERR(nsim_dev->ddir);
 	nsim_dev->ports_ddir = debugfs_create_dir("ports", nsim_dev->ddir);
-	if (IS_ERR(nsim_dev->ports_ddir))
-		return PTR_ERR(nsim_dev->ports_ddir);
+	if (IS_ERR(nsim_dev->ports_ddir)) {
+		err = PTR_ERR(nsim_dev->ports_ddir);
+		goto err_ddir;
+	}
 	debugfs_create_bool("fw_update_status", 0600, nsim_dev->ddir,
 			    &nsim_dev->fw_update_status);
 	debugfs_create_u32("fw_update_overwrite_mask", 0600, nsim_dev->ddir,
@@ -346,7 +348,7 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 	nsim_dev->nodes_ddir = debugfs_create_dir("rate_nodes", nsim_dev->ddir);
 	if (IS_ERR(nsim_dev->nodes_ddir)) {
 		err = PTR_ERR(nsim_dev->nodes_ddir);
-		goto err_out;
+		goto err_ports_ddir;
 	}
 	debugfs_create_bool("fail_trap_drop_counter_get", 0600,
 			    nsim_dev->ddir,
@@ -354,8 +356,9 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 	nsim_udp_tunnels_debugfs_create(nsim_dev);
 	return 0;
 
-err_out:
+err_ports_ddir:
 	debugfs_remove_recursive(nsim_dev->ports_ddir);
+err_ddir:
 	debugfs_remove_recursive(nsim_dev->ddir);
 	return err;
 }
-- 
2.17.1

