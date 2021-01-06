Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F152EB8FD
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 05:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbhAFEbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 23:31:07 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:45285 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbhAFEbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 23:31:06 -0500
Received: from heptagon.blr.asicdesigners.com (uefi-pc.asicdesigners.com [10.193.186.108] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 1064TfXj022094;
        Tue, 5 Jan 2021 20:30:16 -0800
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net 7/7] chtls: Fix chtls resources release sequence
Date:   Wed,  6 Jan 2021 09:59:12 +0530
Message-Id: <20210106042912.23512-8-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.28.0.rc1.6.gae46588
In-Reply-To: <20210106042912.23512-1-ayush.sawal@chelsio.com>
References: <20210106042912.23512-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CPL_ABORT_RPL is sent after releasing the resources by calling
chtls_release_resources(sk); and chtls_conn_done(sk);
eventually causing kernel panic. Fixing it by calling release
in appropriate order.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 .../net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c   | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index 1c6d3c93a0c8..51dd030b3b36 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -2058,9 +2058,9 @@ static void bl_abort_syn_rcv(struct sock *lsk, struct sk_buff *skb)
 	queue = csk->txq_idx;
 
 	skb->sk	= NULL;
-	do_abort_syn_rcv(child, lsk);
 	chtls_send_abort_rpl(child, skb, BLOG_SKB_CB(skb)->cdev,
 			     CPL_ABORT_NO_RST, queue);
+	do_abort_syn_rcv(child, lsk);
 }
 
 static int abort_syn_rcv(struct sock *sk, struct sk_buff *skb)
@@ -2090,8 +2090,8 @@ static int abort_syn_rcv(struct sock *sk, struct sk_buff *skb)
 	if (!sock_owned_by_user(psk)) {
 		int queue = csk->txq_idx;
 
-		do_abort_syn_rcv(sk, psk);
 		chtls_send_abort_rpl(sk, skb, cdev, CPL_ABORT_NO_RST, queue);
+		do_abort_syn_rcv(sk, psk);
 	} else {
 		skb->sk = sk;
 		BLOG_SKB_CB(skb)->backlog_rcv = bl_abort_syn_rcv;
@@ -2135,12 +2135,12 @@ static void chtls_abort_req_rss(struct sock *sk, struct sk_buff *skb)
 		if (sk->sk_state == TCP_SYN_RECV && !abort_syn_rcv(sk, skb))
 			return;
 
-		chtls_release_resources(sk);
-		chtls_conn_done(sk);
 	}
 
 	chtls_send_abort_rpl(sk, skb, BLOG_SKB_CB(skb)->cdev,
 			     rst_status, queue);
+	chtls_release_resources(sk);
+	chtls_conn_done(sk);
 }
 
 static void chtls_abort_rpl_rss(struct sock *sk, struct sk_buff *skb)
-- 
2.28.0.rc1.6.gae46588

