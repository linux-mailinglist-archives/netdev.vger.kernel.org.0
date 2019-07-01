Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D88E35C478
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 22:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfGAUsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 16:48:30 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:43210 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726966AbfGAUsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 16:48:30 -0400
Received: by mail-pf1-f201.google.com with SMTP id j7so9473270pfn.10
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 13:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ModQgDPhzuyPvFACPBg8Rl25O3S/FpNHFLqMvCgTcWw=;
        b=dUpLFaPB+BU41OsL1OLcuRtyiDgDA8iVJSZWYmxw78QWCy1r+Ih5YnaNWZR7AUpGul
         9N+8i7qXndq2f4e/hlXbbdnD4Rjl+0KgMYn3qkuRZmUOfZ9peKN9cAjaeZx+W9LCQpis
         HaugJijk+EePaKKIXoOQaILV8XQaghEMSCOZj7buK61rge5tEnnPuG94M0dnNk0jdc1x
         UIhhXXEcgZFdYhekyBDcQvvhcsIBpuSLpLqC+qJiV5jvlGh/6KwbPiQCYuROkJVfsa+2
         BDFV4aBEHyd1D+9BnlyzchGRyVoVj8iBmcXedTsZ2DbzPaVUKITZzISZ6o9YaIv4A5bx
         6t9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ModQgDPhzuyPvFACPBg8Rl25O3S/FpNHFLqMvCgTcWw=;
        b=K9aVa+zD5KkVsxrIyTxW46zWamRTWKqzL4HeYf4775VK0VIPwUg7kcYaL/53xbZ19t
         fvvHXFdYfPO8ZOZBTfW3o2UhM3w27/+y4lxswPBoTlCMGU1j5+8kDsWAqe1UDweyS7F/
         zLSTunXmBAtRqxFIpTnFpPuZk0Sj01NtkRGBOjtB7/EpfzM9DbEfaMbU9FNfF7tZ2aom
         rGmpRSRJHKvBZ2ZMBbDP8glVyacRSRBXqWf86MLATMwAmQK8SpsoM4Yry9NmRow7IJqJ
         CuBnhigi4lqLWaF0AlhlSoOyrEft0nHabkdaHj9upBxGrD1c+GJvX0fc7UQhT/cZ0+cU
         OTSA==
X-Gm-Message-State: APjAAAWr2ht1nJ96XoAUEuDlL5ldFlICys5pJGf2vfEwImCDTLlwkChZ
        CljRx1zEBz+418zb2UD38k7rF4iOYluEGxRgejIEBgHa/NBTFcM3J/2u1A6j5Ac629YQoKOLEdo
        UtbrTNVjVYuzl3wT8GIoB6kecTS5OFlb/ydgWtyOfawlNckqT/M/7vw==
X-Google-Smtp-Source: APXvYqwDLKwFedoIlfJGc8j4Hwl8kx2YHwbLy6maX2cN+vxpk09sCOh/uJJB9/1v/89aIxlj8nl5JVU=
X-Received: by 2002:a63:3f48:: with SMTP id m69mr26107172pga.17.1562014108970;
 Mon, 01 Jul 2019 13:48:28 -0700 (PDT)
Date:   Mon,  1 Jul 2019 13:48:15 -0700
In-Reply-To: <20190701204821.44230-1-sdf@google.com>
Message-Id: <20190701204821.44230-3-sdf@google.com>
Mime-Version: 1.0
References: <20190701204821.44230-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next 2/8] bpf: split shared bpf_tcp_sock and bpf_sock_ops implementation
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We've added bpf_tcp_sock member to bpf_sock_ops and don't expect
any new tcp_sock fields in bpf_sock_ops. Let's remove
CONVERT_COMMON_TCP_SOCK_FIELDS so bpf_tcp_sock can be independently
extended.

Cc: Eric Dumazet <edumazet@google.com>
Cc: Priyaranjan Jha <priyarjha@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 net/core/filter.c | 180 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 126 insertions(+), 54 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 4836264f82ee..ad908526545d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5194,54 +5194,6 @@ static const struct bpf_func_proto bpf_lwt_seg6_adjust_srh_proto = {
 };
 #endif /* CONFIG_IPV6_SEG6_BPF */
 
-#define CONVERT_COMMON_TCP_SOCK_FIELDS(md_type, CONVERT)		\
-do {									\
-	switch (si->off) {						\
-	case offsetof(md_type, snd_cwnd):				\
-		CONVERT(snd_cwnd); break;				\
-	case offsetof(md_type, srtt_us):				\
-		CONVERT(srtt_us); break;				\
-	case offsetof(md_type, snd_ssthresh):				\
-		CONVERT(snd_ssthresh); break;				\
-	case offsetof(md_type, rcv_nxt):				\
-		CONVERT(rcv_nxt); break;				\
-	case offsetof(md_type, snd_nxt):				\
-		CONVERT(snd_nxt); break;				\
-	case offsetof(md_type, snd_una):				\
-		CONVERT(snd_una); break;				\
-	case offsetof(md_type, mss_cache):				\
-		CONVERT(mss_cache); break;				\
-	case offsetof(md_type, ecn_flags):				\
-		CONVERT(ecn_flags); break;				\
-	case offsetof(md_type, rate_delivered):				\
-		CONVERT(rate_delivered); break;				\
-	case offsetof(md_type, rate_interval_us):			\
-		CONVERT(rate_interval_us); break;			\
-	case offsetof(md_type, packets_out):				\
-		CONVERT(packets_out); break;				\
-	case offsetof(md_type, retrans_out):				\
-		CONVERT(retrans_out); break;				\
-	case offsetof(md_type, total_retrans):				\
-		CONVERT(total_retrans); break;				\
-	case offsetof(md_type, segs_in):				\
-		CONVERT(segs_in); break;				\
-	case offsetof(md_type, data_segs_in):				\
-		CONVERT(data_segs_in); break;				\
-	case offsetof(md_type, segs_out):				\
-		CONVERT(segs_out); break;				\
-	case offsetof(md_type, data_segs_out):				\
-		CONVERT(data_segs_out); break;				\
-	case offsetof(md_type, lost_out):				\
-		CONVERT(lost_out); break;				\
-	case offsetof(md_type, sacked_out):				\
-		CONVERT(sacked_out); break;				\
-	case offsetof(md_type, bytes_received):				\
-		CONVERT(bytes_received); break;				\
-	case offsetof(md_type, bytes_acked):				\
-		CONVERT(bytes_acked); break;				\
-	}								\
-} while (0)
-
 #ifdef CONFIG_INET
 static struct sock *sk_lookup(struct net *net, struct bpf_sock_tuple *tuple,
 			      int dif, int sdif, u8 family, u8 proto)
@@ -5623,9 +5575,6 @@ u32 bpf_tcp_sock_convert_ctx_access(enum bpf_access_type type,
 				      offsetof(struct tcp_sock, FIELD)); \
 	} while (0)
 
-	CONVERT_COMMON_TCP_SOCK_FIELDS(struct bpf_tcp_sock,
-				       BPF_TCP_SOCK_GET_COMMON);
-
 	if (insn > insn_buf)
 		return insn - insn_buf;
 
@@ -5640,6 +5589,69 @@ u32 bpf_tcp_sock_convert_ctx_access(enum bpf_access_type type,
 				      offsetof(struct tcp_sock, rtt_min) +
 				      offsetof(struct minmax_sample, v));
 		break;
+	case offsetof(struct bpf_tcp_sock, snd_cwnd):
+		BPF_TCP_SOCK_GET_COMMON(snd_cwnd);
+		break;
+	case offsetof(struct bpf_tcp_sock, srtt_us):
+		BPF_TCP_SOCK_GET_COMMON(srtt_us);
+		break;
+	case offsetof(struct bpf_tcp_sock, snd_ssthresh):
+		BPF_TCP_SOCK_GET_COMMON(snd_ssthresh);
+		break;
+	case offsetof(struct bpf_tcp_sock, rcv_nxt):
+		BPF_TCP_SOCK_GET_COMMON(rcv_nxt);
+		break;
+	case offsetof(struct bpf_tcp_sock, snd_nxt):
+		BPF_TCP_SOCK_GET_COMMON(snd_nxt);
+		break;
+	case offsetof(struct bpf_tcp_sock, snd_una):
+		BPF_TCP_SOCK_GET_COMMON(snd_una);
+		break;
+	case offsetof(struct bpf_tcp_sock, mss_cache):
+		BPF_TCP_SOCK_GET_COMMON(mss_cache);
+		break;
+	case offsetof(struct bpf_tcp_sock, ecn_flags):
+		BPF_TCP_SOCK_GET_COMMON(ecn_flags);
+		break;
+	case offsetof(struct bpf_tcp_sock, rate_delivered):
+		BPF_TCP_SOCK_GET_COMMON(rate_delivered);
+		break;
+	case offsetof(struct bpf_tcp_sock, rate_interval_us):
+		BPF_TCP_SOCK_GET_COMMON(rate_interval_us);
+		break;
+	case offsetof(struct bpf_tcp_sock, packets_out):
+		BPF_TCP_SOCK_GET_COMMON(packets_out);
+		break;
+	case offsetof(struct bpf_tcp_sock, retrans_out):
+		BPF_TCP_SOCK_GET_COMMON(retrans_out);
+		break;
+	case offsetof(struct bpf_tcp_sock, total_retrans):
+		BPF_TCP_SOCK_GET_COMMON(total_retrans);
+		break;
+	case offsetof(struct bpf_tcp_sock, segs_in):
+		BPF_TCP_SOCK_GET_COMMON(segs_in);
+		break;
+	case offsetof(struct bpf_tcp_sock, data_segs_in):
+		BPF_TCP_SOCK_GET_COMMON(data_segs_in);
+		break;
+	case offsetof(struct bpf_tcp_sock, segs_out):
+		BPF_TCP_SOCK_GET_COMMON(segs_out);
+		break;
+	case offsetof(struct bpf_tcp_sock, data_segs_out):
+		BPF_TCP_SOCK_GET_COMMON(data_segs_out);
+		break;
+	case offsetof(struct bpf_tcp_sock, lost_out):
+		BPF_TCP_SOCK_GET_COMMON(lost_out);
+		break;
+	case offsetof(struct bpf_tcp_sock, sacked_out):
+		BPF_TCP_SOCK_GET_COMMON(sacked_out);
+		break;
+	case offsetof(struct bpf_tcp_sock, bytes_received):
+		BPF_TCP_SOCK_GET_COMMON(bytes_received);
+		break;
+	case offsetof(struct bpf_tcp_sock, bytes_acked):
+		BPF_TCP_SOCK_GET_COMMON(bytes_acked);
+		break;
 	}
 
 	return insn - insn_buf;
@@ -7913,9 +7925,6 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 			SOCK_OPS_GET_FIELD(BPF_FIELD, OBJ_FIELD, OBJ);	      \
 	} while (0)
 
-	CONVERT_COMMON_TCP_SOCK_FIELDS(struct bpf_sock_ops,
-				       SOCK_OPS_GET_TCP_SOCK_FIELD);
-
 	if (insn > insn_buf)
 		return insn - insn_buf;
 
@@ -8085,6 +8094,69 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 		SOCK_OPS_GET_OR_SET_FIELD(sk_txhash, sk_txhash,
 					  struct sock, type);
 		break;
+	case offsetof(struct bpf_sock_ops, snd_cwnd):
+		SOCK_OPS_GET_TCP_SOCK_FIELD(snd_cwnd);
+		break;
+	case offsetof(struct bpf_sock_ops, srtt_us):
+		SOCK_OPS_GET_TCP_SOCK_FIELD(srtt_us);
+		break;
+	case offsetof(struct bpf_sock_ops, snd_ssthresh):
+		SOCK_OPS_GET_TCP_SOCK_FIELD(snd_ssthresh);
+		break;
+	case offsetof(struct bpf_sock_ops, rcv_nxt):
+		SOCK_OPS_GET_TCP_SOCK_FIELD(rcv_nxt);
+		break;
+	case offsetof(struct bpf_sock_ops, snd_nxt):
+		SOCK_OPS_GET_TCP_SOCK_FIELD(snd_nxt);
+		break;
+	case offsetof(struct bpf_sock_ops, snd_una):
+		SOCK_OPS_GET_TCP_SOCK_FIELD(snd_una);
+		break;
+	case offsetof(struct bpf_sock_ops, mss_cache):
+		SOCK_OPS_GET_TCP_SOCK_FIELD(mss_cache);
+		break;
+	case offsetof(struct bpf_sock_ops, ecn_flags):
+		SOCK_OPS_GET_TCP_SOCK_FIELD(ecn_flags);
+		break;
+	case offsetof(struct bpf_sock_ops, rate_delivered):
+		SOCK_OPS_GET_TCP_SOCK_FIELD(rate_delivered);
+		break;
+	case offsetof(struct bpf_sock_ops, rate_interval_us):
+		SOCK_OPS_GET_TCP_SOCK_FIELD(rate_interval_us);
+		break;
+	case offsetof(struct bpf_sock_ops, packets_out):
+		SOCK_OPS_GET_TCP_SOCK_FIELD(packets_out);
+		break;
+	case offsetof(struct bpf_sock_ops, retrans_out):
+		SOCK_OPS_GET_TCP_SOCK_FIELD(retrans_out);
+		break;
+	case offsetof(struct bpf_sock_ops, total_retrans):
+		SOCK_OPS_GET_TCP_SOCK_FIELD(total_retrans);
+		break;
+	case offsetof(struct bpf_sock_ops, segs_in):
+		SOCK_OPS_GET_TCP_SOCK_FIELD(segs_in);
+		break;
+	case offsetof(struct bpf_sock_ops, data_segs_in):
+		SOCK_OPS_GET_TCP_SOCK_FIELD(data_segs_in);
+		break;
+	case offsetof(struct bpf_sock_ops, segs_out):
+		SOCK_OPS_GET_TCP_SOCK_FIELD(segs_out);
+		break;
+	case offsetof(struct bpf_sock_ops, data_segs_out):
+		SOCK_OPS_GET_TCP_SOCK_FIELD(data_segs_out);
+		break;
+	case offsetof(struct bpf_sock_ops, lost_out):
+		SOCK_OPS_GET_TCP_SOCK_FIELD(lost_out);
+		break;
+	case offsetof(struct bpf_sock_ops, sacked_out):
+		SOCK_OPS_GET_TCP_SOCK_FIELD(sacked_out);
+		break;
+	case offsetof(struct bpf_sock_ops, bytes_received):
+		SOCK_OPS_GET_TCP_SOCK_FIELD(bytes_received);
+		break;
+	case offsetof(struct bpf_sock_ops, bytes_acked):
+		SOCK_OPS_GET_TCP_SOCK_FIELD(bytes_acked);
+		break;
 	case offsetof(struct bpf_sock_ops, sk):
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(
 						struct bpf_sock_ops_kern,
-- 
2.22.0.410.gd8fdbe21b5-goog

