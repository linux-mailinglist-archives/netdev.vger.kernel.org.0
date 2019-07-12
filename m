Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 372ED6741C
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 19:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfGLRXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 13:23:03 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40586 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbfGLRXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 13:23:03 -0400
Received: by mail-wr1-f67.google.com with SMTP id r1so10722025wrl.7
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 10:23:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z0QpKbsBZ3Av0YGz5pPdhNb2i+Q1J5Cr4+PVRvJ8q8E=;
        b=AgyFYFs+XwUJStuZTxKIeTx2248uu8ibGQ8J8xiF9aDSaz0dwLxI23oqtshQTyJOqf
         1yCGvlz3E4iywq8qEIfZ3d2bYDD1Cp32r7vY1PMFJerE6XyqOnFnrWihzZn4S5sZ/Bx5
         yZ79VYaSlcfgmpBrEMbC+uk7e4fDu26lsdZZmgbjKB12hcZQQtddUT76M34Yiq9scLjc
         6yg4GLLErzOtyk+U9bnEP122aYWFd58/tQlwqC2Bt8hOTGbszfsSAPCxY6YYY/u9myX/
         8YValvt+DhGuAjuPTh1JeQHVCF2zxODw/n2sRHN6HkIXvbwsSQocZY3XEjpv6IviODgQ
         8TPA==
X-Gm-Message-State: APjAAAVeMF80hIBlu+NbSJ6Ua+WzQXh9rlp2hCRwBNalmXTSk5qF+Qlc
        Ulgb7X34yhMblgUW0b0KM2vj3xMabIM=
X-Google-Smtp-Source: APXvYqzCnhADtuMVgIALOqcodMDOOHUyXQZSkdOH3dtKw3vE/uXlzwlR7pWegYHNgNCF3ucimBPfKA==
X-Received: by 2002:adf:e446:: with SMTP id t6mr12921339wrm.115.1562952180450;
        Fri, 12 Jul 2019 10:23:00 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id j6sm8446849wrx.46.2019.07.12.10.22.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 12 Jul 2019 10:22:59 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, marek@cloudflare.com
Subject: [PATCH net] net: neigh: fix multiple neigh timer scheduling
Date:   Fri, 12 Jul 2019 19:22:51 +0200
Message-Id: <7b254317bcb84a33cdbe8eed96e510324d6eb97c.1562951883.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Neigh timer can be scheduled multiple times from userspace adding
multiple neigh entries and forcing the neigh timer scheduling passing
NTF_USE in the netlink requests.
This will result in a refcount leak and in the following dump stack:

[   32.465295] NEIGH: BUG, double timer add, state is 8
[   32.465308] CPU: 0 PID: 416 Comm: double_timer_ad Not tainted 5.2.0+ #65
[   32.465311] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.12.0-2.fc30 04/01/2014
[   32.465313] Call Trace:
[   32.465318]  dump_stack+0x7c/0xc0
[   32.465323]  __neigh_event_send+0x20c/0x880
[   32.465326]  ? ___neigh_create+0x846/0xfb0
[   32.465329]  ? neigh_lookup+0x2a9/0x410
[   32.465332]  ? neightbl_fill_info.constprop.0+0x800/0x800
[   32.465334]  neigh_add+0x4f8/0x5e0
[   32.465337]  ? neigh_xmit+0x620/0x620
[   32.465341]  ? find_held_lock+0x85/0xa0
[   32.465345]  rtnetlink_rcv_msg+0x204/0x570
[   32.465348]  ? rtnl_dellink+0x450/0x450
[   32.465351]  ? mark_held_locks+0x90/0x90
[   32.465354]  ? match_held_lock+0x1b/0x230
[   32.465357]  netlink_rcv_skb+0xc4/0x1d0
[   32.465360]  ? rtnl_dellink+0x450/0x450
[   32.465363]  ? netlink_ack+0x420/0x420
[   32.465366]  ? netlink_deliver_tap+0x115/0x560
[   32.465369]  ? __alloc_skb+0xc9/0x2f0
[   32.465372]  netlink_unicast+0x270/0x330
[   32.465375]  ? netlink_attachskb+0x2f0/0x2f0
[   32.465378]  netlink_sendmsg+0x34f/0x5a0
[   32.465381]  ? netlink_unicast+0x330/0x330
[   32.465385]  ? move_addr_to_kernel.part.0+0x20/0x20
[   32.465388]  ? netlink_unicast+0x330/0x330
[   32.465391]  sock_sendmsg+0x91/0xa0
[   32.465394]  ___sys_sendmsg+0x407/0x480
[   32.465397]  ? copy_msghdr_from_user+0x200/0x200
[   32.465401]  ? _raw_spin_unlock_irqrestore+0x37/0x40
[   32.465404]  ? lockdep_hardirqs_on+0x17d/0x250
[   32.465407]  ? __wake_up_common_lock+0xcb/0x110
[   32.465410]  ? __wake_up_common+0x230/0x230
[   32.465413]  ? netlink_bind+0x3e1/0x490
[   32.465416]  ? netlink_setsockopt+0x540/0x540
[   32.465420]  ? __fget_light+0x9c/0xf0
[   32.465423]  ? sockfd_lookup_light+0x8c/0xb0
[   32.465426]  __sys_sendmsg+0xa5/0x110
[   32.465429]  ? __ia32_sys_shutdown+0x30/0x30
[   32.465432]  ? __fd_install+0xe1/0x2c0
[   32.465435]  ? lockdep_hardirqs_off+0xb5/0x100
[   32.465438]  ? mark_held_locks+0x24/0x90
[   32.465441]  ? do_syscall_64+0xf/0x270
[   32.465444]  do_syscall_64+0x63/0x270
[   32.465448]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fix the issue unscheduling neigh_timer if selected entry is in 'IN_TIMER'
receiving a netlink request with NTF_USE flag set

Reported-by: Marek Majkowski <marek@cloudflare.com>
Fixes: 0c5c2d308906 ("neigh: Allow for user space users of the neighbour table")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 include/net/neighbour.h |  9 ++++++---
 net/core/neighbour.c    | 13 +++++++++----
 net/ipv4/route.c        |  2 +-
 net/sched/sch_teql.c    |  2 +-
 4 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 50a67bd6a434..5bc68bf03c3b 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -324,7 +324,8 @@ static inline struct neighbour *neigh_create(struct neigh_table *tbl,
 	return __neigh_create(tbl, pkey, dev, true);
 }
 void neigh_destroy(struct neighbour *neigh);
-int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb);
+int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb,
+		       bool unsched_timer);
 int neigh_update(struct neighbour *neigh, const u8 *lladdr, u8 new, u32 flags,
 		 u32 nlmsg_pid);
 void __neigh_set_probe_once(struct neighbour *neigh);
@@ -435,14 +436,16 @@ static inline struct neighbour * neigh_clone(struct neighbour *neigh)
 
 #define neigh_hold(n)	refcount_inc(&(n)->refcnt)
 
-static inline int neigh_event_send(struct neighbour *neigh, struct sk_buff *skb)
+static inline int neigh_event_send(struct neighbour *neigh,
+				   struct sk_buff *skb,
+				   bool unsched_timer)
 {
 	unsigned long now = jiffies;
 	
 	if (neigh->used != now)
 		neigh->used = now;
 	if (!(neigh->nud_state&(NUD_CONNECTED|NUD_DELAY|NUD_PROBE)))
-		return __neigh_event_send(neigh, skb);
+		return __neigh_event_send(neigh, skb, unsched_timer);
 	return 0;
 }
 
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 742cea4ce72e..687f67458187 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1104,7 +1104,8 @@ static void neigh_timer_handler(struct timer_list *t)
 	neigh_release(neigh);
 }
 
-int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb)
+int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb,
+		       bool unsched_timer)
 {
 	int rc;
 	bool immediate_probe = false;
@@ -1124,7 +1125,9 @@ int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb)
 
 			atomic_set(&neigh->probes,
 				   NEIGH_VAR(neigh->parms, UCAST_PROBES));
-			neigh->nud_state     = NUD_INCOMPLETE;
+			if (unsched_timer)
+				neigh_del_timer(neigh);
+			neigh->nud_state = NUD_INCOMPLETE;
 			neigh->updated = now;
 			next = now + max(NEIGH_VAR(neigh->parms, RETRANS_TIME),
 					 HZ/2);
@@ -1140,6 +1143,8 @@ int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb)
 		}
 	} else if (neigh->nud_state & NUD_STALE) {
 		neigh_dbg(2, "neigh %p is delayed\n", neigh);
+		if (unsched_timer)
+			neigh_del_timer(neigh);
 		neigh->nud_state = NUD_DELAY;
 		neigh->updated = jiffies;
 		neigh_add_timer(neigh, jiffies +
@@ -1469,7 +1474,7 @@ int neigh_resolve_output(struct neighbour *neigh, struct sk_buff *skb)
 {
 	int rc = 0;
 
-	if (!neigh_event_send(neigh, skb)) {
+	if (!neigh_event_send(neigh, skb, false)) {
 		int err;
 		struct net_device *dev = neigh->dev;
 		unsigned int seq;
@@ -1962,7 +1967,7 @@ static int neigh_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 		flags |= NEIGH_UPDATE_F_ISROUTER;
 
 	if (ndm->ndm_flags & NTF_USE) {
-		neigh_event_send(neigh, NULL);
+		neigh_event_send(neigh, NULL, true);
 		err = 0;
 	} else
 		err = __neigh_update(neigh, lladdr, ndm->ndm_state, flags,
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 517300d587a7..062fc7ad82f5 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -782,7 +782,7 @@ static void __ip_do_redirect(struct rtable *rt, struct sk_buff *skb, struct flow
 		n = neigh_create(&arp_tbl, &new_gw, rt->dst.dev);
 	if (!IS_ERR(n)) {
 		if (!(n->nud_state & NUD_VALID)) {
-			neigh_event_send(n, NULL);
+			neigh_event_send(n, NULL, false);
 		} else {
 			if (fib_lookup(net, fl4, &res, 0) == 0) {
 				struct fib_nh_common *nhc = FIB_RES_NHC(res);
diff --git a/net/sched/sch_teql.c b/net/sched/sch_teql.c
index 689ef6f3ded8..80646c07e7b7 100644
--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -234,7 +234,7 @@ __teql_resolve(struct sk_buff *skb, struct sk_buff *skb_res,
 		n = mn;
 	}
 
-	if (neigh_event_send(n, skb_res) == 0) {
+	if (neigh_event_send(n, skb_res, false) == 0) {
 		int err;
 		char haddr[MAX_ADDR_LEN];
 
-- 
2.21.0

