Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14A66505B09
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 17:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243129AbiDRPbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 11:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242574AbiDRPav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 11:30:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635013467A;
        Mon, 18 Apr 2022 07:40:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAD0660FA4;
        Mon, 18 Apr 2022 14:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08C4C385A1;
        Mon, 18 Apr 2022 14:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650292799;
        bh=lVGjQiNeitfHX6Iw3+yTxPJF2qVLbXbZLtivn9dL8HI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z/3j0DiSUf+Ao6nkd41yapgoBbFIJGGLFAkGZWMBukANcXiLbbN6qlE+ZtGtrK9wi
         qMUr8KUKJdRbWUxALTxU9dWV+wIkGsBP+7vIOu7mhvF4FHBh7h6hPibFIvyqCNNgyw
         NbvNm2+zYu0nJ4FKDHHAZkL1QcSbRlgitn7o61GqJMkFkUX8JpxzHMXjPRQNelSPra
         k9N3GIkbV1JHNmLtCJf7k+g+3qVmToVyc0SFJ0AKzhgTmPZcGiEt711efcEAH4Z9Tt
         PoUt2rI2OAfO1klT+lQQ4jOohCyWm5HPcIXFoIdd1/FgTbhsj8noS3Zy+AkRfQ65lJ
         HkYxc7fSmXIXA==
Date:   Mon, 18 Apr 2022 23:39:54 +0900
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
Subject: Re: [PATCHv2 bpf-next 2/4] fprobe: Resolve symbols with
 kallsyms_lookup_names
Message-Id: <20220418233954.0b17b003759d54b81e78888b@kernel.org>
In-Reply-To: <20220418124834.829064-3-jolsa@kernel.org>
References: <20220418124834.829064-1-jolsa@kernel.org>
        <20220418124834.829064-3-jolsa@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

On Mon, 18 Apr 2022 14:48:32 +0200
Jiri Olsa <jolsa@kernel.org> wrote:

> Using kallsyms_lookup_names to speed up symbols lookup
> in register_fprobe_syms API.
> 
> This requires syms array to be alphabetically sorted.

This looks good to me. But we may need to update this for changing
the function name "kallsyms_lookup_names()". I think "ftrace_lookup_sorted_syms()"
will be better to understand.
What would you think?

Thank you,

> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/trace/fprobe.c | 32 ++++++++++++--------------------
>  1 file changed, 12 insertions(+), 20 deletions(-)
> 
> diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
> index 89d9f994ebb0..6419501a0036 100644
> --- a/kernel/trace/fprobe.c
> +++ b/kernel/trace/fprobe.c
> @@ -85,39 +85,31 @@ static void fprobe_exit_handler(struct rethook_node *rh, void *data,
>  }
>  NOKPROBE_SYMBOL(fprobe_exit_handler);
>  
> +static int symbols_cmp(const void *a, const void *b)
> +{
> +	const char **str_a = (const char **) a;
> +	const char **str_b = (const char **) b;
> +
> +	return strcmp(*str_a, *str_b);
> +}
> +
>  /* Convert ftrace location address from symbols */
>  static unsigned long *get_ftrace_locations(const char **syms, int num)
>  {
> -	unsigned long addr, size;
>  	unsigned long *addrs;
> -	int i;
>  
>  	/* Convert symbols to symbol address */
>  	addrs = kcalloc(num, sizeof(*addrs), GFP_KERNEL);
>  	if (!addrs)
>  		return ERR_PTR(-ENOMEM);
>  
> -	for (i = 0; i < num; i++) {
> -		addr = kallsyms_lookup_name(syms[i]);
> -		if (!addr)	/* Maybe wrong symbol */
> -			goto error;
> -
> -		/* Convert symbol address to ftrace location. */
> -		if (!kallsyms_lookup_size_offset(addr, &size, NULL) || !size)
> -			goto error;
> +	/* kallsyms_lookup_names expects sorted symbols */
> +	sort(syms, num, sizeof(*syms), symbols_cmp, NULL);
>  
> -		addr = ftrace_location_range(addr, addr + size - 1);
> -		if (!addr) /* No dynamic ftrace there. */
> -			goto error;
> +	if (!kallsyms_lookup_names(syms, num, addrs))
> +		return addrs;
>  
> -		addrs[i] = addr;
> -	}
> -
> -	return addrs;
> -
> -error:
>  	kfree(addrs);
> -
>  	return ERR_PTR(-ENOENT);
>  }
>  
> -- 
> 2.35.1
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
