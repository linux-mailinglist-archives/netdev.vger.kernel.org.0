Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8809CF3E7D
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 04:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbfKHDrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 22:47:07 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:53450 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbfKHDrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 22:47:07 -0500
Received: by mail-pg1-f202.google.com with SMTP id u11so3651200pgm.20
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 19:47:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=OpgBKwH6jIlplLpB5hMrnCvL2stJ/JUciAiVavJ0Fjo=;
        b=E5j7q0CsfP3JYVGOc15lTKf7uJ1wzosehDgvKOWrfJXncnOuLE6sT55mPkgPPl41ro
         TK113Ezg5jr6sGBOex7a99YERf7G3CMtG+ej2+OW4bDkjj8EMFVdBq/QkJjWS40HJcBt
         nXkkiyByER5knBsQ5ePETZHsRPkS7oSg8ikOMt6lc5D6KXZnA23Xd+OyHC+7+xvYU6n1
         +e0giPyBiL/S/Nt1PG36tb4oDD5jLSnViiMwXBDnQllH2jmGpN9pHKZF/Qp/XjpDb6qe
         giRKXYSzIEi3Q22WrLDI0Jx1aVTKDCDJKVLTOH0pE+nhpJuBXOQ2QdSt5uj5yQ8CGQOb
         paqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=OpgBKwH6jIlplLpB5hMrnCvL2stJ/JUciAiVavJ0Fjo=;
        b=evzcOjRG7JFdFFwu+VodNnbH8SKABtsRJwEmlP4mZ8h/3vIV+7hOwIMnJAkkKlvk3Q
         JIbSrj354MssfjHLrQlhaHJeUsKGHk8skVsDFFrRxwd7pbovnK/qGrXpwZ99dpuVLvKG
         MzVUmixkhZ1lLHjvTNHUi7Yu54XX1o6MaAFbYjs7R4E7k3UmHwcM1xsSEERcEiH5Ud9o
         68zQtepaqnBlLtSMJFuesRjAR2YNaWKze3M21wj0C0nihMj6T1BeQlygn7J73uby/X1h
         kvo91/iltt5JPGUqEgA1e28OGCAvpKuHvYYDECwn9lDeq61NCjy4RXRoWzE0XG7kzCx2
         zztA==
X-Gm-Message-State: APjAAAV3qu42lAqsr9djqd2tozxkeWgRNOeUmN+xhTHVc1kB1sS3dEZI
        mZKqTUrt7Lro17zRe2Q1vIjfR1WFN5sSKw==
X-Google-Smtp-Source: APXvYqw5xhCp6n+cxlzSqui0QTIiTS+OlgaSm6uE+gctnKDamojNJlF1kMOX9DrtWlUgX62yvsLy6iReVed4dQ==
X-Received: by 2002:a63:694a:: with SMTP id e71mr9115838pgc.116.1573184826094;
 Thu, 07 Nov 2019 19:47:06 -0800 (PST)
Date:   Thu,  7 Nov 2019 19:47:01 -0800
Message-Id: <20191108034701.77736-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net-next] xfrm: add missing rcu verbs to fix data-race
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KCSAN reported a data-race in xfrm_lookup_with_ifid() and
xfrm_sk_free_policy() [1]

This should be solved using rcu_access_pointer() and rcu_assign_pointer()
to avoid potential load/store-tearing.

[1]
BUG: KCSAN: data-race in sk_common_release / xfrm_lookup_with_ifid

write to 0xffff888121172668 of 8 bytes by task 22196 on cpu 0:
 xfrm_sk_free_policy include/net/xfrm.h:1193 [inline]
 sk_common_release+0x18c/0x1d0 net/core/sock.c:3198
 udp_lib_close+0x1f/0x30 include/net/udp.h:202
 inet_release+0x86/0x100 net/ipv4/af_inet.c:427
 inet6_release+0x4a/0x70 net/ipv6/af_inet6.c:470
 __sock_release+0x85/0x160 net/socket.c:590
 sock_close+0x24/0x30 net/socket.c:1268
 __fput+0x1e1/0x520 fs/file_table.c:280
 ____fput+0x1f/0x30 fs/file_table.c:313
 task_work_run+0xf6/0x130 kernel/task_work.c:113
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_usermode_loop+0x2b4/0x2c0 arch/x86/entry/common.c:163
 prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
 syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
 do_syscall_64+0x353/0x370 arch/x86/entry/common.c:300
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

read to 0xffff888121172668 of 8 bytes by task 22201 on cpu 1:
 xfrm_lookup_with_ifid+0xc0/0x1310 net/xfrm/xfrm_policy.c:3035
 xfrm_lookup net/xfrm/xfrm_policy.c:3174 [inline]
 xfrm_lookup_route+0x44/0x100 net/xfrm/xfrm_policy.c:3185
 ip6_dst_lookup_flow+0xde/0x120 net/ipv6/ip6_output.c:1159
 inet6_csk_route_socket+0x2f7/0x420 net/ipv6/inet6_connection_sock.c:106
 inet6_csk_xmit+0x91/0x1f0 net/ipv6/inet6_connection_sock.c:121
 l2tp_xmit_core net/l2tp/l2tp_core.c:1030 [inline]
 l2tp_xmit_skb+0x8c9/0x8e0 net/l2tp/l2tp_core.c:1132
 pppol2tp_sendmsg+0x2fc/0x3c0 net/l2tp/l2tp_ppp.c:325
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg+0x9f/0xc0 net/socket.c:657
 ___sys_sendmsg+0x2b7/0x5d0 net/socket.c:2311
 __sys_sendmmsg+0x123/0x350 net/socket.c:2413
 __do_sys_sendmmsg net/socket.c:2442 [inline]
 __se_sys_sendmmsg net/socket.c:2439 [inline]
 __x64_sys_sendmmsg+0x64/0x80 net/socket.c:2439
 do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 22201 Comm: syz-executor.5 Not tainted 5.4.0-rc6+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/net/xfrm.h     | 9 +++++----
 net/smc/smc.h          | 4 ++--
 net/xfrm/xfrm_policy.c | 4 ++--
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index aa08a7a5f6ac5836524dd34115cd57e2675e574d..8884575ae2135b739a2c316bf8a92b56d6cc807c 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1093,7 +1093,7 @@ static inline int __xfrm_policy_check2(struct sock *sk, int dir,
 	struct net *net = dev_net(skb->dev);
 	int ndir = dir | (reverse ? XFRM_POLICY_MASK + 1 : 0);
 
-	if (sk && sk->sk_policy[XFRM_POLICY_IN])
+	if (sk && rcu_access_pointer(sk->sk_policy[XFRM_POLICY_IN]))
 		return __xfrm_policy_check(sk, ndir, skb, family);
 
 	return	(!net->xfrm.policy_count[dir] && !secpath_exists(skb)) ||
@@ -1171,7 +1171,8 @@ static inline int xfrm_sk_clone_policy(struct sock *sk, const struct sock *osk)
 {
 	sk->sk_policy[0] = NULL;
 	sk->sk_policy[1] = NULL;
-	if (unlikely(osk->sk_policy[0] || osk->sk_policy[1]))
+	if (unlikely(rcu_access_pointer(osk->sk_policy[0]) ||
+		     rcu_access_pointer(osk->sk_policy[1])))
 		return __xfrm_sk_clone_policy(sk, osk);
 	return 0;
 }
@@ -1185,12 +1186,12 @@ static inline void xfrm_sk_free_policy(struct sock *sk)
 	pol = rcu_dereference_protected(sk->sk_policy[0], 1);
 	if (unlikely(pol != NULL)) {
 		xfrm_policy_delete(pol, XFRM_POLICY_MAX);
-		sk->sk_policy[0] = NULL;
+		rcu_assign_pointer(sk->sk_policy[0], NULL);
 	}
 	pol = rcu_dereference_protected(sk->sk_policy[1], 1);
 	if (unlikely(pol != NULL)) {
 		xfrm_policy_delete(pol, XFRM_POLICY_MAX+1);
-		sk->sk_policy[1] = NULL;
+		rcu_assign_pointer(sk->sk_policy[1], NULL);
 	}
 }
 
diff --git a/net/smc/smc.h b/net/smc/smc.h
index be11ba41190fb58be3ce9e8ab1a9ea4f8aa6a05b..4324dd39de99ba5967e1325746a2f5eff4baf2e7 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -253,8 +253,8 @@ static inline u32 ntoh24(u8 *net)
 #ifdef CONFIG_XFRM
 static inline bool using_ipsec(struct smc_sock *smc)
 {
-	return (smc->clcsock->sk->sk_policy[0] ||
-		smc->clcsock->sk->sk_policy[1]) ? true : false;
+	return (rcu_access_pointer(smc->clcsock->sk->sk_policy[0]) ||
+		rcu_access_pointer(smc->clcsock->sk->sk_policy[1])) ? true : false;
 }
 #else
 static inline bool using_ipsec(struct smc_sock *smc)
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index f2d1e573ea55154eb2ee4fc3dbdd47313d969b98..d76ca0dfbefb31ae8a883b63d755e29ac749569b 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3032,7 +3032,7 @@ struct dst_entry *xfrm_lookup_with_ifid(struct net *net,
 	route = NULL;
 
 	sk = sk_const_to_full_sk(sk);
-	if (sk && sk->sk_policy[XFRM_POLICY_OUT]) {
+	if (sk && rcu_access_pointer(sk->sk_policy[XFRM_POLICY_OUT])) {
 		num_pols = 1;
 		pols[0] = xfrm_sk_policy_lookup(sk, XFRM_POLICY_OUT, fl, family,
 						if_id);
@@ -3557,7 +3557,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 
 	pol = NULL;
 	sk = sk_to_full_sk(sk);
-	if (sk && sk->sk_policy[dir]) {
+	if (sk && rcu_access_pointer(sk->sk_policy[dir])) {
 		pol = xfrm_sk_policy_lookup(sk, dir, &fl, family, if_id);
 		if (IS_ERR(pol)) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINPOLERROR);
-- 
2.24.0.432.g9d3f5f5b63-goog

