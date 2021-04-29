Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C660A36E6F2
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 10:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239762AbhD2IRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 04:17:00 -0400
Received: from mail-m17640.qiye.163.com ([59.111.176.40]:34682 "EHLO
        mail-m17640.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbhD2IQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 04:16:57 -0400
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Apr 2021 04:16:56 EDT
Received: from ubuntu.localdomain (unknown [36.152.145.182])
        by mail-m17640.qiye.163.com (Hmail) with ESMTPA id 5512A5403B8;
        Thu, 29 Apr 2021 16:10:58 +0800 (CST)
From:   zhouchuangao <zhouchuangao@vivo.com>
To:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     zhouchuangao <zhouchuangao@vivo.com>
Subject: [PATCH] net/rxrpc: Use BUG_ON instead of if condition followed by BUG.
Date:   Thu, 29 Apr 2021 01:10:52 -0700
Message-Id: <1619683852-2247-1-git-send-email-zhouchuangao@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZGk4fHVYYTBpJGh9IHUxOSBpVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWUFZT0tIVUpKS0
        hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NT46Hio*Fz8XDkkjNg0DGC4s
        OC8KFEhVSlVKTUpCTUNIQ05DTE5DVTMWGhIXVQETFA4YEw4aFRwaFDsNEg0UVRgUFkVZV1kSC1lB
        WUhNVUpOSVVKT05VSkNJWVdZCAFZQUlOTE43Bg++
X-HM-Tid: 0a791cae5831d995kuws5512a5403b8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BUG_ON() uses unlikely in if(), which can be optimized at compile time.

              do { if (unlikely(condition)) BUG(); } while (0)

Through disassembly, we can see that brk #0x800 is compiled to the
end of the function.
As you can see below:
    ......
    ffffff8008660bec:   d65f03c0    ret
    ffffff8008660bf0:   d4210000    brk #0x800

Usually, the condition in if () is not satisfied. For the multi-stage
pipeline, we do not need to perform fetch decode and excute operation
on brk instruction.

IMO, this can improve the efficiency of the multi-stage pipeline.

Signed-off-by: zhouchuangao <zhouchuangao@vivo.com>
---
 net/rxrpc/call_object.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 4eb91d95..e5deb6f 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -505,8 +505,7 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 	ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
 
 	spin_lock_bh(&call->lock);
-	if (test_and_set_bit(RXRPC_CALL_RELEASED, &call->flags))
-		BUG();
+	BUG_ON(test_and_set_bit(RXRPC_CALL_RELEASED, &call->flags));
 	spin_unlock_bh(&call->lock);
 
 	rxrpc_put_call_slot(call);
@@ -636,8 +635,7 @@ static void rxrpc_rcu_destroy_call(struct rcu_head *rcu)
 
 	if (in_softirq()) {
 		INIT_WORK(&call->processor, rxrpc_destroy_call);
-		if (!rxrpc_queue_work(&call->processor))
-			BUG();
+		BUG_ON(!rxrpc_queue_work(&call->processor));
 	} else {
 		rxrpc_destroy_call(&call->processor);
 	}
-- 
2.7.4

