Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E686B3689D0
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 02:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240151AbhDWA1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 20:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240089AbhDWA1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 20:27:37 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A627C06174A;
        Thu, 22 Apr 2021 17:27:00 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id f29so34010690pgm.8;
        Thu, 22 Apr 2021 17:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Qibptvp1QdRzcLKfsHMW9kMV3qlQXrsqklCni5L8B3U=;
        b=r27aM2MJeKgwzNo0FSOi5idGe/kr4M+x6F+gtxlrOa++j/dAzMZ+2AjmXy7UP3raxz
         w+QXpx1m86zybPie97+TSGeVhtzm+cdDsU1sEi+BKKhFea5G1L48akxq9PSVCThLsnkO
         oBeOuNafp1tIxi3tewM1q0CeWCWCBsK4XhCM7m0tMRPsjUlL7yzSdESr/qwVCvFbcqXC
         Oh+KJCIws6CRRzom9mB9dFw/QAYbBwUpZSpq4nNlIJUxSNotPX2o1PQoZKh/fKdXMJIW
         svf6/oj0gVWsPrtgwl5n8sy8tbfjoPxH+iLV4HYCRXOD0pNmBmqcKz/amoJgS+s0Yunx
         q1jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Qibptvp1QdRzcLKfsHMW9kMV3qlQXrsqklCni5L8B3U=;
        b=rvqpi1Uw2l2kKehWa6d6nEgGZE+3DTDQrbXZL4/nlSW/Cayyn4jtw1Seey68wa5yh6
         655E571JyPp0IRTUdJEjnycLb8rWTTQRIbjEE3cQC8hwmRphmObnZraL1lwIwCVPqIIs
         zB/fAuwfI2PrGNxndEd/ENAfHeD3sXnO8cRuqKJeWQVhdoJNaB/eE+GOW7emZo3XYImh
         KTtBlGyUB8RPMMLoqt8jROohzbf48oDEMvhb/kVcvC5quxQtNieuVxhNcl7bmIqypcxp
         s+1iAa7Kp41IVOuSC5D5e9uQDJPcMlXbIDPGD7kdcunDrfO6nnucYuVWlN43kzNI3asj
         jGXA==
X-Gm-Message-State: AOAM532C7Y/B/NKpGE/UzkEHauEtfCyfnV4ETDM5RbTVod2L3pEo8uwb
        g2tKWlL9N+Z983xsD9VdXCw=
X-Google-Smtp-Source: ABdhPJwg8GRKSSFdSJ08f4GAOr41VkMjI9LtTMfVLbgQwTIGfDUjiZ8YvanLfEqvNcDV/k5VU6p7uQ==
X-Received: by 2002:aa7:928b:0:b029:23e:4d59:1a73 with SMTP id j11-20020aa7928b0000b029023e4d591a73mr1221752pfa.45.1619137619644;
        Thu, 22 Apr 2021 17:26:59 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id u12sm6390987pji.45.2021.04.22.17.26.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Apr 2021 17:26:59 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 08/16] bpf: Introduce fd_idx
Date:   Thu, 22 Apr 2021 17:26:38 -0700
Message-Id: <20210423002646.35043-9-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Typical program loading sequence involves creating bpf maps and applying
map FDs into bpf instructions in various places in the bpf program.
This job is done by libbpf that is using compiler generated ELF relocations
to patch certain instruction after maps are created and BTFs are loaded.
The goal of fd_idx is to allow bpf instructions to stay immutable
after compilation. At load time the libbpf would still create maps as usual,
but it wouldn't need to patch instructions. It would store map_fds into
__u32 fd_array[] and would pass that pointer to sys_bpf(BPF_PROG_LOAD).

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf_verifier.h   |  1 +
 include/uapi/linux/bpf.h       | 16 ++++++++----
 kernel/bpf/syscall.c           |  2 +-
 kernel/bpf/verifier.c          | 47 ++++++++++++++++++++++++++--------
 tools/include/uapi/linux/bpf.h | 16 ++++++++----
 5 files changed, 61 insertions(+), 21 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 6023a1367853..a5a3b4b3e804 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -441,6 +441,7 @@ struct bpf_verifier_env {
 	u32 peak_states;
 	/* longest register parentage chain walked for liveness marking */
 	u32 longest_mark_read_walk;
+	bpfptr_t fd_array;
 };
 
 __printf(2, 0) void bpf_verifier_vlog(struct bpf_verifier_log *log,
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c92648f38144..de58a714ed36 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1098,8 +1098,8 @@ enum bpf_link_type {
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * the following extensions:
  *
- * insn[0].src_reg:  BPF_PSEUDO_MAP_FD
- * insn[0].imm:      map fd
+ * insn[0].src_reg:  BPF_PSEUDO_MAP_[FD|IDX]
+ * insn[0].imm:      map fd or fd_idx
  * insn[1].imm:      0
  * insn[0].off:      0
  * insn[1].off:      0
@@ -1107,15 +1107,19 @@ enum bpf_link_type {
  * verifier type:    CONST_PTR_TO_MAP
  */
 #define BPF_PSEUDO_MAP_FD	1
-/* insn[0].src_reg:  BPF_PSEUDO_MAP_VALUE
- * insn[0].imm:      map fd
+#define BPF_PSEUDO_MAP_IDX	5
+
+/* insn[0].src_reg:  BPF_PSEUDO_MAP_[IDX_]VALUE
+ * insn[0].imm:      map fd or fd_idx
  * insn[1].imm:      offset into value
  * insn[0].off:      0
  * insn[1].off:      0
  * ldimm64 rewrite:  address of map[0]+offset
  * verifier type:    PTR_TO_MAP_VALUE
  */
-#define BPF_PSEUDO_MAP_VALUE	2
+#define BPF_PSEUDO_MAP_VALUE		2
+#define BPF_PSEUDO_MAP_IDX_VALUE	6
+
 /* insn[0].src_reg:  BPF_PSEUDO_BTF_ID
  * insn[0].imm:      kernel btd id of VAR
  * insn[1].imm:      0
@@ -1315,6 +1319,8 @@ union bpf_attr {
 			/* or valid module BTF object fd or 0 to attach to vmlinux */
 			__u32		attach_btf_obj_fd;
 		};
+		__u32		:32;		/* pad */
+		__aligned_u64	fd_array;	/* array of FDs */
 	};
 
 	struct { /* anonymous struct used by BPF_OBJ_* commands */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 9b3bc48b1cc6..a81496c5d09f 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2089,7 +2089,7 @@ static bool is_perfmon_prog_type(enum bpf_prog_type prog_type)
 }
 
 /* last field in 'union bpf_attr' used by this command */
-#define	BPF_PROG_LOAD_LAST_FIELD attach_prog_fd
+#define	BPF_PROG_LOAD_LAST_FIELD fd_array
 
 static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 76a18fb1e792..99ca02d7f0e3 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8830,12 +8830,14 @@ static int check_ld_imm(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	mark_reg_known_zero(env, regs, insn->dst_reg);
 	dst_reg->map_ptr = map;
 
-	if (insn->src_reg == BPF_PSEUDO_MAP_VALUE) {
+	if (insn->src_reg == BPF_PSEUDO_MAP_VALUE ||
+	    insn->src_reg == BPF_PSEUDO_MAP_IDX_VALUE) {
 		dst_reg->type = PTR_TO_MAP_VALUE;
 		dst_reg->off = aux->map_off;
 		if (map_value_has_spin_lock(map))
 			dst_reg->id = ++env->id_gen;
-	} else if (insn->src_reg == BPF_PSEUDO_MAP_FD) {
+	} else if (insn->src_reg == BPF_PSEUDO_MAP_FD ||
+		   insn->src_reg == BPF_PSEUDO_MAP_IDX) {
 		dst_reg->type = CONST_PTR_TO_MAP;
 	} else {
 		verbose(env, "bpf verifier is misconfigured\n");
@@ -11104,6 +11106,7 @@ static int resolve_pseudo_ldimm64(struct bpf_verifier_env *env)
 			struct bpf_map *map;
 			struct fd f;
 			u64 addr;
+			u32 fd;
 
 			if (i == insn_cnt - 1 || insn[1].code != 0 ||
 			    insn[1].dst_reg != 0 || insn[1].src_reg != 0 ||
@@ -11133,16 +11136,38 @@ static int resolve_pseudo_ldimm64(struct bpf_verifier_env *env)
 			/* In final convert_pseudo_ld_imm64() step, this is
 			 * converted into regular 64-bit imm load insn.
 			 */
-			if ((insn[0].src_reg != BPF_PSEUDO_MAP_FD &&
-			     insn[0].src_reg != BPF_PSEUDO_MAP_VALUE) ||
-			    (insn[0].src_reg == BPF_PSEUDO_MAP_FD &&
-			     insn[1].imm != 0)) {
-				verbose(env,
-					"unrecognized bpf_ld_imm64 insn\n");
+			switch (insn[0].src_reg) {
+			case BPF_PSEUDO_MAP_VALUE:
+			case BPF_PSEUDO_MAP_IDX_VALUE:
+				break;
+			case BPF_PSEUDO_MAP_FD:
+			case BPF_PSEUDO_MAP_IDX:
+				if (insn[1].imm == 0)
+					break;
+				fallthrough;
+			default:
+				verbose(env, "unrecognized bpf_ld_imm64 insn\n");
 				return -EINVAL;
 			}
 
-			f = fdget(insn[0].imm);
+			switch (insn[0].src_reg) {
+			case BPF_PSEUDO_MAP_IDX_VALUE:
+			case BPF_PSEUDO_MAP_IDX:
+				if (bpfptr_is_null(env->fd_array)) {
+					verbose(env, "fd_idx without fd_array is invalid\n");
+					return -EPROTO;
+				}
+				if (copy_from_bpfptr_offset(&fd, env->fd_array,
+							    insn[0].imm * sizeof(fd),
+							    sizeof(fd)))
+					return -EFAULT;
+				break;
+			default:
+				fd = insn[0].imm;
+				break;
+			}
+
+			f = fdget(fd);
 			map = __bpf_map_get(f);
 			if (IS_ERR(map)) {
 				verbose(env, "fd %d is not pointing to valid bpf_map\n",
@@ -11157,7 +11182,8 @@ static int resolve_pseudo_ldimm64(struct bpf_verifier_env *env)
 			}
 
 			aux = &env->insn_aux_data[i];
-			if (insn->src_reg == BPF_PSEUDO_MAP_FD) {
+			if (insn[0].src_reg == BPF_PSEUDO_MAP_FD ||
+			    insn[0].src_reg == BPF_PSEUDO_MAP_IDX) {
 				addr = (unsigned long)map;
 			} else {
 				u32 off = insn[1].imm;
@@ -13225,6 +13251,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr)
 		env->insn_aux_data[i].orig_idx = i;
 	env->prog = *prog;
 	env->ops = bpf_verifier_ops[env->prog->type];
+	env->fd_array = make_bpfptr(attr->fd_array, uattr.is_kernel);
 	is_priv = bpf_capable();
 
 	bpf_get_btf_vmlinux();
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 0c13016d3d2c..6c8e178d8ffa 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1098,8 +1098,8 @@ enum bpf_link_type {
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * the following extensions:
  *
- * insn[0].src_reg:  BPF_PSEUDO_MAP_FD
- * insn[0].imm:      map fd
+ * insn[0].src_reg:  BPF_PSEUDO_MAP_[FD|IDX]
+ * insn[0].imm:      map fd or fd_idx
  * insn[1].imm:      0
  * insn[0].off:      0
  * insn[1].off:      0
@@ -1107,15 +1107,19 @@ enum bpf_link_type {
  * verifier type:    CONST_PTR_TO_MAP
  */
 #define BPF_PSEUDO_MAP_FD	1
-/* insn[0].src_reg:  BPF_PSEUDO_MAP_VALUE
- * insn[0].imm:      map fd
+#define BPF_PSEUDO_MAP_IDX	5
+
+/* insn[0].src_reg:  BPF_PSEUDO_MAP_[IDX_]VALUE
+ * insn[0].imm:      map fd or fd_idx
  * insn[1].imm:      offset into value
  * insn[0].off:      0
  * insn[1].off:      0
  * ldimm64 rewrite:  address of map[0]+offset
  * verifier type:    PTR_TO_MAP_VALUE
  */
-#define BPF_PSEUDO_MAP_VALUE	2
+#define BPF_PSEUDO_MAP_VALUE		2
+#define BPF_PSEUDO_MAP_IDX_VALUE	6
+
 /* insn[0].src_reg:  BPF_PSEUDO_BTF_ID
  * insn[0].imm:      kernel btd id of VAR
  * insn[1].imm:      0
@@ -1315,6 +1319,8 @@ union bpf_attr {
 			/* or valid module BTF object fd or 0 to attach to vmlinux */
 			__u32		attach_btf_obj_fd;
 		};
+		__u32		:32;		/* pad */
+		__aligned_u64	fd_array;	/* array of FDs */
 	};
 
 	struct { /* anonymous struct used by BPF_OBJ_* commands */
-- 
2.30.2

