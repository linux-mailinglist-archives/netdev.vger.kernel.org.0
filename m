Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13E6350B48B
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 12:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446340AbiDVKDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 06:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348202AbiDVKDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 06:03:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C5253B4E;
        Fri, 22 Apr 2022 03:00:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C687A61E0D;
        Fri, 22 Apr 2022 10:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75BBC385A0;
        Fri, 22 Apr 2022 10:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650621643;
        bh=eUbVKBGrvVUxVF2TsSLPPb4Ds3rqV3aCUYt+UJyghLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hxBz3l2kxMglAVT+iU0pp5Y2nD3XzeuClYC534Ajn4Tgchx/dczxyZdXHPtBUeIFM
         f9FYWVuoOP9k87y7qR6ijHRmisrB0ZC7UzdesQ4LNuLLmNfZezR0wze2bBtccDBVfc
         PoKXaONvj0OTiH2O1L4UF6tsUyvB8yxYFUP4kIjXIBz3BdcnzAhdK2FELPSbwW+QIW
         LPPkEZQgLGk769n2CAqWXB726G9tGpTo7g18no1zrl3EPyEGS1tZqwOPT5LEA7SXlw
         g+QeWU6Okq8fMz2JB72/1w6iHC4+wkcVFdKzfky2nP6KKzR63lCa0Bn22n5Rz+XRIp
         Soyu4RhrjtOfQ==
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
Subject: [PATCH perf/core 1/5] libbpf: Add bpf_program__set_insns function
Date:   Fri, 22 Apr 2022 12:00:21 +0200
Message-Id: <20220422100025.1469207-2-jolsa@kernel.org>
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

Adding bpf_program__set_insns that allows to set new
instructions for program.

Also moving bpf_program__attach_kprobe_multi_opts on
the proper name sorted place in map file.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/libbpf.c   |  8 ++++++++
 tools/lib/bpf/libbpf.h   | 12 ++++++++++++
 tools/lib/bpf/libbpf.map |  3 ++-
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 809fe209cdcc..284790d81c1b 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8457,6 +8457,14 @@ size_t bpf_program__insn_cnt(const struct bpf_program *prog)
 	return prog->insns_cnt;
 }
 
+void bpf_program__set_insns(struct bpf_program *prog,
+			    struct bpf_insn *insns, size_t insns_cnt)
+{
+	free(prog->insns);
+	prog->insns = insns;
+	prog->insns_cnt = insns_cnt;
+}
+
 int bpf_program__set_prep(struct bpf_program *prog, int nr_instances,
 			  bpf_program_prep_t prep)
 {
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 05dde85e19a6..b31ad58d335f 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -323,6 +323,18 @@ struct bpf_insn;
  * different.
  */
 LIBBPF_API const struct bpf_insn *bpf_program__insns(const struct bpf_program *prog);
+
+/**
+ * @brief **bpf_program__set_insns()** can set BPF program's underlying
+ * BPF instructions.
+ * @param prog BPF program for which to return instructions
+ * @param insn a pointer to an array of BPF instructions
+ * @param insns_cnt number of `struct bpf_insn`'s that form
+ * specified BPF program
+ */
+LIBBPF_API void bpf_program__set_insns(struct bpf_program *prog,
+				       struct bpf_insn *insns, size_t insns_cnt);
+
 /**
  * @brief **bpf_program__insn_cnt()** returns number of `struct bpf_insn`'s
  * that form specified BPF program.
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index dd35ee58bfaa..afa10d24ab41 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -444,7 +444,8 @@ LIBBPF_0.8.0 {
 	global:
 		bpf_object__destroy_subskeleton;
 		bpf_object__open_subskeleton;
+		bpf_program__attach_kprobe_multi_opts;
+		bpf_program__set_insns;
 		libbpf_register_prog_handler;
 		libbpf_unregister_prog_handler;
-		bpf_program__attach_kprobe_multi_opts;
 } LIBBPF_0.7.0;
-- 
2.35.1

