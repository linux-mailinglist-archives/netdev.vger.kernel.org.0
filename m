Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F25234CFDA
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 14:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbhC2MOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 08:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbhC2MNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 08:13:38 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A15DC061756
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 05:13:38 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id w8so13552525ybt.3
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 05:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UUtD4RgUbRkK8S2FxN6TlSeE5uhr0uSay3hRfX/XupY=;
        b=YEwMTWE8abNDS69qomfMHyj4Fcok43ur7EppH9PY/2WkztQYDpfGeFIo8/pD3zgxAV
         XJA3/+A5aiaz4OGs7GIDPIPBIKlKcLRIoCt1D7eGyhyZ4Ml/XpsFqgUehOXqm8ohXK2I
         vIINKSdWCe0ROChEvBSS7HmqzjQf210K0+xOieaujfGxMsj8gW7WU++cd2qijzJHXaCc
         hjjaXtTEUwLgk9l6kXEG3z5s9YxoSyl6GXyRp38TFrRTzwLNUF+NrNIsimue0R5nfzNr
         4vcEpScqk+8ubCIs2myRum3VAQs8vx1oRogibxLienJRctN3+myX+O5k2Ti0Ls2ss+Jc
         kGPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UUtD4RgUbRkK8S2FxN6TlSeE5uhr0uSay3hRfX/XupY=;
        b=OxYF7RdqWxu6KVenZKKMjPET7FZu5iikLT/006N3ATZJpFQ7/5qhw8syM/LOu8t8yS
         x2Q6BsOi3uVwWHYy87cjO4H3j1s0cc7hrRnyW0jTw9ePpkfTTZYJ/sP5DOpgR0UEwD5r
         Ob57nf/5z87nGmjOW+IF05aIbJMY8njFLK7//RAyhScKv5qB3g53EJJOFwuZ6cFCVFQI
         ffYpZo5elABhBPMcaXUjE+9lSzE+ju0rPlraH2y1P6sDCOonsij8Tgo1p2n/zwQ7Jv26
         2rM5hYeBBuw6aIO7Ov3JuKcdONOd3X7vczPtcgv+yjK9799KKf4gGbfU5v0MaHClH1Nl
         fCkA==
X-Gm-Message-State: AOAM5314NXBn5B5A/AQoEb/PiAhAxFZRKQA821KMsHbuTS9qABMiqO2u
        VbquNeIqR1fSKIzJmCrU0V/uSCBV5TwWirA44dnrDg==
X-Google-Smtp-Source: ABdhPJxsdwdM8QuH5t+VXO+P4LZ/YSwbF+249fjynzg2mPonBu4LjiPSp/YNJue/zN/d1CAaElpLTKU828eJg8LtGkg=
X-Received: by 2002:a25:6a88:: with SMTP id f130mr12706217ybc.234.1617020016870;
 Mon, 29 Mar 2021 05:13:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210329071716.12235-1-kurt@linutronix.de> <CANn89iJfLQwADLMw6A9J103qM=1y3O6ki1hQMb3cDuJVrwAkrg@mail.gmail.com>
 <878s661cc2.fsf@kurt>
In-Reply-To: <878s661cc2.fsf@kurt>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 29 Mar 2021 14:13:25 +0200
Message-ID: <CANn89iL6rQ_KqxyTBDDKtU-um_w=OhBywNwMrr+fki3UWdKVLg@mail.gmail.com>
Subject: Re: [PATCH net v2] net: Reset MAC header for direct packet transmission
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 12:30 PM Kurt Kanzenbach <kurt@linutronix.de> wrote:
>
> On Mon Mar 29 2021, Eric Dumazet wrote:
> > Note that last year, I addressed the issue differently in commit
> > 96cc4b69581db68efc9749ef32e9cf8e0160c509
> > ("macvlan: do not assume mac_header is set in macvlan_broadcast()")
> > (amended with commit 1712b2fff8c682d145c7889d2290696647d82dab
> > "macvlan: use skb_reset_mac_header() in macvlan_queue_xmit()")
> >
> > My reasoning was that in TX path, when ndo_start_xmit() is called, MAC
> > header is essentially skb->data,
> > so I was hoping to _remove_ skb_reset_mac_header(skb) eventually from
> > the fast path (aka __dev_queue_xmit),
> > because most drivers do not care about MAC header, they just use skb->data.
> >
> > I understand it is more difficult to review drivers instead of just
> > adding more code in  __dev_direct_xmit()
> >
> > In hsr case, I do not really see why the existing check can not be
> > simply reworked ?
>
> It can be reworked, no problem. I just thought it might be better to add
> it to the generic code just in case there are more drivers suffering
> from the issue.

Note that I have a similar issue pending in ipvlan.

Still, I think I prefer the non easy way to not add more stuff in fast path.

>
> >
> > mac_header really makes sense in input path, when some layer wants to
> > get it after it has been pulled.
> >
> > diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
> > index ed82a470b6e154be28d7e53be57019bccd4a964d..cda495cb1471e23e6666c1f2e9d27a01694f997f
> > 100644
> > --- a/net/hsr/hsr_forward.c
> > +++ b/net/hsr/hsr_forward.c
> > @@ -555,11 +555,7 @@ void hsr_forward_skb(struct sk_buff *skb, struct
> > hsr_port *port)
> >  {
> >         struct hsr_frame_info frame;
> >
> > -       if (skb_mac_header(skb) != skb->data) {
> > -               WARN_ONCE(1, "%s:%d: Malformed frame (port_src %s)\n",
> > -                         __FILE__, __LINE__, port->dev->name);
> > -               goto out_drop;
> > -       }
> > +       skb_reset_mac_header(skb);
>
> hsr_forward_skb() has four call sites. Three of them make sure that the
> header is properly set. The Tx path does not. So, maybe something like
> below?

Yes, this should be fine.

>
> Thanks,
> Kurt
>
> diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
> index 7444ec6e298e..bfcdc75fc01e 100644
> --- a/net/hsr/hsr_device.c
> +++ b/net/hsr/hsr_device.c
> @@ -217,6 +217,7 @@ static netdev_tx_t hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
>         master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
>         if (master) {
>                 skb->dev = master->dev;
> +               skb_reset_mac_header(skb);
>                 hsr_forward_skb(skb, master);
>         } else {
>                 atomic_long_inc(&dev->tx_dropped);
> diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
> index ed82a470b6e1..b218e4594009 100644
> --- a/net/hsr/hsr_forward.c
> +++ b/net/hsr/hsr_forward.c
> @@ -555,12 +555,6 @@ void hsr_forward_skb(struct sk_buff *skb, struct hsr_port *port)
>  {
>         struct hsr_frame_info frame;
>
> -       if (skb_mac_header(skb) != skb->data) {
> -               WARN_ONCE(1, "%s:%d: Malformed frame (port_src %s)\n",
> -                         __FILE__, __LINE__, port->dev->name);
> -               goto out_drop;
> -       }
> -
