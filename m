Return-Path: <netdev+bounces-3723-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6977E7086FA
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 19:33:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 588541C2114B
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:33:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 860D027202;
	Thu, 18 May 2023 17:33:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EF9182B8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 17:33:24 +0000 (UTC)
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2670810CF;
	Thu, 18 May 2023 10:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1684431202; x=1715967202;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=X27rjAdYy0UAAB1FCDN/JcQU09RJNqGgbDasOPqrtgo=;
  b=KU7Y0BaJyWYeRvMZRXh14rFZWD+yZpMcDHVW8r/HVXZT4oklmghNSm4T
   ooIAUu059EjpVk50Y57AkoDr0BByqj0uwl8g8WxJVp8CaeSQLKWMjgHPY
   6J8eEsrn8TknssniAVetTWc/Ynljnfsdo2MDFgl716vAaNl7Gix4s9xZn
   M=;
X-IronPort-AV: E=Sophos;i="6.00,174,1681171200"; 
   d="scan'208";a="285727266"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 17:33:16 +0000
Received: from EX19MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
	by email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com (Postfix) with ESMTPS id 67EFC81337;
	Thu, 18 May 2023 17:33:14 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 18 May 2023 17:33:13 +0000
Received: from 88665a182662.ant.amazon.com (10.187.171.60) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 18 May 2023 17:33:11 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik
	<kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, syzkaller
	<syzkaller@googlegroups.com>
Subject: [PATCH v1 nf] netfilter: ipset: Add schedule point in call_ad().
Date: Thu, 18 May 2023 10:33:00 -0700
Message-ID: <20230518173300.34531-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.171.60]
X-ClientProxiedBy: EX19D044UWB004.ant.amazon.com (10.13.139.134) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

syzkaller found a repro that causes Hung Task [0] with ipset.  The repro
first creates an ipset and then tries to delete a large number of IPs
from the ipset concurrently:

  IPSET_ATTR_IPADDR_IPV4 : 172.20.20.187
  IPSET_ATTR_CIDR        : 2

The first deleting thread hogs a CPU with nfnl_lock(NFNL_SUBSYS_IPSET)
held, and other threads wait for it to be released.

Previously, the same issue existed in set->variant->uadt() that could run
so long under ip_set_lock(set).  Commit 5e29dc36bd5e ("netfilter: ipset:
Rework long task execution when adding/deleting entries") tried to fix it,
but the issue still exists in the caller with another mutex.

While adding/deleting many IPs, we should release the CPU periodically to
prevent someone from abusing ipset to hang the system.

Note we need to increment the ipset's refcnt to prevent the ipset from
being destroyed while rescheduling.

[0]:
INFO: task syz-executor174:268 blocked for more than 143 seconds.
      Not tainted 6.4.0-rc1-00145-gba79e9a73284 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor174 state:D stack:0     pid:268   ppid:260    flags:0x0000000d
Call trace:
 __switch_to+0x308/0x714 arch/arm64/kernel/process.c:556
 context_switch kernel/sched/core.c:5343 [inline]
 __schedule+0xd84/0x1648 kernel/sched/core.c:6669
 schedule+0xf0/0x214 kernel/sched/core.c:6745
 schedule_preempt_disabled+0x58/0xf0 kernel/sched/core.c:6804
 __mutex_lock_common kernel/locking/mutex.c:679 [inline]
 __mutex_lock+0x6fc/0xdb0 kernel/locking/mutex.c:747
 __mutex_lock_slowpath+0x14/0x20 kernel/locking/mutex.c:1035
 mutex_lock+0x98/0xf0 kernel/locking/mutex.c:286
 nfnl_lock net/netfilter/nfnetlink.c:98 [inline]
 nfnetlink_rcv_msg+0x480/0x70c net/netfilter/nfnetlink.c:295
 netlink_rcv_skb+0x1c0/0x350 net/netlink/af_netlink.c:2546
 nfnetlink_rcv+0x18c/0x199c net/netfilter/nfnetlink.c:658
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0x664/0x8cc net/netlink/af_netlink.c:1365
 netlink_sendmsg+0x6d0/0xa4c net/netlink/af_netlink.c:1913
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg net/socket.c:747 [inline]
 ____sys_sendmsg+0x4b8/0x810 net/socket.c:2503
 ___sys_sendmsg net/socket.c:2557 [inline]
 __sys_sendmsg+0x1f8/0x2a4 net/socket.c:2586
 __do_sys_sendmsg net/socket.c:2595 [inline]
 __se_sys_sendmsg net/socket.c:2593 [inline]
 __arm64_sys_sendmsg+0x80/0x94 net/socket.c:2593
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall+0x84/0x270 arch/arm64/kernel/syscall.c:52
 el0_svc_common+0x134/0x24c arch/arm64/kernel/syscall.c:142
 do_el0_svc+0x64/0x198 arch/arm64/kernel/syscall.c:193
 el0_svc+0x2c/0x7c arch/arm64/kernel/entry-common.c:637
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:591

Reported-by: syzkaller <syzkaller@googlegroups.com>
Fixes: a7b4f989a629 ("netfilter: ipset: IP set core support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/netfilter/ipset/ip_set_core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 46ebee9400da..9a6b64779e64 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1694,6 +1694,14 @@ call_ad(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 	bool eexist = flags & IPSET_FLAG_EXIST, retried = false;
 
 	do {
+		if (retried) {
+			__ip_set_get(set);
+			nfnl_unlock(NFNL_SUBSYS_IPSET);
+			cond_resched();
+			nfnl_lock(NFNL_SUBSYS_IPSET);
+			__ip_set_put(set);
+		}
+
 		ip_set_lock(set);
 		ret = set->variant->uadt(set, tb, adt, &lineno, flags, retried);
 		ip_set_unlock(set);
-- 
2.30.2


