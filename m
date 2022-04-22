Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C4F50B4A1
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 12:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446353AbiDVKEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 06:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446367AbiDVKEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 06:04:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FE7541A6;
        Fri, 22 Apr 2022 03:01:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C26A861E25;
        Fri, 22 Apr 2022 10:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE84C385A4;
        Fri, 22 Apr 2022 10:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650621690;
        bh=NUItUtsCwaH8t+rgiyagJdkrcn3JwgnJlI9AIhlyX/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E5vy0r/5ruek8frwintwh371kfseVC78eJCayBE46YwgSBrztGM6UrenjSyocGDV2
         sT99gi5e72Qa1fqGX3B7x7hY1wWHFTRuMv8pUpccDFzMoIbTEifgY476PA0PqV/2G7
         CiJSCyOpo6GPNssBwEoopDPYvJXKGy/imYTrAekjyg/VA95qAb9cq7BFNa8LZi/oxP
         R20XyZD5/sx9jiFY83YThYRbuu9x7mNCnRQMmhYD/e4J+VNIP/CdarSRszr3lS4SuW
         eKfRjR0pZHrh0rP/f69KtrfykqZ3h2IkagyOFDhlvWVK/VxHGGYdfeA1c1A75xFOLF
         sP2F18ns+z5VQ==
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
Subject: [PATCH perf/core 5/5] perf tools: Rework prologue generation code
Date:   Fri, 22 Apr 2022 12:00:25 +0200
Message-Id: <20220422100025.1469207-6-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220422100025.1469207-1-jolsa@kernel.org>
References: <20220422100025.1469207-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

We use bpf_program__set_prep to hook perf callback before program
is loaded and provide new instructions with the prologue.

We workaround this by taking instructions for specific program,
attaching prologue to them and load such new ebpf programs with
prologue using separate bpf_prog_load calls (outside libbpf load
machinery).

Before we can take program instructions, we need libbpf to actually
load it. This way we get the final shape of its instructions (with
all relocations and verifier adjustments).

There's one glitch though.. perf kprobe program already assumes
generated prologue code with proper values in argument registers,
so loading such program directly will fail in the verifier.

That's where 'perfkprobe/' pre-load handler fits in and prepends
the initialization code to the program. Once such program is loaded
we take its instructions, cut off the initialization code and prepend
the prologue.

I know.. sorry ;-)

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/include/bpf/bpf.h                |   2 +-
 tools/perf/tests/bpf-script-example.c       |   2 +-
 tools/perf/tests/bpf-script-test-prologue.c |   2 +-
 tools/perf/util/bpf-loader.c                | 136 +++++++++++++++++---
 4 files changed, 120 insertions(+), 22 deletions(-)

diff --git a/tools/perf/include/bpf/bpf.h b/tools/perf/include/bpf/bpf.h
index b422aeef5339..91869f6fb672 100644
--- a/tools/perf/include/bpf/bpf.h
+++ b/tools/perf/include/bpf/bpf.h
@@ -50,7 +50,7 @@ static void (*bpf_tail_call)(void *ctx, void *map, int index) = (void *)BPF_FUNC
 #define SEC(NAME) __attribute__((section(NAME),  used))
 
 #define probe(function, vars) \
-	SEC(#function "=" #function " " #vars) function
+	SEC("perfkprobe/" #function "=" #function " " #vars) function
 
 #define syscall_enter(name) \
 	SEC("syscalls:sys_enter_" #name) syscall_enter_ ## name
diff --git a/tools/perf/tests/bpf-script-example.c b/tools/perf/tests/bpf-script-example.c
index ab4b98b3165d..56673fa1f30d 100644
--- a/tools/perf/tests/bpf-script-example.c
+++ b/tools/perf/tests/bpf-script-example.c
@@ -32,7 +32,7 @@ struct bpf_map_def SEC("maps") flip_table = {
 	.max_entries = 1,
 };
 
-SEC("func=do_epoll_wait")
+SEC("perfkprobe/func=do_epoll_wait")
 int bpf_func__SyS_epoll_pwait(void *ctx)
 {
 	int ind =0;
diff --git a/tools/perf/tests/bpf-script-test-prologue.c b/tools/perf/tests/bpf-script-test-prologue.c
index bd83d364cf30..00dac5a23938 100644
--- a/tools/perf/tests/bpf-script-test-prologue.c
+++ b/tools/perf/tests/bpf-script-test-prologue.c
@@ -26,7 +26,7 @@
 static void (*bpf_trace_printk)(const char *fmt, int fmt_size, ...) =
 	(void *) 6;
 
-SEC("func=null_lseek file->f_mode offset orig")
+SEC("perfkprobe/func=null_lseek file->f_mode offset orig")
 int bpf_func__null_lseek(void *ctx, int err, unsigned long _f_mode,
 			 unsigned long offset, unsigned long orig)
 {
diff --git a/tools/perf/util/bpf-loader.c b/tools/perf/util/bpf-loader.c
index 92dd8cc18edb..10151da862c8 100644
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
+	int *proglogue_fds;
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
@@ -238,14 +245,31 @@ struct bpf_object *bpf__prepare_load(const char *filename, bool source)
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
+		fd = priv->proglogue_fds[i];
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
+	zfree(&priv->proglogue_fds);
 	zfree(&priv->type_mapping);
 	zfree(&priv->sys_name);
 	zfree(&priv->evt_name);
@@ -480,9 +504,15 @@ static int
 parse_prog_config(const char *config_str, const char **p_main_str,
 		  bool *is_tp, struct perf_probe_event *pev)
 {
+	const char *main_str, *parse_str;
 	int err;
-	const char *main_str = parse_prog_config_kvpair(config_str, pev);
 
+	/* Make sure it's our section with 'perfkprobe/' prefix check. */
+	if (!strstarts(config_str, LIBBPF_SEC_PREFIX))
+		return -EINVAL;
+
+	parse_str = config_str + sizeof(LIBBPF_SEC_PREFIX) - 1;
+	main_str  = parse_prog_config_kvpair(parse_str, pev);
 	if (IS_ERR(main_str))
 		return PTR_ERR(main_str);
 
@@ -608,8 +638,8 @@ static int bpf__prepare_probe(void)
 
 static int
 preproc_gen_prologue(struct bpf_program *prog, int n,
-		     struct bpf_insn *orig_insns, int orig_insns_cnt,
-		     struct bpf_prog_prep_result *res)
+		     const struct bpf_insn *orig_insns, int orig_insns_cnt,
+		     struct bpf_preproc_result *res)
 {
 	struct bpf_prog_priv *priv = program_priv(prog);
 	struct probe_trace_event *tev;
@@ -657,7 +687,6 @@ preproc_gen_prologue(struct bpf_program *prog, int n,
 
 	res->new_insn_ptr = buf;
 	res->new_insn_cnt = prologue_cnt + orig_insns_cnt;
-	res->pfd = NULL;
 	return 0;
 
 errout:
@@ -765,7 +794,7 @@ static int hook_load_preprocessor(struct bpf_program *prog)
 	struct bpf_prog_priv *priv = program_priv(prog);
 	struct perf_probe_event *pev;
 	bool need_prologue = false;
-	int err, i;
+	int i;
 
 	if (IS_ERR_OR_NULL(priv)) {
 		pr_debug("Internal error when hook preprocessor\n");
@@ -803,6 +832,13 @@ static int hook_load_preprocessor(struct bpf_program *prog)
 		return -ENOMEM;
 	}
 
+	priv->proglogue_fds = malloc(sizeof(int) * pev->ntevs);
+	if (!priv->proglogue_fds) {
+		pr_debug("Not enough memory: alloc prologue fds failed\n");
+		return -ENOMEM;
+	}
+	memset(priv->proglogue_fds, -1, sizeof(int) * pev->ntevs);
+
 	priv->type_mapping = malloc(sizeof(int) * pev->ntevs);
 	if (!priv->type_mapping) {
 		pr_debug("Not enough memory: alloc type_mapping failed\n");
@@ -811,13 +847,7 @@ static int hook_load_preprocessor(struct bpf_program *prog)
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
@@ -924,6 +954,77 @@ int bpf__unprobe(struct bpf_object *obj)
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
+		 *   and keep the fd in proglogue_fds
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
+			priv->proglogue_fds[i] = fd;
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
@@ -935,7 +1036,7 @@ int bpf__load(struct bpf_object *obj)
 		pr_debug("bpf: load objects failed: err=%d: (%s)\n", err, bf);
 		return err;
 	}
-	return 0;
+	return bpf_object__load_prologue(obj);
 }
 
 int bpf__foreach_event(struct bpf_object *obj,
@@ -970,13 +1071,10 @@ int bpf__foreach_event(struct bpf_object *obj,
 		for (i = 0; i < pev->ntevs; i++) {
 			tev = &pev->tevs[i];
 
-			if (priv->need_prologue) {
-				int type = priv->type_mapping[i];
-
-				fd = bpf_program__nth_fd(prog, type);
-			} else {
+			if (priv->need_prologue)
+				fd = priv->proglogue_fds[i];
+			else
 				fd = bpf_program__fd(prog);
-			}
 
 			if (fd < 0) {
 				pr_debug("bpf: failed to get file descriptor\n");
-- 
2.35.1

