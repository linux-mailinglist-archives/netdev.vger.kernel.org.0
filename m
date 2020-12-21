Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A2C2E0290
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 23:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgLUWeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 17:34:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgLUWeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 17:34:07 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD75C0613D6
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 14:33:26 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id p187so10303277iod.4
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 14:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E2obikvjZeD56fDp6bhqPRNjslT49+GVema1FJjk3+M=;
        b=NmEz2SPeW++PhaiZuMBQ2AL0f01CFyFbihVlAnm8isEJ6cES1847B7+SsEoP7Czc3j
         EZti0iSgSPZSbxJn+/vVHKHFNNtqVk4U7mhGCkSwWKkxU2Qda2DmdqiQTKbKGQEwLAwP
         mN+UZB2fwNu07UuZX2DowzZziEU6TzbJBf5XpE7lMinxADxn0dpoZLDrhR0mWrR3751l
         ytrCWioTnErU1zBb33WRI1uT6vCB+kFjjRVCbAuzYiHiWYBkXWRAy4Uq1VWqBQp7VoHz
         zkF4KUCxg06RVWxBl12TU53SK54MH0s6OvHpX+kizYSIY0NuocHiZx4bp8zlY2P3+/fg
         xtPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E2obikvjZeD56fDp6bhqPRNjslT49+GVema1FJjk3+M=;
        b=qGZGb0xjfJm7+3GB1d/DRXZbqszVxlFTQgXyLR758HhBpYXpDo7BGNUMDXeDpjJBa1
         Z9iTyCcBENjcUF0zZki8hU4Y7/RgdpLa3XSNKWe5u9UF1hrrSK5+l16D+JNfS4vDuQq5
         T2aLS/EVax/KAToManaS5JwejR2siX8k2N9rR1ew332eqG6DQReC4d/hHCSQ/5a5g+Dd
         gMNNRvZulYhsaqs8+KJi48eHuW7gdM+MbtcGtBlBSmOx5xfaPmyH5yCAJ0VoloRWWtSR
         UiUyfTx8MQXQY6nU7yCxYfG2S5I/gNKfNGwEprKKR/SIzEP3aeAXYoVsadHTYPlJF8OT
         6GcA==
X-Gm-Message-State: AOAM5322NFLc1mTIazglXshrh8OVdrAltaLDsiaC+OBdzq9lNRUvSgWW
        pNYsaQq0MJ9YrkX2aYztJ5Ji1sUXrEfPHDtdC1s=
X-Google-Smtp-Source: ABdhPJy0VmoeHPmQG91+AzfMrQotTw6ht+xY7e0Awc3YXz2r7uMr3YsTKJb9PP2k9rZcDGudc+uRj7FwKYB6bkrol4M=
X-Received: by 2002:a5d:9a82:: with SMTP id c2mr15786186iom.38.1608590006229;
 Mon, 21 Dec 2020 14:33:26 -0800 (PST)
MIME-Version: 1.0
References: <20201221193644.1296933-1-atenart@kernel.org> <20201221193644.1296933-3-atenart@kernel.org>
In-Reply-To: <20201221193644.1296933-3-atenart@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 21 Dec 2020 14:33:15 -0800
Message-ID: <CAKgT0UfsRY8zeYwhuy0kaMozTrfs+9RxTtXpyf2iD1Rcb-J52g@mail.gmail.com>
Subject: Re: [PATCH net v2 2/3] net: move the xps cpus retrieval out of net-sysfs
To:     Antoine Tenart <atenart@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 11:36 AM Antoine Tenart <atenart@kernel.org> wrote:
>
> Accesses to dev->xps_cpus_map (when using dev->num_tc) should be
> protected by the xps_map mutex, to avoid possible race conditions when
> dev->num_tc is updated while the map is accessed. This patch moves the
> logic accessing dev->xps_cpu_map and dev->num_tc to net/core/dev.c,
> where the xps_map mutex is defined and used.
>
> Fixes: 184c449f91fe ("net: Add support for XPS with QoS via traffic classes")
> Signed-off-by: Antoine Tenart <atenart@kernel.org>

It is a bit of a shame that we have to use the mutex_lock while just
displaying the table. But we end up needing it if we are going to use
the xps_map_mutex to protect us from the num_tc being updated while we
are reading it.

One thing I might change is to actually bump this patch up in the
patch set as I think it would probably make things a bit cleaner to
read as you are going to be moving the other functions to this pattern
as well.

> ---
>  include/linux/netdevice.h |  8 ++++++
>  net/core/dev.c            | 59 +++++++++++++++++++++++++++++++++++++++
>  net/core/net-sysfs.c      | 54 ++++++++---------------------------
>  3 files changed, 79 insertions(+), 42 deletions(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 259be67644e3..bfd6cfa3ea90 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3671,6 +3671,8 @@ int netif_set_xps_queue(struct net_device *dev, const struct cpumask *mask,
>                         u16 index);
>  int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
>                           u16 index, bool is_rxqs_map);
> +int netif_show_xps_queue(struct net_device *dev, unsigned long **mask,
> +                        u16 index);
>
>  /**
>   *     netif_attr_test_mask - Test a CPU or Rx queue set in a mask
> @@ -3769,6 +3771,12 @@ static inline int __netif_set_xps_queue(struct net_device *dev,
>  {
>         return 0;
>  }
> +
> +static inline int netif_show_xps_queue(struct net_device *dev,
> +                                      unsigned long **mask, u16 index)
> +{
> +       return 0;
> +}
>  #endif
>
>  /**
> diff --git a/net/core/dev.c b/net/core/dev.c
> index effdb7fee9df..a0257da4160a 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -2831,6 +2831,65 @@ int netif_set_xps_queue(struct net_device *dev, const struct cpumask *mask,
>  }
>  EXPORT_SYMBOL(netif_set_xps_queue);
>
> +int netif_show_xps_queue(struct net_device *dev, unsigned long **mask,
> +                        u16 index)
> +{
> +       const unsigned long *possible_mask = NULL;
> +       int j, num_tc = 1, tc = 0, ret = 0;
> +       struct xps_dev_maps *dev_maps;
> +       unsigned int nr_ids;
> +
> +       rcu_read_lock();
> +       mutex_lock(&xps_map_mutex);
> +

So you only need to call mutex_lock here. The rcu_read_lock becomes redundant.

> +       if (dev->num_tc) {
> +               num_tc = dev->num_tc;
> +               if (num_tc < 0) {
> +                       ret = -EINVAL;
> +                       goto out_no_map;
> +               }
> +
> +               /* If queue belongs to subordinate dev use its map */
> +               dev = netdev_get_tx_queue(dev, index)->sb_dev ? : dev;
> +
> +               tc = netdev_txq_to_tc(dev, index);
> +               if (tc < 0) {
> +                       ret = -EINVAL;
> +                       goto out_no_map;
> +               }
> +       }
> +
> +       dev_maps = rcu_dereference(dev->xps_cpus_map);
> +       if (!dev_maps)
> +               goto out_no_map;
> +       nr_ids = nr_cpu_ids;
> +       if (num_possible_cpus() > 1)
> +               possible_mask = cpumask_bits(cpu_possible_mask);
> +
> +       for (j = -1; j = netif_attrmask_next(j, possible_mask, nr_ids),
> +            j < nr_ids;) {
> +               int i, tci = j * num_tc + tc;
> +               struct xps_map *map;
> +
> +               map = rcu_dereference(dev_maps->attr_map[tci]);

For this you can use either rcu_dereference_protected, or you can use
xmap_dereference.

> +               if (!map)
> +                       continue;
> +
> +               for (i = map->len; i--;) {
> +                       if (map->queues[i] == index) {
> +                               set_bit(j, *mask);
> +                               break;
> +                       }
> +               }
> +       }
> +
> +out_no_map:
> +       mutex_unlock(&xps_map_mutex);
> +       rcu_read_unlock();
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL(netif_show_xps_queue);
>  #endif
>
>  static void __netdev_unbind_sb_channel(struct net_device *dev,
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index 999b70c59761..29ee69b67972 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -1314,60 +1314,30 @@ static const struct attribute_group dql_group = {
>  #endif /* CONFIG_BQL */
>
>  #ifdef CONFIG_XPS
> -static ssize_t xps_cpus_show(struct netdev_queue *queue,
> -                            char *buf)
> +static ssize_t xps_cpus_show(struct netdev_queue *queue, char *buf)
>  {
>         struct net_device *dev = queue->dev;
> -       int cpu, len, num_tc = 1, tc = 0;
> -       struct xps_dev_maps *dev_maps;
> -       cpumask_var_t mask;
> -       unsigned long index;
> +       unsigned long *mask, index;
> +       int len, ret;
>
>         if (!netif_is_multiqueue(dev))
>                 return -ENOENT;
>
>         index = get_netdev_queue_index(queue);
>
> -       if (dev->num_tc) {
> -               /* Do not allow XPS on subordinate device directly */
> -               num_tc = dev->num_tc;
> -               if (num_tc < 0)
> -                       return -EINVAL;
> -
> -               /* If queue belongs to subordinate dev use its map */
> -               dev = netdev_get_tx_queue(dev, index)->sb_dev ? : dev;
> -
> -               tc = netdev_txq_to_tc(dev, index);
> -               if (tc < 0)
> -                       return -EINVAL;
> -       }
> -
> -       if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
> +       mask = bitmap_zalloc(nr_cpu_ids, GFP_KERNEL);
> +       if (!mask)
>                 return -ENOMEM;
>
> -       rcu_read_lock();
> -       dev_maps = rcu_dereference(dev->xps_cpus_map);
> -       if (dev_maps) {
> -               for_each_possible_cpu(cpu) {
> -                       int i, tci = cpu * num_tc + tc;
> -                       struct xps_map *map;
> -
> -                       map = rcu_dereference(dev_maps->attr_map[tci]);
> -                       if (!map)
> -                               continue;
> -
> -                       for (i = map->len; i--;) {
> -                               if (map->queues[i] == index) {
> -                                       cpumask_set_cpu(cpu, mask);
> -                                       break;
> -                               }
> -                       }
> -               }
> +       ret = netif_show_xps_queue(dev, &mask, index);
> +       if (ret) {
> +               bitmap_free(mask);
> +               return ret;
>         }
> -       rcu_read_unlock();
>
> -       len = snprintf(buf, PAGE_SIZE, "%*pb\n", cpumask_pr_args(mask));
> -       free_cpumask_var(mask);
> +       len = bitmap_print_to_pagebuf(false, buf, mask, nr_cpu_ids);
> +       bitmap_free(mask);
> +
>         return len < PAGE_SIZE ? len : -EINVAL;
>  }
>
> --
> 2.29.2
>
