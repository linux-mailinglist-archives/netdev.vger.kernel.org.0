Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B273FB33E
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 11:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236042AbhH3Jj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 05:39:59 -0400
Received: from mail.netfilter.org ([217.70.188.207]:42588 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235583AbhH3Jj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 05:39:58 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 85CD0600B0;
        Mon, 30 Aug 2021 11:38:05 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 2/8] netfilter: ecache: remove another indent level
Date:   Mon, 30 Aug 2021 11:38:46 +0200
Message-Id: <20210830093852.21654-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210830093852.21654-1-pablo@netfilter.org>
References: <20210830093852.21654-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

... by changing:

if (unlikely(ret < 0 || missed)) {
	if (ret < 0) {
to
if (likely(ret >= 0 && !missed))
	goto out;

if (ret < 0) {

After this nf_conntrack_eventmask_report and nf_ct_deliver_cached_events
look pretty much the same, next patch moves common code to a helper.

This patch has no effect on generated code.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_ecache.c | 34 +++++++++++++++--------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 3f1e0add58bc..127a0fa6ae43 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -165,25 +165,27 @@ int nf_conntrack_eventmask_report(unsigned int eventmask, struct nf_conn *ct,
 		goto out_unlock;
 
 	ret = notify->fcn(eventmask | missed, &item);
-	if (unlikely(ret < 0 || missed)) {
-		spin_lock_bh(&ct->lock);
-		if (ret < 0) {
-			/* This is a destroy event that has been
-			 * triggered by a process, we store the PORTID
-			 * to include it in the retransmission.
-			 */
-			if (eventmask & (1 << IPCT_DESTROY)) {
-				if (e->portid == 0 && portid != 0)
-					e->portid = portid;
-				e->state = NFCT_ECACHE_DESTROY_FAIL;
-			} else {
-				e->missed |= eventmask;
-			}
+	if (likely(ret >= 0 && !missed))
+		goto out_unlock;
+
+	spin_lock_bh(&ct->lock);
+	if (ret < 0) {
+		/* This is a destroy event that has been
+		 * triggered by a process, we store the PORTID
+		 * to include it in the retransmission.
+		 */
+		if (eventmask & (1 << IPCT_DESTROY)) {
+			if (e->portid == 0 && portid != 0)
+				e->portid = portid;
+			e->state = NFCT_ECACHE_DESTROY_FAIL;
 		} else {
-			e->missed &= ~missed;
+			e->missed |= eventmask;
 		}
-		spin_unlock_bh(&ct->lock);
+	} else {
+		e->missed &= ~missed;
 	}
+	spin_unlock_bh(&ct->lock);
+
 out_unlock:
 	rcu_read_unlock();
 	return ret;
-- 
2.20.1

