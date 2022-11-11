Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94CF8625447
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 08:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbiKKHIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 02:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233176AbiKKHIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 02:08:40 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E630BF7F;
        Thu, 10 Nov 2022 23:08:32 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N7qYD1nsKz15MX1;
        Fri, 11 Nov 2022 15:08:16 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 15:08:30 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <vburru@marvell.com>, <aayarekar@marvell.com>,
        <sburla@marvell.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 1/4] octeon_ep: delete unnecessary napi rollback under set_queues_err in octep_open()
Date:   Fri, 11 Nov 2022 15:08:27 +0800
Message-ID: <e9fdc4ce6a49105bc9005e94ce13788b16043ed3.1668150074.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1668150074.git.william.xuanziyang@huawei.com>
References: <cover.1668150074.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

octep_napi_add() and octep_napi_enable() are all after
netif_set_real_num_{tx,rx}_queues() in octep_open(), so it is unnecessary
napi rollback under set_queues_err. Delete them to fix it.

Fixes: 37d79d059606 ("octeon_ep: add Tx/Rx processing and interrupt support")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 9089adcb75f9..7985a748fafe 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -527,8 +527,6 @@ static int octep_open(struct net_device *netdev)
 	return 0;
 
 set_queues_err:
-	octep_napi_disable(oct);
-	octep_napi_delete(oct);
 	octep_clean_irqs(oct);
 setup_irq_err:
 	octep_free_oqs(oct);
-- 
2.25.1

