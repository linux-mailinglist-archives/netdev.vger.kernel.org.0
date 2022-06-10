Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D734E54594B
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 02:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235447AbiFJAqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 20:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiFJAqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 20:46:08 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201DC193C6;
        Thu,  9 Jun 2022 17:46:08 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id y12so23870040ior.7;
        Thu, 09 Jun 2022 17:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OcK2QN5/PiNUvbtjPZDIGAbjMN6dtBXh5a4hrmLad/c=;
        b=FVdj/W15FdXHqDx3W7NnDw8AEDU0qQXbvyrF7PD1qnW3sr4DfvLUyTaCLNsSxFNrdF
         UR5nmjeov50wNYd42zUic2nAleIYxcmwbLRneJEkVRdCexiHyTzEPxm25sBdldoXh9ok
         UlsRTSNJ8jldfirjUN5tIYcQVIfRGuvGLuXRaq1fJKZzyvkjyL3vN4rstXH9t6o4SvDF
         JPyd5jc6wQ9PCBN2fuLwZ2/DPCBB0AluWbT6/QsCaT2c8x4RrZnOYMxUSxJNOVBR5Afe
         Qf75fDp5BfKqccEkUQ3yjEDyVpza0mlF3EBO3x434drCuiz203zLt+sWqjAeD2a3q/vu
         VKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OcK2QN5/PiNUvbtjPZDIGAbjMN6dtBXh5a4hrmLad/c=;
        b=jGFRQobOi7IwnQAlovfxtvijeHwfBpzPlElubriyMrS3hZguT0TtJDfagZdLseej5n
         VHycKRcq+fkvcW10x2F5hGj8k5VI7MUlxi65Vu/YwxJjKsJJJVWBBJM4Os6Z7ujsjAIb
         XRBYWSaEhiVG+AL6G+vwBrSGk/ghH7dnxn2d7qtM2kJbPt7lR/JMr6xCdlVHjbM8c8xy
         T3Rhdk2ueHEhS62PV7s2D6Lhn/qCWjSvOF0UDCk7gULNM+DIlSGTKupzk/4ciE13auBv
         7EGWZngDwTOwGoU4/ST2lpe9Yvdl6foQHcWUJ1boYcco10rhHJBp+lHmllwXQCqaBUXz
         pd1g==
X-Gm-Message-State: AOAM5337Be0zex8Ll8ksZJxbijgcYCTVZUOdEbRBPmXeeFVEhxVqG9tH
        VuUXTZMM6cAXG2ZFYyO4Gk2Uhg+fO5w8MuYzj5A=
X-Google-Smtp-Source: ABdhPJxJShuK296mfpYdwrysYgkpiqlKWZbQ2qjze0jwq7pDRyV02ujQOjEXVBFwmLhb3EUlDrlc2OG0kBa1MR9FlFI=
X-Received: by 2002:a05:6638:138f:b0:332:1c0:1e81 with SMTP id
 w15-20020a056638138f00b0033201c01e81mr2728500jad.293.1654821967536; Thu, 09
 Jun 2022 17:46:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220609011844.404011-1-jmaxwell37@gmail.com> <56d6f898-bde0-bb25-3427-12a330b29fb8@iogearbox.net>
 <20220610001743.z5nxapagwknlfjqi@kafai-mbp> <20220610003618.um4qya5rl6hirvnz@kafai-mbp>
In-Reply-To: <20220610003618.um4qya5rl6hirvnz@kafai-mbp>
From:   Jonathan Maxwell <jmaxwell37@gmail.com>
Date:   Fri, 10 Jun 2022 10:45:31 +1000
Message-ID: <CAGHK07BQZj4D1=KUmuWOjYS+4Hm3gq6_GJoWRt=Css9atL5U8w@mail.gmail.com>
Subject: Re: [PATCH net] net: bpf: fix request_sock leak in filter.c
To:     Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        Antoine Tenart <atenart@kernel.org>, cutaylor-pub@yahoo.com,
        alexei.starovoitov@gmail.com, joe@cilium.io, i@lmb.io,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 10:36 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Jun 09, 2022 at 05:17:47PM -0700, Martin KaFai Lau wrote:
> > On Thu, Jun 09, 2022 at 10:29:15PM +0200, Daniel Borkmann wrote:
> > > On 6/9/22 3:18 AM, Jon Maxwell wrote:
> > > > A customer reported a request_socket leak in a Calico cloud environment. We
> > > > found that a BPF program was doing a socket lookup with takes a refcnt on
> > > > the socket and that it was finding the request_socket but returning the parent
> > > > LISTEN socket via sk_to_full_sk() without decrementing the child request socket
> > > > 1st, resulting in request_sock slab object leak. This patch retains the
> > Great catch and debug indeed!
> >
> > > > existing behaviour of returning full socks to the caller but it also decrements
> > > > the child request_socket if one is present before doing so to prevent the leak.
> > > >
> > > > Thanks to Curtis Taylor for all the help in diagnosing and testing this. And
> > > > thanks to Antoine Tenart for the reproducer and patch input.
> > > >
> > > > Fixes: f7355a6c0497 bpf: ("Check sk_fullsock() before returning from bpf_sk_lookup()")
> > > > Fixes: edbf8c01de5a bpf: ("add skc_lookup_tcp helper")
> > Instead of the above commits, I think this dated back to
> > 6acc9b432e67 ("bpf: Add helper to retrieve socket in BPF")
>
> Since this is more bpf specific, I think it could go to the bpf tree.
> In v2, please cc bpf@vger.kernel.org and tag it with 'PATCH v2 bpf'.

Okay thanks will do.

Daniel, are you okay with omitting 'if (unlikely...) { WARN_ONCE(...); }'?

If so I'll stick to the rest of the logic of your suggestion and omit that
check in v1.

Regards

Jon
