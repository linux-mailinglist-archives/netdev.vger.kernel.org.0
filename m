Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30900165841
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 08:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgBTHLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 02:11:42 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39927 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgBTHLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 02:11:42 -0500
Received: by mail-pf1-f196.google.com with SMTP id 84so1454190pfy.6;
        Wed, 19 Feb 2020 23:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wjulShMOO0gDrLH+lKcbEkeCD+HRPpuA+2aEjQjkYOY=;
        b=Q0yrzo/hmN5bLMcb0f0D9QqLvDPQ5aNllIqvyp9ngR44aOWGMejlrqsQI23nKt/Ekr
         hQ3ijWgYjYYF4gE/Vgs+BbRmSqvI0X3m6ipJm8z1SBybClNyEqyE2M8V8994lNx3A5PA
         GBLnbbG2DWFkfm/1ZSSo79ETBi57uDiNHdltKEqJDT0l4H1skJLyZzpd6TBRpt2J4BhB
         sin+3LCQahRNs3G1BDy8DpUMgNemBMYCiQ1L0CSlHp9g1ywd9HYGf2t+lULaHP9O/POg
         960zSXHppcQ7QMFDzNE3ihQLsin+POoAx77bGlx4u6TerM9s6Wllx+ENlPdrEPi9WQNW
         UmyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wjulShMOO0gDrLH+lKcbEkeCD+HRPpuA+2aEjQjkYOY=;
        b=XvzT2YMBL+5oaJMQD9CNEeaQjvrOAuAR1XIJgTwaN8V0Hfij8NjQ6dCZsP6DRLk3VS
         liHdRwAXR0jI9kku0GHkC2+JSN49+TZclYndRHZkPa4vsZbJ8Hlscr4G5VigPSXkxd/i
         1plwr0L6YxGZwEMibopPpcoAZhe4JDo1vxkfwinpR4jXXiyujFSESwc6fOHbI3Ha1FY7
         BRobwtgM09Q+26gbA87RMi23eEGcCsy6RwjOSVsOZG2AGTuNikLGx+f/fNuFyampu7Om
         PBoeetSyU88jy4VrWS6WBErSgO2yBiQeREmM1QAjt3w2n8hwq4dZkF3Sq741gpaEZ5A0
         9qig==
X-Gm-Message-State: APjAAAUoZXtWz/RHJcN8fMRfyxomjBLAAYCp4fZsHNvbhKAWPQEbn7Hq
        4F7MjvgdObtuGApsCwKwnszSmx1q4Nw=
X-Google-Smtp-Source: APXvYqx8/ljD6//aC/PUGORJkuM7Yn99q+no7TA7jcB126kqCj0XiR3gNuXoxHCC1hS3SxfD1iYP2A==
X-Received: by 2002:a62:ac03:: with SMTP id v3mr30486191pfe.17.1582182701754;
        Wed, 19 Feb 2020 23:11:41 -0800 (PST)
Received: from kernel.rdqbwbcbjylexclmhxlbqg5jve.hx.internal.cloudapp.net ([65.52.171.215])
        by smtp.gmail.com with ESMTPSA id p4sm2148325pgh.14.2020.02.19.23.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 23:11:41 -0800 (PST)
From:   Lingpeng Chen <forrest0579@gmail.com>
To:     bpf <bpf@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Petar Penkov <ppenkov.kernel@gmail.com>,
        Lingpeng Chen <forrest0579@gmail.com>
Subject: [PATCH v3 bpf-next 1/3] bpf: Add get_netns_id helper function for sock_ops
Date:   Thu, 20 Feb 2020 07:10:52 +0000
Message-Id: <20200220071054.12499-2-forrest0579@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200220071054.12499-1-forrest0579@gmail.com>
References: <07e2568e-0256-29f5-1656-1ac80a69f229@iogearbox.net>
 <20200220071054.12499-1-forrest0579@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently 5-tuple(sip+dip+sport+dport+proto) can't identify a
uniq connection because there may be multi net namespace.
For example, there may be a chance that netns a and netns b all
listen on 127.0.0.1:8080 and the client with same port 40782
connect to them. Without netns number, sock ops program
can't distinguish them.
Using bpf_get_netns_id helper to get current connection
netns id to distinguish connections.

Signed-off-by: Lingpeng Chen <forrest0579@gmail.com>
---
 include/uapi/linux/bpf.h |  9 ++++++++-
 net/core/filter.c        | 20 ++++++++++++++++++++
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index f1d74a2bd234..e79082f78b74 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2892,6 +2892,12 @@ union bpf_attr {
  *		Obtain the 64bit jiffies
  *	Return
  *		The 64 bit jiffies
+ *
+ * u64 bpf_get_netns_id(struct bpf_sock_ops *bpf_socket)
+ *  Description
+ *      Obtain netns id of sock
+ * Return
+ *      The current netns inum
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3012,7 +3018,8 @@ union bpf_attr {
 	FN(probe_read_kernel_str),	\
 	FN(tcp_send_ack),		\
 	FN(send_signal_thread),		\
-	FN(jiffies64),
+	FN(jiffies64),			\
+	FN(get_netns_id),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/net/core/filter.c b/net/core/filter.c
index c180871e606d..5302ec9f7c0d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4421,6 +4421,24 @@ static const struct bpf_func_proto bpf_sock_ops_cb_flags_set_proto = {
 	.arg2_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_1(bpf_get_netns_id_sock_ops, struct bpf_sock_ops_kern *, bpf_sock)
+{
+#ifdef CONFIG_NET_NS
+	struct sock *sk = bpf_sock->sk;
+
+	return (u64)sk->sk_net.net->ns.inum;
+#else
+	return 0;
+#endif
+}
+
+static const struct bpf_func_proto bpf_get_netns_id_sock_ops_proto = {
+	.func		= bpf_get_netns_id_sock_ops,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+};
+
 const struct ipv6_bpf_stub *ipv6_bpf_stub __read_mostly;
 EXPORT_SYMBOL_GPL(ipv6_bpf_stub);
 
@@ -6218,6 +6236,8 @@ sock_ops_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_tcp_sock:
 		return &bpf_tcp_sock_proto;
 #endif /* CONFIG_INET */
+	case BPF_FUNC_get_netns_id:
+		return &bpf_get_netns_id_sock_ops_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
-- 
2.20.1

