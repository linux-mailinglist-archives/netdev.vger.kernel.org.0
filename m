Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B440B791AD
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbfG2Q7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:59:41 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46586 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727487AbfG2Q7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 12:59:33 -0400
Received: by mail-pg1-f195.google.com with SMTP id k189so9516795pgk.13;
        Mon, 29 Jul 2019 09:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ClW+0hpgqgiDIXEC4dPRtbYibKS9Vk0HSZ+hghtMn6g=;
        b=nie5mf+NuGyPzY1gzyL1l6WRjhaUUxl5T23zo0WKY0lJA91FU/plPGShalk56FBJm4
         lHEHPoy0ebk7Zs/zJcoXMwLAIBR1TP/2e4Zwi57+50q1TOX5+omu0V2MYi6yVZKHaH0A
         aCaG7Szk7IkRTSg6beNTvEdexfrQVy0WXAlsrQAWmWpPGPJBncyJ9NXtKH0XcCiKS3lt
         ZaO140A7Bqczneafsl4DUt9rMz+6yGOauPLf9YtAGV2VETGTwORhhHKczt5ScUQszm6R
         9KB6S/i3hDCu+R2iAeeDU3klpc8Qhm+KQlTpJMvLs9qQABSIR5cdtgOaEqqb9dj2URFV
         yHiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ClW+0hpgqgiDIXEC4dPRtbYibKS9Vk0HSZ+hghtMn6g=;
        b=AciqKPlrkbpVyHFU/ihTSW7DlTUkjclP72iZRyz4r0Id0D5pTViVI9L25Gi3Rj9cQ/
         CsUcGxiaPpFyL6V49nEbtMr58ldSP4/UMyW1QceYqf4RRuTp+AF+s6d3j8TyAoaum6Ji
         3FR8hZgxxEnCwUAqT6BXdW63GZc8fib12k+xUmKGeVdCHMT2d9oTVhjKV/W+CeJc/zU7
         8SK/xxOLaGrOMOnNsDIMsYdBU+s1p38/soKh8IyDSxgi68hWhZZbI8She2hWlOOQ7Toi
         atOVlsPFOkgVqrGE4gmJOhfoa1vmatahSVOcpCVSXRxfGr5NyhAzkNkw5xuxlpgmi8RB
         NPfw==
X-Gm-Message-State: APjAAAUdF1ohUJWe28Gmj76RIBsnLp6r/tI4EcawFUTMvEzbr5HGSv9/
        H/8IKIxyldqUdjn6DiHmHSPdHQm9
X-Google-Smtp-Source: APXvYqw2i+m9jr9PD6Y9n69WD3ZneGseTxiWFqDC5SWt+CJUi7kJs0NAoKnwHSvwEgTJcFm6d7VFTQ==
X-Received: by 2002:aa7:8201:: with SMTP id k1mr36632220pfi.97.1564419573167;
        Mon, 29 Jul 2019 09:59:33 -0700 (PDT)
Received: from ppenkov.svl.corp.google.com ([2620:15c:2c4:201:7bd4:4f27:abe4:d695])
        by smtp.gmail.com with ESMTPSA id i198sm60784651pgd.44.2019.07.29.09.59.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 09:59:32 -0700 (PDT)
From:   Petar Penkov <ppenkov.kernel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, lmb@cloudflare.com, sdf@google.com,
        toke@redhat.com, Petar Penkov <ppenkov@google.com>
Subject: [bpf-next,v2 3/6] bpf: add bpf_tcp_gen_syncookie helper
Date:   Mon, 29 Jul 2019 09:59:15 -0700
Message-Id: <20190729165918.92933-4-ppenkov.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.709.g102302147b-goog
In-Reply-To: <20190729165918.92933-1-ppenkov.kernel@gmail.com>
References: <20190729165918.92933-1-ppenkov.kernel@gmail.com>
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
Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
---
 include/uapi/linux/bpf.h | 30 ++++++++++++++++-
 net/core/filter.c        | 73 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 102 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index e985f07a98ed..5a54f1011db8 100644
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
+ *		**-EOPNOTSUPP** kernel configuration does not enable SYN cookies
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
index 3961437ccc50..d7848d6944ff 100644
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
+	return -EOPNOTSUPP;
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
@@ -6139,6 +6208,8 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_tcp_check_syncookie_proto;
 	case BPF_FUNC_skb_ecn_set_ce:
 		return &bpf_skb_ecn_set_ce_proto;
+	case BPF_FUNC_tcp_gen_syncookie:
+		return &bpf_tcp_gen_syncookie_proto;
 #endif
 	default:
 		return bpf_base_func_proto(func_id);
@@ -6178,6 +6249,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_skc_lookup_tcp_proto;
 	case BPF_FUNC_tcp_check_syncookie:
 		return &bpf_tcp_check_syncookie_proto;
+	case BPF_FUNC_tcp_gen_syncookie:
+		return &bpf_tcp_gen_syncookie_proto;
 #endif
 	default:
 		return bpf_base_func_proto(func_id);
-- 
2.22.0.709.g102302147b-goog

