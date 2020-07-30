Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8A32330AC
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 13:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729171AbgG3LAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 07:00:09 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8303 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726631AbgG3LAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 07:00:09 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id AAF5379B622294EE9634;
        Thu, 30 Jul 2020 19:00:06 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 30 Jul 2020
 18:59:58 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@mellanox.com>,
        <edumazet@google.com>, <ap420073@gmail.com>,
        <xiyou.wangcong@gmail.com>, <lukas@wunner.de>,
        <maximmi@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: Pass NULL to skb_network_protocol() when we don't care about vlan depth
Date:   Thu, 30 Jul 2020 19:02:36 +0800
Message-ID: <1596106956-22054-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

When we don't care about vlan depth, we could pass NULL instead of the
address of a unused local variable to skb_network_protocol() as a param.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/core/dev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 7a774ebf64e2..474da11d18c9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3448,10 +3448,9 @@ static netdev_features_t net_mpls_features(struct sk_buff *skb,
 static netdev_features_t harmonize_features(struct sk_buff *skb,
 	netdev_features_t features)
 {
-	int tmp;
 	__be16 type;
 
-	type = skb_network_protocol(skb, &tmp);
+	type = skb_network_protocol(skb, NULL);
 	features = net_mpls_features(skb, features, type);
 
 	if (skb->ip_summed != CHECKSUM_NONE &&
-- 
2.19.1

