Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67112F0734
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 13:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbhAJMdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 07:33:11 -0500
Received: from mail-yb1-f178.google.com ([209.85.219.178]:46541 "EHLO
        mail-yb1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbhAJMdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 07:33:10 -0500
Received: by mail-yb1-f178.google.com with SMTP id f6so14142972ybq.13;
        Sun, 10 Jan 2021 04:32:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xf9Y4Sd28497N8HdTJIQDbuhCrniQEwtSYEyz2FWEz8=;
        b=RZM/oP18fqdYa7nUKAWFDEv6/1UXHqaObz6ZCkSHGPc0fCdG4bYMZl+SaQc1ekoYag
         OkTlWuVK9/Gzw73OJJyTNkdpNez2Z9KrCzn847kAKF3cR0Q/ivNaPPAxuXZtEjRCyt5P
         dP8Zrx2jGMz7hyCO7rVimQSVig5Sx2wq6ZrI4D7OY8wNMYO+p0FpRZaRMWomlNS27eSf
         FoP9uUxxf4ZGewK2+iGR/tdMDUf6Q/6qo04OP452zYIpQ/YjVVNHlAGBlaKKmwzzficw
         pfR6jMlkpiiGvbVjEvHlAc0YPXHjwvCDX/MEJ2O5tfuN8j25B0ZGzJO+16iDsQzFj218
         UDNQ==
X-Gm-Message-State: AOAM533jvG2gXBLlRSzc3X7Eo7XT71IDRNxbFYWfessXYnvwdOB0JKOs
        AZT8P/MjjvenpbCuhuXzSGNHLc5NC7wcelKobum2qLyHwEZ3zA==
X-Google-Smtp-Source: ABdhPJz2oeOyrvoUsKuLg9Bll0qpGCHxUqcgyHH+cOjcuPjB9q0ZnRE4Wq1BI5YBMbaQuBU99uJ8zcnKgcZQocltLO8=
X-Received: by 2002:a25:4744:: with SMTP id u65mr19439144yba.239.1610281949723;
 Sun, 10 Jan 2021 04:32:29 -0800 (PST)
MIME-Version: 1.0
References: <20210110103526.61047-1-mailhol.vincent@wanadoo.fr>
 <20210110103526.61047-2-mailhol.vincent@wanadoo.fr> <043c3ea1-6bdd-59c0-0269-27b2b5b36cec@victronenergy.com>
In-Reply-To: <043c3ea1-6bdd-59c0-0269-27b2b5b36cec@victronenergy.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sun, 10 Jan 2021 21:32:18 +0900
Message-ID: <CAMZ6RqKL62wR5KRRJgy8fiEHSKCQvP7CJFdR1=8MPh4_3pMq_A@mail.gmail.com>
Subject: Re: [PATCH 1/1] can: dev: add software tx timestamps
To:     Jeroen Hofstee <jhofstee@victronenergy.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can <linux-can@vger.kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jeroen,

On Sun. 10 Jan 2021 at 20:29, Jeroen Hofstee <jhofstee@victronenergy.com> wrote:
>
> Hello Vincent,
>
> On 1/10/21 11:35 AM, Vincent Mailhol wrote:
> > Call skb_tx_timestamp() within can_put_echo_skb() so that a software
> > tx timestamp gets attached on the skb.
> >
> [..]
> >
> > diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
> > index 3486704c8a95..3904e0874543 100644
> > --- a/drivers/net/can/dev.c
> > +++ b/drivers/net/can/dev.c
> > @@ -484,6 +484,8 @@ int can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
> >
> >               /* save this skb for tx interrupt echo handling */
> >               priv->echo_skb[idx] = skb;
> > +
> > +             skb_tx_timestamp(skb);
> >       } else {
> >               /* locking problem with netif_stop_queue() ?? */
> >               netdev_err(dev, "%s: BUG! echo_skb %d is occupied!\n", __func__, idx);
>
> Personally, I would put the skb_tx_timestamp, before adding it to the array:
>
>          /* make settings for echo to reduce code in irq context */
>          skb->pkt_type = PACKET_BROADCAST;
>          skb->ip_summed = CHECKSUM_UNNECESSARY;
>          skb->dev = dev;
> +       skb_tx_timestamp(skb);
>
>          /* save this skb for tx interrupt echo handling */
>          priv->echo_skb[idx] = skb;

I agree that it is better like that from an aesthetic point of
view. The reason to put it at the very end was to really to
blindly follow the doc and do the timestamp as late as possible.

>
> I don't think it actually matters though.

Indeed, but will still follow your suggestion though. Putting it
before would just delay the timestamp by a few assembly
instructions: it is negligible enough.


Yours sincerely,
Vincent Mailhol
