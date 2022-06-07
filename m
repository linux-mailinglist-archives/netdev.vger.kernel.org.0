Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF9E542045
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 02:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384855AbiFHAUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 20:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1842353AbiFHAJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 20:09:12 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D31914A933
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 13:36:55 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id t25so30068270lfg.7
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 13:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3q6TfnyhK/JVdpGe1sn/i51UuwyEe8WKDR0Bhpepgkw=;
        b=tnMvdL81BwwXW6yVLeadSVxqoY40YLtneqyhtf7dzDEpjVWIgYH2iRPKp6eha1ETf/
         Smnkr1PDED9FhO6HiPjOWfoRl+qtY5bDl2zV8/T21F7omzHIsh8REiwWKm7rynrFC7ha
         9z+rlqOGw5hX23QjtYQZk2+zXzfNjdTLnK4vrIWAqzEASTEjsvOOPjhpZ6f40Z7QrcnB
         /r0WaquGT7aHMBd+33JvbWRYcNc6jPuoNu/Lox9ShGV826J9aHUp1scqdqE5EYLGSHfx
         gfWYSsAzMjOPFQwNOxPDSeXLbznp8dwHpy4bYBa63aLMO72Y8VFdbnm8Wo5j+lC8f2hp
         o8GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3q6TfnyhK/JVdpGe1sn/i51UuwyEe8WKDR0Bhpepgkw=;
        b=TEuRDX7CLNgxdoChqxpiN/EzENZP7GXbnS7qnufOvcrEE9ii52uddU/ja2hHGbxitg
         pE9hFj7/gS5nkxxM16le17HhjjKALdVQeVs/XX10QsdnIZWIIyAGuxVCqPRpKYx9ZYif
         qEwdmWyz3HwzTfhj/rLlEri76UfPoZOHhHuUiPQFmEJfWIkG5QBb6e520jaP+/v4qWpN
         QDfLRV0kMCL5vViCZzPBOORlOv/oSgZtwCQOFcFMyARrXA/KWt3Up7ujAGHgtcPBhDOl
         axifo9aLiSInVl0FGspf7q/poI//t75XMFMt0p6OFsA8JlDYnptEblwAueM7DlbWD7eu
         oIhQ==
X-Gm-Message-State: AOAM532xA2SV5LOFtMXb15ymI4hN2XKBJjLCAb8/dCFJTjkpcGtDmw7x
        qxlKtGz1PwP5JtbmqyPXsMBt51jAeqUlGuvDo1UImg==
X-Google-Smtp-Source: ABdhPJy8Duzb8ouGhVTvWRJ84NdalTVXSBgNTWEcv3+UOHIOpiHr/k9nNY8Ntdn5isOX7HonVhqmVDniLFKJXZMbJLw=
X-Received: by 2002:a05:6512:3132:b0:478:f2f1:3a75 with SMTP id
 p18-20020a056512313200b00478f2f13a75mr21381284lfd.100.1654634213023; Tue, 07
 Jun 2022 13:36:53 -0700 (PDT)
MIME-Version: 1.0
References: <Yp9uRz40J24vWLSb@dev-arch.thelio-3990X> <20220607180847.13482-1-jstitt007@gmail.com>
 <CAKwvOd=C2kyMVLYTKJcBQNnqK0T4nEBMeaS3DpTM2ez1P+qcqQ@mail.gmail.com>
In-Reply-To: <CAKwvOd=C2kyMVLYTKJcBQNnqK0T4nEBMeaS3DpTM2ez1P+qcqQ@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 7 Jun 2022 13:36:41 -0700
Message-ID: <CAKwvOdnAALywDS6aZKCu1xnocc8LR5q_-UdLwSkBJ83nS-bL6g@mail.gmail.com>
Subject: Re: [PATCH v2] netfilter: conntrack: Fix clang -Wformat warning in print_tuple()
To:     Justin Stitt <jstitt007@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        Tom Rix <trix@redhat.com>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also, please make sure to run scripts/get_maintainer.pl on your patch
file and CC everyone it recommends, with the maintainers you want to
pick up your patch in the To field.
https://lore.kernel.org/llvm/20220607180847.13482-1-jstitt007@gmail.com/T/#u

$ ./scripts/get_maintainer.pl
0001-netfilter-conntrack-Fix-clang-Wformat-warning-in-pri.patch
Pablo Neira Ayuso <pablo@netfilter.org> (maintainer:NETFILTER)
Jozsef Kadlecsik <kadlec@netfilter.org> (maintainer:NETFILTER)
Florian Westphal <fw@strlen.de> (maintainer:NETFILTER)
"David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING [GENERAL])
Eric Dumazet <edumazet@google.com> (maintainer:NETWORKING [GENERAL])
Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING [GENERAL])
Paolo Abeni <pabeni@redhat.com> (maintainer:NETWORKING [GENERAL])
Nathan Chancellor <nathan@kernel.org> (supporter:CLANG/LLVM BUILD SUPPORT)
Nick Desaulniers <ndesaulniers@google.com> (supporter:CLANG/LLVM BUILD SUPPORT)
Tom Rix <trix@redhat.com> (reviewer:CLANG/LLVM BUILD SUPPORT)
netfilter-devel@vger.kernel.org (open list:NETFILTER)
coreteam@netfilter.org (open list:NETFILTER)
netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
linux-kernel@vger.kernel.org (open list)
llvm@lists.linux.dev (open list:CLANG/LLVM BUILD SUPPORT

On Tue, Jun 7, 2022 at 1:33 PM Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> On Tue, Jun 7, 2022 at 11:09 AM Justin Stitt <jstitt007@gmail.com> wrote:
> >
> >  | net/netfilter/nf_conntrack_standalone.c:63:7: warning: format specifies type
> >  | 'unsigned short' but the argument has type 'int' [-Wformat]
> >  |                            ntohs(tuple->src.u.tcp.port),
> >  |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >  | net/netfilter/nf_conntrack_standalone.c:64:7: warning: format specifies type
> >  | 'unsigned short' but the argument has type 'int' [-Wformat]
> >  |                            ntohs(tuple->dst.u.tcp.port));
> >  |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >  | net/netfilter/nf_conntrack_standalone.c:69:7: warning: format specifies type
> >  | 'unsigned short' but the argument has type 'int' [-Wformat]
> >  |                            ntohs(tuple->src.u.udp.port),
> >  |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >  | net/netfilter/nf_conntrack_standalone.c:70:7: warning: format specifies type
> >  | 'unsigned short' but the argument has type 'int' [-Wformat]
> >  |                            ntohs(tuple->dst.u.udp.port));
> >  |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >  | net/netfilter/nf_conntrack_standalone.c:75:7: warning: format specifies type
> >  | 'unsigned short' but the argument has type 'int' [-Wformat]
> >  |                            ntohs(tuple->src.u.dccp.port),
> >  |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >  | net/netfilter/nf_conntrack_standalone.c:76:7: warning: format specifies type
> >  | 'unsigned short' but the argument has type 'int' [-Wformat]
> >  |                            ntohs(tuple->dst.u.dccp.port));
> >  |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >  | net/netfilter/nf_conntrack_standalone.c:80:7: warning: format specifies type
> >  | 'unsigned short' but the argument has type 'int' [-Wformat]
> >  |                            ntohs(tuple->src.u.sctp.port),
> >  |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >  | net/netfilter/nf_conntrack_standalone.c:81:7: warning: format specifies type
> >  | 'unsigned short' but the argument has type 'int' [-Wformat]
> >  |                            ntohs(tuple->dst.u.sctp.port));
> >  |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >
> > Variadic functions (printf-like) undergo default argument promotion.
> > Documentation/core-api/printk-formats.rst specifically recommends
> > using the promoted-to-type's format flag.
> >
> > Also, as per C11 6.3.1.1:
> > (https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1548.pdf)
> > `If an int can represent all values of the original type ..., the
> > value is converted to an int; otherwise, it is converted to an
> > unsigned int. These are called the integer promotions.`
> > Thus it makes sense to change %hu (as well as %u) to %d.
> >
> > It should be noted that %u does not produce the same warning as %hu in this
> > context. However, it should probably be changed as well for consistency.
>
> Right, because they are `unsigned char` and the parameter is unnamed
> for variadic functions they are also default-argument-promoted to int.
> -Wformat won't warn on signedness.
>
> Thanks for the patch!
>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/378
>
> Also, Nathan supplied his RB tag on v1; it's ok next time to include
> it on subsequent revisions of patches, so long as you don't change the
> patch too much between revisions.
>
> >
> > Signed-off-by: Justin Stitt <jstitt007@gmail.com>
> > ---
> >  Diff between v1 -> v2:
> >  * update commit message and subject line
> >
> >  Note: The architecture (arm64) is critical for reproducing this warning.
> >
> >  net/netfilter/nf_conntrack_standalone.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> > index 6ad7bbc90d38..afbec8a12c5e 100644
> > --- a/net/netfilter/nf_conntrack_standalone.c
> > +++ b/net/netfilter/nf_conntrack_standalone.c
> > @@ -53,30 +53,30 @@ print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
> >
> >         switch (l4proto->l4proto) {
> >         case IPPROTO_ICMP:
> > -               seq_printf(s, "type=%u code=%u id=%u ",
> > +               seq_printf(s, "type=%d code=%d id=%d ",
> >                            tuple->dst.u.icmp.type,
> >                            tuple->dst.u.icmp.code,
> >                            ntohs(tuple->src.u.icmp.id));
> >                 break;
> >         case IPPROTO_TCP:
> > -               seq_printf(s, "sport=%hu dport=%hu ",
> > +               seq_printf(s, "sport=%d dport=%d ",
> >                            ntohs(tuple->src.u.tcp.port),
> >                            ntohs(tuple->dst.u.tcp.port));
> >                 break;
> >         case IPPROTO_UDPLITE:
> >         case IPPROTO_UDP:
> > -               seq_printf(s, "sport=%hu dport=%hu ",
> > +               seq_printf(s, "sport=%d dport=%d ",
> >                            ntohs(tuple->src.u.udp.port),
> >                            ntohs(tuple->dst.u.udp.port));
> >
> >                 break;
> >         case IPPROTO_DCCP:
> > -               seq_printf(s, "sport=%hu dport=%hu ",
> > +               seq_printf(s, "sport=%d dport=%d ",
> >                            ntohs(tuple->src.u.dccp.port),
> >                            ntohs(tuple->dst.u.dccp.port));
> >                 break;
> >         case IPPROTO_SCTP:
> > -               seq_printf(s, "sport=%hu dport=%hu ",
> > +               seq_printf(s, "sport=%d dport=%d ",
> >                            ntohs(tuple->src.u.sctp.port),
> >                            ntohs(tuple->dst.u.sctp.port));
> >                 break;
> > --
> > 2.30.2
> >
>
>
> --
> Thanks,
> ~Nick Desaulniers



-- 
Thanks,
~Nick Desaulniers
