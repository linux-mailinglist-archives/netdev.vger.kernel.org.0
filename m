Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 990D918231F
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 21:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387471AbgCKUGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 16:06:38 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36889 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387448AbgCKUGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 16:06:37 -0400
Received: by mail-pl1-f196.google.com with SMTP id f16so1595485plj.4
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 13:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=++5B0kFRrjAGwY1Pe388z5375HPFD4iEhCYSO75vU9k=;
        b=d7K69vo1bhwMw4HUPNraxkxEDAvA63FgjV5gB6GbslC680eWufo5K6jlOXYSNUy5w/
         E9tlsJ0ehHvi6PE7Niu4XjXz9RFah90G7btm8mbFIiRNJD7x8jHwKTo2zT5whrDZ0X5T
         dELIHgYrIolfYS/CXnML26PUrUSP+338rgp6k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=++5B0kFRrjAGwY1Pe388z5375HPFD4iEhCYSO75vU9k=;
        b=oF6l6Nbr+YKEXG5X/Xj0tWa+gMhJRIimoJyzJKm9cRoJBGPkQMdPheNnR5OUmKl4oh
         r16RO+0vMz+6aKS370bIygEr8OBJo+g5wnIDZmYPw4udN8saBmLYf1k/FN0RNxpDy7cZ
         w0dVB9we7vhi/teVtDcxiJjaPpxMV0HTgBoLhNbz6GewSxckYgcwtHj6MlUqSigdpTpT
         iy7ju12UnEWybfocfy15DksfLBWjVQkTkRvvQ5sfg2/AIUsOdawVErtw9AuHix8SDS74
         Jacm7trZBYHg3HcmDiF+zFt7KbrzmfpGxamPquPvc85vWbH+Du7zhK7Q9ZgRkNKDocRW
         MmuA==
X-Gm-Message-State: ANhLgQ0GPG/44xQjPn5YTZEF+MvxfP3tY90kN8SlZlAMCj+55UZaylv+
        tL5a8fDQSAZax7Owi0ggf1o7YA==
X-Google-Smtp-Source: ADFU+vsd+Vncz158ZMcxoxWjS4PIk1+al05cPYka23A9zMuWMmHh26nb2njwtfyNobXmcY9VjFFhVQ==
X-Received: by 2002:a17:902:7618:: with SMTP id k24mr4601393pll.320.1583957195759;
        Wed, 11 Mar 2020 13:06:35 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id m12sm6440567pjf.25.2020.03.11.13.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 13:06:34 -0700 (PDT)
Date:   Wed, 11 Mar 2020 13:06:33 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Sven Schnelle <svens@linux.ibm.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] seccomp: add compat_ioctl for seccomp notify
Message-ID: <202003111305.87B2A84A@keescook>
References: <20200310123332.42255-1-svens@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310123332.42255-1-svens@linux.ibm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 01:33:32PM +0100, Sven Schnelle wrote:
> Hi,
> 
> executing the seccomp_bpf testsuite with 32 bit userland (both s390 and x86)
> doesn't work because there's no compat_ioctl handler defined. Is that something
> that is supposed to work? Disclaimer: I don't know enough about seccomp to judge
> whether there would be some adjustments required in the compat ioctl handler.
> Just setting it to seccomp_notify_ioctl() makes the testsuite pass, but i'm not
> sure whether that's correct.
> 
> Signed-off-by: Sven Schnelle <svens@linux.ibm.com>

Whoops! Yes, running a mixed environment (64-bit kernel and 32-bit
userspace) shows this as broken. I'll tweak the commit log a bit and
apply it. Thanks!

-Kees

> ---
>  kernel/seccomp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index b6ea3dcb57bf..683c81e4861e 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -1221,6 +1221,7 @@ static const struct file_operations seccomp_notify_ops = {
>  	.poll = seccomp_notify_poll,
>  	.release = seccomp_notify_release,
>  	.unlocked_ioctl = seccomp_notify_ioctl,
> +	.compat_ioctl = seccomp_notify_ioctl,
>  };
>  
>  static struct file *init_listener(struct seccomp_filter *filter)
> -- 
> 2.17.1
> 

-- 
Kees Cook
