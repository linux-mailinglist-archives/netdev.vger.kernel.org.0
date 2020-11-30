Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5762C8B43
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 18:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387725AbgK3RgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 12:36:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387720AbgK3RgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 12:36:13 -0500
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B606EC0613D2;
        Mon, 30 Nov 2020 09:35:33 -0800 (PST)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 029ECB26;
        Mon, 30 Nov 2020 18:35:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1606757732;
        bh=R7OEenYHdXActne42tz0vYeapjLO4a3xipVuLSxiR3o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qSfKTDM0Xyu3P8ooAxG6IgCU6jE4FlI8SWoYYEI3skkJMk/QTsV1sLCvUT/dI5CFk
         k4K15DLe6f6LygS+0hhz++An8JM8opgoA79BzhCdro5MQ6CZUC9y1AnZECl0HkYX77
         +ySLyPFlm9MezncBgFc/Ma5CkUsQIwwwI5whWqxk=
Date:   Mon, 30 Nov 2020 19:35:23 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
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
Subject: Re: [PATCH v3 1/2] PM: runtime: Add pm_runtime_resume_and_get to
 deal with usage counter
Message-ID: <20201130173523.GT14465@pendragon.ideasonboard.com>
References: <20201110092933.3342784-1-zhangqilong3@huawei.com>
 <20201110092933.3342784-2-zhangqilong3@huawei.com>
 <CAMuHMdUH3xnAtQmmMqQDUY5O6H89uk12v6hiZXFThw9yuBAqGQ@mail.gmail.com>
 <CAJZ5v0hVXSgUm877iv3i=1vs1t2QFpGW=-4qTFf2WedTJBU8Zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJZ5v0hVXSgUm877iv3i=1vs1t2QFpGW=-4qTFf2WedTJBU8Zg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 05:37:52PM +0100, Rafael J. Wysocki wrote:
> On Fri, Nov 27, 2020 at 11:16 AM Geert Uytterhoeven wrote:
> > On Tue, Nov 10, 2020 at 10:29 AM Zhang Qilong <zhangqilong3@huawei.com> wrote:
> > > In many case, we need to check return value of pm_runtime_get_sync, but
> > > it brings a trouble to the usage counter processing. Many callers forget
> > > to decrease the usage counter when it failed, which could resulted in
> > > reference leak. It has been discussed a lot[0][1]. So we add a function
> > > to deal with the usage counter for better coding.
> > >
> > > [0]https://lkml.org/lkml/2020/6/14/88
> > > [1]https://patchwork.ozlabs.org/project/linux-tegra/list/?series=178139
> > > Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> >
> > Thanks for your patch, which is now commit dd8088d5a8969dc2 ("PM:
> > runtime: Add pm_runtime_resume_and_get to deal with usage counter") in
> > v5.10-rc5.
> >
> > > --- a/include/linux/pm_runtime.h
> > > +++ b/include/linux/pm_runtime.h
> > > @@ -386,6 +386,27 @@ static inline int pm_runtime_get_sync(struct device *dev)
> > >         return __pm_runtime_resume(dev, RPM_GET_PUT);
> > >  }
> > >
> > > +/**
> > > + * pm_runtime_resume_and_get - Bump up usage counter of a device and resume it.
> > > + * @dev: Target device.
> > > + *
> > > + * Resume @dev synchronously and if that is successful, increment its runtime
> > > + * PM usage counter. Return 0 if the runtime PM usage counter of @dev has been
> > > + * incremented or a negative error code otherwise.
> > > + */
> > > +static inline int pm_runtime_resume_and_get(struct device *dev)
> >
> > Perhaps this function should be called pm_runtime_resume_and_get_sync(),
> 
> No, really.
> 
> I might consider calling it pm_runtime_acquire(), and adding a
> matching _release() as a pm_runtime_get() synonym for that matter, but
> not the above.

pm_runtime_acquire() seems better to me too. Would pm_runtime_release()
would be an alias for pm_runtime_put() ?

We would also likely need a pm_runtime_release_autosuspend() too then.
But on that topic, I was wondering, is there a reason we can't select
autosuspend behaviour automatically when autosuspend is enabled ?

> > to make it clear it does a synchronous get?
> >
> > I had to look into the implementation to verify that a change like
> 
> I'm not sure why, because the kerneldoc is unambiguous AFAICS.
> 
> >
> > -       ret = pm_runtime_get_sync(&pdev->dev);
> > +       ret = pm_runtime_resume_and_get(&pdev->dev);
> >
> > in the follow-up patches is actually a valid change, maintaining
> > synchronous operation. Oh, pm_runtime_resume() is synchronous, too...
> 
> Yes, it is.

-- 
Regards,

Laurent Pinchart
