Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9684186513
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 07:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbgCPGgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 02:36:50 -0400
Received: from mail.wangsu.com ([123.103.51.198]:36433 "EHLO wangsu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729582AbgCPGgt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 02:36:49 -0400
Received: from 137.localdomain (unknown [218.107.205.216])
        by app1 (Coremail) with SMTP id xjNnewDn7Q1cHm9ew20FAA--.217S3;
        Mon, 16 Mar 2020 14:36:20 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     edumazet@google.com, ncardwell@google.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH RESEND net-next v2 1/5] tcp: fix stretch ACK bugs in BIC
Date:   Mon, 16 Mar 2020 14:35:07 +0800
Message-Id: <1584340511-9870-2-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584340511-9870-1-git-send-email-yangpc@wangsu.com>
References: <1584340511-9870-1-git-send-email-yangpc@wangsu.com>
X-CM-TRANSID: xjNnewDn7Q1cHm9ew20FAA--.217S3
X-Coremail-Antispam: 1UD129KBjvdXoWrKrWkGF4DXr4rWF4xXF1DZFb_yoWfCrg_u3
        WxKa9rCry8XFs5ZrZF9ry8Ar18Ka93uFsaqF17Jayftr18tFyUJw4kGF95ur1vgF40gF9r
        Xr9rJFyYva47WjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbYxFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kI
        II0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7
        xvwVC0I7IYx2IY6xkF7I0E14v26rxl6s0DM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84AC
        jcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrV
        ACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaVAv8VW8GwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
        F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8AwCF04
        k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r48MxC20s026xCaFVCjc4AY6r1j6r4U
        MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67
        AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0
        cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_JFI_Gr1lIxAIcVC2z2
        80aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI
        43ZEXa7VU00PfPUUUUU==
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes BIC to properly handle stretch ACKs in additive
increase mode by passing in the count of ACKed packets
to tcp_cong_avoid_ai().

Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
---
 net/ipv4/tcp_bic.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_bic.c b/net/ipv4/tcp_bic.c
index 645cc30..f5f588b 100644
--- a/net/ipv4/tcp_bic.c
+++ b/net/ipv4/tcp_bic.c
@@ -145,12 +145,13 @@ static void bictcp_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 	if (!tcp_is_cwnd_limited(sk))
 		return;
 
-	if (tcp_in_slow_start(tp))
-		tcp_slow_start(tp, acked);
-	else {
-		bictcp_update(ca, tp->snd_cwnd);
-		tcp_cong_avoid_ai(tp, ca->cnt, 1);
+	if (tcp_in_slow_start(tp)) {
+		acked = tcp_slow_start(tp, acked);
+		if (!acked)
+			return;
 	}
+	bictcp_update(ca, tp->snd_cwnd);
+	tcp_cong_avoid_ai(tp, ca->cnt, acked);
 }
 
 /*
-- 
1.8.3.1

