Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C271194ADE
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 22:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbgCZVqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 17:46:11 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52107 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgCZVqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 17:46:10 -0400
Received: by mail-wm1-f68.google.com with SMTP id c187so8956237wme.1;
        Thu, 26 Mar 2020 14:46:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a/1PD/NvwjP6w2Oa7NzVig8rY8DByrpbW9qBCyJF5sU=;
        b=LHnj7LeWnPyh1/vOCsZs0SidzyuvIaO0HjccpqZKyYa/w2NYmRP4ZqWJrcml83DFQS
         4fSBbms5I2z6lUOKtMJMTyvGkFHD0nkjl6rpYcQUWpexIGgNHF9BKeWCEYvWdx//f4Et
         LEWTO+zgpIgEkc98Wcz3HLcMFTOWX4HdQsNAYZi97h59hx9oSyid1Vx1casZ7B8AWAHE
         uq/hTvdBRiNt4kuK3hUjNDiLVXR6xC3EI789O5UXgjTjR22kMyJB6mgCkD++HGSuoiro
         XyW/tgyHuRsNW5On9QAvkBmXTYhAePCLJvjV7AbERRbxL9TFAPe+eXK+TIqIs6QiSXMk
         5BDw==
X-Gm-Message-State: ANhLgQ2FzjKbj4MAiih6Sc/6BjnpXSrZqFV5M+OFu5O+CZDgsSyngs8I
        Rh85xwgJqJQGZEbGH02+R2IwN4alBD8mVhkfggAEUbB7las=
X-Google-Smtp-Source: ADFU+vtSVqu4syGoetjljc4zhy0MKqUVWE3ndmHxElNuifxydIE6BhaLPYtJl4N8kAgZYaO3UcKqvxcH7r60fT5oht0=
X-Received: by 2002:a05:600c:20d:: with SMTP id 13mr2044734wmi.74.1585259168944;
 Thu, 26 Mar 2020 14:46:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200325055745.10710-1-joe@wand.net.nz> <20200325055745.10710-3-joe@wand.net.nz>
 <20200326211152.gcpvezl3753wxljv@ast-mbp>
In-Reply-To: <20200326211152.gcpvezl3753wxljv@ast-mbp>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Thu, 26 Mar 2020 14:45:57 -0700
Message-ID: <CAOftzPgn_FeDc89O=cbAZRvZ5uyhD-hyN3s4kRdE_0Vqcnzt9g@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 2/5] bpf: Prefetch established socket destinations
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Joe Stringer <joe@wand.net.nz>, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 2:12 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Mar 24, 2020 at 10:57:42PM -0700, Joe Stringer wrote:
> > Enhance the sk_assign logic to temporarily store the socket
> > receive destination, to save the route lookup later on. The dst
> > reference is kept alive by the caller's socket reference.
> >
> > Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
> > Signed-off-by: Joe Stringer <joe@wand.net.nz>
> > ---
> > v2: Provide cookie to dst_check() for IPv6 case
> > v1: Initial version
> > ---
> >  net/core/filter.c | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> >
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index f7f9b6631f75..0fada7fe9b75 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -5876,6 +5876,21 @@ BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
> >       skb_orphan(skb);
> >       skb->sk = sk;
> >       skb->destructor = sock_pfree;
> > +     if (sk_fullsock(sk)) {
> > +             struct dst_entry *dst = READ_ONCE(sk->sk_rx_dst);
> > +             u32 cookie = 0;
> > +
> > +#if IS_ENABLED(CONFIG_IPV6)
> > +             if (sk->sk_family == AF_INET6)
> > +                     cookie = inet6_sk(sk)->rx_dst_cookie;
> > +#endif
> > +             if (dst)
> > +                     dst = dst_check(dst, cookie);
> > +             if (dst) {
> > +                     skb_dst_drop(skb);
> > +                     skb_dst_set_noref(skb, dst);
> > +             }
>
> I think the rest of the feedback for the patches can be addressed quickly and
> overall the set is imo ready to land within this cycle. My only concern is
> above dst_set().
> Since it's an optimization may be drop this patch? we can land
> the rest and this one can be introduced in the next cycle?
> I'm happy to be convinced otherwise, but would like a better explanation
> why it's safe to do so in this context.

[resend for lists; somehow gmail introduced some http gunk]

FWIW I found an issue with this implementation over the last day so
your concern is well-warranted. I'd be fine with dropping the
optimization for now and sending it out with other optimizations next
cycle.

Will respin ASAP.

Cheers,
Joe
