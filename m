Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F732134D26
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 21:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgAHUZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 15:25:53 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:40250 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgAHUZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 15:25:53 -0500
Received: by mail-yb1-f193.google.com with SMTP id a2so2028114ybr.7
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 12:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wfJqX5R/FmgkyI2bl1EsKAOo5BNWaygPKIsDVxMmKmc=;
        b=lqZb1QzDni172YMBxksX8MJJH+FhCXTVBS0RIh4VTEB6Dn+3/93AjsLrXjOrYawF+C
         ZFZv55xEyiExDXQJClEWVqCoPoe2bji2ejJc5jAEEJMcsd4UXCT3+E/Gef1PTrgIZEAm
         N9idVk6kClD9UEovRkp0t1V/U/npR677B+6ecK1mmcDiEktYXYtkoszeJx0xUMQ/9OyP
         qXgZOxENOpxKrm9ULqfkNd4aEYSW1IkPrlfbi9L1sbTePV0ZFzmf+J+xjpOQPGWJPgfk
         K6wOAOjtZrAx8KxKtTZNDPwbbf/2pxgAHC55sY4zN5xC9DR2OwwB0YRtxLZc3hs9DeBg
         KwAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wfJqX5R/FmgkyI2bl1EsKAOo5BNWaygPKIsDVxMmKmc=;
        b=dCM+py7o3CBjQsuHtEM5Gkuu7l0m/9VepZKl/ve30VBhpnqL2+gYA8D3K35SCT8WlH
         QS61sJ9BV3aWgbSCxQ/fHpj1JbH33lF6y6EaCQAx79JlybePKX1Gj+8XBRlYOn3pRNI3
         Cz+cIZyUUQ+a96DH/0sQ+wTl2w0MdKU3fNUXB6jYDe3r8JaOHbgtZW/k7t0z0oqRADVL
         EwprYRIHGwvshE3FYUnOSfwmqcs4MO+U789qOIx6Kyx7+ufR9OOoT8cwUzSLsc6ceZnr
         CKd67Wi2qULRGtOd8JqgNFhpKDh0RcofslrOQbDHPe6Q9fuHURAuVU348+iQsxvJceYN
         smOQ==
X-Gm-Message-State: APjAAAVq7kLPV/CM3Lfk2xNM/0KFihhhD/GHhUcE2OUHe9/HJ62lUao7
        L2BzSPunDNPth9xTQwEJV53FQM2r/4uKbNGOgYJHXw==
X-Google-Smtp-Source: APXvYqzQvL12Vmh98kaZwm/NhyJvlTM/jFjgLBeBjdYfzN4YjXY35S2VO2Mp6wfHK8fylskjf+gdav+bJiwhqgNKMgA=
X-Received: by 2002:a5b:489:: with SMTP id n9mr4907888ybp.395.1578515151988;
 Wed, 08 Jan 2020 12:25:51 -0800 (PST)
MIME-Version: 1.0
References: <20200107185701.137063-1-edumazet@google.com> <393ec56d-5d37-ac75-13af-25ade6aabac8@gmail.com>
In-Reply-To: <393ec56d-5d37-ac75-13af-25ade6aabac8@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 8 Jan 2020 12:25:40 -0800
Message-ID: <CANn89iKD6DSnz-QdBMYgm=1N2V7UZpCD3TiB+yTO_tGu7XKReg@mail.gmail.com>
Subject: Re: [PATCH net] net: usb: lan78xx: fix possible skb leak
To:     RENARD Pierre-Francois <pfrenard@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 8, 2020 at 11:13 AM RENARD Pierre-Francois
<pfrenard@gmail.com> wrote:
>
> I tried with last rawhide kernel 5.5.0-0.rc5.git0.1.local.fc32.aarch64
> I compiled it this night. (I check it includes the patch for lan78xx.c )
>
> Both tests (scp and nfs ) are failing the same way as before.
>
> Fox
>

Please report the output of " grep skb /proc/slabinfo"

before and after your test.

The symptoms (of retransmit being not attempted by TCP) match the fact
that skb(s) is(are) not freed by a driver (or some layer)

When TCP detects this (function skb_still_in_host_queue()), one SNMP
counter is incremented

nstat -a | grep TCPSpuriousRtxHostQueues

Thanks.

>
>
> On 1/7/20 7:57 PM, Eric Dumazet wrote:
> > If skb_linearize() fails, we need to free the skb.
> >
> > TSO makes skb bigger, and this bug might be the reason
> > Raspberry Pi 3B+ users had to disable TSO.
> >
> > Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reported-by: RENARD Pierre-Francois <pfrenard@gmail.com>
> > Cc: Stefan Wahren <stefan.wahren@i2se.com>
> > Cc: Woojung Huh <woojung.huh@microchip.com>
> > Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
> > ---
> >   drivers/net/usb/lan78xx.c | 9 +++------
> >   1 file changed, 3 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
> > index f940dc6485e56a7e8f905082ce920f5dd83232b0..fb4781080d6dec2af22f41c5e064350ea74130b3 100644
> > --- a/drivers/net/usb/lan78xx.c
> > +++ b/drivers/net/usb/lan78xx.c
> > @@ -2724,11 +2724,6 @@ static int lan78xx_stop(struct net_device *net)
> >       return 0;
> >   }
> >
> > -static int lan78xx_linearize(struct sk_buff *skb)
> > -{
> > -     return skb_linearize(skb);
> > -}
> > -
> >   static struct sk_buff *lan78xx_tx_prep(struct lan78xx_net *dev,
> >                                      struct sk_buff *skb, gfp_t flags)
> >   {
> > @@ -2740,8 +2735,10 @@ static struct sk_buff *lan78xx_tx_prep(struct lan78xx_net *dev,
> >               return NULL;
> >       }
> >
> > -     if (lan78xx_linearize(skb) < 0)
> > +     if (skb_linearize(skb)) {
> > +             dev_kfree_skb_any(skb);
> >               return NULL;
> > +     }
> >
> >       tx_cmd_a = (u32)(skb->len & TX_CMD_A_LEN_MASK_) | TX_CMD_A_FCS_;
> >
>
>
