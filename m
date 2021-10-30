Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4830E4409AE
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 16:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbhJ3Osv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 10:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbhJ3Oss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 10:48:48 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE0FC061570;
        Sat, 30 Oct 2021 07:46:18 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ls14-20020a17090b350e00b001a00e2251c8so9422555pjb.4;
        Sat, 30 Oct 2021 07:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nJ1EclasUk2f68vdVW65qkPNJErhsVSoIUspEZQHebU=;
        b=F7E3ggFKJ/Um+ROWaPfC8niBnCq054B5g+F/X+gU50VbmSntbdqqKtwwOGSm9f6RVK
         w2arIUvH0pxiJtXo63kyGHxg8b0DUla3mZoXAAzhfbp3icWQaiDaePjCGI+ulpZVWTXL
         VZlwqvxKBipPUIefdVG/jxi5zx/vNSIP8az1UqeMB4t0VFRVP9LGlqps2ZGi8R3CUNYV
         i8eSOgEuAfTO5ZImZvSzSUg2al/3VSzDb6dKgfBJkleqlDluL6jNM1G0K8mz08O2FMJP
         eSXs+6tzwgoaqGSpwMk/ygHWYh2gwHS4NCzw9OrgGiVKJt1DXmdzIPDg+GVKnqLqcvR9
         xm6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nJ1EclasUk2f68vdVW65qkPNJErhsVSoIUspEZQHebU=;
        b=solSTp7rVa+XGRTgH3FkCUJnMJfr8l09GrVMPje7j3vksGLXEHDFXV2ryZ7E23ju+T
         Vu29/chqB4zoSMwFyGdYvGl/uOWY4hyye3sJ/BnA+7Bkgl4DUy7kDW+Qy7bjD6t3jxmk
         1XB536xpGX6gUlvKnXjwU/35ipsvD5BhrRlKBFyz2ys7CNDajoAMOTjmm5kFgfbB5Dro
         nANXn2CSt6o0aYOP6Psf5cCwiLu6rRbCBe398eZzx5PnAVNT9B2iqkVfAmLUIu830QY1
         h3erB/jI2W6UVmZmjWBEwQ53IIQSGXRLIBulqll1TW8oYcIB+gEVDpCDPNbl4RVLdb7J
         a1kg==
X-Gm-Message-State: AOAM532T6WSZNcq4TzXtI7dfNvptXPEUpWbdfXdSpJoisnTlftmOsFt1
        gNaFoiCWdJKOOjF1Jt4XcBYXEmo2ScGbPg==
X-Google-Smtp-Source: ABdhPJwWR4C1NsoJVzURbMsB/C2o38fUUgXUafnZOYXIL7Bz7F8winlYWXev1XptNYI/P2ITdQScfA==
X-Received: by 2002:a17:90b:4f90:: with SMTP id qe16mr18922156pjb.137.1635605177690;
        Sat, 30 Oct 2021 07:46:17 -0700 (PDT)
Received: from localhost ([2405:201:6014:d916:31fc:9e49:a605:b093])
        by smtp.gmail.com with ESMTPSA id h18sm10683638pfh.144.2021.10.30.07.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 07:46:17 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH RFC bpf-next v1 2/6] bpf: Remove DEFINE_KFUNC_BTF_ID_SET
Date:   Sat, 30 Oct 2021 20:16:05 +0530
Message-Id: <20211030144609.263572-3-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211030144609.263572-1-memxor@gmail.com>
References: <20211030144609.263572-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3978; h=from:subject; bh=otcOzJv93xMLNCgi/x39IsdQ6Uq9NhaGk9P5BMFsBO8=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhfVoRulEVaqr3G55h6ST7Kf+6WfB0uaNTX6Jeka50 IiKv/FuJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYX1aEQAKCRBM4MiGSL8RyslOD/ wJXbnh1cKbCiinKKu4xdKN2bppQFvoaPmnLI1JyySf0jR2w+j1VY8gObLkoNcAzx7jBQstl6/alp1k OuEd9DljsAjDD4HcliHRq7dvN1PrucFu2BODiopKw6Ny5/XVR+VhwGjXfSBC8J9CAphAiWLs5eYd/4 f32aBHins7IBXzfzcqz8D2WM487zREmUJuVtw9+fPMRCoOZ0YTHDttAieYtpKgZIGi++QRnfnjF3GU Q+wCZJMCz5DPoVt0pdmvxYILEfVUEY2bjW3hXZt8+/5P8q7kvI3vBIu/m+Oa5s28CeOtvycgmA+MDd mWfqjpSWisyTyU4yjx40lgiQ+BcyPFwPJdhwC1cRSnleAq4pSnBL9Xs8hcGV+wuEtts+XjOmnp4M2q OPo9iMGxqkxRxVbTcGDt1v12D23+N2gteJF/M4L6sz9q6hd2Bxj+0NemjRjMOa0bmXpdVNnbmIKpDP 4qBE5joY9aIJca7dwRIGUJjcT0X0XBB/ZHzN2JcFRelV+o6HOgE+gO85+jNaLFqALH1BPeHUyeRvq0 GBvKpd5qhQtuGW7sRPy5tr4Cjiou72l0A64CCNc1oDf+E1Cjzn0NuObqCcluoS0tFefmdstFbudbxa eIHXfu3yobgLZFeV1vVzPrE+BiHjN05UvO9qzT+RQhrm1ylCEkkP5gr5i5oA==
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
 include/linux/btf.h                                   | 4 ----
 kernel/bpf/btf.c                                      | 1 +
 net/ipv4/tcp_bbr.c                                    | 5 ++++-
 net/ipv4/tcp_cubic.c                                  | 5 ++++-
 net/ipv4/tcp_dctcp.c                                  | 5 ++++-
 tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c | 5 ++++-
 6 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 203eef993d76..1da108e35042 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -270,10 +270,6 @@ static inline bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist,
 }
 #endif
 
-#define DEFINE_KFUNC_BTF_ID_SET(set, name)                                     \
-	struct kfunc_btf_id_set name = { LIST_HEAD_INIT(name.list), (set),     \
-					 THIS_MODULE }
-
 extern struct kfunc_btf_id_list bpf_tcp_ca_kfunc_list;
 extern struct kfunc_btf_id_list prog_test_kfunc_list;
 
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index be1082270455..1773f91fff10 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6356,6 +6356,7 @@ struct kfunc_btf_id_list {
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
index 5e9d9c51164c..70384a8040c5 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -497,7 +497,10 @@ BTF_ID(func, cubictcp_acked)
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
2.33.1

