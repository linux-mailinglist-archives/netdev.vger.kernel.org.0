Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284E633E7BB
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 04:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhCQDjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 23:39:01 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:50210 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229772AbhCQDiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 23:38:51 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R501e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0USDZp7x_1615952319;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0USDZp7x_1615952319)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 17 Mar 2021 11:38:45 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     dhowells@redhat.com
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] rxrpc: rxkad: replace if (cond) BUG() with BUG_ON()
Date:   Wed, 17 Mar 2021 11:38:38 +0800
Message-Id: <1615952318-4861-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

./net/rxrpc/rxkad.c:1140:2-5: WARNING: Use BUG_ON instead of if
condition followed by BUG.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 net/rxrpc/rxkad.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index e2e9e9b..bfa3d9a 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -1135,9 +1135,8 @@ static void rxkad_decrypt_response(struct rxrpc_connection *conn,
 	       ntohl(session_key->n[0]), ntohl(session_key->n[1]));
 
 	mutex_lock(&rxkad_ci_mutex);
-	if (crypto_sync_skcipher_setkey(rxkad_ci, session_key->x,
-					sizeof(*session_key)) < 0)
-		BUG();
+	BUG_ON(crypto_sync_skcipher_setkey(rxkad_ci, session_key->x,
+					sizeof(*session_key)) < 0);
 
 	memcpy(&iv, session_key, sizeof(iv));
 
-- 
1.8.3.1

