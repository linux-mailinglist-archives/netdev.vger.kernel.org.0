Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD02645572
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 09:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiLGIcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 03:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiLGIce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 03:32:34 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7E632048;
        Wed,  7 Dec 2022 00:32:31 -0800 (PST)
Received: from dggpeml500006.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NRr9R1QTSzRpqN;
        Wed,  7 Dec 2022 16:31:39 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 7 Dec 2022 16:32:29 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: stmmac: selftests: fix potential memleak in stmmac_test_arpoffload()
Date:   Wed, 7 Dec 2022 16:31:59 +0800
Message-ID: <1670401920-7574-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The skb allocated by stmmac_test_get_arp_skb() hasn't been released in
some error handling case, which will lead to a memory leak. Fix this up
by adding kfree_skb() to release skb.

Compile tested only.

Fixes: 5e3fb0a6e2b3 ("net: stmmac: selftests: Implement the ARP Offload test")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 49af7e7..687f43c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -1654,12 +1654,16 @@ static int stmmac_test_arpoffload(struct stmmac_priv *priv)
 	}
 
 	ret = stmmac_set_arp_offload(priv, priv->hw, true, ip_addr);
-	if (ret)
+	if (ret) {
+		kfree_skb(skb);
 		goto cleanup;
+	}
 
 	ret = dev_set_promiscuity(priv->dev, 1);
-	if (ret)
+	if (ret) {
+		kfree_skb(skb);
 		goto cleanup;
+	}
 
 	ret = dev_direct_xmit(skb, 0);
 	if (ret)
-- 
2.9.5

