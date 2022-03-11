Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC204D5C57
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 08:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344568AbiCKHdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 02:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347238AbiCKHdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 02:33:10 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2351D1B6E29;
        Thu, 10 Mar 2022 23:32:07 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id t14so6809400pgr.3;
        Thu, 10 Mar 2022 23:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3sXzwfnXLrqecPZyJan53MZ3BYRyUoVNHcQn0y2VBx4=;
        b=NVI8eyEuaatuBzypX9DNRT3E86SEBRal+IyVHv/SP4b2sX7a7P7Orf+Z6ZiHJk8oEf
         q8oOJcMBR7+m3t3O0cD8RFww7i+flVWxK4FIMFTzyl5YKgKesqjPwtlXhUpk0QhFTglG
         Ks++4m06IxrNEy+t2fO26pK25a2X58cfB+MykLc0bv+6LsMnDKd4XGGLUktB5HsOYLsY
         i4xG/VEa2rqHBBZHkPBgHMRSXirQVxVaOXDzTsiPoe2uu+Rs9R6I3os2zjMs3JChmHGX
         dE5RJSxVrvkVTzhLIB2GUJPIxsg7bOkerqASVI6NxAwzZ3ICyD5Ht9KSkBdy45fxoiVU
         tOjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3sXzwfnXLrqecPZyJan53MZ3BYRyUoVNHcQn0y2VBx4=;
        b=uh/kndz/O5bEI02P/TyyV98JEYDAnPDRi2XQWMy0ZUgYtdR68GQbBkXSfXXkCFOjI0
         zjWlXWTyGIATiW9YRM7BqYuq2vvv2mwbG3huBtykEsNV5mwQdslpJ9mcCCCiOSOYmjuz
         nNh1Nnk3wYb1d+MpWd0pUKqj4Oi5Z8AjngXQoN9IgnXTlsHf0DTLaiTqImCRSJ7nn2NW
         0i752M2JjE7BONKGq+OKaJeobhjfFkhBRGbj6ei81lfaJivgOJdw2ReLiEovFxQ5JCR1
         CgEvovutDtpCNNsBCeUFSUBw3AQYtu7MgPhuc8Qmt3hJtvv07MNevo9m+VjfVZE65N8m
         uJxQ==
X-Gm-Message-State: AOAM531YozVkHRYSY70IQQ1beAKUEtqCjH61VqfauYCszP34GzTnhtZ/
        WGHXm+NUJx8cIPrkDp7ay+c=
X-Google-Smtp-Source: ABdhPJw2KNIcREdQXf8g0yagLAk3BTZKpnrXVYi4kqel6B9FJl+3gZt8pxUdidI2LKFoCzSfZNsCUw==
X-Received: by 2002:a63:82c1:0:b0:37c:9950:2fec with SMTP id w184-20020a6382c1000000b0037c99502fecmr7154049pgd.13.1646983926534;
        Thu, 10 Mar 2022 23:32:06 -0800 (PST)
Received: from localhost ([112.79.142.206])
        by smtp.gmail.com with ESMTPSA id lb4-20020a17090b4a4400b001b9b20eabc4sm8774458pjb.5.2022.03.10.23.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 23:32:06 -0800 (PST)
Date:   Fri, 11 Mar 2022 13:01:57 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Lorenz Bauer <linux@lmb.io>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 1/5] bpf: Add ARG_SCALAR and ARG_CONSTANT
Message-ID: <20220311073157.swfsz2x46cxd7ym7@apollo>
References: <20220306234311.452206-1-memxor@gmail.com>
 <20220306234311.452206-2-memxor@gmail.com>
 <CAEf4Bza0smGgyty87gfbUM8z5i+QOFvVqH+VHYcQxobODxCvfQ@mail.gmail.com>
 <20220308062602.7aydtzkk5ghyo5gb@apollo.legion>
 <CAEf4BzbfQ6S526j61uNc0gqE3q=QCyWpztZVMdiM38JFKazmRA@mail.gmail.com>
 <CAEf4Bzb1DmZazWP0YpB-bhbeM-DYyOLSVQjWMS306MoSw51Xww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzb1DmZazWP0YpB-bhbeM-DYyOLSVQjWMS306MoSw51Xww@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 04:39:40AM IST, Andrii Nakryiko wrote:
> On Thu, Mar 10, 2022 at 3:05 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Mar 7, 2022 at 10:26 PM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > On Tue, Mar 08, 2022 at 11:12:13AM IST, Andrii Nakryiko wrote:
> > > > On Sun, Mar 6, 2022 at 3:43 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> > > > >
> > > > > In the next patch, we will introduce a new helper 'bpf_packet_pointer'
> > > > > that takes offset and len and returns a packet pointer. There we want to
> > > > > statically enforce offset is in range [0, 0xffff], and that len is a
> > > > > constant value, in range [1, 0xffff]. This also helps us avoid a
> > > > > pointless runtime check. To make these checks possible, we need to
> > > > > ensure we only get a scalar type. Although a lot of other argument types
> > > > > take scalars, their intent is different. Hence add general ARG_SCALAR
> > > > > and ARG_CONSTANT types, where the latter is also checked to be constant
> > > > > in addition to being scalar.
> > > > >
> > > > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > > > ---
> > > > >  include/linux/bpf.h   |  2 ++
> > > > >  kernel/bpf/verifier.c | 13 +++++++++++++
> > > > >  2 files changed, 15 insertions(+)
> > > > >
> > > > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > > > index 88449fbbe063..7841d90b83df 100644
> > > > > --- a/include/linux/bpf.h
> > > > > +++ b/include/linux/bpf.h
> > > > > @@ -391,6 +391,8 @@ enum bpf_arg_type {
> > > > >         ARG_PTR_TO_STACK,       /* pointer to stack */
> > > > >         ARG_PTR_TO_CONST_STR,   /* pointer to a null terminated read-only string */
> > > > >         ARG_PTR_TO_TIMER,       /* pointer to bpf_timer */
> > > > > +       ARG_SCALAR,             /* a scalar with any value(s) */
> > > >
> > > > What's the difference between ARG_ANYTHING and ARG_SCALAR?
> > > >
> > >
> > > ARG_SCALAR only accepts reg->type == SCALAR, ARG_ANYTHING accepts anything as
> > > long as reg->type != NOT_INIT (due to SRC_OP for check_reg_arg and early return
> > > without further checks).
> > >
> >
> > Ah, ok, didn't realize that it's not always scalar for ARG_ANYTHING
> >
> >
> > > > > +       ARG_CONSTANT,           /* a scalar with constant value */
> > > >
> > > > This ARG_CONSTANT serves a very similar purpose as
> > > > ARG_CONST_ALLOC_SIZE_OR_ZERO, tbh. The only difference is that one is
> > > > used to set meta->mem_size and this one is used (through extra func_id
> > > > special handling) to set meta->ret_pkt_len. But meta->mem_size and
> > > > meta->ret_pkt_len mean the same thing: how many bytes are directly
> > > > accessible through a pointer returned from the helper. So I feel like
> > > > there is some opportunity to unify and generalize, instead of adding
> > > > more custom variants of constants. WDYT?
> > > >
> > >
> > > I see, indeed it would make sense to make both equivalent, since
> > > CONST_ALLOC_SIZE must also be a constant. Joanne also mentioned consolidating,
> > > but I didn't understand how that would work for ARG_CONSTANT and ARG_CONST_SIZE
> > > ones.
> > >
> > > I'm wondering whether we can take a step back and should go with the following
> > > convention:
> > >
> > > ARG_MEM_SIZE, and two type flags, ARG_ZERO | ARG_CONSTANT
> > >
> > > Old                             New (in bpf_func_proto)
> > > -------------------------------------------------------------------
> > > ARG_CONST_SIZE                  ARG_MEM_SIZE
> > > ARG_CONST_SIZE_OR_ZERO          ARG_MEM_SIZE | ARG_ZERO
> > > ARG_CONST_ALLOC_SIZE            ARG_MEM_SIZE | ARG_CONST
> > > ARG_CONST_ALLOC_SIZE_OR_ZERO    ARG_MEM_SIZE | ARG_CONST | ARG_ZERO
> > > ARG_CONSTANT (mine)             ARG_MEM_SIZE | ARG_CONST
> > >
> >
> > I think using "ARG_MEM_SIZE" as part of ARG_CONSTANT is backwards and
> > misleading. It makes more sense to me to have ARG_CONSTANT and use
> > ARG_ZERO (or rather ARG_MAYBE_ZERO?) and ARG_MEM_SIZE (to specify that
> > this constant is describing the size of memory of a pointer that is
> > passed in a previous argument).
> >
> > Basically, something like:
> >
> > ARG_CONST_SIZE => ARG_CONSTANT | ARG_MEM_SIZE
> > ARG_CONST_SIZE_OR_ZERO => ARG_CONSTANT | ARG_MEM_SIZE | ARG_MAYBE_ZERO
> >
> > Then we can replace ARG_CONST_ALLOC_SIZE and
> > ARG_CONST_ALLOC_SIZE_OR_ZERO with ARG_CONSTANT  and ARG_CONSTANT |
> > ARG_MAYBE_ZERO and we'll have a bit of special case to handle
> > bpf_ringbuf_reserve.
> >
> > For ARG_CONSTANT, verifier will remember the value in
> > bpf_call_arg_meta, and then we can use it as necessary (e.g., instead
> > of mem_size when ARG_MEM_SIZE is specified) depending on context,
> > helper being called, etc.
> >
> > Adding ARG_CONST just makes no sense as we always want constant value,
> > otherwise it might as well be just ARG_ANYTHING, right?
>
> Re-reading this, this paragraph is very confusing (especially taking
> into account what I wrote above). My point was that in your table, you
> have ARG_MEM_SIZE as a "base type" and ARG_CONST as "modifier". And
> that makes little sense to me, because in all cases we have a
> constant, but not in all cases we use that constant to describe the
> size of memory passed in a previous argument. So I inverted that,
> ARG_CONSTANT as "base type", ARG_MEM_SIZE and ARG_MAYBE_ZERO as
> modifiers. And we then don't need 5 different resulting types because
> "CONST_ALLOC_SIZE" handling is just a custom constant handling for
> bpf_ringbuf_reserve. Just like for your use case you wanted to use
> plain ARG_CONSTANT and add some extra logic for your
> bpf_packet_pointer(). I hope this clarifies it a bit.
>

Makes sense, I'll split it out as a separate change. Thanks!

> >
> > I haven't spent much time thinking about this, though, so I'm probably
> > missing something.
> >
> >
> > > When we detect ARG_CONST, we always set meta->mem_size, which can be used to
> > > refine returned pointer range, otherwise meta->mem_size = -1 by default (so it
> > > will be -1 for the !tnum_is_const(reg->var_off) case).
> > >
> > > if (arg_type & ARG_CONST)
> > >         meta->mem_size = reg->var_off.value;
> > >         if (!(arg_type & ARG_ZERO) && !meta->mem_size)
> > >                 // error
> > >
> > > The check_mem_size_reg call is only made when we see that previous reg was
> > > ARG_PTR_TO_MEM. When preceding argument is not ARG_PTR_TO_MEM, we error if
> > > ARG_CONST is not set for ARG_MEM_SIZE (so that either the mem size is for
> > > previous parameter, or otherwise a constant size for the returned pointer).
> > > We can also only allow certain pointer return types for that case.
> > >
> > > If that is too much automagic, we can also discern using ARG_MEM_SIZE vs
> > > ARG_RET_MEM_SIZE, but I think the above is fine.
> > >
> > > ARG_CONST ofcourse only applies to args taking scalar type.
> > >
> > > >
> > > >
> > > > >         __BPF_ARG_TYPE_MAX,
> > > > >
> > > > >         /* Extended arg_types. */
> > > > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > > > index ec3a7b6c9515..0373d5bd240f 100644
> > > > > --- a/kernel/bpf/verifier.c
> > > > > +++ b/kernel/bpf/verifier.c
> > > > > @@ -5163,6 +5163,12 @@ static bool arg_type_is_int_ptr(enum bpf_arg_type type)
> > > > >                type == ARG_PTR_TO_LONG;
> > > > >  }
> > > > >
> > > > > +static bool arg_type_is_scalar(enum bpf_arg_type type)
> > > > > +{
> > > > > +       return type == ARG_SCALAR ||
> > > > > +              type == ARG_CONSTANT;
> > > > > +}
> > > > > +
> > > > >  static int int_ptr_type_to_size(enum bpf_arg_type type)
> > > > >  {
> > > > >         if (type == ARG_PTR_TO_INT)
> > > > > @@ -5302,6 +5308,8 @@ static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
> > > > >         [ARG_PTR_TO_STACK]              = &stack_ptr_types,
> > > > >         [ARG_PTR_TO_CONST_STR]          = &const_str_ptr_types,
> > > > >         [ARG_PTR_TO_TIMER]              = &timer_types,
> > > > > +       [ARG_SCALAR]                    = &scalar_types,
> > > > > +       [ARG_CONSTANT]                  = &scalar_types,
> > > > >  };
> > > > >
> > > > >  static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
> > > > > @@ -5635,6 +5643,11 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
> > > > >                         verbose(env, "string is not zero-terminated\n");
> > > > >                         return -EINVAL;
> > > > >                 }
> > > > > +       } else if (arg_type_is_scalar(arg_type)) {
> > > > > +               if (arg_type == ARG_CONSTANT && !tnum_is_const(reg->var_off)) {
> > > > > +                       verbose(env, "R%d is not a known constant\n", regno);
> > > > > +                       return -EACCES;
> > > > > +               }
> > > > >         }
> > > > >
> > > > >         return err;
> > > > > --
> > > > > 2.35.1
> > > > >
> > >
> > > --
> > > Kartikeya

--
Kartikeya
