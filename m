Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B8150FA63
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 12:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344509AbiDZK2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 06:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348845AbiDZK2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 06:28:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D642D5DE71;
        Tue, 26 Apr 2022 03:01:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 881C8B81D47;
        Tue, 26 Apr 2022 10:01:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1A3C385A4;
        Tue, 26 Apr 2022 10:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650967273;
        bh=QpZImYLme4EiJQq5ruNv0+OY+uzOjs/YbCXzxSFuCCo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XKRPriipnaberwU9XSsnbL9pNV4ANaq+YXwnl9ySmbeIqkTfRIb2jpiFpD4uWot2R
         tB1wUMnRCjynWi+JXceE/PNc+TrDbWbmflCL0UrHavtT2L50BoLaW8mMaeJeWsga/d
         6aLwp/D1cGHrspOxDGgRGjAI0PtOnWSAjNayyLJ63WuWefF8bgZSUYZvYFPPxql1rK
         HESeX36K64XFebZRbpzB8Q17WKPC6W2dlhQaLDBGWtJccR0IpOmmf337IdHMt/G12t
         +PKM90yqiNd9Z8SX7I4DEUpJnHI02wQuIopVHv15F2G4GHzsyz/bdFDgTSaHZ140ci
         +sdwCrASZcyug==
Date:   Tue, 26 Apr 2022 19:01:08 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCHv2 bpf-next 1/4] kallsyms: Add kallsyms_lookup_names
 function
Message-Id: <20220426190108.d9c76f5ccff52e27dbef21af@kernel.org>
In-Reply-To: <YmJPcU9dahEatb0f@krava>
References: <20220418124834.829064-1-jolsa@kernel.org>
        <20220418124834.829064-2-jolsa@kernel.org>
        <20220418233546.dfe0a1be12193c26b05cdd93@kernel.org>
        <Yl5yHVOJpCYr+T3r@krava>
        <YmJPcU9dahEatb0f@krava>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

Sorry for replying late.

On Fri, 22 Apr 2022 08:47:13 +0200
Jiri Olsa <olsajiri@gmail.com> wrote:

> On Tue, Apr 19, 2022 at 10:26:05AM +0200, Jiri Olsa wrote:
> 
> SNIP
> 
> > > > +static int kallsyms_callback(void *data, const char *name,
> > > > +			     struct module *mod, unsigned long addr)
> > > > +{
> > > > +	struct kallsyms_data *args = data;
> > > > +
> > > > +	if (!bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp))
> > > > +		return 0;
> > > > +
> > > > +	addr = ftrace_location(addr);
> > > > +	if (!addr)
> > > > +		return 0;
> > > 
> > > Ooops, wait. Did you do this last version? I missed this point.
> > > This changes the meanings of the kernel function.
> > 
> > yes, it was there before ;-) and you're right.. so some archs can
> > return different address, I did not realize that
> > 
> > > 
> > > > +
> > > > +	args->addrs[args->found++] = addr;
> > > > +	return args->found == args->cnt ? 1 : 0;
> > > > +}
> > > > +
> > > > +/**
> > > > + * kallsyms_lookup_names - Lookup addresses for array of symbols
> > > 
> > > More correctly "Lookup 'ftraced' addresses for array of sorted symbols", right?
> > > 
> > > I'm not sure, we can call it as a 'kallsyms' API, since this is using
> > > kallsyms but doesn't return symbol address, but ftrace address.
> > > I think this name misleads user to expect returning symbol address.
> > > 
> > > > + *
> > > > + * @syms: array of symbols pointers symbols to resolve, must be
> > > > + * alphabetically sorted
> > > > + * @cnt: number of symbols/addresses in @syms/@addrs arrays
> > > > + * @addrs: array for storing resulting addresses
> > > > + *
> > > > + * This function looks up addresses for array of symbols provided in
> > > > + * @syms array (must be alphabetically sorted) and stores them in
> > > > + * @addrs array, which needs to be big enough to store at least @cnt
> > > > + * addresses.
> > > 
> > > Hmm, sorry I changed my mind. I rather like to expose kallsyms_on_each_symbol()
> > > and provide this API from fprobe or ftrace, because this returns ftrace address
> > > and thus this is only used from fprobe.
> > 
> > ok, so how about:
> > 
> >   int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *addrs);
> 
> quick question.. is it ok if it stays in kalsyms.c object?

I think if this is for the ftrace API, I think it should be in the ftrace.c, and
it can remove unneeded #ifdefs in C code.

> 
> so we don't need to expose kallsyms_on_each_symbol,
> and it stays in 'kalsyms' place

We don't need to expose it to modules, but just make it into a global scope.
I don't think that doesn't cause a problem.

Thank you,

> 
> jirka
> 
> 
> 
> diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
> index ce1bd2fbf23e..177e0b13c8c5 100644
> --- a/include/linux/kallsyms.h
> +++ b/include/linux/kallsyms.h
> @@ -72,6 +72,7 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
>  #ifdef CONFIG_KALLSYMS
>  /* Lookup the address for a symbol. Returns 0 if not found. */
>  unsigned long kallsyms_lookup_name(const char *name);
> +int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *addrs);
>  
>  extern int kallsyms_lookup_size_offset(unsigned long addr,
>  				  unsigned long *symbolsize,
> @@ -103,6 +104,11 @@ static inline unsigned long kallsyms_lookup_name(const char *name)
>  	return 0;
>  }
>  
> +static inline int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *addrs);
> +{
> +	return -ERANGE;
> +}
> +
>  static inline int kallsyms_lookup_size_offset(unsigned long addr,
>  					      unsigned long *symbolsize,
>  					      unsigned long *offset)
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 79f2eb617a62..1e7136a765a9 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -29,6 +29,7 @@
>  #include <linux/compiler.h>
>  #include <linux/module.h>
>  #include <linux/kernel.h>
> +#include <linux/bsearch.h>
>  
>  /*
>   * These will be re-linked against their real values
> @@ -228,7 +229,7 @@ unsigned long kallsyms_lookup_name(const char *name)
>  	return module_kallsyms_lookup_name(name);
>  }
>  
> -#ifdef CONFIG_LIVEPATCH
> +#if defined(CONFIG_LIVEPATCH) || defined(CONFIG_FPROBE)
>  /*
>   * Iterate over all symbols in vmlinux.  For symbols from modules use
>   * module_kallsyms_on_each_symbol instead.
> @@ -572,6 +573,73 @@ int sprint_backtrace_build_id(char *buffer, unsigned long address)
>  	return __sprint_symbol(buffer, address, -1, 1, 1);
>  }
>  
> +#ifdef CONFIG_FPROBE
> +static int symbols_cmp(const void *a, const void *b)
> +{
> +	const char **str_a = (const char **) a;
> +	const char **str_b = (const char **) b;
> +
> +	return strcmp(*str_a, *str_b);
> +}
> +
> +struct kallsyms_data {
> +	unsigned long *addrs;
> +	const char **syms;
> +	size_t cnt;
> +	size_t found;
> +};
> +
> +static int kallsyms_callback(void *data, const char *name,
> +			     struct module *mod, unsigned long addr)
> +{
> +	struct kallsyms_data *args = data;
> +
> +	if (!bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp))
> +		return 0;
> +
> +	addr = ftrace_location(addr);
> +	if (!addr)
> +		return 0;
> +
> +	args->addrs[args->found++] = addr;
> +	return args->found == args->cnt ? 1 : 0;
> +}
> +
> +/**
> + * ftrace_lookup_symbols - Lookup addresses for array of symbols
> + *
> + * @sorted_syms: array of symbols pointers symbols to resolve,
> + * must be alphabetically sorted
> + * @cnt: number of symbols/addresses in @syms/@addrs arrays
> + * @addrs: array for storing resulting addresses
> + *
> + * This function looks up addresses for array of symbols provided in
> + * @syms array (must be alphabetically sorted) and stores them in
> + * @addrs array, which needs to be big enough to store at least @cnt
> + * addresses.
> + *
> + * This function returns 0 if all provided symbols are found,
> + * -ESRCH otherwise.
> + */
> +int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *addrs)
> +{
> +	struct kallsyms_data args;
> +
> +	args.addrs = addrs;
> +	args.syms = sorted_syms;
> +	args.cnt = cnt;
> +	args.found = 0;
> +	kallsyms_on_each_symbol(kallsyms_callback, &args);
> +
> +	return args.found == args.cnt ? 0 : -ESRCH;
> +}
> +#else
> +int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *addrs)
> +{
> +	return -ERANGE;
> +}
> +#endif /* CONFIG_FPROBE */
> +
>  /* To avoid using get_symbol_offset for every symbol, we carry prefix along. */
>  struct kallsym_iter {
>  	loff_t pos;


-- 
Masami Hiramatsu <mhiramat@kernel.org>
