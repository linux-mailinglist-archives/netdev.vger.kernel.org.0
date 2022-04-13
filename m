Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1094FFFA1
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 21:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238561AbiDMT4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 15:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238550AbiDMT41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 15:56:27 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904F67EB05;
        Wed, 13 Apr 2022 12:53:04 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id p135so3127839iod.2;
        Wed, 13 Apr 2022 12:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PYQkokTYtwVbYRHQxnb+iuaU7r3MFZjW0sFXFg0tbtg=;
        b=FthKul79qbqDNiKkhhp37liOFMg2g7fU3GliLbRuthWZRCmD9AJvnA4YBUNUNO41dD
         8k6b6mzESXUzs9HbBJxBNonOEjAO6XZHS+dMvw9800yDcKsbKxyZJ2zEY0wN/r1xJ1qz
         uw35pd674o+WM/HSPOTc35R1MwQCkHCjXVFPrW6nP9zXyhqw9x3rL6lOuJPNQ69Zdvih
         JfQ3F2jz7iOjuMlTp7flU2GJFzAzLQPZWkoWammpawwvhqJ5yXuc6aUvrrhCnIFF4Ohk
         yQT6J7+joRWskIcEkx6ICQFiXyo+IKN1aZqCi2W0cKjEF2Oy+hVC0KYdUy+YZUtzyf5U
         TWNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PYQkokTYtwVbYRHQxnb+iuaU7r3MFZjW0sFXFg0tbtg=;
        b=uHIOwcy5OgDFB/BVgNvyawxkw5iTiEj4Z2ZfLow18wPmOdhSuyoOmEQCH9vi3TJbsH
         Y/NEASTYIQiU/Dd6Ia1ymu688D0tT2lEFbI9MOmLEgcUXBUVZNA4g9dQx/W7CP1Kuwhe
         IsV2McJ8kNmpXJJr4aITC13OLx0yK3VUze7mqxpEK99sDEDlvyVu/XpNFu4Tpv5LCz//
         ff7wlduosgt6uCnLMjq6vRGPA+X2UttVVMCltVbnW8QgJXoA2nhnFtnYxfms5QlaX/wK
         Quv2McDS9ZbgkAn1mIRI5pBCSOCqPgGiRUNEwkkE9vtX4rI2sUM1mI5WemH4cg6aX8Tl
         IlJg==
X-Gm-Message-State: AOAM533eNNMljG55l2vEm3KeshkK336dCl08VQg66mVLlPbgbzzC2QTc
        Ewirn4wqX0qIQeRzmI6EciylFOWfEZ/C3SNQHrc=
X-Google-Smtp-Source: ABdhPJx8OI+c7t6n0bKaqM8nR4Al1KGElwxWsQ/7aotAR0YzM56X0s9y51jdRPwgB1i+l5OukTXEbgPAmwwNvD/yFxk=
X-Received: by 2002:a6b:8bd7:0:b0:646:2804:5c73 with SMTP id
 n206-20020a6b8bd7000000b0064628045c73mr17753794iod.112.1649879583916; Wed, 13
 Apr 2022 12:53:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220413183256.1819164-1-sdf@google.com> <CAEf4Bzb_-KMy7GBN_NsJCKXHfDnGTtVEZb7i4dmcN-8=cLhO+A@mail.gmail.com>
 <Ylcm/dfeU3AEYqlV@google.com>
In-Reply-To: <Ylcm/dfeU3AEYqlV@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 13 Apr 2022 12:52:53 -0700
Message-ID: <CAEf4BzYuTd9m4_J9nh5pZ9baoMMQK+m6Cum8UMCq-k6jFTJwEA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: move rcu lock management out of
 BPF_PROG_RUN routines
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 12:39 PM <sdf@google.com> wrote:
>
> On 04/13, Andrii Nakryiko wrote:
> > On Wed, Apr 13, 2022 at 11:33 AM Stanislav Fomichev <sdf@google.com>
> > wrote:
> > >
> > > Commit 7d08c2c91171 ("bpf: Refactor BPF_PROG_RUN_ARRAY family of macros
> > > into functions") switched a bunch of BPF_PROG_RUN macros to inline
> > > routines. This changed the semantic a bit. Due to arguments expansion
> > > of macros, it used to be:
> > >
> > >         rcu_read_lock();
> > >         array = rcu_dereference(cgrp->bpf.effective[atype]);
> > >         ...
> > >
> > > Now, with with inline routines, we have:
> > >         array_rcu = rcu_dereference(cgrp->bpf.effective[atype]);
> > >         /* array_rcu can be kfree'd here */
> > >         rcu_read_lock();
> > >         array = rcu_dereference(array_rcu);
> > >
>
> > So subtle difference, wow...
>
> > But this open-coding of rcu_read_lock() seems very unfortunate as
> > well. Would making BPF_PROG_RUN_ARRAY back to a macro which only does
> > rcu lock/unlock and grabs effective array and then calls static inline
> > function be a viable solution?
>
> > #define BPF_PROG_RUN_ARRAY_CG_FLAGS(array_rcu, ctx, run_prog, ret_flags) \
> >    ({
> >        int ret;
>
> >        rcu_read_lock();
> >        ret =
> > __BPF_PROG_RUN_ARRAY_CG_FLAGS(rcu_dereference(array_rcu), ....);
> >        rcu_read_unlock();
> >        ret;
> >    })
>
>
> > where __BPF_PROG_RUN_ARRAY_CG_FLAGS is what
> > BPF_PROG_RUN_ARRAY_CG_FLAGS is today but with __rcu annotation dropped
> > (and no internal rcu stuff)?
>
> Yeah, that should work. But why do you think it's better to hide them?
> I find those automatic rcu locks deep in the call stack a bit obscure
> (when reasoning about sleepable vs non-sleepable contexts/bpf).
>
> I, as the caller, know that the effective array is rcu-managed (it
> has __rcu annotation) and it seems natural for me to grab rcu lock
> while work with it; I might grab it for some other things like cgroup
> anyway.

If you think that having this more explicitly is better, I'm fine with
that as well. I thought a simpler invocation pattern would be good,
given we call bpf_prog_run_array variants in quite a lot of places. So
count me indifferent. I'm curious what others think.
