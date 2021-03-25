Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2DF349A29
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 20:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhCYT1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 15:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhCYT13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 15:27:29 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5C1C06174A;
        Thu, 25 Mar 2021 12:27:28 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 32so2838116pgm.1;
        Thu, 25 Mar 2021 12:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OYrivqIJMJkbkKIsLLmp5Sa6lUlSfN4t+1tq93chnBU=;
        b=rXDTZyx5IHZjDIF1PBSMWbdVUKXYXreRSphnTlmUx1rSyu1a5iqahOshFc3ttbJvFj
         69uKbTXCEUCYnoIgWmBvp/XEjzXqYroE6K4NoKpfkd1h9xQKkwRh6Skgz++GRJG9foIW
         toiwMimCDBM9QPMRJCO+ai+Riwp+GDYSpnmBkPQMklfjXjr4Cg9xanyFgayP9rN9GJey
         c1HUPCVccoZXN3tFe/pD4KmKXCxZl+fujLo8UXEorAiyPgLmXKVegmGwar4lqotbK59X
         jVLlzCLBoNM//0adD/O0lD8Z2obitNBvg6weJ6IXUHrTuApizWN0oavOKLMdFTvQebU1
         6BgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OYrivqIJMJkbkKIsLLmp5Sa6lUlSfN4t+1tq93chnBU=;
        b=XaY+uZ7NhrGykX+JuUWFt8Idox7uOtOtyiQBoWQjaN+/wyPWCKXBg7fuhxaNzItoSv
         NExg23OMtiykcV5TI3lVSCQceuvXFnDjWimSXRyLI11+bUyMKqids7x8bvu2ra/0kywx
         AVW6f6eFUiaqedYzVkrRyBvqSWrALzRJdniW3uNoslhhZCVsRqdwkcc3sIBRvfwijp2K
         asRaBKez0gOHUz5Z4Y52gjP7dJW9td6v86pUskPXOw4JEC+oQjtUW6F/MY3o/4gCvTHq
         n6OSKN28NPn4lcZn1oK4UPu/qAbfIJ2KnhOpmvw/W3iXhXSQf7bCXyP8hC9gySG344Ql
         /G6w==
X-Gm-Message-State: AOAM533WRF7FyxK469XcT3fBYKTRMNhidas30ewaYskmsP6INbc0yGVQ
        Hx+v47yj1IsrgB2mun2cW3ATGRrB9vusfhQPdpo=
X-Google-Smtp-Source: ABdhPJwxPRXYrMgPc3HUi4Z5O1MxJj2fPU876/C8TYGiFdjA36tg+fZtoZS92kFCw71BnRQsOQhNK9YGinSiPK+DJXs=
X-Received: by 2002:a63:1c4c:: with SMTP id c12mr8752180pgm.179.1616700448425;
 Thu, 25 Mar 2021 12:27:28 -0700 (PDT)
MIME-Version: 1.0
References: <161661943080.28508.5809575518293376322.stgit@john-Precision-5820-Tower>
 <161661958954.28508.16923012330549206770.stgit@john-Precision-5820-Tower>
 <CAM_iQpVShCqWx1CYUOO9SrgWw7ztVP6j=v=W9dAd9FbChGZauQ@mail.gmail.com> <605bf9718f2fc_64fde2082b@john-XPS-13-9370.notmuch>
In-Reply-To: <605bf9718f2fc_64fde2082b@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 25 Mar 2021 12:27:17 -0700
Message-ID: <CAM_iQpWzoP9SOQcMPB--jp6C_xnUVAmVtS4yMCN43kL248y4QA@mail.gmail.com>
Subject: Re: [bpf PATCH 2/2] bpf, sockmap: fix incorrect fwd_alloc accounting
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 7:46 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > On Wed, Mar 24, 2021 at 2:00 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > >
> > > Incorrect accounting fwd_alloc can result in a warning when the socket
> > > is torn down,
> > >
>
> [...]
>
> > > To resolve lets only account for sockets on the ingress queue that are
> > > still associated with the current socket. On the redirect case we will
> > > check memory limits per 6fa9201a89898, but will omit fwd_alloc accounting
> > > until skb is actually enqueued. When the skb is sent via skb_send_sock_locked
> > > or received with sk_psock_skb_ingress memory will be claimed on psock_other.
>                      ^^^^^^^^^^^^^^^^^^^^
> >
> > You mean sk_psock_skb_ingress(), right?
>
> Yes.

skb_send_sock_locked() actually allocates its own skb when sending, hence
it uses a different skb for memory accounting.

>
> [...]
>
> > > @@ -880,12 +876,13 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
> > >                 kfree_skb(skb);
> > >                 goto out;
> > >         }
> > > -       skb_set_owner_r(skb, sk);
> > >         prog = READ_ONCE(psock->progs.skb_verdict);
> > >         if (likely(prog)) {
> > > +               skb->sk = psock->sk;
> >
> > Why is skb_orphan() not needed here?
>
> These come from strparser which do not have skb->sk set.

Hmm, but sk_psock_verdict_recv() passes a clone too, like
strparser, so either we need it for both, or not at all. Clones
do not have skb->sk, so I think you can remove the one in
sk_psock_verdict_recv() too.


>
> >
> > Nit: You can just use 'sk' here, so "skb->sk = sk".
>
> Sure that is a bit nicer, will respin with this.
>
> >
> >
> > >                 tcp_skb_bpf_redirect_clear(skb);
> > >                 ret = sk_psock_bpf_run(psock, prog, skb);
> > >                 ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
> > > +               skb->sk = NULL;
> >
> > Why do you want to set it to NULL here?
>
> So we don't cause the stack to throw other errors later if we
> were to call skb_orphan for example. Various places in the skb
> helpers expect both skb->sk and skb->destructor to be set together
> and here we are just using it as a mechanism to feed the sk into
> the BPF program side. The above skb_set_owner_r for example
> would likely BUG().

Sounds reasonable.

Thanks.
