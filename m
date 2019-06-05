Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 773E8367BE
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 01:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbfFEXPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 19:15:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726597AbfFEXP1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 19:15:27 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B54B6208C3;
        Wed,  5 Jun 2019 23:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559776526;
        bh=/785a1r3Rs3azdJzR1BpcZEmDICb1ICLjJyr0h8bfCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e90RNe2EaccymfyJ3SF7YA9LsTKFZIXoLV3Me9gQPtVNHMiEct7aP9s7oRiBi7f0o
         MPMCzFnOgfsxOszGMOZlyvn26eb82k0IswzFdAISY/g6Xzl6ANZQu4ScUEihZCjPrH
         o8x6LV+xmmJx0Kg2GY3o8419R0/LZp/usF6JzL2E=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 07/19] ipv6: Handle all fib6_nh in a nexthop in exception handling
Date:   Wed,  5 Jun 2019 16:15:11 -0700
Message-Id: <20190605231523.18424-8-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190605231523.18424-1-dsahern@kernel.org>
References: <20190605231523.18424-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add a hook in rt6_flush_exceptions, rt6_remove_exception_rt,
rt6_update_exception_stamp_rt, and rt6_age_exceptions to handle
nexthop struct in a fib6_info.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv6/route.c | 109 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 106 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 6f4bd971df70..f1fd376b6035 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1746,9 +1746,22 @@ static void fib6_nh_flush_exceptions(struct fib6_nh *nh, struct fib6_info *from)
 	spin_unlock_bh(&rt6_exception_lock);
 }
 
+static int rt6_nh_flush_exceptions(struct fib6_nh *nh, void *arg)
+{
+	struct fib6_info *f6i = arg;
+
+	fib6_nh_flush_exceptions(nh, f6i);
+
+	return 0;
+}
+
 void rt6_flush_exceptions(struct fib6_info *f6i)
 {
-	fib6_nh_flush_exceptions(f6i->fib6_nh, f6i);
+	if (f6i->nh)
+		nexthop_for_each_fib6_nh(f6i->nh, rt6_nh_flush_exceptions,
+					 f6i);
+	else
+		fib6_nh_flush_exceptions(f6i->fib6_nh, f6i);
 }
 
 /* Find cached rt in the hash table inside passed in rt
@@ -1835,6 +1848,24 @@ static int fib6_nh_remove_exception(const struct fib6_nh *nh, int plen,
 	return err;
 }
 
+struct fib6_nh_excptn_arg {
+	struct rt6_info	*rt;
+	int		plen;
+	bool		found;
+};
+
+static int rt6_nh_remove_exception_rt(struct fib6_nh *nh, void *_arg)
+{
+	struct fib6_nh_excptn_arg *arg = _arg;
+	int err;
+
+	err = fib6_nh_remove_exception(nh, arg->plen, arg->rt);
+	if (err == 0)
+		arg->found = true;
+
+	return 0;
+}
+
 static int rt6_remove_exception_rt(struct rt6_info *rt)
 {
 	struct fib6_info *from;
@@ -1843,6 +1874,17 @@ static int rt6_remove_exception_rt(struct rt6_info *rt)
 	if (!from || !(rt->rt6i_flags & RTF_CACHE))
 		return -EINVAL;
 
+	if (from->nh) {
+		struct fib6_nh_excptn_arg arg = {
+			.rt = rt,
+			.plen = from->fib6_src.plen
+		};
+
+		nexthop_for_each_fib6_nh(from->nh, rt6_nh_remove_exception_rt,
+					 &arg);
+		return arg.found ? 0 : -ENOENT;
+	}
+
 	return fib6_nh_remove_exception(from->fib6_nh,
 					from->fib6_src.plen, rt);
 }
@@ -1873,9 +1915,33 @@ static void fib6_nh_update_exception(const struct fib6_nh *nh, int plen,
 		rt6_ex->stamp = jiffies;
 }
 
+struct fib6_nh_match_arg {
+	const struct net_device *dev;
+	const struct in6_addr	*gw;
+	struct fib6_nh		*match;
+};
+
+/* determine if fib6_nh has given device and gateway */
+static int fib6_nh_find_match(struct fib6_nh *nh, void *_arg)
+{
+	struct fib6_nh_match_arg *arg = _arg;
+
+	if (arg->dev != nh->fib_nh_dev ||
+	    (arg->gw && !nh->fib_nh_gw_family) ||
+	    (!arg->gw && nh->fib_nh_gw_family) ||
+	    (arg->gw && !ipv6_addr_equal(arg->gw, &nh->fib_nh_gw6)))
+		return 0;
+
+	arg->match = nh;
+
+	/* found a match, break the loop */
+	return 1;
+}
+
 static void rt6_update_exception_stamp_rt(struct rt6_info *rt)
 {
 	struct fib6_info *from;
+	struct fib6_nh *fib6_nh;
 
 	rcu_read_lock();
 
@@ -1883,7 +1949,21 @@ static void rt6_update_exception_stamp_rt(struct rt6_info *rt)
 	if (!from || !(rt->rt6i_flags & RTF_CACHE))
 		goto unlock;
 
-	fib6_nh_update_exception(from->fib6_nh, from->fib6_src.plen, rt);
+	if (from->nh) {
+		struct fib6_nh_match_arg arg = {
+			.dev = rt->dst.dev,
+			.gw = &rt->rt6i_gateway,
+		};
+
+		nexthop_for_each_fib6_nh(from->nh, fib6_nh_find_match, &arg);
+
+		if (!arg.match)
+			return;
+		fib6_nh = arg.match;
+	} else {
+		fib6_nh = from->fib6_nh;
+	}
+	fib6_nh_update_exception(fib6_nh, from->fib6_src.plen, rt);
 unlock:
 	rcu_read_unlock();
 }
@@ -2045,11 +2125,34 @@ static void fib6_nh_age_exceptions(const struct fib6_nh *nh,
 	rcu_read_unlock_bh();
 }
 
+struct fib6_nh_age_excptn_arg {
+	struct fib6_gc_args	*gc_args;
+	unsigned long		now;
+};
+
+static int rt6_nh_age_exceptions(struct fib6_nh *nh, void *_arg)
+{
+	struct fib6_nh_age_excptn_arg *arg = _arg;
+
+	fib6_nh_age_exceptions(nh, arg->gc_args, arg->now);
+	return 0;
+}
+
 void rt6_age_exceptions(struct fib6_info *f6i,
 			struct fib6_gc_args *gc_args,
 			unsigned long now)
 {
-	fib6_nh_age_exceptions(f6i->fib6_nh, gc_args, now);
+	if (f6i->nh) {
+		struct fib6_nh_age_excptn_arg arg = {
+			.gc_args = gc_args,
+			.now = now
+		};
+
+		nexthop_for_each_fib6_nh(f6i->nh, rt6_nh_age_exceptions,
+					 &arg);
+	} else {
+		fib6_nh_age_exceptions(f6i->fib6_nh, gc_args, now);
+	}
 }
 
 /* must be called with rcu lock held */
-- 
2.11.0

