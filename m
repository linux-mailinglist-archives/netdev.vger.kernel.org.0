Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C82A1F7ECE
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 00:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgFLWN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 18:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgFLWN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 18:13:28 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1891DC03E96F;
        Fri, 12 Jun 2020 15:13:27 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id i27so12747171ljb.12;
        Fri, 12 Jun 2020 15:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2iDyXafqhLsVrluQiOl3buIl3fneuyWH/g+kH0A8cpg=;
        b=Re2zPzqZ0NC9n29JrL34B6vTkNv3x+UjFVfDX1ep8IaUIqUteHjVmX1GqtfyXPAjDG
         rTZc30M8pW9LpaVpwoUK9z9Icphvb3iQNTMCUtV/aQAySYs4SEp2fKaenN0l3DGAg9K5
         ft5raUj+mzh62iWewNTVQmM/wRmG/N9jSOaIPz8ajUtTHWzxZlAQISQrE9FZCTs4LCgJ
         asN/yU8P2EX1j6uOAYSd2eyzEARO5KGlCnzR+IwaQSfecUnErYWEnx13FmzoxHuR6Ijv
         LL9naANrOJ+86Npz4tUr0RLByedFhX+fyNWMFuZK8pn6jmYAa3am4+FjIipWzPDq9Kzb
         sgkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2iDyXafqhLsVrluQiOl3buIl3fneuyWH/g+kH0A8cpg=;
        b=iqL4+CTwcFncNbJdi+QGf+s51W3QqfTvDJmeKhLq8gicUARLn8KnPEtw5QXvwVP/ee
         pLuS9n3nQJV7FWsdzVUfNm8b0WnBOQ78RfFn6wnSMh5Y0qzOecXw9bdVcc5rv3gFOuOv
         6DnXXRFINQBZ0iZwa1gTZfzWfhGkzqcJPdDZut6CyhzrPoU//n/n9bP8YZz8prOsABIj
         oEA5cyhnaCfP7M2Ea98dX0kIfU2CVp1LnSHTMAjWL2sQkuEQ5JAt7PUyxYxPxINVfYya
         LdPirMGKjc/7ySR5q6alZSpoRiNqzUf4F/05UIg2eqAMx+RYkFl8g9UCVsmEyFhapmPf
         jfHw==
X-Gm-Message-State: AOAM531fTsNd1ho5017iOYLq4o0lMSAUh0olvccMchc2J5QYcXdDflLX
        p2pQbba720wGlbbpMKp9oQkf55huZ9bB5WSC9Zg=
X-Google-Smtp-Source: ABdhPJx9HOcnxrVGiA8RTLC4empHsMB9raNegqTbHMNn9Eyxh7C3RJPlYAvQSEbdOhQd029oKp4gRiiKwUYHk4nYi2c=
X-Received: by 2002:a2e:9187:: with SMTP id f7mr8094978ljg.450.1592000005526;
 Fri, 12 Jun 2020 15:13:25 -0700 (PDT)
MIME-Version: 1.0
References: <26038a28c21fea5d04d4bd4744c5686d3f2e5504.1591784177.git.sd@queasysnail.net>
 <20200612121526.4810a073@toad>
In-Reply-To: <20200612121526.4810a073@toad>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 12 Jun 2020 15:13:14 -0700
Message-ID: <CAADnVQKYHg-ZmzEibZ7TtZdyfNK+r7FQfv_DuJK44LdRuATDGw@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: tcp: recv() should return 0 when the peer socket
 is closed
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Network Development <netdev@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 12, 2020 at 3:18 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Wed, 10 Jun 2020 12:19:43 +0200
> Sabrina Dubroca <sd@queasysnail.net> wrote:
>
> > If the peer is closed, we will never get more data, so
> > tcp_bpf_wait_data will get stuck forever. In case we passed
> > MSG_DONTWAIT to recv(), we get EAGAIN but we should actually get
> > 0.
> >
> > From man 2 recv:
> >
> >     RETURN VALUE
> >
> >     When a stream socket peer has performed an orderly shutdown, the
> >     return value will be 0 (the traditional "end-of-file" return).
> >
> > This patch makes tcp_bpf_wait_data always return 1 when the peer
> > socket has been shutdown. Either we have data available, and it would
> > have returned 1 anyway, or there isn't, in which case we'll call
> > tcp_recvmsg which does the right thing in this situation.
> >
> > Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
> > Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> > ---
> >  net/ipv4/tcp_bpf.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> > index 2b915aafda42..7aa68f4aae6c 100644
> > --- a/net/ipv4/tcp_bpf.c
> > +++ b/net/ipv4/tcp_bpf.c
> > @@ -245,6 +245,9 @@ static int tcp_bpf_wait_data(struct sock *sk, struct sk_psock *psock,
> >       DEFINE_WAIT_FUNC(wait, woken_wake_function);
> >       int ret = 0;
> >
> > +     if (sk->sk_shutdown & RCV_SHUTDOWN)
> > +             return 1;
> > +
> >       if (!timeo)
> >               return ret;
> >
>
> Acked-by: Jakub Sitnicki <jakub@cloudflare.com>

Applied. Thanks
