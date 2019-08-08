Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E56F286880
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 20:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390172AbfHHSLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 14:11:37 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42342 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfHHSLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 14:11:37 -0400
Received: by mail-ed1-f67.google.com with SMTP id v15so91865084eds.9
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 11:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kdqAuCwFB2yHNZLfgfFzFdlW+/F5em+ndVdBrW8itUw=;
        b=SWzySL0Xc7qM5l2UTwUpLz/xsjX3gifhAZ8Uxtc4o5HX9ecRr8BL9kh3dX6irwEy0P
         KAfhBpMQj3JMo12M5580DRwNMVvDqjdqrljwfXqAa5tDr6MORhibhmM68QldG9+t2VDa
         rCggeCE6oWkbvuCB4/Kst47kV07LsC9Mr+ZGaAKH/O9kCAR1eb8Kv/Ykn8Fe//ZKCsMl
         YNfmE1Ppi3iICmXgiP+NuR+rcePrOLqvl0HryD2khmoX1+2oJzJp1RXVA9ds4vB2rdTK
         x5ezcbK5px2X5ePrN6eLZvsFf2gJb9kwiR7unuOcmfAEYmgFYCqbjB4OTsSxpkjr0B0U
         RRFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kdqAuCwFB2yHNZLfgfFzFdlW+/F5em+ndVdBrW8itUw=;
        b=dOJoMq7y+rRRvGZKd+vLfvYfxDfapd3LfrqBtlfYEQwddneGBq9OdpXP+5u0ke43bU
         OA+DPJXPfClpnybVAXwEWIfhpZSWId/CXL+yLIe5jo9rHIUyrvf4tTPSsAIR72HfD3OE
         0oPX9aV1lqoxIp3tG7hbAamQuXvT0fDvi+YiBBo9pleskHnkKQWOXy+jiA9XlUsT972X
         f4dDjUYmnD6BIKHWAPoX+iDPqToqjxXepWHbOTiRh1h3CDsaLsnnMC7ak3039N+MNdoA
         dD7/VFcggwJmreXYZfAq1WP8/hpBQnDB0ZwP83xgZB88ym5rWYHfP5+po/JD9mcA0DCG
         miag==
X-Gm-Message-State: APjAAAXb42yJxJ+nKI+4DCbSDC1TiKoW+y0QB845YAL+JDLqPgRQK4a8
        L9Qiu++bC4UDNcjOerPA7ivBVYGKzhBwzk/IgOE=
X-Google-Smtp-Source: APXvYqy57Lk4VXkx6+o+u3XSi5sqyiEAVv4AF5fQzE7ndsyQa/e+nS0RPSwFUQqk36cKWT0wTp+BkzLhKSQdk4kp3/I=
X-Received: by 2002:a50:eb8f:: with SMTP id y15mr17579665edr.31.1565287895467;
 Thu, 08 Aug 2019 11:11:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190808000359.20785-1-jakub.kicinski@netronome.com>
 <CA+FuTSc7H6X+rRnxZ5NcFiNy+pw1YCONiUr+K6g800DXzT_0EA@mail.gmail.com> <20190808103148.164bec9f@cakuba.netronome.com>
In-Reply-To: <20190808103148.164bec9f@cakuba.netronome.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 8 Aug 2019 14:10:59 -0400
Message-ID: <CAF=yD-+2N8dcJChFy9s+raVA3KjOVb76yr-1xVtGX+apNmGpXQ@mail.gmail.com>
Subject: Re: [PATCH net v3] net/tls: prevent skb_orphan() from leaking TLS
 plain text with offload
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 8, 2019 at 1:32 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Thu, 8 Aug 2019 11:59:18 -0400, Willem de Bruijn wrote:
> > > diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> > > index 7c0b2b778703..43922d86e510 100644
> > > --- a/net/tls/tls_device.c
> > > +++ b/net/tls/tls_device.c
> > > @@ -373,9 +373,9 @@ static int tls_push_data(struct sock *sk,
> > >         struct tls_context *tls_ctx = tls_get_ctx(sk);
> > >         struct tls_prot_info *prot = &tls_ctx->prot_info;
> > >         struct tls_offload_context_tx *ctx = tls_offload_ctx_tx(tls_ctx);
> > > -       int tls_push_record_flags = flags | MSG_SENDPAGE_NOTLAST;
> > >         int more = flags & (MSG_SENDPAGE_NOTLAST | MSG_MORE);
> > >         struct tls_record_info *record = ctx->open_record;
> > > +       int tls_push_record_flags;
> > >         struct page_frag *pfrag;
> > >         size_t orig_size = size;
> > >         u32 max_open_record_len;
> > > @@ -390,6 +390,9 @@ static int tls_push_data(struct sock *sk,
> > >         if (sk->sk_err)
> > >                 return -sk->sk_err;
> > >
> > > +       flags |= MSG_SENDPAGE_DECRYPTED;
> > > +       tls_push_record_flags = flags | MSG_SENDPAGE_NOTLAST;
> > > +
> >
> > Without being too familiar with this code: can this plaintext flag be
> > set once, closer to the call to do_tcp_sendpages, in tls_push_sg?
> >
> > Instead of two locations with multiple non-trivial codepaths between
> > them and do_tcp_sendpages.
> >
> > Or are there paths where the flag is not set? Which I imagine would
> > imply already passing s/w encrypted ciphertext.
>
> tls_push_sg() is shared with sw path which doesn't have the device
> validation.
>
> Device TLS can read tls_push_sg() via tls_push_partial_record() and
> tls_push_data(). tls_push_data() is addressed directly here,
> tls_push_partial_record() is again shared with SW path, so we have to
> address it by adding the flag in tls_device_write_space().
>
> The alternative is to add a conditional to tls_push_sg() which is
> a little less nice from performance and layering PoV but it is a lot
> simpler..
>
> Should I change?

Not at all. Thanks for the detailed explanation. That answered my last question

Acked-by: Willem de Bruijn <willemb@google.com>
