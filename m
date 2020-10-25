Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E61429836F
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 20:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418639AbgJYTun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 15:50:43 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:55430 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1418632AbgJYTum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Oct 2020 15:50:42 -0400
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09PJob34029594;
        Sun, 25 Oct 2020 12:50:38 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net,v2] chelsio/chtls: fix memory leaks
Date:   Mon, 26 Oct 2020 01:19:36 +0530
Message-Id: <20201025194935.31754-1-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct skb refcount in alloc_ctrl_skb(), causing skb memleak
when chtls_send_abort() called with NULL skb.
Also race between user context and softirq causing memleak,
consider the call sequence scenario

chtls_setkey()         //user context
chtls_peer_close()
chtls_abort_req_rss()
chtls_setkey()         //user context

work request skb queued in chtls_setkey() won't be freed
because resources are already cleaned for this connection,
fix it by not queuing work request while socket is closing.

v1->v2:
- fix W=1 warning.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c | 2 +-
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index 24154816d1d1..63aacc184f68 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -212,7 +212,7 @@ static struct sk_buff *alloc_ctrl_skb(struct sk_buff *skb, int len)
 {
 	if (likely(skb && !skb_shared(skb) && !skb_cloned(skb))) {
 		__skb_trim(skb, 0);
-		refcount_add(2, &skb->users);
+		refcount_inc(&skb->users);
 	} else {
 		skb = alloc_skb(len, GFP_KERNEL | __GFP_NOFAIL);
 	}
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c
index f1820aca0d33..62c829023da5 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c
@@ -383,6 +383,9 @@ int chtls_setkey(struct chtls_sock *csk, u32 keylen,
 	if (ret)
 		goto out_notcb;
 
+	if (unlikely(csk_flag(sk, CSK_ABORT_SHUTDOWN)))
+		goto out_notcb;
+
 	set_wr_txq(skb, CPL_PRIORITY_DATA, csk->tlshws.txqid);
 	csk->wr_credits -= DIV_ROUND_UP(len, 16);
 	csk->wr_unacked += DIV_ROUND_UP(len, 16);
-- 
2.18.1

