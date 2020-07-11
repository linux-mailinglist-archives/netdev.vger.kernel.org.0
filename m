Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4122F21C314
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 09:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbgGKHkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 03:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgGKHkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 03:40:10 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8A6C08C5DD
        for <netdev@vger.kernel.org>; Sat, 11 Jul 2020 00:40:09 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id u133so4184434vsc.0
        for <netdev@vger.kernel.org>; Sat, 11 Jul 2020 00:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f5lPF3XdF6K0NGZOyKOCMg14RTyoEyN0JADWifX2WeU=;
        b=NYWdZGqMU2ljOqlNCd0aow0Ffxs+se03nR4vC/cMS9SWDuhpXJbOylQ8vhFscv1TcL
         ttAozVtjpaEdPCtIh1/vDLyhjRK6ti30Os3dUF2QVdntWWcDXE6Kpp4GEnyEy0dkTcrm
         qWbIYB8I+a+17/hOyK3geoqPMVXA64G6qwbsxekswYWU7NuNbBQ4d2UOrk1UK7Elt0FT
         EsxJV438UPDm3av0CAg/IQLfWIptvrN/W0yvP8cg0iWOq6F5TcKXVocmbwbhC5F6z+ut
         IV2+DdZjGJgfAkBOdmjiClMaRWZKwshiu3a1lx/Yrj0ccNF2g4OTZFd9Lx7VX3pCYNhx
         hYcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f5lPF3XdF6K0NGZOyKOCMg14RTyoEyN0JADWifX2WeU=;
        b=Sv5jfdE9krR9clJh0lq4WICTLUvuK6ze4CguHGC/DkzBfxHN/vSsnnl5VX5AKy7E+w
         +4GpOI3Al03ZMh1BMv36rd69o2nWeBiOa5QL+rOanESc57z4m+avxVN24w+FI1P/+GVv
         inXcoSpz5HY8HpDf1chiCFh7yJ/8tWye6HOFA9dth2qEBa/QgxZLzIjBYLYU75GpNeK5
         NmKIQKQGhp4IyDWfrrJ10laJGzi1jURukzh4JzOaQSEYNBxh8A9Z9T988TXKhhV28rar
         sFbxPnV4yWCupKJ0r4qskWAciOUfVN20bJMEpWHeFNxy572JMRwWYsX6rTpQmtk4lf34
         rzUg==
X-Gm-Message-State: AOAM532pV+0H5LTrtlb4DsGOdES8UkBi6Qg0fWQypZSdMlUDBKmVurV9
        Mk6/qX61Gzu7u3i8x7K299bDCKUVPDcUSe6wv6JceqeohxRk8w==
X-Google-Smtp-Source: ABdhPJx8/zaIcZxWP5pbJ7zrJXG2TNvexf+u5OUgTW2TIwyAJo5tnZzXvndLkFlLQ3n+Tr7Pn3DZKo7hZ+GVxj8fZd0=
X-Received: by 2002:a05:6102:830:: with SMTP id k16mr21333035vsb.182.1594453209071;
 Sat, 11 Jul 2020 00:40:09 -0700 (PDT)
MIME-Version: 1.0
References: <1594363554-4076-1-git-send-email-magnus.karlsson@intel.com> <3e42533f-fb6e-d6fa-af48-cb7f5c70890b@iogearbox.net>
In-Reply-To: <3e42533f-fb6e-d6fa-af48-cb7f5c70890b@iogearbox.net>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Sat, 11 Jul 2020 09:39:58 +0200
Message-ID: <CAJ8uoz3WhJkqN2=D+VP+ikvY2_WTRx7Pcuihr_8qJiYh0DUtog@mail.gmail.com>
Subject: Re: [PATCH bpf v2] xsk: fix memory leak and packet loss in Tx skb path
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        A.Zema@falconvsystems.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 11, 2020 at 1:28 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Hi Magnus,
>
> On 7/10/20 8:45 AM, Magnus Karlsson wrote:
> > In the skb Tx path, transmission of a packet is performed with
> > dev_direct_xmit(). When QUEUE_STATE_FROZEN is set in the transmit
> > routines, it returns NETDEV_TX_BUSY signifying that it was not
> > possible to send the packet now, please try later. Unfortunately, the
> > xsk transmit code discarded the packet, missed to free the skb, and
> > returned EBUSY to the application. Fix this memory leak and
> > unnecessary packet loss, by not discarding the packet in the Tx ring,
> > freeing the allocated skb, and return EAGAIN. As EAGAIN is returned to the
> > application, it can then retry the send operation and the packet will
> > finally be sent as we will likely not be in the QUEUE_STATE_FROZEN
> > state anymore. So EAGAIN tells the application that the packet was not
> > discarded from the Tx ring and that it needs to call send()
> > again. EBUSY, on the other hand, signifies that the packet was not
> > sent and discarded from the Tx ring. The application needs to put the
> > packet on the Tx ring again if it wants it to be sent.
> >
> > Fixes: 35fcde7f8deb ("xsk: support for Tx")
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > Reported-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
> > Suggested-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
> > ---
> > The v1 of this patch was called "xsk: do not discard packet when
> > QUEUE_STATE_FROZEN".
> > ---
> >   net/xdp/xsk.c | 13 +++++++++++--
> >   1 file changed, 11 insertions(+), 2 deletions(-)
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
> > +                     /* QUEUE_STATE_FROZEN, tell application to
> > +                      * retry sending the packet
> > +                      */
> > +                     skb->destructor = NULL;
> > +                     kfree_skb(skb);
> > +                     err = -EAGAIN;
> > +                     goto out;
>
> Hmm, I'm probably missing something or I should blame my current lack of coffee,
> but I'll ask anyway.. What is the relation here to the kfree_skb{,_list}() in
> dev_direct_xmit() when we have NETDEV_TX_BUSY condition? Wouldn't the patch above
> double-free with NETDEV_TX_BUSY?

I think you are correct even without coffee :-). I misinterpreted the
following piece of code in dev_direct_xmit():

if (!dev_xmit_complete(ret))
     kfree_skb(skb);

If the skb was NOT consumed by the transmit, then it goes and frees
the skb. NETDEV_TX_BUSY as a return value will make
dev_xmit_complete() return false which triggers the freeing of the
skb. So if I now understand dev_direct_xmit() correctly, it will
always consume the skb, even when NETDEV_TX_BUSY is returned. And this
is what I would like to avoid. If the skb is freed, the destructor is
triggered and it will complete the packet to user-space, which is the
same thing as dropping it, which is what I want to avoid in the first
place since it is completely unnecessary.

So what would be the best way to solve this? Prefer to share the code
with AF_PACKET if possible. Introduce a boolean function parameter to
indicate if it should be freed in this case? Other ideas? Here are the
users of dev_direct_xmit():

drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c

line 349
line 939
line 1033
line 1303
line 1665

include/linux/netdevice.h, line 2719
net/core/dev.c

line 4095
line 4132

net/packet/af_packet.c, line 240
net/xdp/xsk.c, line 425

Thanks: Magnus

> >               }
> > +             xskq_cons_release(xs->tx);
> >
> >               sent_frame = true;
> >       }
> >
>
> Thanks,
> Daniel
