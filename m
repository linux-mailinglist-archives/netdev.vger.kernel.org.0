Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7AF75BC198
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 05:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiISDCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 23:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiISDCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 23:02:15 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0516119C16;
        Sun, 18 Sep 2022 20:02:13 -0700 (PDT)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MW8W32vZjz14QMk;
        Mon, 19 Sep 2022 10:58:07 +0800 (CST)
Received: from dggpeml500008.china.huawei.com (7.185.36.147) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 11:02:11 +0800
Received: from huawei.com (10.67.175.34) by dggpeml500008.china.huawei.com
 (7.185.36.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 19 Sep
 2022 11:02:10 +0800
From:   Ren Zhijie <renzhijie2@huawei.com>
To:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <sumang@marvell.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Ren Zhijie <renzhijie2@huawei.com>
Subject: [PATCH -next] octeontx2-pf: Fix unused variable build error
Date:   Mon, 19 Sep 2022 10:58:40 +0800
Message-ID: <20220919025840.256411-1-renzhijie2@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.175.34]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500008.china.huawei.com (7.185.36.147)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_DCB is not set,
make ARCH=x86_64 CROSS_COMPILE=x86_64-linux-gnu-,
will be failed, like this:

drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c: In function ‘otx2_select_queue’:
drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c:1886:19: error: unused variable ‘pf’ [-Werror=unused-variable]
  struct otx2_nic *pf = netdev_priv(netdev);
                   ^~
cc1: all warnings being treated as errors

To fix this build error, put the definition of *pf under the CONFIG_DCB.

Fixes: 99c969a83d82 ("octeontx2-pf: Add egress PFC support")
Signed-off-by: Ren Zhijie <renzhijie2@huawei.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 49a4ff01cecb..9f5cb213c6d7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1883,8 +1883,8 @@ static netdev_tx_t otx2_xmit(struct sk_buff *skb, struct net_device *netdev)
 static u16 otx2_select_queue(struct net_device *netdev, struct sk_buff *skb,
 			     struct net_device *sb_dev)
 {
-	struct otx2_nic *pf = netdev_priv(netdev);
 #ifdef CONFIG_DCB
+	struct otx2_nic *pf = netdev_priv(netdev);
 	u8 vlan_prio;
 #endif
 
-- 
2.17.1

