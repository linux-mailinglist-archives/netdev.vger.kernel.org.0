Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2938314DD9B
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 16:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbgA3PJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 10:09:59 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38623 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbgA3PJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 10:09:59 -0500
Received: by mail-lf1-f65.google.com with SMTP id r14so2523475lfm.5
        for <netdev@vger.kernel.org>; Thu, 30 Jan 2020 07:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4h+4OGu1kh8r5D+nWBY6Iqkh5f24yEITwaPsUihYoQM=;
        b=tUKOR4b4pgGF+2VE2u7EDS6RYuvEVwdqIi9VoY8PMT3czyMUqu5kASIXiVs2Ul3QiE
         FktJIWtoWm4MjSFY/LqsZaaOl3D5nc+KpgIzuIdBiZmQt2DNN9zbvGcgCR+s+GjErJq6
         kpbXS374PoHjhfKjXIdigAfSG6m3T+GsZXedUXxSl61KlLCYask2SE1CK2GY6sN5RkXx
         ld0CwZ/pWr6g15xF+ADzSUngj2lV+ISDq0jW+76zXeulYu+yakTvRyA5Eoh0Fmuo5ZTL
         bCPr6HjeRIosyixmJfcmYGtvuTk+URZOIwnYa9yd7CSHtasT1NWwKPSYAVHGEjqicP/g
         nHVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4h+4OGu1kh8r5D+nWBY6Iqkh5f24yEITwaPsUihYoQM=;
        b=DueE2VEJVDsJRBzJXI0HB/b1194G1/haUS+/iAEJ8bte2V2Ml5YR7o7Av2PG7njAMQ
         fD9x/jhP4OaIB4rhVCh/0eJkCjLilaMuo7y23RlofGOL2Ta5iPqHSv2SJsTOdTHJxk12
         ETKxzAVeyYp1w87sOpnvgOxC2w8YNWgF0rp9jNmIwzo7/FAG6r8iJyouRFQihUOkIr76
         HGzi2g6quQuDSKUrlF4iqSc/EFoVMJiH/oKgsMi7UKuS/4EGmz6IAR7lfySqksEVQvQY
         32Zg1hjGYqqFyMnnKXoDf8eQTP6XSdS7LRjUNzLcsJCM/2cVYD9vfndENOjVyKs4rroV
         +J0g==
X-Gm-Message-State: APjAAAVe74vrASjixln1jOnrM6sNrK74FG13VfMbusdI+XSu/TsjLHmO
        j16Dh8T6rM+18tm8k13UFlmec28yFqZUeMESMgo=
X-Google-Smtp-Source: APXvYqwF+tFyzfLuMM2m9Ufk3I3pidW2nbZRq+OtZof3Q8nl9S2vL0bSSYYD2/0bgAKpL+VqCYByaFoAsyCeloDTz0M=
X-Received: by 2002:a19:6d13:: with SMTP id i19mr2758146lfc.6.1580396994862;
 Thu, 30 Jan 2020 07:09:54 -0800 (PST)
MIME-Version: 1.0
References: <20200127142957.1177-1-ap420073@gmail.com> <20200127065755.12cf7eb6@cakuba>
In-Reply-To: <20200127065755.12cf7eb6@cakuba>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Fri, 31 Jan 2020 00:09:43 +0900
Message-ID: <CAMArcTV9bt7SEo2010JBUj3DQAakFmkHD3hWTiMj-0kW+RVXDQ@mail.gmail.com>
Subject: Re: [PATCH net v2 1/6] netdevsim: fix race conditions in netdevsim operations
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jan 2020 at 23:57, Jakub Kicinski <kuba@kernel.org> wrote:
>

Hi Jakub,
Thank you for the review!

> On Mon, 27 Jan 2020 14:29:57 +0000, Taehee Yoo wrote:
> > This patch fixes a several locking problem.
> >
> > 1. netdevsim basic operations(new_device, del_device, new_port,
> > and del_port) are called with sysfs.
> > These operations use the same resource so they should acquire a lock for
> > the whole resource not only for a list.
> > 2. devices are managed by nsim_bus_dev_list. and all devices are deleted
> > in the __exit() routine. After delete routine, new_device() and
> > del_device() should be disallowed. So, the global flag variable 'enable'
> > is added.
> > 3. new_port() and del_port() would be called before resources are
> > allocated or initialized. If so, panic will occur.
> > In order to avoid this scenario, variable 'nsim_bus_dev->init' is added.
>
> > Fixes: f9d9db47d3ba ("netdevsim: add bus attributes to add new and delete devices")
> > Fixes: 794b2c05ca1c ("netdevsim: extend device attrs to support port addition and deletion")
> > Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> > ---
> >
> > v1 -> v2
> >  - Do not use trylock
> >  - Do not include code, which fixes devlink reload problem
> >  - Update Fixes tags
> >  - Update comments
>
> Thank you for the update!
>
> > diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
> > index 6aeed0c600f8..a3205fd73c8f 100644
> > --- a/drivers/net/netdevsim/bus.c
> > +++ b/drivers/net/netdevsim/bus.c
> > @@ -16,7 +16,8 @@
> >
> >  static DEFINE_IDA(nsim_bus_dev_ids);
> >  static LIST_HEAD(nsim_bus_dev_list);
> > -static DEFINE_MUTEX(nsim_bus_dev_list_lock);
> > +static DEFINE_MUTEX(nsim_bus_dev_ops_lock);
> > +static bool enable;
> >
> >  static struct nsim_bus_dev *to_nsim_bus_dev(struct device *dev)
> >  {
> > @@ -99,6 +100,8 @@ new_port_store(struct device *dev, struct device_attribute *attr,
> >       unsigned int port_index;
> >       int ret;
> >
> > +     if (!nsim_bus_dev->init)
> > +             return -EBUSY;
>
> I think we should use the acquire/release semantics on those variables.
> The init should be smp_store_release() and the read in ops should use
> smp_load_acquire().
>

Okay, I will use a barrier for the 'init' variable.
Should a barrier be used for 'enable' variable too?
Although this value is protected by nsim_bus_dev_list_lock,
I didn't use the lock for this value in the nsim_bus_init()
because I thought it's enough.
How do you think about this? Should lock or barrier is needed?

> With that we should be able to move the new variable manipulation out
> of the bus_dev lock section. Having a lock for operations/code is a
> little bit of a bad code trait, as locks should generally protect data.
> The lock could then remain as is just for protecting operations on the
> list.
>

Thank so much for this.
I will keep this trait in mind!

> >       ret = kstrtouint(buf, 0, &port_index);
> >       if (ret)
> >               return ret;
> > @@ -116,6 +119,8 @@ del_port_store(struct device *dev, struct device_attribute *attr,
> >       unsigned int port_index;
> >       int ret;
> >
> > +     if (!nsim_bus_dev->init)
> > +             return -EBUSY;
> >       ret = kstrtouint(buf, 0, &port_index);
> >       if (ret)
> >               return ret;
> > @@ -179,13 +184,21 @@ new_device_store(struct bus_type *bus, const char *buf, size_t count)
> >               pr_err("Format for adding new device is \"id port_count\" (uint uint).\n");
> >               return -EINVAL;
> >       }
> > +     mutex_lock(&nsim_bus_dev_ops_lock);
> > +     if (!enable) {
> > +             mutex_unlock(&nsim_bus_dev_ops_lock);
> > +             return -EBUSY;
> > +     }
> >       nsim_bus_dev = nsim_bus_dev_new(id, port_count);
> > -     if (IS_ERR(nsim_bus_dev))
> > +     if (IS_ERR(nsim_bus_dev)) {
> > +             mutex_unlock(&nsim_bus_dev_ops_lock);
> >               return PTR_ERR(nsim_bus_dev);
> > +     }
> > +
> > +     nsim_bus_dev->init = true;
>
> Not sure it matters but perhaps set it to init after its added to the
> list? Should it also be set to false before remove?
>

Setting the 'init' to true before list ops isn't bad because the list
isn't used in {new/del}_port().
The reason for this is to allow {new/del}_port() as fast as possible.
Setting the 'init' to false before remove isn't necessary because
kernfs internally sync this operation.
But I think it's not good for reading code.
So, I will add this explicit code.

> Thanks again for this work, I'll look at the other patches later today.

Thank you so much for your insight!
Taehee Yoo
