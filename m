Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974731BD973
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 12:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgD2KVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 06:21:12 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3340 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726596AbgD2KVL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 06:21:11 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 583123BD2DB797C565C6;
        Wed, 29 Apr 2020 18:21:09 +0800 (CST)
Received: from localhost (10.173.251.152) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Wed, 29 Apr 2020
 18:21:00 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <jerry.lilijun@huawei.com>,
        <xudingke@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next] netpoll: Fix use correct return type for ndo_start_xmit()
Date:   Wed, 29 Apr 2020 18:20:58 +0800
Message-ID: <1588155658-26000-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.251.152]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

The method ndo_start_xmit() returns a value of type netdev_tx_t. Fix
the ndo function to use the correct type.

Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 net/core/netpoll.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 849380a..15b366a 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -69,10 +69,11 @@
 #define np_notice(np, fmt, ...)				\
 	pr_notice("%s: " fmt, np->name, ##__VA_ARGS__)
 
-static int netpoll_start_xmit(struct sk_buff *skb, struct net_device *dev,
-			      struct netdev_queue *txq)
+static netdev_tx_t netpoll_start_xmit(struct sk_buff *skb,
+				      struct net_device *dev,
+				      struct netdev_queue *txq)
 {
-	int status = NETDEV_TX_OK;
+	netdev_tx_t status = NETDEV_TX_OK;
 	netdev_features_t features;
 
 	features = netif_skb_features(skb);
@@ -307,7 +308,7 @@ static int netpoll_owner_active(struct net_device *dev)
 void netpoll_send_skb_on_dev(struct netpoll *np, struct sk_buff *skb,
 			     struct net_device *dev)
 {
-	int status = NETDEV_TX_BUSY;
+	netdev_tx_t status = NETDEV_TX_BUSY;
 	unsigned long tries;
 	/* It is up to the caller to keep npinfo alive. */
 	struct netpoll_info *npinfo;
-- 
1.8.3.1


