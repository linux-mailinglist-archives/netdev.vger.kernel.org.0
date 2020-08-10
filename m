Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E125240685
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 15:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgHJNUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 09:20:54 -0400
Received: from mail-m1271.qiye.163.com ([115.236.127.1]:58787 "EHLO
        mail-m1271.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgHJNUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 09:20:52 -0400
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Aug 2020 09:20:50 EDT
Received: from ubuntu.localdomain (unknown [58.251.74.227])
        by mail-m1271.qiye.163.com (Hmail) with ESMTPA id 35E3258224D;
        Mon, 10 Aug 2020 21:11:01 +0800 (CST)
From:   Jiang Yu <jyu.jiang@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        zhanglin <zhang.lin16@zte.com.cn>,
        Kees Cook <keescook@chromium.org>,
        Andrey Ignatov <rdna@fb.com>,
        Quentin Monnet <quentin@isovalent.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Cc:     opensource.kernel@vivo.com, Jiang Yu <jyu.jiang@vivo.com>
Subject: [PATCH] bpf: Add bpf_skb_get_sock_comm() helper
Date:   Mon, 10 Aug 2020 06:09:48 -0700
Message-Id: <20200810131014.12057-1-jyu.jiang@vivo.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZTE8ZGR5OT0hIH0xOVkpOQkxLTU5LTUpCTEhVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZVUtZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6K0k6Szo*IT8vNU4dDywuDCIB
        FAkwCT5VSlVKTkJMS01OS01JSEJNVTMWGhIXVRECDlUREhoVHDsNEg0UVRgUFkVZV1kSC1lBWU5D
        VUlOSlVMT1VJSUxZV1kIAVlBTUlOTDcG
X-HM-Tid: 0a73d87ee60098b6kuuu35e3258224d
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb distinguished by uid can only recorded to user who consume them.
in many case, skb should been recorded more specific to process who
consume them. E.g, the unexpected large data traffic of illegal process
in metered network.

this helper is used in tracing task comm of the sock to which a skb
belongs.

Signed-off-by: Jiang Yu <jyu.jiang@vivo.com>
---
 include/net/sock.h             |  1 +
 include/uapi/linux/bpf.h       |  1 +
 net/core/filter.c              | 32 ++++++++++++++++++++++++++++++++
 net/core/sock.c                | 20 ++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  1 +
 5 files changed, 55 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index 064637d1ddf6..9c6e8e61940f 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -519,6 +519,7 @@ struct sock {
 #ifdef CONFIG_BPF_SYSCALL
 	struct bpf_sk_storage __rcu	*sk_bpf_storage;
 #endif
+	char sk_task_com[TASK_COMM_LEN];
 	struct rcu_head		sk_rcu;
 };
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b134e679e9db..c7f62215a483 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3538,6 +3538,7 @@ union bpf_attr {
 	FN(skc_to_tcp_request_sock),	\
 	FN(skc_to_udp6_sock),		\
 	FN(get_task_stack),		\
+	FN(skb_get_sock_comm),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index 7124f0fe6974..972c0bf8e7ca 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4313,6 +4313,36 @@ static const struct bpf_func_proto bpf_get_socket_uid_proto = {
 	.arg1_type      = ARG_PTR_TO_CTX,
 };
 
+BPF_CALL_3(bpf_skb_get_sock_comm,     struct sk_buff *, skb, char *, buf, u32, size)
+{
+	struct sock *sk;
+
+	if (!buf || 0 == size)
+		return -EINVAL;
+
+	sk = sk_to_full_sk(skb->sk);
+	if (!sk || !sk_fullsock(sk))
+		goto err_clear;
+
+	memcpy(buf, sk->sk_task_com, size);
+	buf[size - 1] = 0;
+	return 0;
+
+err_clear:
+	memset(buf, 0, size);
+	buf[size - 1] = 0;
+	return -ENOENT;
+}
+
+const struct bpf_func_proto bpf_skb_get_sock_comm_proto = {
+	.func           = bpf_skb_get_sock_comm,
+	.gpl_only       = false,
+	.ret_type       = RET_INTEGER,
+	.arg1_type      = ARG_PTR_TO_CTX,
+	.arg2_type      = ARG_PTR_TO_MEM,
+	.arg3_type      = ARG_CONST_SIZE,
+};
+
 #define SOCKOPT_CC_REINIT (1 << 0)
 
 static int _bpf_setsockopt(struct sock *sk, int level, int optname,
@@ -6313,6 +6343,8 @@ sk_filter_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_socket_cookie_proto;
 	case BPF_FUNC_get_socket_uid:
 		return &bpf_get_socket_uid_proto;
+	case BPF_FUNC_skb_get_sock_comm:
+		return &bpf_skb_get_sock_comm_proto;
 	case BPF_FUNC_perf_event_output:
 		return &bpf_skb_event_output_proto;
 	default:
diff --git a/net/core/sock.c b/net/core/sock.c
index d29709e0790d..79d81afa048f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2961,6 +2961,24 @@ void sk_stop_timer(struct sock *sk, struct timer_list* timer)
 }
 EXPORT_SYMBOL(sk_stop_timer);
 
+void sock_init_task_comm(struct sock *sk)
+{
+	struct pid *pid = NULL;
+	struct task_struct *tgid_task = NULL;
+
+	pid = find_get_pid(current->tgid);
+	if (pid) {
+		tgid_task = get_pid_task(pid, PIDTYPE_PID);
+
+		if (tgid_task) {
+			snprintf(sk->sk_task_com, TASK_COMM_LEN, tgid_task->comm);
+			put_task_struct(tgid_task);
+		}
+
+		put_pid(pid);
+	}
+}
+
 void sock_init_data(struct socket *sock, struct sock *sk)
 {
 	sk_init_common(sk);
@@ -3031,6 +3049,8 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	WRITE_ONCE(sk->sk_pacing_shift, 10);
 	sk->sk_incoming_cpu = -1;
 
+	sock_init_task_comm(sk);
+
 	sk_rx_queue_clear(sk);
 	/*
 	 * Before updating sk_refcnt, we must commit prior changes to memory
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b134e679e9db..c7f62215a483 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3538,6 +3538,7 @@ union bpf_attr {
 	FN(skc_to_tcp_request_sock),	\
 	FN(skc_to_udp6_sock),		\
 	FN(get_task_stack),		\
+	FN(skb_get_sock_comm),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.25.1

