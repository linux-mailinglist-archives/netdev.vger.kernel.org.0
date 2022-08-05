Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169D358B146
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 23:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241265AbiHEVs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 17:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240471AbiHEVsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 17:48:55 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B0976477
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 14:48:54 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id b5-20020a17090a6e0500b001f3076ab926so1552410pjk.1
        for <netdev@vger.kernel.org>; Fri, 05 Aug 2022 14:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=v1NXB6wxRFohvXJoX8NOegBlamHwcU9rtOLwkpAdV8E=;
        b=Xi5iNcCGRKvjjsmKAwMoxe2RN0Shtls178GUOGYmKJg9FShcL+7UsiocCYRAMR2Pxf
         urteg3Kcvf2BVtedqJXvbj0xav+qEORWImui5J64jwmgMXMjnNZ3q/vvp+dfLyxeAlh2
         otVYBS3oHXzz7vnUNWnVoSfsKL2WZoShCCXuYPDoAyfqU4HEki+CXcqbxH0FEkGUNgmt
         i6AAIhX4RjnAGDixu5tph7tPiPTc3nMRYBS5HxhuSbhIOjvCZJrecDCD1IEUhFSXuor0
         BJ+Y2CaD0/K8kY/OL4DzpwX7tL5baRyraZhqHXhpuueVFepFUYPHJ/g4u5HxhlZcCOUH
         5rbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=v1NXB6wxRFohvXJoX8NOegBlamHwcU9rtOLwkpAdV8E=;
        b=gL+lbwXSkUem5UtwNlsN7/vj40ar75dPXOywSggXGrAI1hDriTjMxWSM/iFf2TDiUM
         a4kmtPgMOcCNUrpDDN0zP694uqcsx75Bf0hrh7l4Pvo/aqMXgucajcDZ4dd63a+vYdc9
         mRMCQ3xH2qj+w9m+Q2l5s1kyIN9r6erncrIx6w5LRH+E70HXBELRd/aQtPkXnT84GIvK
         LNRPazaHDCuqdZUcBS8+5/4egCk8LvVGwu6sS6bzYDBjFIQrQAcZLOXxR99qz0Q/2IdO
         5Nha0NT8Tp/h4rgVLPscakDbllPDRsE/Sq7MjrQEKVj3g19sFwVwDx6wS8Gf2Yx3PDsX
         qIiw==
X-Gm-Message-State: ACgBeo1cIZBUlcPjQPutCmQAS2gVsbFeqyjtCJRoC7WDXce9n5L3HnsH
        USaDtmvvJCUmIxmH+vlqIsFxfITLfqc=
X-Google-Smtp-Source: AA6agR4xcun+0LQiqLQQb/H/p8nnMeMQ8d129fBAQksFYt94EVlkuAVY8oY8cNefwuo8279BKU6BAkIKuIo=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2d4:203:4f27:97db:8644:dc82])
 (user=haoluo job=sendgmr) by 2002:a17:902:ef47:b0:16c:60df:3a7c with SMTP id
 e7-20020a170902ef4700b0016c60df3a7cmr8587705plx.9.1659736133709; Fri, 05 Aug
 2022 14:48:53 -0700 (PDT)
Date:   Fri,  5 Aug 2022 14:48:14 -0700
In-Reply-To: <20220805214821.1058337-1-haoluo@google.com>
Message-Id: <20220805214821.1058337-2-haoluo@google.com>
Mime-Version: 1.0
References: <20220805214821.1058337-1-haoluo@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH bpf-next v7 1/8] btf: Add a new kfunc flag which allows to
 mark a function to be sleepable
From:   Hao Luo <haoluo@google.com>
To:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Michal Koutny <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Yosry Ahmed <yosryahmed@google.com>,
        Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

This allows to declare a kfunc as sleepable and prevents its use in
a non sleepable program.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Co-developed-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Hao Luo <haoluo@google.com>
---
 Documentation/bpf/kfuncs.rst | 6 ++++++
 include/linux/btf.h          | 1 +
 kernel/bpf/btf.c             | 9 +++++++++
 3 files changed, 16 insertions(+)

diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
index c0b7dae6dbf5..c8b21de1c772 100644
--- a/Documentation/bpf/kfuncs.rst
+++ b/Documentation/bpf/kfuncs.rst
@@ -146,6 +146,12 @@ that operate (change some property, perform some operation) on an object that
 was obtained using an acquire kfunc. Such kfuncs need an unchanged pointer to
 ensure the integrity of the operation being performed on the expected object.
 
+2.4.6 KF_SLEEPABLE flag
+-----------------------
+
+The KF_SLEEPABLE flag is used for kfuncs that may sleep. Such kfuncs can only
+be called by sleepable BPF programs (BPF_F_SLEEPABLE).
+
 2.5 Registering the kfuncs
 --------------------------
 
diff --git a/include/linux/btf.h b/include/linux/btf.h
index cdb376d53238..976cbdd2981f 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -49,6 +49,7 @@
  * for this case.
  */
 #define KF_TRUSTED_ARGS (1 << 4) /* kfunc only takes trusted pointer arguments */
+#define KF_SLEEPABLE   (1 << 5) /* kfunc may sleep */
 
 struct btf;
 struct btf_member;
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 7e64447659f3..d3e4c86b8fcd 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6175,6 +6175,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 {
 	enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
 	bool rel = false, kptr_get = false, trusted_arg = false;
+	bool sleepable = false;
 	struct bpf_verifier_log *log = &env->log;
 	u32 i, nargs, ref_id, ref_obj_id = 0;
 	bool is_kfunc = btf_is_kernel(btf);
@@ -6212,6 +6213,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 		rel = kfunc_flags & KF_RELEASE;
 		kptr_get = kfunc_flags & KF_KPTR_GET;
 		trusted_arg = kfunc_flags & KF_TRUSTED_ARGS;
+		sleepable = kfunc_flags & KF_SLEEPABLE;
 	}
 
 	/* check that BTF function arguments match actual types that the
@@ -6419,6 +6421,13 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 			func_name);
 		return -EINVAL;
 	}
+
+	if (sleepable && !env->prog->aux->sleepable) {
+		bpf_log(log, "kernel function %s is sleepable but the program is not\n",
+			func_name);
+		return -EINVAL;
+	}
+
 	/* returns argument register number > 0 in case of reference release kfunc */
 	return rel ? ref_regno : 0;
 }
-- 
2.37.1.559.g78731f0fdb-goog

