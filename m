Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CBA22396A
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 12:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgGQKgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 06:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbgGQKf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 06:35:59 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F98C061755
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 03:35:58 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id j11so12020730ljo.7
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 03:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X5grnw5yA7a34ptPfpYZRmkNxHU+5rkM7nQ6am7lk8c=;
        b=XBG78jnwqMDVnAAaKrHTqDPFRvqvWKnPnA+TJDM/54cZRaqb0s/wXUcVGkb08ayXeh
         7ifzOMA6GOvuQ8qC1D2rDMpMvY8hr1J+aQ+wOcLmjCEdlMEb4+DUvzEDOQZoFg5nU671
         bFlG7qxR6+79bKKLrfZZOrSrsPJ1owwiVT7eU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X5grnw5yA7a34ptPfpYZRmkNxHU+5rkM7nQ6am7lk8c=;
        b=T3fMUkYjbjD+fOEYuswD02+T7NiX89M+K5ol0203lQ/udv28HqZs9nJmCWP0ePV0Wa
         bOzhcS5vYpu+RVIT/LtmWlZLeo+7BAah9twXeahEbPRvjxYv3JUYCs85bIPQEt6wLw4k
         Ywf2cWU3587gYmucJoEKfK9uXHv0XzPvM99J0ZAO5mMYIBse0fM+Cj8yp/KnPX3KNcRn
         tfjwPTxsvGc8UmiSb2pd/FjMuyfXOK0VAtrYLEw0XgktouPZMhjK/kNPN+FXWCuCnM+5
         MEjOW3A3ScE7C9fQzDyuY+mMhreN8GRU/pAFpNs/iDVQqyEHUEhZcKUvaJtUdTbH2qeS
         zXLg==
X-Gm-Message-State: AOAM532zxUIhoIv0IyxlW9FrWQcjzyRrQsDD+gp0W4j3TF/2tuzRmLgQ
        1m48ZEs/plYJtmYnHc/8hlqEsGcHxOugFw==
X-Google-Smtp-Source: ABdhPJwbpEgdIjJeEQGDVqtsZGaOZcSMPRFXls1XxR6F6tVOY2yC89rT9TN9PoOWCbGXWVuZQps03g==
X-Received: by 2002:a2e:5141:: with SMTP id b1mr3924747lje.336.1594982157197;
        Fri, 17 Jul 2020 03:35:57 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id p8sm1871754ljn.117.2020.07.17.03.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 03:35:56 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v5 12/15] libbpf: Add support for SK_LOOKUP program type
Date:   Fri, 17 Jul 2020 12:35:33 +0200
Message-Id: <20200717103536.397595-13-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200717103536.397595-1-jakub@cloudflare.com>
References: <20200717103536.397595-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make libbpf aware of the newly added program type, and assign it a
section name.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---

Notes:
    v4:
    - Add trailing slash to section prefix ("sk_lookup/"). (Andrii)
    
    v3:
    - Move new libbpf symbols to version 0.1.0.
    - Set expected_attach_type in probe_load for new prog type.
    
    v2:
    - Add new libbpf symbols to version 0.0.9. (Andrii)

 tools/lib/bpf/libbpf.c        | 3 +++
 tools/lib/bpf/libbpf.h        | 2 ++
 tools/lib/bpf/libbpf.map      | 2 ++
 tools/lib/bpf/libbpf_probes.c | 3 +++
 4 files changed, 10 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index f55fd8a5c008..846164c79df1 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6799,6 +6799,7 @@ BPF_PROG_TYPE_FNS(perf_event, BPF_PROG_TYPE_PERF_EVENT);
 BPF_PROG_TYPE_FNS(tracing, BPF_PROG_TYPE_TRACING);
 BPF_PROG_TYPE_FNS(struct_ops, BPF_PROG_TYPE_STRUCT_OPS);
 BPF_PROG_TYPE_FNS(extension, BPF_PROG_TYPE_EXT);
+BPF_PROG_TYPE_FNS(sk_lookup, BPF_PROG_TYPE_SK_LOOKUP);
 
 enum bpf_attach_type
 bpf_program__get_expected_attach_type(struct bpf_program *prog)
@@ -6981,6 +6982,8 @@ static const struct bpf_sec_def section_defs[] = {
 	BPF_EAPROG_SEC("cgroup/setsockopt",	BPF_PROG_TYPE_CGROUP_SOCKOPT,
 						BPF_CGROUP_SETSOCKOPT),
 	BPF_PROG_SEC("struct_ops",		BPF_PROG_TYPE_STRUCT_OPS),
+	BPF_EAPROG_SEC("sk_lookup/",		BPF_PROG_TYPE_SK_LOOKUP,
+						BPF_SK_LOOKUP),
 };
 
 #undef BPF_PROG_SEC_IMPL
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 2335971ed0bd..c2272132e929 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -350,6 +350,7 @@ LIBBPF_API int bpf_program__set_perf_event(struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_tracing(struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_struct_ops(struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_extension(struct bpf_program *prog);
+LIBBPF_API int bpf_program__set_sk_lookup(struct bpf_program *prog);
 
 LIBBPF_API enum bpf_prog_type bpf_program__get_type(struct bpf_program *prog);
 LIBBPF_API void bpf_program__set_type(struct bpf_program *prog,
@@ -377,6 +378,7 @@ LIBBPF_API bool bpf_program__is_perf_event(const struct bpf_program *prog);
 LIBBPF_API bool bpf_program__is_tracing(const struct bpf_program *prog);
 LIBBPF_API bool bpf_program__is_struct_ops(const struct bpf_program *prog);
 LIBBPF_API bool bpf_program__is_extension(const struct bpf_program *prog);
+LIBBPF_API bool bpf_program__is_sk_lookup(const struct bpf_program *prog);
 
 /*
  * No need for __attribute__((packed)), all members of 'bpf_map_def'
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index c5d5c7664c3b..6f0856abe299 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -287,6 +287,8 @@ LIBBPF_0.1.0 {
 		bpf_map__type;
 		bpf_map__value_size;
 		bpf_program__autoload;
+		bpf_program__is_sk_lookup;
 		bpf_program__set_autoload;
+		bpf_program__set_sk_lookup;
 		btf__set_fd;
 } LIBBPF_0.0.9;
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index 10cd8d1891f5..5a3d3f078408 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -78,6 +78,9 @@ probe_load(enum bpf_prog_type prog_type, const struct bpf_insn *insns,
 	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
 		xattr.expected_attach_type = BPF_CGROUP_INET4_CONNECT;
 		break;
+	case BPF_PROG_TYPE_SK_LOOKUP:
+		xattr.expected_attach_type = BPF_SK_LOOKUP;
+		break;
 	case BPF_PROG_TYPE_KPROBE:
 		xattr.kern_version = get_kernel_version();
 		break;
-- 
2.25.4

