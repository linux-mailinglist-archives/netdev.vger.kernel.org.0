Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C962F5FA6
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 12:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbhANLRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 06:17:10 -0500
Received: from mail.wangsu.com ([123.103.51.198]:47499 "EHLO wangsu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726008AbhANLRJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 06:17:09 -0500
X-Greylist: delayed 1077 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jan 2021 06:17:08 EST
Received: from 101.localdomain (unknown [218.107.205.212])
        by app1 (Coremail) with SMTP id xjNnewC3orqtIwBggf8IAA--.2S2;
        Thu, 14 Jan 2021 18:57:49 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     edumazet@google.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH net] tcp: fix TCP_SKB_CB(skb)->tcp_tw_isn not being used
Date:   Tue, 29 Dec 2020 05:59:20 +0800
Message-Id: <1609192760-4505-1-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: xjNnewC3orqtIwBggf8IAA--.2S2
X-Coremail-Antispam: 1UD129KBjvJXoW3WFy3Aw18uw47JFW3Zw1kKrg_yoW7uryxp3
        ZrGw4fWrWkur9Yvw18ZF1qv3WSqrsYyryfur4kX3y3KFnxJFs5Ka95tFW2vr45GrZ3Aw12
        yFyYqw1fJr9rZ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyl1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l87I20VAv
        wVCjjxC26w4a6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2I
        x0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6rxdM28EF7xv
        wVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcx
        kEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaVAv8VW8
        GwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20V
        AGYxC7MxkIecxEwVAFwVW8twCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r48
        MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwV
        AFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv2
        0xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4
        v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
        67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUsyCJDUUUU
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TCP_SKB_CB(skb)->tcp_tw_isn contains an ISN, chosen by
tcp_timewait_state_process() , when SYN is received in TIMEWAIT state.
But tcp_tw_isn is not used because it is overwritten by
tcp_v4_restore_cb() after commit eeea10b83a13 ("tcp: add
tcp_v4_fill_cb()/tcp_v4_restore_cb()").

To fix this case, we record tcp_tw_isn before tcp_v4_restore_cb() and
then set it in tcp_v4_fill_cb(). V6 does the same.

Fixes: eeea10b83a13 ("tcp: add tcp_v4_fill_cb()/tcp_v4_restore_cb()")
Reported-by: chenc <chenc9@wangsu.com>
Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
---
 net/ipv4/tcp_ipv4.c | 14 ++++++++------
 net/ipv6/tcp_ipv6.c | 14 ++++++++------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 58207c7..c8cceaa 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1892,7 +1892,7 @@ static void tcp_v4_restore_cb(struct sk_buff *skb)
 }
 
 static void tcp_v4_fill_cb(struct sk_buff *skb, const struct iphdr *iph,
-			   const struct tcphdr *th)
+			   const struct tcphdr *th, __u32 isn)
 {
 	/* This is tricky : We move IPCB at its correct location into TCP_SKB_CB()
 	 * barrier() makes sure compiler wont play fool^Waliasing games.
@@ -1906,7 +1906,7 @@ static void tcp_v4_fill_cb(struct sk_buff *skb, const struct iphdr *iph,
 				    skb->len - th->doff * 4);
 	TCP_SKB_CB(skb)->ack_seq = ntohl(th->ack_seq);
 	TCP_SKB_CB(skb)->tcp_flags = tcp_flag_byte(th);
-	TCP_SKB_CB(skb)->tcp_tw_isn = 0;
+	TCP_SKB_CB(skb)->tcp_tw_isn = isn;
 	TCP_SKB_CB(skb)->ip_dsfield = ipv4_get_dsfield(iph);
 	TCP_SKB_CB(skb)->sacked	 = 0;
 	TCP_SKB_CB(skb)->has_rxtstamp =
@@ -1927,6 +1927,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	const struct tcphdr *th;
 	bool refcounted;
 	struct sock *sk;
+	__u32 isn = 0;
 	int ret;
 
 	if (skb->pkt_type != PACKET_HOST)
@@ -1993,7 +1994,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		if (!tcp_filter(sk, skb)) {
 			th = (const struct tcphdr *)skb->data;
 			iph = ip_hdr(skb);
-			tcp_v4_fill_cb(skb, iph, th);
+			tcp_v4_fill_cb(skb, iph, th, isn);
 			nsk = tcp_check_req(sk, skb, req, false, &req_stolen);
 		}
 		if (!nsk) {
@@ -2038,7 +2039,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		goto discard_and_relse;
 	th = (const struct tcphdr *)skb->data;
 	iph = ip_hdr(skb);
-	tcp_v4_fill_cb(skb, iph, th);
+	tcp_v4_fill_cb(skb, iph, th, isn);
 
 	skb->dev = NULL;
 
@@ -2075,7 +2076,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
 		goto discard_it;
 
-	tcp_v4_fill_cb(skb, iph, th);
+	tcp_v4_fill_cb(skb, iph, th, isn);
 
 	if (tcp_checksum_complete(skb)) {
 csum_error:
@@ -2103,7 +2104,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		goto discard_it;
 	}
 
-	tcp_v4_fill_cb(skb, iph, th);
+	tcp_v4_fill_cb(skb, iph, th, isn);
 
 	if (tcp_checksum_complete(skb)) {
 		inet_twsk_put(inet_twsk(sk));
@@ -2121,6 +2122,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		if (sk2) {
 			inet_twsk_deschedule_put(inet_twsk(sk));
 			sk = sk2;
+			isn = TCP_SKB_CB(skb)->tcp_tw_isn;
 			tcp_v4_restore_cb(skb);
 			refcounted = false;
 			goto process;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 0e1509b..a2ff19d 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1557,7 +1557,7 @@ static int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 }
 
 static void tcp_v6_fill_cb(struct sk_buff *skb, const struct ipv6hdr *hdr,
-			   const struct tcphdr *th)
+			   const struct tcphdr *th, __u32 isn)
 {
 	/* This is tricky: we move IP6CB at its correct location into
 	 * TCP_SKB_CB(). It must be done after xfrm6_policy_check(), because
@@ -1573,7 +1573,7 @@ static void tcp_v6_fill_cb(struct sk_buff *skb, const struct ipv6hdr *hdr,
 				    skb->len - th->doff*4);
 	TCP_SKB_CB(skb)->ack_seq = ntohl(th->ack_seq);
 	TCP_SKB_CB(skb)->tcp_flags = tcp_flag_byte(th);
-	TCP_SKB_CB(skb)->tcp_tw_isn = 0;
+	TCP_SKB_CB(skb)->tcp_tw_isn = isn;
 	TCP_SKB_CB(skb)->ip_dsfield = ipv6_get_dsfield(hdr);
 	TCP_SKB_CB(skb)->sacked = 0;
 	TCP_SKB_CB(skb)->has_rxtstamp =
@@ -1589,6 +1589,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	const struct ipv6hdr *hdr;
 	bool refcounted;
 	struct sock *sk;
+	__u32 isn = 0;
 	int ret;
 	struct net *net = dev_net(skb->dev);
 
@@ -1652,7 +1653,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		if (!tcp_filter(sk, skb)) {
 			th = (const struct tcphdr *)skb->data;
 			hdr = ipv6_hdr(skb);
-			tcp_v6_fill_cb(skb, hdr, th);
+			tcp_v6_fill_cb(skb, hdr, th, isn);
 			nsk = tcp_check_req(sk, skb, req, false, &req_stolen);
 		}
 		if (!nsk) {
@@ -1695,7 +1696,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		goto discard_and_relse;
 	th = (const struct tcphdr *)skb->data;
 	hdr = ipv6_hdr(skb);
-	tcp_v6_fill_cb(skb, hdr, th);
+	tcp_v6_fill_cb(skb, hdr, th, isn);
 
 	skb->dev = NULL;
 
@@ -1730,7 +1731,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb))
 		goto discard_it;
 
-	tcp_v6_fill_cb(skb, hdr, th);
+	tcp_v6_fill_cb(skb, hdr, th, isn);
 
 	if (tcp_checksum_complete(skb)) {
 csum_error:
@@ -1757,7 +1758,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		goto discard_it;
 	}
 
-	tcp_v6_fill_cb(skb, hdr, th);
+	tcp_v6_fill_cb(skb, hdr, th, isn);
 
 	if (tcp_checksum_complete(skb)) {
 		inet_twsk_put(inet_twsk(sk));
@@ -1780,6 +1781,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 			struct inet_timewait_sock *tw = inet_twsk(sk);
 			inet_twsk_deschedule_put(tw);
 			sk = sk2;
+			isn = TCP_SKB_CB(skb)->tcp_tw_isn;
 			tcp_v6_restore_cb(skb);
 			refcounted = false;
 			goto process;
-- 
1.8.3.1

