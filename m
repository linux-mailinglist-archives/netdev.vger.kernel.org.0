Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08EA1195004
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 05:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgC0E0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 00:26:02 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43863 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgC0E0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 00:26:02 -0400
Received: by mail-pg1-f194.google.com with SMTP id u12so3985823pgb.10;
        Thu, 26 Mar 2020 21:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jIDLialeG/PdtSOR8eplxARrVRCX+SlrjaAFFDps1vA=;
        b=SIifS4ZuyM6DtMHkvGJhy7Cr9Wy2ImfD8tfMf0jfudD47FDkQO/u8T5IqxzyJIlY+H
         PWRFNDlAioxpYtKIjV6XcvnLdEvaHZq9EVzWnAhvasNaS3WoBpbcV/AGuVNjCZ5BdQFu
         aMrA6hu1p+gZYdciLUNp0I1PftyzOfR9hwFgyynWGl8zzMgV4kt0NsGMV9OCMWMuv/Js
         lWu6eJCQBUpVlKfxHoA0IwbyorR/e6YzA0RmqRiJ9fD0pjSFouhAYmrKSfR2ZwGWJ5wI
         rdQIc5r5OJVWao29ydOPIwNg9/ZXSbAw1JrLwLYTM4F8aW616anltgi89RBpJb5OqNyf
         Na8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=jIDLialeG/PdtSOR8eplxARrVRCX+SlrjaAFFDps1vA=;
        b=E6qhp53i5qIktNlWkC1c6Z/pfMBKJZOMRtEpNL7BdwBLNYm5Fmsv8Ps+Nil4hYr8f7
         jCtuw/uBIxr04CRduBvNRK1TYZIxxSyw8nBw2/ZyqG19YjmzJHhG6ewRkBDmZQ2jHrPf
         uTvean1HFkpVrsUcNoXbhWqG0Et1/pohvK3NUdWS3kgvo3pOxnYVD5RAfkmENQmGKaEq
         vLbYp6DmF1YFDJJJZoMteY7IiBaKz0BDLTeFLNN0KF1d/W8KYEIzQja/kFc0/i0TJnlR
         HieUi0Pr4BXlddpDslTQkSNlQePG/sWuwH3m/oarla2BfTJzgsqtISyimBkSM4wonKUJ
         KVwg==
X-Gm-Message-State: ANhLgQ24Ff0edrN0W9Jco3lSdmhHJjD7mO/pS+4lVZas9ZdoJS8z/Xfe
        O2Do78xBp8sX+OC9OQKfmWgoTuv6
X-Google-Smtp-Source: ADFU+vvFqEggxiDNSkeyEKfNTd2wFjA1FaOE0l90oxWY9x9MBKzAuyHaPDaFS1KFyIzJjJ37rZIzbg==
X-Received: by 2002:a63:be0f:: with SMTP id l15mr11871430pgf.451.1585283160141;
        Thu, 26 Mar 2020 21:26:00 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id y17sm3004647pfl.104.2020.03.26.21.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 21:25:59 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        eric.dumazet@gmail.com, lmb@cloudflare.com, kafai@fb.com
Subject: [PATCHv3 bpf-next 1/5] bpf: Add socket assign support
Date:   Thu, 26 Mar 2020 21:25:52 -0700
Message-Id: <20200327042556.11560-2-joe@wand.net.nz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200327042556.11560-1-joe@wand.net.nz>
References: <20200327042556.11560-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for TPROXY via a new bpf helper, bpf_sk_assign().

This helper requires the BPF program to discover the socket via a call
to bpf_sk*_lookup_*(), then pass this socket to the new helper. The
helper takes its own reference to the socket in addition to any existing
reference that may or may not currently be obtained for the duration of
BPF processing. For the destination socket to receive the traffic, the
traffic must be routed towards that socket via local route. The
simplest example route is below, but in practice you may want to route
traffic more narrowly (eg by CIDR):

  $ ip route add local default dev lo

This patch avoids trying to introduce an extra bit into the skb->sk, as
that would require more invasive changes to all code interacting with
the socket to ensure that the bit is handled correctly, such as all
error-handling cases along the path from the helper in BPF through to
the orphan path in the input. Instead, we opt to use the destructor
variable to switch on the prefetch of the socket.

Signed-off-by: Joe Stringer <joe@wand.net.nz>
---
v3: Check skb_sk_is_prefetched() in TC level redirect check
v2: Use skb->destructor to determine socket prefetch usage instead of
      introducing a new metadata_dst
    Restrict socket assign to same netns as TC device
    Restrict assigning reuseport sockets
    Adjust commit wording
v1: Initial version
---
 include/net/sock.h             |  7 +++++++
 include/uapi/linux/bpf.h       | 25 ++++++++++++++++++++++++-
 net/core/filter.c              | 31 +++++++++++++++++++++++++++++++
 net/core/sock.c                |  9 +++++++++
 net/ipv4/ip_input.c            |  3 ++-
 net/ipv6/ip6_input.c           |  3 ++-
 net/sched/act_bpf.c            |  3 +++
 tools/include/uapi/linux/bpf.h | 25 ++++++++++++++++++++++++-
 8 files changed, 102 insertions(+), 4 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index b5cca7bae69b..2613d21a667a 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1657,6 +1657,7 @@ struct sk_buff *sock_omalloc(struct sock *sk, unsigned long size,
 void skb_orphan_partial(struct sk_buff *skb);
 void sock_rfree(struct sk_buff *skb);
 void sock_efree(struct sk_buff *skb);
+void sock_pfree(struct sk_buff *skb);
 #ifdef CONFIG_INET
 void sock_edemux(struct sk_buff *skb);
 #else
@@ -2526,6 +2527,12 @@ void sock_net_set(struct sock *sk, struct net *net)
 	write_pnet(&sk->sk_net, net);
 }
 
+static inline bool
+skb_sk_is_prefetched(struct sk_buff *skb)
+{
+	return skb->destructor == sock_pfree;
+}
+
 static inline struct sock *skb_steal_sock(struct sk_buff *skb)
 {
 	if (skb->sk) {
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 5d01c5c7e598..c77cd630a724 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2950,6 +2950,28 @@ union bpf_attr {
  *		restricted to raw_tracepoint bpf programs.
  *	Return
  *		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_sk_assign(struct sk_buff *skb, struct bpf_sock *sk, u64 flags)
+ *	Description
+ *		Assign the *sk* to the *skb*. When combined with appropriate
+ *		routing configuration to receive the packet towards the socket,
+ *		will cause *skb* to be delivered to the specified socket.
+ *		Subsequent redirection of *skb* via  **bpf_redirect**\ (),
+ *		**bpf_clone_redirect**\ () or other methods outside of BPF may
+ *		interfere with successful delivery to the socket.
+ *
+ *		This operation is only valid from TC ingress path.
+ *
+ *		The *flags* argument must be zero.
+ *	Return
+ *		0 on success, or a negative errno in case of failure.
+ *
+ *		* **-EINVAL**		Unsupported flags specified.
+ *		* **-ENOENT**		Socket is unavailable for assignment.
+ *		* **-ENETUNREACH**	Socket is unreachable (wrong netns).
+ *		* **-EOPNOTSUPP**	Unsupported operation, for example a
+ *					call from outside of TC ingress.
+ *		* **-ESOCKTNOSUPPORT**	Socket type not supported (reuseport).
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3073,7 +3095,8 @@ union bpf_attr {
 	FN(jiffies64),			\
 	FN(read_branch_records),	\
 	FN(get_ns_current_pid_tgid),	\
-	FN(xdp_output),
+	FN(xdp_output),			\
+	FN(sk_assign),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/net/core/filter.c b/net/core/filter.c
index 96350a743539..2bcc29c1a595 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5860,6 +5860,35 @@ static const struct bpf_func_proto bpf_tcp_gen_syncookie_proto = {
 	.arg5_type	= ARG_CONST_SIZE,
 };
 
+BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
+{
+	if (flags != 0)
+		return -EINVAL;
+	if (!skb_at_tc_ingress(skb))
+		return -EOPNOTSUPP;
+	if (unlikely(dev_net(skb->dev) != sock_net(sk)))
+		return -ENETUNREACH;
+	if (unlikely(sk->sk_reuseport))
+		return -ESOCKTNOSUPPORT;
+	if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
+		return -ENOENT;
+
+	skb_orphan(skb);
+	skb->sk = sk;
+	skb->destructor = sock_pfree;
+
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_sk_assign_proto = {
+	.func		= bpf_sk_assign,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type      = ARG_PTR_TO_CTX,
+	.arg2_type      = ARG_PTR_TO_SOCK_COMMON,
+	.arg3_type	= ARG_ANYTHING,
+};
+
 #endif /* CONFIG_INET */
 
 bool bpf_helper_changes_pkt_data(void *func)
@@ -6153,6 +6182,8 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_skb_ecn_set_ce_proto;
 	case BPF_FUNC_tcp_gen_syncookie:
 		return &bpf_tcp_gen_syncookie_proto;
+	case BPF_FUNC_sk_assign:
+		return &bpf_sk_assign_proto;
 #endif
 	default:
 		return bpf_base_func_proto(func_id);
diff --git a/net/core/sock.c b/net/core/sock.c
index 0fc8937a7ff4..cfaf60267360 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2071,6 +2071,15 @@ void sock_efree(struct sk_buff *skb)
 }
 EXPORT_SYMBOL(sock_efree);
 
+/* Buffer destructor for prefetch/receive path where reference count may
+ * not be held, e.g. for listen sockets.
+ */
+void sock_pfree(struct sk_buff *skb)
+{
+	sock_edemux(skb);
+}
+EXPORT_SYMBOL(sock_pfree);
+
 kuid_t sock_i_uid(struct sock *sk)
 {
 	kuid_t uid;
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index aa438c6758a7..b0c244af1e4d 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -509,7 +509,8 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 	IPCB(skb)->iif = skb->skb_iif;
 
 	/* Must drop socket now because of tproxy. */
-	skb_orphan(skb);
+	if (!skb_sk_is_prefetched(skb))
+		skb_orphan(skb);
 
 	return skb;
 
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 7b089d0ac8cd..e96304d8a4a7 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -285,7 +285,8 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
 	rcu_read_unlock();
 
 	/* Must drop socket now because of tproxy. */
-	skb_orphan(skb);
+	if (!skb_sk_is_prefetched(skb))
+		skb_orphan(skb);
 
 	return skb;
 err:
diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index 46f47e58b3be..54d5652cfe6c 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -12,6 +12,7 @@
 #include <linux/bpf.h>
 
 #include <net/netlink.h>
+#include <net/sock.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
 
@@ -53,6 +54,8 @@ static int tcf_bpf_act(struct sk_buff *skb, const struct tc_action *act,
 		bpf_compute_data_pointers(skb);
 		filter_res = BPF_PROG_RUN(filter, skb);
 	}
+	if (skb_sk_is_prefetched(skb) && filter_res != TC_ACT_OK)
+		skb_orphan(skb);
 	rcu_read_unlock();
 
 	/* A BPF program may overwrite the default action opcode.
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 5d01c5c7e598..c77cd630a724 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2950,6 +2950,28 @@ union bpf_attr {
  *		restricted to raw_tracepoint bpf programs.
  *	Return
  *		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_sk_assign(struct sk_buff *skb, struct bpf_sock *sk, u64 flags)
+ *	Description
+ *		Assign the *sk* to the *skb*. When combined with appropriate
+ *		routing configuration to receive the packet towards the socket,
+ *		will cause *skb* to be delivered to the specified socket.
+ *		Subsequent redirection of *skb* via  **bpf_redirect**\ (),
+ *		**bpf_clone_redirect**\ () or other methods outside of BPF may
+ *		interfere with successful delivery to the socket.
+ *
+ *		This operation is only valid from TC ingress path.
+ *
+ *		The *flags* argument must be zero.
+ *	Return
+ *		0 on success, or a negative errno in case of failure.
+ *
+ *		* **-EINVAL**		Unsupported flags specified.
+ *		* **-ENOENT**		Socket is unavailable for assignment.
+ *		* **-ENETUNREACH**	Socket is unreachable (wrong netns).
+ *		* **-EOPNOTSUPP**	Unsupported operation, for example a
+ *					call from outside of TC ingress.
+ *		* **-ESOCKTNOSUPPORT**	Socket type not supported (reuseport).
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3073,7 +3095,8 @@ union bpf_attr {
 	FN(jiffies64),			\
 	FN(read_branch_records),	\
 	FN(get_ns_current_pid_tgid),	\
-	FN(xdp_output),
+	FN(xdp_output),			\
+	FN(sk_assign),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.20.1

