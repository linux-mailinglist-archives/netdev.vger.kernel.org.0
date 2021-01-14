Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1FB2F5D1E
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 10:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbhANJRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 04:17:09 -0500
Received: from mail-qk1-f173.google.com ([209.85.222.173]:33699 "EHLO
        mail-qk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727512AbhANJRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 04:17:06 -0500
Received: by mail-qk1-f173.google.com with SMTP id f26so6573864qka.0;
        Thu, 14 Jan 2021 01:16:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Py9tv1BOpYTNv98TYkoTeeYi5fcvbtH9uFZFAg3tHPA=;
        b=JVFLQ9a4i65jcHmmTQsoGidozDFYUs3C3o6Y7wSSxK7E5RyoWcKvxbxbSSWDCD03H7
         SlWmui3A+/X8mH1b7NFiT7Ew+Ocwb796314vtj5FGm+ZGIegR4QYKwvLVTu6FX0EhJYy
         Rva3PZYqO4TRnEh0b/nXeYawXNbpc+hsytP9084f5e4UmU+1xoBFyap1KSEoh69pMXuP
         ge+KVSdbUHvMTvN6UXycQYQYSZLPddf8f1ZyY7jxPDhAhsRUciemgPlbslD/p8GYXDno
         EpPwrzW7gMOREMcXCVpGKw+QrkYU1y5zXm87rB4+Fldw2KSu26DBMNz6noCGE6GX5NcO
         kVWQ==
X-Gm-Message-State: AOAM531WrZXBoUdKRKonDVrYu/v/6VfPiB1Y6CA8Ql2UVHmKJTlcb8+Y
        5SnjRuIRuJ1NHJnlE003Rg5xfy7XwA86VMB5nz4=
X-Google-Smtp-Source: ABdhPJxSDzUfvPdnulzChrmcZy1CTadAtqqs9/JIrB+O94LLFUqJl9pZaZrwEu/zPXmwUwIhaMRFeL+2myUrX2Nzq5M=
X-Received: by 2002:a25:5583:: with SMTP id j125mr8348157ybb.307.1610615785252;
 Thu, 14 Jan 2021 01:16:25 -0800 (PST)
MIME-Version: 1.0
References: <20210113211410.917108-1-mkl@pengutronix.de> <20210113211410.917108-10-mkl@pengutronix.de>
 <CAMZ6Rq+Wxn_kG7rSkUrMYMqNw790SMe-UKmpUVdEA_eGcjoT+g@mail.gmail.com> <2f3fff1a-9a50-030b-6a29-2009c8b65b68@hartkopp.net>
In-Reply-To: <2f3fff1a-9a50-030b-6a29-2009c8b65b68@hartkopp.net>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Thu, 14 Jan 2021 18:16:14 +0900
Message-ID: <CAMZ6RqLKYnGDePueN1ftL9a47Qf-ZR7bc4eLGwzCkncsD6ok2Q@mail.gmail.com>
Subject: Re: [net-next 09/17] can: length: can_fd_len2dlc(): simplify length calculcation
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-can <linux-can@vger.kernel.org>, kernel@pengutronix.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 14 Jan 2021 at 17:23, Oliver Hartkopp <socketcan@hartkopp.net> wrote:
> On 14.01.21 02:59, Vincent MAILHOL wrote:
> > On Tue. 14 Jan 2021 at 06:14, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> >>
> >> If the length paramter in len2dlc() exceeds the size of the len2dlc array, we
> >> return 0xF. This is equal to the last 16 members of the array.
> >>
> >> This patch removes these members from the array, uses ARRAY_SIZE() for the
> >> length check, and returns CANFD_MAX_DLC (which is 0xf).
> >>
> >> Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> >> Link: https://lore.kernel.org/r/20210111141930.693847-9-mkl@pengutronix.de
> >> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> >> ---
> >>   drivers/net/can/dev/length.c | 6 ++----
> >>   1 file changed, 2 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/net/can/dev/length.c b/drivers/net/can/dev/length.c
> >> index 5e7d481717ea..d695a3bee1ed 100644
> >> --- a/drivers/net/can/dev/length.c
> >> +++ b/drivers/net/can/dev/length.c
> >> @@ -27,15 +27,13 @@ static const u8 len2dlc[] = {
> >>          13, 13, 13, 13, 13, 13, 13, 13, /* 25 - 32 */
> >>          14, 14, 14, 14, 14, 14, 14, 14, /* 33 - 40 */
> >>          14, 14, 14, 14, 14, 14, 14, 14, /* 41 - 48 */
> >> -       15, 15, 15, 15, 15, 15, 15, 15, /* 49 - 56 */
> >> -       15, 15, 15, 15, 15, 15, 15, 15  /* 57 - 64 */
> >>   };
> >>
> >>   /* map the sanitized data length to an appropriate data length code */
> >>   u8 can_fd_len2dlc(u8 len)
> >>   {
> >> -       if (unlikely(len > 64))
> >> -               return 0xF;
> >> +       if (len > ARRAY_SIZE(len2dlc))
> >
> > Sorry but I missed an of-by-one issue when I did my first
> > review. Don't know why but it popped to my eyes this morning when
> > casually reading the emails.
>
> Oh, yes.
>
> The fist line is 0 .. 8 which has 9 bytes.
>
> I also looked on it (from the back), and wondered if it was correct. But
> didn't see it either at first sight.
>
> >
> > ARRAY_SIZE(len2dlc) is 49. If len is between 0 and 48, use the
> > array, if len is greater *or equal* return CANFD_MAX_DLC.
>
> All these changes and discussions make it very obviously more tricky to
> understand that code.
>
> I don't really like this kind of improvement ...
>
> Before that it was pretty clear that we only catch an out of bounds
> value and usually grab the value from the table.

I understand your point: all three of us initially missed that
bug. But now that it is fixed, I would still prefer to keep
Marc's patch.


Yours sincerely,
Vincent

> >
> > In short, replace > by >=:
> > +       if (len >= ARRAY_SIZE(len2dlc))
> >
> >> +               return CANFD_MAX_DLC;
> >>
> >>          return len2dlc[len];
> >>   }
