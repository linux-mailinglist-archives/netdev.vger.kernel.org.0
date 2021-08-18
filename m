Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83DAA3F021B
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 12:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235358AbhHRK7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 06:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235218AbhHRK7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 06:59:07 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF69EC0613D9;
        Wed, 18 Aug 2021 03:58:32 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id k19so1740312pfc.11;
        Wed, 18 Aug 2021 03:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9WMFUZKDxMfxw44rjP6HLGPmcDMjc9RuKsGPbEWZGyw=;
        b=WQuiHiIFqC05MBRV5TAarkrtZG7J96E8DBWZtPs8QVxnxLUAiE0SeQEx2m7zHktb/m
         afH/bIUn/5r3phNpeRP2DFbsF2T8VHcoAVFkQcKQYqlFTiuU+hh+Ytr2VKZB6Lj52Mp0
         X7iLIcMqRytzyhgLlYeV7DKnmEzLMGwun2aN80BEImxFM4mfOL+7v2cF0mhwNH+OtJ5b
         NRML6mYKR2nWHIjaMWvrcGQO2nBkM2a9106shtyaatjl+MWn0jIbiwGaXFkz/mrL2I3f
         9NCDq5tXRaVTzCYGZWwCncFdm2krvCsgtyBgRSakc9egDJCJczo9LqrYIGSnIgyyPlGG
         oz1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9WMFUZKDxMfxw44rjP6HLGPmcDMjc9RuKsGPbEWZGyw=;
        b=FBnI0oa4dCLaASlCCw9Zx5gLZl09V+PRbyI8WoP78VZnCKOkLrYe2CFfnJscI6ppc/
         JGPEZatnupUISc9N6nAnoPJILBVcX1LoHmvlch8sNS1O1+h8RGu8g+9PF55oIncBVJrd
         8TnShuy7DN+4zVikBMzvNeh1EAU22CHqNUK/85D08fd83kkV2lluZ06uiBTz/g2j9Nad
         dSjWCuYQxYeOb6JQ+ngIJbHRGET4uOcHvRYiwgz6Z53iYfvGj1uUfEeaLSZf5YNvfm3s
         MMrTj4DvpgEL75FaugAn+GpgRVW+Tty9k0kl1hboF3jRpcXWhOUXTVtDnnbuPNn45tfC
         AD3A==
X-Gm-Message-State: AOAM533ew2Unz7DF/VXDILrxrhNb1F7UVoMnyKRujJlGt2zBQzSy79eX
        s9uWrKdHugNK0H22p/6VNA8=
X-Google-Smtp-Source: ABdhPJxeTjPy6/87FIkM+w3vnGVmnNd5a69a/n4WBNtayD2PthQOQvHBHGZFbBwrLX2k5lqdqJqfYw==
X-Received: by 2002:a63:83c7:: with SMTP id h190mr8408230pge.51.1629284312445;
        Wed, 18 Aug 2021 03:58:32 -0700 (PDT)
Received: from IRVINGLIU-MB0.tencent.com ([203.205.141.117])
        by smtp.gmail.com with ESMTPSA id b190sm7099440pgc.91.2021.08.18.03.58.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Aug 2021 03:58:32 -0700 (PDT)
From:   Xu Liu <liuxu623@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xu Liu <liuxu623@gmail.com>
Subject: [PATCH bpf-next v2 1/2] bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_SOCK_OPS
Date:   Wed, 18 Aug 2021 18:58:19 +0800
Message-Id: <20210818105820.91894-2-liuxu623@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210818105820.91894-1-liuxu623@gmail.com>
References: <20210818105820.91894-1-liuxu623@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We'd like to be able to identify netns from sockops hooks
to accelerate local process communication form different netns.

Signed-off-by: Xu Liu <liuxu623@gmail.com>
---
 net/core/filter.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index d70187ce851b..34938a537931 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4664,6 +4664,18 @@ static const struct bpf_func_proto bpf_get_netns_cookie_sock_addr_proto = {
 	.arg1_type	= ARG_PTR_TO_CTX_OR_NULL,
 };
 
+BPF_CALL_1(bpf_get_netns_cookie_sock_ops, struct bpf_sock_ops_kern *, ctx)
+{
+	return __bpf_get_netns_cookie(ctx ? ctx->sk : NULL);
+}
+
+static const struct bpf_func_proto bpf_get_netns_cookie_sock_ops_proto = {
+	.func		= bpf_get_netns_cookie_sock_ops,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX_OR_NULL,
+};
+
 BPF_CALL_1(bpf_get_socket_uid, struct sk_buff *, skb)
 {
 	struct sock *sk = sk_to_full_sk(skb->sk);
@@ -7445,6 +7457,8 @@ sock_ops_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_sk_storage_get_proto;
 	case BPF_FUNC_sk_storage_delete:
 		return &bpf_sk_storage_delete_proto;
+	case BPF_FUNC_get_netns_cookie:
+		return &bpf_get_netns_cookie_sock_ops_proto;
 #ifdef CONFIG_INET
 	case BPF_FUNC_load_hdr_opt:
 		return &bpf_sock_ops_load_hdr_opt_proto;
-- 
2.28.0

