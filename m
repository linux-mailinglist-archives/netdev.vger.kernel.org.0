Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE87A3689D5
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 02:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240205AbhDWA1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 20:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240129AbhDWA1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 20:27:40 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6150EC061756;
        Thu, 22 Apr 2021 17:27:05 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id u15so15836638plf.10;
        Thu, 22 Apr 2021 17:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yeosn1THJesuf0T+zt/OVvVSjX4yyzUTZwQ0LJTfO4Y=;
        b=omsA1JYIJAMq+G5TfInZ7KRI+4pn366t45TL1Cw9XmteDnbKe2ZbaOf3GnMHSJ6ohy
         3Krjs/ardfsuXDRds/yz58laWVF+bWRRUfraCbwiBgs1vAwg6KxeF+eLUpETOgHEsZXO
         9hDyct7vFBPCEZhOtS91P3tgV0+R6RNSmfj53c54Wq+q1ja3jdD0fRHVjlKcq3zmGKQH
         LGSYAlPlHeCXipvLWDb03EYjVHyrzfybqYA6oR8TOuuFyEwocYBH7zKRwR2rLXPZwqEu
         4AZAHEa6IsAfo0hEqcyOC4IkECzGAT9/aDX0ZYYrBynyk/OvV7aL59KxGeawoGAz37kT
         AKzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yeosn1THJesuf0T+zt/OVvVSjX4yyzUTZwQ0LJTfO4Y=;
        b=oetQHLK213sQ3CmaXez1k5SkNu2IIqLGORT4jbyTzOXRMLyRUjSOqLMZStJdOmjgf1
         jqsOofvSq6IKZKHxGy6kY6mnxtk6+LLoGdXtvUYHJAnd/jmieQXgdKbkTMigWfoZv3cu
         L/udQiZAw5UPFmuHvP/tHAyMaT9c9xmZMHTS0AKp6uYpvLBbcQ8HByCRT3odiCQ4TV2v
         +OITX1bzpQ32fr/9TTatCbmXdhEplxbdRnc90M59djGZajud6zXRHANy1FSuUNSEt62B
         Zg0H9byJqiPoKrpjBXHqQ8kvUFP+aEEyTJZQi6xRSqsOBNi+MzROa0qHcpLN9XGXuzqB
         JxdA==
X-Gm-Message-State: AOAM530fUg3TlW33brRhWLM1yQyy9C86Qw1QdrBWAxAsQEHvoVFJWQjz
        f7Pbibv1cvBNt1VyttxTq6Y=
X-Google-Smtp-Source: ABdhPJzGz8vGliiTP1SLMSMowZyV5i0lsMR3EYVOQ8KMKS+sQBG5TmPnR26IC8X9s/uTqOGAHrKD8Q==
X-Received: by 2002:a17:902:6907:b029:ea:d1e8:b80b with SMTP id j7-20020a1709026907b02900ead1e8b80bmr1413503plk.41.1619137624980;
        Thu, 22 Apr 2021 17:27:04 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id u12sm6390987pji.45.2021.04.22.17.27.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Apr 2021 17:27:04 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 12/16] libbpf: Change the order of data and text relocations.
Date:   Thu, 22 Apr 2021 17:26:42 -0700
Message-Id: <20210423002646.35043-13-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

In order to be able to generate loader program in the later
patches change the order of data and text relocations.
Also improve the test to include data relos.

If the kernel supports "FD array" the map_fd relocations can be processed
before text relos since generated loader program won't need to manually
patch ld_imm64 insns with map_fd.
But ksym and kfunc relocations can only be processed after all calls
are relocated, since loader program will consist of a sequence
of calls to bpf_btf_find_by_name_kind() followed by patching of btf_id
and btf_obj_fd into corresponding ld_imm64 insns. The locations of those
ld_imm64 insns are specified in relocations.
Hence process all data relocations (maps, ksym, kfunc) together after call relos.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/lib/bpf/libbpf.c                        | 86 +++++++++++++++----
 .../selftests/bpf/progs/test_subprogs.c       | 13 +++
 2 files changed, 80 insertions(+), 19 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 17cfc5b66111..c73a85b97ca5 100644
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
@@ -6560,18 +6589,32 @@ bpf_object__reloc_code(struct bpf_object *obj, struct bpf_program *main_prog,
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
 			continue;
 
 		relo = find_prog_insn_relo(prog, insn_idx);
+		if (relo && relo->type == RELO_EXTERN_FUNC)
+			/* kfunc relocations will be handled later
+			 * in bpf_object__relocate_data()
+			 */
+			continue;
 		if (relo && relo->type != RELO_CALL && relo->type != RELO_SUBPROG_ADDR) {
 			pr_warn("prog '%s': unexpected relo for insn #%zu, type %d\n",
 				prog->name, insn_idx, relo->type);
@@ -6646,6 +6689,10 @@ bpf_object__reloc_code(struct bpf_object *obj, struct bpf_program *main_prog,
 			pr_debug("prog '%s': added %zu insns from sub-prog '%s'\n",
 				 main_prog->name, subprog->insns_cnt, subprog->name);
 
+			/* The subprog insns are now appended. Append its relos too. */
+			err = append_subprog_relos(main_prog, subprog);
+			if (err)
+				return err;
 			err = bpf_object__reloc_code(obj, main_prog, subprog);
 			if (err)
 				return err;
@@ -6790,23 +6837,12 @@ bpf_object__relocate(struct bpf_object *obj, const char *targ_btf_path)
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
+	 * Append subprog relos to main programs to allow data relos to be
+	 * processed after text is completely relocated.
 	 */
 	for (i = 0; i < obj->nr_programs; i++) {
 		prog = &obj->programs[i];
@@ -6823,6 +6859,18 @@ bpf_object__relocate(struct bpf_object *obj, const char *targ_btf_path)
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

