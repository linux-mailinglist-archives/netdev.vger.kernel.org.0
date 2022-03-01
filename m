Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF084C97FC
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 22:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238617AbiCAVy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 16:54:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiCAVy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 16:54:26 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 57F5F61A13;
        Tue,  1 Mar 2022 13:53:45 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8AD3F608F7;
        Tue,  1 Mar 2022 22:52:16 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/8] netfilter: egress: silence egress hook lockdep splats
Date:   Tue,  1 Mar 2022 22:53:32 +0100
Message-Id: <20220301215337.378405-4-pablo@netfilter.org>
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

Netfilter assumes its called with rcu_read_lock held, but in egress
hook case it may be called with BH readlock.

This triggers lockdep splat.

In order to avoid to change all rcu_dereference() to
rcu_dereference_check(..., rcu_read_lock_bh_held()), wrap nf_hook_slow
with read lock/unlock pair.

Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_netdev.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/netfilter_netdev.h b/include/linux/netfilter_netdev.h
index b4dd96e4dc8d..e6487a691136 100644
--- a/include/linux/netfilter_netdev.h
+++ b/include/linux/netfilter_netdev.h
@@ -101,7 +101,11 @@ static inline struct sk_buff *nf_hook_egress(struct sk_buff *skb, int *rc,
 	nf_hook_state_init(&state, NF_NETDEV_EGRESS,
 			   NFPROTO_NETDEV, dev, NULL, NULL,
 			   dev_net(dev), NULL);
+
+	/* nf assumes rcu_read_lock, not just read_lock_bh */
+	rcu_read_lock();
 	ret = nf_hook_slow(skb, &state, e, 0);
+	rcu_read_unlock();
 
 	if (ret == 1) {
 		return skb;
-- 
2.30.2

