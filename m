Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F127A2749D1
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 22:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgIVUHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 16:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgIVUHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 16:07:52 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32071C061755;
        Tue, 22 Sep 2020 13:07:52 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x22so8660699pfo.12;
        Tue, 22 Sep 2020 13:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gNKuVKWMdO78FqNK+uL+D8cH0jwgXUDn/bVLIwLhaMo=;
        b=uPFhjRwY5v/vx/0VmZ0+Crrif7OSxcc35CmWJhsitmcl86/RIWYfCZp02IbxulYUEZ
         R0+S5KjNoMk6wVfdG/7zWJY4KjhzX1DnKmjbz2Pgz/8t2w3MyFCd6wTvtcz39YT1QeRx
         tMR4oQw7Evv34XJ5AxYsm9U7sIvrBWWUYJ2eE9ZLJnf7ebTR88DEOE05p4IOHFU1ynmN
         yVPIf45XIfBnmSfKqGZSKZ4HZ2Ee8yIFqo6ERUCmPa4pp6kiq/03i9FIp7jWtPBAdK/m
         W7uaAXDLRTeRGql+OiaFrsG/MFzGhgxoFWNM4Cy1v9JIwuLAGjLrFGvjcc16C9rwxaWC
         x/mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gNKuVKWMdO78FqNK+uL+D8cH0jwgXUDn/bVLIwLhaMo=;
        b=XXsm+rTYXF7Nx8aZA0ZPfL82S6yYN2OoqOOua7tjd79/uHBK66alrpqvKnb576y1XA
         zLGU6v/WOuCGFHO+8Gwd6hUs4REZV+GygTpZHxPEgR76JYrgznUtnFRjAoKt7Xy/y6Sj
         hd/V9Ui52hkGurOHibEmXDjjyEkyxUTeeRobyVSTWuQ0i+BUlqSmvUhotd63sQT5CZP6
         bFZLS9dzJDd/9iN1B2va3UBU4Gq/ntLy02fFClzqWPshOfmgwp7zeUmdOptDiKCd4jtq
         WGhE0qzkB6C4Oed/KyGYxGNznYTDxGa0Mv2wvJFdmUENHljz1FbKIoJFQs4d6yRYOiCA
         2+ww==
X-Gm-Message-State: AOAM531zltZHgiyw69JYaX2ndeOVAm00Kqkc2H6TyqKUN+s1uH+MAGrf
        Ka+wBWke0MXhwkg0cHVQHzg=
X-Google-Smtp-Source: ABdhPJzDUxMqLE5rCbXU7Rhex0yFWsHHDU4r9sgsCa4wZXufZzxOfGGmEp4DGvm2oXroXCMa+66/zw==
X-Received: by 2002:a63:d512:: with SMTP id c18mr4588501pgg.387.1600805271577;
        Tue, 22 Sep 2020 13:07:51 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:f812])
        by smtp.gmail.com with ESMTPSA id g32sm15202913pgl.89.2020.09.22.13.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 13:07:50 -0700 (PDT)
Date:   Tue, 22 Sep 2020 13:07:48 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v4 11/11] bpf: use a table to drive helper arg
 type checks
Message-ID: <20200922200748.gv6x6yhkyxnbqxx4@ast-mbp.dhcp.thefacebook.com>
References: <20200921121227.255763-1-lmb@cloudflare.com>
 <20200921121227.255763-12-lmb@cloudflare.com>
 <20200921222335.lew7wmyrtuej5mrh@ast-mbp.dhcp.thefacebook.com>
 <CACAyw98XfkMy4TDFnHBCFzXxauLrZ56w+84-R_NQO1SLMgPJYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAyw98XfkMy4TDFnHBCFzXxauLrZ56w+84-R_NQO1SLMgPJYA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 09:20:27AM +0100, Lorenz Bauer wrote:
> On Mon, 21 Sep 2020 at 23:23, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Mon, Sep 21, 2020 at 01:12:27PM +0100, Lorenz Bauer wrote:
> > > +struct bpf_reg_types {
> > > +     const enum bpf_reg_type types[10];
> > > +};
> >
> > any idea on how to make it more robust?
> 
> I kind of copied this from the bpf_iter context. I prototyped using an
> enum bpf_reg_type * and then terminating the array with NOT_INIT.
> Writing this out is more involved, and might need some macro magic to
> make it palatable. The current approach is a lot simpler, and I
> figured that the compiler will error out if we ever exceed the 10
> items.

The compiler will be silent if number of types is exactly 10,
but at run-time the loop will access out of bounds.

> >
> > > +
> > > +static const struct bpf_reg_types *compatible_reg_types[] = {
> > > +     [ARG_PTR_TO_MAP_KEY]            = &map_key_value_types,
> > > +     [ARG_PTR_TO_MAP_VALUE]          = &map_key_value_types,
> > > +     [ARG_PTR_TO_UNINIT_MAP_VALUE]   = &map_key_value_types,
> > > +     [ARG_PTR_TO_MAP_VALUE_OR_NULL]  = &map_key_value_types,
> > > +     [ARG_CONST_SIZE]                = &scalar_types,
> > > +     [ARG_CONST_SIZE_OR_ZERO]        = &scalar_types,
> > > +     [ARG_CONST_ALLOC_SIZE_OR_ZERO]  = &scalar_types,
> > > +     [ARG_CONST_MAP_PTR]             = &const_map_ptr_types,
> > > +     [ARG_PTR_TO_CTX]                = &context_types,
> > > +     [ARG_PTR_TO_CTX_OR_NULL]        = &context_types,
> > > +     [ARG_PTR_TO_SOCK_COMMON]        = &sock_types,
> > > +     [ARG_PTR_TO_SOCKET]             = &fullsock_types,
> > > +     [ARG_PTR_TO_SOCKET_OR_NULL]     = &fullsock_types,
> > > +     [ARG_PTR_TO_BTF_ID]             = &btf_ptr_types,
> > > +     [ARG_PTR_TO_SPIN_LOCK]          = &spin_lock_types,
> > > +     [ARG_PTR_TO_MEM]                = &mem_types,
> > > +     [ARG_PTR_TO_MEM_OR_NULL]        = &mem_types,
> > > +     [ARG_PTR_TO_UNINIT_MEM]         = &mem_types,
> > > +     [ARG_PTR_TO_ALLOC_MEM]          = &alloc_mem_types,
> > > +     [ARG_PTR_TO_ALLOC_MEM_OR_NULL]  = &alloc_mem_types,
> > > +     [ARG_PTR_TO_INT]                = &int_ptr_types,
> > > +     [ARG_PTR_TO_LONG]               = &int_ptr_types,
> > > +     [__BPF_ARG_TYPE_MAX]            = NULL,
> >
> > I don't understand what this extra value is for.
> > I tried:
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index fc5c901c7542..87b0d5dcc1ff 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -292,7 +292,6 @@ enum bpf_arg_type {
> >         ARG_PTR_TO_ALLOC_MEM,   /* pointer to dynamically allocated memory */
> >         ARG_PTR_TO_ALLOC_MEM_OR_NULL,   /* pointer to dynamically allocated memory or NULL */
> >         ARG_CONST_ALLOC_SIZE_OR_ZERO,   /* number of allocated bytes requested */
> > -       __BPF_ARG_TYPE_MAX,
> >  };
> >
> >  /* type of values returned from helper functions */
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 15ab889b0a3f..83faa67858b6 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -4025,7 +4025,6 @@ static const struct bpf_reg_types *compatible_reg_types[] = {
> >         [ARG_PTR_TO_ALLOC_MEM_OR_NULL]  = &alloc_mem_types,
> >         [ARG_PTR_TO_INT]                = &int_ptr_types,
> >         [ARG_PTR_TO_LONG]               = &int_ptr_types,
> > -       [__BPF_ARG_TYPE_MAX]            = NULL,
> >  };
> >
> > and everything is fine as I think it should be.
> >
> > > +     compatible = compatible_reg_types[arg_type];
> > > +     if (!compatible) {
> > > +             verbose(env, "verifier internal error: unsupported arg type %d\n", arg_type);
> > >               return -EFAULT;
> > >       }
> >
> > This check will trigger the same way when somebody adds new ARG_* and doesn't add to the table.
> 
> I think in that case that value of compatible will be undefined, since
> it points past the end of compatible_reg_types. Hence the
> __BPF_ARG_TYPE_MAX to ensure that the array has a NULL slot for new
> arg types.

I still don't see a point.
If anyone adds one more ARG_ to the end (or anywhere else)
the compatible_reg_types array will be zero inited in that place by the compiler.
Just like it does already for ARG_ANYTHING and ARG_DONTCARE.
Am I still missing something?
If not please follow up with removal of __BPF_ARG_TYPE_MAX.
