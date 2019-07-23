Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78A1470E0B
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 02:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387650AbfGWAUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 20:20:53 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41414 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387633AbfGWAUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 20:20:51 -0400
Received: by mail-pf1-f196.google.com with SMTP id m30so18171677pff.8;
        Mon, 22 Jul 2019 17:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vgF24LyexnjpZpBmhmlOA7onPmOTJnnC05UHG8RL20Y=;
        b=QmKz5oLb/eawxPj0k71yzqxhwrI1ta3Cmh1Ffhbio88xij6YwJCPtRGKANTFZvg0eI
         PzmX4+JLel8i03B5xWdnBqTbygiXAtzQn4YeYoXdWwJr9h9haab8kk6yHwKkbwF+a4ma
         Sr6hL1S+f0upSW8RVDQuot7Iy1iNvbtTCN2ZxXHJgnUnU9U6p6oWYMPvQfQvPrcP07ei
         uliiipoINSNBUXwQwaYIxMlMxyeer0Kroye4pOB28pMBFetSF/9oH19IH5HPbGZtEGoc
         tm3T28aT3D9c4txzpEW48zuFUSyTLVRlUOf0QxczcofwLXeVwwxPXVp0FFm5R2+BpVf1
         3vEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vgF24LyexnjpZpBmhmlOA7onPmOTJnnC05UHG8RL20Y=;
        b=LF9p8rPbaUbh/BqBtN/T+OWyqCmTZ4JGWcFR/qsQR8pm6Asxj+VNbC1mSann55pNJh
         jyd5gXEx8Ko0ULDheog/BuiW4YYYTNeUZVo1Ury6jQgsUI/quh4LgX0WNstahHZTn499
         RJd6OI+cnDhQ7tak3+IUVumczak2jHFIjy+TZJ9IxInqXEbfvS+Mpi7Pg2RoRzGBJLGU
         n/Aimi2xVmQzxHBPjEUzmHrCw0/B0UBjIZBu8jHbYC7nxXh3QEwDmU9aX2NR4Q4O3HZS
         6ifc6WQpFPPdukehJUnZR/kozhUqsSRChRnzVSijZIbaKYtEB0236r9JsycAX0nuJ6A8
         nDkQ==
X-Gm-Message-State: APjAAAW4n7k+4uYkOg7BWzhBxrowgYke2uYj0bLWpKqNh0duoNC5J9DF
        1By/caxzF6lVx5GH2BpghdK8ZXlA
X-Google-Smtp-Source: APXvYqxmaLkeCINfGQW98uGFGVs4A/nGZLBzVxHW754kU93V3fn8P+2drFYONC4dn/hACeSzkvBqTg==
X-Received: by 2002:a63:eb51:: with SMTP id b17mr71887692pgk.384.1563841250731;
        Mon, 22 Jul 2019 17:20:50 -0700 (PDT)
Received: from ppenkov.svl.corp.google.com ([2620:15c:2c4:201:7bd4:4f27:abe4:d695])
        by smtp.gmail.com with ESMTPSA id k64sm21718423pge.65.2019.07.22.17.20.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 17:20:50 -0700 (PDT)
From:   Petar Penkov <ppenkov.kernel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, lmb@cloudflare.com, sdf@google.com,
        Petar Penkov <ppenkov@google.com>
Subject: [bpf-next 3/6] bpf: add bpf_tcp_gen_syncookie helper
Date:   Mon, 22 Jul 2019 17:20:39 -0700
Message-Id: <20190723002042.105927-4-ppenkov.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
In-Reply-To: <20190723002042.105927-1-ppenkov.kernel@gmail.com>
References: <20190723002042.105927-1-ppenkov.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petar Penkov <ppenkov@google.com>

This helper function allows BPF programs to try to generate SYN
cookies, given a reference to a listener socket. The function works
from XDP and with an skb context since bpf_skc_lookup_tcp can lookup a
socket in both cases.

Signed-off-by: Petar Penkov <ppenkov@google.com>
Suggested-by: Eric Dumazet <edumazet@google.com>
---
 include/uapi/linux/bpf.h | 30 ++++++++++++++++-
 net/core/filter.c        | 73 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 102 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 6f68438aa4ed..20baee7b2219 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2713,6 +2713,33 @@ union bpf_attr {
  *		**-EPERM** if no permission to send the *sig*.
  *
  *		**-EAGAIN** if bpf program can try again.
+ *
+ * s64 bpf_tcp_gen_syncookie(struct bpf_sock *sk, void *iph, u32 iph_len, struct tcphdr *th, u32 th_len)
+ *	Description
+ *		Try to issue a SYN cookie for the packet with corresponding
+ *		IP/TCP headers, *iph* and *th*, on the listening socket in *sk*.
+ *
+ *		*iph* points to the start of the IPv4 or IPv6 header, while
+ *		*iph_len* contains **sizeof**\ (**struct iphdr**) or
+ *		**sizeof**\ (**struct ip6hdr**).
+ *
+ *		*th* points to the start of the TCP header, while *th_len*
+ *		contains the length of the TCP header.
+ *
+ *	Return
+ *		On success, lower 32 bits hold the generated SYN cookie in
+ *		followed by 16 bits which hold the MSS value for that cookie,
+ *		and the top 16 bits are unused.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EINVAL** SYN cookie cannot be issued due to error
+ *
+ *		**-ENOENT** SYN cookie should not be issued (no SYN flood)
+ *
+ *		**-ENOTSUPP** kernel configuration does not enable SYN cookies
+ *
+ *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2824,7 +2851,8 @@ union bpf_attr {
 	FN(strtoul),			\
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
-	FN(send_signal),
+	FN(send_signal),		\
+	FN(tcp_gen_syncookie),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/net/core/filter.c b/net/core/filter.c
index 47f6386fb17a..92114271eff6 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5850,6 +5850,75 @@ static const struct bpf_func_proto bpf_tcp_check_syncookie_proto = {
 	.arg5_type	= ARG_CONST_SIZE,
 };
 
+BPF_CALL_5(bpf_tcp_gen_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
+	   struct tcphdr *, th, u32, th_len)
+{
+#ifdef CONFIG_SYN_COOKIES
+	u32 cookie;
+	u16 mss;
+
+	if (unlikely(th_len < sizeof(*th) || th_len != th->doff * 4))
+		return -EINVAL;
+
+	if (sk->sk_protocol != IPPROTO_TCP || sk->sk_state != TCP_LISTEN)
+		return -EINVAL;
+
+	if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies)
+		return -ENOENT;
+
+	if (!th->syn || th->ack || th->fin || th->rst)
+		return -EINVAL;
+
+	if (unlikely(iph_len < sizeof(struct iphdr)))
+		return -EINVAL;
+
+	/* Both struct iphdr and struct ipv6hdr have the version field at the
+	 * same offset so we can cast to the shorter header (struct iphdr).
+	 */
+	switch (((struct iphdr *)iph)->version) {
+	case 4:
+		if (sk->sk_family == AF_INET6 && sk->sk_ipv6only)
+			return -EINVAL;
+
+		mss = tcp_v4_get_syncookie(sk, iph, th, &cookie);
+		break;
+
+#if IS_BUILTIN(CONFIG_IPV6)
+	case 6:
+		if (unlikely(iph_len < sizeof(struct ipv6hdr)))
+			return -EINVAL;
+
+		if (sk->sk_family != AF_INET6)
+			return -EINVAL;
+
+		mss = tcp_v6_get_syncookie(sk, iph, th, &cookie);
+		break;
+#endif /* CONFIG_IPV6 */
+
+	default:
+		return -EPROTONOSUPPORT;
+	}
+	if (mss <= 0)
+		return -ENOENT;
+
+	return cookie | ((u64)mss << 32);
+#else
+	return -ENOTSUPP;
+#endif /* CONFIG_SYN_COOKIES */
+}
+
+static const struct bpf_func_proto bpf_tcp_gen_syncookie_proto = {
+	.func		= bpf_tcp_gen_syncookie,
+	.gpl_only	= true, /* __cookie_v*_init_sequence() is GPL */
+	.pkt_access	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_SOCK_COMMON,
+	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_CONST_SIZE,
+	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg5_type	= ARG_CONST_SIZE,
+};
+
 #endif /* CONFIG_INET */
 
 bool bpf_helper_changes_pkt_data(void *func)
@@ -6135,6 +6204,8 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_tcp_check_syncookie_proto;
 	case BPF_FUNC_skb_ecn_set_ce:
 		return &bpf_skb_ecn_set_ce_proto;
+	case BPF_FUNC_tcp_gen_syncookie:
+		return &bpf_tcp_gen_syncookie_proto;
 #endif
 	default:
 		return bpf_base_func_proto(func_id);
@@ -6174,6 +6245,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_skc_lookup_tcp_proto;
 	case BPF_FUNC_tcp_check_syncookie:
 		return &bpf_tcp_check_syncookie_proto;
+	case BPF_FUNC_tcp_gen_syncookie:
+		return &bpf_tcp_gen_syncookie_proto;
 #endif
 	default:
 		return bpf_base_func_proto(func_id);
-- 
2.22.0.657.g960e92d24f-goog

