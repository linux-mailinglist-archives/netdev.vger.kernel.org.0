Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73ADB32B3A3
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449863AbhCCEEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:04:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:34560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347712AbhCBRx4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 12:53:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A87560241;
        Tue,  2 Mar 2021 17:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614707581;
        bh=CBAxTd3TA3X/I6+8p2eK01UD+AyOeyEo5eUjrDBounE=;
        h=From:To:Cc:Subject:Date:From;
        b=NeHQve/uypViiPImgQGRQZj+Bqav8Lv6OQ8O+5VssqurUe6PmwSGx6ivOiL6y5Z2U
         ouA/qkYW0Z6Uq8kcw5PX2wC2B+z+U6srPsSofMtIsUN3aID9RhPX1GSXdyr+LYx1mi
         XTIC1Hk4VUFJFfw8/LTqh2ZFDHxgItQ5KI2lXfIbl+yKz+sijT3tpYF2oLlhAR9kLC
         rcg1r5tmuQ9olLA/VYR4nvZoUNCOQ1FinEYJHw3fE1py6S8Ye90jhKb/AV+GTHofpy
         Uf3pAPfytwyAOKBmhyMTnViGNKAuhF7ze42nmam7aXXl9E9Upupp0ooMh7sybOqU//
         +QRo/Ld//vcIQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>, Neil Spring <ntspring@fb.com>
Subject: [PATCH net-next v2] tcp: make TCP Fast Open retransmission ignore Tx status
Date:   Tue,  2 Mar 2021 09:52:59 -0800
Message-Id: <20210302175259.971778-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When receiver does not accept TCP Fast Open it will only ack
the SYN, and not the data. We detect this and immediately queue
the data for (re)transmission in tcp_rcv_fastopen_synack().

In DC networks with very low RTT and without RFS the SYN-ACK
may arrive before NIC driver reported Tx completion on
the original SYN. In which case skb_still_in_host_queue()
returns true and sender will need to wait for the retransmission
timer to fire milliseconds later.

Work around this issue by passing negative segment count to
__tcp_retransmit_skb() as suggested by Eric.

The condition triggers more often when Tx coalescing is configured
higher than Rx coalescing on the underlying NIC, but it does happen
even with relatively moderate and even settings (e.g. 33us).

Note that DC machines usually run configured to always accept
TCP FastOpen data so the problem may not be very common.

Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Neil Spring <ntspring@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv4/tcp_input.c  | 3 ++-
 net/ipv4/tcp_output.c | 8 ++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 69a545db80d2..fb453a4799be 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5994,8 +5994,9 @@ static bool tcp_rcv_fastopen_synack(struct sock *sk, struct sk_buff *synack,
 			tp->fastopen_client_fail = TFO_SYN_RETRANSMITTED;
 		else
 			tp->fastopen_client_fail = TFO_DATA_NOT_ACKED;
+		/* segs = -1 to bypass skb_still_in_host_queue() check */
 		skb_rbtree_walk_from(data) {
-			if (__tcp_retransmit_skb(sk, data, 1))
+			if (__tcp_retransmit_skb(sk, data, -1))
 				break;
 		}
 		tcp_rearm_rto(sk);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index fbf140a770d8..1d1489e59697 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3155,8 +3155,12 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 		  sk->sk_sndbuf))
 		return -EAGAIN;
 
-	if (skb_still_in_host_queue(sk, skb))
-		return -EBUSY;
+	if (segs > 0) {
+		if (skb_still_in_host_queue(sk, skb))
+			return -EBUSY;
+	} else {
+		segs = -segs;
+	}
 
 	if (before(TCP_SKB_CB(skb)->seq, tp->snd_una)) {
 		if (unlikely(before(TCP_SKB_CB(skb)->end_seq, tp->snd_una))) {
-- 
2.26.2

