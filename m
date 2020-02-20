Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0606C165B0D
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 11:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgBTKCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 05:02:17 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:33436 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbgBTKCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 05:02:17 -0500
Received: by mail-oi1-f193.google.com with SMTP id q81so27012251oig.0;
        Thu, 20 Feb 2020 02:02:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jBIymrbfBl+v7nPPWD0/CAEzGIYciT+Z8FHLl9X2EUc=;
        b=XnIRNuKkimWKqSKjSt80NFwKrHfxswsPfrUHmZB4nMHzCDZKqVRWJpxAKIm9deHIJ5
         RBlMmhe69LJXEipStTgDTUKVLXevbibAtXe99hU4MGTjEjz288aUWCHaGzSBeBm6LAyB
         Zg2R4FC5ZpzY+zipQ4vHUV2Rg549Z/lO9h4jrKrcgxaEt5zwBgPmWhPowxlFHlSJEhr2
         XCv9YDbPr6YFXRfp1Yi1eSgPvkLdLxg8FGPtIPNT70NeH96gVpIzabWyh8bx3r0qNJIr
         hi67RuSxiopL9hEBjhv5GO2BFGC1buV1E+RbQBVYLQx3fcT2PLnGGZ+6gcqHB/+BP0a5
         nPSw==
X-Gm-Message-State: APjAAAX8TqLU0mGCv0SbIL8sloJBlNolAsDXPq7awkCY44LK/g5+lFXK
        qmXV+6Tniukl3rzTY+YZAKmJ/6/sYK1r3f3DrH4=
X-Google-Smtp-Source: APXvYqxnbQilW4iMMvtajv6GT4Exg1xYmHrKUsTKPPxEke+F68s4JqLngeQF4aZcmLr6rDaXsWXHxB3VKBU07slHupM=
X-Received: by 2002:a05:6808:8e1:: with SMTP id d1mr1369120oic.68.1582192935803;
 Thu, 20 Feb 2020 02:02:15 -0800 (PST)
MIME-Version: 1.0
References: <20200218162943.2488012-1-christian.brauner@ubuntu.com> <20200218162943.2488012-7-christian.brauner@ubuntu.com>
In-Reply-To: <20200218162943.2488012-7-christian.brauner@ubuntu.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 20 Feb 2020 11:02:04 +0100
Message-ID: <CAJZ5v0hJwXH8Oc4spzDDemHhBVGKqtbrV2UG6-gmT-F0hA4ynA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 6/9] drivers/base/power: add dpm_sysfs_change_owner()
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Linux PM <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 5:30 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> Add a helper to change the owner of a device's power entries. This
> needs to happen when the ownership of a device is changed, e.g. when
> moving network devices between network namespaces.
> This function will be used to correctly account for ownership changes,
> e.g. when moving network devices between network namespaces.
>
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
> /* v2 */
> - "Rafael J. Wysocki" <rafael@kernel.org>:
>   -  Fold if (dev->power.wakeup && dev->power.wakeup->dev) check into
>      if (device_can_wakeup(dev)) check since the former can never be true if
>      the latter is false.
>
> - Christian Brauner <christian.brauner@ubuntu.com>:
>   - Place (dev->power.wakeup && dev->power.wakeup->dev) check under
>     CONFIG_PM_SLEEP ifdefine since it will wakeup_source will only be available
>     when this config option is set.
>
> /* v3 */
> -  Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
>    - Add explicit uid/gid parameters.
> ---
>  drivers/base/core.c        |  4 ++++
>  drivers/base/power/power.h |  3 +++
>  drivers/base/power/sysfs.c | 42 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 49 insertions(+)
>
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index ec0d5e8cfd0f..efec2792f5d7 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -3522,6 +3522,10 @@ int device_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
>         if (error)
>                 goto out;
>
> +       error = dpm_sysfs_change_owner(dev, kuid, kgid);
> +       if (error)
> +               goto out;
> +
>  #ifdef CONFIG_BLOCK
>         if (sysfs_deprecated && dev->class == &block_class)
>                 goto out;
> diff --git a/drivers/base/power/power.h b/drivers/base/power/power.h
> index 444f5c169a0b..54292cdd7808 100644
> --- a/drivers/base/power/power.h
> +++ b/drivers/base/power/power.h
> @@ -74,6 +74,7 @@ extern int pm_qos_sysfs_add_flags(struct device *dev);
>  extern void pm_qos_sysfs_remove_flags(struct device *dev);
>  extern int pm_qos_sysfs_add_latency_tolerance(struct device *dev);
>  extern void pm_qos_sysfs_remove_latency_tolerance(struct device *dev);
> +extern int dpm_sysfs_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid);
>
>  #else /* CONFIG_PM */
>
> @@ -88,6 +89,8 @@ static inline void pm_runtime_remove(struct device *dev) {}
>
>  static inline int dpm_sysfs_add(struct device *dev) { return 0; }
>  static inline void dpm_sysfs_remove(struct device *dev) {}
> +static inline int dpm_sysfs_change_owner(struct device *dev, kuid_t kuid,
> +                                        kgid_t kgid) { return 0; }
>
>  #endif
>
> diff --git a/drivers/base/power/sysfs.c b/drivers/base/power/sysfs.c
> index d7d82db2e4bc..4e79afcd5ca8 100644
> --- a/drivers/base/power/sysfs.c
> +++ b/drivers/base/power/sysfs.c
> @@ -684,6 +684,48 @@ int dpm_sysfs_add(struct device *dev)
>         return rc;
>  }
>
> +int dpm_sysfs_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
> +{
> +       int rc;
> +
> +       if (device_pm_not_required(dev))
> +               return 0;
> +
> +       rc = sysfs_group_change_owner(&dev->kobj, &pm_attr_group, kuid, kgid);
> +       if (rc)
> +               return rc;
> +
> +       if (pm_runtime_callbacks_present(dev)) {
> +               rc = sysfs_group_change_owner(
> +                       &dev->kobj, &pm_runtime_attr_group, kuid, kgid);
> +               if (rc)
> +                       return rc;
> +       }
> +       if (device_can_wakeup(dev)) {
> +               rc = sysfs_group_change_owner(&dev->kobj, &pm_wakeup_attr_group,
> +                                             kuid, kgid);
> +               if (rc)
> +                       return rc;
> +
> +#ifdef CONFIG_PM_SLEEP
> +               if (dev->power.wakeup && dev->power.wakeup->dev) {
> +                       rc = device_change_owner(dev->power.wakeup->dev, kuid,
> +                                                kgid);
> +                       if (rc)
> +                               return rc;
> +               }
> +#endif

First off, I don't particularly like #ifdefs in function bodies.  In
particular, there is a CONFIG_PM_SLEEP block in this file already and
you could define a new function in there to carry out the above
operations, and provide an empty stub of it for the "unset" case.
Failing to do so is somewhat on the "rushing things in" side in my
view.

Second, the #ifdef should cover the entire if (device_can_wakeup(dev))
{} block, because wakeup_sysfs_add() is only called if
device_can_wakeup(dev) returns 'true' for the device in question (and
arguably you could have checked that easily enough).

> +       }
> +       if (dev->power.set_latency_tolerance) {
> +               rc = sysfs_group_change_owner(
> +                       &dev->kobj, &pm_qos_latency_tolerance_attr_group, kuid,
> +                       kgid);
> +               if (rc)
> +                       return rc;
> +       }
> +       return 0;
> +}
> +
>  int wakeup_sysfs_add(struct device *dev)
>  {
>         return sysfs_merge_group(&dev->kobj, &pm_wakeup_attr_group);
> --
> 2.25.0
>
