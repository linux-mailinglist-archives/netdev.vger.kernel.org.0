Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126292EB6C6
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 01:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbhAFAX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 19:23:59 -0500
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:2209 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725919AbhAFAX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 19:23:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1609892639; x=1641428639;
  h=from:to:cc:subject:date:message-id;
  bh=0GLBYRAGswWLmnmKgAb4CkTLHRfquKfA3w72y/5lCk4=;
  b=O1TLzEtoLVLt8VV5IqFV5CkI2pqXEzoqBEZiSwHR5aZFJGYpST1+W6Be
   8tvnULw5xe+YTvmgnP2zgQ4iQA/Shzd6atuCcDaMT4glO/mO2yTPuoxBi
   PiskeHAJrk4lN/T/ptDy8drblzSOpdXtjcY42amGQ7OWCF6DsNHqWsari
   c=;
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 05 Jan 2021 16:23:19 -0800
X-QCInternal: smtphost
Received: from stranche-lnx.qualcomm.com ([129.46.14.77])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 05 Jan 2021 16:23:18 -0800
Received: by stranche-lnx.qualcomm.com (Postfix, from userid 383980)
        id 0F412353A; Tue,  5 Jan 2021 16:23:18 -0800 (PST)
From:   Sean Tranchetti <stranche@quicinc.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     subashab@codearurora.org, Sean Tranchetti <stranche@codeaurora.org>
Subject: [net PATCH 1/2] net: ipv6: fib: flush exceptions when purging route
Date:   Tue,  5 Jan 2021 16:22:25 -0800
Message-Id: <1609892546-11389-1-git-send-email-stranche@quicinc.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Tranchetti <stranche@codeaurora.org>

Route removal is handled by two code paths. The main removal path is via
fib6_del_route() which will handle purging any PMTU exceptions from the
cache, removing all per-cpu copies of the DST entry used by the route, and
releasing the fib6_info struct.

The second removal location is during fib6_add_rt2node() during a route
replacement operation. This path also calls fib6_purge_rt() to handle
cleaning up the per-cpu copies of the DST entries and releasing the
fib6_info associated with the older route, but it does not flush any PMTU
exceptions that the older route had. Since the older route is removed from
the tree during the replacement, we lose any way of accessing it again.

As these lingering DSTs and the fib6_info struct are holding references to
the underlying netdevice struct as well, unregistering that device from the
kernel can never complete.

Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
---
 net/ipv6/ip6_fib.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 605cdd3..f43e275 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1025,6 +1025,8 @@ static void fib6_purge_rt(struct fib6_info *rt, struct fib6_node *fn,
 {
 	struct fib6_table *table = rt->fib6_table;
 
+	/* Flush all cached dst in exception table */
+	rt6_flush_exceptions(rt);
 	fib6_drop_pcpu_from(rt, table);
 
 	if (rt->nh && !list_empty(&rt->nh_list))
@@ -1927,9 +1929,6 @@ static void fib6_del_route(struct fib6_table *table, struct fib6_node *fn,
 	net->ipv6.rt6_stats->fib_rt_entries--;
 	net->ipv6.rt6_stats->fib_discarded_routes++;
 
-	/* Flush all cached dst in exception table */
-	rt6_flush_exceptions(rt);
-
 	/* Reset round-robin state, if necessary */
 	if (rcu_access_pointer(fn->rr_ptr) == rt)
 		fn->rr_ptr = NULL;
-- 
2.7.4

