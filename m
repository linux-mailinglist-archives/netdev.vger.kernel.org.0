Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6AA423E03
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 19:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392713AbfETRFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 13:05:38 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41759 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390006AbfETRFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 13:05:38 -0400
Received: by mail-ed1-f68.google.com with SMTP id m4so24908908edd.8;
        Mon, 20 May 2019 10:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OXzVLW5EpqxY+BN5u1Vsu4+duiB4QcdQ8sWM4u2JA90=;
        b=Gwww3aaU7y7zOHYkwmwbAcjKvlfAz1HeiKD4eRIU+qd+YGOBBI56iOegMUzaDNtS5/
         tPdvuZ3Z+U/Io2cAZF/KT1/OhZRlGWqAePyYuoxibxy28XmvUa0kxOgh6T7RgglrPGjG
         ZOKjTrS7GzJ1yAFQpgUYCNziSE6qCu4+dCczcnc1f4vXlrCz3tDiJHEuCa6rIN/99t2I
         2Pq2mxvREq1171PWoBo8NTGIKLqwoZ3Lt1isLRShBUuSm1ly6sTpJ4yizWr0I6UQ6qTO
         J2PEj3xurmc1ZCYOa9ndBgma1FoXnWlh222pMhCthpz+2QI8/Ih09tLUTXyodLk3h/vF
         hmxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OXzVLW5EpqxY+BN5u1Vsu4+duiB4QcdQ8sWM4u2JA90=;
        b=YlvnNKFUM0nntVAKwUzpk1j8ANkdMn1/Lpx2t0skSJk/sMxDKfa0+fEzxmAEC1vQi5
         ofuiQJapCuaCNG1KGaHtIb/haCBFzel0UC6cJ3H38VEutmIXyJlVQME+qJFrv3+4y87v
         yflTHPYsS9rrPZqJWajCSUIa8RvGKe2uywsLeiYiZyq1xRD973gZr90wxluO89LxG2fd
         9T/ceLM7YebJjoVC3tXniLkqIY93Zx2Ln3RFmm2JU5/vAg7j2RSrBL6Xo3nuSNG22RSO
         Kbk/m2uGZgPhHujDJTxtvVCqF8tN2g2aX8v9XkPmiNCQGXE24uAVy4vJ8DscZEk6s6ad
         9wmQ==
X-Gm-Message-State: APjAAAWLGLdsWW+eKUwTqsVgxCDioulOB9fMAysGdme2QS4Ce+pm1KuP
        3XyzkQRIxYxxOy4b+W6gZayVWQveITjDzZrPdOo=
X-Google-Smtp-Source: APXvYqwAWYjUqNwga3IGqyvDXRz6Ayeuvbmx8E0yma/gdydaSLC2gGlrdIps5FN3Mr4TU31/EVCepxajOSqZgABdl9g=
X-Received: by 2002:a50:9968:: with SMTP id l37mr76248294edb.143.1558371936408;
 Mon, 20 May 2019 10:05:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190520093157.59825-1-anirudh.gupta@sophos.com> <20190520153219.oq3se5wvkasgbtkp@gondor.apana.org.au>
In-Reply-To: <20190520153219.oq3se5wvkasgbtkp@gondor.apana.org.au>
From:   Anirudh Gupta <anirudhrudr@gmail.com>
Date:   Mon, 20 May 2019 22:35:24 +0530
Message-ID: <CAN2cbVc3bbEcDB87S4UpySnMtC7oi40bWPK8bd4wW_nv5qEDJg@mail.gmail.com>
Subject: Re: [PATCH net] xfrm: Fix xfrm sel prefix length validation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Anirudh Gupta <anirudh.gupta@sophos.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Herbert,
Yes, I notice that is the only verification of p->family from userspace.
However, the underlying conditions added in commit '07bf7908950a',
validates the selector src/dest prefix len.

So, In case when adding a new SA entry, the family of Selector src/dst
is IPv6 and state id src/dst family is IPv4.
Then, the IPv6 selector prefix verification falls in IPv4 switch case.
This results in not being able to provide prefix length of more than
32, even for IPv6 src/dst.

The above mentioned behaviour can easily be reproduced using below
command having IPv6 selector src/dst with greater than 32 prefix
length.
ip xfrm state add src 1.1.6.1 dst 1.1.6.2 proto esp spi 4260196 \
reqid 20004 mode tunnel aead "rfc4106(gcm(aes))" \
0x1111016400000000000000000000000044440001 128 \
sel src 1011:1:4::2/128 sel dst 1021:1:4::2/128 dev Port5

Please let me know, if I fail to explain my point or I am overlooking anything.

Thanks & Regards,
Anirudh


On Mon, May 20, 2019 at 9:02 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, May 20, 2019 at 03:01:56PM +0530, Anirudh Gupta wrote:
> >
> > diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
> > index eb8d14389601..fc2a8c08091b 100644
> > --- a/net/xfrm/xfrm_user.c
> > +++ b/net/xfrm/xfrm_user.c
> > @@ -149,7 +149,7 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
> >       int err;
> >
> >       err = -EINVAL;
> > -     switch (p->family) {
> > +     switch (p->sel.family) {
> >       case AF_INET:
> >               if (p->sel.prefixlen_d > 32 || p->sel.prefixlen_s > 32)
> >                       goto out;
>
> You just removed the only verification of p->family...
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt



-- 
Regards

Anirudh Gupta
