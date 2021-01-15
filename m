Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C982F704B
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 02:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731780AbhAOB6B convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 14 Jan 2021 20:58:01 -0500
Received: from mail-yb1-f181.google.com ([209.85.219.181]:34434 "EHLO
        mail-yb1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729511AbhAOB6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 20:58:01 -0500
Received: by mail-yb1-f181.google.com with SMTP id x6so3686353ybr.1;
        Thu, 14 Jan 2021 17:57:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VqkrrEe6H1YIkS5n/J/G7K0xHbD/rvMI2NvBBpdBVcI=;
        b=K8R9hYJmLZTNDF31WV8nRqlztl3RPvmQpEHIfCRVIw4DGgmZFPUtbcNx07TrAsLLtN
         eyFEZpmDJApEEArERyMXYY8Qbe0AXyScsNSx9KWAtUqseiTDB2a3aKjN9OtRHDwjwN/E
         hTMu73tqN0i8tdHoXH/jUy0HMYZQeiqSw6QCwXsMgrijshh+xFfyERZeN1Sf8pQDPemK
         YfRjpOHd27D8ByBAHJUY8rEtzEUwIoIsbLi2HdUkONnvTor6ztvZteCQPVfNqgHMLGPn
         uSOMjUnrRawLmyfTVegcVgsgZvGiM/yBGV0KwcPQrZOAWNGZzRJJT8FFMIdSxOGEXFOC
         ZwGg==
X-Gm-Message-State: AOAM530yD1rysckdfVvG+VPT6ql+vA60PJLDc4XHLyBOapgpOte9h4FD
        BvYaT9wiPyP6aJq7JVfA7Oe9OckM0dp8DlOqulg=
X-Google-Smtp-Source: ABdhPJwIi50eOw+YCb8LgH/iHZV9hn9c6qApdoFztiCL/OpFY5v5ouXTMqX8rxudzSCkUf0WTu4cEGTBjE5YZL1Wq78=
X-Received: by 2002:a25:5583:: with SMTP id j125mr13357564ybb.307.1610675839556;
 Thu, 14 Jan 2021 17:57:19 -0800 (PST)
MIME-Version: 1.0
References: <20210113211410.917108-1-mkl@pengutronix.de> <20210113211410.917108-10-mkl@pengutronix.de>
 <CAMZ6Rq+Wxn_kG7rSkUrMYMqNw790SMe-UKmpUVdEA_eGcjoT+g@mail.gmail.com>
 <2f3fff1a-9a50-030b-6a29-2009c8b65b68@hartkopp.net> <CAMZ6RqLKYnGDePueN1ftL9a47Qf-ZR7bc4eLGwzCkncsD6ok2Q@mail.gmail.com>
 <75d3c8e9-acbd-09e9-e185-94833dbfb391@hartkopp.net>
In-Reply-To: <75d3c8e9-acbd-09e9-e185-94833dbfb391@hartkopp.net>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Fri, 15 Jan 2021 10:57:08 +0900
Message-ID: <CAMZ6RqKZcuJH2DPeZjgqvL2MG+LoLScHTdd4s+K9OFYDUFT2ZQ@mail.gmail.com>
Subject: Re: [net-next 09/17] can: length: can_fd_len2dlc(): simplify length calculcation
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-can <linux-can@vger.kernel.org>, kernel@pengutronix.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri. 15 Jan 2021 at 02:03, Oliver Hartkopp <socketcan@hartkopp.net> wrote:
> On 14.01.21 10:16, Vincent MAILHOL wrote:
> > On Tue. 14 Jan 2021 at 17:23, Oliver Hartkopp <socketcan@hartkopp.net> wrote:
> >> On 14.01.21 02:59, Vincent MAILHOL wrote:
> >>> On Tue. 14 Jan 2021 at 06:14, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> >>>>
> >>>> If the length paramter in len2dlc() exceeds the size of the len2dlc array, we
> >>>> return 0xF. This is equal to the last 16 members of the array.
> >>>>
> >>>> This patch removes these members from the array, uses ARRAY_SIZE() for the
> >>>> length check, and returns CANFD_MAX_DLC (which is 0xf).
> >>>>
> >>>> Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> >>>> Link: https://lore.kernel.org/r/20210111141930.693847-9-mkl@pengutronix.de
> >>>> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> >>>> ---
> >>>>    drivers/net/can/dev/length.c | 6 ++----
> >>>>    1 file changed, 2 insertions(+), 4 deletions(-)
> >>>>
> >>>> diff --git a/drivers/net/can/dev/length.c b/drivers/net/can/dev/length.c
> >>>> index 5e7d481717ea..d695a3bee1ed 100644
> >>>> --- a/drivers/net/can/dev/length.c
> >>>> +++ b/drivers/net/can/dev/length.c
> >>>> @@ -27,15 +27,13 @@ static const u8 len2dlc[] = {
> >>>>           13, 13, 13, 13, 13, 13, 13, 13, /* 25 - 32 */
> >>>>           14, 14, 14, 14, 14, 14, 14, 14, /* 33 - 40 */
> >>>>           14, 14, 14, 14, 14, 14, 14, 14, /* 41 - 48 */
> >>>> -       15, 15, 15, 15, 15, 15, 15, 15, /* 49 - 56 */
> >>>> -       15, 15, 15, 15, 15, 15, 15, 15  /* 57 - 64 */
> >>>>    };
> >>>>
> >>>>    /* map the sanitized data length to an appropriate data length code */
> >>>>    u8 can_fd_len2dlc(u8 len)
> >>>>    {
> >>>> -       if (unlikely(len > 64))
> >>>> -               return 0xF;
> >>>> +       if (len > ARRAY_SIZE(len2dlc))
> >>>
> >>> Sorry but I missed an of-by-one issue when I did my first
> >>> review. Don't know why but it popped to my eyes this morning when
> >>> casually reading the emails.
> >>
> >> Oh, yes.
> >>
> >> The fist line is 0 .. 8 which has 9 bytes.
> >>
> >> I also looked on it (from the back), and wondered if it was correct. But
> >> didn't see it either at first sight.
> >>
> >>>
> >>> ARRAY_SIZE(len2dlc) is 49. If len is between 0 and 48, use the
> >>> array, if len is greater *or equal* return CANFD_MAX_DLC.
> >>
> >> All these changes and discussions make it very obviously more tricky to
> >> understand that code.
> >>
> >> I don't really like this kind of improvement ...
> >>
> >> Before that it was pretty clear that we only catch an out of bounds
> >> value and usually grab the value from the table.
> >
> > I understand your point: all three of us initially missed that
> > bug. But now that it is fixed, I would still prefer to keep
> > Marc's patch.
>
> No, I'm still against it as it is now.
>
> Even
>
>         if (len >= ARRAY_SIZE(len2dlc))
>
> would need some comment that values > 48 lead to a DLC = 15.
>
> This is not intuitively understandable from that value
> "ARRAY_SIZE(len2dlc)" !
>
> Using ARRAY_SIZE() is a bad choice IMO.
>
> If it's really worth to save 16 bytes I would suggest this:
>
> diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
> index 3486704c8a95..0b0a5a16943a 100644
> --- a/drivers/net/can/dev.c
> +++ b/drivers/net/can/dev.c
> @@ -42,18 +42,17 @@ static const u8 len2dlc[] = {0, 1, 2, 3, 4, 5, 6, 7,
> 8,             /* 0 - 8 */
>                               10, 10, 10, 10,                    /* 13 -
> 16 */
>                               11, 11, 11, 11,                    /* 17 -
> 20 */
>                               12, 12, 12, 12,                    /* 21 -
> 24 */
>                               13, 13, 13, 13, 13, 13, 13, 13,    /* 25 -
> 32 */
>                               14, 14, 14, 14, 14, 14, 14, 14,    /* 33 -
> 40 */
> -                            14, 14, 14, 14, 14, 14, 14, 14,    /* 41 -
> 48 */
> -                            15, 15, 15, 15, 15, 15, 15, 15,    /* 49 -
> 56 */
> -                            15, 15, 15, 15, 15, 15, 15, 15};   /* 57 -
> 64 */
> +                            14, 14, 14, 14, 14, 14, 14, 14};   /* 41 -
> 48 */
> +                            /* 49 - 64 is checked in  can_fd_len2dlc() */

Ack

>
>   /* map the sanitized data length to an appropriate data length code */
>   u8 can_fd_len2dlc(u8 len)
>   {
> -       if (unlikely(len > 64))
> +       if (len > 48)

I personally prefer the use of macros instead of hardcoded values. 48 is the
last index of the table, i.e. it is ARRAY_SIZE(len2dlc) - 1.

For me, it is like doing this:
for (i = 0; i <= harcoded_value_representing_last_index_of_array; i++)
instead of this:
for (i = 0; i < ARRAY_SIZE(array); i++)

Definitely prefer the later and (len >= ARRAY_SIZE(len2dlc)) is nothing less
than the negation of the i < ARRAY_SIZE(array) that we usually see in a for
loop.

I recognize below patterns to be correct:
   i < ARRAY_SIZE(array): check that variable is inbound.
   i >= ARRAY_SIZE(array): check that variable is outbound.

Anything which deviates from those patterns is fishy and it is actually how
I spotted the bug.

If we don’t use ARRAY_SIZE() we lose that recognizable pattern and we need
to be aware of the actual content of len2dlc[] to understand the code.
(And I know that the table is just above the function and that this makes my
argument weaker).

So IMO, checks done against the array size should use the ARRAY_SIZE() macro
in order 1/ to make it a recognizable pattern and 2/ to make it work regardless
of the actual size of the table (i.e. no hardcoded value).

>                  return 0xF;

I would also prefer to use the CANFD_MAX_DLC macro here.


Yours sincerely,
Vincent


>          return len2dlc[len];
>   }
