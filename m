Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2ED93FB341
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 11:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236132AbhH3JkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 05:40:00 -0400
Received: from mail.netfilter.org ([217.70.188.207]:42594 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235863AbhH3Jj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 05:39:58 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id D88F6600A1;
        Mon, 30 Aug 2021 11:38:04 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 1/8] netfilter: ecache: remove one indent level
Date:   Mon, 30 Aug 2021 11:38:45 +0200
Message-Id: <20210830093852.21654-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210830093852.21654-1-pablo@netfilter.org>
References: <20210830093852.21654-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

nf_conntrack_eventmask_report and nf_ct_deliver_cached_events shared
most of their code.  This unifies the layout by changing

 if (nf_ct_is_confirmed(ct)) {
   foo
 }

 to
 if (!nf_ct_is_confirmed(ct)))
   return
 foo

This removes one level of indentation.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_ecache.h |  2 +-
 net/netfilter/nf_conntrack_ecache.c         | 64 +++++++++++----------
 net/netfilter/nf_conntrack_netlink.c        |  2 +-
 3 files changed, 36 insertions(+), 32 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index d00ba6048e44..3734bacf9763 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -73,7 +73,7 @@ struct nf_ct_event {
 };
 
 struct nf_ct_event_notifier {
-	int (*fcn)(unsigned int events, struct nf_ct_event *item);
+	int (*fcn)(unsigned int events, const struct nf_ct_event *item);
 };
 
 int nf_conntrack_register_notifier(struct net *net,
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 296e4a171bd1..3f1e0add58bc 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -133,10 +133,15 @@ static void ecache_work(struct work_struct *work)
 int nf_conntrack_eventmask_report(unsigned int eventmask, struct nf_conn *ct,
 				  u32 portid, int report)
 {
-	int ret = 0;
 	struct net *net = nf_ct_net(ct);
 	struct nf_ct_event_notifier *notify;
 	struct nf_conntrack_ecache *e;
+	struct nf_ct_event item;
+	unsigned long missed;
+	int ret = 0;
+
+	if (!nf_ct_is_confirmed(ct))
+		return ret;
 
 	rcu_read_lock();
 	notify = rcu_dereference(net->ct.nf_conntrack_event_cb);
@@ -147,38 +152,37 @@ int nf_conntrack_eventmask_report(unsigned int eventmask, struct nf_conn *ct,
 	if (!e)
 		goto out_unlock;
 
-	if (nf_ct_is_confirmed(ct)) {
-		struct nf_ct_event item = {
-			.ct	= ct,
-			.portid	= e->portid ? e->portid : portid,
-			.report = report
-		};
-		/* This is a resent of a destroy event? If so, skip missed */
-		unsigned long missed = e->portid ? 0 : e->missed;
-
-		if (!((eventmask | missed) & e->ctmask))
-			goto out_unlock;
-
-		ret = notify->fcn(eventmask | missed, &item);
-		if (unlikely(ret < 0 || missed)) {
-			spin_lock_bh(&ct->lock);
-			if (ret < 0) {
-				/* This is a destroy event that has been
-				 * triggered by a process, we store the PORTID
-				 * to include it in the retransmission.
-				 */
-				if (eventmask & (1 << IPCT_DESTROY)) {
-					if (e->portid == 0 && portid != 0)
-						e->portid = portid;
-					e->state = NFCT_ECACHE_DESTROY_FAIL;
-				} else {
-					e->missed |= eventmask;
-				}
+	memset(&item, 0, sizeof(item));
+
+	item.ct = ct;
+	item.portid = e->portid ? e->portid : portid;
+	item.report = report;
+
+	/* This is a resent of a destroy event? If so, skip missed */
+	missed = e->portid ? 0 : e->missed;
+
+	if (!((eventmask | missed) & e->ctmask))
+		goto out_unlock;
+
+	ret = notify->fcn(eventmask | missed, &item);
+	if (unlikely(ret < 0 || missed)) {
+		spin_lock_bh(&ct->lock);
+		if (ret < 0) {
+			/* This is a destroy event that has been
+			 * triggered by a process, we store the PORTID
+			 * to include it in the retransmission.
+			 */
+			if (eventmask & (1 << IPCT_DESTROY)) {
+				if (e->portid == 0 && portid != 0)
+					e->portid = portid;
+				e->state = NFCT_ECACHE_DESTROY_FAIL;
 			} else {
-				e->missed &= ~missed;
+				e->missed |= eventmask;
 			}
-			spin_unlock_bh(&ct->lock);
+		} else {
+			e->missed &= ~missed;
 		}
+		spin_unlock_bh(&ct->lock);
 	}
 out_unlock:
 	rcu_read_unlock();
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index eb35c6151fb0..43b891a902de 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -706,7 +706,7 @@ static size_t ctnetlink_nlmsg_size(const struct nf_conn *ct)
 }
 
 static int
-ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
+ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
 {
 	const struct nf_conntrack_zone *zone;
 	struct net *net;
-- 
2.20.1

