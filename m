Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6C634BED6
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 22:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbhC1UUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 16:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbhC1UU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 16:20:27 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE26C061756;
        Sun, 28 Mar 2021 13:20:27 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id v24-20020a9d69d80000b02901b9aec33371so10361539oto.2;
        Sun, 28 Mar 2021 13:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=txJ7hdcrfRxsh60yxdjf17Knn8BTbiq4ZEsyTzM78uo=;
        b=Oih5wQxoHlxb8x2ETcVztr5fFEyH+1dVjYvyqRSqsTiR9a/D5pYyl4ZxkQuKUDncQR
         SXS9FpO1PMl3tKDKuVm2Wm/KId4zkpRBvjji+KYoH4lS9bnjqcMJfU6A/Gg0DQpXZLIu
         Ufg9bI3hSUvjviJx9dzK0Lb0DIk4OACqi7UpjvKPwAR5ZrCZ9cvxGFh2ZDJzittzyHtU
         Ek1J+KVRhH8wqz2VcYZC0VCJLaPSeXsjxB/dNpoCXJ4Mp1DwDAZh7KEDt86NF0xQ0eYJ
         IB9q4JRkoX05bKOkiwu1RdYl/ylbHG7hMXaSeOVMKkRLY3CaVMMVqVi7Qpdb8WcoDrjz
         MZ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=txJ7hdcrfRxsh60yxdjf17Knn8BTbiq4ZEsyTzM78uo=;
        b=I+zCWdwpz7H0pWevVeKbfmEzvFXYqx+Xlo6sEUOCwzs8SyMKUFt61igD2TVee7Kxan
         yoQoF9a5Ix9y9xYG9vYwQberD03yGVyvGt6/cF7Lh0nkH6WZ0F8lccag95Gvekvu4s5m
         GKDfRXc3SqLbn4SAOlUrKVN5ZmZvKiBEH3FB1dZptcphNH/JcTrL03upiDqDHZ6P0h8Y
         7K5+2Q+nfeo5AbCd6qiE8fudmty0Gg7bAmirPfJtByhAwnjHgOjtBrQt8AVyHDD+/dv1
         tjfMjjVeitbPA7NW0yxvYLXIhyQIxKHAH/B3JSONRix16UszrMiQ/w+vYfVlGXt07Zbw
         mExw==
X-Gm-Message-State: AOAM530piPya13L8BHDl+nWCHquZ05xLtqFFtdwNnjeb8saSUkJWirZj
        nRUQKil/eaAYCQfaCWdNR9Rfu9RsNY+GQw==
X-Google-Smtp-Source: ABdhPJys5YFhYrXBE4Gd8HUVjkCVYUbFnESX85OCg8qVgC4tCEJPyXoZonDczGzjwRnr6KrDmHoZ0w==
X-Received: by 2002:a9d:12cb:: with SMTP id g69mr19615340otg.77.1616962826595;
        Sun, 28 Mar 2021 13:20:26 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:bca7:4b69:be8f:21bb])
        by smtp.gmail.com with ESMTPSA id v30sm3898240otb.23.2021.03.28.13.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 13:20:26 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v7 07/13] sock_map: introduce BPF_SK_SKB_VERDICT
Date:   Sun, 28 Mar 2021 13:20:07 -0700
Message-Id: <20210328202013.29223-8-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
References: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Reusing BPF_SK_SKB_STREAM_VERDICT is possible but its name is
confusing and more importantly we still want to distinguish them
from user-space. So we can just reuse the stream verdict code but
introduce a new type of eBPF program, skb_verdict. Users are not
allowed to set stream_verdict and skb_verdict at the same time.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h          |  2 ++
 include/uapi/linux/bpf.h       |  1 +
 kernel/bpf/syscall.c           |  1 +
 net/core/skmsg.c               |  4 +++-
 net/core/sock_map.c            | 23 ++++++++++++++++++++++-
 tools/bpf/bpftool/common.c     |  1 +
 tools/bpf/bpftool/prog.c       |  1 +
 tools/include/uapi/linux/bpf.h |  1 +
 8 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index e7aba150539d..c83dbc2d81d9 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -58,6 +58,7 @@ struct sk_psock_progs {
 	struct bpf_prog			*msg_parser;
 	struct bpf_prog			*stream_parser;
 	struct bpf_prog			*stream_verdict;
+	struct bpf_prog			*skb_verdict;
 };
 
 enum sk_psock_state_bits {
@@ -487,6 +488,7 @@ static inline void psock_progs_drop(struct sk_psock_progs *progs)
 	psock_set_prog(&progs->msg_parser, NULL);
 	psock_set_prog(&progs->stream_parser, NULL);
 	psock_set_prog(&progs->stream_verdict, NULL);
+	psock_set_prog(&progs->skb_verdict, NULL);
 }
 
 int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 598716742593..49371eba98ba 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -957,6 +957,7 @@ enum bpf_attach_type {
 	BPF_XDP_CPUMAP,
 	BPF_SK_LOOKUP,
 	BPF_XDP,
+	BPF_SK_SKB_VERDICT,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 9603de81811a..6428634da57e 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2948,6 +2948,7 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 		return BPF_PROG_TYPE_SK_MSG;
 	case BPF_SK_SKB_STREAM_PARSER:
 	case BPF_SK_SKB_STREAM_VERDICT:
+	case BPF_SK_SKB_VERDICT:
 		return BPF_PROG_TYPE_SK_SKB;
 	case BPF_LIRC_MODE2:
 		return BPF_PROG_TYPE_LIRC_MODE2;
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 656eceab73bc..a045812d7c78 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -697,7 +697,7 @@ void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 	rcu_assign_sk_user_data(sk, NULL);
 	if (psock->progs.stream_parser)
 		sk_psock_stop_strp(sk, psock);
-	else if (psock->progs.stream_verdict)
+	else if (psock->progs.stream_verdict || psock->progs.skb_verdict)
 		sk_psock_stop_verdict(sk, psock);
 	write_unlock_bh(&sk->sk_callback_lock);
 
@@ -1024,6 +1024,8 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
 	}
 	skb_set_owner_r(skb, sk);
 	prog = READ_ONCE(psock->progs.stream_verdict);
+	if (!prog)
+		prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
 		skb_dst_drop(skb);
 		skb_bpf_redirect_clear(skb);
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index e564fdeaada1..c46709786a49 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -155,6 +155,8 @@ static void sock_map_del_link(struct sock *sk,
 				strp_stop = true;
 			if (psock->saved_data_ready && stab->progs.stream_verdict)
 				verdict_stop = true;
+			if (psock->saved_data_ready && stab->progs.skb_verdict)
+				verdict_stop = true;
 			list_del(&link->list);
 			sk_psock_free_link(link);
 		}
@@ -227,7 +229,7 @@ static struct sk_psock *sock_map_psock_get_checked(struct sock *sk)
 static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 			 struct sock *sk)
 {
-	struct bpf_prog *msg_parser, *stream_parser, *stream_verdict;
+	struct bpf_prog *msg_parser, *stream_parser, *stream_verdict, *skb_verdict;
 	struct sk_psock *psock;
 	int ret;
 
@@ -256,6 +258,15 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 		}
 	}
 
+	skb_verdict = READ_ONCE(progs->skb_verdict);
+	if (skb_verdict) {
+		skb_verdict = bpf_prog_inc_not_zero(skb_verdict);
+		if (IS_ERR(skb_verdict)) {
+			ret = PTR_ERR(skb_verdict);
+			goto out_put_msg_parser;
+		}
+	}
+
 	psock = sock_map_psock_get_checked(sk);
 	if (IS_ERR(psock)) {
 		ret = PTR_ERR(psock);
@@ -265,6 +276,7 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 	if (psock) {
 		if ((msg_parser && READ_ONCE(psock->progs.msg_parser)) ||
 		    (stream_parser  && READ_ONCE(psock->progs.stream_parser)) ||
+		    (skb_verdict && READ_ONCE(psock->progs.skb_verdict)) ||
 		    (stream_verdict && READ_ONCE(psock->progs.stream_verdict))) {
 			sk_psock_put(sk, psock);
 			ret = -EBUSY;
@@ -296,6 +308,9 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 	} else if (!stream_parser && stream_verdict && !psock->saved_data_ready) {
 		psock_set_prog(&psock->progs.stream_verdict, stream_verdict);
 		sk_psock_start_verdict(sk,psock);
+	} else if (!stream_verdict && skb_verdict && !psock->saved_data_ready) {
+		psock_set_prog(&psock->progs.skb_verdict, skb_verdict);
+		sk_psock_start_verdict(sk, psock);
 	}
 	write_unlock_bh(&sk->sk_callback_lock);
 	return 0;
@@ -304,6 +319,9 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 out_drop:
 	sk_psock_put(sk, psock);
 out_progs:
+	if (skb_verdict)
+		bpf_prog_put(skb_verdict);
+out_put_msg_parser:
 	if (msg_parser)
 		bpf_prog_put(msg_parser);
 out_put_stream_parser:
@@ -1468,6 +1486,9 @@ static int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog,
 	case BPF_SK_SKB_STREAM_VERDICT:
 		pprog = &progs->stream_verdict;
 		break;
+	case BPF_SK_SKB_VERDICT:
+		pprog = &progs->skb_verdict;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index 65303664417e..1828bba19020 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -57,6 +57,7 @@ const char * const attach_type_name[__MAX_BPF_ATTACH_TYPE] = {
 
 	[BPF_SK_SKB_STREAM_PARSER]	= "sk_skb_stream_parser",
 	[BPF_SK_SKB_STREAM_VERDICT]	= "sk_skb_stream_verdict",
+	[BPF_SK_SKB_VERDICT]		= "sk_skb_verdict",
 	[BPF_SK_MSG_VERDICT]		= "sk_msg_verdict",
 	[BPF_LIRC_MODE2]		= "lirc_mode2",
 	[BPF_FLOW_DISSECTOR]		= "flow_dissector",
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index f2b915b20546..3f067d2d7584 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -76,6 +76,7 @@ enum dump_mode {
 static const char * const attach_type_strings[] = {
 	[BPF_SK_SKB_STREAM_PARSER] = "stream_parser",
 	[BPF_SK_SKB_STREAM_VERDICT] = "stream_verdict",
+	[BPF_SK_SKB_VERDICT] = "skb_verdict",
 	[BPF_SK_MSG_VERDICT] = "msg_verdict",
 	[BPF_FLOW_DISSECTOR] = "flow_dissector",
 	[__MAX_BPF_ATTACH_TYPE] = NULL,
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index ab9f2233607c..69902603012c 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -957,6 +957,7 @@ enum bpf_attach_type {
 	BPF_XDP_CPUMAP,
 	BPF_SK_LOOKUP,
 	BPF_XDP,
+	BPF_SK_SKB_VERDICT,
 	__MAX_BPF_ATTACH_TYPE
 };
 
-- 
2.25.1

