Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B122C8DC5
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 20:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388298AbgK3TNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 14:13:05 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:39571 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388258AbgK3TNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 14:13:05 -0500
Received: by mail-oi1-f194.google.com with SMTP id f11so15370523oij.6;
        Mon, 30 Nov 2020 11:12:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pmtf1a4HitphENukeG8SqVWu3Y/HvkXNeG2L2oSB6Qw=;
        b=nMSznXSQd1qyNq0QkihhWaYxaGvUF3n47tcg7PPm4EEA/dsNkkaPz6fHM5qWV0BCHX
         zIrwgOQHN+A69OnqPmp7ozHpwHvRxnbD6B4T/h+6nsPm1V5Utpy1KRK5AU8M4auDBfZx
         7ncV347LNqE0Wkx6fH9p3lSeYrPN+441cwSD3zMr3P3dWWvQhgyfZdm245cOWdDadD4W
         2YHGOBrxav3ff7olXHrmkl02hMhdu2WjDeOzRpNQeBkP2ftL7klCyu9URJ1z4fIFSEB/
         17UuOnpPjcQjbu52WB7wOzw/umN9c9+ToYMj4xHsV2uUbAOfiBkhaB+QqdJ03J1gTl0f
         g5/Q==
X-Gm-Message-State: AOAM5300SEwJeIfN/HpAnKz+hx87HsBExeuR3/vtjMST20iaALp150RL
        UHdiB84PxCIdMS/oaVqlLyrq/W4k97dHdN5jg8c=
X-Google-Smtp-Source: ABdhPJytCrnnJx3U8JlCMd8DxOc553DmUH/ROIEcNJOOJQRN0dMwydE7GTi6LPyZgwAb7k5a+BArNOMdbE+guXUymWU=
X-Received: by 2002:aca:f15:: with SMTP id 21mr261009oip.71.1606763543910;
 Mon, 30 Nov 2020 11:12:23 -0800 (PST)
MIME-Version: 1.0
References: <20201110092933.3342784-1-zhangqilong3@huawei.com>
 <20201110092933.3342784-2-zhangqilong3@huawei.com> <CAMuHMdUH3xnAtQmmMqQDUY5O6H89uk12v6hiZXFThw9yuBAqGQ@mail.gmail.com>
 <CAJZ5v0hVXSgUm877iv3i=1vs1t2QFpGW=-4qTFf2WedTJBU8Zg@mail.gmail.com>
 <20201130173523.GT14465@pendragon.ideasonboard.com> <CAJZ5v0gx08RY+RjU90y222fLUq7YiO4x6PW3d9GNk4wYadzv_w@mail.gmail.com>
 <20201130185044.GZ4141@pendragon.ideasonboard.com>
In-Reply-To: <20201130185044.GZ4141@pendragon.ideasonboard.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 30 Nov 2020 20:12:12 +0100
Message-ID: <CAJZ5v0iALE+oSXmJ7mWGCEG7MwFptfMwa-_SS8BusMUx7C7urA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] PM: runtime: Add pm_runtime_resume_and_get to deal
 with usage counter
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 7:50 PM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Rafael,
>
> On Mon, Nov 30, 2020 at 06:55:57PM +0100, Rafael J. Wysocki wrote:
> > On Mon, Nov 30, 2020 at 6:35 PM Laurent Pinchart wrote:
> > > On Mon, Nov 30, 2020 at 05:37:52PM +0100, Rafael J. Wysocki wrote:
> > > > On Fri, Nov 27, 2020 at 11:16 AM Geert Uytterhoeven wrote:
> > > > > On Tue, Nov 10, 2020 at 10:29 AM Zhang Qilong <zhangqilong3@huawei.com> wrote:
> > > > > > In many case, we need to check return value of pm_runtime_get_sync, but
> > > > > > it brings a trouble to the usage counter processing. Many callers forget
> > > > > > to decrease the usage counter when it failed, which could resulted in
> > > > > > reference leak. It has been discussed a lot[0][1]. So we add a function
> > > > > > to deal with the usage counter for better coding.
> > > > > >
> > > > > > [0]https://lkml.org/lkml/2020/6/14/88
> > > > > > [1]https://patchwork.ozlabs.org/project/linux-tegra/list/?series=178139
> > > > > > Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> > > > >
> > > > > Thanks for your patch, which is now commit dd8088d5a8969dc2 ("PM:
> > > > > runtime: Add pm_runtime_resume_and_get to deal with usage counter") in
> > > > > v5.10-rc5.
> > > > >
> > > > > > --- a/include/linux/pm_runtime.h
> > > > > > +++ b/include/linux/pm_runtime.h
> > > > > > @@ -386,6 +386,27 @@ static inline int pm_runtime_get_sync(struct device *dev)
> > > > > >         return __pm_runtime_resume(dev, RPM_GET_PUT);
> > > > > >  }
> > > > > >
> > > > > > +/**
> > > > > > + * pm_runtime_resume_and_get - Bump up usage counter of a device and resume it.
> > > > > > + * @dev: Target device.
> > > > > > + *
> > > > > > + * Resume @dev synchronously and if that is successful, increment its runtime
> > > > > > + * PM usage counter. Return 0 if the runtime PM usage counter of @dev has been
> > > > > > + * incremented or a negative error code otherwise.
> > > > > > + */
> > > > > > +static inline int pm_runtime_resume_and_get(struct device *dev)
> > > > >
> > > > > Perhaps this function should be called pm_runtime_resume_and_get_sync(),
> > > >
> > > > No, really.
> > > >
> > > > I might consider calling it pm_runtime_acquire(), and adding a
> > > > matching _release() as a pm_runtime_get() synonym for that matter, but
> > > > not the above.
> > >
> > > pm_runtime_acquire() seems better to me too. Would pm_runtime_release()
> > > would be an alias for pm_runtime_put() ?
> >
> > Yes.  This covers all of the use cases relevant for drivers AFAICS.
> >
> > > We would also likely need a pm_runtime_release_autosuspend() too then.
> >
> > Why would we?
> >
> > > But on that topic, I was wondering, is there a reason we can't select
> > > autosuspend behaviour automatically when autosuspend is enabled ?
> >
> > That is the case already.
> >
> > pm_runtime_put() will autosuspend if enabled and the usage counter is
> > 0, as long as ->runtime_idle() returns 0 (or is absent).
> >
> > pm_runtime_put_autosuspend() is an optimization allowing
> > ->runtime_idle() to be skipped entirely, but I'm wondering how many
> > users really need that.
>
> Ah, I didn't know that, that's good to know. We then don't need
> pm_runtime_release_autosuspend() (unless the optimization really makes a
> big difference).
>
> Should I write new drievr code with pm_runtime_put() instead of
> pm_runtime_put_autosuspend() ?

If you don't have ->runtime_idle() in the driver (and in the bus type
generally speaking, but none of them provide it IIRC),
pm_runtime_put() is basically equivalent to
pm_runtime_put_autosuspend() AFAICS, except for some extra checks done
by the former.

Otherwise it all depends on what the ->runtime_idle() callback does,
but it is hard to imagine a practical use case when the difference
would be really meaningful.

> I haven't found clear guidelines on this in the documentation.

Yes, that's one of the items I need to take care of.
