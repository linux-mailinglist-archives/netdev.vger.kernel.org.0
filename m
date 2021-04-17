Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D215362D51
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 05:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235638AbhDQDeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 23:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235632AbhDQDdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 23:33:52 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B566C061342;
        Fri, 16 Apr 2021 20:32:44 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id g16so6286675pfq.5;
        Fri, 16 Apr 2021 20:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KBk3bK4feaNc3+lvwrD6wznDNxRkOBFpu408+U2igpg=;
        b=l8hCodfFOGMDW1jY9qhs3d3ehGEC/d7KeQ79KBex2W0I/gPJQtLNHTzkNtINfNv+3r
         gaES/lz/jpzhWXMmNya0mRQafoXaUtVvwHieVZxlX75VIHCmZdA1jpZtaaseJF8qctG0
         E7xMGcJPR2B8IvHxxGLyJgUPRxtBjqUxULc+ReTox529Sl5GpDjmv7bvsBotS9X4OvKN
         nv1XChDadMRN2uhJl4ZsQ0danW3BZtabA9Gm04MF2bqw9OsRbUo+1BsIg/VlA99h2jd7
         zwBAaCVS+pQWgxaG+rnv2DWZNho+CkDdmxEN5bjj5N404SvmyFbTzsoyXEfjVnl4eASr
         oPXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KBk3bK4feaNc3+lvwrD6wznDNxRkOBFpu408+U2igpg=;
        b=AF7ofsUGFEZpeCZ5DUht1YFr3wSZKc2RjY+Km0fKj2eheTkdNUSUkuFPY09o0hEFsA
         hBz22iwmJhOMiJDAoXOy8ifhplqwwAZr5S/UG7G0WD82dGaK9p3aUTtcU1FMcJJTKhWe
         p5V9G++TsUgWFb40dCDLKD05+FjJY40gi2kLSdPp22s2jC38loNOBehlHHuMP819HTrE
         gvx98jIffOXJ6Hc+daR54RZkpAdXzJfkMMoQJ7+SkbDnUbX8zv77vf8P8JfpgJsRVC9T
         yvOGp9Tp18AXpyBqEfjyDMy6SKssTAUIwJNhfCltgGK73kcofTDEimDgDDVrvFIRXntA
         iiow==
X-Gm-Message-State: AOAM532+h0KYCGAhFbvdFYaJ20ZzSZleuHiespLUvoU7YoMsGc4x8T3E
        iveVQZFUsOTeAbv54Yk7Vz4=
X-Google-Smtp-Source: ABdhPJxtMG1mATh/nmL1MzTEC2niGJF4DF7sAoEKS2wZPWSiGh81t64IO1exrtSh3BCtML8wMI14Yg==
X-Received: by 2002:a65:590a:: with SMTP id f10mr1887791pgu.358.1618630364012;
        Fri, 16 Apr 2021 20:32:44 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id h1sm6069870pgv.88.2021.04.16.20.32.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Apr 2021 20:32:43 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 12/15] libbpf: Change the order of data and text relocations.
Date:   Fri, 16 Apr 2021 20:32:21 -0700
Message-Id: <20210417033224.8063-13-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
References: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

In order to be able to generate loader program in the later
patches change the order of data and text relocations.
Also improve the test to include data relos.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/lib/bpf/libbpf.c                        | 82 ++++++++++++++-----
 .../selftests/bpf/progs/test_subprogs.c       | 13 +++
 2 files changed, 76 insertions(+), 19 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 17cfc5b66111..083e441d9c5e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6379,11 +6379,15 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
 			insn[0].imm = ext->ksym.kernel_btf_id;
 			break;
 		case RELO_SUBPROG_ADDR:
-			insn[0].src_reg = BPF_PSEUDO_FUNC;
-			/* will be handled as a follow up pass */
+			if (insn[0].src_reg != BPF_PSEUDO_FUNC) {
+				pr_warn("prog '%s': relo #%d: bad insn\n",
+					prog->name, i);
+				return -EINVAL;
+			}
+			/* handled already */
 			break;
 		case RELO_CALL:
-			/* will be handled as a follow up pass */
+			/* handled already */
 			break;
 		default:
 			pr_warn("prog '%s': relo #%d: bad relo type %d\n",
@@ -6552,6 +6556,31 @@ static struct reloc_desc *find_prog_insn_relo(const struct bpf_program *prog, si
 		       sizeof(*prog->reloc_desc), cmp_relo_by_insn_idx);
 }
 
+static int append_subprog_relos(struct bpf_program *main_prog, struct bpf_program *subprog)
+{
+	int new_cnt = main_prog->nr_reloc + subprog->nr_reloc;
+	struct reloc_desc *relos;
+	size_t off = subprog->sub_insn_off;
+	int i;
+
+	if (main_prog == subprog)
+		return 0;
+	relos = libbpf_reallocarray(main_prog->reloc_desc, new_cnt, sizeof(*relos));
+	if (!relos)
+		return -ENOMEM;
+	memcpy(relos + main_prog->nr_reloc, subprog->reloc_desc,
+	       sizeof(*relos) * subprog->nr_reloc);
+
+	for (i = main_prog->nr_reloc; i < new_cnt; i++)
+		relos[i].insn_idx += off;
+	/* After insn_idx adjustment the 'relos' array is still sorted
+	 * by insn_idx and doesn't break bsearch.
+	 */
+	main_prog->reloc_desc = relos;
+	main_prog->nr_reloc = new_cnt;
+	return 0;
+}
+
 static int
 bpf_object__reloc_code(struct bpf_object *obj, struct bpf_program *main_prog,
 		       struct bpf_program *prog)
@@ -6560,12 +6589,21 @@ bpf_object__reloc_code(struct bpf_object *obj, struct bpf_program *main_prog,
 	struct bpf_program *subprog;
 	struct bpf_insn *insns, *insn;
 	struct reloc_desc *relo;
-	int err;
+	int err, i;
 
 	err = reloc_prog_func_and_line_info(obj, main_prog, prog);
 	if (err)
 		return err;
 
+	for (i = 0; i < prog->nr_reloc; i++) {
+		relo = &prog->reloc_desc[i];
+		insn = &main_prog->insns[prog->sub_insn_off + relo->insn_idx];
+
+		if (relo->type == RELO_SUBPROG_ADDR)
+			/* mark the insn, so it becomes insn_is_pseudo_func() */
+			insn[0].src_reg = BPF_PSEUDO_FUNC;
+	}
+
 	for (insn_idx = 0; insn_idx < prog->sec_insn_cnt; insn_idx++) {
 		insn = &main_prog->insns[prog->sub_insn_off + insn_idx];
 		if (!insn_is_subprog_call(insn) && !insn_is_pseudo_func(insn))
@@ -6573,6 +6611,8 @@ bpf_object__reloc_code(struct bpf_object *obj, struct bpf_program *main_prog,
 
 		relo = find_prog_insn_relo(prog, insn_idx);
 		if (relo && relo->type != RELO_CALL && relo->type != RELO_SUBPROG_ADDR) {
+			if (relo->type == RELO_EXTERN_FUNC)
+				continue;
 			pr_warn("prog '%s': unexpected relo for insn #%zu, type %d\n",
 				prog->name, insn_idx, relo->type);
 			return -LIBBPF_ERRNO__RELOC;
@@ -6646,6 +6686,10 @@ bpf_object__reloc_code(struct bpf_object *obj, struct bpf_program *main_prog,
 			pr_debug("prog '%s': added %zu insns from sub-prog '%s'\n",
 				 main_prog->name, subprog->insns_cnt, subprog->name);
 
+			/* The subprog insns are now appended. Append its relos too. */
+			err = append_subprog_relos(main_prog, subprog);
+			if (err)
+				return err;
 			err = bpf_object__reloc_code(obj, main_prog, subprog);
 			if (err)
 				return err;
@@ -6790,23 +6834,11 @@ bpf_object__relocate(struct bpf_object *obj, const char *targ_btf_path)
 			return err;
 		}
 	}
-	/* relocate data references first for all programs and sub-programs,
-	 * as they don't change relative to code locations, so subsequent
-	 * subprogram processing won't need to re-calculate any of them
-	 */
-	for (i = 0; i < obj->nr_programs; i++) {
-		prog = &obj->programs[i];
-		err = bpf_object__relocate_data(obj, prog);
-		if (err) {
-			pr_warn("prog '%s': failed to relocate data references: %d\n",
-				prog->name, err);
-			return err;
-		}
-	}
-	/* now relocate subprogram calls and append used subprograms to main
+	/* relocate subprogram calls and append used subprograms to main
 	 * programs; each copy of subprogram code needs to be relocated
 	 * differently for each main program, because its code location might
-	 * have changed
+	 * have changed.
+	 * Append subprog relos to main programs.
 	 */
 	for (i = 0; i < obj->nr_programs; i++) {
 		prog = &obj->programs[i];
@@ -6823,6 +6855,18 @@ bpf_object__relocate(struct bpf_object *obj, const char *targ_btf_path)
 			return err;
 		}
 	}
+	/* Process data relos for main programs */
+	for (i = 0; i < obj->nr_programs; i++) {
+		prog = &obj->programs[i];
+		if (prog_is_subprog(obj, prog))
+			continue;
+		err = bpf_object__relocate_data(obj, prog);
+		if (err) {
+			pr_warn("prog '%s': failed to relocate data references: %d\n",
+				prog->name, err);
+			return err;
+		}
+	}
 	/* free up relocation descriptors */
 	for (i = 0; i < obj->nr_programs; i++) {
 		prog = &obj->programs[i];
diff --git a/tools/testing/selftests/bpf/progs/test_subprogs.c b/tools/testing/selftests/bpf/progs/test_subprogs.c
index d3c5673c0218..b7c37ca09544 100644
--- a/tools/testing/selftests/bpf/progs/test_subprogs.c
+++ b/tools/testing/selftests/bpf/progs/test_subprogs.c
@@ -4,8 +4,18 @@
 
 const char LICENSE[] SEC("license") = "GPL";
 
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u64);
+} array SEC(".maps");
+
 __noinline int sub1(int x)
 {
+	int key = 0;
+
+	bpf_map_lookup_elem(&array, &key);
 	return x + 1;
 }
 
@@ -23,6 +33,9 @@ static __noinline int sub3(int z)
 
 static __noinline int sub4(int w)
 {
+	int key = 0;
+
+	bpf_map_lookup_elem(&array, &key);
 	return w + sub3(5) + sub1(6);
 }
 
-- 
2.30.2

