Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32034DCBE9
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 17:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236724AbiCQQ77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 12:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236718AbiCQQ7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 12:59:51 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D667A992
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 09:58:29 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id n19so10025073lfh.8
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 09:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eaxohQ9V+SbyCU6jPm+WVSzSaTbRz5JOX0s7z3i2z3I=;
        b=JecNR2A1WBJtpxnNqDnvZPdqrHpENKn8voZNOUOWI4Lcy8FSxZZUTuEMRFDnj1+b4B
         m9ptugbcEhPiwWEdHa2BzgWQO9w6RSEHaIaywPUgbwuM94fTeHI2DgfE1CEFVKNeVgk0
         M/Fvoev8H7QohaD2qFbO1GPIeaDOfvtbBIwzU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eaxohQ9V+SbyCU6jPm+WVSzSaTbRz5JOX0s7z3i2z3I=;
        b=Eo9Vd5uhPgPs09qUBzgy+JwJDjJFPMx/xlFeGgqJ3boZTpDG9jj92K8sjsln50DMZW
         dhUFRiVHDqZlZ5dSBO+lx+qWkJ7ZOSGKNMkcB96BrCeg4Id3qnCaisT74Olxhxy8H2Kw
         Kr3On0q9ytLFTkx/YT6P1Pyj1Q7e4dSBGUlzVw3zq4Id+9h4ZwIPWlYDfoexMFWEdX2c
         FpmWcPSqQddGsf/EUq/WHa1XZgW3MVllnVJi0cUVDHg4qAkA2UIs6NM7Cui/axZmIm2l
         LUKUp8bDkEHOK25qP+QVaGr7O768BE6XePeF8dbv4PnRGnWqRpXSurqa0B1uZN+Q+x3r
         OJ8g==
X-Gm-Message-State: AOAM53225ZfOYluBfNnEDvxp/6jwOmq2P5BDizhRARIrH3d3v0+6KQtq
        kiy818AFqpBKMN+JvyuR/BAlfw==
X-Google-Smtp-Source: ABdhPJwDio7Gf2p5JFZGUbZHlm+0h0m5k4CzujuHZw21dcd4a4YhY5gsL/eBRp2ROQ9sQcF9VpVO2w==
X-Received: by 2002:a19:d61a:0:b0:43f:1a03:21ee with SMTP id n26-20020a19d61a000000b0043f1a0321eemr3624922lfg.152.1647536308145;
        Thu, 17 Mar 2022 09:58:28 -0700 (PDT)
Received: from cloudflare.com ([2a01:110f:4809:d800::f9c])
        by smtp.gmail.com with ESMTPSA id o11-20020ac2434b000000b004481eafa257sm488542lfl.285.2022.03.17.09.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 09:58:27 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com, Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH bpf-next 1/3] bpf: Treat bpf_sk_lookup remote_port as a 2-byte field
Date:   Thu, 17 Mar 2022 17:58:24 +0100
Message-Id: <20220317165826.1099418-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317165826.1099418-1-jakub@cloudflare.com>
References: <20220317165826.1099418-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/core/filter.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 03655f2074ae..9b1e453baf6d 100644
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
+			return off == offsetof(struct bpf_sk_lookup, remote_port);
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

