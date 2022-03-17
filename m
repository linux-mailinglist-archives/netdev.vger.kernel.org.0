Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E2B4DC4F1
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 12:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbiCQLku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 07:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233011AbiCQLkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 07:40:49 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8630C1E5217
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 04:39:26 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id y17so6781180ljd.12
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 04:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gDhbf6FjOQGMDCKaqwepB50GDaXw7puLrLCj6LY2Vos=;
        b=jtZQSvWCYXcRu1ik+ACl7fK4pju9Jc1SHBubB9gFWB8JkLseTCOqR6VJ6cXdH5hkIm
         KkdyX62hYV2U0+cZUrCT29heGXSIH9JQEtDZbzFTbM4YUlLrSntJlbqUtELMfudZ/E8i
         EIWsigdUIJD04YH8gsfnJRH6lSQs3be3ne4K4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gDhbf6FjOQGMDCKaqwepB50GDaXw7puLrLCj6LY2Vos=;
        b=piNtXtsUzC/jkyJ9GP67FIyY3eawhKFKGaTy7oAp8mz+OwPYRH/THAdpnVnO1LQtyT
         TWhXMBgQEvaSpGf2s3q28oq9DdHcR3qYbPLJQId7WoIwVYuxAOH8R8nx3zH8PvjpHAO1
         5O3aPrtc9a1K2ORcl4HMZ68NTxW5scqVcVXJrQtu80oqRILWO3aPc2oqOE8JXGmEUK3g
         XLV9u6LDXPnqdBfRwdazSlcJxaVrVXQn8Vd//6+cWcgrC/D/yrF5++cu/NGp22ewAeyE
         4IO4nyiqSP3yQJwHD1uWnrMOS+ilbNWdu4yAtrqhVniKcdyoLYaB+7gJ8AyB5ZN/YLXT
         s3UA==
X-Gm-Message-State: AOAM533hsk7baiKeILCmQO9hQCkJuMTobkdRTNmRyKIXXOVzsx5cTTP9
        /8ysa6cGKYZhI+XM5hsO45sXig==
X-Google-Smtp-Source: ABdhPJw3apKHdVOMzgB87LZ/8nBEL7E0nIS19wrE53QAZiGONL1j33utcKU1lfXm2y0NDsummUJvCw==
X-Received: by 2002:a2e:97c8:0:b0:248:542:6a2f with SMTP id m8-20020a2e97c8000000b0024805426a2fmr2579327ljj.417.1647517164883;
        Thu, 17 Mar 2022 04:39:24 -0700 (PDT)
Received: from cloudflare.com ([2a01:110f:4809:d800::f9c])
        by smtp.gmail.com with ESMTPSA id m21-20020a197115000000b0044895f0608asm428123lfc.37.2022.03.17.04.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 04:39:24 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com, Ilya Leoshkevich <iii@linux.ibm.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v3 4/4] selftests/bpf: Fix test for 4-byte load from dst_port on big-endian
Date:   Thu, 17 Mar 2022 12:39:20 +0100
Message-Id: <20220317113920.1068535-5-jakub@cloudflare.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317113920.1068535-1-jakub@cloudflare.com>
References: <20220317113920.1068535-1-jakub@cloudflare.com>
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

The check for 4-byte load from dst_port offset into bpf_sock is failing on
big-endian architecture - s390. The bpf access converter rewrites the
4-byte load to a 2-byte load from sock_common at skc_dport offset, as shown
below.

  * s390 / llvm-objdump -S --no-show-raw-insn

  00000000000002a0 <sk_dst_port__load_word>:
        84:       r1 = *(u32 *)(r1 + 48)
        85:       w0 = 1
        86:       if w1 == 51966 goto +1 <LBB5_2>
        87:       w0 = 0
  00000000000002c0 <LBB5_2>:
        88:       exit

  * s390 / bpftool prog dump xlated

  _Bool sk_dst_port__load_word(struct bpf_sock * sk):
    35: (69) r1 = *(u16 *)(r1 +12)
    36: (bc) w1 = w1
    37: (b4) w0 = 1
    38: (16) if w1 == 0xcafe goto pc+1
    39: (b4) w0 = 0
    40: (95) exit

  * x86_64 / llvm-objdump -S --no-show-raw-insn

  00000000000002a0 <sk_dst_port__load_word>:
        84:       r1 = *(u32 *)(r1 + 48)
        85:       w0 = 1
        86:       if w1 == 65226 goto +1 <LBB5_2>
        87:       w0 = 0
  00000000000002c0 <LBB5_2>:
        88:       exit

  * x86_64 / bpftool prog dump xlated

  _Bool sk_dst_port__load_word(struct bpf_sock * sk):
    33: (69) r1 = *(u16 *)(r1 +12)
    34: (b4) w0 = 1
    35: (16) if w1 == 0xfeca goto pc+1
    36: (b4) w0 = 0
    37: (95) exit

This leads to surprises if we treat the destination register contents as a
32-bit value, ignoring the fact that in reality it contains a 16-bit value.

On little-endian the register contents reflect the bpf_sock struct
definition, where the lower 16-bits contain the port number:

	struct bpf_sock {
		...
		__be16 dst_port;	/* offset 48 */
		__u16 :16;
		...
	};

However, on big-endian the register contents suggest that field the layout
of bpf_sock struct is as so:

	struct bpf_sock {
		...
		__u16 :16;		/* offset 48 */
		__be16 dst_port;
		...
	};

Account for this quirky access conversion in the test case exercising the
4-byte load by treating the result as 16-bit wide.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 tools/testing/selftests/bpf/progs/test_sock_fields.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/test_sock_fields.c b/tools/testing/selftests/bpf/progs/test_sock_fields.c
index 43a17fdef226..9f4b8f9f1181 100644
--- a/tools/testing/selftests/bpf/progs/test_sock_fields.c
+++ b/tools/testing/selftests/bpf/progs/test_sock_fields.c
@@ -251,10 +251,16 @@ int ingress_read_sock_fields(struct __sk_buff *skb)
 	return CG_OK;
 }
 
+/*
+ * NOTE: 4-byte load from bpf_sock at dst_port offset is quirky. It
+ * gets rewritten by the access converter to a 2-byte load for
+ * backward compatibility. Treating the load result as a be16 value
+ * makes the code portable across little- and big-endian platforms.
+ */
 static __noinline bool sk_dst_port__load_word(struct bpf_sock *sk)
 {
 	__u32 *word = (__u32 *)&sk->dst_port;
-	return word[0] == bpf_htonl(0xcafe0000);
+	return word[0] == bpf_htons(0xcafe);
 }
 
 static __noinline bool sk_dst_port__load_half(struct bpf_sock *sk)
-- 
2.35.1

