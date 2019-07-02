Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 886395D403
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfGBQOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 12:14:12 -0400
Received: from mail-ot1-f73.google.com ([209.85.210.73]:39336 "EHLO
        mail-ot1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbfGBQOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 12:14:12 -0400
Received: by mail-ot1-f73.google.com with SMTP id v49so794589otb.6
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 09:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cpKkfZAXkeyNSw39ZUMPsJ0UTI2J4zTnjKkyi2A4z0o=;
        b=Q5zsewvMCuOiAvJvV1WPSXk9DGZFkCRgLGReqQckkgDJMZxP/v3sp5aL4DYy5w0Dpe
         KxTlTS2Qnq4a0dllcVpw36vLi6QOAxBGeg4C+xTd4S+ktIqEr/z8A1ba21CdNraIjYbj
         RhF/ldYqo6k0ZA+R81bgyvMIMV3y2pwXAPv3qVYjztf0xZoHCnTKMMF2WedyEozYh3wa
         GlMmrmejb+VVWLPnKJ2FoMgRf1RAtOBntREw7URgPuGOnP/ig01IzrCcdTCEzgVhhosH
         5xGPZ0W5rPc4tWFbpPF+jplDascZLkChHFDi1Ik//atzDtVHFBXbNAi4mFC8w1W6axay
         Hl2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cpKkfZAXkeyNSw39ZUMPsJ0UTI2J4zTnjKkyi2A4z0o=;
        b=KnSTxe9bOQCjRCsMtW1DL6Q2736gE+JOWaKzEH5sEBf4f1BbGr1co7WrMa15rB8+Fd
         JkBvVgCmuX2tMPUzQNrFYGmeFWYl6bml/P12VAaYsdygOM9qStlDyMmnl6HqPE/elrgq
         RMUw0pn7AHb0CVv8nYHVrJ01IqQPE/xnxDAlrG442H6jE2HibpHmiu6SxTfpx4iUQf1/
         xuB0NvrmIPonTSo2avNJ0gfNKZVteBsQz+YmWlB28xpAaU4e1l74nVEYK7tQE1pXXFQP
         9BCRoejy7PN/uYf6gRzMafJUvQqsjrpnw8fRwGe+vOwDgF4OMKrGA3nUNO/LclmJRDVS
         lR5Q==
X-Gm-Message-State: APjAAAVE6uX8oOVYwFaFJhThNx2Vd6onVB2+QLYZssInw/+Lf0IqH08P
        OtDZWJfyfiKuNlLWGwKFKBULoLFNcmSBUKFowUROTyYAcYY5l/Kn80INyLcNtShb5VZDritgGV3
        uSEWr4iZEJW0h38A8lQO39F7DteES2fc5l5eXsaEHHsjcuT1B9Bo85Q==
X-Google-Smtp-Source: APXvYqxtyhzUjOg8oRBoQthh/Cm88JnsYLP0Di+cTQ/Vk09e8nFoc2l9jQvm4qxTZpnq2JIR/eYKQgU=
X-Received: by 2002:aca:318c:: with SMTP id x134mr3156816oix.125.1562084051040;
 Tue, 02 Jul 2019 09:14:11 -0700 (PDT)
Date:   Tue,  2 Jul 2019 09:13:57 -0700
In-Reply-To: <20190702161403.191066-1-sdf@google.com>
Message-Id: <20190702161403.191066-3-sdf@google.com>
Mime-Version: 1.0
References: <20190702161403.191066-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v2 2/8] bpf: split shared bpf_tcp_sock and
 bpf_sock_ops implementation
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
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
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

