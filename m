Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8F758A292
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 22:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235922AbiHDUva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 16:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiHDUv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 16:51:29 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB5919004;
        Thu,  4 Aug 2022 13:51:24 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id dc19so1370792ejb.12;
        Thu, 04 Aug 2022 13:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=w+QGSaOb/XousN44XNbb92dSPmgCqAcukMrM9FUZK9w=;
        b=ZvXwSKVL3FrxRaPLczd+0A1M41isJW7puh9E0w2/up509c2Od1MZGzUcFgOiov0sJM
         s+x4zwONmq7zd4McnlGs650LG2p1GPmvLTjz6XwXDZdAGGaJwS2k3hikYWcmNAuzzGfz
         eBfoP7az6jtK/aqUkdQXY10cljRY/aKkbqndBtBLHoKfFeQD4q2QS9Y+3T75+yUr/4bh
         /T+p2x5VBwFjpUHRvxWhaETX4nQPwMjrudTeMyyhheJjG9O12M7PJpt/AsB94j0Vz8GW
         8IxOX+LvzFGWEosGuDasW30dbbH5BzQOeA3j4fhFGZz9aSKApDF9CQlzBDppnHulHu6F
         XFbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=w+QGSaOb/XousN44XNbb92dSPmgCqAcukMrM9FUZK9w=;
        b=xddnsl4NMYMRz4dznR4TkLRouysu/FXgWA22ZUe6xLyUP22MNLlJFretNCaRRMn7J9
         GrDx7r3oxAUgZ4n6H9aKf2eskPGSvX1zjHouXExthTz0t7pawLJ3HTV3OS8LnUm71KEb
         2OYpuhnFboHSvgjMmIyikOlen+UsyW7EJc0CHprvt9CiqA1OkyS8xPqJH0FdCuWCjCLK
         GJMvdJtcmlndRkqxzFVAIc3qP1yN2lMfbFkGq7O6hzcaEJ/yuIi5Y8ZpmaOQJjrHJuUq
         vAMSu8AD2XYFzF3fpR4cqpz9G7mttl9lupipRqMRtpBEwLxbBBOyoVj8xJnOEs4yjOao
         EBew==
X-Gm-Message-State: ACgBeo1Q9xwM1kXlhFpBezLjJ2rGUBSmPOnPwgYwo28CmYMjjZvgND/d
        zfem8PKrttBMJeF9VWbU8bFOFHb1kseXdA31IAiuZgJ3
X-Google-Smtp-Source: AA6agR79DJb0WnhoX2BEHERZ6NaeN8WG+tgvuonl7GQ0QUylyVH8pETJRo/7vv0Qnnu9bP+ZAtKL/o4uYp1n/slRfeY=
X-Received: by 2002:a17:907:2ccc:b0:72b:6907:fce6 with SMTP id
 hg12-20020a1709072ccc00b0072b6907fce6mr2697065ejc.115.1659646283265; Thu, 04
 Aug 2022 13:51:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220803204601.3075863-1-kafai@fb.com> <20220803204614.3077284-1-kafai@fb.com>
 <CAEf4Bzb9js_4UFChVWOjw52ik5TmNJroF5bXSicJtxyNZH8k3A@mail.gmail.com> <20220804192924.xmj6k556prcqncvk@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220804192924.xmj6k556prcqncvk@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 4 Aug 2022 13:51:12 -0700
Message-ID: <CAEf4BzZiuguQcV4qj_P7AA16O8e9QrvLRgvBbvWeMqnXdJfxoA@mail.gmail.com>
Subject: Universally available bpf_ctx WAS: Re: [PATCH v2 bpf-next 02/15] bpf:
 net: Avoid sk_setsockopt() taking sk lock when called from bpf
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Stanislav Fomichev <sdf@google.com>
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

On Thu, Aug 4, 2022 at 12:29 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Aug 04, 2022 at 12:03:04PM -0700, Andrii Nakryiko wrote:
> > On Wed, Aug 3, 2022 at 1:49 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > Most of the code in bpf_setsockopt(SOL_SOCKET) are duplicated from
> > > the sk_setsockopt().  The number of supported optnames are
> > > increasing ever and so as the duplicated code.
> > >
> > > One issue in reusing sk_setsockopt() is that the bpf prog
> > > has already acquired the sk lock.  This patch adds a in_bpf()
> > > to tell if the sk_setsockopt() is called from a bpf prog.
> > > The bpf prog calling bpf_setsockopt() is either running in_task()
> > > or in_serving_softirq().  Both cases have the current->bpf_ctx
> > > initialized.  Thus, the in_bpf() only needs to test !!current->bpf_ctx.
> > >
> > > This patch also adds sockopt_{lock,release}_sock() helpers
> > > for sk_setsockopt() to use.  These helpers will test in_bpf()
> > > before acquiring/releasing the lock.  They are in EXPORT_SYMBOL
> > > for the ipv6 module to use in a latter patch.
> > >
> > > Note on the change in sock_setbindtodevice().  sockopt_lock_sock()
> > > is done in sock_setbindtodevice() instead of doing the lock_sock
> > > in sock_bindtoindex(..., lock_sk = true).
> > >
> > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > ---
> > >  include/linux/bpf.h |  8 ++++++++
> > >  include/net/sock.h  |  3 +++
> > >  net/core/sock.c     | 26 +++++++++++++++++++++++---
> > >  3 files changed, 34 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > index 20c26aed7896..b905b1b34fe4 100644
> > > --- a/include/linux/bpf.h
> > > +++ b/include/linux/bpf.h
> > > @@ -1966,6 +1966,10 @@ static inline bool unprivileged_ebpf_enabled(void)
> > >         return !sysctl_unprivileged_bpf_disabled;
> > >  }
> > >
> > > +static inline bool in_bpf(void)
> >
> > I think this function deserves a big comment explaining that it's not
> > 100% accurate, as not every BPF program type sets bpf_ctx. As it is
> > named in_bpf() promises a lot more generality than it actually
> > provides.
> >
> > Should this be named either more specific has_current_bpf_ctx() maybe?
> Stans also made a similar point on this to add comment.
> Rename makes sense until all bpf prog has bpf_ctx.  in_bpf() was
> just the name it was used in the v1 discussion for the setsockopt
> context.
>
> > Also, separately, should be make an effort to set bpf_ctx for all
> > program types (instead or in addition to the above)?
> I would prefer to separate this as a separate effort.  This set is
> getting pretty long and the bpf_getsockopt() is still not posted.

Yeah, sure, I don't think you should be blocked on that.

>
> If you prefer this must be done first, I can do that also.

I wanted to bring this up for discussion. I find bpf_ctx a very useful
construct, if we had it available universally we could use it
(reliably) for this in_bpf() check, we could also have a sleepable vs
non-sleepable flag stored in such context and thus avoid all the
special handling we have for providing different gfp flags, etc.

But it's not just up for me to decide if we want to add it for all
program types (e.g., I wouldn't be surprised if I got push back adding
this to XDP). Most program types I normally use already have bpf_ctx
(and bpf_cookie built on top), but I was wondering what others feel
regarding making this (bpf_ctx in general, bpf_cookie in particular)
universally available.

So please proceed with your changes, I just used your patch as an
anchor for this discussion :)
