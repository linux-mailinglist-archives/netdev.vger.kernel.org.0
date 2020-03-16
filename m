Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 905FB186516
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 07:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbgCPGhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 02:37:14 -0400
Received: from mail.wangsu.com ([123.103.51.198]:36523 "EHLO wangsu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729455AbgCPGhN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 02:37:13 -0400
Received: from 137.localdomain (unknown [218.107.205.216])
        by app1 (Coremail) with SMTP id xjNnewDn7Q1cHm9ew20FAA--.217S7;
        Mon, 16 Mar 2020 14:36:28 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     edumazet@google.com, ncardwell@google.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH RESEND net-next v2 5/5] tcp: fix stretch ACK bugs in Yeah
Date:   Mon, 16 Mar 2020 14:35:11 +0800
Message-Id: <1584340511-9870-6-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584340511-9870-1-git-send-email-yangpc@wangsu.com>
References: <1584340511-9870-1-git-send-email-yangpc@wangsu.com>
X-CM-TRANSID: xjNnewDn7Q1cHm9ew20FAA--.217S7
X-Coremail-Antispam: 1UD129KBjvJXoWxAw4UKw1ruw1DKw43AFW7twb_yoW5Ww1xpa
        s3C34a9F4UXFyIgFySy398Ar17G393KFy7G3yUG3s3Aw4q9F13ZF1qq3yjyry7G3yIk34a
        yr40vw17JF92kFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUgI1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l8cAvFVAK
        0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4
        x0Y4vE2Ix0cI8IcVCY1x0267AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28E
        F7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F4
        0EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1sIEY20_Gr4lOx8S6xCaFVCjc4AY6r1j6r4U
        M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_GF1l42
        xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VW8GwCFx2IqxVCFs4IE7xkEbVWUJVW8
        JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1V
        AFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xII
        jxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4
        A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU
        0xZFpf9x0Jj2-eOUUUUU=
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change Yeah to properly handle stretch ACKs in additive
increase mode by passing in the count of ACKed packets
to tcp_cong_avoid_ai().

In addition, we re-implemented the scalable path using
tcp_cong_avoid_ai() and removed the pkts_acked variable.

Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
---
 net/ipv4/tcp_yeah.c | 41 +++++++++++------------------------------
 1 file changed, 11 insertions(+), 30 deletions(-)

diff --git a/net/ipv4/tcp_yeah.c b/net/ipv4/tcp_yeah.c
index e00570d..3bb4487 100644
--- a/net/ipv4/tcp_yeah.c
+++ b/net/ipv4/tcp_yeah.c
@@ -36,8 +36,6 @@ struct yeah {
 
 	u32 reno_count;
 	u32 fast_count;
-
-	u32 pkts_acked;
 };
 
 static void tcp_yeah_init(struct sock *sk)
@@ -57,18 +55,6 @@ static void tcp_yeah_init(struct sock *sk)
 	tp->snd_cwnd_clamp = min_t(u32, tp->snd_cwnd_clamp, 0xffffffff/128);
 }
 
-static void tcp_yeah_pkts_acked(struct sock *sk,
-				const struct ack_sample *sample)
-{
-	const struct inet_connection_sock *icsk = inet_csk(sk);
-	struct yeah *yeah = inet_csk_ca(sk);
-
-	if (icsk->icsk_ca_state == TCP_CA_Open)
-		yeah->pkts_acked = sample->pkts_acked;
-
-	tcp_vegas_pkts_acked(sk, sample);
-}
-
 static void tcp_yeah_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -77,24 +63,19 @@ static void tcp_yeah_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 	if (!tcp_is_cwnd_limited(sk))
 		return;
 
-	if (tcp_in_slow_start(tp))
-		tcp_slow_start(tp, acked);
+	if (tcp_in_slow_start(tp)) {
+		acked = tcp_slow_start(tp, acked);
+		if (!acked)
+			goto do_vegas;
+	}
 
-	else if (!yeah->doing_reno_now) {
+	if (!yeah->doing_reno_now) {
 		/* Scalable */
-
-		tp->snd_cwnd_cnt += yeah->pkts_acked;
-		if (tp->snd_cwnd_cnt > min(tp->snd_cwnd, TCP_SCALABLE_AI_CNT)) {
-			if (tp->snd_cwnd < tp->snd_cwnd_clamp)
-				tp->snd_cwnd++;
-			tp->snd_cwnd_cnt = 0;
-		}
-
-		yeah->pkts_acked = 1;
-
+		tcp_cong_avoid_ai(tp, min(tp->snd_cwnd, TCP_SCALABLE_AI_CNT),
+				  acked);
 	} else {
 		/* Reno */
-		tcp_cong_avoid_ai(tp, tp->snd_cwnd, 1);
+		tcp_cong_avoid_ai(tp, tp->snd_cwnd, acked);
 	}
 
 	/* The key players are v_vegas.beg_snd_una and v_beg_snd_nxt.
@@ -118,7 +99,7 @@ static void tcp_yeah_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 	 * of bytes we send in an RTT is often less than our cwnd will allow.
 	 * So we keep track of our cwnd separately, in v_beg_snd_cwnd.
 	 */
-
+do_vegas:
 	if (after(ack, yeah->vegas.beg_snd_nxt)) {
 		/* We do the Vegas calculations only if we got enough RTT
 		 * samples that we can be reasonably sure that we got
@@ -232,7 +213,7 @@ static u32 tcp_yeah_ssthresh(struct sock *sk)
 	.set_state	= tcp_vegas_state,
 	.cwnd_event	= tcp_vegas_cwnd_event,
 	.get_info	= tcp_vegas_get_info,
-	.pkts_acked	= tcp_yeah_pkts_acked,
+	.pkts_acked	= tcp_vegas_pkts_acked,
 
 	.owner		= THIS_MODULE,
 	.name		= "yeah",
-- 
1.8.3.1

