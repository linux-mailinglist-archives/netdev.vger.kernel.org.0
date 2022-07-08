Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9626856B4F6
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 10:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237549AbiGHI7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 04:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237336AbiGHI7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 04:59:45 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD5DD2D1F5
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 01:59:43 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.218:49598.1989484613
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-36.111.140.9 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id D60FD2800DD;
        Fri,  8 Jul 2022 16:59:37 +0800 (CST)
X-189-SAVE-TO-SEND: +liyonglong@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id a24c4730ebcf4a289bcbb050184522d1 for netdev@vger.kernel.org;
        Fri, 08 Jul 2022 16:59:39 CST
X-Transaction-ID: a24c4730ebcf4a289bcbb050184522d1
X-Real-From: liyonglong@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: liyonglong@chinatelecom.cn
From:   Yonglong Li <liyonglong@chinatelecom.cn>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, liyonglong@chinatelecom.cn
Subject: [PATCH v2] tcp: make retransmitted SKB fit into the send window
Date:   Fri,  8 Jul 2022 16:59:34 +0800
Message-Id: <1657270774-39372-1-git-send-email-liyonglong@chinatelecom.cn>
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

From: lyl <liyonglong@chinatelecom.cn>

current code of __tcp_retransmit_skb only check TCP_SKB_CB(skb)->seq
in send window, and TCP_SKB_CB(skb)->seq_end maybe out of send window.
If receiver has shrunk his window, and skb is out of new window,  it
should not retransmit it.

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

Signed-off-by: liyonglong <liyonglong@chinatelecom.cn>
---
 net/ipv4/tcp_output.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 1c05443..7e1569e 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3176,7 +3176,12 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 	    TCP_SKB_CB(skb)->seq != tp->snd_una)
 		return -EAGAIN;
 
-	len = cur_mss * segs;
+	len = min_t(int, tcp_wnd_end(tp) - TCP_SKB_CB(skb)->seq, cur_mss * segs);
+
+	/* retransmit serves as a zero window probe. */
+	if (len == 0 && TCP_SKB_CB(skb)->seq == tp->snd_una)
+		len = cur_mss;
+
 	if (skb->len > len) {
 		if (tcp_fragment(sk, TCP_FRAG_IN_RTX_QUEUE, skb, len,
 				 cur_mss, GFP_ATOMIC))
-- 
1.8.3.1

