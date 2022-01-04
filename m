Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3BD4845EA
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 17:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbiADQW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 11:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbiADQW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 11:22:27 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FB5C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 08:22:27 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id w184so89724435ybg.5
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 08:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=efm/PSRdrmnLqbgixgaFf3Si8nYIA4neves8WHa+yZw=;
        b=lqERFNjeDvP64YR7Ds9dyXyNnvPyXBP8IO9B7WhrOyniyZMFRChzZjFjDiEPGJzS7V
         qYPKZf0o1jY8Q/alMLdj1kmKZWkrOvs0g3J4bLHLAtJIdQiXzsG8s5zRTXDxvan1UFUz
         aquMMXuIbu7Q9HOkUXfOxSeB6cOf3Jv1U3PmSxHogQvOXQ9bHIAPwbdMso3YIzibUjZT
         PWTjQY6ZA13dDhC2GVdkTMUp3xnFNXf+XhPhVNpKZvcV5iwzK/IL9v/BuikORIyYdbXs
         TUvUt9NgGcSb5hMpmI61JNy0CoGTDtWpiH8NLchrLbnetUtY7zstSOhLoJQ5otTQg1ZS
         dTVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=efm/PSRdrmnLqbgixgaFf3Si8nYIA4neves8WHa+yZw=;
        b=7g/89j04ENgOgyBUZ579TPQFmd1vz1mAWmz+MAniHh/NPKPMiC+FeFc9UcCh0p8Vj1
         jAmFDEoBIHzXyYYaiaNDXfO1GKJ6meZQ+Xgt69i1i4aVjQtvmpIX7cOyrfj5HiCFc0dH
         8gH2rEamdd1HFY5nEet4dON+43E2KdlZ1Pb0nMddodKCMnfRBnVK1sciYH4Z0C9tzAQo
         Xw6wz0iHJ15Ahs8Icwhe8UG9Ljzv9GhQrwUIObSsOnwcUr0trfIv9n1fdECf+AT4ObBz
         6I6945zqYLt1upzeGXlLPLTC35yrgan9xLpJ70d8fbM8w+3IrN28MqDGkXO+cpbsc1XM
         X5Sw==
X-Gm-Message-State: AOAM53236MPBVz/n5AfG6yrUPTLQt+OJQB1ShlfrActadc/hA5JYXecH
        zoFDWtm614dncVTEyeis2hIP8NdZ5wZwFOZbfoDAoKejJQ63fg==
X-Google-Smtp-Source: ABdhPJw5YdnR2JC+pDQkHUXqfHQBLr32RuK8ZPFpQSe4w7wTjR9eIB3HRidYVSKzoPyWZbHpmLuW1Mdi5CScm/4e6vg=
X-Received: by 2002:a25:9d82:: with SMTP id v2mr62453387ybp.383.1641313345952;
 Tue, 04 Jan 2022 08:22:25 -0800 (PST)
MIME-Version: 1.0
References: <20211207013039.1868645-1-eric.dumazet@gmail.com>
 <20211207013039.1868645-12-eric.dumazet@gmail.com> <5836510f3ea87678e1a3bf6d9ff09c0e70942d13.camel@sipsolutions.net>
 <CANn89i+yzt=Y_fgjYJb3VMYCn7aodFVRbZ9hUjb0e4+T+d14ww@mail.gmail.com> <c14b5872799b071145c79a78aab238884510f2a9.camel@sipsolutions.net>
In-Reply-To: <c14b5872799b071145c79a78aab238884510f2a9.camel@sipsolutions.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 4 Jan 2022 08:22:14 -0800
Message-ID: <CANn89iLYo8XQbKGxT=pKQepe8FeELx0pnpMWjKS8n93uHwNJ5Q@mail.gmail.com>
Subject: Re: [PATCH net-next 11/13] netlink: add net device refcount tracker
 to struct ethnl_req_info
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 4, 2022 at 8:07 AM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> Hi Eric,
>
> > > > @@ -624,6 +625,7 @@ static void ethnl_default_notify(struct net_device *dev, unsigned int cmd,
> > > >       }
> > > >
> > > >       req_info->dev = dev;
> > > > +     netdev_tracker_alloc(dev, &req_info->dev_tracker, GFP_KERNEL);
> > > >       req_info->flags |= ETHTOOL_FLAG_COMPACT_BITSETS;
> > > >
> > >
> > > I may have missed a follow-up patch (did a search on netdev now, but
> > > ...), but I'm hitting warnings from this and I'm not sure it's right?
> > >
> > > This req_info is just allocated briefly and freed again, and I'm not
> > > even sure there's a dev_get/dev_put involved here, I didn't see any?
> >
> > We had a fix.
> >
> > commit 34ac17ecbf575eb079094d44f1bd30c66897aa21
> > Author: Eric Dumazet <edumazet@google.com>
> > Date:   Tue Dec 14 00:42:30 2021 -0800
> >
> >     ethtool: use ethnl_parse_header_dev_put()
> >
>
> Hmm. I have this in my tree, and I don't think it affected
> ethnl_default_notify() anyway?

Strange, syzbot have not reported anything there.

ethnl_parse_header_dev_get() needs to take a ref, but
indeed ethnl_default_notify() does its own allocation/freeing.

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index ea23659fab28..5fe8f4ae2ceb 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -627,7 +627,6 @@ static void ethnl_default_notify(struct net_device
*dev, unsigned int cmd,
        }

        req_info->dev = dev;
-       netdev_tracker_alloc(dev, &req_info->dev_tracker, GFP_KERNEL);
        req_info->flags |= ETHTOOL_FLAG_COMPACT_BITSETS;

        ethnl_init_reply_data(reply_data, ops, dev);
