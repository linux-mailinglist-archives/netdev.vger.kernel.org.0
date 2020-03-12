Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3439183D6D
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 00:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgCLXg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 19:36:58 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43387 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbgCLXg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 19:36:56 -0400
Received: by mail-pf1-f193.google.com with SMTP id c144so4045467pfb.10;
        Thu, 12 Mar 2020 16:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hds0QIRYrjA+X6+fdepz7VEu7G+vCOmFvm8ev69haCo=;
        b=vfF+aq3Y+mkdxZ2orCJFoKEj1caclB4WV0Z5Xk2fNteIfQ9oX8epsTiBUq13veZc+V
         5074v0Jk3iuStsnhGbtBidAmlKEmWCHBo6pHXYsyuibB54Z0HB5nKVXoLprydpeC6TQm
         Ly/Qcvo4PMOhDsLNvCkoof/awnxOFokxNRbfnUSN5qKWKwmqja8u+5zqKtEuW+eIkEDl
         RCYI9mLkPHt3ZIwJp/Y1XR+S2mKtL6kbfFBTC4G5mxN2KGefTJcWywXeBi4iu+9PF3Q1
         T0ACEr2PiR0soOGIxORsXXZeH42A6qh9p6BHrZGEvJirDpATrJuq4+O2PMmZp9jbmWyL
         EhNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Hds0QIRYrjA+X6+fdepz7VEu7G+vCOmFvm8ev69haCo=;
        b=JwRPtTc39dxGPKHsz8dJPwjaiXAqP6SZPtjaAlInMt5fDpPUDdM/niCx7fTEBVMf+G
         FouGD/2XvrhDlQ+hMID2ip9s8r+x611Ep+x4gmmzxnL1VJfD84hA2/IxhDtEkPOLHslW
         tx5C043ElZ+VQKYsR2nbfsj2wqXkBAOJYFIQ1mNODBhoo9mUnjXK1jTjqk4UoB5XzTvR
         yUjNVTz9X/mZnGeCiB3avhT2htP7EwZkczIC9d0ig67WKnfRbsuCpJ3JWVgeUK1zbqHG
         u2JU+mWUsPpvgnHMRL/AoVI+oopqjCdbWHt9GZBy+6emDv4iY/ollv1z8Ho6CrimIudM
         Luwg==
X-Gm-Message-State: ANhLgQ3KER+fA9zGO34vH9s6qu5QEQ327b7cSah5sy5yKGesA/8ahH02
        yPNUoCB/ju8UV92iDMokUwADzlyv
X-Google-Smtp-Source: ADFU+vtUksjdXHb6C7u2B8nK4GDSwhgJDoX+ZFLxxMoB1tXyzzPi+X/FFstfSV9sDF+MYFhBHBpzyg==
X-Received: by 2002:a05:6a00:c8:: with SMTP id e8mr7906362pfj.131.1584056214648;
        Thu, 12 Mar 2020 16:36:54 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id d6sm5075225pfn.214.2020.03.12.16.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 16:36:54 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        eric.dumazet@gmail.com, lmb@cloudflare.com
Subject: [PATCH bpf-next 3/7] bpf: Add socket assign support
Date:   Thu, 12 Mar 2020 16:36:44 -0700
Message-Id: <20200312233648.1767-4-joe@wand.net.nz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200312233648.1767-1-joe@wand.net.nz>
References: <20200312233648.1767-1-joe@wand.net.nz>
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
traffic must be routed towards that socket via local route, the socket
must have the transparent option enabled out-of-band, and the socket
must not be closing. If all of these conditions hold, the socket will be
assigned to the skb to allow delivery to the socket.

The recently introduced dst_sk_prefetch is used to communicate from the
TC layer to the IP receive layer that the socket should be retained
across the receive. The dst_sk_prefetch destination wraps any existing
destination (if available) and stores it temporarily in a per-cpu var.

To ensure that no dst references held by the skb prior to sk_assign()
are lost, they are stored in the per-cpu variable associated with
dst_sk_prefetch. When the BPF program invocation from the TC action
completes, we check the return code against TC_ACT_OK and if any other
return code is used, we restore the dst to avoid unintentionally leaking
the reference held in the per-CPU variable. If the packet is cloned or
dropped before reaching ip{,6}_rcv_core(), the original dst will also be
restored from the per-cpu variable to avoid the leak; if the packet makes
its way to the receive function for the protocol, then the destination
(if any) will be restored to the packet at that point.

Signed-off-by: Joe Stringer <joe@wand.net.nz>
---
 include/uapi/linux/bpf.h       | 23 ++++++++++++++++++++++-
 net/core/filter.c              | 28 ++++++++++++++++++++++++++++
 net/core/skbuff.c              |  3 +++
 net/ipv4/ip_input.c            |  5 ++++-
 net/ipv6/ip6_input.c           |  5 ++++-
 net/sched/act_bpf.c            |  3 +++
 tools/include/uapi/linux/bpf.h | 18 +++++++++++++++++-
 7 files changed, 81 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 40b2d9476268..35f282cc745e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2914,6 +2914,26 @@ union bpf_attr {
  *		of sizeof(struct perf_branch_entry).
  *
  *		**-ENOENT** if architecture does not support branch records.
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
+ *		* **-EOPNOTSUPP**:	Unsupported operation, for example a
+ *					call from outside of TC ingress.
+ *		* **-ENOENT**		The socket cannot be assigned.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3035,7 +3055,8 @@ union bpf_attr {
 	FN(tcp_send_ack),		\
 	FN(send_signal_thread),		\
 	FN(jiffies64),			\
-	FN(read_branch_records),
+	FN(read_branch_records),	\
+	FN(sk_assign),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/net/core/filter.c b/net/core/filter.c
index cd0a532db4e7..bae0874289d8 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5846,6 +5846,32 @@ static const struct bpf_func_proto bpf_tcp_gen_syncookie_proto = {
 	.arg5_type	= ARG_CONST_SIZE,
 };
 
+BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
+{
+	if (flags != 0)
+		return -EINVAL;
+	if (!skb_at_tc_ingress(skb))
+		return -EOPNOTSUPP;
+	if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
+		return -ENOENT;
+
+	skb_orphan(skb);
+	skb->sk = sk;
+	skb->destructor = sock_edemux;
+	dst_sk_prefetch_store(skb);
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
@@ -6139,6 +6165,8 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_skb_ecn_set_ce_proto;
 	case BPF_FUNC_tcp_gen_syncookie:
 		return &bpf_tcp_gen_syncookie_proto;
+	case BPF_FUNC_sk_assign:
+		return &bpf_sk_assign_proto;
 #endif
 	default:
 		return bpf_base_func_proto(func_id);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 6b2798450fd4..80ee8f7b6a19 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -63,6 +63,7 @@
 
 #include <net/protocol.h>
 #include <net/dst.h>
+#include <net/dst_metadata.h>
 #include <net/sock.h>
 #include <net/checksum.h>
 #include <net/ip6_checksum.h>
@@ -1042,6 +1043,7 @@ EXPORT_SYMBOL_GPL(alloc_skb_for_msg);
  */
 void skb_dst_drop(struct sk_buff *skb)
 {
+	dst_sk_prefetch_reset(skb);
 	if (skb->_skb_refdst) {
 		refdst_drop(skb->_skb_refdst);
 		skb->_skb_refdst = 0UL;
@@ -1466,6 +1468,7 @@ struct sk_buff *skb_clone(struct sk_buff *skb, gfp_t gfp_mask)
 		n->fclone = SKB_FCLONE_UNAVAILABLE;
 	}
 
+	dst_sk_prefetch_reset(skb);
 	return __skb_clone(n, skb);
 }
 EXPORT_SYMBOL(skb_clone);
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index aa438c6758a7..9bd4858d20fc 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -509,7 +509,10 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 	IPCB(skb)->iif = skb->skb_iif;
 
 	/* Must drop socket now because of tproxy. */
-	skb_orphan(skb);
+	if (skb_dst_is_sk_prefetch(skb))
+		dst_sk_prefetch_fetch(skb);
+	else
+		skb_orphan(skb);
 
 	return skb;
 
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 7b089d0ac8cd..f7b42adca9d0 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -285,7 +285,10 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
 	rcu_read_unlock();
 
 	/* Must drop socket now because of tproxy. */
-	skb_orphan(skb);
+	if (skb_dst_is_sk_prefetch(skb))
+		dst_sk_prefetch_fetch(skb);
+	else
+		skb_orphan(skb);
 
 	return skb;
 err:
diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index 46f47e58b3be..b4c557e6158d 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -11,6 +11,7 @@
 #include <linux/filter.h>
 #include <linux/bpf.h>
 
+#include <net/dst_metadata.h>
 #include <net/netlink.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
@@ -53,6 +54,8 @@ static int tcf_bpf_act(struct sk_buff *skb, const struct tc_action *act,
 		bpf_compute_data_pointers(skb);
 		filter_res = BPF_PROG_RUN(filter, skb);
 	}
+	if (filter_res != TC_ACT_OK)
+		dst_sk_prefetch_reset(skb);
 	rcu_read_unlock();
 
 	/* A BPF program may overwrite the default action opcode.
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 40b2d9476268..546e9e1368ff 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2914,6 +2914,21 @@ union bpf_attr {
  *		of sizeof(struct perf_branch_entry).
  *
  *		**-ENOENT** if architecture does not support branch records.
+ *
+ * int bpf_sk_assign(struct sk_buff *skb, struct bpf_sock *sk, u64 flags)
+ *	Description
+ *		Assign the *sk* to the *skb*.
+ *
+ *		This operation is only valid from TC ingress path.
+ *
+ *		The *flags* argument must be zero.
+ *	Return
+ *		0 on success, or a negative errno in case of failure.
+ *
+ *		* **-EINVAL**		Unsupported flags specified.
+ *		* **-EOPNOTSUPP**:	Unsupported operation, for example a
+ *					call from outside of TC ingress.
+ *		* **-ENOENT**		The socket cannot be assigned.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3035,7 +3050,8 @@ union bpf_attr {
 	FN(tcp_send_ack),		\
 	FN(send_signal_thread),		\
 	FN(jiffies64),			\
-	FN(read_branch_records),
+	FN(read_branch_records),	\
+	FN(sk_assign),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.20.1

