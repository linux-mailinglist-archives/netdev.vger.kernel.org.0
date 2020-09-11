Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100792658F6
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 07:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgIKFx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 01:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgIKFxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 01:53:52 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA31C061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 22:53:51 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id m7so6938777oie.0
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 22:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XFCN/rKe4bMqEFjiiLTtEHRCJj9MQsZ19jltg/H+fQ4=;
        b=cU4tqbgqGb0fEEkC7uOWWDzoTG+CN0DuyXKMxbcbuAZqsJjfZClbLNKXrmDFImIr90
         A9SP5Yda9tzwVmXJ9C9pMV22LNaMafL87XcNb5mA6nbQEcdh+Pf0Wyvf9QUOS1fdX5Cw
         1Wep+fUHN1Bnsx5Qn+BCoiyKryWXVeoFfdyvuROIWnuo/DuyNo7zKvKGMXbRYDxNvobf
         mczucf+OZEujWqbZL16ZepshGvi9gNK3p/p7N6rFSuvwws4bUZC93RJ89XFoELryXoGm
         lm9C8OttmYpf2GkbD8SD56LYA/1Q5O8xt3YiwghVM/kN5MRwNtGtHGFp1vA+HJe9lFb2
         Vppg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XFCN/rKe4bMqEFjiiLTtEHRCJj9MQsZ19jltg/H+fQ4=;
        b=CEhq9s8/TsTyUc5FbkZvYd9q4QXBKOSWtV4s6LwjVuEf1GPogfEEooaZJlfjGh9qVC
         VkZcF9ZERTpZvsPxEM3YbKtpDnxuAUYPfuT9N0F9TYELasqSpbg7F/csJXed5AeeuUuJ
         y2KuoXi7XBS3yrqCkSiiKmBgH4wHQb7zzrSN4Y5tQyjbo8ZgC7ySfUtBF8KGsX1H8Xt3
         O4YiCiev5Fba1/+eju5r0gNL9h2ldzmL5aJA0EGA6iiNx8NGZ7cGmnG7LK283xqL1o7I
         /9v7Q1OJ58Ep47RdVfPHXANl7tBlf0tqkNPyoO15HS+NMJLwoE6l/EuMVIiHe/K4qFhu
         WYJQ==
X-Gm-Message-State: AOAM5300ozTK4YRYDcb6n9SSlNzwpOVTWtIe9FqTJHWn9K20p9j6P2Lk
        hgASMXI+p9O9YVfcEnxYXCp3C16fr94Fg8+xDaM=
X-Google-Smtp-Source: ABdhPJyMLmG3C2wkKGLNgnG3ZcpVC9P0+WFucTFUNbS+xI7sVK15sjQmlBS9LEtORCBr0t5/p44ahYzTBhwqTFXoy0w=
X-Received: by 2002:aca:c50b:: with SMTP id v11mr343269oif.76.1599803630949;
 Thu, 10 Sep 2020 22:53:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200909084510.648706-2-allen.lkml@gmail.com> <20200909.110956.600909796407174509.davem@davemloft.net>
 <CAOMdWSKQxbKzo6z9BBO=0HPCxSs1nt8ArAe5zi_X5cPQhtnUVA@mail.gmail.com> <20200909.143324.405366987951760976.davem@davemloft.net>
In-Reply-To: <20200909.143324.405366987951760976.davem@davemloft.net>
From:   Allen <allen.lkml@gmail.com>
Date:   Fri, 11 Sep 2020 11:23:39 +0530
Message-ID: <CAOMdWSKgpfk=VvCYLjouAVC7Z9fFrh-bCHs0phJrjBgLenVpfw@mail.gmail.com>
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
> >>
> >> > @@ -1562,10 +1562,11 @@ static void ace_watchdog(struct net_device *data, unsigned int txqueue)
> >> >  }
> >> >
> >> >
> >> > -static void ace_tasklet(unsigned long arg)
> >> > +static void ace_tasklet(struct tasklet_struct *t)
> >> >  {
> >> > -     struct net_device *dev = (struct net_device *) arg;
> >> > -     struct ace_private *ap = netdev_priv(dev);
> >> > +     struct ace_private *ap = from_tasklet(ap, t, ace_tasklet);
> >> > +     struct net_device *dev = (struct net_device *)((char *)ap -
> >> > +                             ALIGN(sizeof(struct net_device), NETDEV_ALIGN));
> >> >       int cur_size;
> >> >
> >>
> >> I don't see this is as an improvement.  The 'dev' assignment looks so
> >> incredibly fragile and exposes so many internal details about netdev
> >> object allocation, alignment, and layout.
> >>
> >> Who is going to find and fix this if someone changes how netdev object
> >> allocation works?
> >>
> >
> > Thanks for pointing it out. I'll see if I can fix it to keep it simple.
>
> Just add a backpointer to the netdev from the netdev_priv() if you
> absolutely have too.
>

Okay.

> >> I don't want to apply this, it sets a very bad precedent.  The existing
> >> code is so much cleaner and easier to understand and audit.
> >
> > Will you pick the rest of the patches or would they have to wait till
> > this one is
> > fixed.
>
> I never pick up a partial series, ever.  So yes you will have to fix these
> two patches up and resubmit the entire thing.
>

Sure, let me get these fixed up and ready. Thanks.

-- 
       - Allen
