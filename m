Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8913A789A
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 09:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbhFOH7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 03:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbhFOH7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 03:59:05 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795ACC061574;
        Tue, 15 Jun 2021 00:57:00 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id my49so21017404ejc.7;
        Tue, 15 Jun 2021 00:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=32/dZhle6KrGyODOZOxwRltOK7h8bh5e3SeLC3CcT00=;
        b=BqdHyOHPlg70IJeotkQwWQlQaMgr6jjajr9X0+6HsRbNwI6GpXb+GRr1iQctE/mpjQ
         PeQ6+2U918XoZDfD2leE4cRngrAjL1x9BiPU0gk7sKPX5fV7Z9lrAt9wPFwFcwmytrKn
         u3xTBTVsjN3Emaf0Ce82uLIgqq0AzJOdZm/xDUrwfzcuV2jrIdjv1vvY3P7bL1XzRvsh
         oAt081sfJIg+kSP2qqQJ/Wp8ddwwIR6CZiViymeaLBiyZEpP0fd/XiCPrAm6h3Sbj4NR
         XQPMEdf3cERpMi+IjSnK01FtQ9fGu1NP0Dyt1G9IaOmuqE4s/9j5dBaeSF/d5J45ZZ03
         0yDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=32/dZhle6KrGyODOZOxwRltOK7h8bh5e3SeLC3CcT00=;
        b=eTEqPYVPy1Sv0kTRgn3lqbQkkFrG60FNjU83yKTLNrbp8ivOLp3vCfrjDkP6ulh68N
         f06I3tdrQn4BGvYLYLmzyMB+CRbfzy0GQ2y/uR3W2UDddxOLAY1AWeXJ4OHhYNw+pAcA
         MWspCfLbomqW1oKL8Jj7lhLmx7dn0xCPgliDhrgh20eAO2PaNVv+FOxh6g5Oqdqpi6Q6
         eQb3sXTF/KONq9qmZu/rcEhCazmknEVTd2Uwf3WBFmqT2n6ok9E7XzJlpTqNYEuIZf53
         rN84Jcn6gCV1NJeMLG07YWuv6idczGpY9SDWHIL+4PrxafOwEt/SkwFnAOQliV3Ho1hU
         801g==
X-Gm-Message-State: AOAM533FBWQCOxkQYFyRHXxF8Bk+2o5lfgfdKKYFNRCu1kpVt+NeNIvs
        7l4jbVoBMamSAnBXG3m+OFZGQ4xysxsJsbXHaVo=
X-Google-Smtp-Source: ABdhPJwiB/JJGffjspRTqr1GNlUCIEvUsk4pli/5syQhuVsQbAat+tj5z4zE2+t5OxAAVcZTrGr1lHHTVjxI8wHX22o=
X-Received: by 2002:a17:906:35ca:: with SMTP id p10mr19009027ejb.535.1623743818992;
 Tue, 15 Jun 2021 00:56:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210614153712.2172662-1-mudongliangabcd@gmail.com> <YMhY9NHf1itQyup7@kroah.com>
In-Reply-To: <YMhY9NHf1itQyup7@kroah.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Tue, 15 Jun 2021 15:56:32 +0800
Message-ID: <CAD-N9QVfDQQo0rRiaa6Cx-xO80yox9hNzK91_UVj0KNgkhpvnQ@mail.gmail.com>
Subject: Re: [PATCH] net: usb: fix possible use-after-free in smsc75xx_bind
To:     Greg KH <greg@kroah.com>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 3:38 PM Greg KH <greg@kroah.com> wrote:
>
> On Mon, Jun 14, 2021 at 11:37:12PM +0800, Dongliang Mu wrote:
> > The commit 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
> > fails to clean up the work scheduled in smsc75xx_reset->
> > smsc75xx_set_multicast, which leads to use-after-free if the work is
> > scheduled to start after the deallocation. In addition, this patch also
> > removes one dangling pointer - dev->data[0].
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
> > @@ -1504,7 +1504,10 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
> >       return 0;
> >
> >  err:
> > +     cancel_work_sync(&pdata->set_multicast);
> >       kfree(pdata);
> > +     pdata = NULL;
>
> Why do you have to set pdata to NULL afterward?
>

It does not have to. pdata will be useless when the function exits. I
just referred to the implementation of smsc75xx_unbind.

> thanks,
>
> greg k-h
