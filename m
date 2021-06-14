Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C23D3A724A
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 01:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbhFNXE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 19:04:57 -0400
Received: from mail-ed1-f42.google.com ([209.85.208.42]:43529 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbhFNXE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 19:04:56 -0400
Received: by mail-ed1-f42.google.com with SMTP id s6so48560827edu.10;
        Mon, 14 Jun 2021 16:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xptdFCYBt+DjA9CbQxpyV5Tq5GSDlhdqPmEhWjQXrUg=;
        b=MHouzfSasrE3u/M3ZGURu717kwnTWfQprP27KA63w+Af6l4ZfunAfkZo9STcczn+zz
         SzDBnuIVED0rEhGUWBpGcQeSJWGwCyp812i3mH7UwHr+pNN03Lq4i5Ej33AhryhBYVQm
         8NjFnw242+Ghtl3sTzidgZZUopZoOOJnbD3pXjVOXNPkj5WFM1bTH6GZVwd/1ShOD4nc
         3MXntAkjMfsi6GHJ2euph0PQ2pQ6+KZwpESxDjLyZ5/uBsMtwsLYISE41XG9EMV0wwvy
         FQqFH0+6hSIbn23/J+801S9hSgPfJkPZbAIs0PVF07h0M2fVHZ8HXsA2BFTXiWQNfNE8
         SJdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xptdFCYBt+DjA9CbQxpyV5Tq5GSDlhdqPmEhWjQXrUg=;
        b=Vcv6TEsL4AaruIsn1s/XJRQqZVizRcQ6G22slDJGnGrBVXOe6QM0YGL544DZX3N6mQ
         uX+T2fgIpoKuNPC7pPxu1+X2DOGrKUjKAN+inK3uR1mAGRs/L5QXlibkEfe91G+Xwj7Z
         VptKDAu9FhOYGSqin++gLtl9MpojTHvOD4+I0FkGwb+6gZCwfrSIWIS+/Ha0EGGGTpzk
         Ic3avxLMh7uwlfmVx6/FncKKYr3JKNpH1nBjkbHZ0BfxToZjnGU7ScunWJMK5cwpUHkl
         P7Ej9lupRBW7m81Ey2I5cZLIVt6DXBfTtd14+sj6xkntchPuNQ9ZRfNsWolJVS+AQpPi
         c+Rg==
X-Gm-Message-State: AOAM532zbbGMtk4RlNL0jL/zZzEOsS4oSM3nNWl1IiuCJhaC67L5vbAu
        kVc5ljFgrB+3h4UCyPwmPjQPAVcg6ewYJCZOmW4=
X-Google-Smtp-Source: ABdhPJzDIFrOVrYqg2F2uDLxlfsHL3r4DyaB1+6ZAAk9b2Uj7NKSjPce91VFwOgzPxqET8X5vPj+nkZi8x1SqDCmipA=
X-Received: by 2002:a05:6402:54f:: with SMTP id i15mr19390460edx.339.1623711699919;
 Mon, 14 Jun 2021 16:01:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210614153712.2172662-1-mudongliangabcd@gmail.com> <20210614190045.5b4c92e6@gmail.com>
In-Reply-To: <20210614190045.5b4c92e6@gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Tue, 15 Jun 2021 07:01:13 +0800
Message-ID: <CAD-N9QVG40CqgkHb1w68FL-d1LkTzjcAhF9O8whmzWo67=4KJg@mail.gmail.com>
Subject: Re: [PATCH] net: usb: fix possible use-after-free in smsc75xx_bind
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 12:00 AM Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> On Mon, 14 Jun 2021 23:37:12 +0800
> Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> > The commit 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
> > fails to clean up the work scheduled in smsc75xx_reset->
> > smsc75xx_set_multicast, which leads to use-after-free if the work is
> > scheduled to start after the deallocation. In addition, this patch
> > also removes one dangling pointer - dev->data[0].
> >
> > This patch calls cancel_work_sync to cancel the schedule work and set
> > the dangling pointer to NULL.
> >
> > Fixes: 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
> > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > ---
> >  drivers/net/usb/smsc75xx.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
> > index b286993da67c..f81740fcc8d5 100644
> > --- a/drivers/net/usb/smsc75xx.c
> > +++ b/drivers/net/usb/smsc75xx.c
> > @@ -1504,7 +1504,10 @@ static int smsc75xx_bind(struct usbnet *dev,
> > struct usb_interface *intf) return 0;
> >
> >  err:
> > +     cancel_work_sync(&pdata->set_multicast);
> >       kfree(pdata);
> > +     pdata = NULL;
> > +     dev->data[0] = 0;
> >       return ret;
> >  }
> >
>
> Hi, Dongliang!
>
> Just my thougth about this patch:
>
> INIT_WORK(&pdata->set_multicast, smsc75xx_deferred_multicast_write);
> does not queue anything, it just initalizes list structure and assigns
> callback function. The actual work sheduling happens in
> smsc75xx_set_multicast() which is smsc75xx_netdev_ops member.
>

Yes, you are right. However, as written in the commit message,
smsc75xx_set_multicast will be called by smsc75xx_reset [1].

If smsc75xx_set_multicast is called before any check failure occurs,
this work(set_multicast) will be queued into the global list with

schedule_work(&pdata->set_multicast); [2]

At last, if the pdata or dev->data[0] is freed before the
set_multicast really executes, it may lead to a UAF. Is this correct?

BTW, even if the above is true, I don't know if I call the API
``cancel_work_sync(&pdata->set_multicast)'' properly if the
schedule_work is not called.

[1] https://elixir.bootlin.com/linux/latest/source/drivers/net/usb/smsc75xx.c#L1322

[2] https://elixir.bootlin.com/linux/latest/source/drivers/net/usb/smsc75xx.c#L583

> In case of any error in smsc75xx_bind() the device registration fails
> and smsc75xx_netdev_ops won't be registered, so, i guess, there is no
> chance of UAF.
>
>
> Am I missing something? :)
>
>
>
> With regards,
> Pavel Skripkin
