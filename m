Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6CE4DEA26
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 19:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243914AbiCSSfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 14:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243919AbiCSSfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 14:35:23 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC22A2986E4
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 11:34:01 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 25so15107456ljv.10
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 11:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HJf9hjmlU8ooiir4NWlBaONurfCvBP7drmCxAIcE+pM=;
        b=VLqU3oFb2kAvIf18xDmAfaYRL66Xl/BNJCKWKUmIpbbLFfs7X0XbDfqXKYZGgdBGq1
         YNyagsngccVrEPRWm0w2l6TUhF4Wpqn5osbedBU99T6eSOPQHsZkhRxbdqsMwaxF1c3n
         Il4K7gAKMKSLhEiRr8fQnYguRGmIgU9QVKGVc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HJf9hjmlU8ooiir4NWlBaONurfCvBP7drmCxAIcE+pM=;
        b=AjR/9cHP26kUR2apqPtGOUMvHbu9t6RVbDDqg92rcL4B+HbXn72HJBrS8p8YHHSTOx
         6CEuxFBt4PGDnsSkffyyfDzHD5HnLyn/PPETAN8Xx+gp4YJVcP0BPvrAwETmp50cvIRb
         B+B3EPqQmP+EKQraNbNszHFIfn9O2IqnmyLu19YyvHucffDqr/MjDJgPDekSZN+W/w83
         4Xy1nSgGWGX7lqqy4rQAy9DNBUSeT6TLK3Dg8jZI03ilvR9l+dMk6IJX8M7T5Ip+ylxw
         /SRHvz+dUR5+3w1deYKIRDMPvXtjCpohb/Fyo0056vDfbgowPVL7HHToRygVNFQibk/i
         QXSQ==
X-Gm-Message-State: AOAM531BudxqPaXKkhKR/rrF7nUO6KlWFeBgF5KQu02VZA+HhDZSl61K
        DXVmU+jLqzibzIU/xIP0GgVKpA==
X-Google-Smtp-Source: ABdhPJwdknscv6JyO7SeEx1hBY9N4iMvMM/MkGLNDngTm3RU8c3ZnAJludotXKO926Rc3568NUTX3A==
X-Received: by 2002:a2e:9e4b:0:b0:247:e9f3:2eda with SMTP id g11-20020a2e9e4b000000b00247e9f32edamr10021412ljk.378.1647714840178;
        Sat, 19 Mar 2022 11:34:00 -0700 (PDT)
Received: from cloudflare.com ([2a01:110f:4809:d800::f9c])
        by smtp.gmail.com with ESMTPSA id k7-20020ac257c7000000b0044854f11248sm1347688lfo.55.2022.03.19.11.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 11:33:59 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com, Martin KaFai Lau <kafai@fb.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH bpf-next v2 3/3] selftests/bpf: Fix test for 4-byte load from remote_port on big-endian
Date:   Sat, 19 Mar 2022 19:33:56 +0100
Message-Id: <20220319183356.233666-4-jakub@cloudflare.com>
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

The context access converter rewrites the 4-byte load from
bpf_sk_lookup->remote_port to a 2-byte load from bpf_sk_lookup_kern
structure.

It means that we cannot treat the destination register contents as a 32-bit
value, or the code will not be portable across big- and little-endian
architectures.

This is exactly the same case as with 4-byte loads from bpf_sock->dst_port
so follow the approach outlined in [1] and treat the register contents as a
16-bit value in the test.

[1]: https://lore.kernel.org/bpf/20220317113920.1068535-5-jakub@cloudflare.com/

Fixes: 2ed0dc5937d3 ("selftests/bpf: Cover 4-byte load from remote_port in bpf_sk_lookup")
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 tools/testing/selftests/bpf/progs/test_sk_lookup.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_sk_lookup.c b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
index 38b7a1fe67b6..6058dcb11b36 100644
--- a/tools/testing/selftests/bpf/progs/test_sk_lookup.c
+++ b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
@@ -418,9 +418,15 @@ int ctx_narrow_access(struct bpf_sk_lookup *ctx)
 	if (LSW(ctx->remote_port, 0) != SRC_PORT)
 		return SK_DROP;
 
-	/* Load from remote_port field with zero padding (backward compatibility) */
+	/*
+	 * NOTE: 4-byte load from bpf_sk_lookup at remote_port offset
+	 * is quirky. It gets rewritten by the access converter to a
+	 * 2-byte load for backward compatibility. Treating the load
+	 * result as a be16 value makes the code portable across
+	 * little- and big-endian platforms.
+	 */
 	val_u32 = *(__u32 *)&ctx->remote_port;
-	if (val_u32 != bpf_htonl(bpf_ntohs(SRC_PORT) << 16))
+	if (val_u32 != SRC_PORT)
 		return SK_DROP;
 
 	/* Narrow loads from local_port field. Expect DST_PORT. */
-- 
2.35.1

