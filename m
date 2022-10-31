Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8403F6136A2
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 13:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbiJaMmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 08:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiJaMmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 08:42:18 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7157673;
        Mon, 31 Oct 2022 05:42:17 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N1CPc2ljqzpW2h;
        Mon, 31 Oct 2022 20:38:44 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 20:42:15 +0800
Received: from localhost.localdomain (10.175.112.70) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 20:42:14 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jeff Garzik <jgarzik@pobox.com>,
        Finn Thain <fthain@linux-m68k.org>
CC:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net/sonic: use dma_mapping_error() for error check
Date:   Mon, 31 Oct 2022 21:02:02 +0800
Message-ID: <1667221322-8317-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DMA address returned by dma_map_single() should be checked with
dma_mapping_error(). Fix it accordingly.

Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/natsemi/sonic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index d17d1b4..4050d5b 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -292,7 +292,7 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 	 */
 
 	laddr = dma_map_single(lp->device, skb->data, length, DMA_TO_DEVICE);
-	if (!laddr) {
+	if (dma_mapping_error(lp->device, laddr))
 		pr_err_ratelimited("%s: failed to map tx DMA buffer.\n", dev->name);
 		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
@@ -509,7 +509,7 @@ static bool sonic_alloc_rb(struct net_device *dev, struct sonic_local *lp,
 
 	*new_addr = dma_map_single(lp->device, skb_put(*new_skb, SONIC_RBSIZE),
 				   SONIC_RBSIZE, DMA_FROM_DEVICE);
-	if (!*new_addr) {
+	if (dma_mapping_error(lp->device, *new_addr)) {
 		dev_kfree_skb(*new_skb);
 		*new_skb = NULL;
 		return false;
-- 
2.9.5

