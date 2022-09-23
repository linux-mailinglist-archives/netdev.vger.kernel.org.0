Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670FA5E7DFF
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbiIWPN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiIWPNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:13:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DB8133CAD
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 08:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663945998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=AC2WpCfsE1+B2yfXj3DDXdMXskgczghPG3XqPoy/a+o=;
        b=gMOGXfG2Mmy5iEq4rBKG5NSu4SH/B9d8GAHEaPAjfzs3JCqRTkcEjhvayor/5MnmyOGLot
        i90e3D5xir/D0eH/2kp9o6m6uA15H1c1hNGxyBFx+0vSYFA9NxR3Jteub88pi6nBdT0kSb
        s80OTqg6aNjQRosejdOyT1oLSHHlvME=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-gZQAf_tqP6GmdG7dfHrPOQ-1; Fri, 23 Sep 2022 11:13:17 -0400
X-MC-Unique: gZQAf_tqP6GmdG7dfHrPOQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BC4E101E155;
        Fri, 23 Sep 2022 15:13:15 +0000 (UTC)
Received: from dcaratti.users.ipa.redhat.com (unknown [10.40.194.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14B3C2166B30;
        Fri, 23 Sep 2022 15:13:13 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Paolo Abeni <pabeni@redhat.com>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        wizhao@redhat.com, netdev@vger.kernel.org
Subject: [PATCH net] net/sched: act_mirred: use the backlog for mirred ingress
Date:   Fri, 23 Sep 2022 17:11:12 +0200
Message-Id: <33dc43f587ec1388ba456b4915c75f02a8aae226.1663945716.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

William reports kernel soft-lockups on some OVS topologies when TC mirred
"egress-to-ingress" action is hit by local TCP traffic. Indeed, using the
mirred action in egress-to-ingress can easily produce a dmesg splat like:

 ============================================
 WARNING: possible recursive locking detected
 6.0.0-rc4+ #511 Not tainted
 --------------------------------------------
 nc/1037 is trying to acquire lock:
 ffff950687843cb0 (slock-AF_INET/1){+.-.}-{2:2}, at: tcp_v4_rcv+0x1023/0x1160

 but task is already holding lock:
 ffff950687846cb0 (slock-AF_INET/1){+.-.}-{2:2}, at: tcp_v4_rcv+0x1023/0x1160

 other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(slock-AF_INET/1);
   lock(slock-AF_INET/1);

  *** DEADLOCK ***

  May be due to missing lock nesting notation

 12 locks held by nc/1037:
  #0: ffff950687843d40 (sk_lock-AF_INET){+.+.}-{0:0}, at: tcp_sendmsg+0x19/0x40
  #1: ffffffff9be07320 (rcu_read_lock){....}-{1:2}, at: __ip_queue_xmit+0x5/0x610
  #2: ffffffff9be072e0 (rcu_read_lock_bh){....}-{1:2}, at: ip_finish_output2+0xaa/0xa10
  #3: ffffffff9be072e0 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x72/0x11b0
  #4: ffffffff9be07320 (rcu_read_lock){....}-{1:2}, at: netif_receive_skb+0x181/0x400
  #5: ffffffff9be07320 (rcu_read_lock){....}-{1:2}, at: ip_local_deliver_finish+0x54/0x160
  #6: ffff950687846cb0 (slock-AF_INET/1){+.-.}-{2:2}, at: tcp_v4_rcv+0x1023/0x1160
  #7: ffffffff9be07320 (rcu_read_lock){....}-{1:2}, at: __ip_queue_xmit+0x5/0x610
  #8: ffffffff9be072e0 (rcu_read_lock_bh){....}-{1:2}, at: ip_finish_output2+0xaa/0xa10
  #9: ffffffff9be072e0 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x72/0x11b0
  #10: ffffffff9be07320 (rcu_read_lock){....}-{1:2}, at: netif_receive_skb+0x181/0x400
  #11: ffffffff9be07320 (rcu_read_lock){....}-{1:2}, at: ip_local_deliver_finish+0x54/0x160

 stack backtrace:
 CPU: 1 PID: 1037 Comm: nc Not tainted 6.0.0-rc4+ #511
 Hardware name: Red Hat KVM, BIOS 1.13.0-2.module+el8.3.0+7353+9de0a3cc 04/01/2014
 Call Trace:
  <TASK>
  dump_stack_lvl+0x44/0x5b
  __lock_acquire.cold.76+0x121/0x2a7
  lock_acquire+0xd5/0x310
  _raw_spin_lock_nested+0x39/0x70
  tcp_v4_rcv+0x1023/0x1160
  ip_protocol_deliver_rcu+0x4d/0x280
  ip_local_deliver_finish+0xac/0x160
  ip_local_deliver+0x71/0x220
  ip_rcv+0x5a/0x200
  __netif_receive_skb_one_core+0x89/0xa0
  netif_receive_skb+0x1c1/0x400
  tcf_mirred_act+0x2a5/0x610 [act_mirred]
  tcf_action_exec+0xb3/0x210
  fl_classify+0x1f7/0x240 [cls_flower]
  tcf_classify+0x7b/0x320
  __dev_queue_xmit+0x3a4/0x11b0
  ip_finish_output2+0x3b8/0xa10
  ip_output+0x7f/0x260
  __ip_queue_xmit+0x1ce/0x610
  __tcp_transmit_skb+0xabc/0xc80
  tcp_rcv_state_process+0x669/0x1290
  tcp_v4_do_rcv+0xd7/0x370
  tcp_v4_rcv+0x10bc/0x1160
  ip_protocol_deliver_rcu+0x4d/0x280
  ip_local_deliver_finish+0xac/0x160
  ip_local_deliver+0x71/0x220
  ip_rcv+0x5a/0x200
  __netif_receive_skb_one_core+0x89/0xa0
  netif_receive_skb+0x1c1/0x400
  tcf_mirred_act+0x2a5/0x610 [act_mirred]
  tcf_action_exec+0xb3/0x210
  fl_classify+0x1f7/0x240 [cls_flower]
  tcf_classify+0x7b/0x320
  __dev_queue_xmit+0x3a4/0x11b0
  ip_finish_output2+0x3b8/0xa10
  ip_output+0x7f/0x260
  __ip_queue_xmit+0x1ce/0x610
  __tcp_transmit_skb+0xabc/0xc80
  tcp_write_xmit+0x229/0x12c0
  __tcp_push_pending_frames+0x32/0xf0
  tcp_sendmsg_locked+0x297/0xe10
  tcp_sendmsg+0x27/0x40
  sock_sendmsg+0x58/0x70
  __sys_sendto+0xfd/0x170
  __x64_sys_sendto+0x24/0x30
  do_syscall_64+0x3a/0x90
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
 RIP: 0033:0x7f11a06fd281
 Code: 00 00 00 00 0f 1f 44 00 00 f3 0f 1e fa 48 8d 05 e5 43 2c 00 41 89 ca 8b 00 85 c0 75 1c 45 31 c9 45 31 c0 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 67 c3 66 0f 1f 44 00 00 41 56 41 89 ce 41 55
 RSP: 002b:00007ffd17958358 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
 RAX: ffffffffffffffda RBX: 0000555c6e671610 RCX: 00007f11a06fd281
 RDX: 0000000000002000 RSI: 0000555c6e73a9f0 RDI: 0000000000000003
 RBP: 0000555c6e6433b0 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000002000
 R13: 0000555c6e671410 R14: 0000555c6e671410 R15: 0000555c6e6433f8
  </TASK>

that is very similar to those observed by William in his setup.
By using netif_rx() for mirred ingress packets, packets are queued in the
backlog, like it's done in the receive path of "loopback" and "veth", and
the deadlock is not visible anymore. Also add a selftest that can be used
to reproduce the problem / verify the fix.

Fixes: 53592b364001 ("net/sched: act_mirred: Implement ingress actions")
Reported-by: William Zhao <wizhao@redhat.com>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/act_mirred.c                        |  2 +-
 .../selftests/net/forwarding/tc_actions.sh    | 29 ++++++++++++++++++-
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index a1d70cf86843..ff965ed2dd9f 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -213,7 +213,7 @@ static int tcf_mirred_forward(bool want_ingress, struct sk_buff *skb)
 	if (!want_ingress)
 		err = tcf_dev_queue_xmit(skb, dev_queue_xmit);
 	else
-		err = netif_receive_skb(skb);
+		err = netif_rx(skb);
 
 	return err;
 }
diff --git a/tools/testing/selftests/net/forwarding/tc_actions.sh b/tools/testing/selftests/net/forwarding/tc_actions.sh
index 1e0a62f638fe..6e1b0cc68f7d 100755
--- a/tools/testing/selftests/net/forwarding/tc_actions.sh
+++ b/tools/testing/selftests/net/forwarding/tc_actions.sh
@@ -3,7 +3,8 @@
 
 ALL_TESTS="gact_drop_and_ok_test mirred_egress_redirect_test \
 	mirred_egress_mirror_test matchall_mirred_egress_mirror_test \
-	gact_trap_test mirred_egress_to_ingress_test"
+	gact_trap_test mirred_egress_to_ingress_test \
+	mirred_egress_to_ingress_tcp_test"
 NUM_NETIFS=4
 source tc_common.sh
 source lib.sh
@@ -198,6 +199,32 @@ mirred_egress_to_ingress_test()
 	log_test "mirred_egress_to_ingress ($tcflags)"
 }
 
+mirred_egress_to_ingress_tcp_test()
+{
+	local tmpfile=$(mktemp) tmpfile1=$(mktemp)
+
+	RET=0
+	dd conv=sparse status=none if=/dev/zero bs=1M count=2 of=$tmpfile
+	tc filter add dev $h1 protocol ip pref 100 handle 100 egress flower \
+		ip_proto tcp src_ip 192.0.2.1 dst_ip 192.0.2.2 \
+			action ct commit nat src addr 192.0.2.2 pipe \
+			action ct clear pipe \
+			action ct commit nat dst addr 192.0.2.1 pipe \
+			action ct clear pipe \
+			action skbedit ptype host pipe \
+			action mirred ingress redirect dev $h1
+
+	ip vrf exec v$h1 nc --recv-only -w10 -l -p 12345 -o $tmpfile1 &
+	local rpid=$!
+	ip vrf exec v$h1 nc -w1 --send-only 192.0.2.2 12345 <$tmpfile
+	wait -n $rpid
+	cmp -s $tmpfile $tmpfile1
+	check_err $? "server output check failed"
+	tc filter del dev $h1 egress protocol ip pref 100 handle 100 flower
+	rm -f $tmpfile $tmpfile1
+	log_test "mirred_egress_to_ingress_tcp"
+}
+
 setup_prepare()
 {
 	h1=${NETIFS[p1]}
-- 
2.37.2

