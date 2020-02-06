Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D11A615405E
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 09:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbgBFIfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 03:35:38 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33164 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgBFIfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 03:35:38 -0500
Received: by mail-pf1-f195.google.com with SMTP id n7so2741318pfn.0;
        Thu, 06 Feb 2020 00:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wqpyjU0n3OmiOsQbYIqtIy20XMoUmnxbL5Dsi+CEG04=;
        b=bHmMgmp2mgcHOwaeWlxnFGFNYTvgOL1+4mrh9LR1jA+hux5+Iriv085itlaMDzKQC/
         wm+0OY3WWfY8teEnclundpusOFlxCqgckqlJIImkKLH4l+xf2QQpM2UH4KugijJ+utEm
         fedpsN37Kt4bLJrHsK6EVIrpO2YaH8pvOgiG3UELQ0sPbUQ2sxY5MOCHcIa8JscEL+AD
         tbCqSEOFjKG2CjiQklZWoYZoDASLcZgNCXTU8sYxtH3TgrFc3RsnhoTIy3VBv7hgnN9C
         36+qCv3obyoIGC/vcR3tAuYFMIKew/Bt7Mbh7CDzrgEqVcjzeVZo4+401trWYkHjkwsa
         m/yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wqpyjU0n3OmiOsQbYIqtIy20XMoUmnxbL5Dsi+CEG04=;
        b=d3Jmy0e6fK0r3FVWQTFWYnVouI0zuLnMuGE0NGCtShbLTDB0rXRzo8hB4mgO9KmxnQ
         qeJ9QmC2rVZxTIPZpuFztkhI1lPXXxme2StjqR0WrK23aC1U6nM2SZ3h39baACmPscH0
         NZJBvKIws7wGK9UAp1gsgIZDTichVH356hUxHw/onUqzWLwGSg6dqIyu8di0Aq4M/pbt
         4mMV1a7p6XgbpgD2Uwsp9wvkKZS9eomAFOG4Ym3+f1o5neIY0KsN60ENkuTp/IgoYJtc
         1D3yVoeKGv+QDE7vm7Zk9lJj/ory6jh/xMsqHq5QTxhhJMOMwG67JxOw5wNQDiVDtMhi
         NEug==
X-Gm-Message-State: APjAAAXvw+/15jbknu5GhjOVU6MgSQ6L1wbZP2k2polH1P29ZO3vKO6Z
        nkMnga7Gd+k71qTF1NkZ9tw7WNiGZ12EGw==
X-Google-Smtp-Source: APXvYqxsmpE6SoTdG0DQUKERZaqcGyyEy2AKzXe7AhQVTWAVZ5p2o1VYXfm9mXL7E9dQa11/UtxGhw==
X-Received: by 2002:aa7:9a01:: with SMTP id w1mr2488648pfj.231.1580978137204;
        Thu, 06 Feb 2020 00:35:37 -0800 (PST)
Received: from localhost.localdomain ([124.156.165.26])
        by smtp.gmail.com with ESMTPSA id 5sm2292070pfx.163.2020.02.06.00.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 00:35:36 -0800 (PST)
From:   Lingpeng Chen <forrest0579@gmail.com>
To:     bpf <bpf@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Lingpeng Chen <forrest0579@gmail.com>
Subject: [PATCH bpf-next 1/2] bpf: Add sock ops get netns helpers
Date:   Thu,  6 Feb 2020 16:35:14 +0800
Message-Id: <20200206083515.10334-2-forrest0579@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200206083515.10334-1-forrest0579@gmail.com>
References: <20200206083515.10334-1-forrest0579@gmail.com>
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
Using bpf_sock_ops_get_netns helpers to get current connection
netns number to distinguish connections.

Signed-off-by: Lingpeng Chen <forrest0579@gmail.com>
---
 include/uapi/linux/bpf.h |  8 +++++++-
 net/core/filter.c        | 18 ++++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index f1d74a2bd234..b15a55051232 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2892,6 +2892,11 @@ union bpf_attr {
  *		Obtain the 64bit jiffies
  *	Return
  *		The 64 bit jiffies
+ * u32 bpf_sock_ops_get_netns(struct bpf_sock_ops *bpf_socket)
+ *  Description
+ *      Obtain netns id of sock
+ * Return
+ *      The current netns inum
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3012,7 +3017,8 @@ union bpf_attr {
 	FN(probe_read_kernel_str),	\
 	FN(tcp_send_ack),		\
 	FN(send_signal_thread),		\
-	FN(jiffies64),
+	FN(jiffies64),		\
+	FN(sock_ops_get_netns),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/net/core/filter.c b/net/core/filter.c
index 792e3744b915..b7f33f20e8fb 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4421,6 +4421,22 @@ static const struct bpf_func_proto bpf_sock_ops_cb_flags_set_proto = {
 	.arg2_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_1(bpf_sock_ops_get_netns, struct bpf_sock_ops_kern *, bpf_sock)
+{
+	struct sock *sk = bpf_sock->sk;
+
+	if (!IS_ENABLED(CONFIG_NET_NS))
+		return 0;
+	return sk->sk_net.net->ns.inum;
+}
+
+static const struct bpf_func_proto bpf_sock_ops_get_netns_proto = {
+	.func		= bpf_sock_ops_get_netns,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+};
+
 const struct ipv6_bpf_stub *ipv6_bpf_stub __read_mostly;
 EXPORT_SYMBOL_GPL(ipv6_bpf_stub);
 
@@ -6218,6 +6234,8 @@ sock_ops_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_tcp_sock:
 		return &bpf_tcp_sock_proto;
 #endif /* CONFIG_INET */
+	case BPF_FUNC_sock_ops_get_netns:
+		return &bpf_sock_ops_get_netns_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
-- 
2.17.1

