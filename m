Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37FB313C5B9
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 15:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbgAOOQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 09:16:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:43488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726501AbgAOOQg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 09:16:36 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CBBD2073A;
        Wed, 15 Jan 2020 14:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579097795;
        bh=OH4aikfdqD2aIrwygUCTdgnd7dYGOYvI9tWf6tvDeX8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=spaMyxtRPLtcVmkplPFiCVGICw60qKBxas3kxFZBWgR2nQGKzzWEiI+DHc+NXG6EJ
         GJkp1V4UYK+8sQS154uAVcoYpBW8y5s1lavkrn8bZ6hRWSo++5uEYb1BQf5cwKHItt
         OY/+lBRvIBVHc6cXq7zNcv5VuQIieqoUF0IP6xs8=
Date:   Wed, 15 Jan 2020 06:16:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net 1/5] netdevsim: fix a race condition in netdevsim
 operations
Message-ID: <20200115061634.35da2950@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <CAMArcTUx46w35JPhw5hvnKW+g9z9Lqrv7u1DsnKOeWnvFaAsxg@mail.gmail.com>
References: <20200111163655.4087-1-ap420073@gmail.com>
        <20200112061937.171f6d88@cakuba>
        <CAMArcTUx46w35JPhw5hvnKW+g9z9Lqrv7u1DsnKOeWnvFaAsxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jan 2020 00:26:22 +0900, Taehee Yoo wrote:
> On Sun, 12 Jan 2020 at 23:19, Jakub Kicinski wrote:
> Hi Jakub,
> Thank you for your review!

Thank you for fixing these tricky bugs! :)

> > Perhaps the entire bus dev structure should be freed from release?
> 
> I tested this like this.
> 
> @@ -146,6 +161,8 @@ static void nsim_bus_dev_release(struct device *dev)
>         struct nsim_bus_dev *nsim_bus_dev = to_nsim_bus_dev(dev);
> 
>         nsim_bus_dev_vfs_disable(nsim_bus_dev);
> +       ida_free(&nsim_bus_dev_ids, nsim_bus_dev->dev.id);
> +       kfree(nsim_bus_dev);
>  }
> @@ -300,8 +320,6 @@ nsim_bus_dev_new(unsigned int id, unsigned int port_count)
>  static void nsim_bus_dev_del(struct nsim_bus_dev *nsim_bus_dev)
>  {
>         device_unregister(&nsim_bus_dev->dev);
> -       ida_free(&nsim_bus_dev_ids, nsim_bus_dev->dev.id);
> -       kfree(nsim_bus_dev);
>  }
> 
> It works well. but I'm not sure this is needed.

My concern is that process A opens a sysfs file (eg. numvfs) then
process B deletes the device, but process A still has a file descriptor
(and device reference) so it may be able to write/read the numvfs file
even though nsim_bus_dev was already freed. 

I may very well be wrong, and something else may be preventing this
condition. It's just a bit strange to see release free an internal
sub-structure, while the main structure is freed immediately..

> > >       unsigned int num_vfs;
> > >       int ret;
> > >
> > > +     if (!mutex_trylock(&nsim_bus_dev_ops_lock))
> > > +             return -EBUSY;  
> >
> > Why the trylocks? Are you trying to catch the races between unregister
> > and other ops?
> >  
> 
> The reason is to avoid deadlock.
> If we use mutex_lock() instead of mutex_trylock(), the below message
> will be printed and actual deadlock also appeared.

> [  426.907883][  T805]  Possible unsafe locking scenario:
> [  426.907883][  T805]
> [  426.908715][  T805]        CPU0                    CPU1
> [  426.909312][  T805]        ----                    ----
> [  426.909902][  T805]   lock(kn->count#170);
> [  426.910372][  T805]
> lock(nsim_bus_dev_ops_lock);
> [  426.911277][  T805]                                lock(kn->count#170);
> [  426.912032][  T805]   lock(nsim_bus_dev_ops_lock);

> Locking ordering of {new/del}_device() and {new/del}_port is different.
> So, a deadlock could occur.

Hm, we can't use the same lock for the bus ops and port ops.
But the port ops already take port lock, do we really need 
another lock there?

Also does nsim_bus_exit() really need to iterate over devices to remove
them? Does core not do it for us?
