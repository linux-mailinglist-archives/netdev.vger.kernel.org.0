Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51267520F00
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 09:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236271AbiEJHvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 03:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234014AbiEJHvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 03:51:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087A518C582;
        Tue, 10 May 2022 00:47:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E24660C11;
        Tue, 10 May 2022 07:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E14C385C9;
        Tue, 10 May 2022 07:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652168838;
        bh=G2fb7PblCjCawCg9BEx1U6t/qNzr4r9GSumb8avo1wQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gvDxfQJoZ1ErEEIJTvzZ1dSFKhxZL4Qc07p3bvZvhYKmKcEoNyi505Mt2HiCO6cyv
         Qdcvr/mrQGlA1EnDEt7pTLqs7jYKLtEf+HQ6ygcKCLGzHB654u1gSlMOcg4BZbPh+z
         kOCNADdO+4XWxP4YYTbVXqTuh6DWXnOd80jO6sHMi+JVdB1QxuQDNm1oaalL5K1xHa
         qZM3oRjboaNarPxT0L5fxG56WJjG/hxu3wDB5GjTYlGyV9PKZvRpSzxqgeQGJHRz78
         iI1m3r+VfQBYq0WLnOCfcDwI0itnAjwoYgpQBwmXPLyfXbfx/6OtGOkJlxcySyhnVi
         VyBO8Bh8BE47w==
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
Subject: [PATCHv2 bpf-next 1/3] libbpf: Add bpf_program__set_insns function
Date:   Tue, 10 May 2022 09:46:57 +0200
Message-Id: <20220510074659.2557731-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220510074659.2557731-1-jolsa@kernel.org>
References: <20220510074659.2557731-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding bpf_program__set_insns that allows to set new instructions
for program.

This is a very advanced libbpf API and users need to know what
they are doing. This should be used from prog_prepare_load_fn
callback only.

We can have changed instructions after calling prog_prepare_load_fn
callback, reloading them.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/libbpf.c   | 22 ++++++++++++++++++++++
 tools/lib/bpf/libbpf.h   | 18 ++++++++++++++++++
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 41 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 15117b9a4d1e..7c17ab9f99ca 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6862,6 +6862,8 @@ static int bpf_object_load_prog_instance(struct bpf_object *obj, struct bpf_prog
 				prog->name, err);
 			return err;
 		}
+		insns = prog->insns;
+		insns_cnt = prog->insns_cnt;
 	}
 
 	if (obj->gen_loader) {
@@ -8790,6 +8792,26 @@ size_t bpf_program__insn_cnt(const struct bpf_program *prog)
 	return prog->insns_cnt;
 }
 
+int bpf_program__set_insns(struct bpf_program *prog,
+			   struct bpf_insn *new_insns, size_t new_insn_cnt)
+{
+	struct bpf_insn *insns;
+
+	if (prog->obj->loaded)
+		return -EBUSY;
+
+	insns = libbpf_reallocarray(prog->insns, new_insn_cnt, sizeof(*insns));
+	if (!insns) {
+		pr_warn("prog '%s': failed to realloc prog code\n", prog->name);
+		return -ENOMEM;
+	}
+	memcpy(insns, new_insns, new_insn_cnt * sizeof(*insns));
+
+	prog->insns = insns;
+	prog->insns_cnt = new_insn_cnt;
+	return 0;
+}
+
 int bpf_program__set_prep(struct bpf_program *prog, int nr_instances,
 			  bpf_program_prep_t prep)
 {
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 114b1f6f73a5..5f94459db751 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -323,6 +323,24 @@ struct bpf_insn;
  * different.
  */
 LIBBPF_API const struct bpf_insn *bpf_program__insns(const struct bpf_program *prog);
+
+/**
+ * @brief **bpf_program__set_insns()** can set BPF program's underlying
+ * BPF instructions.
+ *
+ * WARNING: This is a very advanced libbpf API and users need to know
+ * what they are doing. This should be used from prog_prepare_load_fn
+ * callback only.
+ *
+ * @param prog BPF program for which to return instructions
+ * @param new_insns a pointer to an array of BPF instructions
+ * @param new_insn_cnt number of `struct bpf_insn`'s that form
+ * specified BPF program
+ * @return 0, on success; negative error code, otherwise
+ */
+LIBBPF_API int bpf_program__set_insns(struct bpf_program *prog,
+				      struct bpf_insn *new_insns, size_t new_insn_cnt);
+
 /**
  * @brief **bpf_program__insn_cnt()** returns number of `struct bpf_insn`'s
  * that form specified BPF program.
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index b5bc84039407..9eb14ce152dc 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -448,6 +448,7 @@ LIBBPF_0.8.0 {
 		bpf_object__open_subskeleton;
 		bpf_program__attach_kprobe_multi_opts;
 		bpf_program__attach_usdt;
+		bpf_program__set_insns;
 		libbpf_register_prog_handler;
 		libbpf_unregister_prog_handler;
 } LIBBPF_0.7.0;
-- 
2.35.3

