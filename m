Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58BA41E864F
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 20:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbgE2SIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 14:08:54 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48242 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726970AbgE2SIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 14:08:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590775728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=i/xhfa5VHtL0mSk8pPfvKWEzNuRiKTPUhHh6X0LhSw8=;
        b=ZcsQICpVrTyZ3bK4IXrA3DdMUg9IVc6862NVl+9akpkPKSk0YQb0qIsSlxa+z7fykLYBMi
        pX2l9eCVZFst6JciyDEMp3uDaNuttNi2wN+JAfRXgtL7L86m6bAH54f/BFqsJ0YQlfBU6I
        xYfjA8RZ8SKyDq8e0Zindrkbqe1r8Ls=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-GCoKI7vLOMCKLIlKl-ToOw-1; Fri, 29 May 2020 14:08:46 -0400
X-MC-Unique: GCoKI7vLOMCKLIlKl-ToOw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B15B818FE861;
        Fri, 29 May 2020 18:08:45 +0000 (UTC)
Received: from new-host-5.redhat.com (unknown [10.40.193.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 584886ED97;
        Fri, 29 May 2020 18:08:44 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Po Liu <po.liu@nxp.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH net-next v2] net/sched: fix a couple of splats in the error path of tcf_gate_init()
Date:   Fri, 29 May 2020 20:08:38 +0200
Message-Id: <419fed9287c2b9abbb71cc96ac3253ef0074d63e.1590775205.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

trying to configure TC 'act_gate' rules with invalid control actions, the
following splat can be observed:

 # tc action add action gate index 42 clockid CLOCK_TAI goto chain 42

 general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] SMP KASAN NOPTI
 KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
 CPU: 1 PID: 2143 Comm: tc Not tainted 5.7.0-rc6+ #168
 Hardware name: Red Hat KVM, BIOS 1.11.1-4.module+el8.1.0+4066+0f1aadab 04/01/2014
 RIP: 0010:hrtimer_active+0x56/0x290
 [...]
  Call Trace:
  hrtimer_try_to_cancel+0x6d/0x330
  hrtimer_cancel+0x11/0x20
  tcf_gate_cleanup+0x15/0x30 [act_gate]
  tcf_action_cleanup+0x58/0x170
  __tcf_action_put+0xb0/0xe0
  __tcf_idr_release+0x68/0x90
  tcf_gate_init+0x7c7/0x19a0 [act_gate]
  tcf_action_init_1+0x60f/0x960
  tcf_action_init+0x157/0x2a0
  tcf_action_add+0xd9/0x2f0
  tc_ctl_action+0x2a3/0x39d
  rtnetlink_rcv_msg+0x5f3/0x920
  netlink_rcv_skb+0x121/0x350
  netlink_unicast+0x439/0x630
  netlink_sendmsg+0x714/0xbf0
  sock_sendmsg+0xe2/0x110
  ____sys_sendmsg+0x5b4/0x890
  ___sys_sendmsg+0xe9/0x160
  __sys_sendmsg+0xd3/0x170
  do_syscall_64+0x9a/0x370
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

this is caused by hrtimer_cancel(), running before hrtimer_init(). Fix it
ensuring to call hrtimer_cancel() only if clockid is valid, and the timer
has been initialized. After fixing this splat, the same error path causes
another problem:

 general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
 KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
 CPU: 1 PID: 980 Comm: tc Not tainted 5.7.0-rc6+ #168
 Hardware name: Red Hat KVM, BIOS 1.11.1-4.module+el8.1.0+4066+0f1aadab 04/01/2014
 RIP: 0010:release_entry_list+0x4a/0x240 [act_gate]
 [...]
 Call Trace:
  tcf_action_cleanup+0x58/0x170
  __tcf_action_put+0xb0/0xe0
  __tcf_idr_release+0x68/0x90
  tcf_gate_init+0x7ab/0x19a0 [act_gate]
  tcf_action_init_1+0x60f/0x960
  tcf_action_init+0x157/0x2a0
  tcf_action_add+0xd9/0x2f0
  tc_ctl_action+0x2a3/0x39d
  rtnetlink_rcv_msg+0x5f3/0x920
  netlink_rcv_skb+0x121/0x350
  netlink_unicast+0x439/0x630
  netlink_sendmsg+0x714/0xbf0
  sock_sendmsg+0xe2/0x110
  ____sys_sendmsg+0x5b4/0x890
  ___sys_sendmsg+0xe9/0x160
  __sys_sendmsg+0xd3/0x170
  do_syscall_64+0x9a/0x370
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

the problem is similar: tcf_action_cleanup() was trying to release a list
without initializing it first. Ensure that INIT_LIST_HEAD() is called for
every newly created 'act_gate' action, same as what was done to 'act_ife'
with commit 44c23d71599f ("net/sched: act_ife: initalize ife->metalist
earlier").

Changes since v1:
 - fix typo in the subject (tfc_gate_init->tcf_gate_init)
 - change commit message to include an example of command that triggers
   the error path of tcf_gate_init(). Suggested by Po Liu
 - assign 'gact' earlier to reduce usage of to_gate()

Fixes: a51c328df310 ("net: qos: introduce a gate control flow action")
CC: Ivan Vecera <ivecera@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/act_gate.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index 35fc48795541c..7ae2b188eac07 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -332,6 +332,12 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
 		return -EEXIST;
 	}
 
+	gact = to_gate(*a);
+	if (ret == ACT_P_CREATED) {
+		gact->param.tcfg_clockid = -1;
+		INIT_LIST_HEAD(&gact->param.entries);
+	}
+
 	if (tb[TCA_GATE_PRIORITY])
 		prio = nla_get_s32(tb[TCA_GATE_PRIORITY]);
 
@@ -366,8 +372,6 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
 	if (err < 0)
 		goto release_idr;
 
-	gact = to_gate(*a);
-
 	spin_lock_bh(&gact->tcf_lock);
 	p = &gact->param;
 
@@ -377,7 +381,6 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
 			goto chain_put;
 	}
 
-	INIT_LIST_HEAD(&p->entries);
 	if (tb[TCA_GATE_ENTRY_LIST]) {
 		err = parse_gate_list(tb[TCA_GATE_ENTRY_LIST], p, extack);
 		if (err < 0)
@@ -449,9 +452,9 @@ static void tcf_gate_cleanup(struct tc_action *a)
 	struct tcf_gate *gact = to_gate(a);
 	struct tcf_gate_params *p;
 
-	hrtimer_cancel(&gact->hitimer);
-
 	p = &gact->param;
+	if (p->tcfg_clockid != -1)
+		hrtimer_cancel(&gact->hitimer);
 
 	release_entry_list(&p->entries);
 }
-- 
2.26.2

