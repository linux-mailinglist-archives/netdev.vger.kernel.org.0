Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C78154AB06B
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 16:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244148AbiBFP4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 10:56:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233564AbiBFP4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 10:56:09 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625E9C06173B
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 07:56:04 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id b1so860817pfi.9
        for <netdev@vger.kernel.org>; Sun, 06 Feb 2022 07:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XbhnA8I+W53FsNK9seJWijp3mVzGxgG6c4sFS+8pri8=;
        b=KQxQGjOn2//+vD/hEa4Blc3F+8urgb+U1je15jXKAKze+F94dOcc/3KfsXauYTtlT0
         9oHNz05nQr725xMAzTbCPDA638ijs5oMkHYMtAsVgBhLMAHvZFQc66xoNzoXoffvwKND
         +HZmzBm7jSFu7qJJJVRL3rxGW2MxQbUGUkSGQxyU4kKsvJ413UKI1E5wNKVxBdn43bJA
         19BjCsxn14K+oSBYxfk2pmoKTGzRCGedGmmhbH2ckQFDAGllYIeKbl5GnCChjSEpCUvN
         dPssV6pklTrWzMuNlraBAM4QyRdC14PQa3Wfim8Snk0KEuYI06Nil/UJzoV3/tIFgxyQ
         rKcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XbhnA8I+W53FsNK9seJWijp3mVzGxgG6c4sFS+8pri8=;
        b=m/ah+scZ4CV4N8LgwN21vgpDZYIA2FDAOY1PNSivppDHDv4NLWYqjxd+8YUx5EMhOS
         XW1u0oXqR3UuR+Xvgfp1rsLt1mHFDlVZhhqu0e6Mitmag/Qc3KlIPWt8I04tUjGweT17
         I1hwjRewwuf7DAd1ZZ0vb6Axs6/oQNwHGOSfT9MBThLW2PM91yFgo4emrmYDWCvgMr3T
         wmzX2aawv/zHtjP9aKuhtPEc+xB4Y5arKhoue+XyAQvktbbIlOm5ZlzBjo7lCSl4M9rB
         by9CR2e47Enu5/3Le88PvU9h2rIq+dwlPEQkud6nRUZsPZ8UvYq+qLBQrDR/Brbw9Rc/
         15ZA==
X-Gm-Message-State: AOAM533V0brEnFOQDCKIn0BcCA5X+rkSDbRZyYE3Y6yLYV+GCDu2bbHU
        Mj0bvlLTrU0Yn1RYGk6djig=
X-Google-Smtp-Source: ABdhPJwx2lhhCKF0lNePRIvaE/yoEnZGWuNLCXLFiuh0lppIUhzckg2zKv/CwreC6QorAj6Oc9v2Pg==
X-Received: by 2002:a63:d80b:: with SMTP id b11mr6422189pgh.189.1644162963810;
        Sun, 06 Feb 2022 07:56:03 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8eb:b7ed:dbe7:a81f])
        by smtp.gmail.com with ESMTPSA id h14sm10058392pfh.95.2022.02.06.07.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Feb 2022 07:56:03 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net-next] ip6mr: fix use-after-free in ip6mr_sk_done()
Date:   Sun,  6 Feb 2022 07:56:00 -0800
Message-Id: <20220206155600.509633-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Apparently addrconf_exit_net() is called before igmp6_net_exit()
and ndisc_net_exit() at netns dismantle time:

 net_namespace: call ip6table_mangle_net_exit()
 net_namespace: call ip6_tables_net_exit()
 net_namespace: call ipv6_sysctl_net_exit()
 net_namespace: call ioam6_net_exit()
 net_namespace: call seg6_net_exit()
 net_namespace: call ping_v6_proc_exit_net()
 net_namespace: call tcpv6_net_exit()
 ip6mr_sk_done sk=ffffa354c78a74c0
 net_namespace: call ipv6_frags_exit_net()
 net_namespace: call addrconf_exit_net()
 net_namespace: call ip6addrlbl_net_exit()
 net_namespace: call ip6_flowlabel_net_exit()
 net_namespace: call ip6_route_net_exit_late()
 net_namespace: call fib6_rules_net_exit()
 net_namespace: call xfrm6_net_exit()
 net_namespace: call fib6_net_exit()
 net_namespace: call ip6_route_net_exit()
 net_namespace: call ipv6_inetpeer_exit()
 net_namespace: call if6_proc_net_exit()
 net_namespace: call ipv6_proc_exit_net()
 net_namespace: call udplite6_proc_exit_net()
 net_namespace: call raw6_exit_net()
 net_namespace: call igmp6_net_exit()
 ip6mr_sk_done sk=ffffa35472b2a180
 ip6mr_sk_done sk=ffffa354c78a7980
 net_namespace: call ndisc_net_exit()
 ip6mr_sk_done sk=ffffa35472b2ab00
 net_namespace: call ip6mr_net_exit()
 net_namespace: call inet6_net_exit()

This was fine because ip6mr_sk_done() would not reach the point decreasing
net->ipv6.devconf_all->mc_forwarding until my patch in ip6mr_sk_done().

To fix this without changing struct pernet_operations ordering,
we can clear net->ipv6.devconf_dflt and net->ipv6.devconf_all
when they are freed from addrconf_exit_net()

BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrumented.h:71 [inline]
BUG: KASAN: use-after-free in atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
BUG: KASAN: use-after-free in ip6mr_sk_done+0x11b/0x410 net/ipv6/ip6mr.c:1578
Read of size 4 at addr ffff88801ff08688 by task kworker/u4:4/963

CPU: 0 PID: 963 Comm: kworker/u4:4 Not tainted 5.17.0-rc2-syzkaller-00650-g5a8fb33e5305 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x336 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:71 [inline]
 atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
 ip6mr_sk_done+0x11b/0x410 net/ipv6/ip6mr.c:1578
 rawv6_close+0x58/0x80 net/ipv6/raw.c:1201
 inet_release+0x12e/0x280 net/ipv4/af_inet.c:428
 inet6_release+0x4c/0x70 net/ipv6/af_inet6.c:478
 __sock_release net/socket.c:650 [inline]
 sock_release+0x87/0x1b0 net/socket.c:678
 inet_ctl_sock_destroy include/net/inet_common.h:65 [inline]
 igmp6_net_exit+0x6b/0x170 net/ipv6/mcast.c:3173
 ops_exit_list+0xb0/0x170 net/core/net_namespace.c:168
 cleanup_net+0x4ea/0xb00 net/core/net_namespace.c:600
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

Fixes: f2f2325ec799 ("ip6mr: ip6mr_sk_done() can exit early in common cases")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv6/addrconf.c |  2 ++
 net/ipv6/ip6mr.c    | 10 ++++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index ff1b2484b8ed8638e4d37eb21c67de4e5ac43dae..ef23e7dc538ad983a28853865dd4281f7f0ea8de 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7184,7 +7184,9 @@ static void __net_exit addrconf_exit_net(struct net *net)
 				     NETCONFA_IFINDEX_ALL);
 #endif
 	kfree(net->ipv6.devconf_dflt);
+	net->ipv6.devconf_dflt = NULL;
 	kfree(net->ipv6.devconf_all);
+	net->ipv6.devconf_all = NULL;
 }
 
 static struct pernet_operations addrconf_ops = {
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 8e483e14b5709b1b8a6e9dfd6616a5bde5c273ee..fd660414d482a30c6d339bb7360bd91d8f3c6f05 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1567,15 +1567,17 @@ static int ip6mr_sk_init(struct mr_table *mrt, struct sock *sk)
 
 int ip6mr_sk_done(struct sock *sk)
 {
+	struct net *net = sock_net(sk);
+	struct ipv6_devconf *devconf;
+	struct mr_table *mrt;
 	int err = -EACCES;
-	struct net *net = sock_net(sk);
-	struct mr_table *mrt;
 
 	if (sk->sk_type != SOCK_RAW ||
 	    inet_sk(sk)->inet_num != IPPROTO_ICMPV6)
 		return err;
 
-	if (!atomic_read(&net->ipv6.devconf_all->mc_forwarding))
+	devconf = net->ipv6.devconf_all;
+	if (!devconf || !atomic_read(&devconf->mc_forwarding))
 		return err;
 
 	rtnl_lock();
@@ -1587,7 +1589,7 @@ int ip6mr_sk_done(struct sock *sk)
 			 * so the RCU grace period before sk freeing
 			 * is guaranteed by sk_destruct()
 			 */
-			atomic_dec(&net->ipv6.devconf_all->mc_forwarding);
+			atomic_dec(&devconf->mc_forwarding);
 			write_unlock_bh(&mrt_lock);
 			inet6_netconf_notify_devconf(net, RTM_NEWNETCONF,
 						     NETCONFA_MC_FORWARDING,
-- 
2.35.0.263.gb82422642f-goog

