Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB576345405
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 01:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhCWAjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 20:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbhCWAi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 20:38:28 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE91C061762;
        Mon, 22 Mar 2021 17:38:25 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id y5so11166100qkl.9;
        Mon, 22 Mar 2021 17:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Gy7tDuRfeUFuz0b2V+w0UYbQ8JS3pLtgS4NvNblzE28=;
        b=kqK0fOJh8eqgA1jpwNpFbokKq2usP7Vys7IqtDA/hLHIOx5i9NMs6JjEgqN5KBqN5/
         9cKXvxxA15xMdhlO+FTdjrT6l0SlLqx2LQI0LiXQtPRBNgshMKMl3xqO3vmnyqhWWE1I
         tby/4Zfy4lpPMPeWd7tK8PSvltMGqivJIVNdRdvOKR+WF+CU6ZrgCNSCibJEqoRA2sLy
         05GCvcoleAkvEzB0Mx30oF9yeJz3Rz8BLhQb10gn1Y8T7AVOnWoAzcnarhxIT2BRQzFV
         SHm2ue4j4CBFcYzDl1k7QYAh4UNUeFPA/dZJlVTRViZ8gzL3Qek0TuHUowIUZbdrMZoS
         KU+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gy7tDuRfeUFuz0b2V+w0UYbQ8JS3pLtgS4NvNblzE28=;
        b=UrWZfoweD753En3mCEuRGdMDS6oqNcv1sFC4mB9B3tdpj4zghq2POJw54XrdU1tBQB
         +ADJfqsj30cQMfVgrWhVrEx80O7jjkAyhDrd6cbIGzpiQwsWYULXozhGVdvTN5bzdtPa
         EKQYfKyarEXLPtjWp6F2ig/5xOdGIXszPEeGPa1hYuMksevg8ZyUnZFD008XKbGaGNy9
         8xTAkIEouKwUX0C0sY6Kv28zczwh0ePN4c0FyFI6Tc/7XPOXFJ+66mvlpDZRT5agZPNg
         MREoxvbrV/i1J9GiEN/3W0IWM1xyh8mwnq1sLx9VAFqLO7T9FrecraPVGwxuCVbXViq+
         kVmw==
X-Gm-Message-State: AOAM530m0f/rfdhy5MEmfhlrumVidF5jtx+FRzgY/wjFrrGjEgDV5+Ka
        1TcvObLCYJWE2+tO2ABi4F29gz6lf6MW1w==
X-Google-Smtp-Source: ABdhPJwB4aYFSoga7SRmmex+j2gBbkyzbCuXE6AGsBSCksjlBtIb8jgWL3iY/v1i8wuwzrtcRKwqeg==
X-Received: by 2002:a05:620a:819:: with SMTP id s25mr3054270qks.485.1616459904979;
        Mon, 22 Mar 2021 17:38:24 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:fda6:6522:f108:7bd8])
        by smtp.gmail.com with ESMTPSA id 184sm12356403qki.97.2021.03.22.17.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 17:38:24 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v6 06/12] sock_map: introduce BPF_SK_SKB_VERDICT
Date:   Mon, 22 Mar 2021 17:38:02 -0700
Message-Id: <20210323003808.16074-7-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210323003808.16074-1-xiyou.wangcong@gmail.com>
References: <20210323003808.16074-1-xiyou.wangcong@gmail.com>
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
index d75c3936ab91..bc4010b23063 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -58,6 +58,7 @@ struct sk_psock_progs {
 	struct bpf_prog			*msg_parser;
 	struct bpf_prog			*stream_parser;
 	struct bpf_prog			*stream_verdict;
+	struct bpf_prog			*skb_verdict;
 };
 
 enum sk_psock_state_bits {
@@ -486,6 +487,7 @@ static inline void psock_progs_drop(struct sk_psock_progs *progs)
 	psock_set_prog(&progs->msg_parser, NULL);
 	psock_set_prog(&progs->stream_parser, NULL);
 	psock_set_prog(&progs->stream_verdict, NULL);
+	psock_set_prog(&progs->skb_verdict, NULL);
 }
 
 int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 2d3036e292a9..309a24582b18 100644
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
index a9ee26aebfbd..7e7e30e30f4b 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -692,7 +692,7 @@ void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 	rcu_assign_sk_user_data(sk, NULL);
 	if (psock->progs.stream_parser)
 		sk_psock_stop_strp(sk, psock);
-	else if (psock->progs.stream_verdict)
+	else if (psock->progs.stream_verdict || psock->progs.skb_verdict)
 		sk_psock_stop_verdict(sk, psock);
 	write_unlock_bh(&sk->sk_callback_lock);
 
@@ -1019,6 +1019,8 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
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
index 2d3036e292a9..309a24582b18 100644
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

