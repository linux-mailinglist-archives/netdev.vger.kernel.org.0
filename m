Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440F7514E75
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 16:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378011AbiD2O6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 10:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378009AbiD2O6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 10:58:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C167BE9F2;
        Fri, 29 Apr 2022 07:54:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 267C8B835DD;
        Fri, 29 Apr 2022 14:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4F5C385A4;
        Fri, 29 Apr 2022 14:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651244085;
        bh=hrsovH+LFFku1FXppgR3a5Fig56Iz/nETCoLPh/sA/8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GujnCsDyMGYSxhrbrnfHBbgpLaxpVw/hFIqzVYZrB30YCJQeJM1PYc7i9NfEOup82
         j2kFnB0FUF/2nw+6yM2dMkOvf1fdO1q4No97pdrKzFCyH7rngr1m+Jsw6bkazCjvJT
         0nhM+mCHHCFwD7cx7bxM/BuH/aZig7R2v5Kb+UetPtbI22pajNvG5PvKmuRWRs83ou
         Jt/xLsMv7eriHRQGnmpHkAdP7bUQN1CpeTZrx7o7TxRtOxSzMqMQTpBcicbkNqiCkk
         pxeQpugNfoDnfiIn56auMdZPR//8ucBuFlZ3t/4fuEH6AB4FABPR3i3ugzEl2eDiRi
         olX4NjQn4AckA==
Date:   Fri, 29 Apr 2022 23:54:40 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCHv4 bpf-next 3/5] fprobe: Resolve symbols with
 ftrace_lookup_symbols
Message-Id: <20220429235440.58aa5045a507e79230a7ac86@kernel.org>
In-Reply-To: <20220428201207.954552-4-jolsa@kernel.org>
References: <20220428201207.954552-1-jolsa@kernel.org>
        <20220428201207.954552-4-jolsa@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Apr 2022 22:12:05 +0200
Jiri Olsa <jolsa@kernel.org> wrote:

> Using ftrace_lookup_symbols to speed up symbols lookup
> in register_fprobe_syms API.
> 
> This requires syms array to be alphabetically sorted.

This line is no more needed because get_ftrace_locations sorts the syms.
Except for that, this looks good to me.

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>

Thanks!

> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/trace/fprobe.c | 32 ++++++++++++--------------------
>  1 file changed, 12 insertions(+), 20 deletions(-)
> 
> diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
> index 89d9f994ebb0..aac63ca9c3d1 100644
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
> +	/* ftrace_lookup_symbols expects sorted symbols */
> +	sort(syms, num, sizeof(*syms), symbols_cmp, NULL);
>  
> -		addr = ftrace_location_range(addr, addr + size - 1);
> -		if (!addr) /* No dynamic ftrace there. */
> -			goto error;
> +	if (!ftrace_lookup_symbols(syms, num, addrs))
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
