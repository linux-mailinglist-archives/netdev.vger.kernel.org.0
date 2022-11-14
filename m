Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580EC628185
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236722AbiKNNkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:40:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236888AbiKNNk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:40:28 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EAF921815
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 05:40:27 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N9r2k6YqqzJnjL;
        Mon, 14 Nov 2022 21:37:18 +0800 (CST)
Received: from huawei.com (10.175.100.227) by kwepemi500016.china.huawei.com
 (7.221.188.220) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 14 Nov
 2022 21:40:24 +0800
From:   Shang XiaoJing <shangxiaojing@huawei.com>
To:     <horatiu.vultur@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <rmk+kernel@armlinux.org.uk>, <casper.casan@gmail.com>,
        <bjarni.jonasson@microchip.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <shangxiaojing@huawei.com>
Subject: [PATCH 2/2] net: microchip: sparx5: Fix potential null-ptr-deref in sparx_stats_init() and sparx5_start()
Date:   Mon, 14 Nov 2022 21:38:53 +0800
Message-ID: <20221114133853.5384-3-shangxiaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221114133853.5384-1-shangxiaojing@huawei.com>
References: <20221114133853.5384-1-shangxiaojing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sparx_stats_init() calls create_singlethread_workqueue() and not
checked the ret value, which may return NULL. And a null-ptr-deref may
happen:

sparx_stats_init()
    create_singlethread_workqueue() # failed, sparx5->stats_queue is NULL
    queue_delayed_work()
        queue_delayed_work_on()
            __queue_delayed_work()  # warning here, but continue
                __queue_work()      # access wq->flags, null-ptr-deref

Check the ret value and return -ENOMEM if it is NULL. So as
sparx5_start().

Fixes: af4b11022e2d ("net: sparx5: add ethtool configuration and statistics support")
Fixes: b37a1bae742f ("net: sparx5: add mactable support")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c | 3 +++
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c    | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
index 6b0febcb7fa9..01f3a3a41cdb 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
@@ -1253,6 +1253,9 @@ int sparx_stats_init(struct sparx5 *sparx5)
 	snprintf(queue_name, sizeof(queue_name), "%s-stats",
 		 dev_name(sparx5->dev));
 	sparx5->stats_queue = create_singlethread_workqueue(queue_name);
+	if (!sparx5->stats_queue)
+		return -ENOMEM;
+
 	INIT_DELAYED_WORK(&sparx5->stats_work, sparx5_check_stats_work);
 	queue_delayed_work(sparx5->stats_queue, &sparx5->stats_work,
 			   SPX5_STATS_CHECK_DELAY);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 62a325e96345..eeac04b84638 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -659,6 +659,9 @@ static int sparx5_start(struct sparx5 *sparx5)
 	snprintf(queue_name, sizeof(queue_name), "%s-mact",
 		 dev_name(sparx5->dev));
 	sparx5->mact_queue = create_singlethread_workqueue(queue_name);
+	if (!sparx5->mact_queue)
+		return -ENOMEM;
+
 	INIT_DELAYED_WORK(&sparx5->mact_work, sparx5_mact_pull_work);
 	queue_delayed_work(sparx5->mact_queue, &sparx5->mact_work,
 			   SPX5_MACT_PULL_DELAY);
-- 
2.17.1

