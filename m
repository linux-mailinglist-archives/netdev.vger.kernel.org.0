Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A1F488D3E
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237472AbiAIXRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:17:07 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42126 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237420AbiAIXRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:17:01 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id A9B1A64698;
        Mon, 10 Jan 2022 00:14:10 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 18/32] netfilter: egress: avoid a lockdep splat
Date:   Mon, 10 Jan 2022 00:16:26 +0100
Message-Id: <20220109231640.104123-19-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220109231640.104123-1-pablo@netfilter.org>
References: <20220109231640.104123-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

include/linux/netfilter_netdev.h:97 suspicious rcu_dereference_check() usage!
2 locks held by sd-resolve/1100:
 0: ..(rcu_read_lock_bh){1:3}, at: ip_finish_output2
 1: ..(rcu_read_lock_bh){1:3}, at: __dev_queue_xmit
 __dev_queue_xmit+0 ..

The helper has two callers, one uses rcu_read_lock, the other
rcu_read_lock_bh().  Annotate the dereference to reflect this.

Fixes: 42df6e1d221dd ("netfilter: Introduce egress hook")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_netdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netfilter_netdev.h b/include/linux/netfilter_netdev.h
index b71b57a83bb4..b4dd96e4dc8d 100644
--- a/include/linux/netfilter_netdev.h
+++ b/include/linux/netfilter_netdev.h
@@ -94,7 +94,7 @@ static inline struct sk_buff *nf_hook_egress(struct sk_buff *skb, int *rc,
 		return skb;
 #endif
 
-	e = rcu_dereference(dev->nf_hooks_egress);
+	e = rcu_dereference_check(dev->nf_hooks_egress, rcu_read_lock_bh_held());
 	if (!e)
 		return skb;
 
-- 
2.30.2

