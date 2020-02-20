Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43676165B88
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 11:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgBTKao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 05:30:44 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:35422 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbgBTKao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 05:30:44 -0500
Received: by mail-ot1-f67.google.com with SMTP id r16so3194069otd.2;
        Thu, 20 Feb 2020 02:30:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wO6AuiI3EdmqOyIBwgh0qHP3XlZjJrsiTj0RBtDfBq8=;
        b=VOSCq7vWqeAqiYW9P6iKo9iBz7Aygdh7eDJjXJVGRFsgUQcbp3RUX0by+uM+vFvTP5
         W6ZB0dj1jL0RaX70sioIyTKE+mLS32b7anfjjUYlJTfzCIFpT1xclg4Ve0oJBD7gv1Bp
         D7TEeTRyZLcJHoJaTZpV0k30Q7wRx/+zrWCAstmLkPl6+Iq6lqELF0WcegxPMgL4zFA1
         GxxwhBfLw80KYZSS8LZaSDvHv8FIO5LCM9vW8osl0V5Fn534uSawCZggeYVVOlu0S/F2
         i4uF6nIQYuoQGgGlVIbyxijCEvzQa9pR7RaWpM5WF5vvqoS4V370aWqRg51A3Hw0S3UR
         pDSA==
X-Gm-Message-State: APjAAAWrnASxXeYbXHlsI+hhDnzDN0fUIyjnmErytKLbUPGkpeZ8vIJV
        xLp0tq2t0OXhNC9bo+jzXmzsmqz5TzEg0G2Be/Q=
X-Google-Smtp-Source: APXvYqzoNQiMHXsINekY6fRvwCSG2MWfDbUr3Fyn5ZFXqEJMKQeSsMrQOWb3oOXeOZRjssfcvy0Ifs17byzMgZWWz2I=
X-Received: by 2002:a05:6830:4b9:: with SMTP id l25mr1287589otd.266.1582194643319;
 Thu, 20 Feb 2020 02:30:43 -0800 (PST)
MIME-Version: 1.0
References: <20200218162943.2488012-1-christian.brauner@ubuntu.com>
 <20200218162943.2488012-7-christian.brauner@ubuntu.com> <CAJZ5v0hJwXH8Oc4spzDDemHhBVGKqtbrV2UG6-gmT-F0hA4ynA@mail.gmail.com>
 <20200220102107.grkyypt7swrufzas@wittgenstein>
In-Reply-To: <20200220102107.grkyypt7swrufzas@wittgenstein>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 20 Feb 2020 11:30:32 +0100
Message-ID: <CAJZ5v0itDdfdNd6TzLi=2J517CyjEBbKb+K4OfkkSt-B+w9taw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 6/9] drivers/base/power: add dpm_sysfs_change_owner()
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Linux PM <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 11:21 AM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> On Thu, Feb 20, 2020 at 11:02:04AM +0100, Rafael J. Wysocki wrote:
> > On Tue, Feb 18, 2020 at 5:30 PM Christian Brauner
> > <christian.brauner@ubuntu.com> wrote:
> > >
> > > Add a helper to change the owner of a device's power entries. This
> > > needs to happen when the ownership of a device is changed, e.g. when
> > > moving network devices between network namespaces.
> > > This function will be used to correctly account for ownership changes,
> > > e.g. when moving network devices between network namespaces.
> > >
> > > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > > ---
> > > /* v2 */
> > > - "Rafael J. Wysocki" <rafael@kernel.org>:
> > >   -  Fold if (dev->power.wakeup && dev->power.wakeup->dev) check into
> > >      if (device_can_wakeup(dev)) check since the former can never be true if
> > >      the latter is false.
> > >
> > > - Christian Brauner <christian.brauner@ubuntu.com>:
> > >   - Place (dev->power.wakeup && dev->power.wakeup->dev) check under
> > >     CONFIG_PM_SLEEP ifdefine since it will wakeup_source will only be available
> > >     when this config option is set.
> > >
> > > /* v3 */
> > > -  Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> > >    - Add explicit uid/gid parameters.
> > > ---
> > >  drivers/base/core.c        |  4 ++++
> > >  drivers/base/power/power.h |  3 +++
> > >  drivers/base/power/sysfs.c | 42 ++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 49 insertions(+)
> > >
> > > diff --git a/drivers/base/core.c b/drivers/base/core.c
> > > index ec0d5e8cfd0f..efec2792f5d7 100644
> > > --- a/drivers/base/core.c
> > > +++ b/drivers/base/core.c
> > > @@ -3522,6 +3522,10 @@ int device_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
> > >         if (error)
> > >                 goto out;
> > >
> > > +       error = dpm_sysfs_change_owner(dev, kuid, kgid);
> > > +       if (error)
> > > +               goto out;
> > > +
> > >  #ifdef CONFIG_BLOCK
> > >         if (sysfs_deprecated && dev->class == &block_class)
> > >                 goto out;
> > > diff --git a/drivers/base/power/power.h b/drivers/base/power/power.h
> > > index 444f5c169a0b..54292cdd7808 100644
> > > --- a/drivers/base/power/power.h
> > > +++ b/drivers/base/power/power.h
> > > @@ -74,6 +74,7 @@ extern int pm_qos_sysfs_add_flags(struct device *dev);
> > >  extern void pm_qos_sysfs_remove_flags(struct device *dev);
> > >  extern int pm_qos_sysfs_add_latency_tolerance(struct device *dev);
> > >  extern void pm_qos_sysfs_remove_latency_tolerance(struct device *dev);
> > > +extern int dpm_sysfs_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid);
> > >
> > >  #else /* CONFIG_PM */
> > >
> > > @@ -88,6 +89,8 @@ static inline void pm_runtime_remove(struct device *dev) {}
> > >
> > >  static inline int dpm_sysfs_add(struct device *dev) { return 0; }
> > >  static inline void dpm_sysfs_remove(struct device *dev) {}
> > > +static inline int dpm_sysfs_change_owner(struct device *dev, kuid_t kuid,
> > > +                                        kgid_t kgid) { return 0; }
> > >
> > >  #endif
> > >
> > > diff --git a/drivers/base/power/sysfs.c b/drivers/base/power/sysfs.c
> > > index d7d82db2e4bc..4e79afcd5ca8 100644
> > > --- a/drivers/base/power/sysfs.c
> > > +++ b/drivers/base/power/sysfs.c
> > > @@ -684,6 +684,48 @@ int dpm_sysfs_add(struct device *dev)
> > >         return rc;
> > >  }
> > >
> > > +int dpm_sysfs_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
> > > +{
> > > +       int rc;
> > > +
> > > +       if (device_pm_not_required(dev))
> > > +               return 0;
> > > +
> > > +       rc = sysfs_group_change_owner(&dev->kobj, &pm_attr_group, kuid, kgid);
> > > +       if (rc)
> > > +               return rc;
> > > +
> > > +       if (pm_runtime_callbacks_present(dev)) {
> > > +               rc = sysfs_group_change_owner(
> > > +                       &dev->kobj, &pm_runtime_attr_group, kuid, kgid);
> > > +               if (rc)
> > > +                       return rc;
> > > +       }
> > > +       if (device_can_wakeup(dev)) {
> > > +               rc = sysfs_group_change_owner(&dev->kobj, &pm_wakeup_attr_group,
> > > +                                             kuid, kgid);
> > > +               if (rc)
> > > +                       return rc;
> > > +
> > > +#ifdef CONFIG_PM_SLEEP
> > > +               if (dev->power.wakeup && dev->power.wakeup->dev) {
> > > +                       rc = device_change_owner(dev->power.wakeup->dev, kuid,
> > > +                                                kgid);
> > > +                       if (rc)
> > > +                               return rc;
> > > +               }
> > > +#endif
> >
> > First off, I don't particularly like #ifdefs in function bodies.  In
> > particular, there is a CONFIG_PM_SLEEP block in this file already and
> > you could define a new function in there to carry out the above
> > operations, and provide an empty stub of it for the "unset" case.
> > Failing to do so is somewhat on the "rushing things in" side in my
> > view.
>
> How ifdefines are used is highly dependent on the subsystem; networking
> ofen uses in-place ifdefines in some parts and not in others. That has
> nothing to do with rushing things. I'm happy to change it to your
> preferences.

Thanks!

> Thanks for pointing out your expectations. But please don't
> assume bad intentions on my part because I'm not meeting them right
> away. It often is the case that adding a helper that is called in one
> place is not well-received.

Fair enough, sorry for being harsh.
