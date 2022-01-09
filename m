Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4DC488D05
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237388AbiAIXQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:16:54 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42112 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237375AbiAIXQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:16:52 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1CCB964290;
        Mon, 10 Jan 2022 00:14:00 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 02/32] netfilter: nf_nat_masquerade: add netns refcount tracker to masq_dev_work
Date:   Mon, 10 Jan 2022 00:16:10 +0100
Message-Id: <20220109231640.104123-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220109231640.104123-1-pablo@netfilter.org>
References: <20220109231640.104123-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

If compiled with CONFIG_NET_NS_REFCNT_TRACKER=y,
using put_net_track() in iterate_cleanup_work()
and netns_tracker_alloc() in nf_nat_masq_schedule()
might help us finding netns refcount imbalances.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_masquerade.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
index acd73f717a08..e32fac374608 100644
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -12,6 +12,7 @@
 struct masq_dev_work {
 	struct work_struct work;
 	struct net *net;
+	netns_tracker ns_tracker;
 	union nf_inet_addr addr;
 	int ifindex;
 	int (*iter)(struct nf_conn *i, void *data);
@@ -82,7 +83,7 @@ static void iterate_cleanup_work(struct work_struct *work)
 
 	nf_ct_iterate_cleanup_net(w->net, w->iter, (void *)w, 0, 0);
 
-	put_net(w->net);
+	put_net_track(w->net, &w->ns_tracker);
 	kfree(w);
 	atomic_dec(&masq_worker_count);
 	module_put(THIS_MODULE);
@@ -119,6 +120,7 @@ static void nf_nat_masq_schedule(struct net *net, union nf_inet_addr *addr,
 		INIT_WORK(&w->work, iterate_cleanup_work);
 		w->ifindex = ifindex;
 		w->net = net;
+		netns_tracker_alloc(net, &w->ns_tracker, gfp_flags);
 		w->iter = iter;
 		if (addr)
 			w->addr = *addr;
-- 
2.30.2

