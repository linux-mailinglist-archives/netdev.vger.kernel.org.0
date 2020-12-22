Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83DED2E105C
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 23:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbgLVWju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 17:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgLVWju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 17:39:50 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B9EC0613D3
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 14:39:09 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id lt17so20333967ejb.3
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 14:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZwTRX5V8Fqw4iudic5Z5Z5E+UH9jfXHgTmvTD/MWgdY=;
        b=IKmOzK7UMSS6mi9isXd9gHIE6sA29ei18yaJRaV2YA4wt8IPm4JMorBL9rNiHmYtT+
         U3DCOEDqfb3DVYKPaleKUPnJftZBc8qPxE57YY0wvcAxV4A/ah+fRTplj0KV5mliLE1w
         BTZqGqZTo0I41XCT7R6ZChC5SNthNH2D28e9/inlL2u3D7zxy+gt3UvDRm9HfAxw9tnq
         0cRwNVePQIKuEe81bbViU0icFELnY9JixWM/G6rRgSA7e04gUEYqfigpmlDL31ohLlzm
         DUrqlQs6hr12AxE1IpOcuCu7QAOAaBiDDlTc1wbX7eOe2++U2ftIQTrWlPgbVheDlcyE
         b2Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZwTRX5V8Fqw4iudic5Z5Z5E+UH9jfXHgTmvTD/MWgdY=;
        b=AMhm8EwAbUbfhMG2GJ3iKJv3rsEEmqK927A0gbhuanXy4Fy+TkNmMl1G5pdc2vK5tl
         iloy6hSOaDBpGsnrsHeNSmd76pmHLYUQCaTpHfko4yexWKvtb82BnKvjwqSwHyx1z3WZ
         oNjb0p4vJ5tfeK50ha1+VR3TRVSdBJVES50cpz2yylOE1K7Bx1dFw64uSlsUwzZ+l1Pz
         5q8O6bdUuXB6Q3IOktRKI8cEFM+l7YjgcFF+WCCx6P7kTpCeFzLtLqWAWSc6zIZwq3iy
         vGLERAWZpXbOH+PXwKDHIua2/irCffgMLXr6R+arOaRzxF7LI3x4lupYBTRmWRGLd4F3
         lGKA==
X-Gm-Message-State: AOAM531kX4jZtdUSdOGb4vnDRH5vK6iE/S/Z0LU6d9p6cQae8HXzLpVw
        O/Xc5Q9Arn7DqXmGZzLT/xJvTeOgS78aerjJauU=
X-Google-Smtp-Source: ABdhPJxaHos41f0l9Nu/2qwWmSlDLMEQVfoxm9CZReeTWvf6NGcF2ePAO7d8Zq648Mb4Uh4F0VBOjJZpI6TW6FP5jKY=
X-Received: by 2002:a17:906:158c:: with SMTP id k12mr3573209ejd.119.1608676748698;
 Tue, 22 Dec 2020 14:39:08 -0800 (PST)
MIME-Version: 1.0
References: <20201222000926.1054993-1-jonathan.lemon@gmail.com>
 <20201222000926.1054993-5-jonathan.lemon@gmail.com> <CAF=yD-K7bWE-U-O2J2Bwwi3E0NrX+horDARRgmBUU8Pqh6pH3Q@mail.gmail.com>
 <20201222174811.2mts4ojml6yafeou@bsd-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201222174811.2mts4ojml6yafeou@bsd-mbp.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 22 Dec 2020 17:38:31 -0500
Message-ID: <CAF=yD-+EZ95yEk27nzENn2TUM6fSqjZKCrU7DhAZuM+ejHtZfQ@mail.gmail.com>
Subject: Re: [PATCH 04/12 v2 RFC] skbuff: Push status and refcounts into sock_zerocopy_callback
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 12:48 PM Jonathan Lemon
<jonathan.lemon@gmail.com> wrote:
>
> On Tue, Dec 22, 2020 at 09:43:39AM -0500, Willem de Bruijn wrote:
> > On Mon, Dec 21, 2020 at 7:09 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> > >
> > > From: Jonathan Lemon <bsd@fb.com>
> > >
> > > Before this change, the caller of sock_zerocopy_callback would
> > > need to save the zerocopy status, decrement and check the refcount,
> > > and then call the callback function - the callback was only invoked
> > > when the refcount reached zero.
> > >
> > > Now, the caller just passes the status into the callback function,
> > > which saves the status and handles its own refcounts.
> > >
> > > This makes the behavior of the sock_zerocopy_callback identical
> > > to the tpacket and vhost callbacks.
> > >
> > > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> > > ---
> > >  include/linux/skbuff.h |  3 ---
> > >  net/core/skbuff.c      | 14 +++++++++++---
> > >  2 files changed, 11 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > > index fb6dd6af0f82..c9d7de9d624d 100644
> > > --- a/include/linux/skbuff.h
> > > +++ b/include/linux/skbuff.h
> > > @@ -1482,9 +1482,6 @@ static inline void skb_zcopy_clear(struct sk_buff *skb, bool zerocopy)
> > >         if (uarg) {
> > >                 if (skb_zcopy_is_nouarg(skb)) {
> > >                         /* no notification callback */
> > > -               } else if (uarg->callback == sock_zerocopy_callback) {
> > > -                       uarg->zerocopy = uarg->zerocopy && zerocopy;
> > > -                       sock_zerocopy_put(uarg);
> > >                 } else {
> > >                         uarg->callback(uarg, zerocopy);
> > >                 }
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index ea32b3414ad6..73699dbdc4a1 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -1194,7 +1194,7 @@ static bool skb_zerocopy_notify_extend(struct sk_buff *skb, u32 lo, u16 len)
> > >         return true;
> > >  }
> > >
> > > -void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
> > > +static void __sock_zerocopy_callback(struct ubuf_info *uarg)
> > >  {
> > >         struct sk_buff *tail, *skb = skb_from_uarg(uarg);
> > >         struct sock_exterr_skb *serr;
> > > @@ -1222,7 +1222,7 @@ void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
> > >         serr->ee.ee_origin = SO_EE_ORIGIN_ZEROCOPY;
> > >         serr->ee.ee_data = hi;
> > >         serr->ee.ee_info = lo;
> > > -       if (!success)
> > > +       if (!uarg->zerocopy)
> > >                 serr->ee.ee_code |= SO_EE_CODE_ZEROCOPY_COPIED;
> > >
> > >         q = &sk->sk_error_queue;
> > > @@ -1241,11 +1241,19 @@ void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
> > >         consume_skb(skb);
> > >         sock_put(sk);
> > >  }
> > > +
> > > +void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
> > > +{
> > > +       uarg->zerocopy = uarg->zerocopy & success;
> > > +
> > > +       if (refcount_dec_and_test(&uarg->refcnt))
> > > +               __sock_zerocopy_callback(uarg);
> > > +}
> > >  EXPORT_SYMBOL_GPL(sock_zerocopy_callback);
> >
> > I still think this helper is unnecessary. Just return immediately in
> > existing sock_zerocopy_callback if refcount is not zero.
>
> I think the helper makes the logic clearer, and prevents misuse of
> the success variable in the main function (use of last value vs the
> latched value).  If you really feel that strongly about it, I'll
> fold it into one function.

Ok. Thanks, no, it's fine.

>
> > >  void sock_zerocopy_put(struct ubuf_info *uarg)
> > >  {
> > > -       if (uarg && refcount_dec_and_test(&uarg->refcnt))
> > > +       if (uarg)
> > >                 uarg->callback(uarg, uarg->zerocopy);
> > >  }
> > >  EXPORT_SYMBOL_GPL(sock_zerocopy_put);
> >
> > This does increase the number of indirect function calls. Which are
> > not cheap post spectre.
> >
> > In the common case for msg_zerocopy we only have two clones, one sent
> > out and one on the retransmit queue. So I guess the cost will be
> > acceptable.
>
> Yes, this was the source of my original comment about this being
> a slight pessimization - moving the refcount into the function.
>
> I briefly considered adding a flag like 'use_refcnt', so the logic
> becomes:
>
>     if (uarg && (!uarg->use_refcnt || refcount_dec_and_test(&uarg->refcnt)))
>
> But thought this might be too much micro-optimization.  But if
> the call overhead is significant, I can put this back in.

Agreed on the premature optimization. Let's find out :)
