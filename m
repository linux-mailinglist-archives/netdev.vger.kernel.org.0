Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEDE9E4E4E
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 16:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502981AbfJYOG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 10:06:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505138AbfJYNzq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 09:55:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3756D2084C;
        Fri, 25 Oct 2019 13:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011744;
        bh=vcEe/AZRcAACSEWJpKR8lWOXG7KeCano0noHAQBGTgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=giifTOcdoDpypXG6cgB+mrTsgkBCdeP9KL+HJUQ70nCrRrp8tzqPzviBxAlophz1+
         Ci3jbvDRV4gvguiwtShSY+WthCXHYfhMmCbBNTGOMFMLanMuELNXWGFZgCW8gAXh4l
         2Nn4aFbMihEGRLHFZ9oxLft/uVUw93CUN464Czxc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 25/33] net: sched: sch_htb: don't call qdisc_put() while holding tree lock
Date:   Fri, 25 Oct 2019 09:54:57 -0400
Message-Id: <20191025135505.24762-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135505.24762-1-sashal@kernel.org>
References: <20191025135505.24762-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

[ Upstream commit 4ce70b4aed5752332b268909336b351721965dc4 ]

Recent changes that removed rtnl dependency from rules update path of tc
also made tcf_block_put() function sleeping. This function is called from
ops->destroy() of several Qdisc implementations, which in turn is called by
qdisc_put(). Some Qdiscs call qdisc_put() while holding sch tree spinlock,
which results sleeping-while-atomic BUG.

Steps to reproduce for htb:

tc qdisc add dev ens1f0 root handle 1: htb default 12
tc class add dev ens1f0 parent 1: classid 1:1 htb rate 100kbps ceil 100kbps
tc qdisc add dev ens1f0 parent 1:1 handle 40: sfq perturb 10
tc class add dev ens1f0 parent 1:1 classid 1:2 htb rate 100kbps ceil 100kbps

Resulting dmesg:

[ 4791.148551] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:909
[ 4791.151354] in_atomic(): 1, irqs_disabled(): 0, pid: 27273, name: tc
[ 4791.152805] INFO: lockdep is turned off.
[ 4791.153605] CPU: 19 PID: 27273 Comm: tc Tainted: G        W         5.3.0-rc8+ #721
[ 4791.154336] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS 2.0b 03/30/2017
[ 4791.155075] Call Trace:
[ 4791.155803]  dump_stack+0x85/0xc0
[ 4791.156529]  ___might_sleep.cold+0xac/0xbc
[ 4791.157251]  __mutex_lock+0x5b/0x960
[ 4791.157966]  ? console_unlock+0x363/0x5d0
[ 4791.158676]  ? tcf_chain0_head_change_cb_del.isra.0+0x1b/0xf0
[ 4791.159395]  ? tcf_chain0_head_change_cb_del.isra.0+0x1b/0xf0
[ 4791.160103]  tcf_chain0_head_change_cb_del.isra.0+0x1b/0xf0
[ 4791.160815]  tcf_block_put_ext.part.0+0x21/0x50
[ 4791.161530]  tcf_block_put+0x50/0x70
[ 4791.162233]  sfq_destroy+0x15/0x50 [sch_sfq]
[ 4791.162936]  qdisc_destroy+0x5f/0x160
[ 4791.163642]  htb_change_class.cold+0x5df/0x69d [sch_htb]
[ 4791.164505]  tc_ctl_tclass+0x19d/0x480
[ 4791.165360]  rtnetlink_rcv_msg+0x170/0x4b0
[ 4791.166191]  ? netlink_deliver_tap+0x95/0x400
[ 4791.166907]  ? rtnl_dellink+0x2d0/0x2d0
[ 4791.167625]  netlink_rcv_skb+0x49/0x110
[ 4791.168345]  netlink_unicast+0x171/0x200
[ 4791.169058]  netlink_sendmsg+0x224/0x3f0
[ 4791.169771]  sock_sendmsg+0x5e/0x60
[ 4791.170475]  ___sys_sendmsg+0x2ae/0x330
[ 4791.171183]  ? ___sys_recvmsg+0x159/0x1f0
[ 4791.171894]  ? do_wp_page+0x9c/0x790
[ 4791.172595]  ? __handle_mm_fault+0xcd3/0x19e0
[ 4791.173309]  __sys_sendmsg+0x59/0xa0
[ 4791.174024]  do_syscall_64+0x5c/0xb0
[ 4791.174725]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 4791.175435] RIP: 0033:0x7f0aa41497b8
[ 4791.176129] Code: 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 65 8f 0c 00 8b 00 85 c0 75 17 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 48 83 ec 28 89 5
4
[ 4791.177532] RSP: 002b:00007fff4e37d588 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[ 4791.178243] RAX: ffffffffffffffda RBX: 000000005d8132f7 RCX: 00007f0aa41497b8
[ 4791.178947] RDX: 0000000000000000 RSI: 00007fff4e37d5f0 RDI: 0000000000000003
[ 4791.179662] RBP: 0000000000000000 R08: 0000000000000001 R09: 00000000020149a0
[ 4791.180382] R10: 0000000000404eda R11: 0000000000000246 R12: 0000000000000001
[ 4791.181100] R13: 000000000047f640 R14: 0000000000000000 R15: 0000000000000000

In htb_change_class() function save parent->leaf.q to local temporary
variable and put reference to it after sch tree lock is released in order
not to call potentially sleeping cls API in atomic section. This is safe to
do because Qdisc has already been reset by qdisc_purge_queue() inside sch
tree lock critical section.

Fixes: c266f64dbfa2 ("net: sched: protect block state with mutex")
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_htb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 7bcf20ef91453..8184c87da8bec 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1302,6 +1302,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 	struct htb_class *cl = (struct htb_class *)*arg, *parent;
 	struct nlattr *opt = tca[TCA_OPTIONS];
 	struct nlattr *tb[TCA_HTB_MAX + 1];
+	struct Qdisc *parent_qdisc = NULL;
 	struct tc_htb_opt *hopt;
 	u64 rate64, ceil64;
 	int warn = 0;
@@ -1401,7 +1402,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 		if (parent && !parent->level) {
 			/* turn parent into inner node */
 			qdisc_purge_queue(parent->leaf.q);
-			qdisc_put(parent->leaf.q);
+			parent_qdisc = parent->leaf.q;
 			if (parent->prio_activity)
 				htb_deactivate(q, parent);
 
@@ -1480,6 +1481,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 	cl->cbuffer = PSCHED_TICKS2NS(hopt->cbuffer);
 
 	sch_tree_unlock(sch);
+	qdisc_put(parent_qdisc);
 
 	if (warn)
 		pr_warn("HTB: quantum of class %X is %s. Consider r2q change.\n",
-- 
2.20.1

