Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615D8628184
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236908AbiKNNk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236877AbiKNNk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:40:27 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7762120F6C
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 05:40:26 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N9r2j66yjzJnjJ;
        Mon, 14 Nov 2022 21:37:17 +0800 (CST)
Received: from huawei.com (10.175.100.227) by kwepemi500016.china.huawei.com
 (7.221.188.220) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 14 Nov
 2022 21:40:23 +0800
From:   Shang XiaoJing <shangxiaojing@huawei.com>
To:     <horatiu.vultur@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <rmk+kernel@armlinux.org.uk>, <casper.casan@gmail.com>,
        <bjarni.jonasson@microchip.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <shangxiaojing@huawei.com>
Subject: [PATCH 1/2] net: lan966x: Fix potential null-ptr-deref in lan966x_stats_init()
Date:   Mon, 14 Nov 2022 21:38:52 +0800
Message-ID: <20221114133853.5384-2-shangxiaojing@huawei.com>
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

lan966x_stats_init() calls create_singlethread_workqueue() and not
checked the ret value, which may return NULL. And a null-ptr-deref may
happen:

lan966x_stats_init()
    create_singlethread_workqueue() # failed, lan966x->stats_queue is NULL
    queue_delayed_work()
        queue_delayed_work_on()
            __queue_delayed_work()  # warning here, but continue
                __queue_work()      # access wq->flags, null-ptr-deref

Check the ret value and return -ENOMEM if it is NULL.

Fixes: 12c2d0a5b8e2 ("net: lan966x: add ethtool configuration and statistics")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
index e58a27fd8b50..0fb0efc224be 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
@@ -708,6 +708,9 @@ int lan966x_stats_init(struct lan966x *lan966x)
 	snprintf(queue_name, sizeof(queue_name), "%s-stats",
 		 dev_name(lan966x->dev));
 	lan966x->stats_queue = create_singlethread_workqueue(queue_name);
+	if (!lan966x->stats_queue)
+		return -ENOMEM;
+
 	INIT_DELAYED_WORK(&lan966x->stats_work, lan966x_check_stats_work);
 	queue_delayed_work(lan966x->stats_queue, &lan966x->stats_work,
 			   LAN966X_STATS_CHECK_DELAY);
-- 
2.17.1

