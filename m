Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 783A71477E2
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 06:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbgAXFQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 00:16:17 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40622 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgAXFQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 00:16:17 -0500
Received: by mail-lj1-f195.google.com with SMTP id n18so992741ljo.7
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 21:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=34il3EgCKZftLQ+1Qe5b7dcKECIwPluR2V+3VMRLiSU=;
        b=dNuh8SgK1IgcUNGMwRtpOa6MEgwP7BS5Hw7tt0K3VEBnd01cwU1iEdKKRbPM9AV1vp
         zhrhSC4mMjX53t83r4bsZqpVXLiiy/4ZVutMUL67EvKIrfi6+wa1KtAbUlau0TepstWy
         6vJ/eduoX8Zcv9N+MZ91e31BYj/JR4Yz17Uh1xxGTIH5Do3mtOtLfuxUZ2mq3NEectJr
         vRuesXoT2+f9gDpkW0geoE05EY6Yk8TQEDFJV8G62oIJfpA0+ExBsrNUB8rNLQY+BUWI
         HAvylI9uGk8Nw8MJQ6envkCvMcVOYJNOj9Mg5fYshXp/Ispr/+8qxH0xDuMXq5UULeWO
         y1WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=34il3EgCKZftLQ+1Qe5b7dcKECIwPluR2V+3VMRLiSU=;
        b=LQwRUc5e/yW1GnxZh1nOnvdkybgIhIFB6lEc9KZltYCOCHk/0lMC2wHkMc1Z8XQxJj
         N0/LTKF+nGSIKWsDYrWwEKyowOjg53O4iZraIHBfl2XGb/cRD6VKmGkTY/LmD+2aHT4W
         T/hXxuDQ4A6ZkLI0IlAr3a89NLevZJAWnGNhsLDCDHUV6B/rcP5+igKnRrQuOViaCy8P
         B63m5o6Hcn3XwRU1xIflLw0sss+tG9HC760RneuHcjwHyXINxLKgrsLYpt9jsv/isalF
         jKdfCK564f7vnbP6AZUqrj79EAe7Hy9bCLGC3N+zWw3WfUB7m/siqfYPieolLlzfG8Zx
         qCkw==
X-Gm-Message-State: APjAAAWeHEuYw3hxm9hw/yhi9WcE946PAfT09t7tvw6RARwS57xv0/jm
        I9H5hRrLnGZUb5OJUdimWccujTMB9w1bomVNqnM=
X-Google-Smtp-Source: APXvYqySeBObTECZoLP1m1I2oLOhbsXTtKYC49wL3imlipFC8vaj+ZwnkuP2vcpCk7eQO18fg80U9+uhK0hhjlErtpE=
X-Received: by 2002:a2e:854b:: with SMTP id u11mr1146366ljj.90.1579842974579;
 Thu, 23 Jan 2020 21:16:14 -0800 (PST)
MIME-Version: 1.0
References: <20200111163655.4087-1-ap420073@gmail.com> <20200112061937.171f6d88@cakuba>
 <CAMArcTUx46w35JPhw5hvnKW+g9z9Lqrv7u1DsnKOeWnvFaAsxg@mail.gmail.com> <20200115061634.35da2950@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200115061634.35da2950@cakuba.hsd1.ca.comcast.net>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Fri, 24 Jan 2020 14:16:03 +0900
Message-ID: <CAMArcTUOC4YTXrCDoMpbMDwiQmCVm_uXJzgbDt8UFYm0D=DfOw@mail.gmail.com>
Subject: Re: [PATCH net 1/5] netdevsim: fix a race condition in netdevsim operations
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jan 2020 at 23:16, Jakub Kicinski <kuba@kernel.org> wrote:
>

Hi Jakub!

> On Wed, 15 Jan 2020 00:26:22 +0900, Taehee Yoo wrote:
> > On Sun, 12 Jan 2020 at 23:19, Jakub Kicinski wrote:
> > Hi Jakub,
> > Thank you for your review!
>
> Thank you for fixing these tricky bugs! :)
>
> > > Perhaps the entire bus dev structure should be freed from release?
> >
> > I tested this like this.
> >
> > @@ -146,6 +161,8 @@ static void nsim_bus_dev_release(struct device *dev)
> >         struct nsim_bus_dev *nsim_bus_dev = to_nsim_bus_dev(dev);
> >
> >         nsim_bus_dev_vfs_disable(nsim_bus_dev);
> > +       ida_free(&nsim_bus_dev_ids, nsim_bus_dev->dev.id);
> > +       kfree(nsim_bus_dev);
> >  }
> > @@ -300,8 +320,6 @@ nsim_bus_dev_new(unsigned int id, unsigned int port_count)
> >  static void nsim_bus_dev_del(struct nsim_bus_dev *nsim_bus_dev)
> >  {
> >         device_unregister(&nsim_bus_dev->dev);
> > -       ida_free(&nsim_bus_dev_ids, nsim_bus_dev->dev.id);
> > -       kfree(nsim_bus_dev);
> >  }
> >
> > It works well. but I'm not sure this is needed.
>
> My concern is that process A opens a sysfs file (eg. numvfs) then
> process B deletes the device, but process A still has a file descriptor
> (and device reference) so it may be able to write/read the numvfs file
> even though nsim_bus_dev was already freed.
>

If I understood kernfs correctly, kernfs internally avoid this situation.
a) When kernfs file is being removed, it waits for all users who are
operating this file(open/read/write, etc...)
b) When kernfs file is removed, the file is disallowed to be used.
c) Opened kernfs file descriptor also will be disallowed to use anymore.
d) File remove routine is finished, resources are freed.
So, user-after-free case couldn't occur.
The below piece of code is kernfs synchronize code.

static void kernfs_drain(struct kernfs_node *kn)
{
 ...
        wait_event(root->deactivate_waitq,
                   atomic_read(&kn->active) == KN_DEACTIVATED_BIAS);
 ...
}

static ssize_t kernfs_fop_write(struct file *file, const char __user *user_buf,
                                size_t count, loff_t *ppos)
{
 ...
        if (!kernfs_get_active(of->kn)) {
                mutex_unlock(&of->mutex);
                len = -ENODEV;
                goto out_free;
        }

        ops = kernfs_ops(of->kn);
        if (ops->write)
                len = ops->write(of, buf, len, *ppos);
        else
                len = -EINVAL;

        kernfs_put_active(of->kn);
 ...
}

void kernfs_put_active(struct kernfs_node *kn)
{
 ...
        v = atomic_dec_return(&kn->active);
        if (likely(v != KN_DEACTIVATED_BIAS))
                return;

        wake_up_all(&kernfs_root(kn)->deactivate_waitq);
}

I have tested this code, it works well.

> I may very well be wrong, and something else may be preventing this
> condition. It's just a bit strange to see release free an internal
> sub-structure, while the main structure is freed immediately..
>

I didn't think about ordering of resource release routine.
So I took a look at the release routine.

del_device_store()
    nsim_bus_dev_del()
        nsim_bus_dev_del()
            kobject_put()
                device_release()
                    nsim_bus_dev_release()
                        kfree(nsim_bus_dev->vconfigs)
    kfree(nsim_bus_dev)

Before freeing nsim_bus_dev, all resources are freed in the
device_unregister(). So, I think it's safe.

> > > >       unsigned int num_vfs;
> > > >       int ret;
> > > >
> > > > +     if (!mutex_trylock(&nsim_bus_dev_ops_lock))
> > > > +             return -EBUSY;
> > >
> > > Why the trylocks? Are you trying to catch the races between unregister
> > > and other ops?
> > >
> >
> > The reason is to avoid deadlock.
> > If we use mutex_lock() instead of mutex_trylock(), the below message
> > will be printed and actual deadlock also appeared.
>
> > [  426.907883][  T805]  Possible unsafe locking scenario:
> > [  426.907883][  T805]
> > [  426.908715][  T805]        CPU0                    CPU1
> > [  426.909312][  T805]        ----                    ----
> > [  426.909902][  T805]   lock(kn->count#170);
> > [  426.910372][  T805]
> > lock(nsim_bus_dev_ops_lock);
> > [  426.911277][  T805]                                lock(kn->count#170);
> > [  426.912032][  T805]   lock(nsim_bus_dev_ops_lock);
>
> > Locking ordering of {new/del}_device() and {new/del}_port is different.
> > So, a deadlock could occur.
>
> Hm, we can't use the same lock for the bus ops and port ops.
> But the port ops already take port lock, do we really need
> another lock there?
>

A synchronize routine is needed.
new_port() and del_port() operations access many device resources.
It could be used even before resources are allocated or initialized.
So, new_port() and del_port() should be allowed to use after resources
are initialized. But sriov_numvfs() doesn't use uninitialized resource
so it doesn't make any problem.

If a simple flag variable is used, we can avoid using a trylock.
The flag is set after resources are initialized.
So if new_port() and del_port() check the flag, it doesn't access
uninitialized resources.

I would like to try to avoid using trylock.

> Also does nsim_bus_exit() really need to iterate over devices to remove
> them? Does core not do it for us?

I couldn't find the logic, which remove devices.
So I think it's needed.

Thank you!
Taehee Yoo
