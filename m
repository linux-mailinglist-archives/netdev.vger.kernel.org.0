Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 253CF5692B2
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 21:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbiGFTit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 15:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiGFTis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 15:38:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3036112771;
        Wed,  6 Jul 2022 12:38:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA8A4620A3;
        Wed,  6 Jul 2022 19:38:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B18EC341C8;
        Wed,  6 Jul 2022 19:38:44 +0000 (UTC)
Date:   Wed, 6 Jul 2022 15:38:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Song Liu <song@kernel.org>
Cc:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kernel-team@fb.com>,
        <jolsa@kernel.org>, <mhiramat@kernel.org>
Subject: Re: [PATCH v2 bpf-next 5/5] bpf: trampoline: support
 FTRACE_OPS_FL_SHARE_IPMODIFY
Message-ID: <20220706153843.37584b5b@gandalf.local.home>
In-Reply-To: <20220602193706.2607681-6-song@kernel.org>
References: <20220602193706.2607681-1-song@kernel.org>
        <20220602193706.2607681-6-song@kernel.org>
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

On Thu, 2 Jun 2022 12:37:06 -0700
Song Liu <song@kernel.org> wrote:


> --- a/kernel/bpf/trampoline.c
> +++ b/kernel/bpf/trampoline.c
> @@ -27,6 +27,44 @@ static struct hlist_head trampoline_table[TRAMPOLINE_TABLE_SIZE];
>  /* serializes access to trampoline_table */
>  static DEFINE_MUTEX(trampoline_mutex);
>  
> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
> +static int bpf_trampoline_update(struct bpf_trampoline *tr, bool lock_direct_mutex);
> +
> +static int bpf_tramp_ftrace_ops_func(struct ftrace_ops *ops, enum ftrace_ops_cmd cmd)
> +{
> +	struct bpf_trampoline *tr = ops->private;
> +	int ret;
> +
> +	/*
> +	 * The normal locking order is
> +	 *    tr->mutex => direct_mutex (ftrace.c) => ftrace_lock (ftrace.c)
> +	 *
> +	 * This is called from prepare_direct_functions_for_ipmodify, with
> +	 * direct_mutex locked. Use mutex_trylock() to avoid dead lock.
> +	 * Also, bpf_trampoline_update here should not lock direct_mutex.
> +	 */
> +	if (!mutex_trylock(&tr->mutex))

Can you comment here that returning -EAGAIN will not cause this to repeat.
That it will change things where the next try will not return -EGAIN?

> +		return -EAGAIN;
> +
> +	switch (cmd) {
> +	case FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY:
> +		tr->indirect_call = true;
> +		ret = bpf_trampoline_update(tr, false /* lock_direct_mutex */);
> +		break;
> +	case FTRACE_OPS_CMD_DISABLE_SHARE_IPMODIFY:
> +		tr->indirect_call = false;
> +		tr->fops->flags &= ~FTRACE_OPS_FL_SHARE_IPMODIFY;
> +		ret = bpf_trampoline_update(tr, false /* lock_direct_mutex */);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	};
> +	mutex_unlock(&tr->mutex);
> +	return ret;
> +}
> +#endif
> +
> 


> @@ -330,7 +387,7 @@ static struct bpf_tramp_image *bpf_tramp_image_alloc(u64 key, u32 idx)
>  	return ERR_PTR(err);
>  }
>  
> -static int bpf_trampoline_update(struct bpf_trampoline *tr)
> +static int bpf_trampoline_update(struct bpf_trampoline *tr, bool lock_direct_mutex)
>  {
>  	struct bpf_tramp_image *im;
>  	struct bpf_tramp_links *tlinks;
> @@ -363,20 +420,45 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
>  	if (ip_arg)
>  		flags |= BPF_TRAMP_F_IP_ARG;
>  
> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
> +again:
> +	if (tr->indirect_call)
> +		flags |= BPF_TRAMP_F_ORIG_STACK;
> +#endif
> +
>  	err = arch_prepare_bpf_trampoline(im, im->image, im->image + PAGE_SIZE,
>  					  &tr->func.model, flags, tlinks,
>  					  tr->func.addr);
>  	if (err < 0)
>  		goto out;
>  
> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
> +	if (tr->indirect_call)
> +		tr->fops->flags |= FTRACE_OPS_FL_SHARE_IPMODIFY;
> +#endif
> +
>  	WARN_ON(tr->cur_image && tr->selector == 0);
>  	WARN_ON(!tr->cur_image && tr->selector);
>  	if (tr->cur_image)
>  		/* progs already running at this address */
> -		err = modify_fentry(tr, tr->cur_image->image, im->image);
> +		err = modify_fentry(tr, tr->cur_image->image, im->image, lock_direct_mutex);
>  	else
>  		/* first time registering */
>  		err = register_fentry(tr, im->image);
> +
> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
> +	if (err == -EAGAIN) {
> +		if (WARN_ON_ONCE(tr->indirect_call))
> +			goto out;
> +		/* should only retry on the first register */
> +		if (WARN_ON_ONCE(tr->cur_image))
> +			goto out;
> +		tr->indirect_call = true;
> +		tr->fops->func = NULL;
> +		tr->fops->trampoline = 0;
> +		goto again;

I'm assuming that the above will prevent a return of -EAGAIN again. As if
it can, then this could turn into a dead lock.

Can you please comment that?

Thanks,

-- Steve

> +	}
> +#endif
>  	if (err)
>  		goto out;
>  	if (tr->cur_image)
> @@ -460,7 +542,7 @@ int bpf_trampoline_link_prog(struct bpf_tramp_link *link, struct bpf_trampoline
>  
>  	hlist_add_head(&link->tramp_hlist, &tr->progs_hlist[kind]);
>  	tr->progs_cnt[kind]++;
> -	err = bpf_trampoline_update(tr);
> +	err = bpf_trampoline_update(tr, true /* lock_direct_mutex */);
>  	if (err) {
>  		hlist_del_init(&link->tramp_hlist);
>  		tr->progs_cnt[kind]--;
> @@ -487,7 +569,7 @@ int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_trampolin
>  	}
>  	hlist_del_init(&link->tramp_hlist);
>  	tr->progs_cnt[kind]--;
> -	err = bpf_trampoline_update(tr);
> +	err = bpf_trampoline_update(tr, true /* lock_direct_mutex */);
>  out:
>  	mutex_unlock(&tr->mutex);
>  	return err;
> @@ -535,6 +617,7 @@ void bpf_trampoline_put(struct bpf_trampoline *tr)
>  	 * multiple rcu callbacks.
>  	 */
>  	hlist_del(&tr->hlist);
> +	kfree(tr->fops);
>  	kfree(tr);
>  out:
>  	mutex_unlock(&trampoline_mutex);

