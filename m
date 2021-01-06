Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F59C2EB8FB
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 05:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbhAFEa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 23:30:57 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:54193 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbhAFEa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 23:30:56 -0500
Received: from heptagon.blr.asicdesigners.com (uefi-pc.asicdesigners.com [10.193.186.108] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 1064TfXh022094;
        Tue, 5 Jan 2021 20:30:06 -0800
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net 5/7] chtls: Replace skb_dequeue with skb_peek
Date:   Wed,  6 Jan 2021 09:59:10 +0530
Message-Id: <20210106042912.23512-6-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.28.0.rc1.6.gae46588
In-Reply-To: <20210106042912.23512-1-ayush.sawal@chelsio.com>
References: <20210106042912.23512-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The skb is unlinked twice, one in __skb_dequeue in function
chtls_reset_synq() and another in cleanup_syn_rcv_conn().
So in this patch using skb_peek() instead of __skb_dequeue(),
so that unlink will be handled only in cleanup_syn_rcv_conn().

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index 3022c802d09a..ff3969a24d74 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -621,7 +621,7 @@ static void chtls_reset_synq(struct listen_ctx *listen_ctx)
 
 	while (!skb_queue_empty(&listen_ctx->synq)) {
 		struct chtls_sock *csk =
-			container_of((struct synq *)__skb_dequeue
+			container_of((struct synq *)skb_peek
 				(&listen_ctx->synq), struct chtls_sock, synq);
 		struct sock *child = csk->sk;
 
-- 
2.28.0.rc1.6.gae46588

