Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7982D3621F4
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 16:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244490AbhDPOQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 10:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235928AbhDPOQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 10:16:42 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DD5C061574
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 07:16:18 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id u7so12240613plr.6
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 07:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7gMrKgGVITOj4mPMWCs2xYSh5YM48I4HyRKXIedFq8c=;
        b=lf0dlNMaQc/b4u834UshwnzoTnmG9hvzFf5dOk1yuZ6sRxM/+1c8LDx+/raCKcYmEb
         9SLQigbgs7Hs1B0ujRX1+bKWPzbhy3CvCdnh+oU9VPnA5sGL5FmzLFP957EIdoQKpPfT
         kdtxJj+Pwp74zUxnSzdHyi1+/FM4h+CqQlVrPGFhTZLEEHXFrpP775/Z8AG4mTwFAnOk
         xYUmSrc4L7Qaf/XwTfyTw0zTvcSd0vsKhS8W7NEH7CuA8J6eJxh0mt/R9HEk/B80zejB
         giOQhWL4znvToatO/ZAPX3PbU2BTdAkOJJVd0hTM4h9LLT/0QJrUVhbKzySALYVfyfp3
         yseA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7gMrKgGVITOj4mPMWCs2xYSh5YM48I4HyRKXIedFq8c=;
        b=GfosWb1lV0m2ESeUeYvIDZ+wnbRYd6zOUPP8aoFJbeZYPddX4ASFii6WVwtdRcVidf
         JfHbNXKY2YUH30H9cTLf/Z8e2ps9MYDDWpxbt0sOkddw7jCPEli4Xjb1KZXJJNRm6IpV
         whj3ZIU/MO9X49TRqY1VibgzEvEK9ZVBNfFktZAo4DahKNGOLBOLc1axTFcJNJblJ4fX
         4oa9+Icdhdtu/N50AL9u6fGi3NZ/RyQ0r4j4TmLzAk4duzi6G8bncw1ruhabpQASk809
         uHnvXoQ7ahGsAqMG17ukEzhwrGxLjrB+I4pgxKaUwJko1XL7ZJsF5HUicHxlFlUKgD3t
         JjNA==
X-Gm-Message-State: AOAM533xfrwXd8r1wjrOQNTknBxFbHj9yR0EBGyWMGC32H+zxMXLUW6l
        cv+JBVCWwkEZ+FDfvcyAsII=
X-Google-Smtp-Source: ABdhPJyEY5Lh5TgwIDrdhJHw/fd3babC9q0CelJUTqOqukXroSqbUAx2fuzHGM4s2ALclOYN7gG90A==
X-Received: by 2002:a17:90a:ff02:: with SMTP id ce2mr10045242pjb.217.1618582577956;
        Fri, 16 Apr 2021 07:16:17 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id ms9sm6257938pjb.32.2021.04.16.07.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 07:16:17 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dsahern@kernel.org, yoshfuji@linux-ipv6.org, edumazet@google.com
Cc:     ap420073@gmail.com
Subject: [PATCH net-next] mld: fix suspicious RCU usage in __ipv6_dev_mc_dec()
Date:   Fri, 16 Apr 2021 14:16:06 +0000
Message-Id: <20210416141606.24029-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__ipv6_dev_mc_dec() internally uses sleepable functions so that caller
must not acquire atomic locks. But caller, which is addrconf_verify_rtnl()
acquires rcu_read_lock_bh().
So this warning occurs in the __ipv6_dev_mc_dec().

Test commands:
    ip netns add A
    ip link add veth0 type veth peer name veth1
    ip link set veth1 netns A
    ip link set veth0 up
    ip netns exec A ip link set veth1 up
    ip a a 2001:db8::1/64 dev veth0 valid_lft 2 preferred_lft 1

Splat looks like:
============================
WARNING: suspicious RCU usage
5.12.0-rc6+ #515 Not tainted
-----------------------------
kernel/sched/core.c:8294 Illegal context switch in RCU-bh read-side
critical section!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
4 locks held by kworker/4:0/1997:
 #0: ffff88810bd72d48 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at:
process_one_work+0x761/0x1440
 #1: ffff888105c8fe00 ((addr_chk_work).work){+.+.}-{0:0}, at:
process_one_work+0x795/0x1440
 #2: ffffffffb9279fb0 (rtnl_mutex){+.+.}-{3:3}, at:
addrconf_verify_work+0xa/0x20
 #3: ffffffffb8e30860 (rcu_read_lock_bh){....}-{1:2}, at:
addrconf_verify_rtnl+0x23/0xc60

stack backtrace:
CPU: 4 PID: 1997 Comm: kworker/4:0 Not tainted 5.12.0-rc6+ #515
Workqueue: ipv6_addrconf addrconf_verify_work
Call Trace:
 dump_stack+0xa4/0xe5
 ___might_sleep+0x27d/0x2b0
 __mutex_lock+0xc8/0x13f0
 ? lock_downgrade+0x690/0x690
 ? __ipv6_dev_mc_dec+0x49/0x2a0
 ? mark_held_locks+0xb7/0x120
 ? mutex_lock_io_nested+0x1270/0x1270
 ? lockdep_hardirqs_on_prepare+0x12c/0x3e0
 ? _raw_spin_unlock_irqrestore+0x47/0x50
 ? trace_hardirqs_on+0x41/0x120
 ? __wake_up_common_lock+0xc9/0x100
 ? __wake_up_common+0x620/0x620
 ? memset+0x1f/0x40
 ? netlink_broadcast_filtered+0x2c4/0xa70
 ? __ipv6_dev_mc_dec+0x49/0x2a0
 __ipv6_dev_mc_dec+0x49/0x2a0
 ? netlink_broadcast_filtered+0x2f6/0xa70
 addrconf_leave_solict.part.64+0xad/0xf0
 ? addrconf_join_solict.part.63+0xf0/0xf0
 ? nlmsg_notify+0x63/0x1b0
 __ipv6_ifa_notify+0x22c/0x9c0
 ? inet6_fill_ifaddr+0xbe0/0xbe0
 ? lockdep_hardirqs_on_prepare+0x12c/0x3e0
 ? __local_bh_enable_ip+0xa5/0xf0
 ? ipv6_del_addr+0x347/0x870
 ipv6_del_addr+0x3b1/0x870
 ? addrconf_ifdown+0xfe0/0xfe0
 ? rcu_read_lock_any_held.part.27+0x20/0x20
 addrconf_verify_rtnl+0x8a9/0xc60
 addrconf_verify_work+0xf/0x20
 process_one_work+0x84c/0x1440

In order to avoid this problem, it uses rcu_read_unlock_bh() for
a short time. RCU is used for avoiding freeing
ifp(struct *inet6_ifaddr) while ifp is being used. But this will
not be released even if rcu_read_unlock_bh() is used.
Because before rcu_read_unlock_bh(), it uses in6_ifa_hold(ifp).
So this is safe.

Fixes: 63ed8de4be81 ("mld: add mc_lock for protecting per-interface mld data")
Suggested-by: Eric Dumazet <edumazet@google.com>
Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

Target banch is "net-next" although it has a fix tag because
the commit 63ed8de4be81
("mld: add mc_lock for protecting per-interface mld data") is not yet
merged to net branch. So, the target branch is net-next.

 net/ipv6/addrconf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index dbb5bb9269bb..b0ef65eb9bd2 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4485,7 +4485,9 @@ static void addrconf_verify_rtnl(void)
 			    age >= ifp->valid_lft) {
 				spin_unlock(&ifp->lock);
 				in6_ifa_hold(ifp);
+				rcu_read_unlock_bh();
 				ipv6_del_addr(ifp);
+				rcu_read_lock_bh();
 				goto restart;
 			} else if (ifp->prefered_lft == INFINITY_LIFE_TIME) {
 				spin_unlock(&ifp->lock);
-- 
2.17.1

