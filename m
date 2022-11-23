Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1737634C53
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 02:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235567AbiKWBKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 20:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235535AbiKWBJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 20:09:54 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095FCDEAE2
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 17:09:51 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NH31P51KMzHv2R;
        Wed, 23 Nov 2022 09:09:13 +0800 (CST)
Received: from huawei.com (10.175.101.6) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 23 Nov
 2022 09:09:49 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <joyce.ooi@intel.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <maxime.chevallier@bootlin.com>,
        <netdev@vger.kernel.org>
CC:     <liujian56@huawei.com>
Subject: [PATCH net] net: altera_tse: release phylink resources in tse_shutdown()
Date:   Wed, 23 Nov 2022 09:16:17 +0800
Message-ID: <20221123011617.332302-1-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
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

Call phylink_disconnect_phy() in tse_shutdown() to release the
resources occupied by phylink_of_phy_connect() in the tse_open().

Fixes: fef2998203e1 ("net: altera: tse: convert to phylink")
Signed-off-by: Liu Jian <liujian56@huawei.com>
---
Compile tested only.
 drivers/net/ethernet/altera/altera_tse_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 7633b227b2ca..711d5b5a4c49 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -990,6 +990,7 @@ static int tse_shutdown(struct net_device *dev)
 	int ret;
 
 	phylink_stop(priv->phylink);
+	phylink_disconnect_phy(priv->phylink);
 	netif_stop_queue(dev);
 	napi_disable(&priv->napi);
 
-- 
2.17.1

