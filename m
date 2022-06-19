Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFAC5507C2
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 02:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiFSAjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 20:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiFSAjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 20:39:40 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05171056D;
        Sat, 18 Jun 2022 17:39:37 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 01BD420003;
        Sun, 19 Jun 2022 00:39:33 +0000 (UTC)
From:   Ilya Maximets <i.maximets@ovn.org>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Ilya Maximets <i.maximets@ovn.org>
Subject: [PATCH net] net: ensure all external references are released in deferred skbuffs
Date:   Sun, 19 Jun 2022 02:39:19 +0200
Message-Id: <20220619003919.394622-1-i.maximets@ovn.org>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Open vSwitch system test suite is broken due to inability to
load/unload netfilter modules.  kworker thread is getting trapped
in the infinite loop while running a net cleanup inside the
nf_conntrack_cleanup_net_list, because deferred skbuffs are still
holding nfct references and not being freed by their CPU cores.

In general, the idea that we will have an rx interrupt on every
CPU core at some point in a near future doesn't seem correct.
Devices are getting created and destroyed, interrupts are getting
re-scheduled, CPUs are going online and offline dynamically.
Any of these events may leave packets stuck in defer list for a
long time.  It might be OK, if they are just a piece of memory,
but we can't afford them holding references to any other resources.

In case of OVS, nfct reference keeps the kernel thread in busy loop
while holding a 'pernet_ops_rwsem' semaphore.  That blocks the
later modprobe request from user space:

  # ps
   299 root  R  99.3  200:25.89 kworker/u96:4+

  # journalctl
  INFO: task modprobe:11787 blocked for more than 1228 seconds.
        Not tainted 5.19.0-rc2 #8
  task:modprobe     state:D
  Call Trace:
   <TASK>
   __schedule+0x8aa/0x21d0
   schedule+0xcc/0x200
   rwsem_down_write_slowpath+0x8e4/0x1580
   down_write+0xfc/0x140
   register_pernet_subsys+0x15/0x40
   nf_nat_init+0xb6/0x1000 [nf_nat]
   do_one_initcall+0xbb/0x410
   do_init_module+0x1b4/0x640
   load_module+0x4c1b/0x58d0
   __do_sys_init_module+0x1d7/0x220
   do_syscall_64+0x3a/0x80
   entry_SYSCALL_64_after_hwframe+0x46/0xb0

At this point OVS testsuite is unresponsive and never recover,
because these skbuffs are never freed.

Solution is to make sure no external references attached to skb
before pushing it to the defer list.  Using skb_release_head_state()
for that purpose.  The function modified to be re-enterable, as it
will be called again during the defer list flush.

Another approach that can fix the OVS use-case, is to kick all
cores while waiting for references to be released during the net
cleanup.  But that sounds more like a workaround for a current
issue rather than a proper solution and will not cover possible
issues in other parts of the code.

Additionally checking for skb_zcopy() while deferring.  This might
not be necessary, as I'm not sure if we can actually have zero copy
packets on this path, but seems worth having for completeness as we
should never defer such packets regardless.

CC: Eric Dumazet <edumazet@google.com>
Fixes: 68822bdf76f1 ("net: generalize skb freeing deferral to per-cpu lists")
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
---
 net/core/skbuff.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 5b3559cb1d82..5660250e795f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -726,11 +726,9 @@ void skb_release_head_state(struct sk_buff *skb)
 	skb_dst_drop(skb);
 	if (skb->destructor) {
 		WARN_ON(in_hardirq());
-		skb->destructor(skb);
+		skb_orphan(skb);
 	}
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
-	nf_conntrack_put(skb_nfct(skb));
-#endif
+	nf_reset_ct(skb);
 	skb_ext_put(skb);
 }
 
@@ -6502,7 +6500,8 @@ void skb_attempt_defer_free(struct sk_buff *skb)
 
 	if (WARN_ON_ONCE(cpu >= nr_cpu_ids) ||
 	    !cpu_online(cpu) ||
-	    cpu == raw_smp_processor_id()) {
+	    cpu == raw_smp_processor_id() ||
+	    skb_zcopy(skb)) {
 nodefer:	__kfree_skb(skb);
 		return;
 	}
@@ -6512,6 +6511,13 @@ nodefer:	__kfree_skb(skb);
 	if (READ_ONCE(sd->defer_count) >= defer_max)
 		goto nodefer;
 
+	/* skb can contain all kinds of external references that
+	 * will prevent module unloading or destruction of other
+	 * resources.  Need to release them now, since skb can
+	 * stay on a defer list indefinitely.
+	 */
+	skb_release_head_state(skb);
+
 	spin_lock_irqsave(&sd->defer_lock, flags);
 	/* Send an IPI every time queue reaches half capacity. */
 	kick = sd->defer_count == (defer_max >> 1);
-- 
2.34.3

