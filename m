Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38783140749
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 11:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgAQKD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 05:03:58 -0500
Received: from mail.wangsu.com ([123.103.51.198]:46433 "EHLO wangsu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726812AbgAQKD6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jan 2020 05:03:58 -0500
Received: from 137.localdomain (unknown [59.61.78.232])
        by app1 (Coremail) with SMTP id xjNnewAXMpqDhiFeeTcaAA--.1346S2;
        Fri, 17 Jan 2020 18:03:48 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     edumazet@google.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH] tcp: Use REXMIT_NEW instead of 2
Date:   Fri, 17 Jan 2020 18:03:45 +0800
Message-Id: <1579255425-29273-1-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: xjNnewAXMpqDhiFeeTcaAA--.1346S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Gw4rAry5ZFyxGrW8AFyrZwb_yoWxKrX_C3
        ykAaykCw48Zrs2yan8u3yYqr1SqayxuFs3ur1fJa47Aw1kJF4rJws5AryDXrs7uFs7JryD
        X3yqq34FvFy3ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kI
        II0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7
        xvwVC0I7IYx2IY6xkF7I0E14v26rxl6s0DM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84AC
        jcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrV
        ACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaVAv8VW8GwAv7VCY1x0262k0Y48FwI0_Jr0_
        Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2
        IErcIFxwCY02Avz4vE14v_Gw1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VW8
        GwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
        vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IY
        x2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26c
        xKx2IYs7xG6Fyj6rWUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
        14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JjxManUUUUU=
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use REXMIT_NEW instead of the confusing 2 in tcp_xmit_recovery()

Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 5347ab2..de07439 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3554,7 +3554,7 @@ static void tcp_xmit_recovery(struct sock *sk, int rexmit)
 	if (rexmit == REXMIT_NONE || sk->sk_state == TCP_SYN_SENT)
 		return;
 
-	if (unlikely(rexmit == 2)) {
+	if (unlikely(rexmit == REXMIT_NEW)) {
 		__tcp_push_pending_frames(sk, tcp_current_mss(sk),
 					  TCP_NAGLE_OFF);
 		if (after(tp->snd_nxt, tp->high_seq))
-- 
1.8.3.1

