Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCAB32A2E6
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 15:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377906AbhCBIni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:43:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443986AbhCBCil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 21:38:41 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20EA5C06178B;
        Mon,  1 Mar 2021 18:37:55 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id w69so20485861oif.1;
        Mon, 01 Mar 2021 18:37:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R0Ojmw0D2lDoqGY2EK1tsZimcNKC42bH4E+kY1K6FpI=;
        b=AGcNBf4f7BqYj1puJ/t6NxUMt092Y/xARajCd9ETb+LFdXy0G5huHB+eASxwaheo5H
         irNR3fcNHyNhyyK5U+84LNEtf3s4E6HywMzhdx+/lZgOdGgUzXIlJprtzTuylJSUuvbH
         gWpchAGP16Y5yM5wICwQGxAk8npOeHsHp+5Qr/uunR5cg1E3VTewZJiTmwQgIRAeFDTS
         Ia1XPN/NFZ9qLlJ0C8hFIalXmis2N6Ehr/cLIC635KqrNzRuyJfRdbM9wrtB6g3g1JSl
         pZ7F2ISpYlP2bVttSw+W1XqYuyMZTScIP7mDhhCMmcI1bpjjuavuhNFfXn1S9mr8wATz
         v+gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R0Ojmw0D2lDoqGY2EK1tsZimcNKC42bH4E+kY1K6FpI=;
        b=dDue01tc8gL5E8q5zooLeFru3loH75rtpTeTOA2EskRjRaotCjWVUdjKZ0gAhtdqfb
         4QQcHCVa2QCEajhKzhZKXw3lA/8K+cI1nM61hDykCR9gll+uBTDiX3WXAVuXpuWOBqU+
         GxOOzXx2LXV7Mhntuljm56lx8roxFi9FEU77KzTbysDfeZ8/GiJewsgWpKxgmSblqC7Z
         1fuiPE19hWrpgzUTBqRn+v/gL+7urVBrleuE2WCelxik4yDXJ5/l6qzjgl5HvNFHcaCm
         nKRATuvUtrWOveTsWNrKowChJzUBHcjOblnKJoEyv7H4cKJTRTnjaieG7Lu8ms9dwpim
         uKwQ==
X-Gm-Message-State: AOAM530LSW5YYyX+lbeanHMHGxP2qOrGWj/PSpfiyxPHZbO9Fb1vh/OA
        nRMvwtCHyAKgSKLV3GAf1/YW4tc4a9+dDg==
X-Google-Smtp-Source: ABdhPJwftY1RbFknra67NrwF8kDg5/YZztQimQK3jVrm8gdPFvLIKdRiMGIaeGXG21fhnFemFlfvwg==
X-Received: by 2002:aca:2406:: with SMTP id n6mr1674534oic.56.1614652674393;
        Mon, 01 Mar 2021 18:37:54 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1bb:8d29:39ef:5fe5])
        by smtp.gmail.com with ESMTPSA id a30sm100058oiy.42.2021.03.01.18.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 18:37:53 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v2 1/9] sock_map: introduce BPF_SK_SKB_VERDICT
Date:   Mon,  1 Mar 2021 18:37:35 -0800
Message-Id: <20210302023743.24123-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
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
 include/linux/skmsg.h          |  3 +++
 include/uapi/linux/bpf.h       |  1 +
 kernel/bpf/syscall.c           |  1 +
 net/core/skmsg.c               |  4 +++-
 net/core/sock_map.c            | 23 ++++++++++++++++++++++-
 tools/bpf/bpftool/common.c     |  1 +
 tools/bpf/bpftool/prog.c       |  1 +
 tools/include/uapi/linux/bpf.h |  1 +
 8 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 6c09d94be2e9..451530d41af7 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -58,6 +58,7 @@ struct sk_psock_progs {
 	struct bpf_prog			*msg_parser;
 	struct bpf_prog			*stream_parser;
 	struct bpf_prog			*stream_verdict;
+	struct bpf_prog			*skb_verdict;
 };
 
 enum sk_psock_state_bits {
@@ -442,6 +443,7 @@ static inline void psock_progs_drop(struct sk_psock_progs *progs)
 	psock_set_prog(&progs->msg_parser, NULL);
 	psock_set_prog(&progs->stream_parser, NULL);
 	psock_set_prog(&progs->stream_verdict, NULL);
+	psock_set_prog(&progs->skb_verdict, NULL);
 }
 
 int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb);
@@ -489,5 +491,6 @@ static inline void skb_bpf_redirect_clear(struct sk_buff *skb)
 {
 	skb->_sk_redir = 0;
 }
+
 #endif /* CONFIG_NET_SOCK_MSG */
 #endif /* _LINUX_SKMSG_H */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b89af20cfa19..1a08ab00a45e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -247,6 +247,7 @@ enum bpf_attach_type {
 	BPF_XDP_CPUMAP,
 	BPF_SK_LOOKUP,
 	BPF_XDP,
+	BPF_SK_SKB_VERDICT,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index c859bc46d06c..afa803a1553e 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2941,6 +2941,7 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 		return BPF_PROG_TYPE_SK_MSG;
 	case BPF_SK_SKB_STREAM_PARSER:
 	case BPF_SK_SKB_STREAM_VERDICT:
+	case BPF_SK_SKB_VERDICT:
 		return BPF_PROG_TYPE_SK_SKB;
 	case BPF_LIRC_MODE2:
 		return BPF_PROG_TYPE_LIRC_MODE2;
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 07f54015238a..5efd790f1b47 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -693,7 +693,7 @@ void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 	rcu_assign_sk_user_data(sk, NULL);
 	if (psock->progs.stream_parser)
 		sk_psock_stop_strp(sk, psock);
-	else if (psock->progs.stream_verdict)
+	else if (psock->progs.stream_verdict || psock->progs.skb_verdict)
 		sk_psock_stop_verdict(sk, psock);
 	write_unlock_bh(&sk->sk_callback_lock);
 	sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
@@ -1010,6 +1010,8 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
 	}
 	skb_set_owner_r(skb, sk);
 	prog = READ_ONCE(psock->progs.stream_verdict);
+	if (!prog)
+		prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
 		skb_dst_drop(skb);
 		skb_bpf_redirect_clear(skb);
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index dd53a7771d7e..3bddd9dd2da2 100644
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
index b89af20cfa19..1a08ab00a45e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -247,6 +247,7 @@ enum bpf_attach_type {
 	BPF_XDP_CPUMAP,
 	BPF_SK_LOOKUP,
 	BPF_XDP,
+	BPF_SK_SKB_VERDICT,
 	__MAX_BPF_ATTACH_TYPE
 };
 
-- 
2.25.1

