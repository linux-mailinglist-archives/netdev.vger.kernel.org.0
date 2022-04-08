Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3FA44F8CA3
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 05:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbiDHA7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 20:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233115AbiDHA7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 20:59:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E79C21A0C5;
        Thu,  7 Apr 2022 17:57:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B26546191A;
        Fri,  8 Apr 2022 00:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C8EC385A0;
        Fri,  8 Apr 2022 00:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649379427;
        bh=Zb8Ic9D/QGxYAR4I8vqLiookiKbN5j2NfKA35yV3Y4g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bR3dbSBunB2p3hCsRHMiS+KD/yImN50pTPIlRWD7cGnLF4JMZm2tE4qOQPAEdj8Lt
         49W4CwsvIftzvfWF8cux5e38yanGKWkAZXAq6JE6qYQYb5a6tkwgp8AfE+4+/+DRur
         CVh8hx4XzPj2wJqtIMKePNs+dkQNdr/JVlw6bgkknX+0IZ69Qnp4vvHPTQvAJMS4uS
         0KrcVKZJdADIc0RQ7zAddqsDlKrYM2SRKclPc4YAGb8kWKQQm9N6+SeXokyHlIhC4c
         AvtMxJ54VVHZNnk6I3wkug/Yos+9HA4e1Scg7PcdbY6cmLCd3OIwxmMDlmQWRMNv0z
         Z4iaym/DSKMZw==
Date:   Fri, 8 Apr 2022 09:57:01 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC bpf-next 1/4] kallsyms: Add kallsyms_lookup_names function
Message-Id: <20220408095701.54aea15c3cafcf66dd628a95@kernel.org>
In-Reply-To: <20220407125224.310255-2-jolsa@kernel.org>
References: <20220407125224.310255-1-jolsa@kernel.org>
        <20220407125224.310255-2-jolsa@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Apr 2022 14:52:21 +0200
Jiri Olsa <jolsa@kernel.org> wrote:

> Adding kallsyms_lookup_names function that resolves array of symbols
> with single pass over kallsyms.
> 
> The user provides array of string pointers with count and pointer to
> allocated array for resolved values.
> 
>   int kallsyms_lookup_names(const char **syms, u32 cnt,
>                             unsigned long *addrs)
> 
> Before we iterate kallsyms we sort user provided symbols by name and
> then use that in kalsyms iteration to find each kallsyms symbol in
> user provided symbols.
> 
> We also check each symbol to pass ftrace_location, because this API
> will be used for fprobe symbols resolving. This can be optional in
> future if there's a need.

I like this idea very much :-)

> 
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/kallsyms.h |  6 +++++
>  kernel/kallsyms.c        | 48 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 54 insertions(+)
> 
> diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
> index ce1bd2fbf23e..5320a5e77f61 100644
> --- a/include/linux/kallsyms.h
> +++ b/include/linux/kallsyms.h
> @@ -72,6 +72,7 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
>  #ifdef CONFIG_KALLSYMS
>  /* Lookup the address for a symbol. Returns 0 if not found. */
>  unsigned long kallsyms_lookup_name(const char *name);
> +int kallsyms_lookup_names(const char **syms, u32 cnt, unsigned long *addrs);
>  
>  extern int kallsyms_lookup_size_offset(unsigned long addr,
>  				  unsigned long *symbolsize,
> @@ -103,6 +104,11 @@ static inline unsigned long kallsyms_lookup_name(const char *name)
>  	return 0;
>  }
>  
> +int kallsyms_lookup_names(const char **syms, u32 cnt, unsigned long *addrs)
> +{
> +	return -ERANGE;
> +}
> +
>  static inline int kallsyms_lookup_size_offset(unsigned long addr,
>  					      unsigned long *symbolsize,
>  					      unsigned long *offset)
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 79f2eb617a62..a3738ddf9e87 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -29,6 +29,8 @@
>  #include <linux/compiler.h>
>  #include <linux/module.h>
>  #include <linux/kernel.h>
> +#include <linux/bsearch.h>
> +#include <linux/sort.h>
>  
>  /*
>   * These will be re-linked against their real values
> @@ -572,6 +574,52 @@ int sprint_backtrace_build_id(char *buffer, unsigned long address)
>  	return __sprint_symbol(buffer, address, -1, 1, 1);
>  }
>  
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
> +	u32 cnt;
> +	u32 found;

BTW, why do you use 'u32' for this arch independent code?
I think 'size_t' will make its role clearer.

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
> +int kallsyms_lookup_names(const char **syms, u32 cnt, unsigned long *addrs)

Ditto. I think 'size_t cnt' is better. 

Thank you,

> +{
> +	struct kallsyms_data args;
> +
> +	sort(syms, cnt, sizeof(*syms), symbols_cmp, NULL);
> +
> +	args.addrs = addrs;
> +	args.syms = syms;
> +	args.cnt = cnt;
> +	args.found = 0;
> +	kallsyms_on_each_symbol(kallsyms_callback, &args);
> +
> +	return args.found == args.cnt ? 0 : -EINVAL;
> +}
> +
>  /* To avoid using get_symbol_offset for every symbol, we carry prefix along. */
>  struct kallsym_iter {
>  	loff_t pos;
> -- 
> 2.35.1
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
