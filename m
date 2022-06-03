Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB8353C75E
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 11:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235054AbiFCJVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 05:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234965AbiFCJVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 05:21:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548DB39BBE;
        Fri,  3 Jun 2022 02:21:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1805FB82291;
        Fri,  3 Jun 2022 09:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B05AC385A9;
        Fri,  3 Jun 2022 09:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654248090;
        bh=pnYGvBVe/Ughz9Z1CO7LvAmeznuNAGmRwoDwFt65xDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pn8yLH2QlXzWyy5lX982zDhexNknE1+C+FcyuCWMnIlPMiyTrJH0b8TeZRRzjmmTm
         uoq2I6k4Ib2ghbsAeyG+pnoRmiFh4cnANCPcTBjl+qvmkE6TAmKc6YMiBiCchCFOuM
         3uWRdeLochMJdmkNGQq8mjgWtuEvkSPVuLNTA5XGL0msLwxulcwQXQuqnJ3craNaw0
         rA317PCfPPseafvArNQccXFbPNehVaBkee6lGgz3Q2wzjvmcBodZDLtCaNn4qSH4v3
         ySvd0fXKIQMtjkWF5yY2fJKGrRJpj+E1Ay1/2qNbtWImROfMHLgWsvUxrFPtHnyMRQ
         FPgcYZwIQMMZg==
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
Subject: [PATCHv3 bpf-next 1/2] perf tools: Register fallback libbpf section handler
Date:   Fri,  3 Jun 2022 11:21:09 +0200
Message-Id: <20220603092110.1294855-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220603092110.1294855-1-jolsa@kernel.org>
References: <20220603092110.1294855-1-jolsa@kernel.org>
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

Perf is using section name to declare special kprobe arguments,
which no longer works with current libbpf, that either requires
certain form of the section name or allows to register custom
handler.

Adding perf support to register 'fallback' section handler to take
care of perf kprobe programs. The fallback means that it handles
any section definition besides the ones that libbpf handles.

The handler serves two purposes:
  - allows perf programs to have special arguments in section name
  - allows perf to use pre-load callback where we can attach init
    code (zeroing all argument registers) to each perf program

The second is essential part of new prologue generation code,
that's coming in following patch.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/bpf-loader.c | 45 ++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/tools/perf/util/bpf-loader.c b/tools/perf/util/bpf-loader.c
index f8ad581ea247..e7992a0eb477 100644
--- a/tools/perf/util/bpf-loader.c
+++ b/tools/perf/util/bpf-loader.c
@@ -86,6 +86,7 @@ bpf_perf_object__next(struct bpf_perf_object *prev)
 	     (perf_obj) = (tmp), (tmp) = bpf_perf_object__next(tmp))
 
 static bool libbpf_initialized;
+static int libbpf_sec_handler;
 
 static int bpf_perf_object__add(struct bpf_object *obj)
 {
@@ -99,12 +100,56 @@ static int bpf_perf_object__add(struct bpf_object *obj)
 	return perf_obj ? 0 : -ENOMEM;
 }
 
+static struct bpf_insn prologue_init_insn[] = {
+	BPF_MOV64_IMM(BPF_REG_2, 0),
+	BPF_MOV64_IMM(BPF_REG_3, 0),
+	BPF_MOV64_IMM(BPF_REG_4, 0),
+	BPF_MOV64_IMM(BPF_REG_5, 0),
+};
+
+static int libbpf_prog_prepare_load_fn(struct bpf_program *prog,
+				       struct bpf_prog_load_opts *opts __maybe_unused,
+				       long cookie __maybe_unused)
+{
+	size_t init_size_cnt = ARRAY_SIZE(prologue_init_insn);
+	size_t orig_insn_cnt, insn_cnt, init_size, orig_size;
+	const struct bpf_insn *orig_insn;
+	struct bpf_insn *insn;
+
+	/* prepend initialization code to program instructions */
+	orig_insn = bpf_program__insns(prog);
+	orig_insn_cnt = bpf_program__insn_cnt(prog);
+	init_size = init_size_cnt * sizeof(*insn);
+	orig_size = orig_insn_cnt * sizeof(*insn);
+
+	insn_cnt = orig_insn_cnt + init_size_cnt;
+	insn = malloc(insn_cnt * sizeof(*insn));
+	if (!insn)
+		return -ENOMEM;
+
+	memcpy(insn, prologue_init_insn, init_size);
+	memcpy((char *) insn + init_size, orig_insn, orig_size);
+	bpf_program__set_insns(prog, insn, insn_cnt);
+	return 0;
+}
+
 static int libbpf_init(void)
 {
+	LIBBPF_OPTS(libbpf_prog_handler_opts, handler_opts,
+		.prog_prepare_load_fn = libbpf_prog_prepare_load_fn,
+	);
+
 	if (libbpf_initialized)
 		return 0;
 
 	libbpf_set_print(libbpf_perf_print);
+	libbpf_sec_handler = libbpf_register_prog_handler(NULL, BPF_PROG_TYPE_KPROBE,
+							  0, &handler_opts);
+	if (libbpf_sec_handler < 0) {
+		pr_debug("bpf: failed to register libbpf section handler: %d\n",
+			 libbpf_sec_handler);
+		return -BPF_LOADER_ERRNO__INTERNAL;
+	}
 	libbpf_initialized = true;
 	return 0;
 }
-- 
2.35.3

