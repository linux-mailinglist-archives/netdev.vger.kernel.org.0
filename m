Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F4F698629
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 21:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjBOUsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 15:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjBOUri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 15:47:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9817243920;
        Wed, 15 Feb 2023 12:46:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31B8FB823B0;
        Wed, 15 Feb 2023 20:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23BE9C433EF;
        Wed, 15 Feb 2023 20:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676494007;
        bh=V87e6CrzJTfM2FA0m9KH3dYNBct9j8fhgxue4yG8SzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cdPWOeHQDpCBmk0LcNLDf9f2dkEzeKjZeX2bzUN9LfNpq8JPsJdhZ4xafkgdJw31k
         CGZUXTDqeJLcfIa/sbE6R7TPyde0zJnrVsB32fVdV1/+cw/0Q2y3WmH0IuINK3VMNV
         Zh52Qq7rdSjc95HQkmyiQOlYA7ur++JqsDZyndC+1SB28jqbQJQ0UO6JO5j60fM7gm
         JLA+Zdu3NxRla/gMCQqM5PsOOGMzjdyA9uimsHipBFxIySoDQPFVfXtbrQ1OLavUJP
         eRUTA9oQOg1X0s9fNO8CLgqilaojP/G87R31GJPPc1Q1ApjNp75VoGvDkTju9aeMkd
         oBvNS+YQbBP9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Anastasov <ja@ssi.bg>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, den@openvz.org,
        razor@blackwall.org, djwong@kernel.org, Jason@zx2c4.com,
        daniel@iogearbox.net, thomas.zeitlhofer+lkml@ze-it.at,
        yangyingliang@huawei.com, wangyuweihx@gmail.com,
        alexander@mihalicyn.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 10/12] neigh: make sure used and confirmed times are valid
Date:   Wed, 15 Feb 2023 15:46:32 -0500
Message-Id: <20230215204637.2761073-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230215204637.2761073-1-sashal@kernel.org>
References: <20230215204637.2761073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit c1d2ecdf5e38e3489ce8328238b558b3b2866fe1 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 0e22ecb469771..95f588b2fd159 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -241,7 +241,7 @@ static int neigh_forced_gc(struct neigh_table *tbl)
 			    (n->nud_state == NUD_NOARP) ||
 			    (tbl->is_multicast &&
 			     tbl->is_multicast(n->primary_key)) ||
-			    time_after(tref, n->updated))
+			    !time_in_range(n->updated, tref, jiffies))
 				remove = true;
 			write_unlock(&n->lock);
 
@@ -261,7 +261,17 @@ static int neigh_forced_gc(struct neigh_table *tbl)
 
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
@@ -943,12 +953,14 @@ static void neigh_periodic_work(struct work_struct *work)
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
2.39.0

