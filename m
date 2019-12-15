Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3763011FB63
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 22:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfLOVIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 16:08:20 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:48739 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbfLOVIT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 16:08:19 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id b25e1eae;
        Sun, 15 Dec 2019 20:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=a8eskatTy4UVgwpkFMQBIMM69
        TA=; b=iiLaXx7hEQXXsZ4vFIkzbDRJ9zuaBNEbPDUAvm+PggaM+4mLyf+ZAfs2O
        8H76OxSJHcdcadRXMdfyBk3jd4NuETf2z8Wq0ws2c+ndqciESCcldoEckRxIO6qr
        5i88SuWMQl65D39nuFb5mP9f9TzLKoLEmphChdWanJXR2QLP4Sq62SKI8kiRV3DV
        gVUa55+dnHjdw8YXUjgQeIJYn8egeFOQ5wK+HSu8PtgD93yVZkjSjZbPR26EKw+2
        wSNzja7zq48eTiA2Jk4MAuXOloMnuTyeakOvx1bgT0rscfEOLuPZkl71EsB3ibwP
        rgo9S2BRGnxylKGPPTyntb8dgiaHQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d7bee12e (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Sun, 15 Dec 2019 20:12:03 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next 5/5] wireguard: allowedips: use kfree_rcu() instead of call_rcu()
Date:   Sun, 15 Dec 2019 22:08:04 +0100
Message-Id: <20191215210804.143919-6-Jason@zx2c4.com>
In-Reply-To: <20191215210804.143919-1-Jason@zx2c4.com>
References: <20191215210804.143919-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

The callback function of call_rcu() just calls a kfree(), so we
can use kfree_rcu() instead of call_rcu() + callback function.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/allowedips.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireguard/allowedips.c b/drivers/net/wireguard/allowedips.c
index 72667d5399c3..121d9ea0f135 100644
--- a/drivers/net/wireguard/allowedips.c
+++ b/drivers/net/wireguard/allowedips.c
@@ -31,11 +31,6 @@ static void copy_and_assign_cidr(struct allowedips_node *node, const u8 *src,
 #define CHOOSE_NODE(parent, key) \
 	parent->bit[(key[parent->bit_at_a] >> parent->bit_at_b) & 1]
 
-static void node_free_rcu(struct rcu_head *rcu)
-{
-	kfree(container_of(rcu, struct allowedips_node, rcu));
-}
-
 static void push_rcu(struct allowedips_node **stack,
 		     struct allowedips_node __rcu *p, unsigned int *len)
 {
@@ -112,7 +107,7 @@ static void walk_remove_by_peer(struct allowedips_node __rcu **top,
 				if (!node->bit[0] || !node->bit[1]) {
 					rcu_assign_pointer(*nptr, DEREF(
 					       &node->bit[!REF(node->bit[0])]));
-					call_rcu(&node->rcu, node_free_rcu);
+					kfree_rcu(node, rcu);
 					node = DEREF(nptr);
 				}
 			}
-- 
2.24.1

