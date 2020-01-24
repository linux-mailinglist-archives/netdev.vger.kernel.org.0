Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEC3148667
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 14:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388167AbgAXNxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 08:53:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:59338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387592AbgAXNxG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 08:53:06 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F8CD20718;
        Fri, 24 Jan 2020 13:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579873985;
        bh=pe0K7SZWQy5C6lsAqwUf8pvTFpKqZDjxgBH7FivI1tg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TC5i8FFYlCecCYylrg/PQ5joT6G0gZGbTAa5LFETK6MXMSOWxVvzYSzXUgLtJ9AHM
         bg4L+vkhkC5A5QJ54fEyrgtHJBGud+YWk41XGfs8ipz0hOy2noeU4MsixYxVLKPm+H
         Lf2ovfIdkhoL3o4MvF5h8ha9ngJfOFY2+NR0YnJE=
Date:   Fri, 24 Jan 2020 05:53:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net 1/5] netdevsim: fix a race condition in netdevsim
 operations
Message-ID: <20200124055304.4457aacd@cakuba>
In-Reply-To: <CAMArcTUOC4YTXrCDoMpbMDwiQmCVm_uXJzgbDt8UFYm0D=DfOw@mail.gmail.com>
References: <20200111163655.4087-1-ap420073@gmail.com>
        <20200112061937.171f6d88@cakuba>
        <CAMArcTUx46w35JPhw5hvnKW+g9z9Lqrv7u1DsnKOeWnvFaAsxg@mail.gmail.com>
        <20200115061634.35da2950@cakuba.hsd1.ca.comcast.net>
        <CAMArcTUOC4YTXrCDoMpbMDwiQmCVm_uXJzgbDt8UFYm0D=DfOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Jan 2020 14:16:03 +0900, Taehee Yoo wrote:
> On Wed, 15 Jan 2020 at 23:16, Jakub Kicinski <kuba@kernel.org> wrote:
> > I may very well be wrong, and something else may be preventing this
> > condition. It's just a bit strange to see release free an internal
> > sub-structure, while the main structure is freed immediately..
> 
> I didn't think about ordering of resource release routine.
> So I took a look at the release routine.
> 
> del_device_store()
>     nsim_bus_dev_del()
>         nsim_bus_dev_del()
>             kobject_put()
>                 device_release()
>                     nsim_bus_dev_release()
>                         kfree(nsim_bus_dev->vconfigs)
>     kfree(nsim_bus_dev)
> 
> Before freeing nsim_bus_dev, all resources are freed in the
> device_unregister(). So, I think it's safe.

I see

> > > > >       unsigned int num_vfs;
> > > > >       int ret;
> > > > >
> > > > > +     if (!mutex_trylock(&nsim_bus_dev_ops_lock))
> > > > > +             return -EBUSY;  
> > > >
> > > > Why the trylocks? Are you trying to catch the races between unregister
> > > > and other ops?
> > > >  
> > >
> > > The reason is to avoid deadlock.
> > > If we use mutex_lock() instead of mutex_trylock(), the below message
> > > will be printed and actual deadlock also appeared.  
> >  
> > > [  426.907883][  T805]  Possible unsafe locking scenario:
> > > [  426.907883][  T805]
> > > [  426.908715][  T805]        CPU0                    CPU1
> > > [  426.909312][  T805]        ----                    ----
> > > [  426.909902][  T805]   lock(kn->count#170);
> > > [  426.910372][  T805]
> > > lock(nsim_bus_dev_ops_lock);
> > > [  426.911277][  T805]                                lock(kn->count#170);
> > > [  426.912032][  T805]   lock(nsim_bus_dev_ops_lock);  
> >  
> > > Locking ordering of {new/del}_device() and {new/del}_port is different.
> > > So, a deadlock could occur.  
> >
> > Hm, we can't use the same lock for the bus ops and port ops.
> > But the port ops already take port lock, do we really need
> > another lock there?
> >  
> 
> A synchronize routine is needed.
> new_port() and del_port() operations access many device resources.
> It could be used even before resources are allocated or initialized.
> So, new_port() and del_port() should be allowed to use after resources
> are initialized. But sriov_numvfs() doesn't use uninitialized resource
> so it doesn't make any problem.

Oh - because the device can be registered, but that doesn't
mean it's probed yet..

> If a simple flag variable is used, we can avoid using a trylock.
> The flag is set after resources are initialized.
> So if new_port() and del_port() check the flag, it doesn't access
> uninitialized resources.
>
> I would like to try to avoid using trylock.

Sounds good!
 
> > Also does nsim_bus_exit() really need to iterate over devices to remove
> > them? Does core not do it for us?  
> 
> I couldn't find the logic, which remove devices.
> So I think it's needed.

OK, thanks for checking!
