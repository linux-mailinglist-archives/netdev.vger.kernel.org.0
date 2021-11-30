Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5031D462ADF
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 04:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbhK3DJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 22:09:20 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:31924 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhK3DJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 22:09:19 -0500
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4J36YD6wRBzcbfR;
        Tue, 30 Nov 2021 11:05:52 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 30 Nov 2021 11:05:58 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Tue, 30 Nov
 2021 11:05:58 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <jk@codeconstruct.com.au>, <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH -next] mctp: remove unnecessary check before calling kfree_skb()
Date:   Tue, 30 Nov 2021 11:12:43 +0800
Message-ID: <20211130031243.768823-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The skb will be checked inside kfree_skb(), so remove the
outside check.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 net/mctp/af_mctp.c | 3 +--
 net/mctp/route.c   | 4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index 871cf6266125..c921de63b494 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -405,8 +405,7 @@ static void mctp_sk_unhash(struct sock *sk)
 		trace_mctp_key_release(key, MCTP_TRACE_KEY_CLOSED);
 
 		spin_lock(&key->lock);
-		if (key->reasm_head)
-			kfree_skb(key->reasm_head);
+		kfree_skb(key->reasm_head);
 		key->reasm_head = NULL;
 		key->reasm_dead = true;
 		key->valid = false;
diff --git a/net/mctp/route.c b/net/mctp/route.c
index 46c44823edb7..8d759b48f747 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -231,9 +231,7 @@ static void __mctp_key_unlock_drop(struct mctp_sk_key *key, struct net *net,
 	/* and one for the local reference */
 	mctp_key_unref(key);
 
-	if (skb)
-		kfree_skb(skb);
-
+	kfree_skb(skb);
 }
 
 #ifdef CONFIG_MCTP_FLOWS
-- 
2.25.1

