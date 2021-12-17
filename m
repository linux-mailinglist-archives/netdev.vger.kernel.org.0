Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6731847826E
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 02:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbhLQBuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 20:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbhLQBuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 20:50:40 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C1BC061401;
        Thu, 16 Dec 2021 17:50:40 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso4332951pji.0;
        Thu, 16 Dec 2021 17:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w4tiky2Ev+e+KeJAfi76cMrNuQlzK2V61yuDBEXDWc0=;
        b=Rly9BXeqI3WcgC3Q6Ovmz9hinm4HSfk1h3UdTqcNQHgPJC1PwIG78KAIadvyEF2XvW
         SmFohpvsDPjfr7CzjfcaxXbWAqUxdeiOE88/rISsd7yvF9nyiCaxE1zXEf02PzlLsSmQ
         e7c3GpM1vaXoR+iofQBg2wfGhypdMNLAxmB+8vBQAydYPxuOe4b0uoIFej03PslE3mtV
         QVWWE+8DEEP1rVFjymwCT/D6C0gxsVAJ132QdWJ28R8d2JdwYmI4os9tKavy6Wgu5VRz
         wPifedYTnz5tquKGpf1tGV38WY8ptBfAoxIvBNTjiB3PMFxKnR0P62XkXuQPyC87BLKw
         0adw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w4tiky2Ev+e+KeJAfi76cMrNuQlzK2V61yuDBEXDWc0=;
        b=WvRP0l1ptx+Bxa7TLkiFkd6XFLWBQKD5/Yh1qIwG8Ic0bHAcwzNc3s0xfmo9mdGRt2
         pUTs5lM8oxM5rL574nT3iqaZtW4OmBOIfnYCW1DOvpsZoLndcauXyHuFgtsu39XH+aqj
         tqw3CyC8xqMiZQtseynFYsTLq0UyrxmrWKnF8mtwRVJl8xsxki2NLEQBIUdJ8PweeoyB
         r8IdquskVz7kObChbuVa8ANyZMRiD7nqtsFkJPS+Jj00vTRVsx8l2PnPMlTmEHwkggd9
         yYchfxtdXNxHeVXTwXDkiFHP9Ga02Jd8fyzMGZdf1WZo8VTfKAqrt+ZPH16LLhuTnZ1e
         mbjg==
X-Gm-Message-State: AOAM530r761XgH7acteU9EQt3jDixjIa1Qk+hnxOsxIqTH/uDEaqRIJ0
        ni1qjTRZBCc5AbQk0ZPnUeNnkUNDzzw=
X-Google-Smtp-Source: ABdhPJzEH+oMSAHYH/dLyAcn2TtwWL4bsKBd/t36uNXdZzYjIWT+aAOXwYE3z/OzQRYBKdPqQpZ9Cw==
X-Received: by 2002:a17:90a:a504:: with SMTP id a4mr1072183pjq.17.1639705840045;
        Thu, 16 Dec 2021 17:50:40 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id y128sm6753859pfb.181.2021.12.16.17.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 17:50:39 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v4 02/10] bpf: Remove DEFINE_KFUNC_BTF_ID_SET
Date:   Fri, 17 Dec 2021 07:20:23 +0530
Message-Id: <20211217015031.1278167-3-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211217015031.1278167-1-memxor@gmail.com>
References: <20211217015031.1278167-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3973; h=from:subject; bh=KgWDQpD7ntt01mIVJQsow/CKaHwF799aKojh0NbHQv4=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhu+vEbbJo+J12H42gcgzcv1BolEIxmzkeFRwh4c2V het9LW+JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbvrxAAKCRBM4MiGSL8RyhJQD/ 9BDWJSZTwWWCDc6dv6f+Psqo1LzfbzWKG5wQVStssIG2pxtauwlABpXlA/QyiKe/nTnzSNmt+eQ+39 Nfkx+uB/RRfmkjLJBhDPP1BFScR/dA/TSXkuHUw+aqNlXuJ4u58hEb+UFPoBN4xR0EYROyFZXPpHZd g6Dnh572h3u92fnVStnO3S348fYlCW7aDNy3XdZ6talqxE4Yvn8+X1b9DRPkILRq04oELVL+moaOB4 3iPs2OsxFp0T4R9VIO06Hf9Sc3LV1HyBTH+VYfqDXT0dwECudeDYZgCtJmTnKNRt2bn7LpBsulHb4/ sIu49rBUwLJZL+3x9fkh7m2SntnTBwWjv/IOWhSitzRIYBAynwyCxVl1Q1YXAJKdcEhbRlkyr4FczY 2nOfbhC0qqGGbrS0sKVqDwLW5uEo9sYUWdlnXzREPibihk1gvCRT0SDCNqTggn9r3VmtyN2HHjVP/K tSFfUYX0yhJZIHxTem9jtdTKFR6SeqMS6JYMfvnPMjWnf5O7bZC4484nDQNpBseXu2s2Nv+SHKO8MA k6rVSARLM3CzkaBSQtVQZkBaHaoDT7D0HUW+Q69X6KN8GWULwgU74RS6G1ow1jB81DE0U8jNadzMfJ Jx858S3ZRXSxJRafwuFC4l7E/IJtgLCc4YhBSPDH9y0A7e6vwQaaqRoOp7RA==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only reason to keep it was to initialize list head, but future
commits will introduce more members that need to be set, which is more
convenient to do using designated initializer.

Hence, remove the macro, convert users, and initialize list head inside
register_kfunc_btf_id_set.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/btf.h                                   | 5 -----
 kernel/bpf/btf.c                                      | 1 +
 net/ipv4/tcp_bbr.c                                    | 5 ++++-
 net/ipv4/tcp_cubic.c                                  | 5 ++++-
 net/ipv4/tcp_dctcp.c                                  | 5 ++++-
 tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c | 5 ++++-
 6 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 916da2efbea8..5fefa6c2e62c 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -370,9 +370,4 @@ static struct kfunc_btf_id_list bpf_tcp_ca_kfunc_list __maybe_unused;
 static struct kfunc_btf_id_list prog_test_kfunc_list __maybe_unused;
 #endif
 
-#define DEFINE_KFUNC_BTF_ID_SET(set, name)                                     \
-	struct kfunc_btf_id_set name = { LIST_HEAD_INIT(name.list),            \
-					 { { (set) } },                        \
-					 THIS_MODULE }
-
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 97f6729cf23c..575c6a344096 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6369,6 +6369,7 @@ BTF_TRACING_TYPE_xxx
 void register_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
 			       struct kfunc_btf_id_set *s)
 {
+	INIT_LIST_HEAD(&s->list);
 	mutex_lock(&l->mutex);
 	list_add(&s->list, &l->list);
 	mutex_unlock(&l->mutex);
diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
index ec5550089b4d..280dada5d1ae 100644
--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -1169,7 +1169,10 @@ BTF_ID(func, bbr_set_state)
 #endif
 BTF_SET_END(tcp_bbr_kfunc_ids)
 
-static DEFINE_KFUNC_BTF_ID_SET(&tcp_bbr_kfunc_ids, tcp_bbr_kfunc_btf_set);
+static struct kfunc_btf_id_set tcp_bbr_kfunc_btf_set = {
+	.owner = THIS_MODULE,
+	.set   = &tcp_bbr_kfunc_ids,
+};
 
 static int __init bbr_register(void)
 {
diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index e07837e23b3f..b7e60f0ed42a 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -498,7 +498,10 @@ BTF_ID(func, cubictcp_acked)
 #endif
 BTF_SET_END(tcp_cubic_kfunc_ids)
 
-static DEFINE_KFUNC_BTF_ID_SET(&tcp_cubic_kfunc_ids, tcp_cubic_kfunc_btf_set);
+static struct kfunc_btf_id_set tcp_cubic_kfunc_btf_set = {
+	.owner = THIS_MODULE,
+	.set   = &tcp_cubic_kfunc_ids,
+};
 
 static int __init cubictcp_register(void)
 {
diff --git a/net/ipv4/tcp_dctcp.c b/net/ipv4/tcp_dctcp.c
index 0d7ab3cc7b61..ac2a47eb89d8 100644
--- a/net/ipv4/tcp_dctcp.c
+++ b/net/ipv4/tcp_dctcp.c
@@ -251,7 +251,10 @@ BTF_ID(func, dctcp_state)
 #endif
 BTF_SET_END(tcp_dctcp_kfunc_ids)
 
-static DEFINE_KFUNC_BTF_ID_SET(&tcp_dctcp_kfunc_ids, tcp_dctcp_kfunc_btf_set);
+static struct kfunc_btf_id_set tcp_dctcp_kfunc_btf_set = {
+	.owner = THIS_MODULE,
+	.set   = &tcp_dctcp_kfunc_ids,
+};
 
 static int __init dctcp_register(void)
 {
diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
index 5d52ea2768df..a437086e1860 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
@@ -93,7 +93,10 @@ BTF_SET_START(bpf_testmod_kfunc_ids)
 BTF_ID(func, bpf_testmod_test_mod_kfunc)
 BTF_SET_END(bpf_testmod_kfunc_ids)
 
-static DEFINE_KFUNC_BTF_ID_SET(&bpf_testmod_kfunc_ids, bpf_testmod_kfunc_btf_set);
+static struct kfunc_btf_id_set bpf_testmod_kfunc_btf_set = {
+	.owner = THIS_MODULE,
+	.set   = &bpf_testmod_kfunc_ids,
+};
 
 static int bpf_testmod_init(void)
 {
-- 
2.34.1

