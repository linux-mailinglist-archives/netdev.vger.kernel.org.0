Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5805BA965
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 11:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiIPJ3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 05:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiIPJ3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 05:29:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B64143E40;
        Fri, 16 Sep 2022 02:29:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20D13B81A4C;
        Fri, 16 Sep 2022 09:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A54C433C1;
        Fri, 16 Sep 2022 09:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663320587;
        bh=dfHufKqtlVJjPsBrkj4C+lW+AZOPU7tR+MI4RaBdHEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o7EphgOo39UDa7fWO6YVFcg+jTZewXHaq+YMQQI25cLIl97Jt7IVeJsUdiUZQnafD
         1nskgmIu1kOYVw6bp8+J3oxDRior0W5dC/XJt352K4Xw1qBt1WjPsAc9Bp1Y30bmgn
         UXvQSsnagxix75lju7clcc82cKhfTgEPSHowAvK+ag08ZJVl7/tJdYgDpkPmeW4wUY
         kNxR3+p7CqWCnBhG90L2typXbaSmdQUnuJ1vSeBESF1ep4gOGws37TRGuW3krh6pIm
         zZvsR8W3dAxmqatX+gdgQz5godyq09BzN1jzo/6n7cyU5we85/2wGGj/+YCkwHzOHz
         qDL7rCmCdP9fw==
From:   Antoine Tenart <atenart@kernel.org>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     Antoine Tenart <atenart@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH nf 1/2] netfilter: conntrack: fix the gc rescheduling delay
Date:   Fri, 16 Sep 2022 11:29:40 +0200
Message-Id: <20220916092941.39121-2-atenart@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916092941.39121-1-atenart@kernel.org>
References: <20220916092941.39121-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 2cfadb761d3d ("netfilter: conntrack: revisit gc autotuning")
changed the eviction rescheduling to the use average expiry of scanned
entries (within 1-60s) by doing:

  for (...) {
      expires = clamp(nf_ct_expires(tmp), ...);
      next_run += expires;
      next_run /= 2;
  }

The issue is the above will make the average ('next_run' here) more
dependent on the last expiration values than the firsts (for sets > 2).
Depending on the expiration values used to compute the average, the
result can be quite different than what's expected. To fix this we can
do the following:

  for (...) {
      expires = clamp(nf_ct_expires(tmp), ...);
      next_run += (expires - next_run) / ++count;
  }

Fixes: 2cfadb761d3d ("netfilter: conntrack: revisit gc autotuning")
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 1357a2729a4b..2e6d5f1e6d63 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -67,6 +67,7 @@ struct conntrack_gc_work {
 	struct delayed_work	dwork;
 	u32			next_bucket;
 	u32			avg_timeout;
+	u32			count;
 	u32			start_time;
 	bool			exiting;
 	bool			early_drop;
@@ -1466,6 +1467,7 @@ static void gc_worker(struct work_struct *work)
 	unsigned int expired_count = 0;
 	unsigned long next_run;
 	s32 delta_time;
+	long count;
 
 	gc_work = container_of(work, struct conntrack_gc_work, dwork.work);
 
@@ -1475,10 +1477,12 @@ static void gc_worker(struct work_struct *work)
 
 	if (i == 0) {
 		gc_work->avg_timeout = GC_SCAN_INTERVAL_INIT;
+		gc_work->count = 1;
 		gc_work->start_time = start_time;
 	}
 
 	next_run = gc_work->avg_timeout;
+	count = gc_work->count;
 
 	end_time = start_time + GC_SCAN_MAX_DURATION;
 
@@ -1498,8 +1502,8 @@ static void gc_worker(struct work_struct *work)
 
 		hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[i], hnnode) {
 			struct nf_conntrack_net *cnet;
-			unsigned long expires;
 			struct net *net;
+			long expires;
 
 			tmp = nf_ct_tuplehash_to_ctrack(h);
 
@@ -1513,6 +1517,7 @@ static void gc_worker(struct work_struct *work)
 
 				gc_work->next_bucket = i;
 				gc_work->avg_timeout = next_run;
+				gc_work->count = count;
 
 				delta_time = nfct_time_stamp - gc_work->start_time;
 
@@ -1528,8 +1533,8 @@ static void gc_worker(struct work_struct *work)
 			}
 
 			expires = clamp(nf_ct_expires(tmp), GC_SCAN_INTERVAL_MIN, GC_SCAN_INTERVAL_CLAMP);
+			expires = (expires - (long)next_run) / ++count;
 			next_run += expires;
-			next_run /= 2u;
 
 			if (nf_conntrack_max95 == 0 || gc_worker_skip_ct(tmp))
 				continue;
@@ -1570,6 +1575,7 @@ static void gc_worker(struct work_struct *work)
 		delta_time = nfct_time_stamp - end_time;
 		if (delta_time > 0 && i < hashsz) {
 			gc_work->avg_timeout = next_run;
+			gc_work->count = count;
 			gc_work->next_bucket = i;
 			next_run = 0;
 			goto early_exit;
-- 
2.37.3

