Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE3E418D99
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 04:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbhI0CDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 22:03:54 -0400
Received: from smtp21.cstnet.cn ([159.226.251.21]:44610 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232420AbhI0CDw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 22:03:52 -0400
Received: from localhost.localdomain (unknown [124.16.138.128])
        by APP-01 (Coremail) with SMTP id qwCowAAXHAj4JVFhgmVmAQ--.12728S2;
        Mon, 27 Sep 2021 10:01:28 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     dhowells@redhat.com, marc.dionne@auristor.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: Re:[PATCH 3/3] rxrpc: Fix _usecs_to_jiffies() by using usecs_to_jiffies()
Date:   Mon, 27 Sep 2021 02:01:26 +0000
Message-Id: <1632708086-782867-1-git-send-email-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: qwCowAAXHAj4JVFhgmVmAQ--.12728S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtr1xtr43Gr4xWr4DZFyrZwb_yoWfZFg_ZF
        WkJ3W7WayayFZ3uF42yr4Fyr98Cry5uryFvr1SkFZrK3yY9rySy39FgFn5Gr1YgrW7WFnx
        ua1jva4xKr1fujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb4xFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
        1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_
        Gr1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
        WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
        7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
        1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8
        JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUHWlkUUU
        UU=
X-Originating-IP: [124.16.138.128]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Directly using _usecs_to_jiffies() might be unsafe, so it's
better to use usecs_to_jiffies() instead.
Because we can see that the result of _usecs_to_jiffies()
could be larger than MAX_JIFFY_OFFSET values without the
check of the input.

Fixes: c410bf01 ("rxrpc: Fix the excessive initial retransmission timeout")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 net/rxrpc/rtt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/rtt.c b/net/rxrpc/rtt.c
index 4e565ee..be61d6f 100644
--- a/net/rxrpc/rtt.c
+++ b/net/rxrpc/rtt.c
@@ -22,7 +22,7 @@ static u32 rxrpc_rto_min_us(struct rxrpc_peer *peer)
 
 static u32 __rxrpc_set_rto(const struct rxrpc_peer *peer)
 {
-	return _usecs_to_jiffies((peer->srtt_us >> 3) + peer->rttvar_us);
+	return usecs_to_jiffies((peer->srtt_us >> 3) + peer->rttvar_us);
 }
 
 static u32 rxrpc_bound_rto(u32 rto)
-- 
2.7.4

