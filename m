Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51659186515
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 07:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbgCPGgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 02:36:53 -0400
Received: from mail.wangsu.com ([123.103.51.198]:36314 "EHLO wangsu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728302AbgCPGgw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 02:36:52 -0400
Received: from 137.localdomain (unknown [218.107.205.216])
        by app1 (Coremail) with SMTP id xjNnewDn7Q1cHm9ew20FAA--.217S5;
        Mon, 16 Mar 2020 14:36:25 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     edumazet@google.com, ncardwell@google.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH RESEND net-next v2 3/5] tcp: stretch ACK fixes in Veno prep
Date:   Mon, 16 Mar 2020 14:35:09 +0800
Message-Id: <1584340511-9870-4-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584340511-9870-1-git-send-email-yangpc@wangsu.com>
References: <1584340511-9870-1-git-send-email-yangpc@wangsu.com>
X-CM-TRANSID: xjNnewDn7Q1cHm9ew20FAA--.217S5
X-Coremail-Antispam: 1UD129KBjvJXoW7uw1kAF13urWDGFyxKryrtFb_yoW8Ww47pa
        43Wrs3KF1aqFs7KrZxAFWUJw45G3Z7KayUJ3y7CF1fXw4avr1a9FyDXr4YvrWUGrWxt3Wa
        vr4Uur1fKFn7ArDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUgI1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l8cAvFVAK
        0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4
        x0Y4vE2Ix0cI8IcVCY1x0267AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28E
        F7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F4
        0EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1sIEY20_Gr4lOx8S6xCaFVCjc4AY6r1j6r4U
        M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_GF1l42
        xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VW8GwCFx2IqxVCFs4IE7xkEbVWUJVW8
        JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1V
        AFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xII
        jxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4
        A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU
        0xZFpf9x0Jj2-eOUUUUU=
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No code logic has been changed in this patch.

Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
---
 net/ipv4/tcp_veno.c | 44 +++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/net/ipv4/tcp_veno.c b/net/ipv4/tcp_veno.c
index 3b36bb1..857491c 100644
--- a/net/ipv4/tcp_veno.c
+++ b/net/ipv4/tcp_veno.c
@@ -153,31 +153,33 @@ static void tcp_veno_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 		veno->diff = (tp->snd_cwnd << V_PARAM_SHIFT) - target_cwnd;
 
 		if (tcp_in_slow_start(tp)) {
-			/* Slow start.  */
+			/* Slow start. */
 			tcp_slow_start(tp, acked);
+			goto done;
+		}
+
+		/* Congestion avoidance. */
+		if (veno->diff < beta) {
+			/* In the "non-congestive state", increase cwnd
+			 * every rtt.
+			 */
+			tcp_cong_avoid_ai(tp, tp->snd_cwnd, 1);
 		} else {
-			/* Congestion avoidance. */
-			if (veno->diff < beta) {
-				/* In the "non-congestive state", increase cwnd
-				 *  every rtt.
-				 */
-				tcp_cong_avoid_ai(tp, tp->snd_cwnd, 1);
-			} else {
-				/* In the "congestive state", increase cwnd
-				 * every other rtt.
-				 */
-				if (tp->snd_cwnd_cnt >= tp->snd_cwnd) {
-					if (veno->inc &&
-					    tp->snd_cwnd < tp->snd_cwnd_clamp) {
-						tp->snd_cwnd++;
-						veno->inc = 0;
-					} else
-						veno->inc = 1;
-					tp->snd_cwnd_cnt = 0;
+			/* In the "congestive state", increase cwnd
+			 * every other rtt.
+			 */
+			if (tp->snd_cwnd_cnt >= tp->snd_cwnd) {
+				if (veno->inc &&
+				    tp->snd_cwnd < tp->snd_cwnd_clamp) {
+					tp->snd_cwnd++;
+					veno->inc = 0;
 				} else
-					tp->snd_cwnd_cnt++;
-			}
+					veno->inc = 1;
+				tp->snd_cwnd_cnt = 0;
+			} else
+				tp->snd_cwnd_cnt++;
 		}
+done:
 		if (tp->snd_cwnd < 2)
 			tp->snd_cwnd = 2;
 		else if (tp->snd_cwnd > tp->snd_cwnd_clamp)
-- 
1.8.3.1

