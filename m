Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEAF3B95C7
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 20:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbhGASDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 14:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbhGASDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 14:03:17 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC277C061762;
        Thu,  1 Jul 2021 11:00:46 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id j199so6134950pfd.7;
        Thu, 01 Jul 2021 11:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KkKuTcoDoXZy3rISLq/E0AYWkmErSS9gOA3EC2nsVXQ=;
        b=HBw/b+SsflLe3LmGaj8epHwB9PqjXV+bltxmZImaSNzZLFazSatFtvhtlrJ91hbXPB
         gSX0zaJpRzzURfz9Zaos0n1n23wjrPGdGtqGrcxlC0LwMMxbWSYLuq60Cic6cX3QMG0M
         eSt23Aeo/g/oaxc24mr2WYYAC7eRHQWxyw3Y3PHa4IT/ZUOlOhEvHmwsP1NRL/TzevxR
         6lB3mzqNNC6+2J0Gue95gP8F709ZxezH/H+ftt5Ue/Koya/+MFYEd83pyAmChU3zVO70
         6YY+I1Q8jF6aWcVrGP5CoMkSwxR0gS7OF+HSIOM22wchPRTcIVTIUNHRbGiNNgICRQXq
         /knQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KkKuTcoDoXZy3rISLq/E0AYWkmErSS9gOA3EC2nsVXQ=;
        b=DRAOLj9Zie0xJUumudkPNey1pABKXQTxp1MsrQnyxK3bMcLmDt7TAdAVuDlruFih4o
         rY5IjjNzLtyQWpTBLv7VCDuxanpcg17aHraTKpe/sO3RSDebSpPbrsdiQVIX5bniBvGd
         iUcUVSK0Zhdp5rslLtFWl/U8S8jJqg51hT+2qkHLQ8Gl/5x67dJQNviqonTEnmSkPV0Z
         G2yPUBi24Y7swbqZs0QsELfODRXSxlYzRll+zKcTD6IpfkkKMWyOCJK6NAW8ypiwAQjC
         9a7txX+CbFwlMb55JFp4DxXb3I9L+HnRju2RWLv9Ag0EDsP1gaWUMAJx65ZlW0UCFwqX
         6DYQ==
X-Gm-Message-State: AOAM5310KZzNCCJZPADv5TxnvUVkovcDbsUFaa6REKUoZAwbO3LRHdKL
        DTvrE3AxY6j41DeSOOu3TcBftwV321+vTus05tM=
X-Google-Smtp-Source: ABdhPJzWprQlbyzJS9Tgxi5qoaSo19L5sYNmbRY8tdYMWC90qYduHpN3QVbCztLzB53ocmgi/4uDgbSrf6I93LgRkTQ=
X-Received: by 2002:aa7:88c1:0:b029:30b:49b3:18e with SMTP id
 k1-20020aa788c10000b029030b49b3018emr900543pff.43.1625162446467; Thu, 01 Jul
 2021 11:00:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210701061656.34150-1-xiyou.wangcong@gmail.com> <60ddec01c651b_3fe24208dc@john-XPS-13-9370.notmuch>
In-Reply-To: <60ddec01c651b_3fe24208dc@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 1 Jul 2021 11:00:35 -0700
Message-ID: <CAM_iQpUg6EQq0XdahWVZe9CYbN-iY_gfFq5p=+2URPmH0r6bwQ@mail.gmail.com>
Subject: Re: [Patch bpf v2] skmsg: check sk_rcvbuf limit before queuing to ingress_skb
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 1, 2021 at 9:23 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > Jiang observed OOM frequently when testing our AF_UNIX/UDP
> > proxy. This is due to the fact that we do not actually limit
> > the socket memory before queueing skb to ingress_skb. We
> > charge the skb memory later when handling the psock backlog,
> > but it is not limited either.
>
> Right, its not limiting but charging it should push back on
> the stack so it stops feeding skbs to us. Maybe this doesn't
> happen in UDP side?

The OOM is due to skb queued in ingress_skb, not due to
user-space consuming skb slowly.

>
> >
> > This patch adds checks for sk->sk_rcvbuf right before queuing
> > to ingress_skb and drops packets if this limit exceeds. This
> > is very similar to UDP receive path. Ideally we should set the
> > skb owner before this check too, but it is hard to make TCP
> > happy about sk_forward_alloc.
>
> But it breaks TCP side see below.
>
> >
> > Reported-by: Jiang Wang <jiang.wang@bytedance.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  net/core/skmsg.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> > index 9b6160a191f8..a5185c781332 100644
> > --- a/net/core/skmsg.c
> > +++ b/net/core/skmsg.c
> > @@ -854,7 +854,8 @@ static int sk_psock_skb_redirect(struct sk_psock *from, struct sk_buff *skb)
> >               return -EIO;
> >       }
> >       spin_lock_bh(&psock_other->ingress_lock);
> > -     if (!sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED)) {
> > +     if (!sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED) ||
> > +         atomic_read(&sk_other->sk_rmem_alloc) > READ_ONCE(sk_other->sk_rcvbuf)) {
> >               spin_unlock_bh(&psock_other->ingress_lock);
> >               skb_bpf_redirect_clear(skb);
> >               sock_drop(from->sk, skb);
> > @@ -930,7 +931,8 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
> >               }
> >               if (err < 0) {
> >                       spin_lock_bh(&psock->ingress_lock);
> > -                     if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
> > +                     if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED) &&
> > +                         atomic_read(&sk_other->sk_rmem_alloc) <= READ_ONCE(sk_other->sk_rcvbuf)) {
> >                               skb_queue_tail(&psock->ingress_skb, skb);
>
> We can't just drop the packet in the memory overrun case here. This will
> break TCP because the data will be gone and no one will retransmit.
>
> Thats why in the current scheme on redirect we can push back when we
> move it to the other queues ingress message queue or redirect into
> the other socket via send.
>
> At one point I considered charging the data sitting in the ingress_skb?
> Would that solve the problem here? I think it would cause the enqueue
> at the UDP to start dropping packets from __udp_enqueue_schedule_skb()?

I tried to move skb_set_owner_r() here, TCP is clearly unhappy about it,
as I explained in changelog. Yes, it probably helps if we could move it here.

Thanks.
