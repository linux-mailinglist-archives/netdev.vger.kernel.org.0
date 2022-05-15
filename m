Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA5CA52750E
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 04:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbiEOCgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 22:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233892AbiEOCfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 22:35:38 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CD0BF60
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 19:35:19 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id gg5-20020a17090b0a0500b001d9852bd129so5057227pjb.9
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 19:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZEXZ/QXFU/CsHogdpQ7ZUfr7HZOPm4+DGygzngWTcUA=;
        b=VzJ/P7BnyJakBf09tKg7be86cJFVoS7xh60Ky83Z8pkc38jrbA7tPJVJDl0Eavb7sy
         6F0n1AOFaVZODO+9LdufUSnZkesvSAeupz5vDNamKzKRiTYHyTYai/WNfIMjDTAPfFNc
         Df5vg2u6DjfW9LoKqgIgpQaHkfgIflGFQUkUGRPCgIruOzPU5oIaRAlLNLehj6bhk8sk
         /DQRFoHI8weERppdosnMt3A10xwHidKLIGP7oJNURDjePFeKujvw6ulliemweAxKJGmQ
         tKuDQylnBRQnE0Vw3efTiKkc99W1cN+ZX4CZpBVRrBxeS97ufLx7uvBUZVh+hsinhp8C
         t4lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZEXZ/QXFU/CsHogdpQ7ZUfr7HZOPm4+DGygzngWTcUA=;
        b=ROz77hKAx1KPK6UnfNF3W1UzvjYZ2LbNhY85w18Gx2t0AseQnpXrDjbPoS5yJs+APQ
         /LD+KQJu0c9NLpSVcwDJ+srTb6qvfjVmDkT8p51KNcVIWCdTHhk3hm8jM4pVq3w6eSGa
         HtFTnP1gny0UhmeWlnl85XZkwyt2evKa76EAQbi4f+b8BnDuahP7pq34onWuRFHZU1t1
         Wva1aYjjDCNX0swFjs2hEoOu7/DoSZKFrNJNAACJIDj/fMu66D8fpY6FBffFehsvfzgl
         3+6PpPLz+boZQ2A+BpoeGsRM0kSmiNvACr7Duc1b3AEiOs32z1/dTXAT7yJndZp/eTNn
         g+CQ==
X-Gm-Message-State: AOAM531PgRukDDFy4A6p9WlMO7CUkrgVfY6ZOvw1QhM/jDxhO4xL3mDU
        cnBHYGnVt/XTmnb1QxzU/7mao0juLAqcEGKH
X-Google-Smtp-Source: ABdhPJzki7EdQw0sGqwb0SP3TzxosU+OOtJIEU8WS5UAu6wm/vCL6t2hRjdQlKKt/jSEjM7YFHBDBuu6oPhFXUWQ
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:902:da8b:b0:15e:aba7:43fe with SMTP
 id j11-20020a170902da8b00b0015eaba743femr11765556plx.9.1652582118569; Sat, 14
 May 2022 19:35:18 -0700 (PDT)
Date:   Sun, 15 May 2022 02:35:01 +0000
In-Reply-To: <20220515023504.1823463-1-yosryahmed@google.com>
Message-Id: <20220515023504.1823463-5-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220515023504.1823463-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [RFC PATCH bpf-next v2 4/7] bpf: add bpf rstat helpers
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>
Cc:     Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org,
        Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf_cgroup_rstat_updated() and bpf_cgroup_rstat_flush() helpers
to enable  bpf programs that collect and output cgroup stats
to communicate with the rstat frameworkto add a cgroup to the rstat
updated tree or trigger an rstat flush before reading stats.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 include/linux/bpf.h            |  2 ++
 include/uapi/linux/bpf.h       | 18 ++++++++++++++++++
 kernel/bpf/helpers.c           | 30 ++++++++++++++++++++++++++++++
 kernel/trace/bpf_trace.c       |  4 ++++
 scripts/bpf_doc.py             |  2 ++
 tools/include/uapi/linux/bpf.h | 18 ++++++++++++++++++
 6 files changed, 74 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5061ccd8b2dc..ca908a731cb4 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2205,6 +2205,8 @@ extern const struct bpf_func_proto bpf_sock_map_update_proto;
 extern const struct bpf_func_proto bpf_sock_hash_update_proto;
 extern const struct bpf_func_proto bpf_get_current_cgroup_id_proto;
 extern const struct bpf_func_proto bpf_get_current_ancestor_cgroup_id_proto;
+extern const struct bpf_func_proto bpf_cgroup_rstat_updated_proto;
+extern const struct bpf_func_proto bpf_cgroup_rstat_flush_proto;
 extern const struct bpf_func_proto bpf_msg_redirect_hash_proto;
 extern const struct bpf_func_proto bpf_msg_redirect_map_proto;
 extern const struct bpf_func_proto bpf_sk_redirect_hash_proto;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 968e3cb02580..022522174286 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5175,6 +5175,22 @@ union bpf_attr {
  * 	Return
  * 		Map value associated to *key* on *cpu*, or **NULL** if no entry
  * 		was found or *cpu* is invalid.
+ *
+ * void bpf_cgroup_rstat_updated(struct cgroup *cgrp)
+ *	Description
+ *		Notify the rstat framework that bpf stats were updated for
+ *		*cgrp* on the current cpu. Directly calls cgroup_rstat_updated
+ *		with the given *cgrp* and the current cpu.
+ *	Return
+ *		0
+ *
+ * void bpf_cgroup_rstat_flush(struct cgroup *cgrp)
+ *	Description
+ *		Collect all per-cpu stats in *cgrp*'s subtree into global
+ *		counters and propagate them upwards. Directly calls
+ *		cgroup_rstat_flush_irqsafe with the given *cgrp*.
+ *	Return
+ *		0
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5373,6 +5389,8 @@ union bpf_attr {
 	FN(ima_file_hash),		\
 	FN(kptr_xchg),			\
 	FN(map_lookup_percpu_elem),     \
+	FN(cgroup_rstat_updated),	\
+	FN(cgroup_rstat_flush),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index d5f104a39092..88ed26cf45e2 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -416,6 +416,36 @@ const struct bpf_func_proto bpf_get_current_ancestor_cgroup_id_proto = {
 	.arg1_type	= ARG_ANYTHING,
 };
 
+BTF_ID_LIST_SINGLE(bpf_cgroup_btf_ids, struct, cgroup)
+
+BPF_CALL_1(bpf_cgroup_rstat_updated, struct cgroup *, cgrp)
+{
+	cgroup_rstat_updated(cgrp, smp_processor_id());
+	return 0;
+}
+
+const struct bpf_func_proto bpf_cgroup_rstat_updated_proto = {
+	.func		= bpf_cgroup_rstat_updated,
+	.gpl_only	= false,
+	.ret_type	= RET_VOID,
+	.arg1_type	= ARG_PTR_TO_BTF_ID,
+	.arg1_btf_id	= &bpf_cgroup_btf_ids[0],
+};
+
+BPF_CALL_1(bpf_cgroup_rstat_flush, struct cgroup *, cgrp)
+{
+	cgroup_rstat_flush_irqsafe(cgrp);
+	return 0;
+}
+
+const struct bpf_func_proto bpf_cgroup_rstat_flush_proto = {
+	.func		= bpf_cgroup_rstat_flush,
+	.gpl_only	= false,
+	.ret_type	= RET_VOID,
+	.arg1_type	= ARG_PTR_TO_BTF_ID,
+	.arg1_btf_id	= &bpf_cgroup_btf_ids[0],
+};
+
 #ifdef CONFIG_CGROUP_BPF
 
 BPF_CALL_2(bpf_get_local_storage, struct bpf_map *, map, u64, flags)
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 7141ca8a1c2d..e5a4f1b6e00d 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1255,6 +1255,10 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_current_cgroup_id_proto;
 	case BPF_FUNC_get_current_ancestor_cgroup_id:
 		return &bpf_get_current_ancestor_cgroup_id_proto;
+	case BPF_FUNC_cgroup_rstat_updated:
+		return &bpf_cgroup_rstat_updated_proto;
+	case BPF_FUNC_cgroup_rstat_flush:
+		return &bpf_cgroup_rstat_flush_proto;
 #endif
 	case BPF_FUNC_send_signal:
 		return &bpf_send_signal_proto;
diff --git a/scripts/bpf_doc.py b/scripts/bpf_doc.py
index 096625242475..9e2b08557a6f 100755
--- a/scripts/bpf_doc.py
+++ b/scripts/bpf_doc.py
@@ -633,6 +633,7 @@ class PrinterHelpers(Printer):
             'struct socket',
             'struct file',
             'struct bpf_timer',
+            'struct cgroup',
     ]
     known_types = {
             '...',
@@ -682,6 +683,7 @@ class PrinterHelpers(Printer):
             'struct socket',
             'struct file',
             'struct bpf_timer',
+            'struct cgroup',
     }
     mapped_types = {
             'u8': '__u8',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 968e3cb02580..022522174286 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5175,6 +5175,22 @@ union bpf_attr {
  * 	Return
  * 		Map value associated to *key* on *cpu*, or **NULL** if no entry
  * 		was found or *cpu* is invalid.
+ *
+ * void bpf_cgroup_rstat_updated(struct cgroup *cgrp)
+ *	Description
+ *		Notify the rstat framework that bpf stats were updated for
+ *		*cgrp* on the current cpu. Directly calls cgroup_rstat_updated
+ *		with the given *cgrp* and the current cpu.
+ *	Return
+ *		0
+ *
+ * void bpf_cgroup_rstat_flush(struct cgroup *cgrp)
+ *	Description
+ *		Collect all per-cpu stats in *cgrp*'s subtree into global
+ *		counters and propagate them upwards. Directly calls
+ *		cgroup_rstat_flush_irqsafe with the given *cgrp*.
+ *	Return
+ *		0
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5373,6 +5389,8 @@ union bpf_attr {
 	FN(ima_file_hash),		\
 	FN(kptr_xchg),			\
 	FN(map_lookup_percpu_elem),     \
+	FN(cgroup_rstat_updated),	\
+	FN(cgroup_rstat_flush),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.36.0.550.gb090851708-goog

