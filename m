Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67BA93145AD
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 02:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbhBIBgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 20:36:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhBIBgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 20:36:13 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E38C061788;
        Mon,  8 Feb 2021 17:35:33 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id x136so4315824pfc.2;
        Mon, 08 Feb 2021 17:35:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k0kdmiuUBm84KdFcT4b+ESMMTH4N7NEBgM35wYTC9cY=;
        b=I27MPpqX4DqH/5CkgHzlD9yfbRp2l5rwN/QW0BW0g/cK7uxOHt+HTvzUjRjoq4pz6I
         iXnYQFS7GazjaVJKpQT3EPuOYVDLD+q5S7sOIPywQ+VLhpapiEDlzdqyE5J/ueugxvBd
         batgksEMO1L1EJkdlyoWZzMCDTCh6EMrQLJBo7OBZ96r/mM9TbL8hydLDmCsihPsJNqL
         2NAmBYPIKeGK/DCuu+OpJqIcjG2IkNXDRVq+3TqpmSYEJ/kI1XN8ooQU4ToPXmMbab7K
         42uy4EzdJ1dt8z4FroO/C+IGJ5hJNGodtigRKoTzDEQJfbutPE80CP3SiP685pd3p21b
         cujg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k0kdmiuUBm84KdFcT4b+ESMMTH4N7NEBgM35wYTC9cY=;
        b=IBeYZoM3JkkF/fveKnQWVgdrYA51ufEQ9IDXCv+DVnFzLIppy8JrH5pctXPO6WcbVg
         L8yBGL4V4Mdlm6SVb0CI74YaFJ2H2O4lq73h7CciM/ARZDIup2SEgXncV6HIEhur7QUk
         J1c/h5NJGQDPLkNbE68eSqlepyAWR3dPP6UGc5NWJ2FVKIbLhLtJqJjCIttNxuAFKaK5
         qDaNNIHKlk6BSnBSf0CSXskLr9mtXliTIc3oDLVBF49Q0rGZqvtce+gtYz/HQhuchhcb
         +aIeGdXSIidgUs7pKmI19vu3vJhGGZJM+WVKqRZqB2cqBTorCNxdEVk06vVkaK7og8Xp
         QWMQ==
X-Gm-Message-State: AOAM532raCMjLMcjXfgTqpzFOd0tgXdbFe9+L7rp7Uexe97zQ65vi44K
        ItuGXBcR4LgxzNoHYebTjzJejOhyvqvjJHQgJde1kjwwnhE=
X-Google-Smtp-Source: ABdhPJyTcgeyk0VS7ZQDjEGJu3CH3SgAzBAeiXTwopEcu92HcP34ctHrmLx8sGTxQQSAk4URpOXpoojF4Ew2E5TSfR0=
X-Received: by 2002:aa7:9981:0:b029:1d4:2f7b:e0d with SMTP id
 k1-20020aa799810000b02901d42f7b0e0dmr20706429pfh.10.1612834533361; Mon, 08
 Feb 2021 17:35:33 -0800 (PST)
MIME-Version: 1.0
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
 <20210203041636.38555-9-xiyou.wangcong@gmail.com> <CACAyw9-is-sTBUyJnNsQBKga9eyKA8m6+qfS-hWBNipwqgaafg@mail.gmail.com>
In-Reply-To: <CACAyw9-is-sTBUyJnNsQBKga9eyKA8m6+qfS-hWBNipwqgaafg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 8 Feb 2021 17:35:22 -0800
Message-ID: <CAM_iQpUFRz2xKP2EbnOgWFocY7rOVvEgQ+-8doorsbL-pk0EjQ@mail.gmail.com>
Subject: Re: [Patch bpf-next 08/19] udp: implement ->read_sock() for sockmap
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 8, 2021 at 1:48 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Wed, 3 Feb 2021 at 04:17, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  include/net/udp.h  |  2 ++
> >  net/ipv4/af_inet.c |  1 +
> >  net/ipv4/udp.c     | 34 ++++++++++++++++++++++++++++++++++
> >  3 files changed, 37 insertions(+)
> >
> > diff --git a/include/net/udp.h b/include/net/udp.h
> > index 13f9354dbd3e..b6b75cabf4e4 100644
> > --- a/include/net/udp.h
> > +++ b/include/net/udp.h
> > @@ -327,6 +327,8 @@ struct sock *__udp6_lib_lookup(struct net *net,
> >                                struct sk_buff *skb);
> >  struct sock *udp6_lib_lookup_skb(const struct sk_buff *skb,
> >                                  __be16 sport, __be16 dport);
> > +int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
> > +                 sk_read_actor_t recv_actor);
> >
> >  /* UDP uses skb->dev_scratch to cache as much information as possible and avoid
> >   * possibly multiple cache miss on dequeue()
> > diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> > index d184d9379a92..4a4c6d3d2786 100644
> > --- a/net/ipv4/af_inet.c
> > +++ b/net/ipv4/af_inet.c
> > @@ -1072,6 +1072,7 @@ const struct proto_ops inet_dgram_ops = {
> >         .getsockopt        = sock_common_getsockopt,
> >         .sendmsg           = inet_sendmsg,
> >         .sendmsg_locked    = udp_sendmsg_locked,
> > +       .read_sock         = udp_read_sock,
> >         .recvmsg           = inet_recvmsg,
> >         .mmap              = sock_no_mmap,
> >         .sendpage          = inet_sendpage,
> > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > index 635e1e8b2968..6dffbcec0b51 100644
> > --- a/net/ipv4/udp.c
> > +++ b/net/ipv4/udp.c
> > @@ -1792,6 +1792,40 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
> >  }
> >  EXPORT_SYMBOL(__skb_recv_udp);
> >
> > +int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
> > +                 sk_read_actor_t recv_actor)
> > +{
> > +       struct sk_buff *skb;
> > +       int copied = 0, err;
> > +
> > +       while (1) {
> > +               int offset = 0;
> > +
> > +               skb = __skb_recv_udp(sk, 0, 1, &offset, &err);
>
> Seems like err isn't used outside of the loop, is that on purpose? If
> yes, how about moving the declaration of err to be with offset. Maybe
> rename to ignored?

It should be moved inside the loop.

>
> > +               if (!skb)
> > +                       break;
> > +               if (offset < skb->len) {
> > +                       int used;
> > +                       size_t len;
> > +
> > +                       len = skb->len - offset;
> > +                       used = recv_actor(desc, skb, offset, len);
> > +                       if (used <= 0) {
> > +                               if (!copied)
> > +                                       copied = used;
> > +                               break;
> > +                       } else if (used <= len) {
>
> In which case can used be > len?

I think in splice() case it could return a larger value than 'len', but
UDP does not support splice() even after this patchset. I can change
it to 'else', or just leave it as it is, in case we will add splice() support in
the future.

Thanks.
