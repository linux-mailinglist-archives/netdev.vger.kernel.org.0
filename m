Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB50357408D
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 02:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbiGNAdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 20:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231955AbiGNAds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 20:33:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4C3101C6;
        Wed, 13 Jul 2022 17:33:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DFA061AD5;
        Thu, 14 Jul 2022 00:33:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABB0C341C0;
        Thu, 14 Jul 2022 00:33:44 +0000 (UTC)
Date:   Wed, 13 Jul 2022 20:33:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Song Liu <song@kernel.org>
Cc:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kernel-team@fb.com>,
        <jolsa@kernel.org>, <mhiramat@kernel.org>
Subject: Re: [PATCH v2 bpf-next 3/5] ftrace: introduce
 FTRACE_OPS_FL_SHARE_IPMODIFY
Message-ID: <20220713203343.4997eb71@rorschach.local.home>
In-Reply-To: <20220602193706.2607681-4-song@kernel.org>
References: <20220602193706.2607681-1-song@kernel.org>
 <20220602193706.2607681-4-song@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Jun 2022 12:37:04 -0700
Song Liu <song@kernel.org> wrote:

> live patch and BPF trampoline (kfunc/kretfunc in bpftrace) are important
> features for modern systems. Currently, it is not possible to use live
> patch and BPF trampoline on the same kernel function at the same time.
> This is because of the resitriction that only one ftrace_ops with flag
> FTRACE_OPS_FL_IPMODIFY on the same kernel function.
> 
> BPF trampoline uses direct ftrace_ops, which assumes IPMODIFY. However,
> not all direct ftrace_ops would overwrite the actual function. This means
> it is possible to have a non-IPMODIFY direct ftrace_ops to share the same
> kernel function with an IPMODIFY ftrace_ops.
> 
> Introduce FTRACE_OPS_FL_SHARE_IPMODIFY, which allows the direct ftrace_ops
> to share with IPMODIFY ftrace_ops. With FTRACE_OPS_FL_SHARE_IPMODIFY flag
> set, the direct ftrace_ops would call the target function picked by the
> IPMODIFY ftrace_ops.
> 
> Comment "IPMODIFY, DIRECT, and SHARE_IPMODIFY" in include/linux/ftrace.h
> contains more information about how SHARE_IPMODIFY interacts with IPMODIFY
> and DIRECT flags.
> 
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>  include/linux/ftrace.h |  74 +++++++++++++++++
>  kernel/trace/ftrace.c  | 179 ++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 242 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 9023bf69f675..bfacf608de9c 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -98,6 +98,18 @@ static inline int ftrace_mod_get_kallsym(unsigned int symnum, unsigned long *val
>  }
>  #endif
>  
> +/*
> + * FTRACE_OPS_CMD_* commands allow the ftrace core logic to request changes
> + * to a ftrace_ops.
> + *
> + * ENABLE_SHARE_IPMODIFY - enable FTRACE_OPS_FL_SHARE_IPMODIFY.
> + * DISABLE_SHARE_IPMODIFY - disable FTRACE_OPS_FL_SHARE_IPMODIFY.

The above comment is basically:

	/* Set x to 1 */
	x = 1;

Probably something like this:

 * FTRACE_OPS_CMD_* commands allow the ftrace core logic to request
   changes
 * to a ftrace_ops. Note, the requests may fail.
 *
 *	ENABLE_SHARE_IPMODIFY - Request setting the ftrace ops
 *				SHARE_IPMODIFY flag.
 *	DISABLE_SHARE_IPMODIFY - Request disabling the ftrace ops
 *				SHARE_IPMODIFY flag.


> + */
> +enum ftrace_ops_cmd {
> +	FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY,
> +	FTRACE_OPS_CMD_DISABLE_SHARE_IPMODIFY,
> +};
> +
>  #ifdef CONFIG_FUNCTION_TRACER
>  
>  extern int ftrace_enabled;
> @@ -189,6 +201,9 @@ ftrace_func_t ftrace_ops_get_func(struct ftrace_ops *ops);
>   *             ftrace_enabled.
>   * DIRECT - Used by the direct ftrace_ops helper for direct functions
>   *            (internal ftrace only, should not be used by others)
> + * SHARE_IPMODIFY - For direct ftrace_ops only. Set when the direct function
> + *            is ready to share same kernel function with IPMODIFY function
> + *            (live patch, etc.).
>   */
>  enum {
>  	FTRACE_OPS_FL_ENABLED			= BIT(0),
> @@ -209,8 +224,66 @@ enum {
>  	FTRACE_OPS_FL_TRACE_ARRAY		= BIT(15),
>  	FTRACE_OPS_FL_PERMANENT                 = BIT(16),
>  	FTRACE_OPS_FL_DIRECT			= BIT(17),
> +	FTRACE_OPS_FL_SHARE_IPMODIFY		= BIT(18),
>  };
>  
> +/*
> + * IPMODIFY, DIRECT, and SHARE_IPMODIFY.
> + *
> + * ftrace provides IPMODIFY flag for users to replace existing kernel
> + * function with a different version. This is achieved by setting regs->ip.
> + * The top user of IPMODIFY is live patch.
> + *
> + * DIRECT allows user to load custom trampoline on top of ftrace. DIRECT
> + * ftrace does not overwrite regs->ip. Instead, the custom trampoline is

No need to state if DIRECT modifies regs->ip or not. ftrace must assume
that it does (more below).

> + * saved separately (for example, orig_ax on x86). The top user of DIRECT
> + * is bpf trampoline.
> + *
> + * It is not super rare to have both live patch and bpf trampoline on the
> + * same kernel function. Therefore, it is necessary to allow the two work

					"the two to work"

> + * with each other. Given that IPMODIFY and DIRECT target addressese are

						"addresses"

> + * saved separately, this is feasible, but we need to be careful.
> + *
> + * The policy between IPMODIFY and DIRECT is:
> + *
> + *  1. Each kernel function can only have one IPMODIFY ftrace_ops;
> + *  2. Each kernel function can only have one DIRECT ftrace_ops;
> + *  3. DIRECT ftrace_ops may have IPMODIFY or not;

I was thinking about this more, and I think by default we should
consider all DIRECT ftrace_ops as the same as IPMODIFY. So perhaps the
first patch is to just remove the IPMODIFY from direct (as you did) but
then make all checks for multiple IPMODIFY also check DIRECT as well.

That is because there's no way that ftrace can verify that a direct
trampoline modifies the IP or not. Thus, it must assume that all do.

> + *  4. Each kernel function may have one non-DIRECT IPMODIFY ftrace_ops,
> + *     and one non-IPMODIFY DIRECT ftrace_ops at the same time. This
> + *     requires support from the DIRECT ftrace_ops. Specifically, the
> + *     DIRECT trampoline should call the kernel function at regs->ip.
> + *     If the DIRECT ftrace_ops supports sharing a function with ftrace_ops
> + *     with IPMODIFY, it should set flag SHARE_IPMODIFY.
> + *
> + * Some DIRECT ftrace_ops has an option to enable SHARE_IPMODIFY or not.
> + * Usually, the non-SHARE_IPMODIFY option gives better performance. To take
> + * advantage of this performance benefit, is necessary to only enable

The performance part of this comment should not be in ftrace. It's an
implementation detail of the direct trampoline and may not even be
accurate with other implementations.

> + * SHARE_IPMODIFY only when it is on the same function as an IPMODIFY
> + * ftrace_ops. There are two cases to consider:
> + *
> + *  1. IPMODIFY ftrace_ops is registered first. When the (non-IPMODIFY, and
> + *     non-SHARE_IPMODIFY) DIRECT ftrace_ops is registered later,
> + *     register_ftrace_direct_multi() returns -EAGAIN. If the user of
> + *     the DIRECT ftrace_ops can support SHARE_IPMODIFY, it should enable
> + *     SHARE_IPMODIFY and retry.

If this ftrace_ops being registered can support SHARE_IPMODIFY, then it
should have the ops_func defined, in which case, why not have it just
call that instead of having to return -EAGAIN?


> + *  2. (non-IPMODIFY, and non-SHARE_IPMODIFY) DIRECT ftrace_ops is
> + *     registered first. When the IPMODIFY ftrace_ops is registered later,
> + *     it is necessary to ask the direct ftrace_ops to enable
> + *     SHARE_IPMODIFY support. This is achieved via ftrace_ops->ops_func
> + *     cmd=FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY. For more details on this
> + *     condition, check out prepare_direct_functions_for_ipmodify().
> + */
> +
> +/*
> + * For most ftrace_ops_cmd,
> + * Returns:
> + *        0 - Success.
> + *        -EBUSY - The operation cannot process
> + *        -EAGAIN - The operation cannot process tempoorarily.
> + */
> +typedef int (*ftrace_ops_func_t)(struct ftrace_ops *op, enum ftrace_ops_cmd cmd);
> +
>  #ifdef CONFIG_DYNAMIC_FTRACE
>  /* The hash used to know what functions callbacks trace */
>  struct ftrace_ops_hash {
> @@ -253,6 +326,7 @@ struct ftrace_ops {
>  	unsigned long			trampoline;
>  	unsigned long			trampoline_size;
>  	struct list_head		list;
> +	ftrace_ops_func_t		ops_func;
>  #endif
>  };
>  
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 6a419f6bbbf0..868bbc753803 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1865,7 +1865,8 @@ static void ftrace_hash_rec_enable_modify(struct ftrace_ops *ops,
>  /*
>   * Try to update IPMODIFY flag on each ftrace_rec. Return 0 if it is OK
>   * or no-needed to update, -EBUSY if it detects a conflict of the flag
> - * on a ftrace_rec, and -EINVAL if the new_hash tries to trace all recs.
> + * on a ftrace_rec, -EINVAL if the new_hash tries to trace all recs, and
> + * -EAGAIN if the ftrace_ops need to enable SHARE_IPMODIFY.

It should just call the ftrace_ops() with the command to set it. If you
want, we could add another CMD enum that can be passed for this case.

>   * Note that old_hash and new_hash has below meanings
>   *  - If the hash is NULL, it hits all recs (if IPMODIFY is set, this is rejected)
>   *  - If the hash is EMPTY_HASH, it hits nothing
> @@ -1875,6 +1876,7 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
>  					 struct ftrace_hash *old_hash,
>  					 struct ftrace_hash *new_hash)
>  {
> +	bool is_ipmodify, is_direct, share_ipmodify;
>  	struct ftrace_page *pg;
>  	struct dyn_ftrace *rec, *end = NULL;
>  	int in_old, in_new;
> @@ -1883,7 +1885,24 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
>  	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
>  		return 0;
>  
> -	if (!(ops->flags & FTRACE_OPS_FL_IPMODIFY))
> +	/*
> +	 * The following are all the valid combinations of is_ipmodify,
> +	 * is_direct, and share_ipmodify
> +	 *
> +	 *             is_ipmodify     is_direct     share_ipmodify
> +	 *  #1              0               0                0
> +	 *  #2              1               0                0
> +	 *  #3              1               1                0

I still think that DIRECT should automatically be considered IPMODIFY
(at least in the view of ftrace, whether or not the direct function
modifies the IP).

> +	 *  #4              0               1                0
> +	 *  #5              0               1                1
> +	 */
> +
> +
> +	is_ipmodify = ops->flags & FTRACE_OPS_FL_IPMODIFY;
> +	is_direct = ops->flags & FTRACE_OPS_FL_DIRECT;
> +
> +	/* either ipmodify nor direct, skip */
> +	if (!is_ipmodify && !is_direct)   /* combinations #1 */
>  		return 0;
>  
>  	/*
> @@ -1893,6 +1912,30 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
>  	if (!new_hash || !old_hash)
>  		return -EINVAL;
>  
> +	share_ipmodify = ops->flags & FTRACE_OPS_FL_SHARE_IPMODIFY;
> +
> +	/*
> +	 * This ops itself doesn't do ip_modify and it can share a fentry
> +	 * with other ops with ipmodify, nothing to do.
> +	 */
> +	if (!is_ipmodify && share_ipmodify)   /* combinations #5 */
> +		return 0;
> +

Really, if connecting to a function that already has IPMODIFY, then the
ops_func() needs to be called, and if the ops supports SHARED_IPMODIFY
then it should get set and then continue. 

Make sense?

-- Steve

> +	/*
> +	 * Only three combinations of is_ipmodify, is_direct, and
> +	 * share_ipmodify for the logic below:
> +	 * #2 live patch
> +	 * #3 direct with ipmodify
> +	 * #4 direct without ipmodify
> +	 *
> +	 *             is_ipmodify     is_direct     share_ipmodify
> +	 *  #2              1               0                0
> +	 *  #3              1               1                0
> +	 *  #4              0               1                0
> +	 *
> +	 * Only update/rollback rec->flags for is_ipmodify == 1 (#2 and #3)
> +	 */
> +
>  	/* Update rec->flags */
>  	do_for_each_ftrace_rec(pg, rec) {
>  
> @@ -1906,12 +1949,18 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
>  			continue;
>  
>  		if (in_new) {
> -			/* New entries must ensure no others are using it */
> -			if (rec->flags & FTRACE_FL_IPMODIFY)
> -				goto rollback;
> -			rec->flags |= FTRACE_FL_IPMODIFY;
> -		} else /* Removed entry */
> +			if (rec->flags & FTRACE_FL_IPMODIFY) {
> +				/* cannot have two ipmodify on same rec */
> +				if (is_ipmodify)  /* combination #2 and #3 */
> +					goto rollback;
> +				/* let user enable share_ipmodify and retry */
> +				return  -EAGAIN;  /* combination #4 */
> +			} else if (is_ipmodify) {
> +				rec->flags |= FTRACE_FL_IPMODIFY;
> +			}
> +		} else if (is_ipmodify) {/* Removed entry */
>  			rec->flags &= ~FTRACE_FL_IPMODIFY;
> +		}
>  	} while_for_each_ftrace_rec();
>  
>  	return 0;
