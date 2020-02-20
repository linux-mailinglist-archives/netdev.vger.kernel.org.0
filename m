Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8575165B5A
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 11:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgBTKVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 05:21:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39028 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbgBTKVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 05:21:15 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j4ixA-00032V-Nu; Thu, 20 Feb 2020 10:21:08 +0000
Date:   Thu, 20 Feb 2020 11:21:07 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Linux PM <linux-pm@vger.kernel.org>
Subject: Re: [PATCH net-next v3 6/9] drivers/base/power: add
 dpm_sysfs_change_owner()
Message-ID: <20200220102107.grkyypt7swrufzas@wittgenstein>
References: <20200218162943.2488012-1-christian.brauner@ubuntu.com>
 <20200218162943.2488012-7-christian.brauner@ubuntu.com>
 <CAJZ5v0hJwXH8Oc4spzDDemHhBVGKqtbrV2UG6-gmT-F0hA4ynA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJZ5v0hJwXH8Oc4spzDDemHhBVGKqtbrV2UG6-gmT-F0hA4ynA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 11:02:04AM +0100, Rafael J. Wysocki wrote:
> On Tue, Feb 18, 2020 at 5:30 PM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> >
> > Add a helper to change the owner of a device's power entries. This
> > needs to happen when the ownership of a device is changed, e.g. when
> > moving network devices between network namespaces.
> > This function will be used to correctly account for ownership changes,
> > e.g. when moving network devices between network namespaces.
> >
> > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > ---
> > /* v2 */
> > - "Rafael J. Wysocki" <rafael@kernel.org>:
> >   -  Fold if (dev->power.wakeup && dev->power.wakeup->dev) check into
> >      if (device_can_wakeup(dev)) check since the former can never be true if
> >      the latter is false.
> >
> > - Christian Brauner <christian.brauner@ubuntu.com>:
> >   - Place (dev->power.wakeup && dev->power.wakeup->dev) check under
> >     CONFIG_PM_SLEEP ifdefine since it will wakeup_source will only be available
> >     when this config option is set.
> >
> > /* v3 */
> > -  Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> >    - Add explicit uid/gid parameters.
> > ---
> >  drivers/base/core.c        |  4 ++++
> >  drivers/base/power/power.h |  3 +++
> >  drivers/base/power/sysfs.c | 42 ++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 49 insertions(+)
> >
> > diff --git a/drivers/base/core.c b/drivers/base/core.c
> > index ec0d5e8cfd0f..efec2792f5d7 100644
> > --- a/drivers/base/core.c
> > +++ b/drivers/base/core.c
> > @@ -3522,6 +3522,10 @@ int device_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
> >         if (error)
> >                 goto out;
> >
> > +       error = dpm_sysfs_change_owner(dev, kuid, kgid);
> > +       if (error)
> > +               goto out;
> > +
> >  #ifdef CONFIG_BLOCK
> >         if (sysfs_deprecated && dev->class == &block_class)
> >                 goto out;
> > diff --git a/drivers/base/power/power.h b/drivers/base/power/power.h
> > index 444f5c169a0b..54292cdd7808 100644
> > --- a/drivers/base/power/power.h
> > +++ b/drivers/base/power/power.h
> > @@ -74,6 +74,7 @@ extern int pm_qos_sysfs_add_flags(struct device *dev);
> >  extern void pm_qos_sysfs_remove_flags(struct device *dev);
> >  extern int pm_qos_sysfs_add_latency_tolerance(struct device *dev);
> >  extern void pm_qos_sysfs_remove_latency_tolerance(struct device *dev);
> > +extern int dpm_sysfs_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid);
> >
> >  #else /* CONFIG_PM */
> >
> > @@ -88,6 +89,8 @@ static inline void pm_runtime_remove(struct device *dev) {}
> >
> >  static inline int dpm_sysfs_add(struct device *dev) { return 0; }
> >  static inline void dpm_sysfs_remove(struct device *dev) {}
> > +static inline int dpm_sysfs_change_owner(struct device *dev, kuid_t kuid,
> > +                                        kgid_t kgid) { return 0; }
> >
> >  #endif
> >
> > diff --git a/drivers/base/power/sysfs.c b/drivers/base/power/sysfs.c
> > index d7d82db2e4bc..4e79afcd5ca8 100644
> > --- a/drivers/base/power/sysfs.c
> > +++ b/drivers/base/power/sysfs.c
> > @@ -684,6 +684,48 @@ int dpm_sysfs_add(struct device *dev)
> >         return rc;
> >  }
> >
> > +int dpm_sysfs_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
> > +{
> > +       int rc;
> > +
> > +       if (device_pm_not_required(dev))
> > +               return 0;
> > +
> > +       rc = sysfs_group_change_owner(&dev->kobj, &pm_attr_group, kuid, kgid);
> > +       if (rc)
> > +               return rc;
> > +
> > +       if (pm_runtime_callbacks_present(dev)) {
> > +               rc = sysfs_group_change_owner(
> > +                       &dev->kobj, &pm_runtime_attr_group, kuid, kgid);
> > +               if (rc)
> > +                       return rc;
> > +       }
> > +       if (device_can_wakeup(dev)) {
> > +               rc = sysfs_group_change_owner(&dev->kobj, &pm_wakeup_attr_group,
> > +                                             kuid, kgid);
> > +               if (rc)
> > +                       return rc;
> > +
> > +#ifdef CONFIG_PM_SLEEP
> > +               if (dev->power.wakeup && dev->power.wakeup->dev) {
> > +                       rc = device_change_owner(dev->power.wakeup->dev, kuid,
> > +                                                kgid);
> > +                       if (rc)
> > +                               return rc;
> > +               }
> > +#endif
> 
> First off, I don't particularly like #ifdefs in function bodies.  In
> particular, there is a CONFIG_PM_SLEEP block in this file already and
> you could define a new function in there to carry out the above
> operations, and provide an empty stub of it for the "unset" case.
> Failing to do so is somewhat on the "rushing things in" side in my
> view.

How ifdefines are used is highly dependent on the subsystem; networking
ofen uses in-place ifdefines in some parts and not in others. That has
nothing to do with rushing things. I'm happy to change it to your
preferences. Thanks for pointing out your expectations. But please don't
assume bad intentions on my part because I'm not meeting them right
away. It often is the case that adding a helper that is called in one
place is not well-received.

> 
> Second, the #ifdef should cover the entire if (device_can_wakeup(dev))
> {} block, because wakeup_sysfs_add() is only called if
> device_can_wakeup(dev) returns 'true' for the device in question (and
> arguably you could have checked that easily enough).

I've looked at the header definitions for device_can_wakeup() and with
and without CONFIG_PM_SLEEP it is defined as:

static inline bool device_can_wakeup(struct device *dev)
{
	return dev->power.can_wakeup;
}

which to me looks like it would neet to be called in all cases.

I'll rework this to you preferences.

Thanks!
Christian
