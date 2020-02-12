Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C81EC15A708
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 11:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgBLKxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 05:53:01 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39519 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgBLKxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 05:53:00 -0500
Received: by mail-ot1-f67.google.com with SMTP id 77so1457615oty.6;
        Wed, 12 Feb 2020 02:53:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xDaTG9CjFB5v08pxicGCnpkVMw06DjcCCmv/DeDv44U=;
        b=HIUS7iAUkK28kZCD5AEONCrJZT4uY97mXLftnxlSbHOR7DsnTiwn/K6IvMSpN/3qJi
         KpQZCBxOirR1XFrPnRkJ9xAMMqC7uiXJWywNvp8tIyPNIhXtR4TvacHNK+qOPtge86jU
         EPlQLUV8Se+oNvdXBvoMcquEeP5dLmKVYHpFUTPap0ZAzfq3W1EuRVfkuPYS140V0Z7l
         uuqRpNBFQs0RChDrCeY37lCTgf2aSHGyRcZXNybu9/6KWC0vYmMTZ1g+oatetAt9GHjW
         nMkYBHQdiZcQKpnhddFalnmTsHS5EXZPQXVUing/IyS1WpG8uvqLo+F6f18XReRHx0WV
         ItcQ==
X-Gm-Message-State: APjAAAVzqH1JOnGkAp+xEVtEwq1mfXqwKfCgwKSmWEXWun4ImdoxGHei
        565V2gWgelr6MbF/db2NhvSFWuQU5tGy+HXVghPd54yk
X-Google-Smtp-Source: APXvYqwlBWTrC37R7VTa9EjcJ61LqHAjx4orj3e8146ySRFGC3hM/aolrQr5MVazU5TX6FEIW3dTsCxbWszSxvggp/s=
X-Received: by 2002:a05:6830:1651:: with SMTP id h17mr8361894otr.167.1581504779738;
 Wed, 12 Feb 2020 02:52:59 -0800 (PST)
MIME-Version: 1.0
References: <20200212104321.43570-1-christian.brauner@ubuntu.com> <20200212104321.43570-8-christian.brauner@ubuntu.com>
In-Reply-To: <20200212104321.43570-8-christian.brauner@ubuntu.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 12 Feb 2020 11:52:49 +0100
Message-ID: <CAJZ5v0i+BFg6fEt4UP0vGb=KXBf=iWQcf1cL-2nk-xr=2xZ66w@mail.gmail.com>
Subject: Re: [PATCH net-next 07/10] drivers/base/power: add dpm_sysfs_change_owner()
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

On Wed, Feb 12, 2020 at 11:43 AM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> Add a helper to change the owner of a device's power entries. This
> needs to happen when the ownership of a device is changed, e.g. when
> moving network devices between network namespaces.
> The ownership of a device's power entries is determined based on the
> ownership of the corresponding kobject, i.e. only if the ownership of a
> kobject is changed will this function change the ownership of the
> corresponding sysfs entries.
> This function will be used to correctly account for ownership changes,
> e.g. when moving network devices between network namespaces.
>
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
>  drivers/base/core.c        |  4 ++++
>  drivers/base/power/power.h |  2 ++
>  drivers/base/power/sysfs.c | 37 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 43 insertions(+)
>
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 262217287a09..dfaf6d3614fa 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -3515,6 +3515,10 @@ int device_change_owner(struct device *dev)
>         if (error)
>                 goto out;
>
> +       error = dpm_sysfs_change_owner(dev);
> +       if (error)
> +               goto out;
> +
>  #ifdef CONFIG_BLOCK
>         if (sysfs_deprecated && dev->class == &block_class)
>                 goto out;
> diff --git a/drivers/base/power/power.h b/drivers/base/power/power.h
> index 444f5c169a0b..f68490d0811b 100644
> --- a/drivers/base/power/power.h
> +++ b/drivers/base/power/power.h
> @@ -74,6 +74,7 @@ extern int pm_qos_sysfs_add_flags(struct device *dev);
>  extern void pm_qos_sysfs_remove_flags(struct device *dev);
>  extern int pm_qos_sysfs_add_latency_tolerance(struct device *dev);
>  extern void pm_qos_sysfs_remove_latency_tolerance(struct device *dev);
> +extern int dpm_sysfs_change_owner(struct device *dev);
>
>  #else /* CONFIG_PM */
>
> @@ -88,6 +89,7 @@ static inline void pm_runtime_remove(struct device *dev) {}
>
>  static inline int dpm_sysfs_add(struct device *dev) { return 0; }
>  static inline void dpm_sysfs_remove(struct device *dev) {}
> +static inline int dpm_sysfs_change_owner(struct device *dev) { return 0; }
>
>  #endif
>
> diff --git a/drivers/base/power/sysfs.c b/drivers/base/power/sysfs.c
> index d7d82db2e4bc..ce1fd346e854 100644
> --- a/drivers/base/power/sysfs.c
> +++ b/drivers/base/power/sysfs.c
> @@ -684,6 +684,43 @@ int dpm_sysfs_add(struct device *dev)
>         return rc;
>  }
>
> +int dpm_sysfs_change_owner(struct device *dev)
> +{
> +       int rc;
> +
> +       if (device_pm_not_required(dev))
> +               return 0;
> +
> +       rc = sysfs_group_change_owner(&dev->kobj, &pm_attr_group);
> +       if (rc)
> +               return rc;
> +
> +       if (pm_runtime_callbacks_present(dev)) {
> +               rc = sysfs_group_change_owner(&dev->kobj,
> +                                             &pm_runtime_attr_group);
> +               if (rc)
> +                       return rc;
> +       }
> +       if (device_can_wakeup(dev)) {
> +               rc = sysfs_group_change_owner(&dev->kobj,
> +                                             &pm_wakeup_attr_group);
> +               if (rc)
> +                       return rc;
> +       }
> +       if (dev->power.set_latency_tolerance) {
> +               rc = sysfs_group_change_owner(&dev->kobj,
> +                               &pm_qos_latency_tolerance_attr_group);
> +               if (rc)
> +                       return rc;
> +       }
> +       if (dev->power.wakeup && dev->power.wakeup->dev) {

This is related to the device_can_wakeup(dev) condition above (i.e. it
will never be 'true' if that one is 'false').

LGTM apart from this.

> +               rc = device_change_owner(dev->power.wakeup->dev);
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
