Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBA342283E
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235089AbhJENtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 09:49:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233077AbhJENtV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 09:49:21 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D191961244;
        Tue,  5 Oct 2021 13:47:29 +0000 (UTC)
Date:   Tue, 5 Oct 2021 09:47:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, rcu@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [RFC][PATCH] rcu: Use typeof(p) instead of typeof(*p) *
Message-ID: <20211005094728.203ecef2@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

After moving a structure into a local file and only declaring it for users
of that structure to have just a pointer to it, some compilers gave this error:

kernel/trace/ftrace.c: In function 'ftrace_filter_pid_sched_switch_probe':
include/linux/rcupdate.h:389:9: error: dereferencing pointer to incomplete type 'struct trace_pid_list'
  typeof(*p) *________p1 = (typeof(*p) *__force)READ_ONCE(p); \
         ^
include/linux/rcupdate.h:558:2: note: in expansion of macro '__rcu_dereference_check'
  __rcu_dereference_check((p), (c) || rcu_read_lock_sched_held(), \
  ^~~~~~~~~~~~~~~~~~~~~~~
include/linux/rcupdate.h:612:34: note: in expansion of macro 'rcu_dereference_sched_check'
 #define rcu_dereference_sched(p) rcu_dereference_sched_check(p, 0)
                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~
kernel/trace/ftrace.c:7101:13: note: in expansion of macro 'rcu_dereference_sched'
  pid_list = rcu_dereference_sched(tr->function_pids);
             ^~~~~~~~~~~~~~~~~~~~~

The reason is that rcu_dereference_sched() has a check that uses
typeof(*p) of the pointer passed to it. But here, the pointer is of type
"struct trace_pid_list *" which is abstracted out, and nothing outside of
pid_list.c should care what the content of it is. But the check uses
typeof(*p) and on some (not all) compilers, it errors with the
dereferencing pointer to incomplete type, which is totally bogus here.

Since the logic creates a pointer of each of these instances of
typeof(*p), just use typeof(p).

That is, instead of declaring: typeof(*p) *_p; just do:
 typeof(p) _p;

Also had to update a lot of the function pointer initialization in the
networking code, as a function address must be passed as an argument in
RCU_INIT_POINTER() and not just the function name, otherwise the following
error occurs:

In file included from ./arch/x86/include/generated/asm/rwonce.h:1,
                 from ./include/linux/compiler.h:266,
                 from ./include/linux/init.h:5,
                 from ./include/linux/netfilter.h:5,
                 from ./net/netfilter/nf_conntrack_core.c:15:
./net/netfilter/nf_conntrack_core.c: In function 'nf_conntrack_init_end':
./include/linux/rcupdate.h:411:28: error: cast specifies function type
 #define RCU_INITIALIZER(v) (typeof((v)) __force __rcu)(v)
                            ^
./include/asm-generic/rwonce.h:55:33: note: in definition of macro '__WRITE_ONCE'
  *(volatile typeof(x) *)&(x) = (val);    \
                                 ^~~
./include/linux/rcupdate.h:853:3: note: in expansion of macro 'WRITE_ONCE'
   WRITE_ONCE(p, RCU_INITIALIZER(v)); \
   ^~~~~~~~~~
./include/linux/rcupdate.h:853:17: note: in expansion of macro 'RCU_INITIALIZER'
   WRITE_ONCE(p, RCU_INITIALIZER(v)); \
                 ^~~~~~~~~~~~~~~
./net/netfilter/nf_conntrack_core.c:2736:2: note: in expansion of macro 'RCU_INIT_POINTER'
  RCU_INIT_POINTER(ip_ct_attach, nf_conntrack_attach);
  ^~~~~~~~~~~~~~~~

Link: https://lore.kernel.org/all/20211002195718.0b5d9b67@oasis.local.home/

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/linux/rcupdate.h                    | 20 ++++++++++----------
 net/ipv4/netfilter/nf_nat_h323.c            | 18 +++++++++---------
 net/ipv4/netfilter/nf_nat_pptp.c            |  8 ++++----
 net/ipv4/netfilter/nf_nat_snmp_basic_main.c |  2 +-
 net/netfilter/nf_conntrack_core.c           |  2 +-
 net/netfilter/nf_nat_amanda.c               |  2 +-
 net/netfilter/nf_nat_ftp.c                  |  2 +-
 net/netfilter/nf_nat_irc.c                  |  2 +-
 net/netfilter/nf_nat_tftp.c                 |  2 +-
 net/netfilter/nfnetlink_cttimeout.c         |  4 ++--
 10 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 434d12fe2d4f..3835ead65094 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -358,7 +358,7 @@ static inline void rcu_preempt_sleep_check(void) { }
 
 #ifdef __CHECKER__
 #define rcu_check_sparse(p, space) \
-	((void)(((typeof(*p) space *)p) == p))
+	((void)(((typeof(p) space)p) == p))
 #else /* #ifdef __CHECKER__ */
 #define rcu_check_sparse(p, space)
 #endif /* #else #ifdef __CHECKER__ */
@@ -372,43 +372,43 @@ static inline void rcu_preempt_sleep_check(void) { }
  */
 #define unrcu_pointer(p)						\
 ({									\
-	typeof(*p) *_________p1 = (typeof(*p) *__force)(p);		\
+	typeof(p)_________p1 = (typeof(p) __force)(p);			\
 	rcu_check_sparse(p, __rcu);					\
-	((typeof(*p) __force __kernel *)(_________p1)); 		\
+	((typeof(p) __force __kernel)(_________p1));			\
 })
 
 #define __rcu_access_pointer(p, space) \
 ({ \
-	typeof(*p) *_________p1 = (typeof(*p) *__force)READ_ONCE(p); \
+	typeof(p) _________p1 = (typeof(p) __force)READ_ONCE(p); \
 	rcu_check_sparse(p, space); \
-	((typeof(*p) __force __kernel *)(_________p1)); \
+	((typeof(p) __force __kernel)(_________p1)); \
 })
 #define __rcu_dereference_check(p, c, space) \
 ({ \
 	/* Dependency order vs. p above. */ \
-	typeof(*p) *________p1 = (typeof(*p) *__force)READ_ONCE(p); \
+	typeof(p) ________p1 = (typeof(p) __force)READ_ONCE(p); \
 	RCU_LOCKDEP_WARN(!(c), "suspicious rcu_dereference_check() usage"); \
 	rcu_check_sparse(p, space); \
-	((typeof(*p) __force __kernel *)(________p1)); \
+	((typeof(p) __force __kernel )(________p1)); \
 })
 #define __rcu_dereference_protected(p, c, space) \
 ({ \
 	RCU_LOCKDEP_WARN(!(c), "suspicious rcu_dereference_protected() usage"); \
 	rcu_check_sparse(p, space); \
-	((typeof(*p) __force __kernel *)(p)); \
+	((typeof(p) __force __kernel)(p)); \
 })
 #define rcu_dereference_raw(p) \
 ({ \
 	/* Dependency order vs. p above. */ \
 	typeof(p) ________p1 = READ_ONCE(p); \
-	((typeof(*p) __force __kernel *)(________p1)); \
+	((typeof(p) __force __kernel)(________p1)); \
 })
 
 /**
  * RCU_INITIALIZER() - statically initialize an RCU-protected global variable
  * @v: The value to statically initialize with.
  */
-#define RCU_INITIALIZER(v) (typeof(*(v)) __force __rcu *)(v)
+#define RCU_INITIALIZER(v) (typeof((v)) __force __rcu)(v)
 
 /**
  * rcu_assign_pointer() - assign to RCU-protected pointer
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index 3e2685c120c7..88c902141e33 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -592,15 +592,15 @@ static int __init init(void)
 	BUG_ON(nat_callforwarding_hook != NULL);
 	BUG_ON(nat_q931_hook != NULL);
 
-	RCU_INIT_POINTER(set_h245_addr_hook, set_h245_addr);
-	RCU_INIT_POINTER(set_h225_addr_hook, set_h225_addr);
-	RCU_INIT_POINTER(set_sig_addr_hook, set_sig_addr);
-	RCU_INIT_POINTER(set_ras_addr_hook, set_ras_addr);
-	RCU_INIT_POINTER(nat_rtp_rtcp_hook, nat_rtp_rtcp);
-	RCU_INIT_POINTER(nat_t120_hook, nat_t120);
-	RCU_INIT_POINTER(nat_h245_hook, nat_h245);
-	RCU_INIT_POINTER(nat_callforwarding_hook, nat_callforwarding);
-	RCU_INIT_POINTER(nat_q931_hook, nat_q931);
+	RCU_INIT_POINTER(set_h245_addr_hook, &set_h245_addr);
+	RCU_INIT_POINTER(set_h225_addr_hook, &set_h225_addr);
+	RCU_INIT_POINTER(set_sig_addr_hook, &set_sig_addr);
+	RCU_INIT_POINTER(set_ras_addr_hook, &set_ras_addr);
+	RCU_INIT_POINTER(nat_rtp_rtcp_hook, &nat_rtp_rtcp);
+	RCU_INIT_POINTER(nat_t120_hook, &nat_t120);
+	RCU_INIT_POINTER(nat_h245_hook, &nat_h245);
+	RCU_INIT_POINTER(nat_callforwarding_hook, &nat_callforwarding);
+	RCU_INIT_POINTER(nat_q931_hook, &nat_q931);
 	nf_ct_helper_expectfn_register(&q931_nat);
 	nf_ct_helper_expectfn_register(&callforwarding_nat);
 	return 0;
diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index 3f248a19faa3..6a22ffa5e4c7 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -298,16 +298,16 @@ pptp_inbound_pkt(struct sk_buff *skb,
 static int __init nf_nat_helper_pptp_init(void)
 {
 	BUG_ON(nf_nat_pptp_hook_outbound != NULL);
-	RCU_INIT_POINTER(nf_nat_pptp_hook_outbound, pptp_outbound_pkt);
+	RCU_INIT_POINTER(nf_nat_pptp_hook_outbound, &pptp_outbound_pkt);
 
 	BUG_ON(nf_nat_pptp_hook_inbound != NULL);
-	RCU_INIT_POINTER(nf_nat_pptp_hook_inbound, pptp_inbound_pkt);
+	RCU_INIT_POINTER(nf_nat_pptp_hook_inbound, &pptp_inbound_pkt);
 
 	BUG_ON(nf_nat_pptp_hook_exp_gre != NULL);
-	RCU_INIT_POINTER(nf_nat_pptp_hook_exp_gre, pptp_exp_gre);
+	RCU_INIT_POINTER(nf_nat_pptp_hook_exp_gre, &pptp_exp_gre);
 
 	BUG_ON(nf_nat_pptp_hook_expectfn != NULL);
-	RCU_INIT_POINTER(nf_nat_pptp_hook_expectfn, pptp_nat_expected);
+	RCU_INIT_POINTER(nf_nat_pptp_hook_expectfn, &pptp_nat_expected);
 	return 0;
 }
 
diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic_main.c b/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
index 717b726504fe..2ac36fa86e73 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
@@ -215,7 +215,7 @@ static struct nf_conntrack_helper snmp_trap_helper __read_mostly = {
 static int __init nf_nat_snmp_basic_init(void)
 {
 	BUG_ON(nf_nat_snmp_hook != NULL);
-	RCU_INIT_POINTER(nf_nat_snmp_hook, help);
+	RCU_INIT_POINTER(nf_nat_snmp_hook, &help);
 
 	return nf_conntrack_helper_register(&snmp_trap_helper);
 }
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 94e18fb9690d..e243e5695b63 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2733,7 +2733,7 @@ static struct nf_ct_hook nf_conntrack_hook = {
 void nf_conntrack_init_end(void)
 {
 	/* For use by REJECT target */
-	RCU_INIT_POINTER(ip_ct_attach, nf_conntrack_attach);
+	RCU_INIT_POINTER(ip_ct_attach, &nf_conntrack_attach);
 	RCU_INIT_POINTER(nf_ct_hook, &nf_conntrack_hook);
 }
 
diff --git a/net/netfilter/nf_nat_amanda.c b/net/netfilter/nf_nat_amanda.c
index 3bc7e0854efe..fe077c53e06a 100644
--- a/net/netfilter/nf_nat_amanda.c
+++ b/net/netfilter/nf_nat_amanda.c
@@ -84,7 +84,7 @@ static int __init nf_nat_amanda_init(void)
 {
 	BUG_ON(nf_nat_amanda_hook != NULL);
 	nf_nat_helper_register(&nat_helper_amanda);
-	RCU_INIT_POINTER(nf_nat_amanda_hook, help);
+	RCU_INIT_POINTER(nf_nat_amanda_hook, &help);
 	return 0;
 }
 
diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
index aace6768a64e..d657606b3364 100644
--- a/net/netfilter/nf_nat_ftp.c
+++ b/net/netfilter/nf_nat_ftp.c
@@ -135,7 +135,7 @@ static int __init nf_nat_ftp_init(void)
 {
 	BUG_ON(nf_nat_ftp_hook != NULL);
 	nf_nat_helper_register(&nat_helper_ftp);
-	RCU_INIT_POINTER(nf_nat_ftp_hook, nf_nat_ftp);
+	RCU_INIT_POINTER(nf_nat_ftp_hook, &nf_nat_ftp);
 	return 0;
 }
 
diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
index c691ab8d234c..4742ed478989 100644
--- a/net/netfilter/nf_nat_irc.c
+++ b/net/netfilter/nf_nat_irc.c
@@ -106,7 +106,7 @@ static int __init nf_nat_irc_init(void)
 {
 	BUG_ON(nf_nat_irc_hook != NULL);
 	nf_nat_helper_register(&nat_helper_irc);
-	RCU_INIT_POINTER(nf_nat_irc_hook, help);
+	RCU_INIT_POINTER(nf_nat_irc_hook, &help);
 	return 0;
 }
 
diff --git a/net/netfilter/nf_nat_tftp.c b/net/netfilter/nf_nat_tftp.c
index 1a591132d6eb..591f4e559c55 100644
--- a/net/netfilter/nf_nat_tftp.c
+++ b/net/netfilter/nf_nat_tftp.c
@@ -48,7 +48,7 @@ static int __init nf_nat_tftp_init(void)
 {
 	BUG_ON(nf_nat_tftp_hook != NULL);
 	nf_nat_helper_register(&nat_helper_tftp);
-	RCU_INIT_POINTER(nf_nat_tftp_hook, help);
+	RCU_INIT_POINTER(nf_nat_tftp_hook, &help);
 	return 0;
 }
 
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index c57673d499be..0097e0a65ca2 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -619,8 +619,8 @@ static int __init cttimeout_init(void)
 			"nfnetlink.\n");
 		goto err_out;
 	}
-	RCU_INIT_POINTER(nf_ct_timeout_find_get_hook, ctnl_timeout_find_get);
-	RCU_INIT_POINTER(nf_ct_timeout_put_hook, ctnl_timeout_put);
+	RCU_INIT_POINTER(nf_ct_timeout_find_get_hook, &ctnl_timeout_find_get);
+	RCU_INIT_POINTER(nf_ct_timeout_put_hook, &ctnl_timeout_put);
 	return 0;
 
 err_out:
-- 
2.31.1

