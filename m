Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460644AFB8A
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 19:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240830AbiBISr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 13:47:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241088AbiBISqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 13:46:31 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6F1C001F5A
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 10:43:41 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id 13so5938651lfp.7
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 10:43:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RN/tkFt4SUEnPNKIEmbgIJ+tfio1vompc3kgaRkSrL8=;
        b=L5aiNBDHpsoVmJ9NKwroVT42/piGlsi3/DJhLy5Dk6OvwNq4Hbkb2vzhYR7Qsyze9A
         0i/3j5f9gf8rQOmbnv+FfJxyNp2oRiDh7VvG0bsFVz10Bj0I4cEk7k2RhY5ce3upvVRb
         8G6oMFDUFV+Ie0qqq1WQnks2u2NcdqlJEZULM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RN/tkFt4SUEnPNKIEmbgIJ+tfio1vompc3kgaRkSrL8=;
        b=VkzT73q8G5Q/XZ+AuGp7pl89Kr3SK7C6BNySnYxVE3SNzbLRNwIOXTJK2qcnYaoeSF
         5r9MTG9IyjBYfLHcQo0dcXh6i5O2aibkdX/hWGX06PUQZYp5nu3OxqjGy/kVnJR7gZyv
         zIpNp2tV+0K0E/k+tLsWU8AJtrhHlKSbFltl9i/6wa8KG8MLJ59cpgFxLfe+Kt27gwod
         Uq0d+DZSvIaO5K/zt9a2jKOvkljUL7VvFbg1KGgJeqjoQozSprZXdjb35lOsRGxMzAHI
         wTWj6M0uilmG9YEEUBO/5HJfZM17EQM+zhEy6W12qfXMcddIeQdj4FhBd03CFkE7otWy
         pqHA==
X-Gm-Message-State: AOAM532g32Sxybikq93IVHvqh2jXqSGkWqxmNat+ldLKrW2Q+uN92dnt
        hWbRMjyZ/nSCDkQz+ssJQNdaxg==
X-Google-Smtp-Source: ABdhPJxXdRrugt2f3/89XSZced49VuGMF0gs9hWVzNTZ9HHt7a9XBXx/L/yEs7AGUuHAtpzJPItq+A==
X-Received: by 2002:a05:6512:6c5:: with SMTP id u5mr2514963lff.105.1644432215199;
        Wed, 09 Feb 2022 10:43:35 -0800 (PST)
Received: from cloudflare.com (2a01-110f-4809-d800-0000-0000-0000-0e00.aa.ipv6.supernova.orange.pl. [2a01:110f:4809:d800::e00])
        by smtp.gmail.com with ESMTPSA id i15sm711986lfu.280.2022.02.09.10.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 10:43:34 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com, Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf-next v2 1/2] bpf: Make remote_port field in struct bpf_sk_lookup 16-bit wide
Date:   Wed,  9 Feb 2022 19:43:32 +0100
Message-Id: <20220209184333.654927-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220209184333.654927-1-jakub@cloudflare.com>
References: <20220209184333.654927-1-jakub@cloudflare.com>
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

remote_port is another case of a BPF context field documented as a 32-bit
value in network byte order for which the BPF context access converter
generates a load of a zero-padded 16-bit integer in network byte order.

First such case was dst_port in bpf_sock which got addressed in commit
4421a582718a ("bpf: Make dst_port field in struct bpf_sock 16-bit wide").

Loading 4-bytes from the remote_port offset and converting the value with
bpf_ntohl() leads to surprising results, as the expected value is shifted
by 16 bits.

Reduce the confusion by splitting the field in two - a 16-bit field holding
a big-endian integer, and a 16-bit zero-padding anonymous field that
follows it.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/uapi/linux/bpf.h | 3 ++-
 net/bpf/test_run.c       | 4 ++--
 net/core/filter.c        | 3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a7f0ddedac1f..afe3d0d7f5f2 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -6453,7 +6453,8 @@ struct bpf_sk_lookup {
 	__u32 protocol;		/* IP protocol (IPPROTO_TCP, IPPROTO_UDP) */
 	__u32 remote_ip4;	/* Network byte order */
 	__u32 remote_ip6[4];	/* Network byte order */
-	__u32 remote_port;	/* Network byte order */
+	__be16 remote_port;	/* Network byte order */
+	__u16 :16;		/* Zero padding */
 	__u32 local_ip4;	/* Network byte order */
 	__u32 local_ip6[4];	/* Network byte order */
 	__u32 local_port;	/* Host byte order */
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 0220b0822d77..8c2608567555 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1146,7 +1146,7 @@ int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog, const union bpf_attr *kat
 	if (!range_is_zero(user_ctx, offsetofend(typeof(*user_ctx), local_port), sizeof(*user_ctx)))
 		goto out;
 
-	if (user_ctx->local_port > U16_MAX || user_ctx->remote_port > U16_MAX) {
+	if (user_ctx->local_port > U16_MAX) {
 		ret = -ERANGE;
 		goto out;
 	}
@@ -1154,7 +1154,7 @@ int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog, const union bpf_attr *kat
 	ctx.family = (u16)user_ctx->family;
 	ctx.protocol = (u16)user_ctx->protocol;
 	ctx.dport = (u16)user_ctx->local_port;
-	ctx.sport = (__force __be16)user_ctx->remote_port;
+	ctx.sport = user_ctx->remote_port;
 
 	switch (ctx.family) {
 	case AF_INET:
diff --git a/net/core/filter.c b/net/core/filter.c
index 99a05199a806..83f06d3b2c52 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10843,7 +10843,8 @@ static bool sk_lookup_is_valid_access(int off, int size,
 	case bpf_ctx_range(struct bpf_sk_lookup, local_ip4):
 	case bpf_ctx_range_till(struct bpf_sk_lookup, remote_ip6[0], remote_ip6[3]):
 	case bpf_ctx_range_till(struct bpf_sk_lookup, local_ip6[0], local_ip6[3]):
-	case bpf_ctx_range(struct bpf_sk_lookup, remote_port):
+	case offsetof(struct bpf_sk_lookup, remote_port) ...
+	     offsetof(struct bpf_sk_lookup, local_ip4) - 1:
 	case bpf_ctx_range(struct bpf_sk_lookup, local_port):
 	case bpf_ctx_range(struct bpf_sk_lookup, ingress_ifindex):
 		bpf_ctx_record_field_size(info, sizeof(__u32));
-- 
2.31.1

