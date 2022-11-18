Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B9F62F46E
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 13:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241749AbiKRMSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 07:18:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241837AbiKRMR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 07:17:58 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0376A976D6;
        Fri, 18 Nov 2022 04:17:53 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NDG0n0ZspzqSXF;
        Fri, 18 Nov 2022 20:14:01 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 20:17:51 +0800
Received: from localhost.localdomain (10.175.112.70) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 20:17:50 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "Alexander Duyck" <alexander.h.duyck@intel.com>
CC:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] fm10k: fix potential memleak in fm10k_xmit_frame()
Date:   Fri, 18 Nov 2022 20:37:27 +0800
Message-ID: <1668775048-22031-1-git-send-email-zhangchangzhong@huawei.com>
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

The fm10k_xmit_frame() returns NETDEV_TX_OK without freeing skb in error
handling case, add dev_kfree_skb() to fix it. Compile tested only.

Fixes: b101c9626477 ("fm10k: Add transmit and receive fastpath and interrupt handlers")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_netdev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index 2cca9e8..c7b672a 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -531,8 +531,10 @@ static netdev_tx_t fm10k_xmit_frame(struct sk_buff *skb, struct net_device *dev)
 			return NETDEV_TX_OK;
 
 		/* make sure there is enough room to move the ethernet header */
-		if (unlikely(!pskb_may_pull(skb, VLAN_ETH_HLEN)))
+		if (unlikely(!pskb_may_pull(skb, VLAN_ETH_HLEN))) {
+			dev_kfree_skb(skb);
 			return NETDEV_TX_OK;
+		}
 
 		/* verify the skb head is not shared */
 		err = skb_cow_head(skb, 0);
-- 
2.9.5

