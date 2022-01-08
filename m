Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5206488468
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 17:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbiAHQLZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 8 Jan 2022 11:11:25 -0500
Received: from mail-yb1-f179.google.com ([209.85.219.179]:37756 "EHLO
        mail-yb1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbiAHQLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 11:11:24 -0500
Received: by mail-yb1-f179.google.com with SMTP id 127so9591728ybb.4;
        Sat, 08 Jan 2022 08:11:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4Ba5ev7Mc37f12MPn8Bo9MNz+S3JxhJYNwMKImyhXUw=;
        b=kBUxGq50S7kKqYppmTZr61IPp8c5JGEltU/h3g6fLoIdKZPNFejnXj2HDLS+LDR556
         1asDilxX2ARX03ubZo+7UMcqJXD1/jZBb3f/X62hm8wyvH4ZqMSuIUdLl5qI8Hz8o0fK
         jSZuTV1Olaxh3OqR/q/FKV5+pxOb/ggmGM8RURXF8csNDkTHy6LtIcPa//RJDixvmJ0q
         yFjxQSxDj+kbe/2V5qgQ+3LpuOrKvZhYg4QpZq9fplEo6ZwnhNlB2zAIs6KrYs3PAuqf
         0wBxsTOpHqTW2aBqiEFjMBHIsVdXV0HW2SE+akv3x72A+I3YbekBT8ii5ATOXGBf+eXo
         duYw==
X-Gm-Message-State: AOAM530L8f/5N0+AIQwniwvKbwu3gL9gMEWslHGOETBj+3iHdjgQtY3e
        sIigmUkBTHrdUawoEs0KQrqD6RqEyne/HjrC2ig=
X-Google-Smtp-Source: ABdhPJwTT7jGLzi6Jaj1sdjbAD+HtmppUtGTcOIYx+ZJx6FdVXaBSRn3vcKzO1bYL/hFb9m1SolpNiXQX+pqMlhQwaQ=
X-Received: by 2002:a25:abe3:: with SMTP id v90mr32406661ybi.25.1641658283543;
 Sat, 08 Jan 2022 08:11:23 -0800 (PST)
MIME-Version: 1.0
References: <20220108143319.3986923-1-trix@redhat.com>
In-Reply-To: <20220108143319.3986923-1-trix@redhat.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sun, 9 Jan 2022 01:11:12 +0900
Message-ID: <CAMZ6RqL4iznd+Hz_J02hheFF1xGRHo9nUzTNXGD=ey=GPA1WmA@mail.gmail.com>
Subject: Re: [PATCH] can: janz-ican3: initialize dlc variable
To:     trix@redhat.com
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        Stefan.Maetje@esd.eu, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat. 8 Jan 2022 à 23:33, <trix@redhat.com> wrote:
> From: Tom Rix <trix@redhat.com>
>
> Clang static analysis reports this problem
> janz-ican3.c:1311:2: warning: Undefined or garbage value returned to caller
>         return dlc;
>         ^~~~~~~~~~
>
> dlc is only set with this conditional
>         if (!(cf->can_id & CAN_RTR_FLAG))
>                 dlc = cf->len;
>
> But is always returned.  So initialize dlc to 0.

Yes. The actual intent is to return a length of 0 for RTR frames.

> Fixes: cc4b08c31b5c ("can: do not increase tx_bytes statistics for RTR frames")
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  drivers/net/can/janz-ican3.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
> index 5b677af5f2a41..808c105cf8f7e 100644
> --- a/drivers/net/can/janz-ican3.c
> +++ b/drivers/net/can/janz-ican3.c
> @@ -1285,7 +1285,7 @@ static unsigned int ican3_get_echo_skb(struct ican3_dev *mod)
>  {
>         struct sk_buff *skb = skb_dequeue(&mod->echoq);
>         struct can_frame *cf;
> -       u8 dlc;
> +       u8 dlc = 0;
>
>         /* this should never trigger unless there is a driver bug */
>         if (!skb) {
> --
> 2.26.3

I missed that when writing the patch.

I thought that I did my due diligence by running a "make W=1"
with GCC but I did not catch the error. I should have been more
precocious and run a "make W=2".

Thank you.

Acked-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
