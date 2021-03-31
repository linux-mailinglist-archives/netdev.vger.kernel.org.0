Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E825834FBB2
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 10:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbhCaIdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 04:33:20 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14972 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234197AbhCaIcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 04:32:50 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F9KJf4twnzwQDt;
        Wed, 31 Mar 2021 16:30:42 +0800 (CST)
Received: from huawei.com (10.175.103.91) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.498.0; Wed, 31 Mar 2021
 16:32:44 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>, <tipc-discussion@lists.sourceforge.net>
CC:     <davem@davemloft.net>
Subject: [PATCH -next] net/tipc: fix missing destroy_workqueue() on error in tipc_crypto_start()
Date:   Wed, 31 Mar 2021 16:36:02 +0800
Message-ID: <20210331083602.2089030-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missing destroy_workqueue() before return from
tipc_crypto_start() in the error handling case.

Fixes: 1ef6f7c9390f ("tipc: add automatic session key exchange")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 net/tipc/crypto.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 6f64acef73dc..76b8428c94a7 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -1492,6 +1492,8 @@ int tipc_crypto_start(struct tipc_crypto **crypto, struct net *net,
 	/* Allocate statistic structure */
 	c->stats = alloc_percpu_gfp(struct tipc_crypto_stats, GFP_ATOMIC);
 	if (!c->stats) {
+		if (c->wq)
+			destroy_workqueue(c->wq);
 		kfree_sensitive(c);
 		return -ENOMEM;
 	}
-- 
2.25.1

