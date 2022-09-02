Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA445AA95B
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 10:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235618AbiIBIDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 04:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235585AbiIBIDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 04:03:21 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC217B24A0
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 01:03:20 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MJr0m61LmzkWxF
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 15:59:36 +0800 (CST)
Received: from huawei.com (10.67.175.31) by dggpemm500024.china.huawei.com
 (7.185.36.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 2 Sep
 2022 16:03:18 +0800
From:   GUO Zihua <guozihua@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <wellslutw@gmail.com>
Subject: [PATCH] net: sunplus: Fix return type for implementation of
Date:   Fri, 2 Sep 2022 15:59:52 +0800
Message-ID: <20220902075952.54345-1-guozihua@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.31]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since Linux now supports CFI, it will be a good idea to fix mismatched
return type for implementation of hooks. Otherwise this might get
cought out by CFI and cause a panic.

spl2sw_ethernet_start_xmit() would return either NETDEV_TX_BUSY or
NETDEV_TX_OK, so change the return type to netdev_tx_t directly.

Signed-off-by: GUO Zihua <guozihua@huawei.com>
---
 drivers/net/ethernet/sunplus/spl2sw_driver.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sunplus/spl2sw_driver.c b/drivers/net/ethernet/sunplus/spl2sw_driver.c
index 546206640492..38e478aa415c 100644
--- a/drivers/net/ethernet/sunplus/spl2sw_driver.c
+++ b/drivers/net/ethernet/sunplus/spl2sw_driver.c
@@ -62,7 +62,8 @@ static int spl2sw_ethernet_stop(struct net_device *ndev)
 	return 0;
 }
 
-static int spl2sw_ethernet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t spl2sw_ethernet_start_xmit(struct sk_buff *skb,
+					      struct net_device *ndev)
 {
 	struct spl2sw_mac *mac = netdev_priv(ndev);
 	struct spl2sw_common *comm = mac->comm;
-- 
2.17.1

