Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9498220DB4
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 15:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731499AbgGONJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 09:09:09 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29271 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731434AbgGONJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 09:09:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594818545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IKBvJRNk93vwxTBqmwC3ALAbgp1/dbF+UbTGXWDVVb4=;
        b=fW7fhZWrMnygC87QrpQq+41CtdNgIYMNQAy/hEiROSyliBGk8oNce9GPJ0zBAC0rh/djTx
        oavEQXlclVu93UoRRtmgcVpz98csbuuZKSxZFgQITOFffiFx2Dp+g+cuVtyk3hXA4yWqda
        E1FxfMwujzsavnJelM9qZAOKF9z31k8=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-pwqjlZrBNXaW9z8TPSe5jQ-1; Wed, 15 Jul 2020 09:09:03 -0400
X-MC-Unique: pwqjlZrBNXaW9z8TPSe5jQ-1
Received: by mail-qt1-f197.google.com with SMTP id e6so1310349qtb.19
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 06:09:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=IKBvJRNk93vwxTBqmwC3ALAbgp1/dbF+UbTGXWDVVb4=;
        b=gVFnK+w2ax1AaJP8Pmo4DCl5N9Zf7OR4KiyXsbklp6qe8GgeIUH/rCA3y1RUKsYHKB
         fJvKbVnpyye20UHkKxDprKNeMwFvegFJR9uD1n4YkNG8QGNoMG3WB12EMbPewwwVC5Oe
         ZL9VnTPt2MWF+9RyRZvNMdbARnQkESUtQE2+K77EmfG1/02KFmFIx7nY0DbfaestzfuI
         ZIzB0qy/3suFcNtRC4sLQ8UfnIkL+gfWYNDrF9VdaHerUIRBm/+W6b7FSKKHqYHFF1v8
         2Qf0AtpnwNjoxTgfOMvC4lJTjzhR73w5ZeLdHScZrc1+Vs/5CXt0cJ8Bn2upz8HJc2sn
         bBJg==
X-Gm-Message-State: AOAM530bqE5vwVdwRRQ0Evejdu51X4k5LcfmqGEaMZLQGNtsIhb8ICpd
        fLulwIxhGuu7MAgxk/ob8jTi4EXIuu5JxOJZ/VHnzngQhNC7WN5U744ZTTPTruPe2WKM56DUiwP
        u1RGJCcxYAJoZLZGC
X-Received: by 2002:a05:6214:18f2:: with SMTP id ep18mr9225971qvb.96.1594818542912;
        Wed, 15 Jul 2020 06:09:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCm+7phsiw1soBteON/DDKrjdP437N0a7kKFq/wTxHb77pQuHM4Vs2YasYfwjmrsHFzi6gOg==
X-Received: by 2002:a05:6214:18f2:: with SMTP id ep18mr9225935qvb.96.1594818542536;
        Wed, 15 Jul 2020 06:09:02 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id i26sm2472714qkh.14.2020.07.15.06.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 06:09:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6B411180653; Wed, 15 Jul 2020 15:09:00 +0200 (CEST)
Subject: [PATCH bpf-next v2 1/6] bpf: change logging calls from verbose() to
 bpf_log() and use log pointer
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Wed, 15 Jul 2020 15:09:00 +0200
Message-ID: <159481854034.454654.14793846101394162640.stgit@toke.dk>
In-Reply-To: <159481853923.454654.12184603524310603480.stgit@toke.dk>
References: <159481853923.454654.12184603524310603480.stgit@toke.dk>
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
 include/linux/bpf_verifier.h |    2 +-
 kernel/bpf/btf.c             |    6 +++--
 kernel/bpf/verifier.c        |   46 +++++++++++++++++++++---------------------
 4 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c67c88ad35f8..154aab467728 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1314,7 +1314,7 @@ int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog,
 			     struct bpf_reg_state *regs);
 int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
 			  struct bpf_reg_state *reg);
-int btf_check_type_match(struct bpf_verifier_env *env, struct bpf_prog *prog,
+int btf_check_type_match(struct bpf_verifier_log *log, const struct bpf_prog *prog,
 			 struct btf *btf, const struct btf_type *t);
 
 struct bpf_prog *bpf_prog_by_id(u32 id);
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 53c7bd568c5d..f1ee7468ec28 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -347,7 +347,7 @@ static inline bool bpf_verifier_log_full(const struct bpf_verifier_log *log)
 
 static inline bool bpf_verifier_log_needed(const struct bpf_verifier_log *log)
 {
-	return (log->level && log->ubuf && !bpf_verifier_log_full(log)) ||
+	return (log && log->level && log->ubuf && !bpf_verifier_log_full(log)) ||
 		log->level == BPF_LOG_KERNEL;
 }
 
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 03d6d43bb1d6..e9122e260950 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4285,7 +4285,7 @@ static int btf_check_func_type_match(struct bpf_verifier_log *log,
 }
 
 /* Compare BTFs of given program with BTF of target program */
-int btf_check_type_match(struct bpf_verifier_env *env, struct bpf_prog *prog,
+int btf_check_type_match(struct bpf_verifier_log *log, const struct bpf_prog *prog,
 			 struct btf *btf2, const struct btf_type *t2)
 {
 	struct btf *btf1 = prog->aux->btf;
@@ -4293,7 +4293,7 @@ int btf_check_type_match(struct bpf_verifier_env *env, struct bpf_prog *prog,
 	u32 btf_id = 0;
 
 	if (!prog->aux->func_info) {
-		bpf_log(&env->log, "Program extension requires BTF\n");
+		bpf_log(log, "Program extension requires BTF\n");
 		return -EINVAL;
 	}
 
@@ -4305,7 +4305,7 @@ int btf_check_type_match(struct bpf_verifier_env *env, struct bpf_prog *prog,
 	if (!t1 || !btf_type_is_func(t1))
 		return -EFAULT;
 
-	return btf_check_func_type_match(&env->log, btf1, t1, btf2, t2);
+	return btf_check_func_type_match(log, btf1, t1, btf2, t2);
 }
 
 /* Compare BTF of a function with given bpf_reg_state.
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3c1efc9d08fd..6f35b4924b4c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10736,6 +10736,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 	struct bpf_prog *prog = env->prog;
 	bool prog_extension = prog->type == BPF_PROG_TYPE_EXT;
 	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
+	struct bpf_verifier_log *log = &env->log;
 	u32 btf_id = prog->aux->attach_btf_id;
 	const char prefix[] = "btf_trace_";
 	struct btf_func_model fmodel;
@@ -10757,23 +10758,23 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -10785,18 +10786,18 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -10804,7 +10805,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 			prog->expected_attach_type = tgt_prog->expected_attach_type;
 		}
 		if (!tgt_prog->jited) {
-			verbose(env, "Can attach to only JITed progs\n");
+			bpf_log(log, "Can attach to only JITed progs\n");
 			return -EINVAL;
 		}
 		if (tgt_prog->type == prog->type) {
@@ -10812,7 +10813,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 			 * Cannot attach program extension to another extension.
 			 * It's ok to attach fentry/fexit to extension program.
 			 */
-			verbose(env, "Cannot recursively attach\n");
+			bpf_log(log, "Cannot recursively attach\n");
 			return -EINVAL;
 		}
 		if (tgt_prog->type == BPF_PROG_TYPE_TRACING &&
@@ -10834,13 +10835,13 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -10849,17 +10850,17 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -10882,7 +10883,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		return 0;
 	case BPF_TRACE_ITER:
 		if (!btf_type_is_func(t)) {
-			verbose(env, "attach_btf_id %u is not a function\n",
+			bpf_log(log, "attach_btf_id %u is not a function\n",
 				btf_id);
 			return -EINVAL;
 		}
@@ -10893,8 +10894,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		prog->aux->attach_func_proto = t;
 		if (!bpf_iter_prog_supported(prog))
 			return -EINVAL;
-		ret = btf_distill_func_proto(&env->log, btf, t,
-					     tname, &fmodel);
+		ret = btf_distill_func_proto(log, btf, t, tname, &fmodel);
 		return ret;
 	default:
 		if (!prog_extension)
@@ -10906,18 +10906,18 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -10936,7 +10936,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 			prog->aux->attach_func_proto = NULL;
 			t = NULL;
 		}
-		ret = btf_distill_func_proto(&env->log, btf, t,
+		ret = btf_distill_func_proto(log, btf, t,
 					     tname, &tr->func.model);
 		if (ret < 0)
 			goto out;
@@ -10948,7 +10948,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		} else {
 			addr = kallsyms_lookup_name(tname);
 			if (!addr) {
-				verbose(env,
+				bpf_log(log,
 					"The address of function %s cannot be found\n",
 					tname);
 				ret = -ENOENT;
@@ -10959,7 +10959,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		if (prog->expected_attach_type == BPF_MODIFY_RETURN) {
 			ret = check_attach_modify_return(prog, addr);
 			if (ret)
-				verbose(env, "%s() is not modifiable\n",
+				bpf_log(log, "%s() is not modifiable\n",
 					prog->aux->attach_func_name);
 		}
 

