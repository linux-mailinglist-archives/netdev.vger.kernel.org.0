Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04FE2351268
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 11:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbhDAJgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 05:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233604AbhDAJgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 05:36:02 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D6E91C0613E6;
        Thu,  1 Apr 2021 02:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=EYOcBt0qa2
        2f/es4WCfEIreakVBwSYplcjTg4orpzdk=; b=ABnt6bZmWeDZmCL39f1Tkh/GLN
        AztCI/Hx/V7PUjv/MYT/MaxpOIjnYZ5IrP2OrMY44YitqFYEhwYXk8sOCK3VMyOB
        zR8C//vk/TVYimmO34nFZervE/02niA4xwA/Y6rMzTtCeSsFUuj86AdJmEsS1Tp5
        mpyZFomgbEp/UfC1w=
Received: from ubuntu.localdomain (unknown [202.38.69.14])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygBXX3_0k2VgApOAAA--.164S4;
        Thu, 01 Apr 2021 17:35:48 +0800 (CST)
From:   Lv Yunlong <lyl2019@mail.ustc.edu.cn>
To:     dhowells@redhat.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Subject: [PATCH] net/rxrpc: Fix a use after free in rxrpc_input_packet
Date:   Thu,  1 Apr 2021 02:35:45 -0700
Message-Id: <20210401093545.4055-1-lyl2019@mail.ustc.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LkAmygBXX3_0k2VgApOAAA--.164S4
X-Coremail-Antispam: 1UD129KBjvdXoWrur1kXF15uryDJF47ZF4DCFg_yoWkWrX_Ar
        yIyFykG3WUGFs0krnrAF4FywnrGrZ7Wry8Xr1fKrZIy3y8Jw48Zw4vkr43GryUKF48Ww1D
        XFWFgw1UCw1kujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbskFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
        YxC7MxkIecxEwVAFwVW8uwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8Jw
        C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
        wI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjx
        v20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2
        z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73Uj
        IFyTuYvjfUe2-nDUUUU
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the case RXRPC_PACKET_TYPE_DATA of rxrpc_input_packet, if
skb_unshare(skb,..) failed, it will free the skb and return NULL.
But if skb_unshare() return NULL, the freed skb will be used by
rxrpc_eaten_skb(skb,..).

I see that rxrpc_eaten_skb() is used to drop a ref of skb. As the skb
is already freed in skb_unshare() on error, my patch removes the
rxrpc_eaten_skb() to avoid the uaf.

Fixes: d0d5c0cd1e711 ("rxrpc: Use skb_unshare() rather than skb_cow_data()")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
---
 net/rxrpc/input.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index dc201363f2c4..9ba408064465 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -1281,10 +1281,8 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 		 */
 		if (sp->hdr.securityIndex != 0) {
 			struct sk_buff *nskb = skb_unshare(skb, GFP_ATOMIC);
-			if (!nskb) {
-				rxrpc_eaten_skb(skb, rxrpc_skb_unshared_nomem);
+			if (!nskb)
 				goto out;
-			}
 
 			if (nskb != skb) {
 				rxrpc_eaten_skb(skb, rxrpc_skb_received);
-- 
2.25.1


