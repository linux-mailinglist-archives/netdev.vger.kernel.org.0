Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1D331920D0
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 06:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgCYF6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 01:58:00 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46800 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgCYF6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 01:58:00 -0400
Received: by mail-pg1-f194.google.com with SMTP id k191so620003pgc.13;
        Tue, 24 Mar 2020 22:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LOBnpjoCVWdEtHtGbj23rQxMzW+lA3sQQ/MK31NWfSY=;
        b=WYrAZa5KP/CQ+JtkJnlSTmWyxrK7U3l/IYMwuDc+OW9c6ZePD3nOizVrFTW3v/SmxD
         Khh9VTGuT4ZT1mpLhLQN5m3DjdhI7AN4EBpwKEQgtN7TOupxkFmV5siT/dcAW8FsciOl
         tjX1kFObMcSB1JTUBIOMvoDXd6en+AHS2PFwVJDqgQkylZ0/5W24hmaW6hbCMGlvJAJ+
         OPxnpl0mU3+7UIJhOxFMMoCgJs9qjg380MqpX929Fv8eiuevNcWj2SUCWphfdzHkp4P1
         F384LPJ7EVYWqv6awEk1q5c8zC25FCtEV5CMVVkBIRhWORosECCNLYE83s5bUoT547ti
         K2Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=LOBnpjoCVWdEtHtGbj23rQxMzW+lA3sQQ/MK31NWfSY=;
        b=KFS5RYjZ+yeDeLHDukygJloXI172gcSTM0ayE3itnaorwcrcOPj8SuJYNe/O7Fdrco
         sc/SJa2+vwbKAwSiNuTmSDJgdHhwV9RoaKAFko5pUpXt1QhNrOw2+Mf4NnjrYCmEMwyh
         FmxEyFwXTo2nRaCzXcX2bbZ+K8l9O0jRiGMp9VBP0XLdYMHGx7iacqmoBZXuC2snbSKA
         RxTnvPL3aUC40PvvVx+kSkHhoIMV2Zs1FLboXzvGZTa0nE3OEyOg4rISFIlPEUPM6C4N
         P6kPVOYbwF9NRBKgqqoBQ9Im7qCKpCU1yfN5iqKoyTnPVQsXQO+h5akjXHqEhv/o24pR
         wWlA==
X-Gm-Message-State: ANhLgQ2uQgGrYpr2VnLN2VDRHG3cU6jFaBUEkD2mw5IRNWEab8l7JmYS
        osYfy9Jl7VKS23EY8cG6lqRSJ5tW
X-Google-Smtp-Source: ADFU+vspkAFUsoDQ6wAjtIGsL0M2QsHKc3w4CPKSxhsPLai5s1SE2+3eF+1QuSY9hx7u7h3SLpYFaQ==
X-Received: by 2002:a63:54e:: with SMTP id 75mr1423427pgf.398.1585115877812;
        Tue, 24 Mar 2020 22:57:57 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id e10sm17605716pfm.121.2020.03.24.22.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 22:57:57 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        eric.dumazet@gmail.com, lmb@cloudflare.com, kafai@fb.com
Subject: [PATCHv2 bpf-next 1/5] bpf: Add socket assign support
Date:   Tue, 24 Mar 2020 22:57:41 -0700
Message-Id: <20200325055745.10710-2-joe@wand.net.nz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200325055745.10710-1-joe@wand.net.nz>
References: <20200325055745.10710-1-joe@wand.net.nz>
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
 net/sched/act_bpf.c            |  2 ++
 tools/include/uapi/linux/bpf.h | 25 ++++++++++++++++++++++++-
 8 files changed, 101 insertions(+), 4 deletions(-)

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
index 5d01c5c7e598..0c6f151deebe 100644
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
+ *		* **-ENETUNREACH**	Socket is unreachable (wrong netns).
+ *		* **-ENOENT**		Socket is unavailable for assignment.
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
index 96350a743539..f7f9b6631f75 100644
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
+	if (unlikely(sk->sk_reuseport))
+		return -ESOCKTNOSUPPORT;
+	if (unlikely(dev_net(skb->dev) != sock_net(sk)))
+		return -ENETUNREACH;
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
index 46f47e58b3be..6c7ed8fcc909 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -53,6 +53,8 @@ static int tcf_bpf_act(struct sk_buff *skb, const struct tc_action *act,
 		bpf_compute_data_pointers(skb);
 		filter_res = BPF_PROG_RUN(filter, skb);
 	}
+	if (filter_res != TC_ACT_OK)
+		skb_orphan(skb);
 	rcu_read_unlock();
 
 	/* A BPF program may overwrite the default action opcode.
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 5d01c5c7e598..0c6f151deebe 100644
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
+ *		* **-ENETUNREACH**	Socket is unreachable (wrong netns).
+ *		* **-ENOENT**		Socket is unavailable for assignment.
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

