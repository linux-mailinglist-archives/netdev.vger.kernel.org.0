Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146C41CE326
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 20:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731280AbgEKSws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 14:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731262AbgEKSwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 14:52:44 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7A6C05BD0D
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 11:52:43 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id l18so12289168wrn.6
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 11:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6tCYXE51QKC2s1xmH0RFoqrpk+5/XyGhBDt5mxX5Fgg=;
        b=FO58hWDqPYzKNjvKdhrYLp6kpxITiMwRv0UKW4YArm23gg9B5DLYcOH28W5a+n6LaO
         L/UAKhZCqrfUOtLkp0BkjvuKtqAOKMhcyqrFyIk0dMGOhj9Q7pSlI38QDV6A32eOXwPc
         EYLNtf5JS1IiTgIR15ilE20GDNBbFR67Msmkk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6tCYXE51QKC2s1xmH0RFoqrpk+5/XyGhBDt5mxX5Fgg=;
        b=qkmkuwD3qL9ZsBTeHC2zz/7hIJy2WYW/TOHvN5GdGGC3sSd71HHPeMQKQ0HJzxrpLV
         s58nyWsMRDpwFzT++GFgaVZbIrWwtU0ANgVTnB26hlNY3ueYN+DaYMHNnfaUijyFvoAj
         zN6LoV/k3eAyWLlhUo/fQS7VmKgkqsGeToyw0qzH9euuXJ7RlcApKdPS5+zxOJESX+M1
         9EmjR+Bs/y4Gvad5HZ+sp4ewG+0mZvnfSMcgJ7tNbiX9sv/XWTs78NPJQYV41ONd5eac
         HB7opwNIzbZgDBGSu4I3bzar/nKNwz2KeQeMqc0/xMiWXhS1zHn496qmQ+Orc74XPIuI
         n9tA==
X-Gm-Message-State: AGi0PubHqWdZ64xFpVJ892YNIh+lE0/3mPrSTL3pVa5SoQCU5BySS9Ld
        WWRcxUnC1PnDLYFSQ6p8D65vsAUi5+0=
X-Google-Smtp-Source: APiQypJdJjKeskJNOdvLgJIGLZkTRNunPkWLYdb/o/Zebmz/DQsWn4FJs/l4EiZPpZU7Wy+F2zTOkg==
X-Received: by 2002:a5d:5228:: with SMTP id i8mr20905349wra.359.1589223162200;
        Mon, 11 May 2020 11:52:42 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id t6sm3543234wma.4.2020.05.11.11.52.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 11:52:41 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     dccp@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v2 14/17] libbpf: Add support for SK_LOOKUP program type
Date:   Mon, 11 May 2020 20:52:15 +0200
Message-Id: <20200511185218.1422406-15-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200511185218.1422406-1-jakub@cloudflare.com>
References: <20200511185218.1422406-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make libbpf aware of the newly added program type, and assign it a
section name.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---

Notes:
    v2:
     - Add new libbpf symbols to version 0.0.9. (Andrii)

 tools/lib/bpf/libbpf.c        | 3 +++
 tools/lib/bpf/libbpf.h        | 2 ++
 tools/lib/bpf/libbpf.map      | 2 ++
 tools/lib/bpf/libbpf_probes.c | 1 +
 4 files changed, 8 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 6c2f46908f4d..ccded6cd310a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6524,6 +6524,7 @@ BPF_PROG_TYPE_FNS(perf_event, BPF_PROG_TYPE_PERF_EVENT);
 BPF_PROG_TYPE_FNS(tracing, BPF_PROG_TYPE_TRACING);
 BPF_PROG_TYPE_FNS(struct_ops, BPF_PROG_TYPE_STRUCT_OPS);
 BPF_PROG_TYPE_FNS(extension, BPF_PROG_TYPE_EXT);
+BPF_PROG_TYPE_FNS(sk_lookup, BPF_PROG_TYPE_SK_LOOKUP);
 
 enum bpf_attach_type
 bpf_program__get_expected_attach_type(struct bpf_program *prog)
@@ -6690,6 +6691,8 @@ static const struct bpf_sec_def section_defs[] = {
 	BPF_EAPROG_SEC("cgroup/setsockopt",	BPF_PROG_TYPE_CGROUP_SOCKOPT,
 						BPF_CGROUP_SETSOCKOPT),
 	BPF_PROG_SEC("struct_ops",		BPF_PROG_TYPE_STRUCT_OPS),
+	BPF_EAPROG_SEC("sk_lookup",		BPF_PROG_TYPE_SK_LOOKUP,
+						BPF_SK_LOOKUP),
 };
 
 #undef BPF_PROG_SEC_IMPL
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 8ea69558f0a8..7bb5a4f22740 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -346,6 +346,7 @@ LIBBPF_API int bpf_program__set_perf_event(struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_tracing(struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_struct_ops(struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_extension(struct bpf_program *prog);
+LIBBPF_API int bpf_program__set_sk_lookup(struct bpf_program *prog);
 
 LIBBPF_API enum bpf_prog_type bpf_program__get_type(struct bpf_program *prog);
 LIBBPF_API void bpf_program__set_type(struct bpf_program *prog,
@@ -373,6 +374,7 @@ LIBBPF_API bool bpf_program__is_perf_event(const struct bpf_program *prog);
 LIBBPF_API bool bpf_program__is_tracing(const struct bpf_program *prog);
 LIBBPF_API bool bpf_program__is_struct_ops(const struct bpf_program *prog);
 LIBBPF_API bool bpf_program__is_extension(const struct bpf_program *prog);
+LIBBPF_API bool bpf_program__is_sk_lookup(const struct bpf_program *prog);
 
 /*
  * No need for __attribute__((packed)), all members of 'bpf_map_def'
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 0133d469d30b..2490c5e34297 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -262,4 +262,6 @@ LIBBPF_0.0.9 {
 		bpf_link_get_fd_by_id;
 		bpf_link_get_next_id;
 		bpf_program__attach_iter;
+		bpf_program__is_sk_lookup;
+		bpf_program__set_sk_lookup;
 } LIBBPF_0.0.8;
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index 2c92059c0c90..5c6d3e49f254 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -109,6 +109,7 @@ probe_load(enum bpf_prog_type prog_type, const struct bpf_insn *insns,
 	case BPF_PROG_TYPE_STRUCT_OPS:
 	case BPF_PROG_TYPE_EXT:
 	case BPF_PROG_TYPE_LSM:
+	case BPF_PROG_TYPE_SK_LOOKUP:
 	default:
 		break;
 	}
-- 
2.25.3

