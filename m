Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B984C9809
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 22:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238631AbiCAVyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 16:54:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238609AbiCAVy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 16:54:28 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D8D898B6CF;
        Tue,  1 Mar 2022 13:53:46 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id B8B80625FB;
        Tue,  1 Mar 2022 22:52:18 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 7/8] netfilter: nf_queue: handle socket prefetch
Date:   Tue,  1 Mar 2022 22:53:36 +0100
Message-Id: <20220301215337.378405-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220301215337.378405-1-pablo@netfilter.org>
References: <20220301215337.378405-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

In case someone combines bpf socket assign and nf_queue, then we will
queue an skb who references a struct sock that did not have its
reference count incremented.

As we leave rcu protection, there is no guarantee that skb->sk is still
valid.

For refcount-less skb->sk case, try to increment the reference count
and then override the destructor.

In case of failure we have two choices: orphan the skb and 'delete'
preselect or let nf_queue() drop the packet.

Do the latter, it should not happen during normal operation.

Fixes: cf7fbe660f2d ("bpf: Add socket assign support")
Acked-by: Joe Stringer <joe@cilium.io>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_queue.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index e39549c55945..63d1516816b1 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -180,6 +180,18 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 		break;
 	}
 
+	if (skb_sk_is_prefetched(skb)) {
+		struct sock *sk = skb->sk;
+
+		if (!sk_is_refcounted(sk)) {
+			if (!refcount_inc_not_zero(&sk->sk_refcnt))
+				return -ENOTCONN;
+
+			/* drop refcount on skb_orphan */
+			skb->destructor = sock_edemux;
+		}
+	}
+
 	entry = kmalloc(sizeof(*entry) + route_key_size, GFP_ATOMIC);
 	if (!entry)
 		return -ENOMEM;
-- 
2.30.2

