Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47EDA29651C
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 21:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369974AbgJVTOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 15:14:17 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:8994 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S369967AbgJVTOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 15:14:16 -0400
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09MJEBJY016514;
        Thu, 22 Oct 2020 12:14:12 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net] chelsio/chtls: fix memory leak
Date:   Fri, 23 Oct 2020 00:43:33 +0530
Message-Id: <20201022191332.21436-1-vinay.yadav@chelsio.com>
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
because resource is already cleaned for this connection,
fix it by not queuing work request while socket is closing

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
index f1820aca0d33..e37cbfc34dd3 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c
@@ -377,6 +377,9 @@ int chtls_setkey(struct chtls_sock *csk, u32 keylen,
 	kwr->sc_imm.len = cpu_to_be32(klen);
 
 	lock_sock(sk);
+	if (unlikely(csk_flag(sk, CSK_ABORT_SHUTDOWN)))
+		goto out_notcb;
+
 	/* key info */
 	kctx = (struct _key_ctx *)(kwr + 1);
 	ret = chtls_key_info(csk, kctx, keylen, optname, cipher_type);
-- 
2.18.1

