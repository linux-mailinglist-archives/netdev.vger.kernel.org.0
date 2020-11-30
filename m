Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533612C8D40
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 19:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387879AbgK3Svh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 13:51:37 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:33080 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387735AbgK3Svf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 13:51:35 -0500
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 945EF2A4;
        Mon, 30 Nov 2020 19:50:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1606762252;
        bh=RYPSsiTosnAD+ZN+SZZDJFZnGttsHQTdpttar3k1Mnc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RWirhkVyj5MwMV72mfJGTP+V9L424pGhwBYgkTAoDzf9bBsyTAKhIt/fW4w3izSJs
         CG35nJz1K990Qiv/ce6p4H5bq7BbfpJGWlryRLrKY8joLg62eufWLSJOan7pJ2bk/c
         UKbZje++dTIHVvd6PiELeLPTegrDGDF+BtidtWoY=
Date:   Mon, 30 Nov 2020 20:50:44 +0200
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
Message-ID: <20201130185044.GZ4141@pendragon.ideasonboard.com>
References: <20201110092933.3342784-1-zhangqilong3@huawei.com>
 <20201110092933.3342784-2-zhangqilong3@huawei.com>
 <CAMuHMdUH3xnAtQmmMqQDUY5O6H89uk12v6hiZXFThw9yuBAqGQ@mail.gmail.com>
 <CAJZ5v0hVXSgUm877iv3i=1vs1t2QFpGW=-4qTFf2WedTJBU8Zg@mail.gmail.com>
 <20201130173523.GT14465@pendragon.ideasonboard.com>
 <CAJZ5v0gx08RY+RjU90y222fLUq7YiO4x6PW3d9GNk4wYadzv_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJZ5v0gx08RY+RjU90y222fLUq7YiO4x6PW3d9GNk4wYadzv_w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rafael,

On Mon, Nov 30, 2020 at 06:55:57PM +0100, Rafael J. Wysocki wrote:
> On Mon, Nov 30, 2020 at 6:35 PM Laurent Pinchart wrote:
> > On Mon, Nov 30, 2020 at 05:37:52PM +0100, Rafael J. Wysocki wrote:
> > > On Fri, Nov 27, 2020 at 11:16 AM Geert Uytterhoeven wrote:
> > > > On Tue, Nov 10, 2020 at 10:29 AM Zhang Qilong <zhangqilong3@huawei.com> wrote:
> > > > > In many case, we need to check return value of pm_runtime_get_sync, but
> > > > > it brings a trouble to the usage counter processing. Many callers forget
> > > > > to decrease the usage counter when it failed, which could resulted in
> > > > > reference leak. It has been discussed a lot[0][1]. So we add a function
> > > > > to deal with the usage counter for better coding.
> > > > >
> > > > > [0]https://lkml.org/lkml/2020/6/14/88
> > > > > [1]https://patchwork.ozlabs.org/project/linux-tegra/list/?series=178139
> > > > > Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> > > >
> > > > Thanks for your patch, which is now commit dd8088d5a8969dc2 ("PM:
> > > > runtime: Add pm_runtime_resume_and_get to deal with usage counter") in
> > > > v5.10-rc5.
> > > >
> > > > > --- a/include/linux/pm_runtime.h
> > > > > +++ b/include/linux/pm_runtime.h
> > > > > @@ -386,6 +386,27 @@ static inline int pm_runtime_get_sync(struct device *dev)
> > > > >         return __pm_runtime_resume(dev, RPM_GET_PUT);
> > > > >  }
> > > > >
> > > > > +/**
> > > > > + * pm_runtime_resume_and_get - Bump up usage counter of a device and resume it.
> > > > > + * @dev: Target device.
> > > > > + *
> > > > > + * Resume @dev synchronously and if that is successful, increment its runtime
> > > > > + * PM usage counter. Return 0 if the runtime PM usage counter of @dev has been
> > > > > + * incremented or a negative error code otherwise.
> > > > > + */
> > > > > +static inline int pm_runtime_resume_and_get(struct device *dev)
> > > >
> > > > Perhaps this function should be called pm_runtime_resume_and_get_sync(),
> > >
> > > No, really.
> > >
> > > I might consider calling it pm_runtime_acquire(), and adding a
> > > matching _release() as a pm_runtime_get() synonym for that matter, but
> > > not the above.
> >
> > pm_runtime_acquire() seems better to me too. Would pm_runtime_release()
> > would be an alias for pm_runtime_put() ?
> 
> Yes.  This covers all of the use cases relevant for drivers AFAICS.
> 
> > We would also likely need a pm_runtime_release_autosuspend() too then.
> 
> Why would we?
> 
> > But on that topic, I was wondering, is there a reason we can't select
> > autosuspend behaviour automatically when autosuspend is enabled ?
> 
> That is the case already.
> 
> pm_runtime_put() will autosuspend if enabled and the usage counter is
> 0, as long as ->runtime_idle() returns 0 (or is absent).
> 
> pm_runtime_put_autosuspend() is an optimization allowing
> ->runtime_idle() to be skipped entirely, but I'm wondering how many
> users really need that.

Ah, I didn't know that, that's good to know. We then don't need
pm_runtime_release_autosuspend() (unless the optimization really makes a
big difference).

Should I write new drievr code with pm_runtime_put() instead of
pm_runtime_put_autosuspend() ? I haven't found clear guidelines on this
in the documentation.

-- 
Regards,

Laurent Pinchart
