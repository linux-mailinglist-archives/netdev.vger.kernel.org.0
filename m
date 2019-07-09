Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 197DB63A5D
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 20:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbfGISAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 14:00:13 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:48425 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbfGISAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 14:00:13 -0400
Received: by mail-pl1-f201.google.com with SMTP id i33so11084738pld.15
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 11:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/FWnMMr39n+Rg4WltZKLdrffcUYCEq85Tj0c/Xlt4pg=;
        b=Y4vGTl5SmU0T6wZIRQE7ky9W2PGM3jr2qyWo+IgPjdQ4uSg0eyVeM2i4hWK1jDyvQP
         Eu30BPX9t8xaIC9HBQLE6WJDHRKSvd7f0W+Jo5ILBEuW8SZTYpw0wmg+a/JEoGqk64hk
         dYuxACY/1JSvElheFm5zZ63ik5HSxCXHla0lZhf3zLXsNxTZ3oJN5b4KXFgz1cCeRI1n
         mavEJP++qulbYHemhhCmBYIOenDPoeOmfoDhFECoq3NP2ieAngTP/3HL1gEdRLtbYpq6
         MnP/FX3cCiWHDIHtHPnUTx97Kj4IU83mCSEcVTaRnE/lOEncadth72pIxugJGUsA7LVB
         75pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/FWnMMr39n+Rg4WltZKLdrffcUYCEq85Tj0c/Xlt4pg=;
        b=H1riqtFyl43jrfICBRdVj2ZrY/7qlJA4G5o6lsiKFgWv8ztF6iMDhXG7gkaVNQjsLa
         rZMZymjgFE4jBMXLQQZD6KBzm4oPddZIWD3VAcKFmCLeQuGNLHUmBD74Gx67ARRz13L8
         mRlpKIvCLsTSgPoCSJiq01xLVQ87V3bPAvcq0qU19woSoU7JG/AVkBCzLseQ/aVe4ZF9
         cB+ADuraJgtx+BzqR70eRImIuamVZeX124b7xMb9ly+xcMZ9LPeaFgExMZmwGwculBaF
         g6mKG/+xABQByReggdq/BnTszXP1ADMCSuhBuHGakfTsynm06GnvNGvMLUYRneH3a9lw
         pd7w==
X-Gm-Message-State: APjAAAUAB/j3Zrf5eu9HLL8BoQ3mmbAn/wNQAuUo1UyZ7AVjgtSQhjlA
        Oyst5jFRdSCxAZzPcwIKzhrseaSqTrZATHhoUXYpCnRX3Qp//8bvjEPJ8Xdbh+szRqvmHfmPlaX
        1u7mLFWql9kWolNcE6zOZaQdgMyszIKbPBBMyli8aZi8K4lfjPs42LzW1yNDlz4qlAiMhbBwz
X-Google-Smtp-Source: APXvYqziuVKf1alWFtioAGchqy9H4A4pIemue6036aF7dg9uFyhbxnvf0n5vcOhiYNEkf/UWc688S9iq0y5VYi4X
X-Received: by 2002:a63:2c8:: with SMTP id 191mr31734451pgc.139.1562695211612;
 Tue, 09 Jul 2019 11:00:11 -0700 (PDT)
Date:   Tue,  9 Jul 2019 11:00:04 -0700
In-Reply-To: <20190709180005.33406-1-allanzhang@google.com>
Message-Id: <20190709180005.33406-2-allanzhang@google.com>
Mime-Version: 1.0
References: <20190709180005.33406-1-allanzhang@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v8 1/2] bpf: Allow bpf_skb_event_output for a few
 prog types
From:   Allan Zhang <allanzhang@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org, songliubraving@fb.com,
        daniel@iogearbox.net
Cc:     ast@kernel.org, allanzhang <allanzhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: allanzhang <allanzhang@google.com>

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

Signed-off-by: Allan Zhang <allanzhang@google.com>
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

