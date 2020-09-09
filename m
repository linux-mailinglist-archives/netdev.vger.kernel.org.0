Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8533A263623
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgIIShE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgIIShB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:37:01 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E3CC061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:36:59 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id x14so3347639oic.9
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 11:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=USQoZDoKPR/BwWmXvpJGTLTtPOmE1oQJfGXWI144fpU=;
        b=Fy49uBa+eWJMaL3KIrNF9gAcNk/AeJf/tNImm9+yYMj9lA2fmEOcOC9blK1WyhgXuf
         xChpAW5EiUw7JQnd+9nTY2lF4qe6n6hcc5btoQTKhlb5sh+FZxTnbsgtnpBHZ3pv5o0U
         MN9OxaTklZLHTDTC1sZMar3gu3uQmngWKpp6mywVRTpYIbeeDOu3EofuCCvXosvvmdqC
         RxsPngJ0IVIuqkNKotYr5A0QO3uJ3ZBobjs/rBB0Usyi5h43HIa8Lgw4lhCluCzljhAK
         Q78HPpNt5eNbuKoB/R3aneCZ1meFTCTRqzLYBDiuSeyAwNsLHE7umFX/K+Ec+Yc/n4H+
         02iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=USQoZDoKPR/BwWmXvpJGTLTtPOmE1oQJfGXWI144fpU=;
        b=XRcKNuK832cr+1J+tWyMgvme4FSbt0/omJKpSOf76phKaM0weuwHyx+JGJn75WrLUu
         /ThGSmGTel7XbfBip10X42nzK2S93koK5l1uxEOZvvBD6JE4mmwHkmzo73YoAkVk/ZTu
         jBe3NJbsE6XH682ZDBiqJIUTQpwGyOaNlypzpNBxY4mRTMUrew8w16SuPCFH+m2T+eh6
         04SAHQjkqhEI8al6S3kgwUAYbmfgwNB+XdStGQECAD28QdjGEO2jPOO9olfn815aBsXK
         g/+6Qbjc+aH17fNnT2sV0ILgktNIb1F5fVCjVKDtby8hfKEES5lPARcQOp3BpM+OWTrA
         oNZA==
X-Gm-Message-State: AOAM532MZhFnoK+CLJ41UVx1i2zzbonuC5DfsWEw6Bd2zd3fXZIgch+y
        P+hheAndbpwspK/23Xi3r2veOa4LJXQ+QCFptuA=
X-Google-Smtp-Source: ABdhPJx38JOczv51PtfAYegVGyriqXpWhDZHhzKPlozJCYvJH+UyvndWvkjgGMF3p6ip9bPTSS3+Flr0nhdY3Pwhxd8=
X-Received: by 2002:aca:c50b:: with SMTP id v11mr1444051oif.76.1599676619239;
 Wed, 09 Sep 2020 11:36:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200909084510.648706-1-allen.lkml@gmail.com> <20200909084510.648706-2-allen.lkml@gmail.com>
 <20200909.110956.600909796407174509.davem@davemloft.net>
In-Reply-To: <20200909.110956.600909796407174509.davem@davemloft.net>
From:   Allen <allen.lkml@gmail.com>
Date:   Thu, 10 Sep 2020 00:06:47 +0530
Message-ID: <CAOMdWSKQxbKzo6z9BBO=0HPCxSs1nt8ArAe5zi_X5cPQhtnUVA@mail.gmail.com>
Subject: Re: [PATCH v2 01/20] ethernet: alteon: convert tasklets to use new
 tasklet_setup() API
To:     David Miller <davem@davemloft.net>
Cc:     jes@trained-monkey.org, Jakub Kicinski <kuba@kernel.org>,
        dougmill@linux.ibm.com, cooldavid@cooldavid.org,
        mlindner@marvell.com, stephen@networkplumber.org,
        borisp@mellanox.com, netdev@vger.kernel.org,
        Romain Perier <romain.perier@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> > @@ -1562,10 +1562,11 @@ static void ace_watchdog(struct net_device *data, unsigned int txqueue)
> >  }
> >
> >
> > -static void ace_tasklet(unsigned long arg)
> > +static void ace_tasklet(struct tasklet_struct *t)
> >  {
> > -     struct net_device *dev = (struct net_device *) arg;
> > -     struct ace_private *ap = netdev_priv(dev);
> > +     struct ace_private *ap = from_tasklet(ap, t, ace_tasklet);
> > +     struct net_device *dev = (struct net_device *)((char *)ap -
> > +                             ALIGN(sizeof(struct net_device), NETDEV_ALIGN));
> >       int cur_size;
> >
>
> I don't see this is as an improvement.  The 'dev' assignment looks so
> incredibly fragile and exposes so many internal details about netdev
> object allocation, alignment, and layout.
>
> Who is going to find and fix this if someone changes how netdev object
> allocation works?
>

Thanks for pointing it out. I'll see if I can fix it to keep it simple.

> I don't want to apply this, it sets a very bad precedent.  The existing
> code is so much cleaner and easier to understand and audit.
>

Will you pick the rest of the patches or would they have to wait till
this one is
fixed.

Thanks,

-- 
       - Allen
