Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55DEB56FF15
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 12:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiGKKhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 06:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiGKKhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 06:37:31 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8021ADE9EB
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 02:47:27 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.218:32834.1039489391
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-36.111.140.9 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id E9C392800C3;
        Mon, 11 Jul 2022 17:47:23 +0800 (CST)
X-189-SAVE-TO-SEND: +liyonglong@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id b54b0f5c2c2447d082cda67d2a5991fb for netdev@vger.kernel.org;
        Mon, 11 Jul 2022 17:47:25 CST
X-Transaction-ID: b54b0f5c2c2447d082cda67d2a5991fb
X-Real-From: liyonglong@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: liyonglong@chinatelecom.cn
From:   Yonglong Li <liyonglong@chinatelecom.cn>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, liyonglong@chinatelecom.cn
Subject: [PATCH v4] tcp: make retransmitted SKB fit into the send window
Date:   Mon, 11 Jul 2022 17:47:18 +0800
Message-Id: <1657532838-20200-1-git-send-email-liyonglong@chinatelecom.cn>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

current code of __tcp_retransmit_skb only check TCP_SKB_CB(skb)->seq
in send window, and TCP_SKB_CB(skb)->seq_end maybe out of send window.
If receiver has shrunk his window, and skb is out of new window,  it
should retransmit a smaller portion of the payload.

test packetdrill script:
    0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
   +0 fcntl(3, F_GETFL) = 0x2 (flags O_RDWR)
   +0 fcntl(3, F_SETFL, O_RDWR|O_NONBLOCK) = 0

   +0 connect(3, ..., ...) = -1 EINPROGRESS (Operation now in progress)
   +0 > S 0:0(0)  win 65535 <mss 1460,sackOK,TS val 100 ecr 0,nop,wscale 8>
 +.05 < S. 0:0(0) ack 1 win 6000 <mss 1000,nop,nop,sackOK>
   +0 > . 1:1(0) ack 1

   +0 write(3, ..., 10000) = 10000

   +0 > . 1:2001(2000) ack 1 win 65535
   +0 > . 2001:4001(2000) ack 1 win 65535
   +0 > . 4001:6001(2000) ack 1 win 65535

 +.05 < . 1:1(0) ack 4001 win 1001

and tcpdump show:
192.168.226.67.55 > 192.0.2.1.8080: Flags [.], seq 1:2001, ack 1, win 65535, length 2000
192.168.226.67.55 > 192.0.2.1.8080: Flags [.], seq 2001:4001, ack 1, win 65535, length 2000
192.168.226.67.55 > 192.0.2.1.8080: Flags [P.], seq 4001:5001, ack 1, win 65535, length 1000
192.168.226.67.55 > 192.0.2.1.8080: Flags [.], seq 5001:6001, ack 1, win 65535, length 1000
192.0.2.1.8080 > 192.168.226.67.55: Flags [.], ack 4001, win 1001, length 0
192.168.226.67.55 > 192.0.2.1.8080: Flags [.], seq 5001:6001, ack 1, win 65535, length 1000
192.168.226.67.55 > 192.0.2.1.8080: Flags [P.], seq 4001:5001, ack 1, win 65535, length 1000

when cient retract window to 1001, send window is [4001,5002],
but TLP send 5001-6001 packet which is out of send window.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
---
 net/ipv4/tcp_output.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 18c913a..d1ca3df 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3144,7 +3144,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 	struct tcp_sock *tp = tcp_sk(sk);
 	unsigned int cur_mss;
 	int diff, len, err;
-
+	int avail_wnd;
 
 	/* Inconclusive MTU probe */
 	if (icsk->icsk_mtup.probe_size)
@@ -3166,17 +3166,25 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 		return -EHOSTUNREACH; /* Routing failure or similar. */
 
 	cur_mss = tcp_current_mss(sk);
+	avail_wnd = tcp_wnd_end(tp) - TCP_SKB_CB(skb)->seq;
 
 	/* If receiver has shrunk his window, and skb is out of
 	 * new window, do not retransmit it. The exception is the
 	 * case, when window is shrunk to zero. In this case
-	 * our retransmit serves as a zero window probe.
+	 * our retransmit of one segment serves as a zero window probe.
 	 */
-	if (!before(TCP_SKB_CB(skb)->seq, tcp_wnd_end(tp)) &&
-	    TCP_SKB_CB(skb)->seq != tp->snd_una)
-		return -EAGAIN;
+	if (avail_wnd <= 0) {
+		if (TCP_SKB_CB(skb)->seq != tp->snd_una)
+			return -EAGAIN;
+		avail_wnd = cur_mss;
+	}
 
 	len = cur_mss * segs;
+	if (len > avail_wnd) {
+		len = rounddown(avail_wnd, cur_mss);
+		if (!len)
+			len = avail_wnd;
+	}
 	if (skb->len > len) {
 		if (tcp_fragment(sk, TCP_FRAG_IN_RTX_QUEUE, skb, len,
 				 cur_mss, GFP_ATOMIC))
@@ -3190,8 +3198,9 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 		diff -= tcp_skb_pcount(skb);
 		if (diff)
 			tcp_adjust_pcount(sk, skb, diff);
-		if (skb->len < cur_mss)
-			tcp_retrans_try_collapse(sk, skb, cur_mss);
+		avail_wnd = min_t(int, avail_wnd, cur_mss);
+		if (skb->len < avail_wnd)
+			tcp_retrans_try_collapse(sk, skb, avail_wnd);
 	}
 
 	/* RFC3168, section 6.1.1.1. ECN fallback */
-- 
1.8.3.1

