Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4030B184D8F
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 18:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgCMRZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 13:25:33 -0400
Received: from mail.wangsu.com ([123.103.51.227]:44054 "EHLO wangsu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726414AbgCMRZd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 13:25:33 -0400
Received: from 137.localdomain (unknown [218.107.205.216])
        by app2 (Coremail) with SMTP id 4zNnewDnSNZEuWtesuYaAA--.224S2;
        Sat, 14 Mar 2020 00:48:05 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     edumazet@google.com, davem@davemloft.net, ncardwell@google.com
Cc:     netdev@vger.kernel.org, Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH net-next 1/5] tcp: fix stretch ACK bugs in BIC
Date:   Sat, 14 Mar 2020 00:47:20 +0800
Message-Id: <1584118044-9798-1-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: 4zNnewDnSNZEuWtesuYaAA--.224S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKr4kKFy8Kw43Wr4fWr45Jrb_yoWDuwb_Z3
        WxKasrCry8XrZ5ZFZF9r18Ar18Ka93uF45XF13J3yrJw18tFyUJw4kKFn5ur1vgF409Fy7
        Wr9rJFWYva43XjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbYAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kI
        II0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7
        xvwVC0I7IYx2IY6xkF7I0E14v26F4UJVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28E
        F7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F4
        0EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1sIEY20_Gr4lOx8S6xCaFVCjc4AY6r1j6r4U
        M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_JwCF04
        k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r48MxC20s026xCaFVCjc4AY6r1j6r4U
        MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67
        AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0
        cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcV
        C2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73
        UjIFyTuYvjfU2iL0UUUUU
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Neal Cardwell submits a series of patches to handle stretched ACKs,
which start with commit e73ebb0881ea ("tcp: stretch ACK fixes prep").

This patch changes BIC to properly handle stretch ACKs in additive
increase mode by passing in the count of ACKed packets to
tcp_cong_avoid_ai().

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

