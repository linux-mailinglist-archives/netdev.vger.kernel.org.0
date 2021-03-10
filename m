Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1F6333314
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 03:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbhCJCUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 21:20:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbhCJCUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 21:20:37 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E41C06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 18:20:37 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id e6so11905864qte.0
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 18:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=DM1v+9w99RQoySvUXAnNC33r2PeIZ3rQbNZfe26PoaY=;
        b=JTmxecP/Xk+EuXe9yW0eFjvyOVHYpD521Cvo5U8Ita4hDnTG0VRD6OEk3Vqd1FcOdN
         YNdgga624CaMRQNBGPVxhhIxLGyWSIznOWDmnskH2KOkuqwbuLq4iFBdrriFdpyXmNm3
         DJ3LXMGxFd5oCZOokFfMh7zEie0MDnM1NbPK8EPbRrCoVXp18vU5klMNNOF0Hi9URHlG
         eu0gN4keK8kiaRb9HtdIxoDHE5mOzzPEnfclZZn9T4T5nnvqaIgIQ1120iwqmYvYN19B
         ItQ8kNEh5U/jlSa/fDfM64FMvvJ8oDjyJxjIXFmLX/4udrdeSsNUH259fPxkM6dnAl01
         5vPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=DM1v+9w99RQoySvUXAnNC33r2PeIZ3rQbNZfe26PoaY=;
        b=g0HyZTb3yh0UXybnDY/RDCE2KatToThLGYOLTRIh1MRywf38mBO1wChGyVgsEXumgE
         elf789OsLIwZXceJHpr7dtuwLT2sUbNEIG5LucOgotZjw1vrXwUC5INiAdVJ9a0dEs5x
         VL/X0t1Zz2YX3m0q+EH1pdkBAg/3GxnnKqiSsNIJOaiUh5bnNjj95mPVHVP6i74EMi6v
         kQfK9BJuj3rTyG0OJb4BdONa4VN3rhstLiKr+ZFoe8TVz5CxE58FYwUkSN7OVYOQnihD
         iqU0+5SndhoU9aWW+mvoidlZbeVGpy5o9edocBECoENVR5PPS28X5H562H6OfeCip7zm
         zZYA==
X-Gm-Message-State: AOAM532tVHYldcY2NsIgsdQ9k2KOy07xPBn7iAN90lRVesUmJwx4zMXx
        gE7iFieOsw/GKB2KLaUk70GraMlFlsU=
X-Google-Smtp-Source: ABdhPJzJj1kLxr190KCYKttqO/s/RjSXu5Y8/uQ2JaAEEOBkhzMqIRE3aBTTTUNNDm+TiIJXmC0YRG9Kg0g=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:5df1:77ea:c626:6f77])
 (user=weiwan job=sendgmr) by 2002:a05:6214:242f:: with SMTP id
 gy15mr1065261qvb.17.1615342836876; Tue, 09 Mar 2021 18:20:36 -0800 (PST)
Date:   Tue,  9 Mar 2021 18:20:35 -0800
Message-Id: <20210310022035.2908294-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH net v2] ipv6: fix suspecious RCU usage warning
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     syzbot <syzkaller@googlegroups.com>,
        David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        Petr Machata <petrm@nvidia.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported the suspecious RCU usage in nexthop_fib6_nh() when
called from ipv6_route_seq_show(). The reason is ipv6_route_seq_start()
calls rcu_read_lock_bh(), while nexthop_fib6_nh() calls
rcu_dereference_rtnl().
The fix proposed is to add a variant of nexthop_fib6_nh() to use
rcu_dereference_bh_rtnl() for ipv6_route_seq_show().

The reported trace is as follows:
./include/net/nexthop.h:416 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
2 locks held by syz-executor.0/17895:
     at: seq_read+0x71/0x12a0 fs/seq_file.c:169
     at: seq_file_net include/linux/seq_file_net.h:19 [inline]
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
Cc: Ido Schimmel <idosch@idosch.org>
Cc: Petr Machata <petrm@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>
---
 include/net/nexthop.h | 24 ++++++++++++++++++++++++
 net/ipv6/ip6_fib.c    |  2 +-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 7bc057aee40b..a10a319d7eb2 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -410,6 +410,7 @@ static inline struct fib_nh *fib_info_nh(struct fib_info *fi, int nhsel)
 int fib6_check_nexthop(struct nexthop *nh, struct fib6_config *cfg,
 		       struct netlink_ext_ack *extack);
 
+/* Caller should either hold rcu_read_lock(), or RTNL. */
 static inline struct fib6_nh *nexthop_fib6_nh(struct nexthop *nh)
 {
 	struct nh_info *nhi;
@@ -430,6 +431,29 @@ static inline struct fib6_nh *nexthop_fib6_nh(struct nexthop *nh)
 	return NULL;
 }
 
+/* Variant of nexthop_fib6_nh().
+ * Caller should either hold rcu_read_lock_bh(), or RTNL.
+ */
+static inline struct fib6_nh *nexthop_fib6_nh_bh(struct nexthop *nh)
+{
+	struct nh_info *nhi;
+
+	if (nh->is_group) {
+		struct nh_group *nh_grp;
+
+		nh_grp = rcu_dereference_bh_rtnl(nh->nh_grp);
+		nh = nexthop_mpath_select(nh_grp, 0);
+		if (!nh)
+			return NULL;
+	}
+
+	nhi = rcu_dereference_bh_rtnl(nh->nh_info);
+	if (nhi->family == AF_INET6)
+		return &nhi->fib6_nh;
+
+	return NULL;
+}
+
 static inline struct net_device *fib6_info_nh_dev(struct fib6_info *f6i)
 {
 	struct fib6_nh *fib6_nh;
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index ef9d022e693f..679699e953f1 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -2486,7 +2486,7 @@ static int ipv6_route_native_seq_show(struct seq_file *seq, void *v)
 	const struct net_device *dev;
 
 	if (rt->nh)
-		fib6_nh = nexthop_fib6_nh(rt->nh);
+		fib6_nh = nexthop_fib6_nh_bh(rt->nh);
 
 	seq_printf(seq, "%pi6 %02x ", &rt->fib6_dst.addr, rt->fib6_dst.plen);
 
-- 
2.30.1.766.gb4fecdf3b7-goog

