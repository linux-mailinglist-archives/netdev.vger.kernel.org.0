Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1329F57FBC6
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 10:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234201AbiGYIxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 04:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbiGYIxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 04:53:15 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2140140EC;
        Mon, 25 Jul 2022 01:53:14 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id q14so8278062iod.3;
        Mon, 25 Jul 2022 01:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y7mPPGBazqAqwkG20jnC2+HFnRE+pbJ+wiyr1+LAzNw=;
        b=i/gA2XQn/Y6GgFJ9rkRMzR/UGa5jaNoyQZszlL86X66MxlmCNzXiGAFxKDiwDiVvOQ
         ZGzbLgHdrXcoDbcu5e4KDZhzJC+2sc1fuSSpPklhf/C7w/LPsigSgnSC8prgHf0HVSiA
         ZAP9qryEjPT3bI2BSGMjf12Fz3tbTSjSuKKfQz+jEiTkUbFekDlJLExpAMXhRCdMltDA
         MZdczjsgVjs+YdqG6MPITqBE/mD5F1GWViwyxTsO+7Tf+Fk279dk5FR1j1nYPAAGfQU+
         /9lW0RkxjlkbWLwLbuaVMSwBQuSmhQUFS6bPh/vJuDedCeRQ+3r8CDH+CLAO/pcdq3Ea
         jC8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y7mPPGBazqAqwkG20jnC2+HFnRE+pbJ+wiyr1+LAzNw=;
        b=C+NGt5vl+EdWpzWkyEYvLmQFOGkYVP/vZ/c3CMP876I71G4J5pIz0kRYojnIez2IkX
         pGqCwhZwROxAuriFruizQCOfmTugXqQOXw1hWeOqNSDJkf4ffRoXPWrXtH/DW9UxbR+Y
         xKnJ2s1nkL6xxEZNC62l1GYKEeBUGJX+IC98kdklhEMcpsLKc6XjIs2xCAPkKqgOFhs9
         27QhwvKpYsG2l59zkPUCbopro+hRX+CyqDG4saekXK6DWsfTQX9/UPbnhvn5KaRUjHj6
         VFANKf7V1aw1KN3JBArL0ajTaDNIhCg5ShmZV9v7f04AiSGTcHBwInG2dcXkf8ykW+2E
         NtTA==
X-Gm-Message-State: AJIora+wx9kbXy9jG7T5+u+Sx9fkFWlf/LYeSnhD6Xc2+uG8VO9EV6Tf
        +f7jklBSMsx9IOdjBrnIOAnjTXA1MhlM0Ueb2qU=
X-Google-Smtp-Source: AGRyM1sbiuPk0HpUlbbEg/nBRULpqJ+5dTNsVogYxIefkExm5aZ1WVRbly3b/PqnIycVphZuOBNvGEDjLn56+XZFTuA=
X-Received: by 2002:a05:6602:395:b0:67b:d0c6:50cb with SMTP id
 f21-20020a056602039500b0067bd0c650cbmr4155629iov.110.1658739194008; Mon, 25
 Jul 2022 01:53:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220721134245.2450-1-memxor@gmail.com> <20220721134245.2450-8-memxor@gmail.com>
 <YtpnmI1oPOQRv3j3@salvia> <CAP01T75r6OQffvq8u3e4Srj6c1vsN_NP0PohWikYPUbdp1nDXQ@mail.gmail.com>
 <YtuoWpOJmfcb/3Yu@salvia>
In-Reply-To: <YtuoWpOJmfcb/3Yu@salvia>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Mon, 25 Jul 2022 10:52:35 +0200
Message-ID: <CAP01T74fNZo4SD++NWxmM+FVWk0yybG0xhwCnYuOi5NFkv8ekg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 07/13] net: netfilter: Add kfuncs to allocate
 and insert CT
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     bpf@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Jul 2022 at 09:50, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Fri, Jul 22, 2022 at 11:39:49AM +0200, Kumar Kartikeya Dwivedi wrote:
> > On Fri, 22 Jul 2022 at 11:02, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >
> > > Hi,
> > >
> > > On Thu, Jul 21, 2022 at 03:42:39PM +0200, Kumar Kartikeya Dwivedi wrote:
> > > > diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
> > > > index 37866c8386e2..83a60c684e6c 100644
> > > > --- a/include/net/netfilter/nf_conntrack_core.h
> > > > +++ b/include/net/netfilter/nf_conntrack_core.h
> > > > @@ -84,4 +84,19 @@ void nf_conntrack_lock(spinlock_t *lock);
> > > >
> > > >  extern spinlock_t nf_conntrack_expect_lock;
> > > >
> > > > +/* ctnetlink code shared by both ctnetlink and nf_conntrack_bpf */
> > > > +
> > > > +#if (IS_BUILTIN(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
> > > > +    (IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES) || \
> > > > +    IS_ENABLED(CONFIG_NF_CT_NETLINK))
> > >
> > > There must be a better way to do this without ifdef pollution?
> > >
> > > Could you fix this?
> >
> > I can just remove the ifdefs completely. The first part of the ifdef
> > is the correct way to detect BPF support for nf_conntrack, the second
> > is for ct netlink. These are the only two users. But it's not a lot of
> > code, so until it grows too much we can compile it unconditionally.
>
> I would suggest to compile in these small functions unconditionally.
>
> > Or do you have anything else in mind (like defining a macro for the
> > bpf one and making the ifdef look less ugly)?
>
> it's the ifdef pollution that it would be good to avoid IMO.

Ok, I have sent a fix to remove these ifdefs. We can revisit this when
more shared functions appear.
