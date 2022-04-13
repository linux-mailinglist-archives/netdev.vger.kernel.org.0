Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8DDF4FFF7B
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 21:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236933AbiDMTmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 15:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236102AbiDMTmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 15:42:06 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23C036B49
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 12:39:43 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id d129-20020a254f87000000b006411bf3f331so2530481ybb.4
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 12:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tLNxohLKrVZ2VVuJVQUOGJ+tr2LG5dKkJ9dtNAVBr4M=;
        b=aDeLMXW3YW0LEhpD+WohfSXtav5zJ0uHeotCMJ57B3AxhTBSgE9kZR06v6MdMLhA93
         xBgcOX5NaMZHkbabUgvPlxqq57dGIIOEqLlVNAf69iIflYthOiQQG07QoQW8gL2lyOLf
         XPiYRZc48IDshzUkFcyzuYZGRwGqj6ZSDqNY88KDWsMkKcEDMIEyBJ9ugSiiWc+/xw/d
         WoslN5QVNVOsy/U2HIyFH1+3g4YkAlJaT1uXXkZGiZlM/dzAOSeny9yAice2QSqBJCzR
         QoFwC4cETm3rvLKYjnqMp6t43U3ThyGjHPmTm3m2og4cJSiUVi+TPTXLdXlGl0CHnXMM
         sgLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tLNxohLKrVZ2VVuJVQUOGJ+tr2LG5dKkJ9dtNAVBr4M=;
        b=QK+Lv/xKGcihe9/awH/nDUsG0AQfb0cxmRkLN/SkPOqp5D7PAzpfsadfT58MKe6nEv
         TqPf9XMXiDmHm4TTxIyoSn0e6g9XvhEagoQY2ibPquDKX9sv/l3bh7zXh/WYrLxWpLKA
         ehyEujSrc9W5J5rpneRTzkYChjYUWTRlEcNVtPJjj0OW/ZYdrfzIj6jqsulwHeoc5nta
         qJ9IGQUAHpRGEZhDj4M2d1KerfQJQbx4RQ4SACm2Wh7aTJvv4xMWeqS5grYZCglzGsEr
         neGMF8nUcz3JZ1vt5+Vqv6U//CHKGWIOSF1U4P2beeXHPqrSipttFcBkr3o2q5vf6R2L
         dQXw==
X-Gm-Message-State: AOAM530dwfeT8hijFKTefZcMA+7MYIg8PRRTbZ3K6/3OhdusJ5X5nUyd
        tk8KMNEUiq++1fNenSg8ZQv5ftY=
X-Google-Smtp-Source: ABdhPJxWATPkf8KlWcgRLEhbe1i88LM2aPdMSwy8XRQXKbhlUx/A5AAh2nr639TLrv1W9e+ZEr8zP7I=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:45c6:42d5:e443:72cc])
 (user=sdf job=sendgmr) by 2002:a25:1dc2:0:b0:641:e120:4ab1 with SMTP id
 d185-20020a251dc2000000b00641e1204ab1mr389524ybd.169.1649878783188; Wed, 13
 Apr 2022 12:39:43 -0700 (PDT)
Date:   Wed, 13 Apr 2022 12:39:41 -0700
In-Reply-To: <CAEf4Bzb_-KMy7GBN_NsJCKXHfDnGTtVEZb7i4dmcN-8=cLhO+A@mail.gmail.com>
Message-Id: <Ylcm/dfeU3AEYqlV@google.com>
Mime-Version: 1.0
References: <20220413183256.1819164-1-sdf@google.com> <CAEf4Bzb_-KMy7GBN_NsJCKXHfDnGTtVEZb7i4dmcN-8=cLhO+A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: move rcu lock management out of
 BPF_PROG_RUN routines
From:   sdf@google.com
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/13, Andrii Nakryiko wrote:
> On Wed, Apr 13, 2022 at 11:33 AM Stanislav Fomichev <sdf@google.com>  
> wrote:
> >
> > Commit 7d08c2c91171 ("bpf: Refactor BPF_PROG_RUN_ARRAY family of macros
> > into functions") switched a bunch of BPF_PROG_RUN macros to inline
> > routines. This changed the semantic a bit. Due to arguments expansion
> > of macros, it used to be:
> >
> >         rcu_read_lock();
> >         array = rcu_dereference(cgrp->bpf.effective[atype]);
> >         ...
> >
> > Now, with with inline routines, we have:
> >         array_rcu = rcu_dereference(cgrp->bpf.effective[atype]);
> >         /* array_rcu can be kfree'd here */
> >         rcu_read_lock();
> >         array = rcu_dereference(array_rcu);
> >

> So subtle difference, wow...

> But this open-coding of rcu_read_lock() seems very unfortunate as
> well. Would making BPF_PROG_RUN_ARRAY back to a macro which only does
> rcu lock/unlock and grabs effective array and then calls static inline
> function be a viable solution?

> #define BPF_PROG_RUN_ARRAY_CG_FLAGS(array_rcu, ctx, run_prog, ret_flags) \
>    ({
>        int ret;

>        rcu_read_lock();
>        ret =  
> __BPF_PROG_RUN_ARRAY_CG_FLAGS(rcu_dereference(array_rcu), ....);
>        rcu_read_unlock();
>        ret;
>    })


> where __BPF_PROG_RUN_ARRAY_CG_FLAGS is what
> BPF_PROG_RUN_ARRAY_CG_FLAGS is today but with __rcu annotation dropped
> (and no internal rcu stuff)?

Yeah, that should work. But why do you think it's better to hide them?
I find those automatic rcu locks deep in the call stack a bit obscure
(when reasoning about sleepable vs non-sleepable contexts/bpf).

I, as the caller, know that the effective array is rcu-managed (it
has __rcu annotation) and it seems natural for me to grab rcu lock
while work with it; I might grab it for some other things like cgroup  
anyway.
