Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C622665F9B
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 16:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235658AbjAKPs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 10:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239657AbjAKPsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 10:48:38 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F21C34774;
        Wed, 11 Jan 2023 07:47:51 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id c8-20020a17090a4d0800b00225c3614161so20433439pjg.5;
        Wed, 11 Jan 2023 07:47:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Gj+rHUQSHl08kG5q/y5nClhBM+nXgO1wjgjAshKqRk4=;
        b=BA2MTP8TRivv5ERqEnO+FDXOnY5MGer/9WLPAKaw8wQUvIBNxsRh57uL9s8vhJ+qCy
         Fxv4LGKl0dzupA/mFiJLV5n5+xaz7/oUy05rIzAPz7STFw4Ux0B1+zO37hSvsC1CmTcK
         KUawJMgPgHd4ZqdnQSK24z2zfBI4u0R8kcqkmKKjnmaXgYRmm2TYPUbm6yNxKo7N/tC+
         55QpGyiz+5yliIiBlZt/zss5KKUAJE/9I44xCllcy/POmvOH8Jj4Tpfl5UWD/IP0u/li
         +fCvkAA7fC5op6sbxMc7KqGTF5ixYoVjf+MlkoJRSqMADNTAIs/tOP7pPKiQmL3pgtW8
         /UlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gj+rHUQSHl08kG5q/y5nClhBM+nXgO1wjgjAshKqRk4=;
        b=4y9iAXoWzHKU/OBMqIjBNH5t9tQHgG6Pya412TS7CqLa2mLEcUrNoCY/gGBzoc2F+L
         kywwS3/enEJC+95EP0Qs44Tazf+wZaeIZKaQ164ilAU2dNPdAe5nIWYAaB6IM5OmWh37
         8Brc0I8o8UI8ufBkqDVD0QtFPOcNNpzT8Y+MAKa4zB19nb75iNo7k66UOaogsMMOgQgQ
         UXGEoanN+Se4jTgKHJsfVZXcj9DlqPwOCs64A3X/FeR11VvT3KBGRYTe3x1MW62810Tz
         KGwZ02akC4yyXPrjJLvWjQ0+8+fPqX/TG4k5ni3mpdFitQk9HUS0iWCWGUbSxQvnjn9s
         pUYQ==
X-Gm-Message-State: AFqh2kroQe2/2T5A/HpglP7rCi9uyWqs63kcIGzuHqZKjM5tE2yQwRkS
        ckaqB5RWv2XaTS84dGSnEEAs9cwwY4YYHmcxKio=
X-Google-Smtp-Source: AMrXdXugVy81scU/ovy38kPXgK2XTNp3pAqYobSDJPO7mipFqeXtmPEHSEe24ieDNYOyCaNvXpZLQPLAHrSNv76ck3E=
X-Received: by 2002:a17:902:8a8f:b0:190:fc28:8cb6 with SMTP id
 p15-20020a1709028a8f00b00190fc288cb6mr4195582plo.144.1673452070938; Wed, 11
 Jan 2023 07:47:50 -0800 (PST)
MIME-Version: 1.0
References: <20230110173007.57110-1-szymon.heidrich@gmail.com>
 <ece5f6a7fad9eb55d0fbf97c6227571e887c2c33.camel@gmail.com> <d06d2e44-7403-7e7e-1936-588139bf448e@gmail.com>
In-Reply-To: <d06d2e44-7403-7e7e-1936-588139bf448e@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 11 Jan 2023 07:47:39 -0800
Message-ID: <CAKgT0UePq+Gg5mpvD7ag=ern9JN5JyAFv5RPc05Zn9jSh4W+0g@mail.gmail.com>
Subject: Re: [PATCH] rndis_wlan: Prevent buffer overflow in rndis_query_oid
To:     Szymon Heidrich <szymon.heidrich@gmail.com>
Cc:     kvalo@kernel.org, jussi.kivilinna@iki.fi, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
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

On Wed, Jan 11, 2023 at 1:54 AM Szymon Heidrich
<szymon.heidrich@gmail.com> wrote:
>
> On 10/01/2023 20:39, Alexander H Duyck wrote:
> > On Tue, 2023-01-10 at 18:30 +0100, Szymon Heidrich wrote:
> >> Since resplen and respoffs are signed integers sufficiently
> >> large values of unsigned int len and offset members of RNDIS
> >> response will result in negative values of prior variables.
> >> This may be utilized to bypass implemented security checks
> >> to either extract memory contents by manipulating offset or
> >> overflow the data buffer via memcpy by manipulating both
> >> offset and len.
> >>
> >> Additionally assure that sum of resplen and respoffs does not
> >> overflow so buffer boundaries are kept.
> >>
> >> Fixes: 80f8c5b434f9 ("rndis_wlan: copy only useful data from rndis_command respond")
> >> Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
> >> ---
> >>  drivers/net/wireless/rndis_wlan.c | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
> >> index 82a7458e0..d7fc05328 100644
> >> --- a/drivers/net/wireless/rndis_wlan.c
> >> +++ b/drivers/net/wireless/rndis_wlan.c
> >> @@ -697,7 +697,7 @@ static int rndis_query_oid(struct usbnet *dev, u32 oid, void *data, int *len)
> >>              struct rndis_query_c    *get_c;
> >>      } u;
> >>      int ret, buflen;
> >> -    int resplen, respoffs, copylen;
> >> +    u32 resplen, respoffs, copylen;
> >
> > Rather than a u32 why not just make it an size_t? The advantage is that
> > is the native type for all the memory allocation and copying that takes
> > place in the function so it would avoid having to cast between u32 and
> > size_t.
>
> My sole intention with this patch was to address the exploitable overflow
> with minimal chance of introducing any extra issues.
> Sure some things probably could be done differently, but I would stick to
> the choices made by original authors of this driver, especially since Greg
> mentioned that RNDIS support generally should be dropped at some point.

My main concern was that your change will introduce a comparison
between signed and unsigned integer expressions. If you build with W=3
you should find that your changes add new warnings when they trigger
the "-Wsign-compare" check. Based on the comment earlier that you were
concerned about integer roll-over I thought that it might be good to
address that as well.

Basically my initial thought was that buflen should be a u32, but I
had opted to suggest size_t since that is the native type for the size
of memory regions in the kernel.

> > Also why not move buflen over to the unsigned integer category with the
> > other values you stated were at risk of overflow?
> >
> >>
> >>      buflen = *len + sizeof(*u.get);
> >>      if (buflen < CONTROL_BUFFER_SIZE)
> >
> > For example, this line here is comparing buflen to a fixed constant. If
> > we are concerned about overflows this could be triggering an integer
> > overflow resulting in truncation assuming *len is close to the roll-
> > over threshold.
>
> I'm not sure how this would be exploitable since len is controlled by the
> developer rather than potential attacker, at least in existing code. Please
> correct me in case I'm wrong.

The fact that w/ buflen signed and your other variables unsigned it
can lead to mix-ups between the comparisons below as it has to promote
one side or the other so that the types match before making the
comparison.

> > By converting to a size_t we would most likely end up blowing up on the
> > kmalloc and instead returning an -ENOMEM.
> >
> >> @@ -740,7 +740,7 @@ static int rndis_query_oid(struct usbnet *dev, u32 oid, void *data, int *len)
> >
> > Also with any type change such as this I believe you would also need to
> > update the netdev_dbg statement that displays respoffs and the like to
> > account for the fact that you are now using an unsigned value.
> > Otherwise I believe %d will display the value as a signed integer
> > value.
> >
> >>                      goto exit_unlock;
> >>              }
> >>
> >> -            if ((resplen + respoffs) > buflen) {
> >> +            if (resplen > (buflen - respoffs)) {
> >>                      /* Device would have returned more data if buffer would
> >>                       * have been big enough. Copy just the bits that we got.
> >>                       */
> >
> > Actually you should be able to simplfy this further. Assuming resplen,
> > buflen and respoffs all the same type this entire if statement could be
> > broken down into:
> >               copylen = min(resplen, buflen - respoffs);
> >
> >
>
> Agree, yet I would prefer to avoid any non-essential changes to keep the risk
> of introducing errors as low as possible. I intentionally refrained from any
> additional modifications. Is this acceptable?
>
> Thank you for your review, I really appreciate all the suggestions.

What I was getting at is that with this change the use of min should
result in almost exactly the same assembler code. If you look at the
min macro all it is doing is a comparison followed by an assignment,
and in your case you are working with only the two values "resplen"
and "buflen - respoffs" so it just saves space to make use of the
macro.

If you opt to not use the macro at a minimum you can get rid of the
parenthesis around "(buflen - respoffs)" since the order of operations
will complete the subtraction first before the comparison.
