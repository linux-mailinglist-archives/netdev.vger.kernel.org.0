Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6783B16AE47
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 19:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbgBXSAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 13:00:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58489 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBXSAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 13:00:25 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j6I1k-0006yQ-US; Mon, 24 Feb 2020 18:00:21 +0000
Date:   Mon, 24 Feb 2020 19:00:20 +0100
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
Subject: Re: [PATCH v4 6/9] drivers/base/power: add dpm_sysfs_change_owner()
Message-ID: <20200224180020.tu4g22rzk6xt3zeo@wittgenstein>
References: <20200224172110.4121492-1-christian.brauner@ubuntu.com>
 <20200224172110.4121492-7-christian.brauner@ubuntu.com>
 <CAJZ5v0gDuP33TFNocsSgTD4QFQTQeczwWUXegU2GDzMAFq5Vvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJZ5v0gDuP33TFNocsSgTD4QFQTQeczwWUXegU2GDzMAFq5Vvg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 06:56:03PM +0100, Rafael J. Wysocki wrote:
> On Mon, Feb 24, 2020 at 6:21 PM Christian Brauner
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
> >
> > /* v4 */
> > - "Rafael J. Wysocki" <rafael@kernel.org>:
> >    - Remove in-function #ifdef in favor of separate helper that is a nop
> >      whenver !CONFIG_PM_SLEEP.
> > ---
> >  drivers/base/core.c        |  4 +++
> >  drivers/base/power/power.h |  3 ++
> >  drivers/base/power/sysfs.c | 61 +++++++++++++++++++++++++++++++++++++-
> >  3 files changed, 67 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/base/core.c b/drivers/base/core.c
> > index 988f34ce2eb0..fb8b7990f6fd 100644
> > --- a/drivers/base/core.c
> > +++ b/drivers/base/core.c
> > @@ -3552,6 +3552,10 @@ int device_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
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
> > index d7d82db2e4bc..d2955784d98d 100644
> > --- a/drivers/base/power/sysfs.c
> > +++ b/drivers/base/power/sysfs.c
> > @@ -480,6 +480,20 @@ static ssize_t wakeup_last_time_ms_show(struct device *dev,
> >         return enabled ? sprintf(buf, "%lld\n", msec) : sprintf(buf, "\n");
> >  }
> >
> > +static int dpm_sysfs_wakeup_change_owner(struct device *dev, kuid_t kuid,
> > +                                        kgid_t kgid)
> > +{
> > +       int rc = 0;
> > +
> > +       if (dev->power.wakeup && dev->power.wakeup->dev) {
> > +               rc = device_change_owner(dev->power.wakeup->dev, kuid, kgid);
> > +               if (rc)
> > +                       return rc;
> > +       }
> > +
> > +       return rc;
> 
> Why not to do
> 
> if (dev->power.wakeup && dev->power.wakeup->dev)
>         return device_change_owner(dev->power.wakeup->dev, kuid, kgid);
> 
> return 0;
> 
> here instead?

Yeah, sure, can do.

Christian
