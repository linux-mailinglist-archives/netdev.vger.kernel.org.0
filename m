Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC1826A7867
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 01:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjCBA3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 19:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjCBA3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 19:29:39 -0500
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F04C1BD9;
        Wed,  1 Mar 2023 16:29:37 -0800 (PST)
Received: by mail-qt1-f171.google.com with SMTP id c19so16363474qtn.13;
        Wed, 01 Mar 2023 16:29:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677716976;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kFNq1h3B/zveyHOjwzj1kfV3+R/UWi1ERbbA8LPWyMc=;
        b=PnLRco5CVHg+L5RECLGQeiUh61t2gVU3VqoN8v9uR35OnRj6YQ2msi1+iXziKNcg/p
         XiIVhmTXqO+5rkBj1XEx9XpoWBZjwPyoFwEl/nPiGP6HElhA5HD1SNdLHlXhuwMigYsg
         vDBGRd9Aqn1lEvcBSRyfK8Rq3773nJigMdMFq3m8IUpS/Sn4rX6rTrbZTZ2M5MyUIPg9
         0bmMdzoimdwEtN5GOYRd3k7KlXSWBV7RXXY/f9D++rJCDEeseNCEIgsWMPF2todP51C2
         c/cdTBfKQ17w0ZGuLH2ugSroHzdxWX7mEReNFMkCuZQYA5GE1uM0a8regLFKJRttMMpg
         lLYg==
X-Gm-Message-State: AO0yUKVwRs5JUwU/EH2lcE0AdJ50rX1LjuWl9NJOkui04D4NQJvMIxWy
        pjORbFtScngn82E9VErNXjo=
X-Google-Smtp-Source: AK7set/yz67O0vf6BxboYpYsrGjRmjT+htQHuKiVw9iX3A28O7hJpsAfDY3n1fsCE+ge9froCSWJAg==
X-Received: by 2002:a05:622a:1792:b0:3bf:d9a9:25f7 with SMTP id s18-20020a05622a179200b003bfd9a925f7mr13907239qtk.6.1677716975866;
        Wed, 01 Mar 2023 16:29:35 -0800 (PST)
Received: from maniforge ([24.1.27.177])
        by smtp.gmail.com with ESMTPSA id t129-20020a374687000000b0074235745fdasm9854161qka.58.2023.03.01.16.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 16:29:35 -0800 (PST)
Date:   Wed, 1 Mar 2023 18:29:33 -0600
From:   David Vernet <void@manifault.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v4 bpf-next 3/6] bpf: Introduce kptr_rcu.
Message-ID: <Y//t7d4eVkqoOP8P@maniforge>
References: <20230301223555.84824-1-alexei.starovoitov@gmail.com>
 <20230301223555.84824-4-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301223555.84824-4-alexei.starovoitov@gmail.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 01, 2023 at 02:35:52PM -0800, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> The life time of certain kernel structures like 'struct cgroup' is protected by RCU.
> Hence it's safe to dereference them directly from __kptr tagged pointers in bpf maps.
> The resulting pointer is MEM_RCU and can be passed to kfuncs that expect KF_RCU.
> Derefrence of other kptr-s returns PTR_UNTRUSTED.
> 
> For example:
> struct map_value {
>    struct cgroup __kptr *cgrp;
> };
> 
> SEC("tp_btf/cgroup_mkdir")
> int BPF_PROG(test_cgrp_get_ancestors, struct cgroup *cgrp_arg, const char *path)
> {
>   struct cgroup *cg, *cg2;
> 
>   cg = bpf_cgroup_acquire(cgrp_arg); // cg is PTR_TRUSTED and ref_obj_id > 0
>   bpf_kptr_xchg(&v->cgrp, cg);
> 
>   cg2 = v->cgrp; // This is new feature introduced by this patch.
>   // cg2 is PTR_MAYBE_NULL | MEM_RCU.
>   // When cg2 != NULL, it's a valid cgroup, but its percpu_ref could be zero
> 
>   if (cg2)
>     bpf_cgroup_ancestor(cg2, level); // safe to do.
> }
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Tejun Heo <tj@kernel.org>

LGTM, just one typo below to fix before merging.

Acked-by: David Vernet <void@manifault.com>

> ---
>  Documentation/bpf/kfuncs.rst                  | 12 ++--
>  include/linux/btf.h                           |  2 +-
>  kernel/bpf/helpers.c                          |  6 +-
>  kernel/bpf/verifier.c                         | 55 ++++++++++++++++---
>  net/bpf/test_run.c                            |  3 +-
>  .../selftests/bpf/progs/cgrp_kfunc_failure.c  |  2 +-
>  .../selftests/bpf/progs/map_kptr_fail.c       |  4 +-
>  tools/testing/selftests/bpf/verifier/calls.c  |  2 +-
>  .../testing/selftests/bpf/verifier/map_kptr.c |  2 +-
>  9 files changed, 65 insertions(+), 23 deletions(-)
> 
> diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
> index 0a565e310d1a..1210d8c866d6 100644
> --- a/Documentation/bpf/kfuncs.rst
> +++ b/Documentation/bpf/kfuncs.rst
> @@ -249,11 +249,13 @@ added later.
>  2.4.8 KF_RCU flag
>  -----------------
>  
> -The KF_RCU flag is used for kfuncs which have a rcu ptr as its argument.
> -When used together with KF_ACQUIRE, it indicates the kfunc should have a
> -single argument which must be a trusted argument or a MEM_RCU pointer.
> -The argument may have reference count of 0 and the kfunc must take this
> -into consideration.
> +The KF_RCU flag is a weaker version of KF_TRUSTED_ARGS. The kfuncs marked with
> +KF_RCU expect either PTR_TRUSTED or MEM_RCU arguments. The verifier guarantees
> +that the objects are valid and there is no use-after-free. The pointers are not
> +NULL, but the object's refcount could have reached zero. The kfuncs need to
> +consider doing refcnt != 0 check, especailly when returning a KF_ACQUIRE

s/especailly/especially

> +pointer. Note as well that a KF_ACQUIRE kfunc that is KF_RCU should very likely
> +also be KF_RET_NULL.
>  
>  .. _KF_deprecated_flag:
>  
> diff --git a/include/linux/btf.h b/include/linux/btf.h
> index 49e0fe6d8274..556b3e2e7471 100644
> --- a/include/linux/btf.h
> +++ b/include/linux/btf.h
> @@ -70,7 +70,7 @@
>  #define KF_TRUSTED_ARGS (1 << 4) /* kfunc only takes trusted pointer arguments */
>  #define KF_SLEEPABLE    (1 << 5) /* kfunc may sleep */
>  #define KF_DESTRUCTIVE  (1 << 6) /* kfunc performs destructive actions */
> -#define KF_RCU          (1 << 7) /* kfunc only takes rcu pointer arguments */
> +#define KF_RCU          (1 << 7) /* kfunc takes either rcu or trusted pointer arguments */
>  
>  /*
>   * Tag marking a kernel function as a kfunc. This is meant to minimize the
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 648b29e78b84..d1b53b2358ed 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -2152,8 +2152,10 @@ __bpf_kfunc struct cgroup *bpf_cgroup_ancestor(struct cgroup *cgrp, int level)
>  	if (level > cgrp->level || level < 0)
>  		return NULL;
>  
> +	/* cgrp's refcnt could be 0 here, but ancestors can still be accessed */
>  	ancestor = cgrp->ancestors[level];
> -	cgroup_get(ancestor);
> +	if (!cgroup_tryget(ancestor))
> +		return NULL;
>  	return ancestor;
>  }
>  
> @@ -2373,7 +2375,7 @@ BTF_ID_FLAGS(func, bpf_rbtree_first, KF_RET_NULL)
>  BTF_ID_FLAGS(func, bpf_cgroup_acquire, KF_ACQUIRE | KF_TRUSTED_ARGS)
>  BTF_ID_FLAGS(func, bpf_cgroup_kptr_get, KF_ACQUIRE | KF_KPTR_GET | KF_RET_NULL)
>  BTF_ID_FLAGS(func, bpf_cgroup_release, KF_RELEASE)
> -BTF_ID_FLAGS(func, bpf_cgroup_ancestor, KF_ACQUIRE | KF_TRUSTED_ARGS | KF_RET_NULL)
> +BTF_ID_FLAGS(func, bpf_cgroup_ancestor, KF_ACQUIRE | KF_RCU | KF_RET_NULL)
>  BTF_ID_FLAGS(func, bpf_cgroup_from_id, KF_ACQUIRE | KF_RET_NULL)
>  #endif
>  BTF_ID_FLAGS(func, bpf_task_from_pid, KF_ACQUIRE | KF_RET_NULL)
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index b834f3d2d81a..a095055d7ef4 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -4218,7 +4218,7 @@ static int map_kptr_match_type(struct bpf_verifier_env *env,
>  			       struct bpf_reg_state *reg, u32 regno)
>  {
>  	const char *targ_name = kernel_type_name(kptr_field->kptr.btf, kptr_field->kptr.btf_id);
> -	int perm_flags = PTR_MAYBE_NULL | PTR_TRUSTED;
> +	int perm_flags = PTR_MAYBE_NULL | PTR_TRUSTED | MEM_RCU;
>  	const char *reg_name = "";
>  
>  	/* Only unreferenced case accepts untrusted pointers */
> @@ -4285,6 +4285,34 @@ static int map_kptr_match_type(struct bpf_verifier_env *env,
>  	return -EINVAL;
>  }
>  
> +/* The non-sleepable programs and sleepable programs with explicit bpf_rcu_read_lock()
> + * can dereference RCU protected pointers and result is PTR_TRUSTED.
> + */
> +static bool in_rcu_cs(struct bpf_verifier_env *env)
> +{
> +	return env->cur_state->active_rcu_lock || !env->prog->aux->sleepable;
> +}
> +
> +/* Once GCC supports btf_type_tag the following mechanism will be replaced with tag check */
> +BTF_SET_START(rcu_protected_types)
> +BTF_ID(struct, prog_test_ref_kfunc)
> +BTF_ID(struct, cgroup)
> +BTF_SET_END(rcu_protected_types)
> +
> +static bool rcu_protected_object(const struct btf *btf, u32 btf_id)
> +{
> +	if (!btf_is_kernel(btf))
> +		return false;
> +	return btf_id_set_contains(&rcu_protected_types, btf_id);
> +}
> +
> +static bool rcu_safe_kptr(const struct btf_field *field)
> +{
> +	const struct btf_field_kptr *kptr = &field->kptr;
> +
> +	return field->type == BPF_KPTR_REF && rcu_protected_object(kptr->btf, kptr->btf_id);
> +}
> +
>  static int check_map_kptr_access(struct bpf_verifier_env *env, u32 regno,
>  				 int value_regno, int insn_idx,
>  				 struct btf_field *kptr_field)
> @@ -4319,7 +4347,10 @@ static int check_map_kptr_access(struct bpf_verifier_env *env, u32 regno,
>  		 * value from map as PTR_TO_BTF_ID, with the correct type.
>  		 */
>  		mark_btf_ld_reg(env, cur_regs(env), value_regno, PTR_TO_BTF_ID, kptr_field->kptr.btf,
> -				kptr_field->kptr.btf_id, PTR_MAYBE_NULL | PTR_UNTRUSTED);
> +				kptr_field->kptr.btf_id,
> +				rcu_safe_kptr(kptr_field) && in_rcu_cs(env) ?
> +				PTR_MAYBE_NULL | MEM_RCU :
> +				PTR_MAYBE_NULL | PTR_UNTRUSTED);
>  		/* For mark_ptr_or_null_reg */
>  		val_reg->id = ++env->id_gen;
>  	} else if (class == BPF_STX) {
> @@ -5163,10 +5194,17 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
>  	 * An RCU-protected pointer can also be deemed trusted if we are in an
>  	 * RCU read region. This case is handled below.
>  	 */
> -	if (nested_ptr_is_trusted(env, reg, off))
> +	if (nested_ptr_is_trusted(env, reg, off)) {
>  		flag |= PTR_TRUSTED;
> -	else
> +		/*
> +		 * task->cgroups is trusted. It provides a stronger guarantee
> +		 * than __rcu tag on 'cgroups' field in 'struct task_struct'.
> +		 * Clear MEM_RCU in such case.
> +		 */
> +		flag &= ~MEM_RCU;
> +	} else {
>  		flag &= ~PTR_TRUSTED;
> +	}
>  
>  	if (flag & MEM_RCU) {
>  		/* Mark value register as MEM_RCU only if it is protected by
> @@ -5175,11 +5213,10 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
>  		 * read lock region. Also mark rcu pointer as PTR_MAYBE_NULL since
>  		 * it could be null in some cases.
>  		 */
> -		if (!env->cur_state->active_rcu_lock ||
> -		    !(is_trusted_reg(reg) || is_rcu_reg(reg)))
> -			flag &= ~MEM_RCU;
> -		else
> +		if (in_rcu_cs(env) && (is_trusted_reg(reg) || is_rcu_reg(reg)))
>  			flag |= PTR_MAYBE_NULL;
> +		else
> +			flag &= ~MEM_RCU;
>  	} else if (reg->type & MEM_RCU) {
>  		/* ptr (reg) is marked as MEM_RCU, but the struct field is not tagged
>  		 * with __rcu. Mark the flag as PTR_UNTRUSTED conservatively.
> @@ -9676,7 +9713,7 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
>  			return -EINVAL;
>  		}
>  
> -		if (is_kfunc_trusted_args(meta) &&
> +		if ((is_kfunc_trusted_args(meta) || is_kfunc_rcu(meta)) &&
>  		    (register_is_null(reg) || type_may_be_null(reg->type))) {
>  			verbose(env, "Possibly NULL pointer passed to trusted arg%d\n", i);
>  			return -EACCES;
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 6f3d654b3339..6a8b33a103a4 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -737,6 +737,7 @@ __bpf_kfunc void bpf_kfunc_call_test_mem_len_fail2(u64 *mem, int len)
>  
>  __bpf_kfunc void bpf_kfunc_call_test_ref(struct prog_test_ref_kfunc *p)
>  {
> +	/* p != NULL, but p->cnt could be 0 */
>  }
>  
>  __bpf_kfunc void bpf_kfunc_call_test_destructive(void)
> @@ -784,7 +785,7 @@ BTF_ID_FLAGS(func, bpf_kfunc_call_test_fail3)
>  BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_pass1)
>  BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_fail1)
>  BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_fail2)
> -BTF_ID_FLAGS(func, bpf_kfunc_call_test_ref, KF_TRUSTED_ARGS)
> +BTF_ID_FLAGS(func, bpf_kfunc_call_test_ref, KF_TRUSTED_ARGS | KF_RCU)
>  BTF_ID_FLAGS(func, bpf_kfunc_call_test_destructive, KF_DESTRUCTIVE)
>  BTF_ID_FLAGS(func, bpf_kfunc_call_test_static_unused_arg)
>  BTF_SET8_END(test_sk_check_kfunc_ids)
> diff --git a/tools/testing/selftests/bpf/progs/cgrp_kfunc_failure.c b/tools/testing/selftests/bpf/progs/cgrp_kfunc_failure.c
> index 4ad7fe24966d..b42291ed9586 100644
> --- a/tools/testing/selftests/bpf/progs/cgrp_kfunc_failure.c
> +++ b/tools/testing/selftests/bpf/progs/cgrp_kfunc_failure.c
> @@ -205,7 +205,7 @@ int BPF_PROG(cgrp_kfunc_get_unreleased, struct cgroup *cgrp, const char *path)
>  }
>  
>  SEC("tp_btf/cgroup_mkdir")
> -__failure __msg("arg#0 is untrusted_ptr_or_null_ expected ptr_ or socket")
> +__failure __msg("expects refcounted")
>  int BPF_PROG(cgrp_kfunc_release_untrusted, struct cgroup *cgrp, const char *path)
>  {
>  	struct __cgrps_kfunc_map_value *v;
> diff --git a/tools/testing/selftests/bpf/progs/map_kptr_fail.c b/tools/testing/selftests/bpf/progs/map_kptr_fail.c
> index e19e2a5f38cf..08f9ec18c345 100644
> --- a/tools/testing/selftests/bpf/progs/map_kptr_fail.c
> +++ b/tools/testing/selftests/bpf/progs/map_kptr_fail.c
> @@ -281,7 +281,7 @@ int reject_kptr_get_bad_type_match(struct __sk_buff *ctx)
>  }
>  
>  SEC("?tc")
> -__failure __msg("R1 type=untrusted_ptr_or_null_ expected=percpu_ptr_")
> +__failure __msg("R1 type=rcu_ptr_or_null_ expected=percpu_ptr_")
>  int mark_ref_as_untrusted_or_null(struct __sk_buff *ctx)
>  {
>  	struct map_value *v;
> @@ -316,7 +316,7 @@ int reject_untrusted_store_to_ref(struct __sk_buff *ctx)
>  }
>  
>  SEC("?tc")
> -__failure __msg("R2 type=untrusted_ptr_ expected=ptr_")
> +__failure __msg("R2 must be referenced")
>  int reject_untrusted_xchg(struct __sk_buff *ctx)
>  {
>  	struct prog_test_ref_kfunc *p;
> diff --git a/tools/testing/selftests/bpf/verifier/calls.c b/tools/testing/selftests/bpf/verifier/calls.c
> index 289ed202ec66..9a326a800e5c 100644
> --- a/tools/testing/selftests/bpf/verifier/calls.c
> +++ b/tools/testing/selftests/bpf/verifier/calls.c
> @@ -243,7 +243,7 @@
>  	},
>  	.result_unpriv = REJECT,
>  	.result = REJECT,
> -	.errstr = "R1 must be referenced",
> +	.errstr = "R1 must be",
>  },
>  {
>  	"calls: valid kfunc call: referenced arg needs refcounted PTR_TO_BTF_ID",
> diff --git a/tools/testing/selftests/bpf/verifier/map_kptr.c b/tools/testing/selftests/bpf/verifier/map_kptr.c
> index 6914904344c0..d775ccb01989 100644
> --- a/tools/testing/selftests/bpf/verifier/map_kptr.c
> +++ b/tools/testing/selftests/bpf/verifier/map_kptr.c
> @@ -336,7 +336,7 @@
>  	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
>  	.fixup_map_kptr = { 1 },
>  	.result = REJECT,
> -	.errstr = "R1 type=untrusted_ptr_or_null_ expected=percpu_ptr_",
> +	.errstr = "R1 type=rcu_ptr_or_null_ expected=percpu_ptr_",
>  },
>  {
>  	"map_kptr: ref: reject off != 0",
> -- 
> 2.39.2
> 
