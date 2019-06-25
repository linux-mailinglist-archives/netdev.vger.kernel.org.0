Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC9FF51F92
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729815AbfFYANe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:13:34 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:50541 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729794AbfFYANd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 20:13:33 -0400
Received: by mail-pf1-f202.google.com with SMTP id h27so10571975pfq.17
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 17:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vljDviNdnBJvl0I2gRgeW5+fqicMSv8iMMvpNNvivIc=;
        b=NrZSDJTh2FXpckKHa1h0Vqi/bJQqnapLp0xhDRHwzxqZtLCJTKKcgAvWXz/QuTMr89
         qrnZIGSX7+dh7Cf0m9OaVKWvUMDASf/4qbk9twE8pMngTy/eBshvsqYsDGW8TdoZ6N6U
         rD7MMZJDTJtSdTevvTRBZ5+pT4oXQ9PvPra/CBM6wydugJWtU9/YT0HqUqd2pPrMsQc6
         fMK/y1g2a+9gaY0x5CkLI1yY1VDrND1uhvgKWJLQglZlX2HvFrXnGJH1Q5CkOAlIq3cA
         D3lwgo2Ph94FPf6D6ZCvo9tPnd+12nFW6DlrfFcSJBnPMTSu9E+QWlYTijDG/mtGcz84
         C7AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vljDviNdnBJvl0I2gRgeW5+fqicMSv8iMMvpNNvivIc=;
        b=Vgd971aQW0gz3V6SfPbvgDubkMBzIe16DfZBPnhczWeuYFrGi7WoMFsChOG3pz+YPL
         QWdnyaQzzhagtZN7qyA6xZnElFVVD++GhSIU2bkPa3UHS2t1A5ysrtFRRWLV9dmMHK/v
         9ZgH9xVuVCJscQki91b74lGg//+2iOtVslHDGkMFToR3dmihUkFaw8huScJQN6+Lb0xl
         NWBSoRyuYOmQqX+1B4NV8yIRg6mNjz/C2oNtAso9MXmmIB9RJmQA0UbHXZUd1OlSiOaZ
         SgPKtw1YAijYJnUyztfvEQq8HMLqx5T2JWYyOI8qr990H2jCeyciX/yuSutjv6qjqjMW
         DNpg==
X-Gm-Message-State: APjAAAUenXT/sUUqLMtFf5cUN0PSk6hlByrBgkfrn7EIkwYy0rMWmNun
        U1efF8sQLP6BY6Gkckc+gLJRyCxoW+Rgcw3d
X-Google-Smtp-Source: APXvYqwFAbGso4c66okMxnyz0loyzCLHwBq4peR9dUOP0qU3kDdjv232XyHaizp0eZ2sYJCn5B/udSKKWL0D7+Fz
X-Received: by 2002:a63:9143:: with SMTP id l64mr24766192pge.65.1561421612604;
 Mon, 24 Jun 2019 17:13:32 -0700 (PDT)
Date:   Mon, 24 Jun 2019 17:13:25 -0700
In-Reply-To: <20190625001326.172280-1-allanzhang@google.com>
Message-Id: <20190625001326.172280-2-allanzhang@google.com>
Mime-Version: 1.0
References: <20190625001326.172280-1-allanzhang@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH] bpf: Allow bpf_skb_event_output for a few prog types
From:   allanzhang <allanzhang@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     allanzhang <allanzhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Software event output is only enabled by a few prog types right now (TC,
LWT out, XDP, sockops). Many other skb based prog types need
bpf_skb_event_output to produce software event.

Added socket_filter, cg_skb, sk_skb prog types to generate sw event.

Test bpf code is generated from code snippet:

struct TMP {
    uint64_t tmp;
} tt;
tt.tmp = 5;
bpf_perf_event_output(skb, &connection_tracking_event_map, 0,
                      &tt, sizeof(tt));
return 1;

the bpf assembly from llvm is:
       0:       b7 02 00 00 05 00 00 00         r2 = 5
       1:       7b 2a f8 ff 00 00 00 00         *(u64 *)(r10 - 8) = r2
       2:       bf a4 00 00 00 00 00 00         r4 = r10
       3:       07 04 00 00 f8 ff ff ff         r4 += -8
       4:       18 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00    r2 = 0ll
       6:       b7 03 00 00 00 00 00 00         r3 = 0
       7:       b7 05 00 00 08 00 00 00         r5 = 8
       8:       85 00 00 00 19 00 00 00         call 25
       9:       b7 00 00 00 01 00 00 00         r0 = 1
      10:       95 00 00 00 00 00 00 00         exit

Patch 1 is enabling code.
Patch 2 is fullly covered selftest code.

Signed-off-by: allanzhang <allanzhang@google.com>
---
 net/core/filter.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 2014d76e0d2a..b75fcf412628 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5958,6 +5958,8 @@ sk_filter_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_socket_cookie_proto;
 	case BPF_FUNC_get_socket_uid:
 		return &bpf_get_socket_uid_proto;
+	case BPF_FUNC_perf_event_output:
+		return &bpf_skb_event_output_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
@@ -5978,6 +5980,8 @@ cg_skb_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_sk_storage_get_proto;
 	case BPF_FUNC_sk_storage_delete:
 		return &bpf_sk_storage_delete_proto;
+	case BPF_FUNC_perf_event_output:
+		return &bpf_skb_event_output_proto;
 #ifdef CONFIG_SOCK_CGROUP_DATA
 	case BPF_FUNC_skb_cgroup_id:
 		return &bpf_skb_cgroup_id_proto;
@@ -6226,6 +6230,8 @@ sk_skb_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_sk_redirect_map_proto;
 	case BPF_FUNC_sk_redirect_hash:
 		return &bpf_sk_redirect_hash_proto;
+	case BPF_FUNC_perf_event_output:
+		return &bpf_skb_event_output_proto;
 #ifdef CONFIG_INET
 	case BPF_FUNC_sk_lookup_tcp:
 		return &bpf_sk_lookup_tcp_proto;
-- 
2.22.0.410.gd8fdbe21b5-goog

