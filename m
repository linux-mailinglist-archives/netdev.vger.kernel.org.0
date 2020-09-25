Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF94627935F
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 23:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729641AbgIYVZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 17:25:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21635 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726980AbgIYVZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 17:25:09 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601069107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AJoCga+d2pa8PzHdU8MWvbXaemgsNi0pnkA3tC56uxI=;
        b=Jl42+Lg9xoUPxRSA9iymwg8DXWfVp56qPSOUx3huuqG70bIhWuNW2b1br1oFMh0EA9uC8y
        zLRYAfHNupKLdrZVRusFfrvHxPM+t1qRjpyX2zFXru0RFkqkUVRM6mr29Fr+gV01Nq9ezj
        JvEHoKazRVy12OmKKnqPNufpRH4TGiY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-RPhCA4H6MwuuS-iDxFMg6A-1; Fri, 25 Sep 2020 17:25:05 -0400
X-MC-Unique: RPhCA4H6MwuuS-iDxFMg6A-1
Received: by mail-wm1-f70.google.com with SMTP id l15so116916wmh.9
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 14:25:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=AJoCga+d2pa8PzHdU8MWvbXaemgsNi0pnkA3tC56uxI=;
        b=sSfAXFSDv89MJcbrVlrHjrbCx+x9dp4mNIj64yDtfWFCTHLjmM5MNIMUiJbDb7z5mg
         EotycV5CE91V+f/C5DBcrqb5GF2XtHdWTk/amrbOXtjb8xI2XmHU5cz+zItBwavF9QIY
         L2W/m8wgaJW4gVkEXaW+zPL/+s29J3G6wVC+JYJimLKkWosEqLUBIAfg38+dpzE9r9qg
         aFkSF03SOMTUf7qDi0TFvtLm4e2Nxze1YpPgt3LlbeiObfkw0Zs4jp9kAUjeI5soXdmM
         mbbKklFAkIqQ1lxGJ61UKv2CxpwRbvE36hjXdCcMbkCMjMk/dM/EC1TZJLfGdMVYaASm
         aQvw==
X-Gm-Message-State: AOAM532MUH+6j/IeI0YJlZmUS8Z6LIE9h9Gpvei17SNDL43L3pbmd0cS
        6xXMeF71Ih8F5SQHAdUVxvBOsuHpZ/yy7ia30kqlua4nDJz3m8JH6A9UJstQlMJepeLfQKJUmxY
        A5x5Cc8TvNPJ9DL2m
X-Received: by 2002:adf:e686:: with SMTP id r6mr6502736wrm.295.1601069103687;
        Fri, 25 Sep 2020 14:25:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfHYcdem5cRBaV/T9YnV6SkBST2MoYlJVcnUdCf8oWFF4fc5ea7BiUqyxjky9VeOuxAuMDrg==
X-Received: by 2002:adf:e686:: with SMTP id r6mr6502692wrm.295.1601069103117;
        Fri, 25 Sep 2020 14:25:03 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id k84sm330233wmf.6.2020.09.25.14.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 14:25:02 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BE283183C5B; Fri, 25 Sep 2020 23:25:01 +0200 (CEST)
Subject: [PATCH bpf-next v9 02/11] bpf: change logging calls from verbose() to
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
Date:   Fri, 25 Sep 2020 23:25:01 +0200
Message-ID: <160106910173.27725.4810010834227930133.stgit@toke.dk>
In-Reply-To: <160106909952.27725.8383447127582216829.stgit@toke.dk>
References: <160106909952.27725.8383447127582216829.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
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

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf.h          |    2 +-
 include/linux/bpf_verifier.h |    5 +++-
 kernel/bpf/btf.c             |    6 +++--
 kernel/bpf/verifier.c        |   50 +++++++++++++++++++++---------------------
 4 files changed, 32 insertions(+), 31 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index fc5c901c7542..1f9e7c22cc7e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1402,7 +1402,7 @@ int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog,
 			     struct bpf_reg_state *regs);
 int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
 			  struct bpf_reg_state *reg);
-int btf_check_type_match(struct bpf_verifier_env *env, struct bpf_prog *prog,
+int btf_check_type_match(struct bpf_verifier_log *log, const struct bpf_prog *prog,
 			 struct btf *btf, const struct btf_type *t);
 
 struct bpf_prog *bpf_prog_by_id(u32 id);
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 2bb48a2c4d08..7bc9276c4ef4 100644
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
index 5d3c36e13139..868c03a24d0a 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4388,7 +4388,7 @@ static int btf_check_func_type_match(struct bpf_verifier_log *log,
 }
 
 /* Compare BTFs of given program with BTF of target program */
-int btf_check_type_match(struct bpf_verifier_env *env, struct bpf_prog *prog,
+int btf_check_type_match(struct bpf_verifier_log *log, const struct bpf_prog *prog,
 			 struct btf *btf2, const struct btf_type *t2)
 {
 	struct btf *btf1 = prog->aux->btf;
@@ -4396,7 +4396,7 @@ int btf_check_type_match(struct bpf_verifier_env *env, struct bpf_prog *prog,
 	u32 btf_id = 0;
 
 	if (!prog->aux->func_info) {
-		bpf_log(&env->log, "Program extension requires BTF\n");
+		bpf_log(log, "Program extension requires BTF\n");
 		return -EINVAL;
 	}
 
@@ -4408,7 +4408,7 @@ int btf_check_type_match(struct bpf_verifier_env *env, struct bpf_prog *prog,
 	if (!t1 || !btf_type_is_func(t1))
 		return -EFAULT;
 
-	return btf_check_func_type_match(&env->log, btf1, t1, btf2, t2);
+	return btf_check_func_type_match(log, btf1, t1, btf2, t2);
 }
 
 /* Compare BTF of a function with given bpf_reg_state.
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 66b6714b3fd7..400c265fdd73 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11219,6 +11219,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 	struct bpf_prog *prog = env->prog;
 	bool prog_extension = prog->type == BPF_PROG_TYPE_EXT;
 	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
+	struct bpf_verifier_log *log = &env->log;
 	u32 btf_id = prog->aux->attach_btf_id;
 	const char prefix[] = "btf_trace_";
 	struct btf_func_model fmodel;
@@ -11246,23 +11247,23 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -11274,18 +11275,18 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -11293,7 +11294,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 			prog->expected_attach_type = tgt_prog->expected_attach_type;
 		}
 		if (!tgt_prog->jited) {
-			verbose(env, "Can attach to only JITed progs\n");
+			bpf_log(log, "Can attach to only JITed progs\n");
 			return -EINVAL;
 		}
 		if (tgt_prog->type == prog->type) {
@@ -11301,7 +11302,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 			 * Cannot attach program extension to another extension.
 			 * It's ok to attach fentry/fexit to extension program.
 			 */
-			verbose(env, "Cannot recursively attach\n");
+			bpf_log(log, "Cannot recursively attach\n");
 			return -EINVAL;
 		}
 		if (tgt_prog->type == BPF_PROG_TYPE_TRACING &&
@@ -11323,13 +11324,13 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -11338,17 +11339,17 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -11371,7 +11372,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		return 0;
 	case BPF_TRACE_ITER:
 		if (!btf_type_is_func(t)) {
-			verbose(env, "attach_btf_id %u is not a function\n",
+			bpf_log(log, "attach_btf_id %u is not a function\n",
 				btf_id);
 			return -EINVAL;
 		}
@@ -11382,8 +11383,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		prog->aux->attach_func_proto = t;
 		if (!bpf_iter_prog_supported(prog))
 			return -EINVAL;
-		ret = btf_distill_func_proto(&env->log, btf, t,
-					     tname, &fmodel);
+		ret = btf_distill_func_proto(log, btf, t, tname, &fmodel);
 		return ret;
 	default:
 		if (!prog_extension)
@@ -11395,18 +11395,18 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -11425,7 +11425,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 			prog->aux->attach_func_proto = NULL;
 			t = NULL;
 		}
-		ret = btf_distill_func_proto(&env->log, btf, t,
+		ret = btf_distill_func_proto(log, btf, t,
 					     tname, &tr->func.model);
 		if (ret < 0)
 			goto out;
@@ -11437,7 +11437,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		} else {
 			addr = kallsyms_lookup_name(tname);
 			if (!addr) {
-				verbose(env,
+				bpf_log(log,
 					"The address of function %s cannot be found\n",
 					tname);
 				ret = -ENOENT;
@@ -11467,17 +11467,17 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 				break;
 			}
 			if (ret)
-				verbose(env, "%s is not sleepable\n",
+				bpf_log(log, "%s is not sleepable\n",
 					prog->aux->attach_func_name);
 		} else if (prog->expected_attach_type == BPF_MODIFY_RETURN) {
 			if (tgt_prog) {
-				verbose(env, "can't modify return codes of BPF programs\n");
+				bpf_log(log, "can't modify return codes of BPF programs\n");
 				ret = -EINVAL;
 				goto out;
 			}
 			ret = check_attach_modify_return(prog, addr);
 			if (ret)
-				verbose(env, "%s() is not modifiable\n",
+				bpf_log(log, "%s() is not modifiable\n",
 					prog->aux->attach_func_name);
 		}
 		if (ret)

