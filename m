Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11DD316B896
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 05:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbgBYEqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 23:46:12 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:40530 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728725AbgBYEqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 23:46:12 -0500
Received: by mail-pj1-f67.google.com with SMTP id 12so729943pjb.5;
        Mon, 24 Feb 2020 20:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1A0YWW6rbB/xJ7k1L6H16agsdnh5ewiBRcsNXC12TGc=;
        b=eDq3d77A9whj7aiDFhu/hlrb0kfp3qaazHK0prgGTyxycTK5Qvt8FTq1IROQ+fZHUR
         lxTUyn+nJ5KI2Cm5iLqtcW8DY8l+DKBm5cT6sD2z4RaY/8q3rH1Lhb7n/R5mhiGY5bJw
         Nqzl8rH86GhP7MQkRUjbKInrz+3jr4pzdCBydmvc08mSUOSbPhUxYoZDgg4b7wlCJc7h
         Hrywt5dT++wKRM9G2GrmrhtoIYQTB4BzqSvIGIlvZwCOgCwn+ZgyWU+4WVZ3RYjK287K
         HmxkCNkmVzgNr1vIWEK/CeOKZ49lND5FGEeAR2zSmpMSOkrmUbTv2BqN68NEznNAGclu
         JemQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1A0YWW6rbB/xJ7k1L6H16agsdnh5ewiBRcsNXC12TGc=;
        b=E52xhdb8SEEg9GqiDDZqTL4/8KIJFbGx9cKHrMiSHt5IGOa64BbPH1mqluoa+hCnbD
         XlNqRclhM8t9ciCQVCirvWw4J9JFIoPyq0l5D3E+KTGkbSQAvkA+m/CNV6OKBVaayzv5
         bSuXLq5c+B10QN6Afmep7MaKEY6kzSNUedzYzt40HLLXEO07LBjXDHOEbSS6O7sx8yZG
         YFaA67/egsZxAQnLAtpQTmwHk4Ek8nWuxekB2yXGTcGCnqbLor0bLe9WkyxEf1ybQ+5q
         2SCoSP+xHuc+wzMQWG4p8p5R61rSgb35c9R04LkDyFfhxMghm1BlOgkDKWeFDUgsZRzH
         hyMA==
X-Gm-Message-State: APjAAAUwDR6XmbMm++Zw3VrFP5P+xUeDsD6PytnRAx240pFj02WVOofZ
        5NPdyjdjAiato3gEo6lYAf03kyv7JXU=
X-Google-Smtp-Source: APXvYqzpxBK0dVd7tgTR88bhRmrbxqCHpWZh2dqWgIQ3XvqlYkWpXJQ/UJDsh5MnqfbGUzRYo4EVBw==
X-Received: by 2002:a17:902:123:: with SMTP id 32mr54429734plb.38.1582605971207;
        Mon, 24 Feb 2020 20:46:11 -0800 (PST)
Received: from kernel.rdqbwbcbjylexclmhxlbqg5jve.hx.internal.cloudapp.net ([65.52.171.215])
        by smtp.gmail.com with ESMTPSA id l13sm1170879pjq.23.2020.02.24.20.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 20:46:10 -0800 (PST)
From:   Lingpeng Chen <forrest0579@gmail.com>
To:     bpf <bpf@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Petar Penkov <ppenkov.kernel@gmail.com>,
        Song Liu <song@kernel.org>,
        Lingpeng Chen <forrest0579@gmail.com>
Subject: [PATCH v4 bpf-next 1/3] bpf: Add get_netns_id helper function for sock_ops
Date:   Tue, 25 Feb 2020 04:45:36 +0000
Message-Id: <20200225044538.61889-2-forrest0579@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200225044538.61889-1-forrest0579@gmail.com>
References: <CAPhsuW6QkQ8-pXamQVzTXLPzyb4-FCeF_6To7sa_=gd7Ea5VpA@mail.gmail.com>
 <20200225044538.61889-1-forrest0579@gmail.com>
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
index 906e9f2752db..c53178f7585e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2909,6 +2909,12 @@ union bpf_attr {
  *		of sizeof(struct perf_branch_entry).
  *
  *		**-ENOENT** if architecture does not support branch records.
+ *
+ * u64 bpf_get_netns_id(struct bpf_sock_ops *bpf_socket)
+ *  Description
+ *      Obtain netns id of sock
+ * Return
+ *      The current netns inum
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3030,7 +3036,8 @@ union bpf_attr {
 	FN(tcp_send_ack),		\
 	FN(send_signal_thread),		\
 	FN(jiffies64),			\
-	FN(read_branch_records),
+	FN(read_branch_records),	\
+	FN(get_netns_id),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/net/core/filter.c b/net/core/filter.c
index 925b23de218b..98536b0eecb6 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4421,6 +4421,24 @@ static const struct bpf_func_proto bpf_sock_ops_cb_flags_set_proto = {
 	.arg2_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_1(bpf_get_netns_id, struct bpf_sock_ops_kern *, bpf_sock)
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
+static const struct bpf_func_proto bpf_get_netns_id_proto = {
+	.func		= bpf_get_netns_id,
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
+		return &bpf_get_netns_id_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
-- 
2.20.1

