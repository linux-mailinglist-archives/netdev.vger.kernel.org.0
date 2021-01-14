Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98322F577C
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729519AbhANCAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:00:37 -0500
Received: from mail-qk1-f173.google.com ([209.85.222.173]:34825 "EHLO
        mail-qk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727880AbhANCAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 21:00:19 -0500
Received: by mail-qk1-f173.google.com with SMTP id n142so5215897qkn.2;
        Wed, 13 Jan 2021 18:00:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1S4ht7EU4Q1EAaIDGPaE3cK58qdGEWTbB4lD0RChk5k=;
        b=jpOzYRG53uyjQ7CLcR3VGfDaQKpFajfWq/eMpQ9R+Vlb5aF4nwRKLESuClV9am7XxR
         j4VbFWVpFfh3+nv8xOBatwlyqvznRAoe9vbKxJo0Mf1N7tiomikI0Rtvh+PHRNjPeMz9
         MHYQgxpUEp6cNX7vaqp3lOyI2vE24KWr0Xj5jV30YYOeAbS01sMP1uKlc9uA9mAdfUOD
         Mn+GlmhQqSNOVVsICSoQgLdsyFxiKVX2xtV6D83OzqfOTAPQc63kixpvr5Z2HbHn/aMQ
         Df323WNxTfzn2iv8xldjV7rmA+oRvd7IiSW0qAMU5tpAHFc4bpcXstfl6lPHYxNPgixx
         /p8A==
X-Gm-Message-State: AOAM533pVRglaVtIuNmfFFGn5QVSrpmN1JI82GPdvujUO4lq5/yrbYW0
        n0OzAE5UFQZ6GiMpmeBYw5xldBzoh1jEn9ru50Zm5tqR793AJQ==
X-Google-Smtp-Source: ABdhPJzsaUyplrpR1IuUXmDMQCoLG4sBSzKOfjrUTbiUacoqd0G/8hBduS3nKQvvC1Q0RTpBy801lf3JjtuZr8DQNzE=
X-Received: by 2002:a05:6902:4f4:: with SMTP id w20mr7152691ybs.125.1610589578299;
 Wed, 13 Jan 2021 17:59:38 -0800 (PST)
MIME-Version: 1.0
References: <20210113211410.917108-1-mkl@pengutronix.de> <20210113211410.917108-10-mkl@pengutronix.de>
In-Reply-To: <20210113211410.917108-10-mkl@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Thu, 14 Jan 2021 10:59:27 +0900
Message-ID: <CAMZ6Rq+Wxn_kG7rSkUrMYMqNw790SMe-UKmpUVdEA_eGcjoT+g@mail.gmail.com>
Subject: Re: [net-next 09/17] can: length: can_fd_len2dlc(): simplify length calculcation
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-can <linux-can@vger.kernel.org>, kernel@pengutronix.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 14 Jan 2021 at 06:14, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> If the length paramter in len2dlc() exceeds the size of the len2dlc array, we
> return 0xF. This is equal to the last 16 members of the array.
>
> This patch removes these members from the array, uses ARRAY_SIZE() for the
> length check, and returns CANFD_MAX_DLC (which is 0xf).
>
> Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> Link: https://lore.kernel.org/r/20210111141930.693847-9-mkl@pengutronix.de
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>  drivers/net/can/dev/length.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/can/dev/length.c b/drivers/net/can/dev/length.c
> index 5e7d481717ea..d695a3bee1ed 100644
> --- a/drivers/net/can/dev/length.c
> +++ b/drivers/net/can/dev/length.c
> @@ -27,15 +27,13 @@ static const u8 len2dlc[] = {
>         13, 13, 13, 13, 13, 13, 13, 13, /* 25 - 32 */
>         14, 14, 14, 14, 14, 14, 14, 14, /* 33 - 40 */
>         14, 14, 14, 14, 14, 14, 14, 14, /* 41 - 48 */
> -       15, 15, 15, 15, 15, 15, 15, 15, /* 49 - 56 */
> -       15, 15, 15, 15, 15, 15, 15, 15  /* 57 - 64 */
>  };
>
>  /* map the sanitized data length to an appropriate data length code */
>  u8 can_fd_len2dlc(u8 len)
>  {
> -       if (unlikely(len > 64))
> -               return 0xF;
> +       if (len > ARRAY_SIZE(len2dlc))

Sorry but I missed an of-by-one issue when I did my first
review. Don't know why but it popped to my eyes this morning when
casually reading the emails.

ARRAY_SIZE(len2dlc) is 49. If len is between 0 and 48, use the
array, if len is greater *or equal* return CANFD_MAX_DLC.

In short, replace > by >=:
+       if (len >= ARRAY_SIZE(len2dlc))

> +               return CANFD_MAX_DLC;
>
>         return len2dlc[len];
>  }

Yours sincerely,
Vincent
