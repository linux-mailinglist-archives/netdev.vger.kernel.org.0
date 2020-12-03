Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254CE2CDDE9
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 19:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgLCSmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 13:42:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44140 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726012AbgLCSmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 13:42:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607020870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TluD/XEAy0Q1pToTptPMPKOSYfTEtC7R637L0g45Src=;
        b=ggp/x234IXllD6492T850A+5o5eoGtcGnwfl3PFMPzAlnsY9w46ZZqhfvwkZR6ueIbZJZn
        ziaatH+fnYVmtlzc+VsjB+W+QhEZVgBKBjOx/B4WUWXKfYzugLhZPmpD7VZL4gRisYocUa
        Lvr7ulxq+Bpv5FzKe7I1VyusS9MecPM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-AvIhTx8fPnuRzuofPedsuw-1; Thu, 03 Dec 2020 13:41:01 -0500
X-MC-Unique: AvIhTx8fPnuRzuofPedsuw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB381518A;
        Thu,  3 Dec 2020 18:40:59 +0000 (UTC)
Received: from new-host-6.station (unknown [10.40.192.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98DB960854;
        Thu,  3 Dec 2020 18:40:57 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Mohit Bhasi <mohitbhasi1998@gmail.com>,
        Leslie Monis <lesliemonis@gmail.com>
Subject: [PATCH net] net/sched: fq_pie: initialize timer earlier in fq_pie_init()
Date:   Thu,  3 Dec 2020 19:40:47 +0100
Message-Id: <2e78e01c504c633ebdff18d041833cf2e079a3a4.1607020450.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

with the following tdc testcase:

 83be: (qdisc, fq_pie) Create FQ-PIE with invalid number of flows

as fq_pie_init() fails, fq_pie_destroy() is called to clean up. Since the
timer is not yet initialized, it's possible to observe a splat like this:

  INFO: trying to register non-static key.
  the code is fine but needs lockdep annotation.
  turning off the locking correctness validator.
  CPU: 0 PID: 975 Comm: tc Not tainted 5.10.0-rc4+ #298
  Hardware name: Red Hat KVM, BIOS 1.11.1-4.module+el8.1.0+4066+0f1aadab 04/01/2014
  Call Trace:
   dump_stack+0x99/0xcb
   register_lock_class+0x12dd/0x1750
   __lock_acquire+0xfe/0x3970
   lock_acquire+0x1c8/0x7f0
   del_timer_sync+0x49/0xd0
   fq_pie_destroy+0x3f/0x80 [sch_fq_pie]
   qdisc_create+0x916/0x1160
   tc_modify_qdisc+0x3c4/0x1630
   rtnetlink_rcv_msg+0x346/0x8e0
   netlink_unicast+0x439/0x630
   netlink_sendmsg+0x719/0xbf0
   sock_sendmsg+0xe2/0x110
   ____sys_sendmsg+0x5ba/0x890
   ___sys_sendmsg+0xe9/0x160
   __sys_sendmsg+0xd3/0x170
   do_syscall_64+0x33/0x40
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  [...]
  ODEBUG: assert_init not available (active state 0) object type: timer_list hint: 0x0
  WARNING: CPU: 0 PID: 975 at lib/debugobjects.c:508 debug_print_object+0x162/0x210
  [...]
  Call Trace:
   debug_object_assert_init+0x268/0x380
   try_to_del_timer_sync+0x6a/0x100
   del_timer_sync+0x9e/0xd0
   fq_pie_destroy+0x3f/0x80 [sch_fq_pie]
   qdisc_create+0x916/0x1160
   tc_modify_qdisc+0x3c4/0x1630
   rtnetlink_rcv_msg+0x346/0x8e0
   netlink_rcv_skb+0x120/0x380
   netlink_unicast+0x439/0x630
   netlink_sendmsg+0x719/0xbf0
   sock_sendmsg+0xe2/0x110
   ____sys_sendmsg+0x5ba/0x890
   ___sys_sendmsg+0xe9/0x160
   __sys_sendmsg+0xd3/0x170
   do_syscall_64+0x33/0x40
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

fix it moving timer_setup() before any failure, like it was done on 'red'
with former commit 608b4adab178 ("net_sched: initialize timer earlier in
red_init()").

Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/sch_fq_pie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index 4dda15588cf4..949163fe68af 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -401,6 +401,7 @@ static int fq_pie_init(struct Qdisc *sch, struct nlattr *opt,
 
 	INIT_LIST_HEAD(&q->new_flows);
 	INIT_LIST_HEAD(&q->old_flows);
+	timer_setup(&q->adapt_timer, fq_pie_timer, 0);
 
 	if (opt) {
 		err = fq_pie_change(sch, opt, extack);
@@ -426,7 +427,6 @@ static int fq_pie_init(struct Qdisc *sch, struct nlattr *opt,
 		pie_vars_init(&flow->vars);
 	}
 
-	timer_setup(&q->adapt_timer, fq_pie_timer, 0);
 	mod_timer(&q->adapt_timer, jiffies + HZ / 2);
 
 	return 0;
-- 
2.28.0

