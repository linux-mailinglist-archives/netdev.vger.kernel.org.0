Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C978062796F
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 10:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236222AbiKNJtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 04:49:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235995AbiKNJtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 04:49:02 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D395DDD6
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 01:49:00 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N9kyy3MGnzRpF3;
        Mon, 14 Nov 2022 17:48:42 +0800 (CST)
Received: from huawei.com (10.175.101.6) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 14 Nov
 2022 17:48:58 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <chris.snook@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <linux@rempel-privat.de>,
        <netdev@vger.kernel.org>
CC:     <liujian56@huawei.com>
Subject: [PATCH] net: ag71xx: call phylink_disconnect_phy if ag71xx_hw_enable() fail in ag71xx_open()
Date:   Mon, 14 Nov 2022 17:55:49 +0800
Message-ID: <20221114095549.40342-1-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If ag71xx_hw_enable() fails, call phylink_disconnect_phy() to clean up.
And if phylink_of_phy_connect() fails, nothing needs to be done.
Compile tested only.

Fixes: 892e09153fa3 ("net: ag71xx: port to phylink")
Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 drivers/net/ethernet/atheros/ag71xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index cc932b3cf873..4a1efe9b37d0 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1427,7 +1427,7 @@ static int ag71xx_open(struct net_device *ndev)
 	if (ret) {
 		netif_err(ag, link, ndev, "phylink_of_phy_connect filed with err: %i\n",
 			  ret);
-		goto err;
+		return ret;
 	}
 
 	max_frame_len = ag71xx_max_frame_len(ndev->mtu);
@@ -1448,6 +1448,7 @@ static int ag71xx_open(struct net_device *ndev)
 
 err:
 	ag71xx_rings_cleanup(ag);
+	phylink_disconnect_phy(ag->phylink);
 	return ret;
 }
 
-- 
2.17.1

