Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8427E21A574
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 19:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgGIRKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 13:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbgGIRKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 13:10:25 -0400
Received: from mail-vk1-xa43.google.com (mail-vk1-xa43.google.com [IPv6:2607:f8b0:4864:20::a43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E57BC08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 10:10:25 -0700 (PDT)
Received: by mail-vk1-xa43.google.com with SMTP id s192so609251vkh.3
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 10:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nb4yAj76qW7j7QKdCL7aF0Y1HRm3InumXPzB7ld987M=;
        b=GOFlgpfHpElM6QHDT9KhkpShl7IauszBWYmm3pxyIwkfhYefzDv62QwQ27IPQ5iI3e
         squ0qrsg//rPdULElxbRHqcmIR19wzNSD2KoggqhwyL13ee8XoRTiER8tDJDeCL6Xd0c
         48VRl8Q+mcTBKclba1v24jmtK80xno5U1i0NMihQwQYPzEixIFnSOFVMUUyXZkbFdRU5
         1zGwP0ckj5jo7NDuoFzvnh1Ad5s/XXuuUzS1SjSJCyROtkZBowAI18tIdScQYVOCcv1l
         9XoS4y0prM3lalwgJGBBnUeQ8jIMLQ0csujjCNl7SwXoJfNwvMqac/BmJgCNwjfqul4V
         WGAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nb4yAj76qW7j7QKdCL7aF0Y1HRm3InumXPzB7ld987M=;
        b=Q8QYiYaBZ/Tm9uFnFNco5/IGwnrAWiVIhz6oQGjmvgz7mvPcVtGRQ4f1VVbbCKuhLy
         9PPsRQbSYnGgqb3ugmP97hRH9KIqL5kLP+/NnFH/UWYW6cuAPhMzm7ZgiW55CmMedhN1
         Ih5kN/X+oWkdQ5UwxdfXJ2TV427COIq6RhNE+PwS1LloZ/3h4OSpRINdHmCdMyZvtjHm
         +xoxthKCIcWe8Hl1snAfBHt4gEfHJBZIVO3VqoY5UxUX3GmdBieAv3VNkTD3taBGVYdQ
         6UktVVcKwF5TUUWQFgY7/rBpJs7N3OQ4KeAC8RG4MQ3Vq1FGy11VWyPvzcXqqGGI0LUf
         L+HA==
X-Gm-Message-State: AOAM532ed3GQ9k2K8HLZwN9g6USv8Q+ARCBA0QgN6IYSYkzOiMGnCzQo
        lQxKEbysR+gmULXYYDAVcQJ9luckM+XhPY7Z66Q=
X-Google-Smtp-Source: ABdhPJyyP8xLmYVGVYAZsCAIJd/kIf9+f28sfFK6TA3G7M+etecLuaj0My8Gn1u7i/ccLtDPhtGz2eHqGoWovJLQx/8=
X-Received: by 2002:a1f:16c3:: with SMTP id 186mr31551559vkw.16.1594314624149;
 Thu, 09 Jul 2020 10:10:24 -0700 (PDT)
MIME-Version: 1.0
References: <1594287951-27479-1-git-send-email-magnus.karlsson@intel.com> <20200709170356.pivsunwnk57jm4kr@bsd-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200709170356.pivsunwnk57jm4kr@bsd-mbp.dhcp.thefacebook.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 9 Jul 2020 19:10:13 +0200
Message-ID: <CAJ8uoz2_m+-s4UXuChu9Edk99BS7NK=0cRFGFB4+z9KsHiDTMg@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: do not discard packet when QUEUE_STATE_FROZEN
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        A.Zema@falconvsystems.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 9, 2020 at 7:06 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> On Thu, Jul 09, 2020 at 11:45:51AM +0200, Magnus Karlsson wrote:
> > In the skb Tx path, transmission of a packet is performed with
> > dev_direct_xmit(). When QUEUE_STATE_FROZEN is set in the transmit
> > routines, it returns NETDEV_TX_BUSY signifying that it was not
> > possible to send the packet now, please try later. Unfortunately, the
> > xsk transmit code discarded the packet and returned EBUSY to the
> > application. Fix this unnecessary packet loss, by not discarding the
> > packet and return EAGAIN. As EAGAIN is returned to the application, it
> > can then retry the send operation and the packet will finally be sent
> > as we will likely not be in the QUEUE_STATE_FROZEN state anymore. So
> > EAGAIN tells the application that the packet was not discarded from
> > the Tx ring and that it needs to call send() again. EBUSY, on the
> > other hand, signifies that the packet was not sent and discarded from
> > the Tx ring. The application needs to put the packet on the Tx ring
> > again if it wants it to be sent.
>
> Doesn't the original code leak the skb if NETDEV_TX_BUSY is returned?
> I'm not seeing where it was released.  The new code looks correct.

You are correct. Should also have mentioned that in the commit message.

/Magnus

>
> > Fixes: 35fcde7f8deb ("xsk: support for Tx")
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > Reported-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
> > Suggested-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
> > ---
> >  net/xdp/xsk.c | 13 +++++++++++--
> >  1 file changed, 11 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index 3700266..5304250 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -376,13 +376,22 @@ static int xsk_generic_xmit(struct sock *sk)
> >               skb->destructor = xsk_destruct_skb;
> >
> >               err = dev_direct_xmit(skb, xs->queue_id);
> > -             xskq_cons_release(xs->tx);
> >               /* Ignore NET_XMIT_CN as packet might have been sent */
> > -             if (err == NET_XMIT_DROP || err == NETDEV_TX_BUSY) {
> > +             if (err == NET_XMIT_DROP) {
> >                       /* SKB completed but not sent */
> > +                     xskq_cons_release(xs->tx);
> >                       err = -EBUSY;
> >                       goto out;
> > +             } else if  (err == NETDEV_TX_BUSY) {
>
> Should be "if (err == ..." here, no else.
>
>
> > +                     /* QUEUE_STATE_FROZEN, tell application to
> > +                      * retry sending the packet
> > +                      */
> > +                     skb->destructor = NULL;
> > +                     kfree_skb(skb);
> > +                     err = -EAGAIN;
> > +                     goto out;
> >               }
> > +             xskq_cons_release(xs->tx);
> >
> >               sent_frame = true;
> >       }
> > --
> > 2.7.4
> >
