Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23824680B8B
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 12:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235704AbjA3LDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 06:03:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236569AbjA3LCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 06:02:32 -0500
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 06D3514E99;
        Mon, 30 Jan 2023 03:01:55 -0800 (PST)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id D8D943E7DD;
        Mon, 30 Jan 2023 13:01:53 +0200 (EET)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id 3602B3E7DC;
        Mon, 30 Jan 2023 13:01:52 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 6FBC93C0435;
        Mon, 30 Jan 2023 13:01:46 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 30UB1jpf044293;
        Mon, 30 Jan 2023 13:01:45 +0200
Date:   Mon, 30 Jan 2023 13:01:45 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
cc:     Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Denis V. Lunev" <den@openvz.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [Question] neighbor entry doesn't switch to the STALE state
 after the reachable timer expires
In-Reply-To: <9ebd0210-a4bb-afda-8a4d-5041b8395d78@huawei.com>
Message-ID: <9ac5f4f6-36cc-cc6b-1220-f45db141656c@ssi.bg>
References: <b1d8722e-5660-c38e-848f-3220d642889d@huawei.com> <99532c7f-161e-6d39-7680-ccc1f20349@ssi.bg> <9ebd0210-a4bb-afda-8a4d-5041b8395d78@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Mon, 30 Jan 2023, Zhang Changzhong wrote:

> On 2023/1/30 3:43, Julian Anastasov wrote:
> > 
> >> Does anyone have a good idea to solve this problem? Or are there other scenarios that might cause
> >> such a neighbor entry?
> > 
> > 	Is the neigh entry modified somehow, for example,
> > with 'arp -s' or 'ip neigh change' ? Or is bond0 reconfigured
> > after initial setup? I mean, 4 days ago?>
> 
> So far, we haven't found any user-space program that modifies the neigh
> entry or bond0.

	Ouch, we do not need tools to hit the problem,
thanks to gc_thresh1.

> In fact, the neigh entry has been rarely used since initialization.
> 4 days ago, our machine just needed to download files from 172.16.1.18.
> However, the laddr has changed, and the neigh entry wrongly switched to
> NUD_REACHABLE state, causing the laddr to fail to update.

	Received ARP packets should be able to change
the address. But we do not refresh the entry because
its timer is scheduled days ahead.

> > 	Looking at __neigh_update, there are few cases that
> > can assign NUD_STALE without touching neigh->confirmed:
> > lladdr = neigh->ha should be called, NEIGH_UPDATE_F_ADMIN
> > should be provided. Later, as you explain, it can wrongly
> > switch to NUD_REACHABLE state for long time.
> > 
> > 	May be there should be some measures to keep
> > neigh->confirmed valid during admin modifications.
> > 
> 
> This problem can also occur if the neigh entry stays in NUD_STALE state
> for more than 99 days, even if it is not modified by the administrator.

	I see.

> > 	What is the kernel version?
> > 
> 
> We encountered this problem in 4.4 LTS, and the mainline doesn't seem
> to fix it yet.

	Yep, kernel version is irrelevant.

	Here is a change that you can comment/test but
I'm not sure how many days (100?) are needed :) Not tested.

: From: Julian Anastasov <ja@ssi.bg>
Subject: [PATCH] neigh: make sure used and confirmed times are valid

Entries can linger without timer for days, thanks to
the gc_thresh1 limit. Later, on traffic, NUD_STALE entries
can switch to NUD_DELAY and start the timer which can see
confirmed time in the future causing switch to NUD_REACHABLE.
But then timer is started again based on the wrong
confirmed time, so days in the future. This is more
visible on 32-bit platforms.

Problem and the wrong state change reported by Zhang Changzhong:

172.16.1.18 dev bond0 lladdr 0a:0e:0f:01:12:01 ref 1 used 350521/15994171/350520 probes 4 REACHABLE

350520 seconds have elapsed since this entry was last updated, but it is
still in the REACHABLE state (base_reachable_time_ms is 30000),
preventing lladdr from being updated through probe.

Fix it by ensuring timer is started with valid used/confirmed
times. There are also places that need used/updated times to be
validated.

Reported-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Signed-off-by: Julian Anastasov <ja@ssi.bg>
---
 net/core/neighbour.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index a77a85e357e0..f063e8b8fb7d 100644
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
 
@@ -289,7 +289,13 @@ static int neigh_forced_gc(struct neigh_table *tbl)
 
 static void neigh_add_timer(struct neighbour *n, unsigned long when)
 {
+	unsigned long mint = jiffies - MAX_JIFFY_OFFSET + 86400 * HZ;
+
 	neigh_hold(n);
+	if (!time_in_range(n->confirmed, mint, jiffies))
+		n->confirmed = mint;
+	if (time_before(n->used, n->confirmed))
+		n->used = n->confirmed;
 	if (unlikely(mod_timer(&n->timer, when))) {
 		printk("NEIGH: BUG, double timer add, state is %x\n",
 		       n->nud_state);
@@ -982,12 +988,14 @@ static void neigh_periodic_work(struct work_struct *work)
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


