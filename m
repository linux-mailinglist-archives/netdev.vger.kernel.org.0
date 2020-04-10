Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5B601A4B1B
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 22:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgDJU0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 16:26:21 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35094 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgDJU0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 16:26:20 -0400
Received: by mail-pf1-f196.google.com with SMTP id a13so1492799pfa.2
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 13:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pcawoXzVUnVmK13P4l97Pnws9LJgqOmSgo+Ma/dSWps=;
        b=Rb6Q1NVncgv/6LrQjHpG/fCd/Eq6dDMbjtn14iX378Is2HtKxpf1KzcdRcUJQKpAjE
         3jcUokjzBmfZ9DcloypWm67fUYTHSXQ6SvuNJv4raI7UAROw25onxDiiZ9BSo6QulpKp
         4p05bqg7iV9Mh551htKgXjmTu+kRXOvAM+ZfI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pcawoXzVUnVmK13P4l97Pnws9LJgqOmSgo+Ma/dSWps=;
        b=cgP0kf/+ACGKr6c8z2uCOCG2CrfWjxrR2y5Vx7RnacX3O/1E++GISx5vjAvSvvhJ/t
         PAHy4FpTKw6cUu7kNwXIJjtubFVE8Lp/pS5wsMx7/HH35I7OCtZJ1JfKUKQX/64sLTS+
         DEsKuvgO5JnotnsXKJmgqVZneXtEjlFk/73GCFPka7u4p+XOKKBFsTggC44703ED6i6b
         VTlRupgiddj3mAnnLaG1ZNwwMsVGk3LfyxpgjrGpLCf/IwU9AJkBR41x9hFyOkmScf87
         pJnjGw33YaKC8WAJku7uj5/SZxOUlqcZcZ6ivgfxVILDW80ooUYz342m59Cyv2/Ecutq
         rUEw==
X-Gm-Message-State: AGi0Pub12jiGPbMKKpBRjhLhqKwuQ1kgO2MXPzwruoQ649oF97uI4nBz
        QgFmwDzt/+Za3DRMRh6GAuYdQA==
X-Google-Smtp-Source: APiQypK9ltyvL2bWmmEFCII0i4yr4OAUIQsB6jy+736q8Ru3rDmgBOTO/4ND99RcHfaRdLuItB72Rw==
X-Received: by 2002:aa7:9f98:: with SMTP id z24mr6906759pfr.122.1586550380256;
        Fri, 10 Apr 2020 13:26:20 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u13sm2582831pjb.45.2020.04.10.13.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2020 13:26:19 -0700 (PDT)
Date:   Fri, 10 Apr 2020 13:26:18 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        luto@amacapital.net, wad@chromium.org, shuah@kernel.org
Subject: Re: [PATCH] selftests/seccomp: allow clock_nanosleep instead of
 nanosleep
Message-ID: <202004101325.CF69610F77@keescook>
References: <20200408235753.8566-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408235753.8566-1-cascardo@canonical.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 08, 2020 at 08:57:53PM -0300, Thadeu Lima de Souza Cascardo wrote:
> glibc 2.31 calls clock_nanosleep when its nanosleep function is used. So
> the restart_syscall fails after that. In order to deal with it, we trace
> clock_nanosleep and nanosleep. Then we check for either.
> 
> This works just fine on systems with both glibc 2.30 and glibc 2.31,
> whereas it failed before on a system with glibc 2.31.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

Thanks for this! I'm trying to determine if all architectures have
__NR_clock_nanosleep ... got some test builds running now, but if it all
builds fine, then I'll get this sent to Linus for -rc2.

-Kees

> ---
>  tools/testing/selftests/seccomp/seccomp_bpf.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
> index 89fb3e0b552e..c0aa46ce14f6 100644
> --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
> +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
> @@ -2803,12 +2803,13 @@ TEST(syscall_restart)
>  			 offsetof(struct seccomp_data, nr)),
>  
>  #ifdef __NR_sigreturn
> -		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_sigreturn, 6, 0),
> +		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_sigreturn, 7, 0),
>  #endif
> -		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_read, 5, 0),
> -		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_exit, 4, 0),
> -		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_rt_sigreturn, 3, 0),
> -		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_nanosleep, 4, 0),
> +		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_read, 6, 0),
> +		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_exit, 5, 0),
> +		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_rt_sigreturn, 4, 0),
> +		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_nanosleep, 5, 0),
> +		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_clock_nanosleep, 4, 0),
>  		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_restart_syscall, 4, 0),
>  
>  		/* Allow __NR_write for easy logging. */
> @@ -2895,7 +2896,8 @@ TEST(syscall_restart)
>  	ASSERT_EQ(PTRACE_EVENT_SECCOMP, (status >> 16));
>  	ASSERT_EQ(0, ptrace(PTRACE_GETEVENTMSG, child_pid, NULL, &msg));
>  	ASSERT_EQ(0x100, msg);
> -	EXPECT_EQ(__NR_nanosleep, get_syscall(_metadata, child_pid));
> +	ret = get_syscall(_metadata, child_pid);
> +	EXPECT_TRUE(ret == __NR_nanosleep || ret == __NR_clock_nanosleep);
>  
>  	/* Might as well check siginfo for sanity while we're here. */
>  	ASSERT_EQ(0, ptrace(PTRACE_GETSIGINFO, child_pid, NULL, &info));
> -- 
> 2.20.1
> 

-- 
Kees Cook
