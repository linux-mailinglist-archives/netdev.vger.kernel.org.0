Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBE32F6542
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 16:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbhANPyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 10:54:31 -0500
Received: from mail-qk1-f177.google.com ([209.85.222.177]:39135 "EHLO
        mail-qk1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbhANPyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 10:54:31 -0500
Received: by mail-qk1-f177.google.com with SMTP id p14so8606043qke.6;
        Thu, 14 Jan 2021 07:54:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oER94ISeeQp8C2fada71qvbSp81ji9VD0JCVbzgzuL4=;
        b=UwkfeYjnG+xELWW0nR1ZGqfKr4pk1KYx9rDg32/zQvV28e9E7qr+EWkvYrmBu/yvxd
         rC6cB6hZPcNviBzQ1xBZJlXtPJ1WILT6tPsb8jzeSic7iIp1uAu4t8qJBh2k7n5KH7pe
         XHPy7N3U8NNPA2IGo7yUcpD8xnwU3J1A1fX8Kc3bWi/vIfDRK5zWNSz0g36FEq1H0Hrn
         Ddt6Jc22HQmzw9YkOFbIheNt7VWMa1YcsKBXCqaXZLpBsXDauAA1QXJ/Te7KYEW0cM5N
         XLzSGe/VKmUGFdk2PO3tBK/H3AUpFweYlgjXWACkaqTeEOWTCvqkQ4ICYZHm4f2szHjf
         yG6A==
X-Gm-Message-State: AOAM532i4X0GDuAZylgdDyVp4dGeCEgpMMDwmtmn1FOPONsrOH0VAQtS
        plDWDrG1i9vkk0Lc2mw4QXtdbk5obpBPIamHpko=
X-Google-Smtp-Source: ABdhPJwu8omCz5uioYXNhdJ3CclkR43ziBbBIlt918T2EGG/rjJeqVk9QiPFKxeYRYlA2oOum9+PYLCgWDgdMeRjCoA=
X-Received: by 2002:a25:d84:: with SMTP id 126mr4336174ybn.145.1610639629162;
 Thu, 14 Jan 2021 07:53:49 -0800 (PST)
MIME-Version: 1.0
References: <20210112130538.14912-1-mailhol.vincent@wanadoo.fr>
 <20210112130538.14912-2-mailhol.vincent@wanadoo.fr> <7643bd48-6594-9ede-b791-de6e155c62c1@pengutronix.de>
 <CAMZ6Rq+HggK2HHkPn_QTKzz-niyiU8AkHc4rP5AXE+AqJmkbrg@mail.gmail.com> <24603b31-fe7b-1f03-4939-fa074f471239@pengutronix.de>
In-Reply-To: <24603b31-fe7b-1f03-4939-fa074f471239@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Fri, 15 Jan 2021 00:53:37 +0900
Message-ID: <CAMZ6RqL4xW0WsJO=m-r8DTSDJai31GPtMM6zZYXZYHiwQ5hAPA@mail.gmail.com>
Subject: Re: [PATCH v10 1/1] can: usb: etas_es58X: add support for ETAS ES58X
 CAN USB interfaces
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jimmy Assarsson <extja@kvaser.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "open list : NETWORKING DRIVERS" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 14 janv. 2021 at 01:04, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 1/13/21 1:15 PM, Vincent MAILHOL wrote:
> >>> +/**
> >>> + * es58x_calculate_crc() - Compute the crc16 of a given URB.
> >>> + * @urb_cmd: The URB command for which we want to calculate the CRC.
> >>> + * @urb_len: Length of @urb_cmd. Must be at least bigger than 4
> >>> + *   (ES58X_CRC_CALC_OFFSET + sizeof(crc))
> >>> + *
> >>> + * Return: crc16 value.
> >>> + */
> >>> +static u16 es58x_calculate_crc(const union es58x_urb_cmd *urb_cmd, u16 urb_len)
> >>> +{
> >>> +     u16 crc;
> >>> +     ssize_t len = urb_len - ES58X_CRC_CALC_OFFSET - sizeof(crc);
> >>> +
> >>> +     WARN_ON(len < 0);
> >>
> >> Is it possible to ensure earlier, that the urbs are of correct length?
> >
> > Easy answer: it is ensured.
>
> Okay, then get rid of those checks :)
>
> > On the Tx branch, I create the urbs so I
> > know for sure that the length is correct. On the Rx branch, I have a
> > dedicated function: es58x_check_rx_urb() for this purpose.  I
> > will remove that WARN_ON() and the one in es58x_get_crc().
> >
> > I will also check the other WARN_ON() in my code to see if they
> > can be removed (none on my test throughout the last ten months or
> > so could trigger any of these WARN_ON() so should be fine to
> > remove but I will double check).

Checked, all WARN_ON() will be removed in v11.

> >>> +struct es58x_priv {
> >>> +     struct can_priv can;
> >>> +     struct es58x_device *es58x_dev;
> >>> +     struct urb *tx_urb;
> >>> +
> >>> +     spinlock_t echo_skb_spinlock;   /* Comments: c.f. supra */
> >>> +     u32 current_packet_idx;
> >>> +     u16 echo_skb_tail_idx;
> >>> +     u16 echo_skb_head_idx;
> >>> +     u16 num_echo_skb;
> >>
> >> Can you explain me how the tx-path works, especially why you need the
> >> current_packet_idx.
> >>
> >> In the mcp251xfd driver, the number of TX buffers is a power of two, that makes
> >> things easier. tx_heads % len points to the next buffer to be filled, tx_tail %
> >> len points to the next buffer to be completed. tx_head - tx_tail is the fill
> >> level of the FIFO. This works without spinlocks.
> >
> > For what I understand of your explanations here are the equivalences
> > between the etas_es58x and the mcp251xfd drivers:
> >
> >  +--------------------+-------------------+
> >  | etas_es58x         | mcp251xfd         |
> >  +--------------------+-------------------+
> >  | current_packet_idx | tx_head           |
> >  | echo_skb_tail_idx  | tx_tail % len     |
> >  | echo_skb_head_idx  | tx_head % len     |
> >  | num_echo_skb       | tx_head - tx_tail |
> >  +--------------------+-------------------+
> >
> > Especially, the current_packet_idx is sent to the device and returned
> > to the driver upon completion.
>
> Is current_packet_idx used only for the TX-PATH?

It is used in the RX path of loopback packet. When a packet comes
back, its index should be equal to current_packet_idx -
num_echo_skb. I use this in es58x_can_get_echo_skb() to check
that there are no packet drops.

Of course, if the FIFO size is a power of two, the
current_packet_idx would become useless.

> > I wish the TX buffers were a power of two which is unfortunately not
> > the case. The theoretical TX buffer sizes are 330 and 500 for the two
> > devices so I wrote the code to work with those values. The exact size
> > of the TX buffer is actually even more of a mystery because during
> > testing both devices were unstable when using the theoretical values
> > and I had to lower these. There is a comment at the bottom of
> > es581_4.c and es58x_fd.c to reflect those issues.
>
> What are the performance penalties for using 256 for the fd and 64 ofr the other?

I checked my passed log, actually, I had good results with 256 on
the FD. I lowered it to 255 with no strong reasons.

For the classical CAN changing from 75 to 64 should still be
enough to reach full busload.

> > Because I do not
> > have access to the source code of the firmware, I could not identify
> > the root cause.
>
> ok
>
> > My understanding is that having a queue size being a power of two is
> > required in order not to use spinlocks (else, modulo operations would
> > break when the index wraparound back to zero). I tried to minimize the
> > number of spinlock: only one per bulk send or bulk receive.
>
> With queue size being power of two the modulo can be written as a mask
> operation, so it's reasonable fast. So you only need to care about tx_head and
> tx_tail, and there is only one writer for each variable. With a little dance and
> barriers when stopping and starting the queue it's race-free without spinlocks.

Yep, I checked linux/kfifo.h in the past. I think I understand
the theory, now I need to practice.

I will try to do the change. Will get back to you later when it is
done and tested.


Yours sincerely,
Vincent
