Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B8842BF75
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 14:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbhJMMGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 08:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbhJMMGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 08:06:07 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA475C061749
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 05:04:04 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id w14so1656709pll.2
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 05:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=li/Vpn5Wu6X+Kzrsg43KbGBbRvdUem+CU3/lp/9gODE=;
        b=RgS0rKVa0G6RD32ICzRX0eQxYmA1I9+38OnSM6ouadBWD/AbbYYUNAmNfmLrkGQVhG
         FMoVTMN5lOUpvRhNODbCtTC0pmXa+Jot/F2ysZMHYMIcStpNCcNMbUMuXO/CjCm8EVEg
         Jzu0Wox51e5qznM1JP3Xnf3b+YvPXcVFAUzv8522HnIPrM9KmwUegfRJMy2tqDEgP4C5
         xGIsMdIWby0sfYrzPpa2DgS3FmzV0euV3GOOPDgg3SdD65A9Zo9mIGLG0HV+o3sWMjsl
         XRGLBcRA8pKGtT0TFP3AaXPvadXFVHijnf0UnbNOa0mMG5FEbuQA5E95LmSXg5rsj0Ji
         VfLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=li/Vpn5Wu6X+Kzrsg43KbGBbRvdUem+CU3/lp/9gODE=;
        b=uZlKrwGAP3TDie3o5sb6SAI+BXtCkM8VBxWJhgpeJm2t9hpK+/Kl/P8b9uDFmADP1J
         YFE8svapabp48R2Ex82G6rGXUnpYce5X4X4tVwJvNsbjO69FEGI88caL9ZODrgUkEmhJ
         sccek6DFFq0LjczdcbL3r6Tf7maZdLVe0dbOd00/nQx/03aBxklePWxORKasRHdHCpCs
         n2hTyjZ6A23/D+n07/Ng1M+NSIIqs4vcPzRWRxReoWJEl+OgKYdAR3dZ5+1bQnQGWeWw
         sn/+djlPswK6AWEG3wmjo1tSOoUwMzkKsCGIkDZkfwgtyTRSWGlJWXSmHYpOEQkHx7jy
         ZgDg==
X-Gm-Message-State: AOAM5333pbAfz0XLwzISr4RKHJ2u/4DmN43iXOHPdEFjNO5GRrk1D4gb
        5H1VJdy/bND2kXAe0AfxR7xERxwLb59uf8RjZ+weg8ooIu8=
X-Google-Smtp-Source: ABdhPJyneJH0chvun7R8B3JgQRb0LpvqqeyzIakwCTpmZfenmnt5T/CiwKnQ1MGObkRNnIS8AFGiQUqN5pM2mahsuq4=
X-Received: by 2002:a17:90b:1d0a:: with SMTP id on10mr12961168pjb.218.1634126644247;
 Wed, 13 Oct 2021 05:04:04 -0700 (PDT)
MIME-Version: 1.0
References: <20211012155542.827631-1-atenart@kernel.org>
In-Reply-To: <20211012155542.827631-1-atenart@kernel.org>
From:   Jonathon Reinhart <jonathon.reinhart@gmail.com>
Date:   Wed, 13 Oct 2021 08:03:39 -0400
Message-ID: <CAPFHKzfg2+cvbbbDL0Qt1LRiYKO6N+7DeNshLZXnbb6+Fo7QPQ@mail.gmail.com>
Subject: Re: [RFC net-next] net: sysctl data could be in .bss
To:     Antoine Tenart <atenart@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 11:55 AM Antoine Tenart <atenart@kernel.org> wrote:
>
> A check is made when registering non-init netns sysctl files to ensure
> their data pointer does not point to a global data section. This works
> well for modules as the check is made against the whole module address
> space (is_module_address). But when built-in, the check is made against
> the .data section. However global variables initialized to 0 can be in
> .bss (-fzero-initialized-in-bss).
>
> Add an extra check to make sure the sysctl data does not point to the
> .bss section either.
>
> Signed-off-by: Antoine Tenart <atenart@kernel.org>

Reviewed-by: Jonathon Reinhart <jonathon.reinhart@gmail.com>

> ---
>
> Hello,
>
> This is sent as an RFC as I'd like a fix[1] to be merged before to
> avoid introducing a new warning. But this can be reviewed in the
> meantime.
>
> I'm not sending this as a fix to avoid possible new warnings in stable
> kernels. (The actual fixes of sysctl files should go).
>
> I think this can go through the net-next tree as kernel/extable.c
> doesn't seem to be under any subsystem and a conflict is unlikely to
> happen.
>
> Thanks!
> Antoine
>
> [1] https://lore.kernel.org/all/20211012145437.754391-1-atenart@kernel.org/T/
>
>  include/linux/kernel.h | 1 +
>  kernel/extable.c       | 8 ++++++++
>  net/sysctl_net.c       | 2 +-
>  3 files changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 2776423a587e..beb61d0ab220 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -231,6 +231,7 @@ extern char *next_arg(char *args, char **param, char **val);
>  extern int core_kernel_text(unsigned long addr);
>  extern int init_kernel_text(unsigned long addr);
>  extern int core_kernel_data(unsigned long addr);
> +extern int core_kernel_bss(unsigned long addr);
>  extern int __kernel_text_address(unsigned long addr);
>  extern int kernel_text_address(unsigned long addr);
>  extern int func_ptr_is_kernel_text(void *ptr);
> diff --git a/kernel/extable.c b/kernel/extable.c
> index b0ea5eb0c3b4..477a4b6c8f63 100644
> --- a/kernel/extable.c
> +++ b/kernel/extable.c
> @@ -100,6 +100,14 @@ int core_kernel_data(unsigned long addr)
>         return 0;
>  }
>
> +int core_kernel_bss(unsigned long addr)
> +{
> +       if (addr >= (unsigned long)__bss_start &&
> +           addr < (unsigned long)__bss_stop)
> +               return 1;
> +       return 0;
> +}
> +
>  int __kernel_text_address(unsigned long addr)
>  {
>         if (kernel_text_address(addr))
> diff --git a/net/sysctl_net.c b/net/sysctl_net.c
> index f6cb0d4d114c..d883cf65029f 100644
> --- a/net/sysctl_net.c
> +++ b/net/sysctl_net.c
> @@ -144,7 +144,7 @@ static void ensure_safe_net_sysctl(struct net *net, const char *path,
>                 addr = (unsigned long)ent->data;
>                 if (is_module_address(addr))
>                         where = "module";
> -               else if (core_kernel_data(addr))
> +               else if (core_kernel_data(addr) || core_kernel_bss(addr))
>                         where = "kernel";
>                 else
>                         continue;
> --
> 2.31.1
>

This looks good to me. Thanks for the improvement, Antoine!

I would ask about .rodata, that would imply the use of 'const'
variables, which would be causing compiler warnings or errors. And
writes to those variables would already be crashing. So it doesn't
seem to be necessary.

(sorry for the duplicate mail; I accidentally sent HTML from mobile
the first time.)

Jonathon
