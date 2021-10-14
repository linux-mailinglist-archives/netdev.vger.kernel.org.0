Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC6C42CFF8
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 03:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbhJNBic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 21:38:32 -0400
Received: from smtp23.cstnet.cn ([159.226.251.23]:52224 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229496AbhJNBic (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 21:38:32 -0400
Received: from localhost.localdomain (unknown [124.16.138.128])
        by APP-03 (Coremail) with SMTP id rQCowAAnLqqBiWdhYA+BAw--.50977S2;
        Thu, 14 Oct 2021 09:36:01 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     dhowells@redhat.com, marc.dionne@auristor.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH RESEND] rxrpc: Fix _usecs_to_jiffies() by using usecs_to_jiffies()
Date:   Thu, 14 Oct 2021 01:35:59 +0000
Message-Id: <1634175359-1810410-1-git-send-email-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: rQCowAAnLqqBiWdhYA+BAw--.50977S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtr1xtr43Gr4xWr4DZFyrZwb_yoWfZFg_ZF
        WkJ3W7WayayFZ3uF42yr4Fyr98Cry5uryFvr1SkFZrK3yY9rySy39FgFn5Gr1YgrW7WFnx
        ua1jva4xKr1fujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbcxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
        jxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
        1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVWkMxAI
        w28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr
        4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxG
        rwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJw
        CI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
        cVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VU1ItC7UUUUU==
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

