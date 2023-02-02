Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773F168823C
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 16:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbjBBP3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 10:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbjBBP26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 10:28:58 -0500
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D68C56F717
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 07:28:24 -0800 (PST)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 3911B52B7E;
        Thu,  2 Feb 2023 17:27:21 +0200 (EET)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id 1340552A76;
        Thu,  2 Feb 2023 17:27:18 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id DAC083C0435;
        Thu,  2 Feb 2023 17:27:14 +0200 (EET)
Received: from ja.home.ssi.bg (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 312FREHI056617;
        Thu, 2 Feb 2023 17:27:14 +0200
Received: (from root@localhost)
        by ja.home.ssi.bg (8.17.1/8.17.1/Submit) id 312FREDK056616;
        Thu, 2 Feb 2023 17:27:14 +0200
From:   Julian Anastasov <ja@ssi.bg>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net] neigh: make sure used and confirmed times are valid
Date:   Thu,  2 Feb 2023 17:25:51 +0200
Message-Id: <20230202152551.56390-1-ja@ssi.bg>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Entries can linger in cache without timer for days, thanks to
the gc_thresh1 limit. As result, without traffic, the confirmed
time can be outdated and to appear to be in the future. Later,
on traffic, NUD_STALE entries can switch to NUD_DELAY and start
the timer which can see the invalid confirmed time and wrongly
switch to NUD_REACHABLE state instead of NUD_PROBE. As result,
timer is set many days in the future. This is more visible on
32-bit platforms, with higher HZ value.

Why this is a problem? While we expect unused entries to expire,
such entries stay in REACHABLE state for too long, locked in
cache. They are not expired normally, only when cache is full.

Problem and the wrong state change reported by Zhang Changzhong:

172.16.1.18 dev bond0 lladdr 0a:0e:0f:01:12:01 ref 1 used 350521/15994171/350520 probes 4 REACHABLE

350520 seconds have elapsed since this entry was last updated, but it is
still in the REACHABLE state (base_reachable_time_ms is 30000),
preventing lladdr from being updated through probe.

Fix it by ensuring timer is started with valid used/confirmed
times. Considering the valid time range is LONG_MAX jiffies,
we try not to go too much in the past while we are in
DELAY/PROBE state. There are also places that need
used/updated times to be validated while timer is not running.

Reported-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Tested-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 net/core/neighbour.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

 This solution prefers to add code in neigh_add_timer()
 assuming it is less used than the timer code. The
 alternative would be to add time_in_range* calls in
 neigh_timer_handler() to be more safe.
 Another solution would be to add the time correction
 only in __neigh_event_send() where we switch from
 STALE to DELAY as it looks to be the only path that
 is affected and where we switch to states that
 consider the confirmed time. OTOH, NUD_INCOMPLETE
 is not affected from invalid times.

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index f00a79fc301b..4edd2176e238 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -269,7 +269,7 @@ static int neigh_forced_gc(struct neigh_table *tbl)
 			    (n->nud_state == NUD_NOARP) ||
 			    (tbl->is_multicast &&
 			     tbl->is_multicast(n->primary_key)) ||
-			    time_after(tref, n->updated))
+			    !time_in_range(n->updated, tref, jiffies))
 				remove = true;
 			write_unlock(&n->lock);
 
@@ -289,7 +289,17 @@ static int neigh_forced_gc(struct neigh_table *tbl)
 
 static void neigh_add_timer(struct neighbour *n, unsigned long when)
 {
+	/* Use safe distance from the jiffies - LONG_MAX point while timer
+	 * is running in DELAY/PROBE state but still show to user space
+	 * large times in the past.
+	 */
+	unsigned long mint = jiffies - (LONG_MAX - 86400 * HZ);
+
 	neigh_hold(n);
+	if (!time_in_range(n->confirmed, mint, jiffies))
+		n->confirmed = mint;
+	if (time_before(n->used, n->confirmed))
+		n->used = n->confirmed;
 	if (unlikely(mod_timer(&n->timer, when))) {
 		printk("NEIGH: BUG, double timer add, state is %x\n",
 		       n->nud_state);
@@ -1001,12 +1011,14 @@ static void neigh_periodic_work(struct work_struct *work)
 				goto next_elt;
 			}
 
-			if (time_before(n->used, n->confirmed))
+			if (time_before(n->used, n->confirmed) &&
+			    time_is_before_eq_jiffies(n->confirmed))
 				n->used = n->confirmed;
 
 			if (refcount_read(&n->refcnt) == 1 &&
 			    (state == NUD_FAILED ||
-			     time_after(jiffies, n->used + NEIGH_VAR(n->parms, GC_STALETIME)))) {
+			     !time_in_range_open(jiffies, n->used,
+						 n->used + NEIGH_VAR(n->parms, GC_STALETIME)))) {
 				*np = n->next;
 				neigh_mark_dead(n);
 				write_unlock(&n->lock);
-- 
2.39.1


