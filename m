Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9268E3B9562
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 19:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232766AbhGARWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 13:22:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229949AbhGARWs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 13:22:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CBA961406;
        Thu,  1 Jul 2021 17:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625160017;
        bh=vFNQSZ6n/Twg5RyCG/BGeZ7teVzZyqjvOrQsP/LFtG8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P94t7cQAuSQqXCrjmnh+s+7Jk0lVVMg3K2NInzWULuobktsJnAU/C6VVT49PTTZLv
         +tk6354FcpzQ7C5AmMftBytIKGNSVhcJ3iXCiQ3tomWcvXPvClClmL9GiHfY5Necez
         jiyMDYl5JRi/3NL9v9Nfbd/xNpaDmNJl28c8rDpkWP5yNTa4rV0+rPUUQaQhgwVQmt
         WSQp3EuDJUKdjV7/FPBxu7jAUO9pjWiyG1M9T3LXBw8kLbqE+nTNWzOwMGFVOenmvL
         gyaLBGnUQ37wsHZInaeckHswSyJaTs2ILdpkaI1O2p7OJmk9JsIL4OAJ+Lc4BEdvug
         PNRcLACazMNmw==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 56B4C40B1A; Thu,  1 Jul 2021 14:20:13 -0300 (-03)
Date:   Thu, 1 Jul 2021 14:20:13 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Zhihao Cheng <chengzhihao1@huawei.com>
Cc:     peterz@infradead.org, mingo@redhat.com, jolsa@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, yukuai3@huawei.com
Subject: Re: [PATCH] perf llvm: Fix error return code in llvm__compile_bpf()
Message-ID: <YN35TYxboEdM5iHc@kernel.org>
References: <20210609115945.2193194-1-chengzhihao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609115945.2193194-1-chengzhihao1@huawei.com>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Jun 09, 2021 at 07:59:45PM +0800, Zhihao Cheng escreveu:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.

I checked and llvm__compile_bpf() returns -errno, so I'll change this to
instead set err to -ENOMEM just before the if (asprintf)(), ok?

- Arnaldo
 
> Fixes: cb76371441d098 ("perf llvm: Allow passing options to llc ...")
> Fixes: 5eab5a7ee032ac ("perf llvm: Display eBPF compiling command ...")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
> ---
>  tools/perf/util/llvm-utils.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/util/llvm-utils.c b/tools/perf/util/llvm-utils.c
> index 3ceaf7ef3301..2de02639fb67 100644
> --- a/tools/perf/util/llvm-utils.c
> +++ b/tools/perf/util/llvm-utils.c
> @@ -504,8 +504,9 @@ int llvm__compile_bpf(const char *path, void **p_obj_buf,
>  			goto errout;
>  		}
>  
> -		if (asprintf(&pipe_template, "%s -emit-llvm | %s -march=bpf %s -filetype=obj -o -",
> -			      template, llc_path, opts) < 0) {
> +		err = asprintf(&pipe_template, "%s -emit-llvm | %s -march=bpf %s -filetype=obj -o -",
> +			       template, llc_path, opts);
> +		if (err < 0) {
>  			pr_err("ERROR:\tnot enough memory to setup command line\n");
>  			goto errout;
>  		}
> @@ -524,7 +525,8 @@ int llvm__compile_bpf(const char *path, void **p_obj_buf,
>  
>  	pr_debug("llvm compiling command template: %s\n", template);
>  
> -	if (asprintf(&command_echo, "echo -n \"%s\"", template) < 0)
> +	err = asprintf(&command_echo, "echo -n \"%s\"", template);
> +	if (err < 0)
>  		goto errout;
>  
>  	err = read_from_pipe(command_echo, (void **) &command_out, NULL);
> -- 
> 2.31.1
> 

-- 

- Arnaldo
