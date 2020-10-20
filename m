Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFA129435C
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 21:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438309AbgJTTlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 15:41:13 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:26662 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409246AbgJTTlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 15:41:12 -0400
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09KJf6Pt008195;
        Tue, 20 Oct 2020 12:41:06 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net] chelsio/chtls: fix tls record info to user
Date:   Wed, 21 Oct 2020 01:09:31 +0530
Message-Id: <20201020193930.12274-1-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tls record header is not getting updated correctly causing
application to close the connection in between data copy.
fixing it by finalizing current record whenever tls header
received.

Fixes: 17a7d24aa89d ("crypto: chtls - generic handling of data and hdr")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 .../net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c   | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
index 9fb5ca6682ea..a5dcc576ba3c 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
@@ -1585,6 +1585,7 @@ static int chtls_pt_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			tp->urg_data = 0;
 
 		if ((avail + offset) >= skb->len) {
+			struct sk_buff *next_skb;
 			if (ULP_SKB_CB(skb)->flags & ULPCB_FLAG_TLS_HDR) {
 				tp->copied_seq += skb->len;
 				hws->rcvpld = skb->hdr_len;
@@ -1595,9 +1596,12 @@ static int chtls_pt_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			chtls_free_skb(sk, skb);
 			buffers_freed++;
 			hws->copied_seq = 0;
-			if (copied >= target &&
-			    !skb_peek(&sk->sk_receive_queue))
+			next_skb = skb_peek(&sk->sk_receive_queue);
+			if (copied >= target && !next_skb)
 				break;
+			if (ULP_SKB_CB(next_skb)->flags & ULPCB_FLAG_TLS_HDR)
+				break;
+
 		}
 	} while (len > 0);
 
-- 
2.18.1

