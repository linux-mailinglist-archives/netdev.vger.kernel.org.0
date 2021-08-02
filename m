Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17EB03DD1AF
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 10:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232726AbhHBIFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 04:05:40 -0400
Received: from out1.migadu.com ([91.121.223.63]:39748 "EHLO out1.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232537AbhHBIFj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 04:05:39 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1627891529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FNEjoqYikcFg/JQNU0unDa83ZHY6oHgRfPce5wOp754=;
        b=jrXAmmfFAPcDrSl9f/6o/tqrjAkvSqRZ0EkPT3KByYg3jc0PfB/a+vrn6aRqj1dxmwY8eY
        zOSdgUaymx8BYaDgI8oNIU4vFrcoxz3oFgZjMzpSZqjjWj1Ro/abFfdrpTwLBlsxKM8ebh
        k1+zLWA6gsQvLoQp83v/wdCjw9LxCBk=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next v2] net: Keep vertical alignment
Date:   Mon,  2 Aug 2021 16:05:08 +0800
Message-Id: <20210802080508.11971-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Those files under /proc/net/stat/ don't have vertical alignment, it looks
very difficult. Modify the seq_printf statement, keep vertical alignment.

v2:
 - Use seq_puts() and seq_printf() correctly.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/core/neighbour.c | 7 ++++---
 net/ipv4/route.c     | 7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index c294addb7818..683b87a6a615 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3315,12 +3315,13 @@ static int neigh_stat_seq_show(struct seq_file *seq, void *v)
 	struct neigh_statistics *st = v;
 
 	if (v == SEQ_START_TOKEN) {
-		seq_printf(seq, "entries  allocs destroys hash_grows  lookups hits  res_failed  rcv_probes_mcast rcv_probes_ucast  periodic_gc_runs forced_gc_runs unresolved_discards table_fulls\n");
+		seq_puts(seq, "entries  allocs   destroys hash_grows lookups  hits     res_failed rcv_probes_mcast rcv_probes_ucast periodic_gc_runs forced_gc_runs unresolved_discards table_fulls\n");
 		return 0;
 	}
 
-	seq_printf(seq, "%08x  %08lx %08lx %08lx  %08lx %08lx  %08lx  "
-			"%08lx %08lx  %08lx %08lx %08lx %08lx\n",
+	seq_printf(seq, "%08x %08lx %08lx %08lx   %08lx %08lx %08lx   "
+			"%08lx         %08lx         %08lx         "
+			"%08lx       %08lx            %08lx\n",
 		   atomic_read(&tbl->entries),
 
 		   st->allocs,
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 04754d55b3c1..44a96cfcfbdf 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -276,12 +276,13 @@ static int rt_cpu_seq_show(struct seq_file *seq, void *v)
 	struct rt_cache_stat *st = v;
 
 	if (v == SEQ_START_TOKEN) {
-		seq_printf(seq, "entries  in_hit in_slow_tot in_slow_mc in_no_route in_brd in_martian_dst in_martian_src  out_hit out_slow_tot out_slow_mc  gc_total gc_ignored gc_goal_miss gc_dst_overflow in_hlist_search out_hlist_search\n");
+		seq_puts(seq, "entries  in_hit   in_slow_tot in_slow_mc in_no_route in_brd   in_martian_dst in_martian_src out_hit  out_slow_tot out_slow_mc gc_total gc_ignored gc_goal_miss gc_dst_overflow in_hlist_search out_hlist_search\n");
 		return 0;
 	}
 
-	seq_printf(seq,"%08x  %08x %08x %08x %08x %08x %08x %08x "
-		   " %08x %08x %08x %08x %08x %08x %08x %08x %08x \n",
+	seq_printf(seq, "%08x %08x %08x    %08x   %08x    %08x %08x       "
+			"%08x       %08x %08x     %08x    %08x %08x   "
+			"%08x     %08x        %08x        %08x\n",
 		   dst_entries_get_slow(&ipv4_dst_ops),
 		   0, /* st->in_hit */
 		   st->in_slow_tot,
-- 
2.32.0

