Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423FE3F2786
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 09:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238848AbhHTHSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 03:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238802AbhHTHSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 03:18:03 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E2DC061756;
        Fri, 20 Aug 2021 00:17:26 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id e7so8258719pgk.2;
        Fri, 20 Aug 2021 00:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Dc4aSLuoa6omNl1zxvSqWiFnOSWJh9ZCFnyIQ8OBVvw=;
        b=AiqJit9EickB/UfRVGdlsM1wvjmSgrIFfkfs3KK3CS7DVqJvaxy0fOy+kBUeT0nWVd
         2zVXUVSpPMjW56olO6Vb5ypfqxzKcgrMLdgljmGiJRguWWgm9axfgRcwoCgokdG83ddI
         n7MPewrsyUdW2gi7LbjpY+PRXvOKlGffwWWWo0UVMKGx4k1z0ddloJ/AbIbDSSlxiCl0
         gBYdu4pikQ+Nx+E3IRvsrRmHeuPUyvSjF8sX7vV7K6Yl/2eX5dDSxY1xGGMq05cfdPko
         nm3SNQwff2gsVVkUkspB6BwDGa4IJV7DnYkN1RPO1SwkAj1ZD/F8R7Iey+i/mP6WcZVk
         574g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dc4aSLuoa6omNl1zxvSqWiFnOSWJh9ZCFnyIQ8OBVvw=;
        b=bydN2IP02103Az+CNmR2qI/aRKTiRF3HYCvvMsPfnI8iDOkXkn/DlknF0R01RvPB35
         UUO2uY+M0jk/myIe6IH0bq7Kxv5gcuhYbuKWMjs6rB3Nnz9243nE+2pyIJucyR1qhtms
         KH7Mc88MzXEf1dDE0NKfQ7/ybiu8esv9idmI7CVdxuSJJe85Z7ZD4ki+EmfjTBGL2Rwn
         4xNLxgOPaQyDZ1a0NOp6A2TAvPs40n1Z9hZAWexDpv6nccupvVt3RnhpCpTrlMwyLld9
         J8HC4Do8Gd9vWjc+VjbUezCjUZ9a+1mGXyHI8kbau9at9d9liCruFe64kiLgatBjdy3Y
         ob7w==
X-Gm-Message-State: AOAM532C68Vj7Z+UTts2zdBqbxQDABoSWpdmjIl5gYLdixfH0VVlLYah
        PMcfX+JPKLnFw4hD1uHzv9A=
X-Google-Smtp-Source: ABdhPJx0+IMIlg1yKCkvYaeYfTos+noh8LNoea9H+8nSMzliw7ejKAQ6joSgHiCChlupYvfNcafKng==
X-Received: by 2002:a05:6a00:a8a:b029:30c:a10b:3e3f with SMTP id b10-20020a056a000a8ab029030ca10b3e3fmr18258595pfl.40.1629443846047;
        Fri, 20 Aug 2021 00:17:26 -0700 (PDT)
Received: from IRVINGLIU-MB0.tencent.com ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id u21sm5717544pfh.163.2021.08.20.00.17.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Aug 2021 00:17:25 -0700 (PDT)
From:   Xu Liu <liuxu623@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xu Liu <liuxu623@gmail.com>
Subject: [PATCH bpf-next 1/2] bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_SK_MSG
Date:   Fri, 20 Aug 2021 15:17:11 +0800
Message-Id: <20210820071712.52852-2-liuxu623@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210820071712.52852-1-liuxu623@gmail.com>
References: <20210820071712.52852-1-liuxu623@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We'd like to be able to identify netns from sk_msg hooks
to accelerate local process communication form different netns.

Signed-off-by: Xu Liu <liuxu623@gmail.com>
---
 net/core/filter.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 59b8f5050180..cfbd01167eb5 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4688,6 +4688,18 @@ static const struct bpf_func_proto bpf_get_netns_cookie_sock_ops_proto = {
 	.arg1_type	= ARG_PTR_TO_CTX_OR_NULL,
 };
 
+BPF_CALL_1(bpf_get_netns_cookie_sk_msg, struct sk_msg *, ctx)
+{
+	return __bpf_get_netns_cookie(ctx ? ctx->sk : NULL);
+}
+
+static const struct bpf_func_proto bpf_get_netns_cookie_sk_msg_proto = {
+	.func		= bpf_get_netns_cookie_sk_msg,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX_OR_NULL,
+};
+
 BPF_CALL_1(bpf_get_socket_uid, struct sk_buff *, skb)
 {
 	struct sock *sk = sk_to_full_sk(skb->sk);
@@ -7551,6 +7563,8 @@ sk_msg_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_sk_storage_get_proto;
 	case BPF_FUNC_sk_storage_delete:
 		return &bpf_sk_storage_delete_proto;
+	case BPF_FUNC_get_netns_cookie:
+		return &bpf_get_netns_cookie_sk_msg_proto;
 #ifdef CONFIG_CGROUPS
 	case BPF_FUNC_get_current_cgroup_id:
 		return &bpf_get_current_cgroup_id_proto;
-- 
2.28.0

