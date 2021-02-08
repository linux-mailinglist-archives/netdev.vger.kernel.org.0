Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0393142C6
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 23:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhBHWWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 17:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbhBHWVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 17:21:51 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA349C061788
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 14:21:10 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id m20so14301484ilj.13
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 14:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HA2/imsxse4+Wvfox3XugjZfAuFpdA1Zz1Po5JcNkf8=;
        b=kuHWevKVQ5uQs6/PaYf7m99CJuGUt/t0sf6LRl8S310BzRqS8fbtyxFM/kY6tNa0Br
         2mMUQhrkEwaftOItzVmIc+uyIj3+5QPw6VkXwULkYvMzZSqHh1GI2gDvchvuCEfR4eAc
         v9p+YpHeeWa+Cc6N3ck+IbDXGp3nqxAbb7i7AmPH6SGD8NhJFXbppLsXwZ/zr6m92OtE
         G2SlDL2UoH1e+7npeYiyNi/znmtEWPnqo9Wy6rBtLS6x3z+y/eFY94/I60hT944PC0km
         Eg7mcCjdTjQ2l+jalBBgP6GyBCxA8Lut93J7YPjTnCQ3QH7w+LNkCZ4QKIgH5tnwoKzE
         QGnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HA2/imsxse4+Wvfox3XugjZfAuFpdA1Zz1Po5JcNkf8=;
        b=F6+/b0yni6mbhcO2uNJytbhdgw+E6I/bKH/5krEAwW3KoEz6Ceb+GCaJyOyzg7ZpWS
         p2TM9Fy34g88DnGFZ5C8mKUuvMMvewS31CdY8wzfxePmMiOT7rc+DfnQ3pkgcd82jB/2
         mmfvw9GZXtetHPlq8ddUY3j+QMexP3LuPeDftMN7tFvGCXz1hYpHezzZyxTUSMEDBGAt
         LseePub5U8xTjlWrOs1SS8l1WWs2/8VaV54CEqFb0OVM8Jo0dICvaUmsCjnQxl0hvCqf
         pbOvTdiVI7pgWDbEYvHlmAGTAvaZyWg7rxPL02AF8Pvul3etNCZtFwcFgr2iJsh8z0R8
         uu0g==
X-Gm-Message-State: AOAM532TJmnD9Nbyp3ALGMd9+SItKqEump+3t1Y+McSlJaXWWrLnXF4p
        zqZRDh6grAiKlNwHP5XSX5JhfjXEX+dWFFvh2wBDun9//Dc=
X-Google-Smtp-Source: ABdhPJwpOQLGS5RhV6XBVXBHy5R0MJgNBpYPdXg04WaLHrHZYgFjCWVi7hAOc9dqNM0twiv9FbYqZ7TkP6RCNjncpyc=
X-Received: by 2002:a05:6e02:2196:: with SMTP id j22mr17410953ila.64.1612822870054;
 Mon, 08 Feb 2021 14:21:10 -0800 (PST)
MIME-Version: 1.0
References: <20210208171917.1088230-1-atenart@kernel.org> <20210208171917.1088230-10-atenart@kernel.org>
In-Reply-To: <20210208171917.1088230-10-atenart@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 8 Feb 2021 14:20:58 -0800
Message-ID: <CAKgT0Uc3TePxDd12MQiWtkUmtjnd4CAsrN2U49R1p7wXsvxgRA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 09/12] net-sysfs: remove the rtnl lock when
 accessing the xps maps
To:     Antoine Tenart <atenart@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 8, 2021 at 9:19 AM Antoine Tenart <atenart@kernel.org> wrote:
>
> Now that nr_ids and num_tc are stored in the xps dev_maps, which are RCU
> protected, we do not have the need to protect the xps_cpus_show and
> xps_rxqs_show functions with the rtnl lock.
>
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> ---
>  net/core/net-sysfs.c | 26 ++++----------------------
>  1 file changed, 4 insertions(+), 22 deletions(-)
>
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index c2276b589cfb..6ce5772e799e 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -1328,17 +1328,12 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
>
>         index = get_netdev_queue_index(queue);
>
> -       if (!rtnl_trylock())
> -               return restart_syscall();
> -
>         /* If queue belongs to subordinate dev use its map */
>         dev = netdev_get_tx_queue(dev, index)->sb_dev ? : dev;
>
>         tc = netdev_txq_to_tc(dev, index);
> -       if (tc < 0) {
> -               ret = -EINVAL;
> -               goto err_rtnl_unlock;
> -       }
> +       if (tc < 0)
> +               return -EINVAL;
>
>         rcu_read_lock();
>         dev_maps = rcu_dereference(dev->xps_maps[XPS_CPUS]);

So I think we hit a snag here. The sb_dev pointer is protected by the
rtnl_lock. So I don't think we can release the rtnl_lock until after
we are done with the dev pointer.

Also I am not sure it is safe to use netdev_txq_to_tc without holding
the lock. I don't know if we ever went through and guaranteed that it
will always work if the lock isn't held since in theory the device
could reprogram all the map values out from under us.

Odds are we should probably fix traffic_class_show as I suspect it
probably also needs to be holding the rtnl_lock to prevent any
possible races. I'll submit a patch for that.

> @@ -1371,16 +1366,12 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
>  out_no_maps:
>         rcu_read_unlock();
>
> -       rtnl_unlock();
> -
>         len = bitmap_print_to_pagebuf(false, buf, mask, nr_ids);
>         bitmap_free(mask);
>         return len < PAGE_SIZE ? len : -EINVAL;
>
>  err_rcu_unlock:
>         rcu_read_unlock();
> -err_rtnl_unlock:
> -       rtnl_unlock();
>         return ret;
>  }
>
> @@ -1435,14 +1426,9 @@ static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
>
>         index = get_netdev_queue_index(queue);
>
> -       if (!rtnl_trylock())
> -               return restart_syscall();
> -
>         tc = netdev_txq_to_tc(dev, index);
> -       if (tc < 0) {
> -               ret = -EINVAL;
> -               goto err_rtnl_unlock;
> -       }
> +       if (tc < 0)
> +               return -EINVAL;
>
>         rcu_read_lock();
>         dev_maps = rcu_dereference(dev->xps_maps[XPS_RXQS]);
> @@ -1475,8 +1461,6 @@ static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
>  out_no_maps:
>         rcu_read_unlock();
>
> -       rtnl_unlock();
> -
>         len = bitmap_print_to_pagebuf(false, buf, mask, nr_ids);
>         bitmap_free(mask);
>
> @@ -1484,8 +1468,6 @@ static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
>
>  err_rcu_unlock:
>         rcu_read_unlock();
> -err_rtnl_unlock:
> -       rtnl_unlock();
>         return ret;
>  }
>
> --
> 2.29.2
>
