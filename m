Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51D649BB86
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 19:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbiAYSvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 13:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbiAYSuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 13:50:35 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EB9C061744;
        Tue, 25 Jan 2022 10:50:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wgDA9fP7U4eL48s1ELGNzJnpgnC00E8ctU7slTh1x70=; b=BDrV42wP0MTNpKdOsq+CgxPR41
        XylFLZEfpc7AhwKkAvQlmqFNZybub36TqSMxrzODwNdvzWVBjYifALdKPVLoxIMF+cf3B/ewAmFH9
        GWUvJc7NHgpAJIVHBgYVE0uR29Lumc40neFkHLfFycszbeP9wG/qo0ps54soiTfE1hPxyUJyTsDdT
        iDu1lMyLzRHaOAVHithuQETPKoodbCqfm7forTkYLFm3kmXd9/vT+2Crc8zvaeeeL5I/kgVCTg0c8
        DJ4p//fQoNMKCO8sKipbtWVD/7oo8L5cJXKlag0lVCM7Gbwy4844sutAc5Z7RyilIuNsexgSfAu0f
        3m5ZR0dg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nCQtm-009G7u-1e; Tue, 25 Jan 2022 18:50:34 +0000
Date:   Tue, 25 Jan 2022 10:50:34 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Jessica Yu <jeyu@kernel.org>,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v6 01/11] kernel: Implement try_module_get_live
Message-ID: <YfBGetHxW+qdk8WD@bombadil.infradead.org>
References: <20220102162115.1506833-1-memxor@gmail.com>
 <20220102162115.1506833-2-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220102162115.1506833-2-memxor@gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 02, 2022 at 09:51:05PM +0530, Kumar Kartikeya Dwivedi wrote:
> Refactor shared functionality between strong_try_module_get and
> try_module_get into a common helper, and expose try_module_get_live
> that returns a bool similar to try_module_get.
> 
> It will be used in the next patch for btf_try_get_module, to eliminate a
> race between module __init function invocation and module_put from BPF
> side.
> 
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: Jessica Yu <jeyu@kernel.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-modules@vger.kernel.org
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  include/linux/module.h | 26 +++++++++++++++++++-------
>  kernel/module.c        | 20 ++++++++------------
>  2 files changed, 27 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index c9f1200b2312..eb83aaeaa76e 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -608,17 +608,17 @@ void symbol_put_addr(void *addr);
>  /* Sometimes we know we already have a refcount, and it's easier not
>     to handle the error case (which only happens with rmmod --wait). */
>  extern void __module_get(struct module *module);
> -
> -/* This is the Right Way to get a module: if it fails, it's being removed,
> - * so pretend it's not there. */
> -extern bool try_module_get(struct module *module);
> -
> +extern int __try_module_get(struct module *module, bool strong);
>  extern void module_put(struct module *module);
>  
>  #else /*!CONFIG_MODULE_UNLOAD*/
> -static inline bool try_module_get(struct module *module)
> +static inline int __try_module_get(struct module *module, bool strong)
>  {
> -	return !module || module_is_live(module);
> +	if (module && !module_is_live(module))
> +		return -ENOENT;
> +	if (strong && module && module->state == MODULE_STATE_COMING)
> +		return -EBUSY;
> +	return 0;
>  }

The bool return is clear here before on try_module_get().

>  static inline void module_put(struct module *module)
>  {
> @@ -631,6 +631,18 @@ static inline void __module_get(struct module *module)
>  
>  #endif /* CONFIG_MODULE_UNLOAD */
>  
> +/* This is the Right Way to get a module: if it fails, it's being removed,
> + * so pretend it's not there. */
> +static inline bool try_module_get(struct module *module)
> +{
> +	return !__try_module_get(module, false);

Now you're making it negate an int return... 

> +}
> +/* Only take reference for modules which have fully initialized */
> +static inline bool try_module_get_live(struct module *module)
> +{
> +	return !__try_module_get(module, true);
> +}
> +
>  /* This is a #define so the string doesn't get put in every .o file */
>  #define module_name(mod)			\
>  ({						\
> diff --git a/kernel/module.c b/kernel/module.c
> index 84a9141a5e15..a9bb0a5576c8 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -318,12 +318,7 @@ EXPORT_SYMBOL(unregister_module_notifier);
>  static inline int strong_try_module_get(struct module *mod)
>  {
>  	BUG_ON(mod && mod->state == MODULE_STATE_UNFORMED);
> -	if (mod && mod->state == MODULE_STATE_COMING)
> -		return -EBUSY;
> -	if (try_module_get(mod))
> -		return 0;
> -	else
> -		return -ENOENT;

Before this change, this check had no disabled preemption
prior to the first branch, now we are having it moved with
preemption disabled. That's an OK change, but it is a
small functional change.

Because of these two things NACK on this patch for now.
Please split the patch up if you intend to make a new
functional change. And this patch should be easy to read,
this is not.

  Luis
