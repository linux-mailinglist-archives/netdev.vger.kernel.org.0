Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51D5E1970E6
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 00:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729288AbgC2Wxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 18:53:51 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37961 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727591AbgC2Wxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 18:53:50 -0400
Received: by mail-pj1-f67.google.com with SMTP id m15so6507795pje.3;
        Sun, 29 Mar 2020 15:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7Q9we1QvB6zj/YAzkcMxjsbghvTQXpHH+PS811R2LAY=;
        b=mHVmaj++gXFIcwTWZwRVJscesHXBCo3LQ+M+UJ8yvab5MFAHShH5x3rj9NZ/8JnDyM
         AYCj9LI/62D8/9oIvUuyup5Ih4qrMLwzT47vzBKeLChk8Ul8m0kl1hS/ajf3om8+iWmc
         NUHlb5E0VXTx95thWFOYalzRqyOAr+tsHGUkUKzawC2zGB7xx7LWi/6duC+zf0esuDFQ
         BuKdXds+5OT/4hScIERhDZH6273U+Nx1nac5nRynch+r3WzzkPap17XwW3fVZ5Jzi0YI
         VSivM9b46h8aRrdzPTW9XIvMKjZBIoNYWZGuJZ35vl1f7BftKuYcPgkth7y0Y9Qo+PN1
         JDHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=7Q9we1QvB6zj/YAzkcMxjsbghvTQXpHH+PS811R2LAY=;
        b=cUlkxzQrLdTg7qCKK88iIw+K+UJiDJTwKyYRAk4pvMvrojwgbjelJmQiesxwGOP/as
         XV3R0zyNYtZjQKKAWQMeHZwK2s1PZ/X0YEcjp/PQyjkwBHOoV6pVRFiCaY/Wkjj9eEXX
         I8pyKwSBmrspAXD47WDnlMNNkUZVTRtO2sMCf/Zi0LNx2haPtqFAvD0n5QU2Xcl8ADbF
         Y+KYn+yQyQPW+OCvS4f0z0qVYSjYLYCvLuLUYX1sJ58RbXHkWF8GqiL/Z2sbMNJz8aoV
         cGXPk0+lM4OU+/Rn9c71RKP46c72zCKJOKkbFMmuMBbjEokNEodVNap34csxWpK/MPDP
         SiLw==
X-Gm-Message-State: ANhLgQ3Zxce+j2JyRdJ8D5kQX0jI8ZRGrMs5GoEqf1O5e5s/PzcrSY6e
        bFKVhAUx0nM9Txj59GMHK/TkdyFo
X-Google-Smtp-Source: ADFU+vtPSNYivwpoeEhjRald7FBx0SKge4U6AN+eFbiNKPza3MiOmRMXbEOEzi3NZQKzHLhcKq0gUA==
X-Received: by 2002:a17:90a:c401:: with SMTP id i1mr12324542pjt.131.1585522429134;
        Sun, 29 Mar 2020 15:53:49 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id i187sm8710386pfg.33.2020.03.29.15.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 15:53:48 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        eric.dumazet@gmail.com, lmb@cloudflare.com, kafai@fb.com
Subject: [PATCHv5 bpf-next 1/5] bpf: Add socket assign support
Date:   Sun, 29 Mar 2020 15:53:38 -0700
Message-Id: <20200329225342.16317-2-joe@wand.net.nz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200329225342.16317-1-joe@wand.net.nz>
References: <20200329225342.16317-1-joe@wand.net.nz>
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
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
v5: Guard sock_gen_put() with #ifdef for CONFIG_INET
v4: Use sock_gen_put() directly in sock_pfree()
    Rebase
    Acked
v3: Check skb_sk_is_prefetched() in TC level redirect check
v2: Use skb->destructor to determine socket prefetch usage instead of
      introducing a new metadata_dst
    Restrict socket assign to same netns as TC device
    Restrict assigning reuseport sockets
    Adjust commit wording
v1: Initial version
---
 include/net/sock.h             | 11 +++++++++++
 include/uapi/linux/bpf.h       | 25 ++++++++++++++++++++++++-
 net/core/filter.c              | 31 +++++++++++++++++++++++++++++++
 net/core/sock.c                | 11 +++++++++++
 net/ipv4/ip_input.c            |  3 ++-
 net/ipv6/ip6_input.c           |  3 ++-
 net/sched/act_bpf.c            |  3 +++
 tools/include/uapi/linux/bpf.h | 25 ++++++++++++++++++++++++-
 8 files changed, 108 insertions(+), 4 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index b5cca7bae69b..dc398cee7873 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1659,6 +1659,7 @@ void sock_rfree(struct sk_buff *skb);
 void sock_efree(struct sk_buff *skb);
 #ifdef CONFIG_INET
 void sock_edemux(struct sk_buff *skb);
+void sock_pfree(struct sk_buff *skb);
 #else
 #define sock_edemux sock_efree
 #endif
@@ -2526,6 +2527,16 @@ void sock_net_set(struct sock *sk, struct net *net)
 	write_pnet(&sk->sk_net, net);
 }
 
+static inline bool
+skb_sk_is_prefetched(struct sk_buff *skb)
+{
+#ifdef CONFIG_INET
+	return skb->destructor == sock_pfree;
+#else
+	return false;
+#endif /* CONFIG_INET */
+}
+
 static inline struct sock *skb_steal_sock(struct sk_buff *skb)
 {
 	if (skb->sk) {
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 222ba11966e3..2ae402fe272a 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2981,6 +2981,28 @@ union bpf_attr {
  * 		**bpf_get_current_cgroup_id**\ ().
  * 	Return
  * 		The id is returned or 0 in case the id could not be retrieved.
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
@@ -3106,7 +3128,8 @@ union bpf_attr {
 	FN(get_ns_current_pid_tgid),	\
 	FN(xdp_output),			\
 	FN(get_netns_cookie),		\
-	FN(get_current_ancestor_cgroup_id),
+	FN(get_current_ancestor_cgroup_id),	\
+	FN(sk_assign),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/net/core/filter.c b/net/core/filter.c
index bb4a196c8809..ac5c1633f8d2 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5918,6 +5918,35 @@ static const struct bpf_func_proto bpf_tcp_gen_syncookie_proto = {
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
@@ -6249,6 +6278,8 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_skb_ecn_set_ce_proto;
 	case BPF_FUNC_tcp_gen_syncookie:
 		return &bpf_tcp_gen_syncookie_proto;
+	case BPF_FUNC_sk_assign:
+		return &bpf_sk_assign_proto;
 #endif
 	default:
 		return bpf_base_func_proto(func_id);
diff --git a/net/core/sock.c b/net/core/sock.c
index 0fc8937a7ff4..87e3a03c9056 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2071,6 +2071,17 @@ void sock_efree(struct sk_buff *skb)
 }
 EXPORT_SYMBOL(sock_efree);
 
+/* Buffer destructor for prefetch/receive path where reference count may
+ * not be held, e.g. for listen sockets.
+ */
+#ifdef CONFIG_INET
+void sock_pfree(struct sk_buff *skb)
+{
+	sock_gen_put(skb->sk);
+}
+EXPORT_SYMBOL(sock_pfree);
+#endif /* CONFIG_INET */
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
index 222ba11966e3..2ae402fe272a 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2981,6 +2981,28 @@ union bpf_attr {
  * 		**bpf_get_current_cgroup_id**\ ().
  * 	Return
  * 		The id is returned or 0 in case the id could not be retrieved.
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
@@ -3106,7 +3128,8 @@ union bpf_attr {
 	FN(get_ns_current_pid_tgid),	\
 	FN(xdp_output),			\
 	FN(get_netns_cookie),		\
-	FN(get_current_ancestor_cgroup_id),
+	FN(get_current_ancestor_cgroup_id),	\
+	FN(sk_assign),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.20.1

