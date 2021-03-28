Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D59434BB8A
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 09:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhC1HbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 03:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhC1HbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 03:31:02 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2775DC061762;
        Sun, 28 Mar 2021 00:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=ySo3LejcKx
        hpiNYrTW7rYd2XKHLRzJ0Dm1JJ/H0CViE=; b=Y0JTSslWLJr2ilr4o55nMybfXO
        JhLkgthVElLkm+N1ME4thTBB6koj5fCp4xS/lWSaTpJWZXOgXdjAEm3r6U2Cgp/J
        JX+6g0F70jHxM5ZbDR2EQ69ETOIFhSptPQQlRLBBpvJ1WZfx8QxtejsMESsRuXJM
        UIa06KPaqxrVabyVQ=
Received: from ubuntu.localdomain (unknown [202.38.69.14])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygBHT0uaMGBgV45cAA--.3225S4;
        Sun, 28 Mar 2021 15:30:34 +0800 (CST)
From:   Lv Yunlong <lyl2019@mail.ustc.edu.cn>
To:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Subject: [PATCH] net:tipc: Fix a double free in tipc_sk_mcast_rcv
Date:   Sun, 28 Mar 2021 00:30:29 -0700
Message-Id: <20210328073029.4325-1-lyl2019@mail.ustc.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LkAmygBHT0uaMGBgV45cAA--.3225S4
X-Coremail-Antispam: 1UD129KBjvJXoWxJrWxXFWDWrWrCr43JFyftFb_yoW8JFWxpF
        45Gr15GrZ7Jws09FyIqw40gr43C3yqkrsI9rW7Jr4kZrs0gw1Sqr409F4YgF45JrZ8CF4S
        qr1IqFs0qrWrZ37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvm14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
        rcIFxwCY02Avz4vE14v_GF4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
        1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
        14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
        IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvE
        x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnU
        UI43ZEXa7VUbVHq5UUUUU==
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the if(skb_peek(arrvq) == skb) branch, it calls __skb_dequeue(arrvq) to get
the skb by skb = skb_peek(arrvq). Then __skb_dequeue() unlinks the skb from arrvq
and returns the skb which equals to skb_peek(arrvq). After __skb_dequeue(arrvq)
finished, the skb is freed by kfree_skb(__skb_dequeue(arrvq)) in the first time.

Unfortunately, the same skb is freed in the second time by kfree_skb(skb) after
the branch completed.

My patch removes kfree_skb() in the if(skb_peek(arrvq) == skb) branch, because
this skb will be freed by kfree_skb(skb) finally.

Fixes: cb1b728096f54 ("tipc: eliminate race condition at multicast reception")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
---
 net/tipc/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index cebcc104dc70..022999e0202d 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1265,7 +1265,7 @@ void tipc_sk_mcast_rcv(struct net *net, struct sk_buff_head *arrvq,
 		spin_lock_bh(&inputq->lock);
 		if (skb_peek(arrvq) == skb) {
 			skb_queue_splice_tail_init(&tmpq, inputq);
-			kfree_skb(__skb_dequeue(arrvq));
+			__skb_dequeue(arrvq);
 		}
 		spin_unlock_bh(&inputq->lock);
 		__skb_queue_purge(&tmpq);
-- 
2.25.1


