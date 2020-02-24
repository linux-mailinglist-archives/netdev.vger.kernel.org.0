Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB3D716AE38
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 18:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgBXR4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 12:56:16 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:33607 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbgBXR4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 12:56:15 -0500
Received: by mail-oi1-f194.google.com with SMTP id q81so9818079oig.0;
        Mon, 24 Feb 2020 09:56:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YIkdD31bYp03upGvFS6JQiE90wpfUQKAjIeFAC5gg5U=;
        b=CeKApxK+gyenHAfGaVsHA8s4L8mN/9EF5ldvBGNmwjaepltE5w+Eah79hJoi8IZggo
         mJJLseNRfgAV18BgzZJMKtPsotD7DslaeRyvCsxJLCqcpyHzU4Dbhoywio8TxZaz+Okg
         4el9ZaiKuJcZA6daho4JJBKTzn2NB2MvjkrpCySPRi/VspfJR4HeLMC1ifr76Y5gDfVz
         QV0VUR5sRIUPUikuCO+9Lif2TKiIliiKtUUhlY5GtQMGpRpwIbPddTlWo9q6kP5cUT5G
         nwlWowvIucBO57ZqkQPQNCHeC8oVbgGpWojgW3eqG7PZtJ/QkpcO16Dv1obiqZjA3Vw/
         5vfQ==
X-Gm-Message-State: APjAAAWmo7WBsg2FItdbbNW7A4zIPfOPm1upi+DLhH7rkztmjBzYpGdk
        2BhVvcv+kVHi6wkT/S2WNOYQni2kGvAm+ZHvu88=
X-Google-Smtp-Source: APXvYqwkZyLoQysqRPUYbaGABE/a7gGjukUY/U2cDRw3W7lwKCfYD1fdCwMfodOKZda7l3h4WxMqo9fbfaGQfqXPmQA=
X-Received: by 2002:a54:4e96:: with SMTP id c22mr231243oiy.110.1582566975064;
 Mon, 24 Feb 2020 09:56:15 -0800 (PST)
MIME-Version: 1.0
References: <20200224172110.4121492-1-christian.brauner@ubuntu.com> <20200224172110.4121492-7-christian.brauner@ubuntu.com>
In-Reply-To: <20200224172110.4121492-7-christian.brauner@ubuntu.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 24 Feb 2020 18:56:03 +0100
Message-ID: <CAJZ5v0gDuP33TFNocsSgTD4QFQTQeczwWUXegU2GDzMAFq5Vvg@mail.gmail.com>
Subject: Re: [PATCH v4 6/9] drivers/base/power: add dpm_sysfs_change_owner()
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

On Mon, Feb 24, 2020 at 6:21 PM Christian Brauner
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
>
> /* v4 */
> - "Rafael J. Wysocki" <rafael@kernel.org>:
>    - Remove in-function #ifdef in favor of separate helper that is a nop
>      whenver !CONFIG_PM_SLEEP.
> ---
>  drivers/base/core.c        |  4 +++
>  drivers/base/power/power.h |  3 ++
>  drivers/base/power/sysfs.c | 61 +++++++++++++++++++++++++++++++++++++-
>  3 files changed, 67 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 988f34ce2eb0..fb8b7990f6fd 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -3552,6 +3552,10 @@ int device_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
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
> index d7d82db2e4bc..d2955784d98d 100644
> --- a/drivers/base/power/sysfs.c
> +++ b/drivers/base/power/sysfs.c
> @@ -480,6 +480,20 @@ static ssize_t wakeup_last_time_ms_show(struct device *dev,
>         return enabled ? sprintf(buf, "%lld\n", msec) : sprintf(buf, "\n");
>  }
>
> +static int dpm_sysfs_wakeup_change_owner(struct device *dev, kuid_t kuid,
> +                                        kgid_t kgid)
> +{
> +       int rc = 0;
> +
> +       if (dev->power.wakeup && dev->power.wakeup->dev) {
> +               rc = device_change_owner(dev->power.wakeup->dev, kuid, kgid);
> +               if (rc)
> +                       return rc;
> +       }
> +
> +       return rc;

Why not to do

if (dev->power.wakeup && dev->power.wakeup->dev)
        return device_change_owner(dev->power.wakeup->dev, kuid, kgid);

return 0;

here instead?

> +}
> +
>  static DEVICE_ATTR_RO(wakeup_last_time_ms);
>
>  #ifdef CONFIG_PM_AUTOSLEEP
> @@ -501,7 +515,13 @@ static ssize_t wakeup_prevent_sleep_time_ms_show(struct device *dev,
>
>  static DEVICE_ATTR_RO(wakeup_prevent_sleep_time_ms);
>  #endif /* CONFIG_PM_AUTOSLEEP */
> -#endif /* CONFIG_PM_SLEEP */
> +#else /* CONFIG_PM_SLEEP */
> +static inline int dpm_sysfs_wakeup_change_owner(struct device *dev, kuid_t kuid,
> +                                               kgid_t kgid)
> +{
> +       return 0;
> +}
> +#endif
>
>  #ifdef CONFIG_PM_ADVANCED_DEBUG
>  static ssize_t runtime_usage_show(struct device *dev,
> @@ -684,6 +704,45 @@ int dpm_sysfs_add(struct device *dev)
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
> +
> +       if (device_can_wakeup(dev)) {
> +               rc = sysfs_group_change_owner(&dev->kobj, &pm_wakeup_attr_group,
> +                                             kuid, kgid);
> +               if (rc)
> +                       return rc;
> +
> +               rc = dpm_sysfs_wakeup_change_owner(dev, kuid, kgid);
> +               if (rc)
> +                       return rc;
> +       }
> +
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
> 2.25.1
>
