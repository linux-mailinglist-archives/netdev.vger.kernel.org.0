Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7CE269199
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgINQcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:32:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49281 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726479AbgINQNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 12:13:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600100009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MNKGvmvinnY3ygZadj39mUBYZRk0cN1ua12KTMr1Qm4=;
        b=Gpc6paeTZ/63baFBBaFmQVmYFuu6DoeBt8tPSsf001CIgEMO0XHc7+4WAvaLBVyv5aJM5M
        Gxw4IswTXk40gnAuFeYyVk+rRkNTlPlXJ9yR96Vl4ShzfMRNv6XkVKZINST4AlQL/wj6Tp
        Adlt5G47bt51U+kY1j3agOBjt6A+998=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-bUQJ23XaMJiVQC1VUPE4YQ-1; Mon, 14 Sep 2020 12:13:27 -0400
X-MC-Unique: bUQJ23XaMJiVQC1VUPE4YQ-1
Received: by mail-wm1-f71.google.com with SMTP id d22so177088wmd.6
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 09:13:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=MNKGvmvinnY3ygZadj39mUBYZRk0cN1ua12KTMr1Qm4=;
        b=VcIFO8iXqLMemlrTSPekwlVs6UQQLF/qcU1E9tDqn8E2ZAc5EEeQrO1j+lfBkW2Vcd
         DZbbDbV0z3m815BTvPSNrMQ2r3Dk6lZPuWeEzO3m7mVPbZQTf0ZpKWf1q+cRlVYxFz2+
         4FqUry9Utv2Q+tGSw4oi9NfXFhrDYlC82MebVTUC2zzDAwQeC/o7WRbZ0UOoXpgfXvKx
         ff76je5IDQF6LWtMlX7OQNJLRWK3HTUT5UyQ1vjNAPYgytBLAgX8NeW/5DJMLN0IyK23
         jU02RrBy03SKZi0/7m444z05GoDU50NK+PdL81QXC1bMh0hUQ1Ps+npZtuaKfYjgqu/x
         uaog==
X-Gm-Message-State: AOAM530Rtk6OonW60E1wN9C1oOvV8uZRhxWvdu/+XldB3cpANcq6HBbW
        fbXCg0W8l+KEsz8TeA1yQf6UtMrzdPkZldglDGwYq4krc/bvjpYLqfB1xkyDolkrO/Ip+GqlLrg
        tYqcFMAC/QZqO8C86
X-Received: by 2002:a7b:ca56:: with SMTP id m22mr163911wml.12.1600100005834;
        Mon, 14 Sep 2020 09:13:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKLJRmlaKHQ0xTntyfodYvC1RDu3j8/fbwYF1uhcpzQPw2O+gWWoU7rT+lbcO+DgAokY12cg==
X-Received: by 2002:a7b:ca56:: with SMTP id m22mr163870wml.12.1600100005445;
        Mon, 14 Sep 2020 09:13:25 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id t1sm18715359wmi.16.2020.09.14.09.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 09:13:24 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EAE431829CC; Mon, 14 Sep 2020 18:13:23 +0200 (CEST)
Subject: [PATCH bpf-next v4 1/8] bpf: change logging calls from verbose() to
 bpf_log() and use log pointer
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:13:23 +0200
Message-ID: <160010000386.80898.7368764705942215616.stgit@toke.dk>
In-Reply-To: <160010000272.80898.13117015273092905112.stgit@toke.dk>
References: <160010000272.80898.13117015273092905112.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

In preparation for moving code around, change a bunch of references to
env->log (and the verbose() logging helper) to use bpf_log() and a direct
pointer to struct bpf_verifier_log. While we're touching the function
signature, mark the 'prog' argument to bpf_check_type_match() as const.

Also enhance the bpf_verifier_log_needed() check to handle NULL pointers
for the log struct so we can re-use the code with logging disabled.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf.h          |    2 +-
 include/linux/bpf_verifier.h |    5 +++-
 kernel/bpf/btf.c             |    6 +++--
 kernel/bpf/verifier.c        |   48 +++++++++++++++++++++---------------------
 4 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c6d9f2c444f4..5ad4a935a24e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1394,7 +1394,7 @@ int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog,
 			     struct bpf_reg_state *regs);
 int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
 			  struct bpf_reg_state *reg);
-int btf_check_type_match(struct bpf_verifier_env *env, struct bpf_prog *prog,
+int btf_check_type_match(struct bpf_verifier_log *log, const struct bpf_prog *prog,
 			 struct btf *btf, const struct btf_type *t);
 
 struct bpf_prog *bpf_prog_by_id(u32 id);
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 53c7bd568c5d..20009e766805 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -347,8 +347,9 @@ static inline bool bpf_verifier_log_full(const struct bpf_verifier_log *log)
 
 static inline bool bpf_verifier_log_needed(const struct bpf_verifier_log *log)
 {
-	return (log->level && log->ubuf && !bpf_verifier_log_full(log)) ||
-		log->level == BPF_LOG_KERNEL;
+	return log &&
+		((log->level && log->ubuf && !bpf_verifier_log_full(log)) ||
+		 log->level == BPF_LOG_KERNEL);
 }
 
 #define BPF_MAX_SUBPROGS 256
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index f9ac6935ab3c..2ace56c99c36 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4401,7 +4401,7 @@ static int btf_check_func_type_match(struct bpf_verifier_log *log,
 }
 
 /* Compare BTFs of given program with BTF of target program */
-int btf_check_type_match(struct bpf_verifier_env *env, struct bpf_prog *prog,
+int btf_check_type_match(struct bpf_verifier_log *log, const struct bpf_prog *prog,
 			 struct btf *btf2, const struct btf_type *t2)
 {
 	struct btf *btf1 = prog->aux->btf;
@@ -4409,7 +4409,7 @@ int btf_check_type_match(struct bpf_verifier_env *env, struct bpf_prog *prog,
 	u32 btf_id = 0;
 
 	if (!prog->aux->func_info) {
-		bpf_log(&env->log, "Program extension requires BTF\n");
+		bpf_log(log, "Program extension requires BTF\n");
 		return -EINVAL;
 	}
 
@@ -4421,7 +4421,7 @@ int btf_check_type_match(struct bpf_verifier_env *env, struct bpf_prog *prog,
 	if (!t1 || !btf_type_is_func(t1))
 		return -EFAULT;
 
-	return btf_check_func_type_match(&env->log, btf1, t1, btf2, t2);
+	return btf_check_func_type_match(log, btf1, t1, btf2, t2);
 }
 
 /* Compare BTF of a function with given bpf_reg_state.
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 814bc6c1ad16..0be7a187fb7f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11043,6 +11043,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 	struct bpf_prog *prog = env->prog;
 	bool prog_extension = prog->type == BPF_PROG_TYPE_EXT;
 	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
+	struct bpf_verifier_log *log = &env->log;
 	u32 btf_id = prog->aux->attach_btf_id;
 	const char prefix[] = "btf_trace_";
 	struct btf_func_model fmodel;
@@ -11070,23 +11071,23 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		return 0;
 
 	if (!btf_id) {
-		verbose(env, "Tracing programs must provide btf_id\n");
+		bpf_log(log, "Tracing programs must provide btf_id\n");
 		return -EINVAL;
 	}
 	btf = bpf_prog_get_target_btf(prog);
 	if (!btf) {
-		verbose(env,
+		bpf_log(log,
 			"FENTRY/FEXIT program can only be attached to another program annotated with BTF\n");
 		return -EINVAL;
 	}
 	t = btf_type_by_id(btf, btf_id);
 	if (!t) {
-		verbose(env, "attach_btf_id %u is invalid\n", btf_id);
+		bpf_log(log, "attach_btf_id %u is invalid\n", btf_id);
 		return -EINVAL;
 	}
 	tname = btf_name_by_offset(btf, t->name_off);
 	if (!tname) {
-		verbose(env, "attach_btf_id %u doesn't have a name\n", btf_id);
+		bpf_log(log, "attach_btf_id %u doesn't have a name\n", btf_id);
 		return -EINVAL;
 	}
 	if (tgt_prog) {
@@ -11098,18 +11099,18 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 				break;
 			}
 		if (subprog == -1) {
-			verbose(env, "Subprog %s doesn't exist\n", tname);
+			bpf_log(log, "Subprog %s doesn't exist\n", tname);
 			return -EINVAL;
 		}
 		conservative = aux->func_info_aux[subprog].unreliable;
 		if (prog_extension) {
 			if (conservative) {
-				verbose(env,
+				bpf_log(log,
 					"Cannot replace static functions\n");
 				return -EINVAL;
 			}
 			if (!prog->jit_requested) {
-				verbose(env,
+				bpf_log(log,
 					"Extension programs should be JITed\n");
 				return -EINVAL;
 			}
@@ -11117,7 +11118,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 			prog->expected_attach_type = tgt_prog->expected_attach_type;
 		}
 		if (!tgt_prog->jited) {
-			verbose(env, "Can attach to only JITed progs\n");
+			bpf_log(log, "Can attach to only JITed progs\n");
 			return -EINVAL;
 		}
 		if (tgt_prog->type == prog->type) {
@@ -11125,7 +11126,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 			 * Cannot attach program extension to another extension.
 			 * It's ok to attach fentry/fexit to extension program.
 			 */
-			verbose(env, "Cannot recursively attach\n");
+			bpf_log(log, "Cannot recursively attach\n");
 			return -EINVAL;
 		}
 		if (tgt_prog->type == BPF_PROG_TYPE_TRACING &&
@@ -11147,13 +11148,13 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 			 * reasonable stack size. Hence extending fentry is not
 			 * allowed.
 			 */
-			verbose(env, "Cannot extend fentry/fexit\n");
+			bpf_log(log, "Cannot extend fentry/fexit\n");
 			return -EINVAL;
 		}
 		key = ((u64)aux->id) << 32 | btf_id;
 	} else {
 		if (prog_extension) {
-			verbose(env, "Cannot replace kernel functions\n");
+			bpf_log(log, "Cannot replace kernel functions\n");
 			return -EINVAL;
 		}
 		key = btf_id;
@@ -11162,17 +11163,17 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 	switch (prog->expected_attach_type) {
 	case BPF_TRACE_RAW_TP:
 		if (tgt_prog) {
-			verbose(env,
+			bpf_log(log,
 				"Only FENTRY/FEXIT progs are attachable to another BPF prog\n");
 			return -EINVAL;
 		}
 		if (!btf_type_is_typedef(t)) {
-			verbose(env, "attach_btf_id %u is not a typedef\n",
+			bpf_log(log, "attach_btf_id %u is not a typedef\n",
 				btf_id);
 			return -EINVAL;
 		}
 		if (strncmp(prefix, tname, sizeof(prefix) - 1)) {
-			verbose(env, "attach_btf_id %u points to wrong type name %s\n",
+			bpf_log(log, "attach_btf_id %u points to wrong type name %s\n",
 				btf_id, tname);
 			return -EINVAL;
 		}
@@ -11195,7 +11196,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		return 0;
 	case BPF_TRACE_ITER:
 		if (!btf_type_is_func(t)) {
-			verbose(env, "attach_btf_id %u is not a function\n",
+			bpf_log(log, "attach_btf_id %u is not a function\n",
 				btf_id);
 			return -EINVAL;
 		}
@@ -11206,8 +11207,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		prog->aux->attach_func_proto = t;
 		if (!bpf_iter_prog_supported(prog))
 			return -EINVAL;
-		ret = btf_distill_func_proto(&env->log, btf, t,
-					     tname, &fmodel);
+		ret = btf_distill_func_proto(log, btf, t, tname, &fmodel);
 		return ret;
 	default:
 		if (!prog_extension)
@@ -11219,18 +11219,18 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 	case BPF_TRACE_FEXIT:
 		prog->aux->attach_func_name = tname;
 		if (prog->type == BPF_PROG_TYPE_LSM) {
-			ret = bpf_lsm_verify_prog(&env->log, prog);
+			ret = bpf_lsm_verify_prog(log, prog);
 			if (ret < 0)
 				return ret;
 		}
 
 		if (!btf_type_is_func(t)) {
-			verbose(env, "attach_btf_id %u is not a function\n",
+			bpf_log(log, "attach_btf_id %u is not a function\n",
 				btf_id);
 			return -EINVAL;
 		}
 		if (prog_extension &&
-		    btf_check_type_match(env, prog, btf, t))
+		    btf_check_type_match(log, prog, btf, t))
 			return -EINVAL;
 		t = btf_type_by_id(btf, t->type);
 		if (!btf_type_is_func_proto(t))
@@ -11249,7 +11249,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 			prog->aux->attach_func_proto = NULL;
 			t = NULL;
 		}
-		ret = btf_distill_func_proto(&env->log, btf, t,
+		ret = btf_distill_func_proto(log, btf, t,
 					     tname, &tr->func.model);
 		if (ret < 0)
 			goto out;
@@ -11261,7 +11261,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		} else {
 			addr = kallsyms_lookup_name(tname);
 			if (!addr) {
-				verbose(env,
+				bpf_log(log,
 					"The address of function %s cannot be found\n",
 					tname);
 				ret = -ENOENT;
@@ -11291,12 +11291,12 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 				break;
 			}
 			if (ret)
-				verbose(env, "%s is not sleepable\n",
+				bpf_log(log, "%s is not sleepable\n",
 					prog->aux->attach_func_name);
 		} else if (prog->expected_attach_type == BPF_MODIFY_RETURN) {
 			ret = check_attach_modify_return(prog, addr);
 			if (ret)
-				verbose(env, "%s() is not modifiable\n",
+				bpf_log(log, "%s() is not modifiable\n",
 					prog->aux->attach_func_name);
 		}
 		if (ret)

