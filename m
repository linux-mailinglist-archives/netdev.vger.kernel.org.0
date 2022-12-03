Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F4964148A
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 07:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbiLCGno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 01:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiLCGnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 01:43:43 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E727A9D2D3;
        Fri,  2 Dec 2022 22:43:41 -0800 (PST)
Received: from kwepemi500014.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NPKtj09TkzpW4K;
        Sat,  3 Dec 2022 14:40:13 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 kwepemi500014.china.huawei.com (7.221.188.232) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 3 Dec 2022 14:43:38 +0800
From:   Qiheng Lin <linqiheng@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <daniel.machon@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linqiheng@huawei.com>
Subject: [PATCH v2] net: microchip: sparx5: Fix missing destroy_workqueue of mact_queue
Date:   Sat, 3 Dec 2022 15:02:59 +0800
Message-ID: <20221203070259.19560-1-linqiheng@huawei.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500014.china.huawei.com (7.221.188.232)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mchp_sparx5_probe() won't destroy workqueue created by
create_singlethread_workqueue() in sparx5_start() when later
inits failed. Add destroy_workqueue in the cleanup_ports case,
also add it in mchp_sparx5_remove()

Fixes: b37a1bae742f ("net: sparx5: add mactable support")
Signed-off-by: Qiheng Lin <linqiheng@huawei.com>
---

v2:
 - add the Fixes tag.

 drivers/net/ethernet/microchip/sparx5/sparx5_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index eeac04b84638..b6bbb3c9bd7a 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -887,6 +887,8 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 
 cleanup_ports:
 	sparx5_cleanup_ports(sparx5);
+	if (sparx5->mact_queue)
+		destroy_workqueue(sparx5->mact_queue);
 cleanup_config:
 	kfree(configs);
 cleanup_pnode:
@@ -911,6 +913,7 @@ static int mchp_sparx5_remove(struct platform_device *pdev)
 	sparx5_cleanup_ports(sparx5);
 	/* Unregister netdevs */
 	sparx5_unregister_notifier_blocks(sparx5);
+	destroy_workqueue(sparx5->mact_queue);
 
 	return 0;
 }
-- 
2.32.0

