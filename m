Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176E02D9E62
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 19:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502252AbgLNSAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 13:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408739AbgLNSAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 13:00:18 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B16C0613D6
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 09:59:34 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id w127so16306916ybw.8
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 09:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cuJzCqw0yGcbmg+mGFFGUw4gt0nbbXNBdOYye9PxvVU=;
        b=f3P3xb8XZVFEGeKbrCMLRvmnfpRTJ5NPkAXK5avGo8jV/CosGvtBkd+JZpJGPvCi8f
         WLDg2Z+0HuLmEWsYCJdBy3HMbKZdeO8dAsTVSGF4f89oR0F+hySPRA2l9HHakECEqLKB
         d88EdNcyu40unSQMhbcRBlMtJJAy1qrbrHvue3iW3HAA0iwiIazIMGxzvdNf2AbRgrot
         MGX6XfrRXxGMdIxH88yblvoEq5cJuLTQoXL9AQt4rXvDjJhq2UJzjdidaFWPDSXDLyc0
         Qx3IWnE64kNbuqh8KkGDvakk0wUzgk+EUHza/ZaWHf4hZ/yDOzD+V36ZP3Mc/L5/OIjz
         Nypg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cuJzCqw0yGcbmg+mGFFGUw4gt0nbbXNBdOYye9PxvVU=;
        b=HyJSQwZDvibpkaW4OgXIqQUz0HBcPjNJJTSgajjhXTe39nxaVIP+W/ISg7jky5URmB
         Jc4+UrNbjsXuUjrDYttl8Rxk/usUTwU4RqJ3Fc5WoruXdiwJLRNSoTbQbZhqU7YQJXzD
         EI8/Y96EMB3HIwCwbZxw4yMSgWUsqN23wze+3jw7zTeaACyWxDrLoKi4QoMaxLx1Re8r
         YqrvPlnFfJn+IZrIhGwvGvM6v/XhlzilcdEVonS+EsrOAk8F+WBeIL1gqLhiKRKvLboe
         T9RWF6roRHUdsEySkL3OMDdFpDO3tFMVc8asfke3oa6ewYckp1f4VCQwlppk7h1v1BGR
         tqkQ==
X-Gm-Message-State: AOAM533kGq3cGyrKUBKQlwW9AoQUU2i0yX4qHfV+G82Eyfjkuy3sxp6P
        QyXg5KnhcRNU03l6Uh5W8lG+MfxxYa6jNCbfnqJcmQ==
X-Google-Smtp-Source: ABdhPJwwf2PvLDsu9SWZKcLa3hxzFq/txQgJ7TWDMe9dGgExGmKI1IwP2GZizLjr4ATkwPOIj19GR2RNwxuNTp/C364=
X-Received: by 2002:a25:8201:: with SMTP id q1mr7668402ybk.351.1607968772499;
 Mon, 14 Dec 2020 09:59:32 -0800 (PST)
MIME-Version: 1.0
References: <20201209005444.1949356-1-weiwan@google.com> <20201209005444.1949356-3-weiwan@google.com>
 <20201212145022.6f2698d3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <20201212145503.285a8bfb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201212145503.285a8bfb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Wei Wang <weiwan@google.com>
Date:   Mon, 14 Dec 2020 09:59:21 -0800
Message-ID: <CAEA6p_BM_H=2bhYBtJ3LtBT0DBPBeVLyuC=BRQv=H3Ww2eecWA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/3] net: implement threaded-able napi poll
 loop support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        Felix Fietkau <nbd@nbd.name>, Hillf Danton <hdanton@sina.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 12, 2020 at 2:55 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 12 Dec 2020 14:50:22 -0800 Jakub Kicinski wrote:
> > > @@ -6731,6 +6790,7 @@ void napi_disable(struct napi_struct *n)
> > >             msleep(1);
> > >
> > >     hrtimer_cancel(&n->timer);
> > > +   napi_kthread_stop(n);
> >
> > I'm surprised that we stop the thread on napi_disable() but there is no
> > start/create in napi_enable(). NAPIs can (and do get) disabled and
> > enabled again. But that'd make your code crash with many popular
> > drivers if you tried to change rings with threaded napi enabled so I
> > feel like I must be missing something..
>
> Ah, not crash, 'cause the flag gets cleared. Is it intentional that any
> changes that disable NAPIs cause us to go back to non-threaded NAPI?
> I think I had the "threaded" setting stored in struct netdevice in my
> patches, is there a reason not to do that?
>

Thanks for the comments!

The reason that I did not record it in dev is: there is a slight
chance that during creation of the kthreads, failures occur and we
flip back all NAPIs to use non-threaded mode. I am not sure the
recorded value in dev should be what user desires, or what the actual
situation is. Same as after the driver does a
napi_disabe()/napi_enable(). It might occur that the dev->threaded =
true, but the operation to re-create the kthreads fail and we flip
back to non-thread mode. This seems to get things more complicated.
What I expect is the user only enables the threaded mode after the
device is up and alive, with all NAPIs attached to dev, and enabled.
And user has to check the sysfs to make sure that the operation
succeeds.
And any operation that brings down the device, will flip this back to
default, which is non-threaded mode.

> In fact your patches may _require_ the device to be up to enable
> threaded NAPI if NAPIs are allocated in open.
