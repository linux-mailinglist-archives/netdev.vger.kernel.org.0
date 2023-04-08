Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1866DBC74
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 20:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbjDHSuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 14:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDHSuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 14:50:10 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D9861AA;
        Sat,  8 Apr 2023 11:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1680979809; x=1712515809;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dpTw7HrsmdgR8I65YONpwLZ5OMz/coIULOGGTT7JEEw=;
  b=MAJBzAGZqkbWAcDRLLtekwtfGcBD5LvgasqgRKJ4p5HEyBDwCNnDHV7n
   F0uDJXBkFNuUff0FN1favp7XGA+18f9uJEtSRNzQlzGio6L/tdPgbctSK
   poecQt9VFd2PU4j+GQsSpf4oXll0o7tO1IEW6OAqAqmI/0nLhVg8Y5wkU
   k=;
X-IronPort-AV: E=Sophos;i="5.98,329,1673913600"; 
   d="scan'208";a="202433039"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-7dc0ecf1.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2023 18:50:05 +0000
Received: from EX19MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-7dc0ecf1.us-east-1.amazon.com (Postfix) with ESMTPS id 873D680D8C;
        Sat,  8 Apr 2023 18:50:01 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Sat, 8 Apr 2023 18:49:57 +0000
Received: from 88665a182662.ant.amazon.com (10.187.171.41) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.26;
 Sat, 8 Apr 2023 18:49:54 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Jan Karcher <jaka@linux.ibm.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <syzbot+7e1e1bdb852961150198@syzkaller.appspotmail.com>
Subject: [PATCH v1 net] smc: Fix use-after-free in tcp_write_timer_handler().
Date:   Sat, 8 Apr 2023 11:49:43 -0700
Message-ID: <20230408184943.48136-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.171.41]
X-ClientProxiedBy: EX19D045UWC002.ant.amazon.com (10.13.139.230) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SPF_PERMERROR
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With Eric's ref tracker, syzbot finally found a repro for
use-after-free in tcp_write_timer_handler() by kernel TCP
sockets. [0]

If SMC creates a kernel socket in __smc_create(), the kernel
socket is supposed to be freed in smc_clcsock_release() by
calling sock_release() when we close() the parent SMC socket.

However, at the end of smc_clcsock_release(), the kernel
socket's sk_state might not be TCP_CLOSE.  This means that
we have not called inet_csk_destroy_sock() in __tcp_close()
and have not stopped the TCP timers.

The kernel socket's TCP timers can be fired later, so we
need to hold a refcnt for net as we do for MPTCP subflows
in mptcp_subflow_create_socket().

[0]:
leaked reference.
 sk_alloc (./include/net/net_namespace.h:335 net/core/sock.c:2108)
 inet_create (net/ipv4/af_inet.c:319 net/ipv4/af_inet.c:244)
 __sock_create (net/socket.c:1546)
 smc_create (net/smc/af_smc.c:3269 net/smc/af_smc.c:3284)
 __sock_create (net/socket.c:1546)
 __sys_socket (net/socket.c:1634 net/socket.c:1618 net/socket.c:1661)
 __x64_sys_socket (net/socket.c:1672)
 do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
==================================================================
BUG: KASAN: slab-use-after-free in tcp_write_timer_handler (net/ipv4/tcp_timer.c:378 net/ipv4/tcp_timer.c:624 net/ipv4/tcp_timer.c:594)
Read of size 1 at addr ffff888052b65e0d by task syzrepro/18091

CPU: 0 PID: 18091 Comm: syzrepro Tainted: G        W          6.3.0-rc4-01174-gb5d54eb5899a #7
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-1.amzn2022.0.1 04/01/2014
Call Trace:
 <IRQ>
 dump_stack_lvl (lib/dump_stack.c:107)
 print_report (mm/kasan/report.c:320 mm/kasan/report.c:430)
 kasan_report (mm/kasan/report.c:538)
 tcp_write_timer_handler (net/ipv4/tcp_timer.c:378 net/ipv4/tcp_timer.c:624 net/ipv4/tcp_timer.c:594)
 tcp_write_timer (./include/linux/spinlock.h:390 net/ipv4/tcp_timer.c:643)
 call_timer_fn (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:207 ./include/trace/events/timer.h:127 kernel/time/timer.c:1701)
 __run_timers.part.0 (kernel/time/timer.c:1752 kernel/time/timer.c:2022)
 run_timer_softirq (kernel/time/timer.c:2037)
 __do_softirq (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:207 ./include/trace/events/irq.h:142 kernel/softirq.c:572)
 __irq_exit_rcu (kernel/softirq.c:445 kernel/softirq.c:650)
 irq_exit_rcu (kernel/softirq.c:664)
 sysvec_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:1107 (discriminator 14))
 </IRQ>

Fixes: ac7138746e14 ("smc: establish new socket family")
Reported-by: syzbot+7e1e1bdb852961150198@syzkaller.appspotmail.com
Link: https://lore.kernel.org/netdev/000000000000a3f51805f8bcc43a@google.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/smc/af_smc.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index c6b4a62276f6..50c38b624f77 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -3270,6 +3270,17 @@ static int __smc_create(struct net *net, struct socket *sock, int protocol,
 			sk_common_release(sk);
 			goto out;
 		}
+
+		/* smc_clcsock_release() does not wait smc->clcsock->sk's
+		 * destruction;  its sk_state might not be TCP_CLOSE after
+		 * smc->sk is close()d, and TCP timers can be fired later,
+		 * which need net ref.
+		 */
+		sk = smc->clcsock->sk;
+		__netns_tracker_free(net, &sk->ns_tracker, false);
+		sk->sk_net_refcnt = 1;
+		get_net_track(net, &sk->ns_tracker, GFP_KERNEL);
+		sock_inuse_add(net, 1);
 	} else {
 		smc->clcsock = clcsock;
 	}
-- 
2.30.2

