Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60E2362D50
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 05:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235812AbhDQDeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 23:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235589AbhDQDdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 23:33:52 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E875C06138C;
        Fri, 16 Apr 2021 20:32:38 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id cu16so13014432pjb.4;
        Fri, 16 Apr 2021 20:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=R96Z+ndjC87ZwoTbstAfeoZnXDUN/2F5sFzLTgB48bk=;
        b=IqSZ4YQ1M3Z5ILHVzKlJhhSzkKiqvwDUHgNNXNKagP+GPseBF5hBSrmPboW3lsxj8v
         r0UBW8wOKAqJxh1C1cvgo1AdOYbQsDuAf3XKKxbk/Jn9E5xMsMwYc8rq+WHEZpxVFGD+
         lUquELa+M41wa+OMPIsUPVL7YXlGyzHSIVQReAGEVtWYRRfsogYCwzdijfq83XzGpjoi
         X8f+f28wTvJiVqL/tj49i50X3t1bcWWY2UKo1HW78vOLWo+vxggWyqMO+VhE2zLZrr1+
         QsKsJi71FZvp5JpA/7bV/v0GO7bjpPK5qAsw7MRvN/j9nNl222Ip28mo8HwFvfiT+DC5
         ZCUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=R96Z+ndjC87ZwoTbstAfeoZnXDUN/2F5sFzLTgB48bk=;
        b=ORCeIUSNtgeebB69gaQD0ZdIw/GzDC6K+/pdwhjUyjDbCYGIKHr1NfnWEHjeik8MDy
         EvNn57cyNQZ0jBOW1sN/fYRoGwdGLM6IcoNp8EwUddKGuRyaKtAhNO5DK8gsPOPGo50a
         aHXESC8kNgYVWKKJWa+YXoeJmHozdDcX2UUBS+yG2/ly87WOVT6o/z43fseaWSDZLy2t
         J5CdAbvnYe9ylUreLbg9lps3Xdu8t10g/qkcQUvJx2UVM3xA/uMg/PMpjBpqeoMr5/h0
         CVsvohl8OQUV21eqt0vEQhL25c5qmt3pMN7Gv3B/v5ipp6PNd9cGLyx2fYnZxMYfmjbi
         x8Ng==
X-Gm-Message-State: AOAM530XypthPfacMB5XGW57ycoov2bi6/8RuWuQjBx+lbEqmS9uIu4L
        c+mfYPgAg73TtncBNf9vAAPegIywnfs=
X-Google-Smtp-Source: ABdhPJx0dJ57r534UgbrcRlbYJ+ZdPW+ol1p327mQKoRmMkj/x0Y8+//8XzbtqFYCNsNc8v/Hoc+wg==
X-Received: by 2002:a17:90b:1d92:: with SMTP id pf18mr2851996pjb.71.1618630358048;
        Fri, 16 Apr 2021 20:32:38 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id h1sm6069870pgv.88.2021.04.16.20.32.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Apr 2021 20:32:37 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 08/15] bpf: Introduce fd_idx
Date:   Fri, 16 Apr 2021 20:32:17 -0700
Message-Id: <20210417033224.8063-9-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
References: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
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
index ce3e76ff08cd..068c23f278bc 100644
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
index f5e2511c504e..7b51d56e420b 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2088,7 +2088,7 @@ static bool is_perfmon_prog_type(enum bpf_prog_type prog_type)
 }
 
 /* last field in 'union bpf_attr' used by this command */
-#define	BPF_PROG_LOAD_LAST_FIELD attach_prog_fd
+#define	BPF_PROG_LOAD_LAST_FIELD fd_array
 
 static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 7028fd0f4481..fa853b761f0d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8747,12 +8747,14 @@ static int check_ld_imm(struct bpf_verifier_env *env, struct bpf_insn *insn)
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
@@ -11021,6 +11023,7 @@ static int resolve_pseudo_ldimm64(struct bpf_verifier_env *env)
 			struct bpf_map *map;
 			struct fd f;
 			u64 addr;
+			u32 fd;
 
 			if (i == insn_cnt - 1 || insn[1].code != 0 ||
 			    insn[1].dst_reg != 0 || insn[1].src_reg != 0 ||
@@ -11050,16 +11053,38 @@ static int resolve_pseudo_ldimm64(struct bpf_verifier_env *env)
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
@@ -11074,7 +11099,8 @@ static int resolve_pseudo_ldimm64(struct bpf_verifier_env *env)
 			}
 
 			aux = &env->insn_aux_data[i];
-			if (insn->src_reg == BPF_PSEUDO_MAP_FD) {
+			if (insn[0].src_reg == BPF_PSEUDO_MAP_FD ||
+			    insn[0].src_reg == BPF_PSEUDO_MAP_IDX) {
 				addr = (unsigned long)map;
 			} else {
 				u32 off = insn[1].imm;
@@ -13142,6 +13168,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr)
 		env->insn_aux_data[i].orig_idx = i;
 	env->prog = *prog;
 	env->ops = bpf_verifier_ops[env->prog->type];
+	env->fd_array = make_bpfptr(attr->fd_array, uattr.is_kernel);
 	is_priv = bpf_capable();
 
 	bpf_get_btf_vmlinux();
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index ce3e76ff08cd..068c23f278bc 100644
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

