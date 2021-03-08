Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09BB4331724
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 20:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbhCHTV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 14:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbhCHTVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 14:21:18 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA466C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 11:21:16 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id v196so13940623ybv.3
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 11:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=dgjAf3psN/fTWUlgUZQ+sezfuHiyStXidZ8UuVctVcA=;
        b=dlKR2fgfmpHb/a5IJH5Dby9efhkZWkrcq4jFPllTDy6OkwKoZ7VnxTMZoL1YxB6YsO
         XwSrrfLIrGnLYM2EiT7UMQkn9glmY4+P3k683N/3wndpiVsiMPis/+GhW01MYlTTh8Dh
         r2kySTcPwaMPtdcwB7lS4VmZhCg1Jatfe074aL+DLuRSEm5AnEdEmpUbor8cRnxwXn2m
         U44O8n95/HW3JW70+OIzvYAagwBwtKeqJEgZuhj0bep+aeyFRxPwoyw1NqHop9hmTerv
         TFeUW1IcP932sa6VvxN5Y5kn/4209fKo0HEbnD1cLXFkyD2N8BC1KnVNj17738xi04BS
         FS0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=dgjAf3psN/fTWUlgUZQ+sezfuHiyStXidZ8UuVctVcA=;
        b=IPZNIrU30nEPmhC0UmBE/qRDr0BwO39litgcJPrhOBvJTA2JYk7pF09bqcbUNudUch
         xy9w7CnVhapTuXl2792uoWMIslsPKcP1uLLIT4bPJ747ZtCigW/1cugbN1Yb2CwbvXcX
         MTSP1H6sePefifPgpES91/w1hVQJCCseoDlfV9yUfS4WiW+mDLUYJMmtn6SqwRT+0QZ0
         uFaMI1MFLUITsbBvAOWnZbS2Z5JYzl1pj58+NgfYe4wmouOxluNb2Dw+ZoR8f/39GkJq
         nAMpaT7gF7lCMNH+6AAc5/61jHTFaacNA/GpwgQo0yeQSMg/QJSRl0p05t/TK8ZwKvak
         Nb/A==
X-Gm-Message-State: AOAM531yY6Gz93rst57FXHi7Lu0oDU/LSzAQwAXySt9s3oRySOlHlIQf
        6xd5hN95LxWvnF193Um3zBsti1yj0TM=
X-Google-Smtp-Source: ABdhPJxTJkJ2gV2AdRiEjzbSzMFBjfone3Zz0BsBd9qJ5Po78o/vM76f5tWvzl+s+DfN4yNGA0Msuk3cMIs=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:ac5a:d5b3:ec51:a5d8])
 (user=weiwan job=sendgmr) by 2002:a25:50d5:: with SMTP id e204mr33744539ybb.294.1615231275233;
 Mon, 08 Mar 2021 11:21:15 -0800 (PST)
Date:   Mon,  8 Mar 2021 11:21:13 -0800
Message-Id: <20210308192113.2721435-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH net] ipv6: fix suspecious RCU usage warning
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     syzbot <syzkaller@googlegroups.com>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported the suspecious RCU usage in nexthop_fib6_nh() when
called from ipv6_route_seq_show(). The reason is ipv6_route_seq_start()
calls rcu_read_lock_bh(), while nexthop_fib6_nh() calls
rcu_dereference_rtnl().
The fix proposed is to add an extra parameter in nexthop_fib6_nh() to
indicate if bh is disabled or not, and then use the corresponding
dereference function.

The reported trace is as follows:
./include/net/nexthop.h:416 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
2 locks held by syz-executor.0/17895:
 #0: ffff8801db098e20 (&p->lock){+.+.},
     at: seq_read+0x71/0x12a0 fs/seq_file.c:169
 #1: ffffffff85e18de0 (rcu_read_lock_bh){....},
     at: seq_file_net include/linux/seq_file_net.h:19 [inline]
 #1: ffffffff85e18de0 (rcu_read_lock_bh){....},
     at: ipv6_route_seq_start+0xaf/0x300 net/ipv6/ip6_fib.c:2616

stack backtrace:
CPU: 1 PID: 17895 Comm: syz-executor.0 Not tainted 4.15.0-syzkaller #0
Call Trace:
 [<ffffffff849edf9e>] __dump_stack lib/dump_stack.c:17 [inline]
 [<ffffffff849edf9e>] dump_stack+0xd8/0x147 lib/dump_stack.c:53
 [<ffffffff8480b7fa>] lockdep_rcu_suspicious+0x153/0x15d kernel/locking/lockdep.c:5745
 [<ffffffff8459ada6>] nexthop_fib6_nh include/net/nexthop.h:416 [inline]
 [<ffffffff8459ada6>] ipv6_route_native_seq_show net/ipv6/ip6_fib.c:2488 [inline]
 [<ffffffff8459ada6>] ipv6_route_seq_show+0x436/0x7a0 net/ipv6/ip6_fib.c:2673
 [<ffffffff81c556df>] seq_read+0xccf/0x12a0 fs/seq_file.c:276
 [<ffffffff81dbc62c>] proc_reg_read+0x10c/0x1d0 fs/proc/inode.c:231
 [<ffffffff81bc28ae>] do_loop_readv_writev fs/read_write.c:714 [inline]
 [<ffffffff81bc28ae>] do_loop_readv_writev fs/read_write.c:701 [inline]
 [<ffffffff81bc28ae>] do_iter_read+0x49e/0x660 fs/read_write.c:935
 [<ffffffff81bc81ab>] vfs_readv+0xfb/0x170 fs/read_write.c:997
 [<ffffffff81c88847>] kernel_readv fs/splice.c:361 [inline]
 [<ffffffff81c88847>] default_file_splice_read+0x487/0x9c0 fs/splice.c:416
 [<ffffffff81c86189>] do_splice_to+0x129/0x190 fs/splice.c:879
 [<ffffffff81c86f66>] splice_direct_to_actor+0x256/0x890 fs/splice.c:951
 [<ffffffff81c8777d>] do_splice_direct+0x1dd/0x2b0 fs/splice.c:1060
 [<ffffffff81bc4747>] do_sendfile+0x597/0xce0 fs/read_write.c:1459
 [<ffffffff81bca205>] SYSC_sendfile64 fs/read_write.c:1520 [inline]
 [<ffffffff81bca205>] SyS_sendfile64+0x155/0x170 fs/read_write.c:1506
 [<ffffffff81015fcf>] do_syscall_64+0x1ff/0x310 arch/x86/entry/common.c:305
 [<ffffffff84a00076>] entry_SYSCALL_64_after_hwframe+0x42/0xb7

Fixes: f88d8ea67fbdb ("ipv6: Plumb support for nexthop object in a fib6_info")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Wei Wang <weiwan@google.com>
Cc: David Ahern <dsahern@kernel.org> 
Cc: Eric Dumazet <edumazet@google.com>
---
 include/net/nexthop.h | 18 +++++++++++++-----
 net/ipv6/ip6_fib.c    |  2 +-
 net/ipv6/route.c      | 10 +++++-----
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 7bc057aee40b..48956b144689 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -410,31 +410,39 @@ static inline struct fib_nh *fib_info_nh(struct fib_info *fi, int nhsel)
 int fib6_check_nexthop(struct nexthop *nh, struct fib6_config *cfg,
 		       struct netlink_ext_ack *extack);
 
-static inline struct fib6_nh *nexthop_fib6_nh(struct nexthop *nh)
+static inline struct fib6_nh *nexthop_fib6_nh(struct nexthop *nh,
+					      bool bh_disabled)
 {
 	struct nh_info *nhi;
 
 	if (nh->is_group) {
 		struct nh_group *nh_grp;
 
-		nh_grp = rcu_dereference_rtnl(nh->nh_grp);
+		if (bh_disabled)
+			nh_grp = rcu_dereference_bh_rtnl(nh->nh_grp);
+		else
+			nh_grp = rcu_dereference_rtnl(nh->nh_grp);
 		nh = nexthop_mpath_select(nh_grp, 0);
 		if (!nh)
 			return NULL;
 	}
 
-	nhi = rcu_dereference_rtnl(nh->nh_info);
+	if (bh_disabled)
+		nhi = rcu_dereference_bh_rtnl(nh->nh_info);
+	else
+		nhi = rcu_dereference_rtnl(nh->nh_info);
 	if (nhi->family == AF_INET6)
 		return &nhi->fib6_nh;
 
 	return NULL;
 }
 
+// Called with rcu_read_lock()
 static inline struct net_device *fib6_info_nh_dev(struct fib6_info *f6i)
 {
 	struct fib6_nh *fib6_nh;
 
-	fib6_nh = f6i->nh ? nexthop_fib6_nh(f6i->nh) : f6i->fib6_nh;
+	fib6_nh = f6i->nh ? nexthop_fib6_nh(f6i->nh, false) : f6i->fib6_nh;
 	return fib6_nh->fib_nh_dev;
 }
 
@@ -449,7 +457,7 @@ static inline void nexthop_path_fib6_result(struct fib6_result *res, int hash)
 	if (nhi->reject_nh) {
 		res->fib6_type = RTN_BLACKHOLE;
 		res->fib6_flags |= RTF_REJECT;
-		res->nh = nexthop_fib6_nh(nh);
+		res->nh = nexthop_fib6_nh(nh, false);
 	} else {
 		res->nh = &nhi->fib6_nh;
 	}
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index ef9d022e693f..70246a7e1344 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -2486,7 +2486,7 @@ static int ipv6_route_native_seq_show(struct seq_file *seq, void *v)
 	const struct net_device *dev;
 
 	if (rt->nh)
-		fib6_nh = nexthop_fib6_nh(rt->nh);
+		fib6_nh = nexthop_fib6_nh(rt->nh, true);
 
 	seq_printf(seq, "%pi6 %02x ", &rt->fib6_dst.addr, rt->fib6_dst.plen);
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 1536f4948e86..2439f6904806 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -547,7 +547,7 @@ static void rt6_device_match(struct net *net, struct fib6_result *res,
 
 	if (!oif && ipv6_addr_any(saddr)) {
 		if (unlikely(f6i->nh)) {
-			nh = nexthop_fib6_nh(f6i->nh);
+			nh = nexthop_fib6_nh(f6i->nh, false);
 			if (nexthop_is_blackhole(f6i->nh))
 				goto out_blackhole;
 		} else {
@@ -583,7 +583,7 @@ static void rt6_device_match(struct net *net, struct fib6_result *res,
 	}
 
 	if (unlikely(f6i->nh)) {
-		nh = nexthop_fib6_nh(f6i->nh);
+		nh = nexthop_fib6_nh(f6i->nh, false);
 		if (nexthop_is_blackhole(f6i->nh))
 			goto out_blackhole;
 	} else {
@@ -830,7 +830,7 @@ static void __find_rr_leaf(struct fib6_info *f6i_start,
 				res->fib6_flags = RTF_REJECT;
 				res->fib6_type = RTN_BLACKHOLE;
 				res->f6i = f6i;
-				res->nh = nexthop_fib6_nh(f6i->nh);
+				res->nh = nexthop_fib6_nh(f6i->nh, false);
 				return;
 			}
 			if (nexthop_for_each_fib6_nh(f6i->nh, rt6_nh_find_match,
@@ -3701,7 +3701,7 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
 			goto out;
 		}
 		rt->nh = nh;
-		fib6_nh = nexthop_fib6_nh(rt->nh);
+		fib6_nh = nexthop_fib6_nh(rt->nh, false);
 	} else {
 		err = fib6_nh_init(net, rt->fib6_nh, cfg, gfp_flags, extack);
 		if (err)
@@ -5443,7 +5443,7 @@ static int rt6_fill_node_nexthop(struct sk_buff *skb, struct nexthop *nh,
 	} else {
 		struct fib6_nh *fib6_nh;
 
-		fib6_nh = nexthop_fib6_nh(nh);
+		fib6_nh = nexthop_fib6_nh(nh, false);
 		if (fib_nexthop_info(skb, &fib6_nh->nh_common, AF_INET6,
 				     flags, false) < 0)
 			goto nla_put_failure;
-- 
2.30.1.766.gb4fecdf3b7-goog

