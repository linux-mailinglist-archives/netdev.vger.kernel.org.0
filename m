Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350342754B7
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 11:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgIWJp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 05:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbgIWJp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 05:45:59 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54486C0613D1
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 02:45:59 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id a3so24410398oib.4
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 02:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LwMsUeBd+G9eZvV7G728hJKAOACTxJ6wnFY8hoF+sPM=;
        b=mVKqozgkckjUzmVlvkngomLbjL46mOmJQ1iUNNlR/btaKVMdcuChuwGQ3L5bidP4a2
         A7KU4zQYz+kiNj0e4j+iy2za7V50yfuZ6ei4I9lDl3xky2apHxHWnQrCXT/s/1UyUhsy
         UVXj+W2Vrp5neaRUQH3RuVVNST94ZAscRsSHY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LwMsUeBd+G9eZvV7G728hJKAOACTxJ6wnFY8hoF+sPM=;
        b=nZzUIELL01lyowokaILOY7zgiK8iVnk95RrU1JeeBvOgo46GhUiB4TF4rLoNSYyLEA
         nxEMDPu57lITuTuRhRvPucgI100ntEV+F34txjr4jaovs5/C2MuDjZwY5M/PqPJqolUE
         OnFtGr/g/MZ33bOQnDVWVxTvwOK3Vun9vQjqtBWw7DYWZmZbw+jlBLHQ3luOE1XI/hqc
         Bh2++/PTVRJzqJ+A6GpzP/4n2LdQ4vk+OXeY09unlGybkUfwM5Xg9ndFQ5bQrCEl1Gy1
         kCnps7NIRUkWUcOz/NyLJeK4Ipl84lkpqC0+wKvaX0nOY1EtDNRZXhVhOoECJjXRjG/l
         bXsQ==
X-Gm-Message-State: AOAM531Vw0QhZaEtcvsof7mIN/2WTZXcqnmUPojGHl2YoIWXogi8hR7Z
        dsXgc+4GBiaHTww/Fl2IlIpnA4GfPVB+6JAvpThqfw==
X-Google-Smtp-Source: ABdhPJyj2KqBmE0ZXvOB4e+TZKN4fH3t67HhewU7IVXnI2pqV+7uM14DYq7/LtIRMQpJkV0fcZxFxqn2omlUp69/eEs=
X-Received: by 2002:aca:f0a:: with SMTP id 10mr5327263oip.13.1600854358609;
 Wed, 23 Sep 2020 02:45:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200921121227.255763-1-lmb@cloudflare.com> <20200921121227.255763-12-lmb@cloudflare.com>
 <20200921222335.lew7wmyrtuej5mrh@ast-mbp.dhcp.thefacebook.com>
 <CACAyw98XfkMy4TDFnHBCFzXxauLrZ56w+84-R_NQO1SLMgPJYA@mail.gmail.com> <20200922200748.gv6x6yhkyxnbqxx4@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200922200748.gv6x6yhkyxnbqxx4@ast-mbp.dhcp.thefacebook.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 23 Sep 2020 10:45:47 +0100
Message-ID: <CACAyw9-K15TMNzWkg3PtFt47X2iQCD9fwbUaVdF2jJZn3poZ3A@mail.gmail.com>
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

On Tue, 22 Sep 2020 at 21:07, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Sep 22, 2020 at 09:20:27AM +0100, Lorenz Bauer wrote:
> > On Mon, 21 Sep 2020 at 23:23, Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Mon, Sep 21, 2020 at 01:12:27PM +0100, Lorenz Bauer wrote:
> > > > +struct bpf_reg_types {
> > > > +     const enum bpf_reg_type types[10];
> > > > +};
> > >
> > > any idea on how to make it more robust?
> >
> > I kind of copied this from the bpf_iter context. I prototyped using an
> > enum bpf_reg_type * and then terminating the array with NOT_INIT.
> > Writing this out is more involved, and might need some macro magic to
> > make it palatable. The current approach is a lot simpler, and I
> > figured that the compiler will error out if we ever exceed the 10
> > items.
>
> The compiler will be silent if number of types is exactly 10,
> but at run-time the loop will access out of bounds.

Which loop do you refer to?

The one in check_reg_type shouldn't go out of bounds due to ARRAY_SIZE:

    for (i = 0; i < ARRAY_SIZE(compatible->types); i++) {
        expected = compatible->types[i];
        if (expected == NOT_INIT)
            break;

>
> > >
> > > > +
> > > > +static const struct bpf_reg_types *compatible_reg_types[] = {
> > > > +     [ARG_PTR_TO_MAP_KEY]            = &map_key_value_types,
> > > > +     [ARG_PTR_TO_MAP_VALUE]          = &map_key_value_types,
> > > > +     [ARG_PTR_TO_UNINIT_MAP_VALUE]   = &map_key_value_types,
> > > > +     [ARG_PTR_TO_MAP_VALUE_OR_NULL]  = &map_key_value_types,
> > > > +     [ARG_CONST_SIZE]                = &scalar_types,
> > > > +     [ARG_CONST_SIZE_OR_ZERO]        = &scalar_types,
> > > > +     [ARG_CONST_ALLOC_SIZE_OR_ZERO]  = &scalar_types,
> > > > +     [ARG_CONST_MAP_PTR]             = &const_map_ptr_types,
> > > > +     [ARG_PTR_TO_CTX]                = &context_types,
> > > > +     [ARG_PTR_TO_CTX_OR_NULL]        = &context_types,
> > > > +     [ARG_PTR_TO_SOCK_COMMON]        = &sock_types,
> > > > +     [ARG_PTR_TO_SOCKET]             = &fullsock_types,
> > > > +     [ARG_PTR_TO_SOCKET_OR_NULL]     = &fullsock_types,
> > > > +     [ARG_PTR_TO_BTF_ID]             = &btf_ptr_types,
> > > > +     [ARG_PTR_TO_SPIN_LOCK]          = &spin_lock_types,
> > > > +     [ARG_PTR_TO_MEM]                = &mem_types,
> > > > +     [ARG_PTR_TO_MEM_OR_NULL]        = &mem_types,
> > > > +     [ARG_PTR_TO_UNINIT_MEM]         = &mem_types,
> > > > +     [ARG_PTR_TO_ALLOC_MEM]          = &alloc_mem_types,
> > > > +     [ARG_PTR_TO_ALLOC_MEM_OR_NULL]  = &alloc_mem_types,
> > > > +     [ARG_PTR_TO_INT]                = &int_ptr_types,
> > > > +     [ARG_PTR_TO_LONG]               = &int_ptr_types,
> > > > +     [__BPF_ARG_TYPE_MAX]            = NULL,
> > >
> > > I don't understand what this extra value is for.
> > > I tried:
> > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > index fc5c901c7542..87b0d5dcc1ff 100644
> > > --- a/include/linux/bpf.h
> > > +++ b/include/linux/bpf.h
> > > @@ -292,7 +292,6 @@ enum bpf_arg_type {
> > >         ARG_PTR_TO_ALLOC_MEM,   /* pointer to dynamically allocated memory */
> > >         ARG_PTR_TO_ALLOC_MEM_OR_NULL,   /* pointer to dynamically allocated memory or NULL */
> > >         ARG_CONST_ALLOC_SIZE_OR_ZERO,   /* number of allocated bytes requested */
> > > -       __BPF_ARG_TYPE_MAX,
> > >  };
> > >
> > >  /* type of values returned from helper functions */
> > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > index 15ab889b0a3f..83faa67858b6 100644
> > > --- a/kernel/bpf/verifier.c
> > > +++ b/kernel/bpf/verifier.c
> > > @@ -4025,7 +4025,6 @@ static const struct bpf_reg_types *compatible_reg_types[] = {
> > >         [ARG_PTR_TO_ALLOC_MEM_OR_NULL]  = &alloc_mem_types,
> > >         [ARG_PTR_TO_INT]                = &int_ptr_types,
> > >         [ARG_PTR_TO_LONG]               = &int_ptr_types,
> > > -       [__BPF_ARG_TYPE_MAX]            = NULL,
> > >  };
> > >
> > > and everything is fine as I think it should be.
> > >
> > > > +     compatible = compatible_reg_types[arg_type];
> > > > +     if (!compatible) {
> > > > +             verbose(env, "verifier internal error: unsupported arg type %d\n", arg_type);
> > > >               return -EFAULT;
> > > >       }
> > >
> > > This check will trigger the same way when somebody adds new ARG_* and doesn't add to the table.
> >
> > I think in that case that value of compatible will be undefined, since
> > it points past the end of compatible_reg_types. Hence the
> > __BPF_ARG_TYPE_MAX to ensure that the array has a NULL slot for new
> > arg types.
>
> I still don't see a point.
> If anyone adds one more ARG_ to the end (or anywhere else)
> the compatible_reg_types array will be zero inited in that place by the compiler.
> Just like it does already for ARG_ANYTHING and ARG_DONTCARE.

I looked up designated initializers when I wrote this, since I wasn't
super familiar with them:
https://gcc.gnu.org/onlinedocs/gcc/Designated-Inits.html#Designated-Inits

    Note that the length of the array is the highest value specified plus one.

So ARG_ANYTHING and ARG_DONTCARE are OK since there is a higher enum
value present in the initializer. If someone adds a new item to enum
bpf_arg_type I assume they would add it to the end. In that case the
highest value of the initializer doesn't change, and then indexing
into compatible_reg_types with the new enum value would be out of
bounds. Adding __BPF_ARG_TYPE_MAX fixes that.

It's very possible I misunderstood how this whole contraption works,
happy to send a patch.

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
