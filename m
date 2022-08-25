Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4165A1C89
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 00:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243611AbiHYWjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 18:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243517AbiHYWjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 18:39:44 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4292C6531
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 15:39:41 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3360c0f0583so363227817b3.2
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 15:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc;
        bh=E1Am1KOOqd+kcYCTrbE5pakRnbluUytnJ7ZikmHUQEk=;
        b=ls21BEDUWTx+LgGb5RZC0+PaSAYeoORZUDVJPCu7TsWkS5oZvNAU+PXiwfyf78TBqi
         EA1lsRoQj9jm6l8rT1012SzxebJFLp9uWJL5qSaWQoOCu7HJKFoU4BuAlENJRPPdxt59
         zz9/92TXwnbAvyPvtL5XlFs+8kbDmy6kPiN+KXMbCKqL0OzBkUchSmM1EOILSRTY+f61
         s5YQMgxQk9ts9GB46m7v5cTVUYSXBJydCVV4wK5YqHsRuVCHqDgug5hI7vYyh6+1Wnin
         hJXK6DsMi5qAwEKJvq5sWGBHE7QSS55uEAEZr+MePu5HtElQSS/NH/ZbB4l/h5UZqO86
         ENDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc;
        bh=E1Am1KOOqd+kcYCTrbE5pakRnbluUytnJ7ZikmHUQEk=;
        b=BECyQ3MvBgSOcdoqKE+6nBJt1sR4V5maCv1kVmIdvDsRJqqYm/AtSYR59T0gO7DrE0
         zsveFDx+yBxGr1SQ6EFMeYecTHg9y+jVaGOTohmnD9eFT3LpbNB2Z7n1/EXBvk3SFrq6
         CsDmUaxLYxZari8yUKgWpCmrrTabtqPS29egImS3PpO8YpsTQX+Oq9KNSOF2RsCLNvWt
         ofpym0Mnm8nf79Q9qgQIfHEmSbHiVdXc/ksx3WQTadyBXNFmpe1mJ1Mh12na8jpW06QN
         lFAvlnj9sgSz/4Af0xj/Xe6VrOmkhsCk7vZG5B7FNX2mc1mFew5IdDplBGmH35cjc9E7
         x9zw==
X-Gm-Message-State: ACgBeo2nAVgBUeeUC0VlOztbaDzdH2pO1Uc7QylvMXmmCIdJliQKRRu8
        IS4lDEOdXhFHQHlbVoH0tvqesBlSRr8=
X-Google-Smtp-Source: AA6agR6pzgkeD3CTaUIwnfCuZ3DNZ6LH4bPUI/fm7qI/X4/4Aal3IQbcbYSERly4tr0uMjl5jWiaTUbh3ks=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2d4:203:2c4f:653f:78b3:2b5b])
 (user=haoluo job=sendgmr) by 2002:a81:4c0d:0:b0:335:ecff:edd5 with SMTP id
 z13-20020a814c0d000000b00335ecffedd5mr6374984ywa.133.1661467181140; Thu, 25
 Aug 2022 15:39:41 -0700 (PDT)
Date:   Thu, 25 Aug 2022 15:39:36 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220825223936.1865810-1-haoluo@google.com>
Subject: [PATCH bpf-next v2] bpf: Add CGROUP prefix to cgroup_iter_order
From:   Hao Luo <haoluo@google.com>
To:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Yosry Ahmed <yosryahmed@google.com>,
        Hao Luo <haoluo@google.com>
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

bpf_cgroup_iter_order is globally visible but the entries do not have
CGROUP prefix. As requested by Andrii, put a CGROUP in the names
in bpf_cgroup_iter_order.

This patch fixes two previous commits: one introduced the API and
the other uses the API in bpf selftest (that is, the selftest
cgroup_hierarchical_stats).

I tested this patch via the following command:

  test_progs -t cgroup,iter,btf_dump

Fixes: d4ccaf58a847 ("bpf: Introduce cgroup iter")
Fixes: 88886309d2e8 ("selftests/bpf: add a selftest for cgroup hierarchical stats collection")
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Hao Luo <haoluo@google.com>
---
 include/uapi/linux/bpf.h                      | 10 +++---
 kernel/bpf/cgroup_iter.c                      | 32 +++++++++----------
 tools/include/uapi/linux/bpf.h                | 10 +++---
 .../selftests/bpf/prog_tests/btf_dump.c       |  2 +-
 .../prog_tests/cgroup_hierarchical_stats.c    |  2 +-
 .../selftests/bpf/prog_tests/cgroup_iter.c    | 10 +++---
 6 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 0f61f09f467a..bdf4bc6d8d6b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -88,11 +88,11 @@ struct bpf_cgroup_storage_key {
 };
 
 enum bpf_cgroup_iter_order {
-	BPF_ITER_ORDER_UNSPEC = 0,
-	BPF_ITER_SELF_ONLY,		/* process only a single object. */
-	BPF_ITER_DESCENDANTS_PRE,	/* walk descendants in pre-order. */
-	BPF_ITER_DESCENDANTS_POST,	/* walk descendants in post-order. */
-	BPF_ITER_ANCESTORS_UP,		/* walk ancestors upward. */
+	BPF_CGROUP_ITER_ORDER_UNSPEC = 0,
+	BPF_CGROUP_ITER_SELF_ONLY,		/* process only a single object. */
+	BPF_CGROUP_ITER_DESCENDANTS_PRE,	/* walk descendants in pre-order. */
+	BPF_CGROUP_ITER_DESCENDANTS_POST,	/* walk descendants in post-order. */
+	BPF_CGROUP_ITER_ANCESTORS_UP,		/* walk ancestors upward. */
 };
 
 union bpf_iter_link_info {
diff --git a/kernel/bpf/cgroup_iter.c b/kernel/bpf/cgroup_iter.c
index cf6d763a57d5..c69bce2f4403 100644
--- a/kernel/bpf/cgroup_iter.c
+++ b/kernel/bpf/cgroup_iter.c
@@ -74,13 +74,13 @@ static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
 	++*pos;
 	p->terminate = false;
 	p->visited_all = false;
-	if (p->order == BPF_ITER_DESCENDANTS_PRE)
+	if (p->order == BPF_CGROUP_ITER_DESCENDANTS_PRE)
 		return css_next_descendant_pre(NULL, p->start_css);
-	else if (p->order == BPF_ITER_DESCENDANTS_POST)
+	else if (p->order == BPF_CGROUP_ITER_DESCENDANTS_POST)
 		return css_next_descendant_post(NULL, p->start_css);
-	else if (p->order == BPF_ITER_ANCESTORS_UP)
+	else if (p->order == BPF_CGROUP_ITER_ANCESTORS_UP)
 		return p->start_css;
-	else /* BPF_ITER_SELF_ONLY */
+	else /* BPF_CGROUP_ITER_SELF_ONLY */
 		return p->start_css;
 }
 
@@ -109,13 +109,13 @@ static void *cgroup_iter_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	if (p->terminate)
 		return NULL;
 
-	if (p->order == BPF_ITER_DESCENDANTS_PRE)
+	if (p->order == BPF_CGROUP_ITER_DESCENDANTS_PRE)
 		return css_next_descendant_pre(curr, p->start_css);
-	else if (p->order == BPF_ITER_DESCENDANTS_POST)
+	else if (p->order == BPF_CGROUP_ITER_DESCENDANTS_POST)
 		return css_next_descendant_post(curr, p->start_css);
-	else if (p->order == BPF_ITER_ANCESTORS_UP)
+	else if (p->order == BPF_CGROUP_ITER_ANCESTORS_UP)
 		return curr->parent;
-	else  /* BPF_ITER_SELF_ONLY */
+	else  /* BPF_CGROUP_ITER_SELF_ONLY */
 		return NULL;
 }
 
@@ -188,10 +188,10 @@ static int bpf_iter_attach_cgroup(struct bpf_prog *prog,
 	int order = linfo->cgroup.order;
 	struct cgroup *cgrp;
 
-	if (order != BPF_ITER_DESCENDANTS_PRE &&
-	    order != BPF_ITER_DESCENDANTS_POST &&
-	    order != BPF_ITER_ANCESTORS_UP &&
-	    order != BPF_ITER_SELF_ONLY)
+	if (order != BPF_CGROUP_ITER_DESCENDANTS_PRE &&
+	    order != BPF_CGROUP_ITER_DESCENDANTS_POST &&
+	    order != BPF_CGROUP_ITER_ANCESTORS_UP &&
+	    order != BPF_CGROUP_ITER_SELF_ONLY)
 		return -EINVAL;
 
 	if (fd && id)
@@ -239,13 +239,13 @@ static void bpf_iter_cgroup_show_fdinfo(const struct bpf_iter_aux_info *aux,
 	kfree(buf);
 
 show_order:
-	if (aux->cgroup.order == BPF_ITER_DESCENDANTS_PRE)
+	if (aux->cgroup.order == BPF_CGROUP_ITER_DESCENDANTS_PRE)
 		seq_puts(seq, "order: descendants_pre\n");
-	else if (aux->cgroup.order == BPF_ITER_DESCENDANTS_POST)
+	else if (aux->cgroup.order == BPF_CGROUP_ITER_DESCENDANTS_POST)
 		seq_puts(seq, "order: descendants_post\n");
-	else if (aux->cgroup.order == BPF_ITER_ANCESTORS_UP)
+	else if (aux->cgroup.order == BPF_CGROUP_ITER_ANCESTORS_UP)
 		seq_puts(seq, "order: ancestors_up\n");
-	else /* BPF_ITER_SELF_ONLY */
+	else /* BPF_CGROUP_ITER_SELF_ONLY */
 		seq_puts(seq, "order: self_only\n");
 }
 
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 5056cef2112f..92f7387e378a 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -88,11 +88,11 @@ struct bpf_cgroup_storage_key {
 };
 
 enum bpf_cgroup_iter_order {
-	BPF_ITER_ORDER_UNSPEC = 0,
-	BPF_ITER_SELF_ONLY,		/* process only a single object. */
-	BPF_ITER_DESCENDANTS_PRE,	/* walk descendants in pre-order. */
-	BPF_ITER_DESCENDANTS_POST,	/* walk descendants in post-order. */
-	BPF_ITER_ANCESTORS_UP,		/* walk ancestors upward. */
+	BPF_CGROUP_ITER_ORDER_UNSPEC = 0,
+	BPF_CGROUP_ITER_SELF_ONLY,		/* process only a single object. */
+	BPF_CGROUP_ITER_DESCENDANTS_PRE,	/* walk descendants in pre-order. */
+	BPF_CGROUP_ITER_DESCENDANTS_POST,	/* walk descendants in post-order. */
+	BPF_CGROUP_ITER_ANCESTORS_UP,		/* walk ancestors upward. */
 };
 
 union bpf_iter_link_info {
diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
index a1bae92be1fc..7b5bbe21b549 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
@@ -764,7 +764,7 @@ static void test_btf_dump_struct_data(struct btf *btf, struct btf_dump *d,
 
 	/* union with nested struct */
 	TEST_BTF_DUMP_DATA(btf, d, "union", str, union bpf_iter_link_info, BTF_F_COMPACT,
-			   "(union bpf_iter_link_info){.map = (struct){.map_fd = (__u32)1,},.cgroup = (struct){.order = (enum bpf_cgroup_iter_order)BPF_ITER_SELF_ONLY,.cgroup_fd = (__u32)1,},}",
+			   "(union bpf_iter_link_info){.map = (struct){.map_fd = (__u32)1,},.cgroup = (struct){.order = (enum bpf_cgroup_iter_order)BPF_CGROUP_ITER_SELF_ONLY,.cgroup_fd = (__u32)1,},}",
 			   { .cgroup = { .order = 1, .cgroup_fd = 1, }});
 
 	/* struct skb with nested structs/unions; because type output is so
diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c b/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
index 101a6d70b863..bed1661596f7 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
@@ -275,7 +275,7 @@ static int setup_cgroup_iter(struct cgroup_hierarchical_stats *obj,
 	 * traverse one cgroup, so set the traversal order to "self".
 	 */
 	linfo.cgroup.cgroup_fd = cgroup_fd;
-	linfo.cgroup.order = BPF_ITER_SELF_ONLY;
+	linfo.cgroup.order = BPF_CGROUP_ITER_SELF_ONLY;
 	opts.link_info = &linfo;
 	opts.link_info_len = sizeof(linfo);
 	link = bpf_program__attach_iter(obj->progs.dump_vmscan, &opts);
diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
index 38958c37b9ce..c4a2adb38da1 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
@@ -134,7 +134,7 @@ static void test_walk_preorder(struct cgroup_iter *skel)
 		 cg_id[PARENT], cg_id[CHILD1], cg_id[CHILD2]);
 
 	read_from_cgroup_iter(skel->progs.cgroup_id_printer, cg_fd[PARENT],
-			      BPF_ITER_DESCENDANTS_PRE, "preorder");
+			      BPF_CGROUP_ITER_DESCENDANTS_PRE, "preorder");
 }
 
 /* Postorder walk prints child and parent in order. */
@@ -145,7 +145,7 @@ static void test_walk_postorder(struct cgroup_iter *skel)
 		 cg_id[CHILD1], cg_id[CHILD2], cg_id[PARENT]);
 
 	read_from_cgroup_iter(skel->progs.cgroup_id_printer, cg_fd[PARENT],
-			      BPF_ITER_DESCENDANTS_POST, "postorder");
+			      BPF_CGROUP_ITER_DESCENDANTS_POST, "postorder");
 }
 
 /* Walking parents prints parent and then root. */
@@ -159,7 +159,7 @@ static void test_walk_ancestors_up(struct cgroup_iter *skel)
 		 cg_id[PARENT], cg_id[ROOT]);
 
 	read_from_cgroup_iter(skel->progs.cgroup_id_printer, cg_fd[PARENT],
-			      BPF_ITER_ANCESTORS_UP, "ancestors_up");
+			      BPF_CGROUP_ITER_ANCESTORS_UP, "ancestors_up");
 
 	skel->bss->terminal_cgroup = 0;
 }
@@ -174,7 +174,7 @@ static void test_early_termination(struct cgroup_iter *skel)
 		 PROLOGUE "%8llu\n" EPILOGUE, cg_id[PARENT]);
 
 	read_from_cgroup_iter(skel->progs.cgroup_id_printer, cg_fd[PARENT],
-			      BPF_ITER_DESCENDANTS_PRE, "early_termination");
+			      BPF_CGROUP_ITER_DESCENDANTS_PRE, "early_termination");
 
 	skel->bss->terminate_early = 0;
 }
@@ -186,7 +186,7 @@ static void test_walk_self_only(struct cgroup_iter *skel)
 		 PROLOGUE "%8llu\n" EPILOGUE, cg_id[PARENT]);
 
 	read_from_cgroup_iter(skel->progs.cgroup_id_printer, cg_fd[PARENT],
-			      BPF_ITER_SELF_ONLY, "self_only");
+			      BPF_CGROUP_ITER_SELF_ONLY, "self_only");
 }
 
 void test_cgroup_iter(void)
-- 
2.37.2.672.g94769d06f0-goog

