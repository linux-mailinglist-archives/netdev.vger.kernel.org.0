Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD424F8CA9
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 05:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbiDHBA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 21:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233205AbiDHBA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 21:00:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8901030C206;
        Thu,  7 Apr 2022 17:58:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 70F8FCE29EC;
        Fri,  8 Apr 2022 00:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA37AC385A0;
        Fri,  8 Apr 2022 00:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649379500;
        bh=RnBqrO05wig0Mia6VfsR65TYl3CuXN2/hell+ZhumPM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pgxzGhdEl3K3/DLBH0PVog7yDE1sPRdYQTj22pnBvD8EeEEiWJ17jps9bM3WxhN3x
         xf9jYu/QZ+pjhhik8wL252/US+TpoVA/i0gKwxF4KyYz7sJPRAB2umgbuCz4rfKg0g
         HWGhOFDBtCRRP3noX+JXI86TVEcSwOiea3fcfiXXnPfdojcvbCRvHr+/7Tys/nYbaJ
         D3aaL48ElX0s97jqMNewjsnQQbr8mXd8s3GqO237aV/bP/XyP/BgiMaWzMs70qExx3
         lDnpuAR1OUBg8QZdA5RK5OD7hp+ZTM8gFYqdEidDFgTXoBbq0ao+dckHoqbx65B2ed
         DbezCPa2sabTA==
Date:   Fri, 8 Apr 2022 09:58:15 +0900
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
Subject: Re: [RFC bpf-next 2/4] fprobe: Resolve symbols with
 kallsyms_lookup_names
Message-Id: <20220408095815.9827bcf7aa98127046f69481@kernel.org>
In-Reply-To: <20220407125224.310255-3-jolsa@kernel.org>
References: <20220407125224.310255-1-jolsa@kernel.org>
        <20220407125224.310255-3-jolsa@kernel.org>
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

On Thu,  7 Apr 2022 14:52:22 +0200
Jiri Olsa <jolsa@kernel.org> wrote:

> Using kallsyms_lookup_names to speed up symbols lookup
> in register_fprobe_syms API.

OK, this looks good to me.

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>

Thank you!

> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/kallsyms.c     |  2 +-
>  kernel/trace/fprobe.c | 23 ++---------------------
>  2 files changed, 3 insertions(+), 22 deletions(-)
> 
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index a3738ddf9e87..7d89da375c23 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -230,7 +230,7 @@ unsigned long kallsyms_lookup_name(const char *name)
>  	return module_kallsyms_lookup_name(name);
>  }
>  
> -#ifdef CONFIG_LIVEPATCH
> +#if defined(CONFIG_LIVEPATCH) || defined(CONFIG_FPROBE)
>  /*
>   * Iterate over all symbols in vmlinux.  For symbols from modules use
>   * module_kallsyms_on_each_symbol instead.
> diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
> index 89d9f994ebb0..d466803dc2b2 100644
> --- a/kernel/trace/fprobe.c
> +++ b/kernel/trace/fprobe.c
> @@ -88,36 +88,17 @@ NOKPROBE_SYMBOL(fprobe_exit_handler);
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
> +	if (!kallsyms_lookup_names(syms, num, addrs))
> +		return addrs;
>  
> -		/* Convert symbol address to ftrace location. */
> -		if (!kallsyms_lookup_size_offset(addr, &size, NULL) || !size)
> -			goto error;
> -
> -		addr = ftrace_location_range(addr, addr + size - 1);
> -		if (!addr) /* No dynamic ftrace there. */
> -			goto error;
> -
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
