Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C390D1F5DC8
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 23:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgFJVnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 17:43:41 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27322 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726134AbgFJVnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 17:43:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591825418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P5+/L6ZP3RXYi+om0EKcHOkUMo8rvt3qclkrZsOGSkA=;
        b=XHK74gI38T+mX//dPyr/+JgK6Bo3XYhJ2CYbAmUehCqmlevNlie9f7mWczEv8k5FgvngY3
        w73DlotucocdtYjLZF9yJf6l8zmZXnaeiDsNndcrQzczzH0U1PIzacw+2d8zptHH7Y0lTj
        /9Gzu0+jzsBpcF3naQclmaaG7nHFV9o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-9dyvH2ozO7iY2hLOhj7Zog-1; Wed, 10 Jun 2020 17:43:36 -0400
X-MC-Unique: 9dyvH2ozO7iY2hLOhj7Zog-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD9FB8014D4;
        Wed, 10 Jun 2020 21:43:35 +0000 (UTC)
Received: from new-host-5.redhat.com (unknown [10.40.194.215])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75E5B10013D0;
        Wed, 10 Jun 2020 21:43:34 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Po Liu <Po.Liu@nxp.com>, Cong Wang <xiyou.wangcong@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net 1/2] net/sched: act_gate: fix NULL dereference in tcf_gate_init()
Date:   Wed, 10 Jun 2020 23:42:46 +0200
Message-Id: <14f86cd7e526126de65418c7eeee82d14a11ecba.1591824863.git.dcaratti@redhat.com>
In-Reply-To: <cover.1591824863.git.dcaratti@redhat.com>
References: <cover.1591824863.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

it is possible to see a KASAN use-after-free, immediately followed by a
NULL dereference crash, with the following command:

 # tc action add action gate index 3 cycle-time 100000000ns \
 > cycle-time-ext 100000000ns clockid CLOCK_TAI

 BUG: KASAN: use-after-free in tcf_action_init_1+0x8eb/0x960
 Write of size 1 at addr ffff88810a5908bc by task tc/883

 CPU: 0 PID: 883 Comm: tc Not tainted 5.7.0+ #188
 Hardware name: Red Hat KVM, BIOS 1.11.1-4.module+el8.1.0+4066+0f1aadab 04/01/2014
 Call Trace:
  dump_stack+0x75/0xa0
  print_address_description.constprop.6+0x1a/0x220
  kasan_report.cold.9+0x37/0x7c
  tcf_action_init_1+0x8eb/0x960
  tcf_action_init+0x157/0x2a0
  tcf_action_add+0xd9/0x2f0
  tc_ctl_action+0x2a3/0x39d
  rtnetlink_rcv_msg+0x5f3/0x920
  netlink_rcv_skb+0x120/0x380
  netlink_unicast+0x439/0x630
  netlink_sendmsg+0x714/0xbf0
  sock_sendmsg+0xe2/0x110
  ____sys_sendmsg+0x5b4/0x890
  ___sys_sendmsg+0xe9/0x160
  __sys_sendmsg+0xd3/0x170
  do_syscall_64+0x9a/0x370
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

[...]

 KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
 CPU: 0 PID: 883 Comm: tc Tainted: G    B             5.7.0+ #188
 Hardware name: Red Hat KVM, BIOS 1.11.1-4.module+el8.1.0+4066+0f1aadab 04/01/2014
 RIP: 0010:tcf_action_fill_size+0xa3/0xf0
 [....]
 RSP: 0018:ffff88813a48f250 EFLAGS: 00010212
 RAX: dffffc0000000000 RBX: 0000000000000094 RCX: ffffffffa47c3eb6
 RDX: 000000000000000e RSI: 0000000000000008 RDI: 0000000000000070
 RBP: ffff88810a590800 R08: 0000000000000004 R09: ffffed1027491e03
 R10: 0000000000000003 R11: ffffed1027491e03 R12: 0000000000000000
 R13: 0000000000000000 R14: dffffc0000000000 R15: ffff88810a590800
 FS:  00007f62cae8ce40(0000) GS:ffff888147c00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f62c9d20a10 CR3: 000000013a52a000 CR4: 0000000000340ef0
 Call Trace:
  tcf_action_init+0x172/0x2a0
  tcf_action_add+0xd9/0x2f0
  tc_ctl_action+0x2a3/0x39d
  rtnetlink_rcv_msg+0x5f3/0x920
  netlink_rcv_skb+0x120/0x380
  netlink_unicast+0x439/0x630
  netlink_sendmsg+0x714/0xbf0
  sock_sendmsg+0xe2/0x110
  ____sys_sendmsg+0x5b4/0x890
  ___sys_sendmsg+0xe9/0x160
  __sys_sendmsg+0xd3/0x170
  do_syscall_64+0x9a/0x370
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

this is caused by the test on 'cycletime_ext', that is still unassigned
when the action is newly created. This makes the action .init() return 0
without calling tcf_idr_insert(), hence the UAF + crash.

rework the logic that prevents zero values of cycle-time, as follows:

1) 'tcfg_cycletime_ext' seems to be unused in the action software path,
   and it was already possible by other means to obtain non-zero
   cycletime and zero cycletime-ext. So, removing that test should not
   cause any damage.
2) while at it, we must prevent overwriting configuration data with wrong
   ones: use a temporary variable for 'tcfg_cycletime', and validate it
   preserving the original semantic (that allowed computing the cycle
   time as the sum of all intervals, when not specified by
   TCA_GATE_CYCLE_TIME).
3) remove the test on 'tcfg_cycletime', no more useful, and avoid
   returning -EFAULT, which did not seem an appropriate return value for
   a wrong netlink attribute.

Fixes: a51c328df310 ("net: qos: introduce a gate control flow action")
CC: Ivan Vecera <ivecera@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/act_gate.c | 37 ++++++++++++++-----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index 9c628591f452..7d05f755d8fb 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -32,7 +32,7 @@ static ktime_t gate_get_time(struct tcf_gate *gact)
 	return KTIME_MAX;
 }
 
-static int gate_get_start_time(struct tcf_gate *gact, ktime_t *start)
+static void gate_get_start_time(struct tcf_gate *gact, ktime_t *start)
 {
 	struct tcf_gate_params *param = &gact->param;
 	ktime_t now, base, cycle;
@@ -43,18 +43,14 @@ static int gate_get_start_time(struct tcf_gate *gact, ktime_t *start)
 
 	if (ktime_after(base, now)) {
 		*start = base;
-		return 0;
+		return;
 	}
 
 	cycle = param->tcfg_cycletime;
 
-	/* cycle time should not be zero */
-	if (!cycle)
-		return -EFAULT;
-
 	n = div64_u64(ktime_sub_ns(now, base), cycle);
 	*start = ktime_add_ns(base, (n + 1) * cycle);
-	return 0;
+	return;
 }
 
 static void gate_start_timer(struct tcf_gate *gact, ktime_t start)
@@ -287,12 +283,12 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
 	enum tk_offsets tk_offset = TK_OFFS_TAI;
 	struct nlattr *tb[TCA_GATE_MAX + 1];
 	struct tcf_chain *goto_ch = NULL;
+	u64 cycletime, basetime = 0;
 	struct tcf_gate_params *p;
 	s32 clockid = CLOCK_TAI;
 	struct tcf_gate *gact;
 	struct tc_gate *parm;
 	int ret = 0, err;
-	u64 basetime = 0;
 	u32 gflags = 0;
 	s32 prio = -1;
 	ktime_t start;
@@ -375,11 +371,8 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
 	spin_lock_bh(&gact->tcf_lock);
 	p = &gact->param;
 
-	if (tb[TCA_GATE_CYCLE_TIME]) {
-		p->tcfg_cycletime = nla_get_u64(tb[TCA_GATE_CYCLE_TIME]);
-		if (!p->tcfg_cycletime_ext)
-			goto chain_put;
-	}
+	if (tb[TCA_GATE_CYCLE_TIME])
+		cycletime = nla_get_u64(tb[TCA_GATE_CYCLE_TIME]);
 
 	if (tb[TCA_GATE_ENTRY_LIST]) {
 		err = parse_gate_list(tb[TCA_GATE_ENTRY_LIST], p, extack);
@@ -387,14 +380,19 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
 			goto chain_put;
 	}
 
-	if (!p->tcfg_cycletime) {
+	if (!cycletime) {
 		struct tcfg_gate_entry *entry;
 		ktime_t cycle = 0;
 
 		list_for_each_entry(entry, &p->entries, list)
 			cycle = ktime_add_ns(cycle, entry->interval);
-		p->tcfg_cycletime = cycle;
+		cycletime = cycle;
+		if (!cycletime) {
+			err = -EINVAL;
+			goto chain_put;
+		}
 	}
+	p->tcfg_cycletime = cycletime;
 
 	if (tb[TCA_GATE_CYCLE_TIME_EXT])
 		p->tcfg_cycletime_ext =
@@ -408,14 +406,7 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
 	gact->tk_offset = tk_offset;
 	hrtimer_init(&gact->hitimer, clockid, HRTIMER_MODE_ABS_SOFT);
 	gact->hitimer.function = gate_timer_func;
-
-	err = gate_get_start_time(gact, &start);
-	if (err < 0) {
-		NL_SET_ERR_MSG(extack,
-			       "Internal error: failed get start time");
-		release_entry_list(&p->entries);
-		goto chain_put;
-	}
+	gate_get_start_time(gact, &start);
 
 	gact->current_close_time = start;
 	gact->current_gate_status = GATE_ACT_GATE_OPEN | GATE_ACT_PENDING;
-- 
2.26.2

