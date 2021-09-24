Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47BBD416A60
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 05:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244010AbhIXDUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 23:20:41 -0400
Received: from smtp21.cstnet.cn ([159.226.251.21]:37644 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231680AbhIXDUl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 23:20:41 -0400
Received: from localhost.localdomain (unknown [124.16.138.128])
        by APP-01 (Coremail) with SMTP id qwCowACnrQmRQ01hNyXQAA--.62110S2;
        Fri, 24 Sep 2021 11:18:41 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     dhowells@redhat.com, marc.dionne@auristor.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH 3/3] rxrpc: Fix _usecs_to_jiffies() by using usecs_to_jiffies()
Date:   Fri, 24 Sep 2021 03:18:37 +0000
Message-Id: <1632453517-782538-1-git-send-email-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: qwCowACnrQmRQ01hNyXQAA--.62110S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtr1xtr43Gr4xWr4DZFyrZwb_yoWfZFb_ZF
        WkJF17WayayFZ3uF42yr4rA3s8ury3uryFvr1SkFZrK3yY9rySy3y7WFn5Gr1YgrW2qFnx
        ua1jva4xKr1fujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbcAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
        1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
        6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
        0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8
        GwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
        1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij
        64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr
        0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
        IxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUnQ6pDUUUU
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

Fixes: c410bf01933e ("Fix the excessive initial retransmission timeout")
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

