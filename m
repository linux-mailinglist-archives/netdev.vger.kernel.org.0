Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE5462F40B
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 12:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241181AbiKRLwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 06:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbiKRLwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 06:52:49 -0500
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12BB922EE
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 03:52:47 -0800 (PST)
Received: from fsav411.sakura.ne.jp (fsav411.sakura.ne.jp [133.242.250.110])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 2AIBpLhq014927;
        Fri, 18 Nov 2022 20:51:21 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav411.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav411.sakura.ne.jp);
 Fri, 18 Nov 2022 20:51:21 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav411.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 2AIBpEwV014896
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 18 Nov 2022 20:51:20 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <c64284f4-2c2a-ecb9-a08e-9e49d49c720b@I-love.SAKURA.ne.jp>
Date:   Fri, 18 Nov 2022 20:51:13 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: [PATCH 6.1-rc6] l2tp: call udp_tunnel_encap_enable() and
 sock_release() without sk_callback_lock
Content-Language: en-US
To:     "David S. Miller\"" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Tom Parkin <tparkin@katalix.com>
References: <0000000000004e78ec05eda79749@google.com>
 <00000000000011ec5105edb50386@google.com>
Cc:     syzbot <syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com>,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Haowei Yan <g1042620637@gmail.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <00000000000011ec5105edb50386@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot is reporting sleep in atomic context at l2tp_tunnel_register() [1],
for commit b68777d54fac ("l2tp: Serialize access to sk_user_data with
sk_callback_lock") missed that udp_tunnel_encap_enable() from
setup_udp_tunnel_sock() might sleep.

Since we don't want to drop sk->sk_callback_lock inside
setup_udp_tunnel_sock() right before calling udp_tunnel_encap_enable(),
introduce a variant which does not call udp_tunnel_encap_enable(). And
call udp_tunnel_encap_enable() after dropping sk->sk_callback_lock.

Also, drop sk->sk_callback_lock before calling sock_release() in order to
avoid circular locking dependency problem.

Link: https://syzkaller.appspot.com/bug?extid=703d9e154b3b58277261 [1]
Reported-by: syzbot <syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: b68777d54fac ("l2tp: Serialize access to sk_user_data with sk_callback_lock")
---
F.Y.I. Below is the lockdep message:

 ======================================================
 WARNING: possible circular locking dependency detected
 6.1.0-rc5+ #2 Not tainted
 ------------------------------------------------------
 a.out/2794 is trying to acquire lock:
 ffff8c628878bdf0 (k-sk_lock-AF_INET){+.+.}-{0:0}, at: sk_common_release+0x19/0xe0

 but task is already holding lock:
 ffff8c628878c078 (k-clock-AF_INET){+++.}-{2:2}, at: l2tp_tunnel_register+0x64/0x5e0 [l2tp_core]

 which lock already depends on the new lock.


 the existing dependency chain (in reverse order) is:

 -> #2 (k-clock-AF_INET){+++.}-{2:2}:
        lock_acquire+0xc7/0x2e0
        _raw_read_lock_bh+0x3d/0x80
        sock_i_uid+0x19/0x40
        udp_lib_lport_inuse+0x2c/0x120
        udp_lib_get_port+0xf8/0x570
        udp_v4_get_port+0xbb/0xc0
        __inet_bind+0x10e/0x240
        inet_bind+0x2b/0x40
        kernel_bind+0xb/0x10
        udp_sock_create4+0x97/0x160 [udp_tunnel]
        l2tp_tunnel_sock_create+0x316/0x330 [l2tp_core]
        l2tp_tunnel_register+0x394/0x5e0 [l2tp_core]
        l2tp_nl_cmd_tunnel_create+0xe8/0x200 [l2tp_netlink]
        genl_family_rcv_msg_doit.isra.17+0x102/0x140
        genl_rcv_msg+0x112/0x270
        netlink_rcv_skb+0x4f/0x100
        genl_rcv+0x23/0x40
        netlink_unicast+0x1a5/0x280
        netlink_sendmsg+0x22f/0x490
        sock_sendmsg+0x2e/0x40
        ____sys_sendmsg+0x1e9/0x210
        ___sys_sendmsg+0x77/0xb0
        __sys_sendmsg+0x60/0xb0
        __x64_sys_sendmsg+0x1a/0x20
        do_syscall_64+0x34/0x80
        entry_SYSCALL_64_after_hwframe+0x63/0xcd

 -> #1 (&table->hash[i].lock){+...}-{2:2}:
        lock_acquire+0xc7/0x2e0
        _raw_spin_lock_bh+0x31/0x40
        udp_lib_get_port+0xda/0x570
        udp_v4_get_port+0xbb/0xc0
        __inet_bind+0x10e/0x240
        inet_bind+0x2b/0x40
        kernel_bind+0xb/0x10
        udp_sock_create4+0x97/0x160 [udp_tunnel]
        l2tp_tunnel_sock_create+0x316/0x330 [l2tp_core]
        l2tp_tunnel_register+0x394/0x5e0 [l2tp_core]
        l2tp_nl_cmd_tunnel_create+0xe8/0x200 [l2tp_netlink]
        genl_family_rcv_msg_doit.isra.17+0x102/0x140
        genl_rcv_msg+0x112/0x270
        netlink_rcv_skb+0x4f/0x100
        genl_rcv+0x23/0x40
        netlink_unicast+0x1a5/0x280
        netlink_sendmsg+0x22f/0x490
        sock_sendmsg+0x2e/0x40
        ____sys_sendmsg+0x1e9/0x210
        ___sys_sendmsg+0x77/0xb0
        __sys_sendmsg+0x60/0xb0
        __x64_sys_sendmsg+0x1a/0x20
        do_syscall_64+0x34/0x80
        entry_SYSCALL_64_after_hwframe+0x63/0xcd

 -> #0 (k-sk_lock-AF_INET){+.+.}-{0:0}:
        check_prevs_add+0x16a/0x1070
        __lock_acquire+0x11bd/0x1670
        lock_acquire+0xc7/0x2e0
        udp_destroy_sock+0x2d/0xd0
        sk_common_release+0x19/0xe0
        udp_lib_close+0x9/0x10
        inet_release+0x2e/0x60
        __sock_release+0x7e/0xa0
        sock_release+0xb/0x10
        l2tp_tunnel_register+0x3f1/0x5e0 [l2tp_core]
        l2tp_nl_cmd_tunnel_create+0xe8/0x200 [l2tp_netlink]
        genl_family_rcv_msg_doit.isra.17+0x102/0x140
        genl_rcv_msg+0x112/0x270
        netlink_rcv_skb+0x4f/0x100
        genl_rcv+0x23/0x40
        netlink_unicast+0x1a5/0x280
        netlink_sendmsg+0x22f/0x490
        sock_sendmsg+0x2e/0x40
        ____sys_sendmsg+0x1e9/0x210
        ___sys_sendmsg+0x77/0xb0
        __sys_sendmsg+0x60/0xb0
        __x64_sys_sendmsg+0x1a/0x20
        do_syscall_64+0x34/0x80
        entry_SYSCALL_64_after_hwframe+0x63/0xcd

 other info that might help us debug this:

 Chain exists of:
   k-sk_lock-AF_INET --> &table->hash[i].lock --> k-clock-AF_INET

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(k-clock-AF_INET);
                                lock(&table->hash[i].lock);
                                lock(k-clock-AF_INET);
   lock(k-sk_lock-AF_INET);

  *** DEADLOCK ***

 3 locks held by a.out/2794:
  #0: ffffffffb466fc30 (cb_lock){++++}-{3:3}, at: genl_rcv+0x14/0x40
  #1: ffffffffb466fcc8 (genl_mutex){+.+.}-{3:3}, at: genl_rcv_msg+0x14d/0x270
  #2: ffff8c628878c078 (k-clock-AF_INET){+++.}-{2:2}, at: l2tp_tunnel_register+0x64/0x5e0 [l2tp_core]

 include/net/udp_tunnel.h   |  2 ++
 net/ipv4/udp_tunnel_core.c | 10 ++++++++--
 net/l2tp/l2tp_core.c       | 10 +++++-----
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index 72394f441dad..a84fa57bc750 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -92,6 +92,8 @@ struct udp_tunnel_sock_cfg {
 /* Setup the given (UDP) sock to receive UDP encapsulated packets */
 void setup_udp_tunnel_sock(struct net *net, struct socket *sock,
 			   struct udp_tunnel_sock_cfg *sock_cfg);
+void setup_udp_tunnel_sock_no_enable(struct net *net, struct socket *sock,
+				     struct udp_tunnel_sock_cfg *sock_cfg);
 
 /* -- List of parsable UDP tunnel types --
  *
diff --git a/net/ipv4/udp_tunnel_core.c b/net/ipv4/udp_tunnel_core.c
index 8242c8947340..dff825664000 100644
--- a/net/ipv4/udp_tunnel_core.c
+++ b/net/ipv4/udp_tunnel_core.c
@@ -57,8 +57,8 @@ int udp_sock_create4(struct net *net, struct udp_port_cfg *cfg,
 }
 EXPORT_SYMBOL(udp_sock_create4);
 
-void setup_udp_tunnel_sock(struct net *net, struct socket *sock,
-			   struct udp_tunnel_sock_cfg *cfg)
+void setup_udp_tunnel_sock_no_enable(struct net *net, struct socket *sock,
+				     struct udp_tunnel_sock_cfg *cfg)
 {
 	struct sock *sk = sock->sk;
 
@@ -77,7 +77,13 @@ void setup_udp_tunnel_sock(struct net *net, struct socket *sock,
 	udp_sk(sk)->encap_destroy = cfg->encap_destroy;
 	udp_sk(sk)->gro_receive = cfg->gro_receive;
 	udp_sk(sk)->gro_complete = cfg->gro_complete;
+}
+EXPORT_SYMBOL_GPL(setup_udp_tunnel_sock_no_enable);
 
+void setup_udp_tunnel_sock(struct net *net, struct socket *sock,
+			   struct udp_tunnel_sock_cfg *cfg)
+{
+	setup_udp_tunnel_sock_no_enable(net, sock, cfg);
 	udp_tunnel_encap_enable(sock);
 }
 EXPORT_SYMBOL_GPL(setup_udp_tunnel_sock);
diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 754fdda8a5f5..a4f611196c83 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1506,7 +1506,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 			.encap_destroy = l2tp_udp_encap_destroy,
 		};
 
-		setup_udp_tunnel_sock(net, sock, &udp_cfg);
+		setup_udp_tunnel_sock_no_enable(net, sock, &udp_cfg);
 	} else {
 		rcu_assign_sk_user_data(sk, tunnel);
 	}
@@ -1519,19 +1519,19 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 
 	trace_register_tunnel(tunnel);
 
+	write_unlock(&sk->sk_callback_lock);
+	if (tunnel->encap == L2TP_ENCAPTYPE_UDP)
+		udp_tunnel_encap_enable(sock);
 	if (tunnel->fd >= 0)
 		sockfd_put(sock);
-
-	write_unlock(&sk->sk_callback_lock);
 	return 0;
 
 err_sock:
+	write_unlock(&sk->sk_callback_lock);
 	if (tunnel->fd < 0)
 		sock_release(sock);
 	else
 		sockfd_put(sock);
-
-	write_unlock(&sk->sk_callback_lock);
 err:
 	return ret;
 }
-- 
2.18.4


