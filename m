Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF195FC7BD
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 16:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiJLOvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 10:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiJLOvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 10:51:18 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303661B7B8
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 07:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665586277; x=1697122277;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wA+4xA37EIdsuP2sL0qtmsrAFV14JVy9iO4ckk8jYB8=;
  b=vL05n+UHtKq1Wpibx826XIr3nmcrtCklpKGo+SxCn7Rn2OTcS2qla35z
   CVMaJAuxoYObTRIKXwLD3yHw9GpaF9VYHqa/TOZhvAdHZi9ShrbhJ7is6
   y55gzA7bahM1cI2LBPxCYvqpvt+xye5syFg8fKgaKfD4aVAqbqrkntl9p
   s=;
X-IronPort-AV: E=Sophos;i="5.95,179,1661817600"; 
   d="scan'208";a="254679679"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-2d7489a4.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2022 14:51:05 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-2d7489a4.us-east-1.amazon.com (Postfix) with ESMTPS id 5043585188;
        Wed, 12 Oct 2022 14:51:03 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Wed, 12 Oct 2022 14:51:02 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.111) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Wed, 12 Oct 2022 14:50:57 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, syzbot <syzkaller@googlegroups.com>
Subject: [PATCH v1 net] tcp: Clean up kernel listener's reqsk in inet_twsk_purge()
Date:   Wed, 12 Oct 2022 07:50:36 -0700
Message-ID: <20221012145036.74960-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.111]
X-ClientProxiedBy: EX13D37UWC004.ant.amazon.com (10.43.162.212) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet reported a use-after-free related to the per-netns ehash
series. [0]

When we create a TCP socket from userspace, the socket always holds a
refcnt of the netns.  This guarantees that a reqsk timer is always fired
before netns dismantle.  Each reqsk has a refcnt of its listener, so the
listener is not freed before the reqsk, and the net is not freed before
the listener as well.

OTOH, when in-kernel users create a TCP socket, it might not hold a refcnt
of its netns.  Thus, a reqsk timer can be fired after the netns dismantle
and access freed per-netns ehash.

To avoid the use-after-free, we need to clean up TCP_NEW_SYN_RECV sockets
in inet_twsk_purge() if the netns uses a per-netns ehash.

[0]: https://lore.kernel.org/netdev/CANn89iLXMup0dRD_Ov79Xt8N9FM0XdhCHEN05sf3eLwxKweM6w@mail.gmail.com/

BUG: KASAN: use-after-free in tcp_or_dccp_get_hashinfo
include/net/inet_hashtables.h:181 [inline]
BUG: KASAN: use-after-free in reqsk_queue_unlink+0x320/0x350
net/ipv4/inet_connection_sock.c:913
Read of size 8 at addr ffff88807545bd80 by task syz-executor.2/8301

CPU: 1 PID: 8301 Comm: syz-executor.2 Not tainted
6.0.0-syzkaller-02757-gaf7d23f9d96a #0
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 09/22/2022
Call Trace:
<IRQ>
__dump_stack lib/dump_stack.c:88 [inline]
dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
print_address_description mm/kasan/report.c:317 [inline]
print_report.cold+0x2ba/0x719 mm/kasan/report.c:433
kasan_report+0xb1/0x1e0 mm/kasan/report.c:495
tcp_or_dccp_get_hashinfo include/net/inet_hashtables.h:181 [inline]
reqsk_queue_unlink+0x320/0x350 net/ipv4/inet_connection_sock.c:913
inet_csk_reqsk_queue_drop net/ipv4/inet_connection_sock.c:927 [inline]
inet_csk_reqsk_queue_drop_and_put net/ipv4/inet_connection_sock.c:939 [inline]
reqsk_timer_handler+0x724/0x1160 net/ipv4/inet_connection_sock.c:1053
call_timer_fn+0x1a0/0x6b0 kernel/time/timer.c:1474
expire_timers kernel/time/timer.c:1519 [inline]
__run_timers.part.0+0x674/0xa80 kernel/time/timer.c:1790
__run_timers kernel/time/timer.c:1768 [inline]
run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1803
__do_softirq+0x1d0/0x9c8 kernel/softirq.c:571
invoke_softirq kernel/softirq.c:445 [inline]
__irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1107
</IRQ>

Fixes: d1e5e6408b30 ("tcp: Introduce optional per-netns ehash.")
Reported-by: syzbot <syzkaller@googlegroups.com>
Reported-by: Eric Dumazet <edumazet@google.com>
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/inet_timewait_sock.c | 15 ++++++++++++++-
 net/ipv4/tcp_minisocks.c      |  9 +++++----
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index 71d3bb0abf6c..66fc940f9521 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -268,8 +268,21 @@ void inet_twsk_purge(struct inet_hashinfo *hashinfo, int family)
 		rcu_read_lock();
 restart:
 		sk_nulls_for_each_rcu(sk, node, &head->chain) {
-			if (sk->sk_state != TCP_TIME_WAIT)
+			if (sk->sk_state != TCP_TIME_WAIT) {
+				/* A kernel listener socket might not hold refcnt for net,
+				 * so reqsk_timer_handler() could be fired after net is
+				 * freed.  Userspace listener and reqsk never exist here.
+				 */
+				if (unlikely(sk->sk_state == TCP_NEW_SYN_RECV &&
+					     hashinfo->pernet)) {
+					struct request_sock *req = inet_reqsk(sk);
+
+					inet_csk_reqsk_queue_drop_and_put(req->rsk_listener, req);
+				}
+
 				continue;
+			}
+
 			tw = inet_twsk(sk);
 			if ((tw->tw_family != family) ||
 				refcount_read(&twsk_net(tw)->ns.count))
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 79f30f026d89..c375f603a16c 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -353,13 +353,14 @@ void tcp_twsk_purge(struct list_head *net_exit_list, int family)
 	struct net *net;
 
 	list_for_each_entry(net, net_exit_list, exit_list) {
-		/* The last refcount is decremented in tcp_sk_exit_batch() */
-		if (refcount_read(&net->ipv4.tcp_death_row.tw_refcount) == 1)
-			continue;
-
 		if (net->ipv4.tcp_death_row.hashinfo->pernet) {
+			/* Even if tw_refcount == 1, we must clean up kernel reqsk */
 			inet_twsk_purge(net->ipv4.tcp_death_row.hashinfo, family);
 		} else if (!purged_once) {
+			/* The last refcount is decremented in tcp_sk_exit_batch() */
+			if (refcount_read(&net->ipv4.tcp_death_row.tw_refcount) == 1)
+				continue;
+
 			inet_twsk_purge(&tcp_hashinfo, family);
 			purged_once = true;
 		}
-- 
2.30.2

