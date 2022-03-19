Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17B2D4DEA23
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 19:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243007AbiCSSfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 14:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243914AbiCSSfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 14:35:21 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5F92986E4
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 11:33:59 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id bx44so8612436ljb.13
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 11:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mtXczsu2C3JoPkHJLZN7LlmBti2ryIONYAmzdT/tcu0=;
        b=o+ubH51Aik2rVUR4EZJvtiL4v0D9wqLfUTqk/qtyuuqxeuURWuzqqKsM1dnGF1WiI2
         UucAEuxPIF4SpMVrL746HLilekL+7K5qyx1vm/UyEnMt3HRzSYPLMnBgEF5DKjyxMZiH
         127LQ5ZryPvsaiBSUQfyJK2JrDJI9HIUvYfcM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mtXczsu2C3JoPkHJLZN7LlmBti2ryIONYAmzdT/tcu0=;
        b=uHHog/tfeTmTuefxr0FW72Gwc/BwWf72eNobnWX7VeknFD1pn6tdzKAss/hJSNokQc
         PcDEQ2pKs0q7e01CTMD1vzmunWmD+GMJNUkv48NqR5JseKXJfKlDSEJP0+MBlcR/U9MA
         v5fzs9O+r6cG1QsxgwWi5VursF27khPQ+a+smu8oH0LCnbWTFjIgLLrS3u6GY9GwUoiB
         2fdblND6AuIrZwTdfF8MRlED/JRUlNWrDZF160S8QPWw4CYyonXHioZ+NEarqYhRa3km
         mtWyCBePHGGLq8x0cqg5Dd879vkMF9opKU30u9IRcE/ur0IsoH9QihTGTtr1+Iw3hueW
         HiBg==
X-Gm-Message-State: AOAM530URt8lL4hva8qARPcqAqL6xRJSTJ4tvIZLw6kEROtZ/8aW8FnF
        qk1qwVJrz7CA0l42gF3WjmmV8A==
X-Google-Smtp-Source: ABdhPJyPIZKJLSrkwjM+FnzlSWFECMSGT98UgehV41rJMi/pH211+ek/qSFrnGx3EHajc3KS4M72wQ==
X-Received: by 2002:a2e:a236:0:b0:249:2a4b:16f5 with SMTP id i22-20020a2ea236000000b002492a4b16f5mr9757845ljm.384.1647714838158;
        Sat, 19 Mar 2022 11:33:58 -0700 (PDT)
Received: from cloudflare.com ([2a01:110f:4809:d800::f9c])
        by smtp.gmail.com with ESMTPSA id f9-20020a2e3809000000b002491885098dsm1585676lja.74.2022.03.19.11.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 11:33:57 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com, Martin KaFai Lau <kafai@fb.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH bpf-next v2 1/3] bpf: Treat bpf_sk_lookup remote_port as a 2-byte field
Date:   Sat, 19 Mar 2022 19:33:54 +0100
Message-Id: <20220319183356.233666-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220319183356.233666-1-jakub@cloudflare.com>
References: <20220319183356.233666-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 9a69e2b385f4 ("bpf: Make remote_port field in struct
bpf_sk_lookup 16-bit wide") the remote_port field has been split up and
re-declared from u32 to be16.

However, the accompanying changes to the context access converter have not
been well thought through when it comes big-endian platforms.

Today 2-byte wide loads from offsetof(struct bpf_sk_lookup, remote_port)
are handled as narrow loads from a 4-byte wide field.

This by itself is not enough to create a problem, but when we combine

 1. 32-bit wide access to ->remote_port backed by a 16-wide wide load, with
 2. inherent difference between litte- and big-endian in how narrow loads
    need have to be handled (see bpf_ctx_narrow_access_offset),

we get inconsistent results for a 2-byte loads from &ctx->remote_port on LE
and BE architectures. This in turn makes BPF C code for the common case of
2-byte load from ctx->remote_port not portable.

To rectify it, inform the context access converter that remote_port is
2-byte wide field, and only 1-byte loads need to be treated as narrow
loads.

At the same time, we special-case the 4-byte load from &ctx->remote_port to
continue handling it the same way as do today, in order to keep the
existing BPF programs working.

Fixes: 9a69e2b385f4 ("bpf: Make remote_port field in struct bpf_sk_lookup 16-bit wide")
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/core/filter.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 03655f2074ae..a7044e98765e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10989,13 +10989,24 @@ static bool sk_lookup_is_valid_access(int off, int size,
 	case bpf_ctx_range(struct bpf_sk_lookup, local_ip4):
 	case bpf_ctx_range_till(struct bpf_sk_lookup, remote_ip6[0], remote_ip6[3]):
 	case bpf_ctx_range_till(struct bpf_sk_lookup, local_ip6[0], local_ip6[3]):
-	case offsetof(struct bpf_sk_lookup, remote_port) ...
-	     offsetof(struct bpf_sk_lookup, local_ip4) - 1:
 	case bpf_ctx_range(struct bpf_sk_lookup, local_port):
 	case bpf_ctx_range(struct bpf_sk_lookup, ingress_ifindex):
 		bpf_ctx_record_field_size(info, sizeof(__u32));
 		return bpf_ctx_narrow_access_ok(off, size, sizeof(__u32));
 
+	case bpf_ctx_range(struct bpf_sk_lookup, remote_port):
+		/* Allow 4-byte access to 2-byte field for backward compatibility */
+		if (size == sizeof(__u32))
+			return true;
+		bpf_ctx_record_field_size(info, sizeof(__be16));
+		return bpf_ctx_narrow_access_ok(off, size, sizeof(__be16));
+
+	case offsetofend(struct bpf_sk_lookup, remote_port) ...
+	     offsetof(struct bpf_sk_lookup, local_ip4) - 1:
+		/* Allow access to zero padding for backward compatibility */
+		bpf_ctx_record_field_size(info, sizeof(__u16));
+		return bpf_ctx_narrow_access_ok(off, size, sizeof(__u16));
+
 	default:
 		return false;
 	}
@@ -11077,6 +11088,11 @@ static u32 sk_lookup_convert_ctx_access(enum bpf_access_type type,
 						     sport, 2, target_size));
 		break;
 
+	case offsetofend(struct bpf_sk_lookup, remote_port):
+		*target_size = 2;
+		*insn++ = BPF_MOV32_IMM(si->dst_reg, 0);
+		break;
+
 	case offsetof(struct bpf_sk_lookup, local_port):
 		*insn++ = BPF_LDX_MEM(BPF_H, si->dst_reg, si->src_reg,
 				      bpf_target_off(struct bpf_sk_lookup_kern,
-- 
2.35.1

