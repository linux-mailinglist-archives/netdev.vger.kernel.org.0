Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869D34AF2E1
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234171AbiBINge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234136AbiBINg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:36:26 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0323C0613CA;
        Wed,  9 Feb 2022 05:36:29 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5689C601CD;
        Wed,  9 Feb 2022 14:36:18 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 10/14] netfilter: ecache: don't use nf_conn spinlock
Date:   Wed,  9 Feb 2022 14:36:12 +0100
Message-Id: <20220209133616.165104-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220209133616.165104-1-pablo@netfilter.org>
References: <20220209133616.165104-1-pablo@netfilter.org>
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

For updating eache missed value we can use cmpxchg.
This also avoids need to disable BH.

kernel robot reported build failure on v1 because not all arches support
cmpxchg for u16, so extend this to u32.

This doesn't increase struct size, existing padding is used.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_ecache.h |  2 +-
 net/netfilter/nf_conntrack_ecache.c         | 25 +++++++++++----------
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 16bcff809b18..6c4c490a3e34 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -21,10 +21,10 @@ enum nf_ct_ecache_state {
 
 struct nf_conntrack_ecache {
 	unsigned long cache;		/* bitops want long */
-	u16 missed;			/* missed events */
 	u16 ctmask;			/* bitmask of ct events to be delivered */
 	u16 expmask;			/* bitmask of expect events to be delivered */
 	enum nf_ct_ecache_state state:8;/* ecache state */
+	u32 missed;			/* missed events */
 	u32 portid;			/* netlink portid of destroyer */
 };
 
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 873908054f7f..07e65b4e92f8 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -131,13 +131,13 @@ static void ecache_work(struct work_struct *work)
 }
 
 static int __nf_conntrack_eventmask_report(struct nf_conntrack_ecache *e,
-					   const unsigned int events,
-					   const unsigned long missed,
+					   const u32 events,
+					   const u32 missed,
 					   const struct nf_ct_event *item)
 {
-	struct nf_conn *ct = item->ct;
 	struct net *net = nf_ct_net(item->ct);
 	struct nf_ct_event_notifier *notify;
+	u32 old, want;
 	int ret;
 
 	if (!((events | missed) & e->ctmask))
@@ -157,12 +157,13 @@ static int __nf_conntrack_eventmask_report(struct nf_conntrack_ecache *e,
 	if (likely(ret >= 0 && missed == 0))
 		return 0;
 
-	spin_lock_bh(&ct->lock);
-	if (ret < 0)
-		e->missed |= events;
-	else
-		e->missed &= ~missed;
-	spin_unlock_bh(&ct->lock);
+	do {
+		old = READ_ONCE(e->missed);
+		if (ret < 0)
+			want = old | events;
+		else
+			want = old & ~missed;
+	} while (cmpxchg(&e->missed, old, want) != old);
 
 	return ret;
 }
@@ -172,7 +173,7 @@ int nf_conntrack_eventmask_report(unsigned int events, struct nf_conn *ct,
 {
 	struct nf_conntrack_ecache *e;
 	struct nf_ct_event item;
-	unsigned long missed;
+	unsigned int missed;
 	int ret;
 
 	if (!nf_ct_is_confirmed(ct))
@@ -211,7 +212,7 @@ void nf_ct_deliver_cached_events(struct nf_conn *ct)
 {
 	struct nf_conntrack_ecache *e;
 	struct nf_ct_event item;
-	unsigned long events;
+	unsigned int events;
 
 	if (!nf_ct_is_confirmed(ct) || nf_ct_is_dying(ct))
 		return;
@@ -312,7 +313,7 @@ void nf_conntrack_ecache_pernet_init(struct net *net)
 	cnet->ct_net = &net->ct;
 	INIT_DELAYED_WORK(&cnet->ecache_dwork, ecache_work);
 
-	BUILD_BUG_ON(__IPCT_MAX >= 16);	/* ctmask, missed use u16 */
+	BUILD_BUG_ON(__IPCT_MAX >= 16);	/* e->ctmask is u16 */
 }
 
 void nf_conntrack_ecache_pernet_fini(struct net *net)
-- 
2.30.2

