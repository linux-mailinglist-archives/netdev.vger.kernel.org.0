Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA6A273D21
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 10:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgIVIUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 04:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726649AbgIVIUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 04:20:38 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCAE5C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 01:20:38 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id n61so14829171ota.10
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 01:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+rsWj68RA4wQ7u5KrSVR8S7HYRcYE1Yovc/+7u5unFY=;
        b=xEvlnbAaIWitP9Zj+ZLirpTk1NGfBUMlipCMEH23/frR+vIOSpX3RWP/7l4VaGhNeG
         ZmNvhdthdbsugD5k9fzcf5/k6nSDoNpQlcE8imOqE0ZHM9UQJOiELeu8bsCCL3dK8lnf
         D9BnqukI8uQXu27TzB59H1GbbDnioCXZDOZFA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+rsWj68RA4wQ7u5KrSVR8S7HYRcYE1Yovc/+7u5unFY=;
        b=HoSyliOQuq5E4zT4akgKgsshg5pkJ/adCh6en2ZGwiSZO35nS20VIoKuBHuqYdKNT0
         KtgEs0Nzb8AHymxys+mDGwN0qSv9evkkRTofjbZRoRGgwSeBVz9x1ouEgYArFWC3AcUv
         rdPJGiCRxLR4ViuedtF0J8AwV7kv4YhN62BnVsctcrto3R696pUUxRparsEIDBvLcq4s
         /5ibME4G7kBvlG0axkRD6N7oDMsfI6jB2kUqr19nYM1H8Tys3J6JyoQMsg5mKt0XKfaX
         zlPleYfWOqiJ4kZM73hnwkD5EwrGke/s9hZxrx5kOxII0QO0nExu32xrWaOvVRtgmoWm
         1NUw==
X-Gm-Message-State: AOAM532KnQjWRY7ow5kj/bi2w0FppkOv6bha7mpc9SM/MemPzAA0C1VV
        q9+KGitxs2X6GlKZqSpJraCz8HQ5r7X339lV/uKfC2NREB3UQQ==
X-Google-Smtp-Source: ABdhPJx+Ibj27xrQ/pVHYEsXp9Gg2b/icbP9ZB1eWaqKaKdTa5A0x0G8urpZu3Nm0R6F6HrFtU6HwqjO5D6gBjeuN98=
X-Received: by 2002:a05:6830:1653:: with SMTP id h19mr1916290otr.147.1600762838090;
 Tue, 22 Sep 2020 01:20:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200921121227.255763-1-lmb@cloudflare.com> <20200921121227.255763-12-lmb@cloudflare.com>
 <20200921222335.lew7wmyrtuej5mrh@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200921222335.lew7wmyrtuej5mrh@ast-mbp.dhcp.thefacebook.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 22 Sep 2020 09:20:27 +0100
Message-ID: <CACAyw98XfkMy4TDFnHBCFzXxauLrZ56w+84-R_NQO1SLMgPJYA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 11/11] bpf: use a table to drive helper arg
 type checks
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Sep 2020 at 23:23, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Sep 21, 2020 at 01:12:27PM +0100, Lorenz Bauer wrote:
> > +struct bpf_reg_types {
> > +     const enum bpf_reg_type types[10];
> > +};
>
> any idea on how to make it more robust?

I kind of copied this from the bpf_iter context. I prototyped using an
enum bpf_reg_type * and then terminating the array with NOT_INIT.
Writing this out is more involved, and might need some macro magic to
make it palatable. The current approach is a lot simpler, and I
figured that the compiler will error out if we ever exceed the 10
items.

>
> > +
> > +static const struct bpf_reg_types *compatible_reg_types[] = {
> > +     [ARG_PTR_TO_MAP_KEY]            = &map_key_value_types,
> > +     [ARG_PTR_TO_MAP_VALUE]          = &map_key_value_types,
> > +     [ARG_PTR_TO_UNINIT_MAP_VALUE]   = &map_key_value_types,
> > +     [ARG_PTR_TO_MAP_VALUE_OR_NULL]  = &map_key_value_types,
> > +     [ARG_CONST_SIZE]                = &scalar_types,
> > +     [ARG_CONST_SIZE_OR_ZERO]        = &scalar_types,
> > +     [ARG_CONST_ALLOC_SIZE_OR_ZERO]  = &scalar_types,
> > +     [ARG_CONST_MAP_PTR]             = &const_map_ptr_types,
> > +     [ARG_PTR_TO_CTX]                = &context_types,
> > +     [ARG_PTR_TO_CTX_OR_NULL]        = &context_types,
> > +     [ARG_PTR_TO_SOCK_COMMON]        = &sock_types,
> > +     [ARG_PTR_TO_SOCKET]             = &fullsock_types,
> > +     [ARG_PTR_TO_SOCKET_OR_NULL]     = &fullsock_types,
> > +     [ARG_PTR_TO_BTF_ID]             = &btf_ptr_types,
> > +     [ARG_PTR_TO_SPIN_LOCK]          = &spin_lock_types,
> > +     [ARG_PTR_TO_MEM]                = &mem_types,
> > +     [ARG_PTR_TO_MEM_OR_NULL]        = &mem_types,
> > +     [ARG_PTR_TO_UNINIT_MEM]         = &mem_types,
> > +     [ARG_PTR_TO_ALLOC_MEM]          = &alloc_mem_types,
> > +     [ARG_PTR_TO_ALLOC_MEM_OR_NULL]  = &alloc_mem_types,
> > +     [ARG_PTR_TO_INT]                = &int_ptr_types,
> > +     [ARG_PTR_TO_LONG]               = &int_ptr_types,
> > +     [__BPF_ARG_TYPE_MAX]            = NULL,
>
> I don't understand what this extra value is for.
> I tried:
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index fc5c901c7542..87b0d5dcc1ff 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -292,7 +292,6 @@ enum bpf_arg_type {
>         ARG_PTR_TO_ALLOC_MEM,   /* pointer to dynamically allocated memory */
>         ARG_PTR_TO_ALLOC_MEM_OR_NULL,   /* pointer to dynamically allocated memory or NULL */
>         ARG_CONST_ALLOC_SIZE_OR_ZERO,   /* number of allocated bytes requested */
> -       __BPF_ARG_TYPE_MAX,
>  };
>
>  /* type of values returned from helper functions */
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 15ab889b0a3f..83faa67858b6 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -4025,7 +4025,6 @@ static const struct bpf_reg_types *compatible_reg_types[] = {
>         [ARG_PTR_TO_ALLOC_MEM_OR_NULL]  = &alloc_mem_types,
>         [ARG_PTR_TO_INT]                = &int_ptr_types,
>         [ARG_PTR_TO_LONG]               = &int_ptr_types,
> -       [__BPF_ARG_TYPE_MAX]            = NULL,
>  };
>
> and everything is fine as I think it should be.
>
> > +     compatible = compatible_reg_types[arg_type];
> > +     if (!compatible) {
> > +             verbose(env, "verifier internal error: unsupported arg type %d\n", arg_type);
> >               return -EFAULT;
> >       }
>
> This check will trigger the same way when somebody adds new ARG_* and doesn't add to the table.

I think in that case that value of compatible will be undefined, since
it points past the end of compatible_reg_types. Hence the
__BPF_ARG_TYPE_MAX to ensure that the array has a NULL slot for new
arg types.

>
> >
> > +     err = check_reg_type(env, regno, compatible);
> > +     if (err)
> > +             return err;
> > +
> >       if (type == PTR_TO_BTF_ID) {
> >               const u32 *btf_id = fn->arg_btf_id[arg];
> >
> > @@ -4174,10 +4213,6 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
> >       }
> >
> >       return err;
> > -err_type:
> > -     verbose(env, "R%d type=%s expected=%s\n", regno,
> > -             reg_type_str[type], reg_type_str[expected_type]);
> > -     return -EACCES;
>
> I'm not a fan of table driven checks. I think one explicit switch statement
> would have been easier to read, but I guess we can convert back to it later if
> table becomes too limiting. The improvement in the verifier output is important
> and justifies this approach.
>
> Applied to bpf-next. Thanks!

Thank you!

--
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
