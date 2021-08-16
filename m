Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4B03ED272
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236265AbhHPKwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236262AbhHPKwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 06:52:08 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1C9C0612A3;
        Mon, 16 Aug 2021 03:51:22 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id fa24-20020a17090af0d8b0290178bfa69d97so26922525pjb.0;
        Mon, 16 Aug 2021 03:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9WMFUZKDxMfxw44rjP6HLGPmcDMjc9RuKsGPbEWZGyw=;
        b=UYvfREnOKpTSNXzvJsw3rSEUTwd2nSeqxk9Ml+iR0byJuf/dtLx2+J7omAadkglGr9
         Tco7kiolV+XZfj0pAAyvoWsXaAM47ev7lQfsq+LZzVzmtIh1j/Zpt2AVBF584CJVZbaM
         cnqaahavhCO2Bkbms+TMn9KKWb41Dj3cfhaA/vnB6SIGMnCTntgnK0iy2MEWX8dOvlJa
         7840wvqBn8Yk8LvHgTSLq1BWt45tykhbLEr0XBPYXy8CaUWh315UYn7NMRLjatKn4DTq
         1rFjnTP5FK5zUYQLhhPoWWo4ze4fx+d+O11VP5FUpbpYKcW5pMygyP7CtzXVttyp7bgL
         mdsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9WMFUZKDxMfxw44rjP6HLGPmcDMjc9RuKsGPbEWZGyw=;
        b=X1Z8cWhz3N+zjnzxQxdsVZrUaFRNs9bO4rUuEen7O/jeIJfdFB7N06fK4fR8qahlzP
         cUfTjBYN4RsC4GKcsc0CqMWjWxM9mnhqgKb1qYwKm9MGHJsP2JmoL3JOS7lZWMqbDHKm
         0ylniKiDrMEZZJ1lNSCvPHisX5Ksv60bvB2pRLVFCZo1f88a9bXI3sqOl6m+NUhBrWZ1
         6QoLkvGamUxiFoZa/5beVKoG0O20O0ZDUcHUbavZ0e8z8wnjPsVuwVirJoz6+EEIGKJl
         YbhFKqNkEH6XCqqtfUCCZj2cf6vvIsMCsVQS8gDONe+cSG8c0/LbGJmatjOyEFVAMWJj
         Ilrg==
X-Gm-Message-State: AOAM533m8iF1nJuDJTXcNzaqHMKHJhz2D7kkdQTuwAyyLTub1ZeQfXwX
        Xl6ghK5jNAjMOiigTCgMClE=
X-Google-Smtp-Source: ABdhPJxh9IxiulwybsKd7daCC5p/EXFlTi2+ojIXPXkMgDm59ZmdhFNetpiXBVISWMOClTuy3t9TaA==
X-Received: by 2002:a17:90b:438e:: with SMTP id in14mr16714417pjb.66.1629111082059;
        Mon, 16 Aug 2021 03:51:22 -0700 (PDT)
Received: from IRVINGLIU-MB0.tencent.com ([203.205.141.115])
        by smtp.gmail.com with ESMTPSA id j13sm12685256pgp.29.2021.08.16.03.51.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Aug 2021 03:51:21 -0700 (PDT)
From:   Xu Liu <liuxu623@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xu Liu <liuxu623@gmail.com>
Subject: [PATCH] bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_SOCK_OPS
Date:   Mon, 16 Aug 2021 18:51:14 +0800
Message-Id: <20210816105114.34781-1-liuxu623@gmail.com>
X-Mailer: git-send-email 2.28.0
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

