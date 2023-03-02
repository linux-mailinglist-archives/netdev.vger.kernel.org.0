Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793EC6A7A41
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 05:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjCBEF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 23:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCBEF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 23:05:27 -0500
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3109534336;
        Wed,  1 Mar 2023 20:05:24 -0800 (PST)
Received: by mail-qt1-f182.google.com with SMTP id w23so16825164qtn.6;
        Wed, 01 Mar 2023 20:05:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677729923;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zyq4NQLS+BJxhrF5szyC5MOi63LABQYQ0FsDZGg2lXI=;
        b=ErM/wqM9dytu02PHs/BVwCIyUt4+35xgFOeopo/cCPNxAufJ9p8TtmbYx8VMe3Sob2
         qvtwMFDy1l9z6AwQnCBAlDNlRuV/K9MgZUszTLVSawDBAcak7idN1OQydNG0e6KMeuhA
         P4VfH0fSk7BjGXCCCJMAt2QO675O1E3lo8B+OqDGyybRpN8HpUJoUw7HSfvFn9GfbQTF
         PVSraqn0xNB/NB18v6fwMjpNTpHWKBPczyeFFOiSXCgYsFnOYPJ4mZ5sRzGjs8WKRuJH
         Zv6dWOOfzqNIs3KVl2xvS8/ItZhXb6j6Xc78CAdi9EhtpIPdylw2sw9DIohQEAp1zm7J
         vI+w==
X-Gm-Message-State: AO0yUKUA1qNyZXTg+w0sdSuDLDGmYzd04YDrC1IqiqdYvkND3jH54gC6
        aurXMJCJMurxvgL/3IivNVdR0gvDvVwsCse9
X-Google-Smtp-Source: AK7set/8hpYHftEHi0DNQgwg8NMVUbtayxwglT3XDVPi+pAIx0DOPaDYnvGbjSL+Om5L/n3ocx0MBw==
X-Received: by 2002:a05:622a:1788:b0:3b9:bc8c:c215 with SMTP id s8-20020a05622a178800b003b9bc8cc215mr1226638qtk.32.1677729922787;
        Wed, 01 Mar 2023 20:05:22 -0800 (PST)
Received: from maniforge ([2620:10d:c091:480::1:85b1])
        by smtp.gmail.com with ESMTPSA id i62-20020a37b841000000b0073b79edf46csm10192987qkf.83.2023.03.01.20.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 20:05:22 -0800 (PST)
Date:   Wed, 1 Mar 2023 22:05:19 -0600
From:   David Vernet <void@manifault.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v4 bpf-next 6/6] bpf: Refactor RCU enforcement in the
 verifier.
Message-ID: <ZAAgfwgo5GU8V28f@maniforge>
References: <20230301223555.84824-1-alexei.starovoitov@gmail.com>
 <20230301223555.84824-7-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301223555.84824-7-alexei.starovoitov@gmail.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 01, 2023 at 02:35:55PM -0800, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> bpf_rcu_read_lock/unlock() are only available in clang compiled kernels. Lack
> of such key mechanism makes it impossible for sleepable bpf programs to use RCU
> pointers.
> 
> Allow bpf_rcu_read_lock/unlock() in GCC compiled kernels (though GCC doesn't
> support btf_type_tag yet) and allowlist certain field dereferences in important
> data structures like tast_struct, cgroup, socket that are used by sleepable
> programs either as RCU pointer or full trusted pointer (which is valid outside
> of RCU CS). Use BTF_TYPE_SAFE_RCU and BTF_TYPE_SAFE_TRUSTED macros for such
> tagging. They will be removed once GCC supports btf_type_tag.
> 
> With that refactor check_ptr_to_btf_access(). Make it strict in enforcing
> PTR_TRUSTED and PTR_UNTRUSTED while deprecating old PTR_TO_BTF_ID without
> modifier flags. There is a chance that this strict enforcement might break
> existing programs (especially on GCC compiled kernels), but this cleanup has to
> start sooner than later. Note PTR_TO_CTX access still yields old deprecated
> PTR_TO_BTF_ID. Once it's converted to strict PTR_TRUSTED or PTR_UNTRUSTED the
> kfuncs and helpers will be able to default to KF_TRUSTED_ARGS. KF_RCU will
> remain as a weaker version of KF_TRUSTED_ARGS where obj refcnt could be 0.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Nice, this is a great cleanup. Looks good overall, left a couple of
minor comments / questions below.

> ---
>  include/linux/bpf.h                           |   2 +-
>  include/linux/bpf_verifier.h                  |   1 -
>  kernel/bpf/btf.c                              |  15 +-
>  kernel/bpf/cpumask.c                          |  40 ++--
>  kernel/bpf/verifier.c                         | 178 ++++++++++++------
>  .../bpf/prog_tests/cgrp_local_storage.c       |  14 +-
>  .../selftests/bpf/prog_tests/rcu_read_lock.c  |  16 +-
>  .../selftests/bpf/progs/cgrp_ls_sleepable.c   |   4 +-
>  .../selftests/bpf/progs/cpumask_failure.c     |   2 +-
>  .../bpf/progs/nested_trust_failure.c          |   2 +-
>  .../selftests/bpf/progs/rcu_read_lock.c       |   6 +-
>  tools/testing/selftests/bpf/verifier/calls.c  |   2 +-
>  12 files changed, 172 insertions(+), 110 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 23ec684e660d..d3456804f7aa 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -2279,7 +2279,7 @@ struct bpf_core_ctx {
>  
>  bool btf_nested_type_is_trusted(struct bpf_verifier_log *log,
>  				const struct bpf_reg_state *reg,
> -				int off);
> +				int off, const char *suffix);
>  
>  bool btf_type_ids_nocast_alias(struct bpf_verifier_log *log,
>  			       const struct btf *reg_btf, u32 reg_id,
> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> index b26ff2a8f63b..18538bad2b8c 100644
> --- a/include/linux/bpf_verifier.h
> +++ b/include/linux/bpf_verifier.h
> @@ -537,7 +537,6 @@ struct bpf_verifier_env {
>  	bool bypass_spec_v1;
>  	bool bypass_spec_v4;
>  	bool seen_direct_write;
> -	bool rcu_tag_supported;
>  	struct bpf_insn_aux_data *insn_aux_data; /* array of per-insn state */
>  	const struct bpf_line_info *prev_linfo;
>  	struct bpf_verifier_log log;
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index c5e1d6955491..bae384728ec7 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -6329,6 +6329,15 @@ static int btf_struct_walk(struct bpf_verifier_log *log, const struct btf *btf,
>  		 * of this field or inside of this struct
>  		 */
>  		if (btf_type_is_struct(mtype)) {
> +			if (BTF_INFO_KIND(mtype->info) == BTF_KIND_UNION &&
> +			    btf_type_vlen(mtype) != 1)
> +				/*
> +				 * walking unions yields untrusted pointers
> +				 * with exception of __bpf_md_ptr and others

s/others/other

> +				 * unions with a single member
> +				 */
> +				*flag |= PTR_UNTRUSTED;
> +
>  			/* our field must be inside that union or struct */
>  			t = mtype;
>  
> @@ -6373,7 +6382,7 @@ static int btf_struct_walk(struct bpf_verifier_log *log, const struct btf *btf,
>  			stype = btf_type_skip_modifiers(btf, mtype->type, &id);
>  			if (btf_type_is_struct(stype)) {
>  				*next_btf_id = id;
> -				*flag = tmp_flag;
> +				*flag |= tmp_flag;

Now that this function doesn't do a full write of the variable, the
semantics have changed such that the caller has to initialize the
variable on behalf of bpf_struct_walk(). This makes callers such as
btf_struct_ids_match() (line 6503) have random crud in the pointer.
Doesn't really matter for that case because the variable isn't used
anyways, but it seems slightly less brittle to initialize *flag to 0 at
the beginning of the function to avoid requiring the caller to
initialize it. Wdyt?

>  				return WALK_PTR;
>  			}
>  		}
> @@ -8357,7 +8366,7 @@ int bpf_core_apply(struct bpf_core_ctx *ctx, const struct bpf_core_relo *relo,
>  
>  bool btf_nested_type_is_trusted(struct bpf_verifier_log *log,
>  				const struct bpf_reg_state *reg,
> -				int off)
> +				int off, const char *suffix)
>  {
>  	struct btf *btf = reg->btf;
>  	const struct btf_type *walk_type, *safe_type;
> @@ -8374,7 +8383,7 @@ bool btf_nested_type_is_trusted(struct bpf_verifier_log *log,
>  
>  	tname = btf_name_by_offset(btf, walk_type->name_off);
>  
> -	ret = snprintf(safe_tname, sizeof(safe_tname), "%s__safe_fields", tname);
> +	ret = snprintf(safe_tname, sizeof(safe_tname), "%s%s", tname, suffix);
>  	if (ret < 0)
>  		return false;
>  
> diff --git a/kernel/bpf/cpumask.c b/kernel/bpf/cpumask.c
> index 2b3fbbfebdc5..2223562dd54e 100644
> --- a/kernel/bpf/cpumask.c
> +++ b/kernel/bpf/cpumask.c
> @@ -427,26 +427,26 @@ BTF_ID_FLAGS(func, bpf_cpumask_create, KF_ACQUIRE | KF_RET_NULL)
>  BTF_ID_FLAGS(func, bpf_cpumask_release, KF_RELEASE | KF_TRUSTED_ARGS)
>  BTF_ID_FLAGS(func, bpf_cpumask_acquire, KF_ACQUIRE | KF_TRUSTED_ARGS)
>  BTF_ID_FLAGS(func, bpf_cpumask_kptr_get, KF_ACQUIRE | KF_KPTR_GET | KF_RET_NULL)
> -BTF_ID_FLAGS(func, bpf_cpumask_first, KF_TRUSTED_ARGS)
> -BTF_ID_FLAGS(func, bpf_cpumask_first_zero, KF_TRUSTED_ARGS)
> -BTF_ID_FLAGS(func, bpf_cpumask_set_cpu, KF_TRUSTED_ARGS)
> -BTF_ID_FLAGS(func, bpf_cpumask_clear_cpu, KF_TRUSTED_ARGS)
> -BTF_ID_FLAGS(func, bpf_cpumask_test_cpu, KF_TRUSTED_ARGS)
> -BTF_ID_FLAGS(func, bpf_cpumask_test_and_set_cpu, KF_TRUSTED_ARGS)
> -BTF_ID_FLAGS(func, bpf_cpumask_test_and_clear_cpu, KF_TRUSTED_ARGS)
> -BTF_ID_FLAGS(func, bpf_cpumask_setall, KF_TRUSTED_ARGS)
> -BTF_ID_FLAGS(func, bpf_cpumask_clear, KF_TRUSTED_ARGS)
> -BTF_ID_FLAGS(func, bpf_cpumask_and, KF_TRUSTED_ARGS)
> -BTF_ID_FLAGS(func, bpf_cpumask_or, KF_TRUSTED_ARGS)
> -BTF_ID_FLAGS(func, bpf_cpumask_xor, KF_TRUSTED_ARGS)
> -BTF_ID_FLAGS(func, bpf_cpumask_equal, KF_TRUSTED_ARGS)
> -BTF_ID_FLAGS(func, bpf_cpumask_intersects, KF_TRUSTED_ARGS)
> -BTF_ID_FLAGS(func, bpf_cpumask_subset, KF_TRUSTED_ARGS)
> -BTF_ID_FLAGS(func, bpf_cpumask_empty, KF_TRUSTED_ARGS)
> -BTF_ID_FLAGS(func, bpf_cpumask_full, KF_TRUSTED_ARGS)
> -BTF_ID_FLAGS(func, bpf_cpumask_copy, KF_TRUSTED_ARGS)
> -BTF_ID_FLAGS(func, bpf_cpumask_any, KF_TRUSTED_ARGS)
> -BTF_ID_FLAGS(func, bpf_cpumask_any_and, KF_TRUSTED_ARGS)
> +BTF_ID_FLAGS(func, bpf_cpumask_first, KF_TRUSTED_ARGS | KF_RCU)
> +BTF_ID_FLAGS(func, bpf_cpumask_first_zero, KF_TRUSTED_ARGS | KF_RCU)
> +BTF_ID_FLAGS(func, bpf_cpumask_set_cpu, KF_TRUSTED_ARGS | KF_RCU)
> +BTF_ID_FLAGS(func, bpf_cpumask_clear_cpu, KF_TRUSTED_ARGS | KF_RCU)
> +BTF_ID_FLAGS(func, bpf_cpumask_test_cpu, KF_TRUSTED_ARGS | KF_RCU)
> +BTF_ID_FLAGS(func, bpf_cpumask_test_and_set_cpu, KF_TRUSTED_ARGS | KF_RCU)
> +BTF_ID_FLAGS(func, bpf_cpumask_test_and_clear_cpu, KF_TRUSTED_ARGS | KF_RCU)
> +BTF_ID_FLAGS(func, bpf_cpumask_setall, KF_TRUSTED_ARGS | KF_RCU)
> +BTF_ID_FLAGS(func, bpf_cpumask_clear, KF_TRUSTED_ARGS | KF_RCU)
> +BTF_ID_FLAGS(func, bpf_cpumask_and, KF_TRUSTED_ARGS | KF_RCU)
> +BTF_ID_FLAGS(func, bpf_cpumask_or, KF_TRUSTED_ARGS | KF_RCU)
> +BTF_ID_FLAGS(func, bpf_cpumask_xor, KF_TRUSTED_ARGS | KF_RCU)
> +BTF_ID_FLAGS(func, bpf_cpumask_equal, KF_TRUSTED_ARGS | KF_RCU)
> +BTF_ID_FLAGS(func, bpf_cpumask_intersects, KF_TRUSTED_ARGS | KF_RCU)
> +BTF_ID_FLAGS(func, bpf_cpumask_subset, KF_TRUSTED_ARGS | KF_RCU)
> +BTF_ID_FLAGS(func, bpf_cpumask_empty, KF_TRUSTED_ARGS | KF_RCU)
> +BTF_ID_FLAGS(func, bpf_cpumask_full, KF_TRUSTED_ARGS | KF_RCU)
> +BTF_ID_FLAGS(func, bpf_cpumask_copy, KF_TRUSTED_ARGS | KF_RCU)
> +BTF_ID_FLAGS(func, bpf_cpumask_any, KF_TRUSTED_ARGS | KF_RCU)
> +BTF_ID_FLAGS(func, bpf_cpumask_any_and, KF_TRUSTED_ARGS | KF_RCU)

It's functionally the same, but could you please remove KF_TRUSTED_ARGS
given that it's accepted for KF_RCU? We should ideally be removing
KF_TRUSTED_ARGS altogether soon(ish) anyways, so might as well do it
here.

>  BTF_SET8_END(cpumask_kfunc_btf_ids)
>  
>  static const struct btf_kfunc_id_set cpumask_kfunc_set = {
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index a095055d7ef4..10d674e8154a 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -5073,29 +5073,76 @@ static int bpf_map_direct_read(struct bpf_map *map, int off, int size, u64 *val)
>  	return 0;
>  }
>  
> -#define BTF_TYPE_SAFE_NESTED(__type)  __PASTE(__type, __safe_fields)
> +#define BTF_TYPE_SAFE_RCU(__type)  __PASTE(__type, __safe_rcu)
> +#define BTF_TYPE_SAFE_TRUSTED(__type)  __PASTE(__type, __safe_trusted)
>  
> -BTF_TYPE_SAFE_NESTED(struct task_struct) {
> +/*
> + * Allow list few fields as RCU trusted or full trusted.
> + * This logic doesn't allow mix tagging and will be removed once GCC supports
> + * btf_type_tag.
> + */
> +
> +/* RCU trusted: these fields are trusted in RCU CS and never NULL */
> +BTF_TYPE_SAFE_RCU(struct task_struct) {
>  	const cpumask_t *cpus_ptr;
>  	struct css_set __rcu *cgroups;
> +	struct task_struct __rcu *real_parent;
> +	struct task_struct *group_leader;
>  };
>  
> -BTF_TYPE_SAFE_NESTED(struct css_set) {
> +BTF_TYPE_SAFE_RCU(struct css_set) {
>  	struct cgroup *dfl_cgrp;
>  };
>  
> -static bool nested_ptr_is_trusted(struct bpf_verifier_env *env,
> -				  struct bpf_reg_state *reg,
> -				  int off)
> +/* full trusted: these fields are trusted even outside of RCU CS and never NULL */
> +BTF_TYPE_SAFE_TRUSTED(struct bpf_iter_meta) {
> +	__bpf_md_ptr(struct seq_file *, seq);
> +};
> +
> +BTF_TYPE_SAFE_TRUSTED(struct bpf_iter__task) {
> +	__bpf_md_ptr(struct bpf_iter_meta *, meta);
> +	__bpf_md_ptr(struct task_struct *, task);
> +};
> +
> +BTF_TYPE_SAFE_TRUSTED(struct linux_binprm) {
> +	struct file *file;
> +};
> +
> +BTF_TYPE_SAFE_TRUSTED(struct file) {
> +	struct inode *f_inode;
> +};
> +
> +BTF_TYPE_SAFE_TRUSTED(struct dentry) {
> +	/* no negative dentry-s in places where bpf can see it */
> +	struct inode *d_inode;
> +};
> +
> +BTF_TYPE_SAFE_TRUSTED(struct socket) {
> +	struct sock *sk;
> +};
> +
> +static bool type_is_rcu(struct bpf_verifier_env *env,
> +			struct bpf_reg_state *reg,
> +			int off)
>  {
> -	/* If its parent is not trusted, it can't regain its trusted status. */
> -	if (!is_trusted_reg(reg))
> -		return false;
> +	BTF_TYPE_EMIT(BTF_TYPE_SAFE_RCU(struct task_struct));
> +	BTF_TYPE_EMIT(BTF_TYPE_SAFE_RCU(struct css_set));
>  
> -	BTF_TYPE_EMIT(BTF_TYPE_SAFE_NESTED(struct task_struct));
> -	BTF_TYPE_EMIT(BTF_TYPE_SAFE_NESTED(struct css_set));
> +	return btf_nested_type_is_trusted(&env->log, reg, off, "__safe_rcu");
> +}
>  
> -	return btf_nested_type_is_trusted(&env->log, reg, off);
> +static bool type_is_trusted(struct bpf_verifier_env *env,
> +			    struct bpf_reg_state *reg,
> +			    int off)
> +{
> +	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct bpf_iter_meta));
> +	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct bpf_iter__task));
> +	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct linux_binprm));
> +	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct file));
> +	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct dentry));
> +	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct socket));
> +
> +	return btf_nested_type_is_trusted(&env->log, reg, off, "__safe_trusted");
>  }
>  
>  static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
> @@ -5181,49 +5228,58 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
>  	if (ret < 0)
>  		return ret;
>  
> -	/* If this is an untrusted pointer, all pointers formed by walking it
> -	 * also inherit the untrusted flag.
> -	 */
> -	if (type_flag(reg->type) & PTR_UNTRUSTED)
> -		flag |= PTR_UNTRUSTED;
> +	if (ret != PTR_TO_BTF_ID) {
> +		/* just mark; */
>  
> -	/* By default any pointer obtained from walking a trusted pointer is no
> -	 * longer trusted, unless the field being accessed has explicitly been
> -	 * marked as inheriting its parent's state of trust.
> -	 *
> -	 * An RCU-protected pointer can also be deemed trusted if we are in an
> -	 * RCU read region. This case is handled below.
> -	 */
> -	if (nested_ptr_is_trusted(env, reg, off)) {
> -		flag |= PTR_TRUSTED;
> -		/*
> -		 * task->cgroups is trusted. It provides a stronger guarantee
> -		 * than __rcu tag on 'cgroups' field in 'struct task_struct'.
> -		 * Clear MEM_RCU in such case.
> +	} else if (type_flag(reg->type) & PTR_UNTRUSTED) {
> +		/* If this is an untrusted pointer, all pointers formed by walking it
> +		 * also inherit the untrusted flag.
> +		 */
> +		flag = PTR_UNTRUSTED;
> +
> +	} else if (is_trusted_reg(reg) || is_rcu_reg(reg)) {
> +		/* By default any pointer obtained from walking a trusted pointer is no
> +		 * longer trusted, unless the field being accessed has explicitly been
> +		 * marked as inheriting its parent's state of trust (either full or RCU).
> +		 * For example:
> +		 * 'cgroups' pointer is untrusted if task->cgroups dereference
> +		 * happened in a sleepable program outside of bpf_rcu_read_lock()
> +		 * section. In a non-sleepable program it's trusted while in RCU CS (aka MEM_RCU).
> +		 * Note bpf_rcu_read_unlock() converts MEM_RCU pointers to PTR_UNTRUSTED.
> +		 *
> +		 * A regular RCU-protected pointer with __rcu tag can also be deemed
> +		 * trusted if we are in an RCU CS. Such pointer can be NULL.
>  		 */
> -		flag &= ~MEM_RCU;
> +		if (type_is_trusted(env, reg, off)) {
> +			flag |= PTR_TRUSTED;
> +		} else if (in_rcu_cs(env) && !type_may_be_null(reg->type)) {
> +			if (type_is_rcu(env, reg, off)) {
> +				/* ignore __rcu tag and mark it MEM_RCU */
> +				flag |= MEM_RCU;
> +			} else if (flag & MEM_RCU) {
> +				/* __rcu tagged pointers can be NULL */
> +				flag |= PTR_MAYBE_NULL;

I'm not quite understanding the distinction between manually-specified
RCU-safe types being non-nullable, vs. __rcu pointers being nullable.
Aren't they functionally the exact same thing, with the exception being
that gcc doesn't support __rcu, so we've decided to instead manually
specify them for some types that we know we need until __rcu is the
default mechanism?  If the plan is to remove these macros once gcc
supports __rcu, this could break some programs that are expecting the
fields to be non-NULL, no?

I see why we're doing this in the interim -- task->cgroups,
css->dfl_cgrp, task->cpus_ptr, etc can never be NULL. The problem is
that I think those are implementation details that are separate from the
pointers being RCU safe. This seems rather like we need a separate
non-nullable tag, or something to that effect.

> +			} else if (flag & (MEM_PERCPU | MEM_USER)) {
> +				/* keep as-is */
> +			} else {
> +				/* walking unknown pointers yields untrusted pointer */
> +				flag = PTR_UNTRUSTED;
> +			}
> +		} else {
> +			/*
> +			 * If not in RCU CS or MEM_RCU pointer can be NULL then
> +			 * aggressively mark as untrusted otherwise such
> +			 * pointers will be plain PTR_TO_BTF_ID without flags
> +			 * and will be allowed to be passed into helpers for
> +			 * compat reasons.
> +			 */
> +			flag = PTR_UNTRUSTED;
> +		}
>  	} else {
> +		/* Old compat. Deperecated */

s/Deperecated/Deprecated

>  		flag &= ~PTR_TRUSTED;

Do you know what else is left for us to fix to be able to just set
PTR_UNTRUSTED here?

>  	}
>  
> -	if (flag & MEM_RCU) {
> -		/* Mark value register as MEM_RCU only if it is protected by
> -		 * bpf_rcu_read_lock() and the ptr reg is rcu or trusted. MEM_RCU
> -		 * itself can already indicate trustedness inside the rcu
> -		 * read lock region. Also mark rcu pointer as PTR_MAYBE_NULL since
> -		 * it could be null in some cases.
> -		 */
> -		if (in_rcu_cs(env) && (is_trusted_reg(reg) || is_rcu_reg(reg)))
> -			flag |= PTR_MAYBE_NULL;
> -		else
> -			flag &= ~MEM_RCU;
> -	} else if (reg->type & MEM_RCU) {
> -		/* ptr (reg) is marked as MEM_RCU, but the struct field is not tagged
> -		 * with __rcu. Mark the flag as PTR_UNTRUSTED conservatively.
> -		 */
> -		flag |= PTR_UNTRUSTED;
> -	}
> -
>  	if (atype == BPF_READ && value_regno >= 0)
>  		mark_btf_ld_reg(env, regs, value_regno, ret, reg->btf, btf_id, flag);
>  
> @@ -10049,10 +10105,6 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
>  
>  	rcu_lock = is_kfunc_bpf_rcu_read_lock(&meta);
>  	rcu_unlock = is_kfunc_bpf_rcu_read_unlock(&meta);
> -	if ((rcu_lock || rcu_unlock) && !env->rcu_tag_supported) {
> -		verbose(env, "no vmlinux btf rcu tag support for kfunc %s\n", func_name);
> -		return -EACCES;
> -	}
>  
>  	if (env->cur_state->active_rcu_lock) {
>  		struct bpf_func_state *state;
> @@ -14911,8 +14963,22 @@ static int do_check(struct bpf_verifier_env *env)
>  				 * src_reg == stack|map in some other branch.
>  				 * Reject it.
>  				 */
> -				verbose(env, "same insn cannot be used with different pointers\n");
> -				return -EINVAL;
> +				if (base_type(src_reg_type) == PTR_TO_BTF_ID &&
> +				    base_type(*prev_src_type) == PTR_TO_BTF_ID) {
> +					/*
> +					 * Have to support a use case when one path through
> +					 * the program yields TRUSTED pointer while another
> +					 * is UNTRUSTED. Fallback to UNTRUSTED to generate
> +					 * BPF_PROBE_MEM.
> +					 */
> +					*prev_src_type = PTR_TO_BTF_ID | PTR_UNTRUSTED;
> +				} else {
> +					verbose(env,
> +						"The same insn cannot be used with different pointers: %s",
> +						reg_type_str(env, src_reg_type));
> +					verbose(env, " != %s\n", reg_type_str(env, *prev_src_type));
> +					return -EINVAL;
> +				}
>  			}
>  
>  		} else if (class == BPF_STX) {
> @@ -17984,8 +18050,6 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr)
>  	env->bypass_spec_v1 = bpf_bypass_spec_v1();
>  	env->bypass_spec_v4 = bpf_bypass_spec_v4();
>  	env->bpf_capable = bpf_capable();
> -	env->rcu_tag_supported = btf_vmlinux &&
> -		btf_find_by_name_kind(btf_vmlinux, "rcu", BTF_KIND_TYPE_TAG) > 0;
>  
>  	if (is_priv)
>  		env->test_state_freq = attr->prog_flags & BPF_F_TEST_STATE_FREQ;
> diff --git a/tools/testing/selftests/bpf/prog_tests/cgrp_local_storage.c b/tools/testing/selftests/bpf/prog_tests/cgrp_local_storage.c
> index 2cc759956e3b..63e776f4176e 100644
> --- a/tools/testing/selftests/bpf/prog_tests/cgrp_local_storage.c
> +++ b/tools/testing/selftests/bpf/prog_tests/cgrp_local_storage.c
> @@ -193,7 +193,7 @@ static void test_cgroup_iter_sleepable(int cgroup_fd, __u64 cgroup_id)
>  	cgrp_ls_sleepable__destroy(skel);
>  }
>  
> -static void test_no_rcu_lock(__u64 cgroup_id)
> +static void test_yes_rcu_lock(__u64 cgroup_id)
>  {
>  	struct cgrp_ls_sleepable *skel;
>  	int err;
> @@ -204,7 +204,7 @@ static void test_no_rcu_lock(__u64 cgroup_id)
>  
>  	skel->bss->target_pid = syscall(SYS_gettid);
>  
> -	bpf_program__set_autoload(skel->progs.no_rcu_lock, true);
> +	bpf_program__set_autoload(skel->progs.yes_rcu_lock, true);
>  	err = cgrp_ls_sleepable__load(skel);
>  	if (!ASSERT_OK(err, "skel_load"))
>  		goto out;
> @@ -220,7 +220,7 @@ static void test_no_rcu_lock(__u64 cgroup_id)
>  	cgrp_ls_sleepable__destroy(skel);
>  }
>  
> -static void test_rcu_lock(void)
> +static void test_no_rcu_lock(void)
>  {
>  	struct cgrp_ls_sleepable *skel;
>  	int err;
> @@ -229,7 +229,7 @@ static void test_rcu_lock(void)
>  	if (!ASSERT_OK_PTR(skel, "skel_open"))
>  		return;
>  
> -	bpf_program__set_autoload(skel->progs.yes_rcu_lock, true);
> +	bpf_program__set_autoload(skel->progs.no_rcu_lock, true);
>  	err = cgrp_ls_sleepable__load(skel);
>  	ASSERT_ERR(err, "skel_load");
>  
> @@ -256,10 +256,10 @@ void test_cgrp_local_storage(void)
>  		test_negative();
>  	if (test__start_subtest("cgroup_iter_sleepable"))
>  		test_cgroup_iter_sleepable(cgroup_fd, cgroup_id);
> +	if (test__start_subtest("yes_rcu_lock"))
> +		test_yes_rcu_lock(cgroup_id);
>  	if (test__start_subtest("no_rcu_lock"))
> -		test_no_rcu_lock(cgroup_id);
> -	if (test__start_subtest("rcu_lock"))
> -		test_rcu_lock();
> +		test_no_rcu_lock();
>  
>  	close(cgroup_fd);
>  }
> diff --git a/tools/testing/selftests/bpf/prog_tests/rcu_read_lock.c b/tools/testing/selftests/bpf/prog_tests/rcu_read_lock.c
> index 447d8560ecb6..3f1f58d3a729 100644
> --- a/tools/testing/selftests/bpf/prog_tests/rcu_read_lock.c
> +++ b/tools/testing/selftests/bpf/prog_tests/rcu_read_lock.c
> @@ -25,10 +25,10 @@ static void test_success(void)
>  
>  	bpf_program__set_autoload(skel->progs.get_cgroup_id, true);
>  	bpf_program__set_autoload(skel->progs.task_succ, true);
> -	bpf_program__set_autoload(skel->progs.no_lock, true);
>  	bpf_program__set_autoload(skel->progs.two_regions, true);
>  	bpf_program__set_autoload(skel->progs.non_sleepable_1, true);
>  	bpf_program__set_autoload(skel->progs.non_sleepable_2, true);
> +	bpf_program__set_autoload(skel->progs.task_trusted_non_rcuptr, true);
>  	err = rcu_read_lock__load(skel);
>  	if (!ASSERT_OK(err, "skel_load"))
>  		goto out;
> @@ -69,6 +69,7 @@ static void test_rcuptr_acquire(void)
>  
>  static const char * const inproper_region_tests[] = {
>  	"miss_lock",
> +	"no_lock",
>  	"miss_unlock",
>  	"non_sleepable_rcu_mismatch",
>  	"inproper_sleepable_helper",
> @@ -99,7 +100,6 @@ static void test_inproper_region(void)
>  }
>  
>  static const char * const rcuptr_misuse_tests[] = {
> -	"task_untrusted_non_rcuptr",
>  	"task_untrusted_rcuptr",
>  	"cross_rcu_region",
>  };
> @@ -128,17 +128,8 @@ static void test_rcuptr_misuse(void)
>  
>  void test_rcu_read_lock(void)
>  {
> -	struct btf *vmlinux_btf;
>  	int cgroup_fd;
>  
> -	vmlinux_btf = btf__load_vmlinux_btf();
> -	if (!ASSERT_OK_PTR(vmlinux_btf, "could not load vmlinux BTF"))
> -		return;
> -	if (btf__find_by_name_kind(vmlinux_btf, "rcu", BTF_KIND_TYPE_TAG) < 0) {
> -		test__skip();
> -		goto out;
> -	}
> -
>  	cgroup_fd = test__join_cgroup("/rcu_read_lock");
>  	if (!ASSERT_GE(cgroup_fd, 0, "join_cgroup /rcu_read_lock"))
>  		goto out;
> @@ -153,6 +144,5 @@ void test_rcu_read_lock(void)
>  	if (test__start_subtest("negative_tests_rcuptr_misuse"))
>  		test_rcuptr_misuse();
>  	close(cgroup_fd);
> -out:
> -	btf__free(vmlinux_btf);
> +out:;
>  }
> diff --git a/tools/testing/selftests/bpf/progs/cgrp_ls_sleepable.c b/tools/testing/selftests/bpf/progs/cgrp_ls_sleepable.c
> index 2d11ed528b6f..7615dc23d301 100644
> --- a/tools/testing/selftests/bpf/progs/cgrp_ls_sleepable.c
> +++ b/tools/testing/selftests/bpf/progs/cgrp_ls_sleepable.c
> @@ -49,7 +49,7 @@ int no_rcu_lock(void *ctx)
>  	if (task->pid != target_pid)
>  		return 0;
>  
> -	/* ptr_to_btf_id semantics. should work. */
> +	/* task->cgroups is untrusted in sleepable prog outside of RCU CS */
>  	cgrp = task->cgroups->dfl_cgrp;
>  	ptr = bpf_cgrp_storage_get(&map_a, cgrp, 0,
>  				   BPF_LOCAL_STORAGE_GET_F_CREATE);
> @@ -71,7 +71,7 @@ int yes_rcu_lock(void *ctx)
>  
>  	bpf_rcu_read_lock();
>  	cgrp = task->cgroups->dfl_cgrp;
> -	/* cgrp is untrusted and cannot pass to bpf_cgrp_storage_get() helper. */
> +	/* cgrp is trusted under RCU CS */
>  	ptr = bpf_cgrp_storage_get(&map_a, cgrp, 0, BPF_LOCAL_STORAGE_GET_F_CREATE);
>  	if (ptr)
>  		cgroup_id = cgrp->kn->id;
> diff --git a/tools/testing/selftests/bpf/progs/cpumask_failure.c b/tools/testing/selftests/bpf/progs/cpumask_failure.c
> index 33e8e86dd090..c16f7563b84e 100644
> --- a/tools/testing/selftests/bpf/progs/cpumask_failure.c
> +++ b/tools/testing/selftests/bpf/progs/cpumask_failure.c
> @@ -44,7 +44,7 @@ int BPF_PROG(test_alloc_double_release, struct task_struct *task, u64 clone_flag
>  }
>  
>  SEC("tp_btf/task_newtask")
> -__failure __msg("bpf_cpumask_acquire args#0 expected pointer to STRUCT bpf_cpumask")
> +__failure __msg("must be referenced")
>  int BPF_PROG(test_acquire_wrong_cpumask, struct task_struct *task, u64 clone_flags)
>  {
>  	struct bpf_cpumask *cpumask;
> diff --git a/tools/testing/selftests/bpf/progs/nested_trust_failure.c b/tools/testing/selftests/bpf/progs/nested_trust_failure.c
> index 14aff7676436..0d1aa6bbace4 100644
> --- a/tools/testing/selftests/bpf/progs/nested_trust_failure.c
> +++ b/tools/testing/selftests/bpf/progs/nested_trust_failure.c
> @@ -17,7 +17,7 @@ char _license[] SEC("license") = "GPL";
>   */
>  
>  SEC("tp_btf/task_newtask")
> -__failure __msg("R2 must be referenced or trusted")
> +__failure __msg("R2 must be")
>  int BPF_PROG(test_invalid_nested_user_cpus, struct task_struct *task, u64 clone_flags)
>  {
>  	bpf_cpumask_test_cpu(0, task->user_cpus_ptr);
> diff --git a/tools/testing/selftests/bpf/progs/rcu_read_lock.c b/tools/testing/selftests/bpf/progs/rcu_read_lock.c
> index 5cecbdbbb16e..7250bb76d18a 100644
> --- a/tools/testing/selftests/bpf/progs/rcu_read_lock.c
> +++ b/tools/testing/selftests/bpf/progs/rcu_read_lock.c
> @@ -81,7 +81,7 @@ int no_lock(void *ctx)
>  {
>  	struct task_struct *task, *real_parent;
>  
> -	/* no bpf_rcu_read_lock(), old code still works */
> +	/* old style ptr_to_btf_id is not allowed in sleepable */
>  	task = bpf_get_current_task_btf();
>  	real_parent = task->real_parent;
>  	(void)bpf_task_storage_get(&map_a, real_parent, 0, 0);
> @@ -286,13 +286,13 @@ int nested_rcu_region(void *ctx)
>  }
>  
>  SEC("?fentry.s/" SYS_PREFIX "sys_getpgid")
> -int task_untrusted_non_rcuptr(void *ctx)
> +int task_trusted_non_rcuptr(void *ctx)
>  {
>  	struct task_struct *task, *group_leader;
>  
>  	task = bpf_get_current_task_btf();
>  	bpf_rcu_read_lock();
> -	/* the pointer group_leader marked as untrusted */
> +	/* the pointer group_leader is explicitly marked as trusted */
>  	group_leader = task->real_parent->group_leader;
>  	(void)bpf_task_storage_get(&map_a, group_leader, 0, 0);
>  	bpf_rcu_read_unlock();
> diff --git a/tools/testing/selftests/bpf/verifier/calls.c b/tools/testing/selftests/bpf/verifier/calls.c
> index 9a326a800e5c..5702fc9761ef 100644
> --- a/tools/testing/selftests/bpf/verifier/calls.c
> +++ b/tools/testing/selftests/bpf/verifier/calls.c
> @@ -181,7 +181,7 @@
>  	},
>  	.result_unpriv = REJECT,
>  	.result = REJECT,
> -	.errstr = "negative offset ptr_ ptr R1 off=-4 disallowed",
> +	.errstr = "ptr R1 off=-4 disallowed",
>  },
>  {
>  	"calls: invalid kfunc call: PTR_TO_BTF_ID with variable offset",
> -- 
> 2.39.2
> 
