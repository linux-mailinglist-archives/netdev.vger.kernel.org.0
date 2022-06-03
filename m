Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD4453D2EA
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 22:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348602AbiFCUpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 16:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346929AbiFCUpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 16:45:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4DDF5B8A0;
        Fri,  3 Jun 2022 13:45:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77C6BB82480;
        Fri,  3 Jun 2022 20:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1722C385A9;
        Fri,  3 Jun 2022 20:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654289141;
        bh=LLldoFXaGiOz4bO9jBQcNShDWrJjO5EVbO2QNsys1J8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MmoTsQn8cpUP5hs7j4C5EvfFrbrAHEjo/k/SEOoZ9dZtadhBrG5cKKGjhXjZR4o3h
         /w7iEJmlnIqux69kfozdcAtxKj6oNoB722ke9lKl7FXz5PSZogJEUAmy2SCPxk5Uf1
         W6+hZFsHQRGIONYjXY6vXPopnX7b14SXx9TC6Gf8cNh29/GK6/Gj+mQTEUJHht1lfv
         20VcLXPvW1FD+hCfHGonJW15lbooL05wzALA3gTrD3s3JSHN7C34EtrsrF/8nds1Ie
         xQ/DmGAdVCQ04fs54qiR+Y0skJuQ87dPjIeGcgPk1FM1iLj7S3GtbPWqi6q3dduFRb
         bdK6LfhnhHJgA==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     linux-perf-users@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Ian Rogers <irogers@google.com>
Subject: [PATCHv4 bpf-next 2/2] perf tools: Rework prologue generation code
Date:   Fri,  3 Jun 2022 22:45:09 +0200
Message-Id: <20220603204509.15044-3-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220603204509.15044-1-jolsa@kernel.org>
References: <20220603204509.15044-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some functions we use for bpf prologue generation are going to be
deprecated. This change reworks current code not to use them.

We need to replace following functions/struct:
   bpf_program__set_prep
   bpf_program__nth_fd
   struct bpf_prog_prep_result

Currently we use bpf_program__set_prep to hook perf callback before
program is loaded and provide new instructions with the prologue.

We replace this function/ality by taking instructions for specific
program, attaching prologue to them and load such new ebpf programs
with prologue using separate bpf_prog_load calls (outside libbpf
load machinery).

Before we can take and use program instructions, we need libbpf to
actually load it. This way we get the final shape of its instructions
with all relocations and verifier adjustments).

There's one glitch though.. perf kprobe program already assumes
generated prologue code with proper values in argument registers,
so loading such program directly will fail in the verifier.

That's where the fallback pre-load handler fits in and prepends
the initialization code to the program. Once such program is loaded
we take its instructions, cut off the initialization code and prepend
the prologue.

I know.. sorry ;-)

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/bpf-loader.c | 128 ++++++++++++++++++++++++++++++-----
 1 file changed, 110 insertions(+), 18 deletions(-)

diff --git a/tools/perf/util/bpf-loader.c b/tools/perf/util/bpf-loader.c
index e7992a0eb477..30d0e688beec 100644
--- a/tools/perf/util/bpf-loader.c
+++ b/tools/perf/util/bpf-loader.c
@@ -9,6 +9,7 @@
 #include <linux/bpf.h>
 #include <bpf/libbpf.h>
 #include <bpf/bpf.h>
+#include <linux/filter.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
@@ -49,6 +50,7 @@ struct bpf_prog_priv {
 	struct bpf_insn *insns_buf;
 	int nr_types;
 	int *type_mapping;
+	int *prologue_fds;
 };
 
 struct bpf_perf_object {
@@ -56,6 +58,11 @@ struct bpf_perf_object {
 	struct bpf_object *obj;
 };
 
+struct bpf_preproc_result {
+	struct bpf_insn *new_insn_ptr;
+	int new_insn_cnt;
+};
+
 static LIST_HEAD(bpf_objects_list);
 static struct hashmap *bpf_program_hash;
 static struct hashmap *bpf_map_hash;
@@ -233,14 +240,31 @@ struct bpf_object *bpf__prepare_load(const char *filename, bool source)
 	return obj;
 }
 
+static void close_prologue_programs(struct bpf_prog_priv *priv)
+{
+	struct perf_probe_event *pev;
+	int i, fd;
+
+	if (!priv->need_prologue)
+		return;
+	pev = &priv->pev;
+	for (i = 0; i < pev->ntevs; i++) {
+		fd = priv->prologue_fds[i];
+		if (fd != -1)
+			close(fd);
+	}
+}
+
 static void
 clear_prog_priv(const struct bpf_program *prog __maybe_unused,
 		void *_priv)
 {
 	struct bpf_prog_priv *priv = _priv;
 
+	close_prologue_programs(priv);
 	cleanup_perf_probe_events(&priv->pev, 1);
 	zfree(&priv->insns_buf);
+	zfree(&priv->prologue_fds);
 	zfree(&priv->type_mapping);
 	zfree(&priv->sys_name);
 	zfree(&priv->evt_name);
@@ -603,8 +627,8 @@ static int bpf__prepare_probe(void)
 
 static int
 preproc_gen_prologue(struct bpf_program *prog, int n,
-		     struct bpf_insn *orig_insns, int orig_insns_cnt,
-		     struct bpf_prog_prep_result *res)
+		     const struct bpf_insn *orig_insns, int orig_insns_cnt,
+		     struct bpf_preproc_result *res)
 {
 	struct bpf_prog_priv *priv = program_priv(prog);
 	struct probe_trace_event *tev;
@@ -652,7 +676,6 @@ preproc_gen_prologue(struct bpf_program *prog, int n,
 
 	res->new_insn_ptr = buf;
 	res->new_insn_cnt = prologue_cnt + orig_insns_cnt;
-	res->pfd = NULL;
 	return 0;
 
 errout:
@@ -760,7 +783,7 @@ static int hook_load_preprocessor(struct bpf_program *prog)
 	struct bpf_prog_priv *priv = program_priv(prog);
 	struct perf_probe_event *pev;
 	bool need_prologue = false;
-	int err, i;
+	int i;
 
 	if (IS_ERR_OR_NULL(priv)) {
 		pr_debug("Internal error when hook preprocessor\n");
@@ -798,6 +821,13 @@ static int hook_load_preprocessor(struct bpf_program *prog)
 		return -ENOMEM;
 	}
 
+	priv->prologue_fds = malloc(sizeof(int) * pev->ntevs);
+	if (!priv->prologue_fds) {
+		pr_debug("Not enough memory: alloc prologue fds failed\n");
+		return -ENOMEM;
+	}
+	memset(priv->prologue_fds, -1, sizeof(int) * pev->ntevs);
+
 	priv->type_mapping = malloc(sizeof(int) * pev->ntevs);
 	if (!priv->type_mapping) {
 		pr_debug("Not enough memory: alloc type_mapping failed\n");
@@ -806,13 +836,7 @@ static int hook_load_preprocessor(struct bpf_program *prog)
 	memset(priv->type_mapping, -1,
 	       sizeof(int) * pev->ntevs);
 
-	err = map_prologue(pev, priv->type_mapping, &priv->nr_types);
-	if (err)
-		return err;
-
-	err = bpf_program__set_prep(prog, priv->nr_types,
-				    preproc_gen_prologue);
-	return err;
+	return map_prologue(pev, priv->type_mapping, &priv->nr_types);
 }
 
 int bpf__probe(struct bpf_object *obj)
@@ -919,6 +943,77 @@ int bpf__unprobe(struct bpf_object *obj)
 	return ret;
 }
 
+static int bpf_object__load_prologue(struct bpf_object *obj)
+{
+	int init_cnt = ARRAY_SIZE(prologue_init_insn);
+	const struct bpf_insn *orig_insns;
+	struct bpf_preproc_result res;
+	struct perf_probe_event *pev;
+	struct bpf_program *prog;
+	int orig_insns_cnt;
+
+	bpf_object__for_each_program(prog, obj) {
+		struct bpf_prog_priv *priv = program_priv(prog);
+		int err, i, fd;
+
+		if (IS_ERR_OR_NULL(priv)) {
+			pr_debug("bpf: failed to get private field\n");
+			return -BPF_LOADER_ERRNO__INTERNAL;
+		}
+
+		if (!priv->need_prologue)
+			continue;
+
+		/*
+		 * For each program that needs prologue we do following:
+		 *
+		 * - take its current instructions and use them
+		 *   to generate the new code with prologue
+		 * - load new instructions with bpf_prog_load
+		 *   and keep the fd in prologue_fds
+		 * - new fd will be used in bpf__foreach_event
+		 *   to connect this program with perf evsel
+		 */
+		orig_insns = bpf_program__insns(prog);
+		orig_insns_cnt = bpf_program__insn_cnt(prog);
+
+		pev = &priv->pev;
+		for (i = 0; i < pev->ntevs; i++) {
+			/*
+			 * Skipping artificall prologue_init_insn instructions
+			 * (init_cnt), so the prologue can be generated instead
+			 * of them.
+			 */
+			err = preproc_gen_prologue(prog, i,
+						   orig_insns + init_cnt,
+						   orig_insns_cnt - init_cnt,
+						   &res);
+			if (err)
+				return err;
+
+			fd = bpf_prog_load(bpf_program__get_type(prog),
+					   bpf_program__name(prog), "GPL",
+					   res.new_insn_ptr,
+					   res.new_insn_cnt, NULL);
+			if (fd < 0) {
+				char bf[128];
+
+				libbpf_strerror(-errno, bf, sizeof(bf));
+				pr_debug("bpf: load objects with prologue failed: err=%d: (%s)\n",
+					 -errno, bf);
+				return -errno;
+			}
+			priv->prologue_fds[i] = fd;
+		}
+		/*
+		 * We no longer need the original program,
+		 * we can unload it.
+		 */
+		bpf_program__unload(prog);
+	}
+	return 0;
+}
+
 int bpf__load(struct bpf_object *obj)
 {
 	int err;
@@ -930,7 +1025,7 @@ int bpf__load(struct bpf_object *obj)
 		pr_debug("bpf: load objects failed: err=%d: (%s)\n", err, bf);
 		return err;
 	}
-	return 0;
+	return bpf_object__load_prologue(obj);
 }
 
 int bpf__foreach_event(struct bpf_object *obj,
@@ -965,13 +1060,10 @@ int bpf__foreach_event(struct bpf_object *obj,
 		for (i = 0; i < pev->ntevs; i++) {
 			tev = &pev->tevs[i];
 
-			if (priv->need_prologue) {
-				int type = priv->type_mapping[i];
-
-				fd = bpf_program__nth_fd(prog, type);
-			} else {
+			if (priv->need_prologue)
+				fd = priv->prologue_fds[i];
+			else
 				fd = bpf_program__fd(prog);
-			}
 
 			if (fd < 0) {
 				pr_debug("bpf: failed to get file descriptor\n");
-- 
2.35.3

