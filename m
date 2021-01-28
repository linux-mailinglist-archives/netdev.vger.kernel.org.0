Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB58307E0E
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 19:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbhA1SdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 13:33:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbhA1Sbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 13:31:33 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FAEC061788
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 10:30:52 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id e22so6601478iog.6
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 10:30:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/ssG5ilxLcIqrQeGOX/tFBOSj//l42P0daz7BnDb9Lw=;
        b=Jdql+6giql5+GiUkEJc8Uk8ZuHeMMEV6P+GCassKLsEwTYcqZaYUkWZT6Oi4lM96C0
         uw3aHMO1LwB7VeRBz3SPy6RHbt9mYL10C3SGgie3Hf57gXWpJnqbgMkZSMFyOF9qegjI
         KRINycRboVgIknPOb81inPjjL6dTRqWqYWFtcvwm2HUpkCu3xyodcKfQHDD1bHSSsSCW
         pilt2ZPcnZSTiyM5tGyREi6S2inZfBypBjm2bdjXo5Mbvrbe0JBtUGVaQUqvEXhruZAH
         tjauZKXqpEZFPPLCEmqIcqZ2aBMO9EfDWKxhDoRGYcqysaLQrwOVPB57nEPrGjLai3it
         sEjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/ssG5ilxLcIqrQeGOX/tFBOSj//l42P0daz7BnDb9Lw=;
        b=b69oUO3YzsLXBYwkUuL3/pAY+jSh0R83Pe77W0o7rZScDBjevmL6GtBFFESLPjoXQK
         +D/1d4sbP0x5hC470eE9SyqI6gE1udTKvXqltnUN/z8rSRI6FV/X+CETHOpuc9++mA/V
         Nt/eStLzRtPULklXneRtdQ6uM7CqPejrMhoOMKJflb8Jv61eqK4ZKtiFk3TlZvbiAig0
         y1q2Hn+bM4wjRFl4CivTmy9EkodoMl5ZcCgPIaQ2E2kZsfM0VkMJDPMFHvnsBMaPLwL8
         tniMViTpMlYgLVLVwfVxUd1rUBYVBS4qqGuDn5tg0JYPt2WTWaoFfz6mhKVpTDGYZERz
         +Dcg==
X-Gm-Message-State: AOAM530YCkWIsxishsOsQv79wxoraMjQhM0PgNgW6qX7wtBXpT4i02In
        uLJNTc8pPfryvpuV667KV46cthxvZ4YFYqvfkNk=
X-Google-Smtp-Source: ABdhPJzg58C0o8nQV1w82E9AqMMwVkA9OaCoAl1bYIC81FbZ+dtWqE0LfdBSRJ1ukZXkoOtBKgbTm2U8hLl2vo4rg6A=
X-Received: by 2002:a02:5889:: with SMTP id f131mr486310jab.121.1611858651681;
 Thu, 28 Jan 2021 10:30:51 -0800 (PST)
MIME-Version: 1.0
References: <20210128144405.4157244-1-atenart@kernel.org> <20210128144405.4157244-4-atenart@kernel.org>
In-Reply-To: <20210128144405.4157244-4-atenart@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 28 Jan 2021 10:30:40 -0800
Message-ID: <CAKgT0UcXgAZUt+2N=dsrenGpyKmemxGRLOz3HS7OShzgK9jY5Q@mail.gmail.com>
Subject: Re: [PATCH net-next 03/11] net-sysfs: move the xps cpus/rxqs
 retrieval in a common function
To:     Antoine Tenart <atenart@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 6:44 AM Antoine Tenart <atenart@kernel.org> wrote:
>
> Most of the xps_cpus_show and xps_rxqs_show functions share the same
> logic. Having it in two different functions does not help maintenance
> and we can already see small implementation differences. This should not
> be the case and this patch moves their common logic into a new function,
> xps_queue_show, to improve maintenance.
>
> While the rtnl lock could be held in the new xps_queue_show, it is still
> held in xps_cpus_show and xps_rxqs_show as this is an important
> information when looking at those two functions. This does not add
> complexity.
>
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> ---
>  net/core/net-sysfs.c | 168 ++++++++++++++++++++-----------------------
>  1 file changed, 79 insertions(+), 89 deletions(-)
>
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index 5a39e9b38e5f..6e6bc05181f6 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -1314,77 +1314,98 @@ static const struct attribute_group dql_group = {
>  #endif /* CONFIG_BQL */
>
>  #ifdef CONFIG_XPS
> -static ssize_t xps_cpus_show(struct netdev_queue *queue,
> -                            char *buf)
> +/* Should be called with the rtnl lock held. */
> +static int xps_queue_show(struct net_device *dev, unsigned long **mask,
> +                         unsigned int index, bool is_rxqs_map)
>  {
> -       int cpu, len, ret, num_tc = 1, tc = 0;
> -       struct net_device *dev = queue->dev;
> +       const unsigned long *possible_mask = NULL;
> +       int j, num_tc = 0, tc = 0, ret = 0;
>         struct xps_dev_maps *dev_maps;
> -       unsigned long *mask;
> -       unsigned int index;
> -
> -       if (!netif_is_multiqueue(dev))
> -               return -ENOENT;
> -
> -       index = get_netdev_queue_index(queue);
> -
> -       if (!rtnl_trylock())
> -               return restart_syscall();
> +       unsigned int nr_ids;
>
>         if (dev->num_tc) {
>                 /* Do not allow XPS on subordinate device directly */
>                 num_tc = dev->num_tc;
> -               if (num_tc < 0) {
> -                       ret = -EINVAL;
> -                       goto err_rtnl_unlock;
> -               }
> +               if (num_tc < 0)
> +                       return -EINVAL;
>
>                 /* If queue belongs to subordinate dev use its map */
>                 dev = netdev_get_tx_queue(dev, index)->sb_dev ? : dev;
>
>                 tc = netdev_txq_to_tc(dev, index);
> -               if (tc < 0) {
> -                       ret = -EINVAL;
> -                       goto err_rtnl_unlock;
> -               }
> +               if (tc < 0)
> +                       return -EINVAL;
>         }
>
> -       mask = bitmap_zalloc(nr_cpu_ids, GFP_KERNEL);
> -       if (!mask) {
> -               ret = -ENOMEM;
> -               goto err_rtnl_unlock;
> +       rcu_read_lock();
> +
> +       if (is_rxqs_map) {
> +               dev_maps = rcu_dereference(dev->xps_rxqs_map);
> +               nr_ids = dev->num_rx_queues;
> +       } else {
> +               dev_maps = rcu_dereference(dev->xps_cpus_map);
> +               nr_ids = nr_cpu_ids;
> +               if (num_possible_cpus() > 1)
> +                       possible_mask = cpumask_bits(cpu_possible_mask);
>         }

I was good with what we had up until this point. THe issue is we are
allocating the nr_ids for the bitmap in one location, and then
populating it here.

In order to keep this consisten we would need to either hold the
rtnl_lock in the case of the number of Rx queues, or we would need to
call cpus_read_lock in order to prevent the number of CPUs from
changing. It may be better to look at encoding the number of IDs into
the map first, and then using that value. Otherwise we need to be
holding the appropriate lock or passing the number of IDs ourselves as
an argument.

Also we can just drop the possible_mask. No point in carrying it and
it will simplify the loop below as we shouldn't have added the CPU if
it wasn't possible to access it.

> +       if (!dev_maps)
> +               goto rcu_unlock;
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
> -                                       set_bit(cpu, mask);
> -                                       break;
> -                               }
> +       for (j = -1; j = netif_attrmask_next(j, possible_mask, nr_ids),
> +            j < nr_ids;) {

I would drop the mask check and just work from 0 to nr_ids - 1.

> +               int i, tci = j * num_tc + tc;
> +               struct xps_map *map;
> +
> +               map = rcu_dereference(dev_maps->attr_map[tci]);
> +               if (!map)
> +                       continue;
> +
> +               for (i = map->len; i--;) {
> +                       if (map->queues[i] == index) {
> +                               set_bit(j, *mask);
> +                               break;
>                         }
>                 }
>         }
> +
> +rcu_unlock:
>         rcu_read_unlock();
>
> +       return ret;
> +}
> +
> +static ssize_t xps_cpus_show(struct netdev_queue *queue, char *buf)
> +{
> +       struct net_device *dev = queue->dev;
> +       unsigned long *mask;
> +       unsigned int index;
> +       int len, ret;
> +
> +       if (!netif_is_multiqueue(dev))
> +               return -ENOENT;
> +
> +       index = get_netdev_queue_index(queue);
> +
> +       mask = bitmap_zalloc(nr_cpu_ids, GFP_KERNEL);

The nr_cpu_ids could change from this read to the one in the
xps_queue_show function. We should either wrap this in a READ_ONCE and
use a local variable to track the nr_ids or we need to wrap this in
cpus_read_lock.

> +       if (!mask)
> +               return -ENOMEM;
> +
> +       if (!rtnl_trylock()) {
> +               bitmap_free(mask);
> +               return restart_syscall();
> +       }
> +
> +       ret = xps_queue_show(dev, &mask, index, false);
>         rtnl_unlock();
>
> +       if (ret) {
> +               bitmap_free(mask);
> +               return ret;
> +       }
> +
>         len = bitmap_print_to_pagebuf(false, buf, mask, nr_cpu_ids);
>         bitmap_free(mask);
>         return len < PAGE_SIZE ? len : -EINVAL;
> -
> -err_rtnl_unlock:
> -       rtnl_unlock();
> -       return ret;
>  }
>
>  static ssize_t xps_cpus_store(struct netdev_queue *queue,
> @@ -1430,65 +1451,34 @@ static struct netdev_queue_attribute xps_cpus_attribute __ro_after_init
>
>  static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
>  {
> -       int j, len, ret, num_tc = 1, tc = 0;
>         struct net_device *dev = queue->dev;
> -       struct xps_dev_maps *dev_maps;
>         unsigned long *mask;
>         unsigned int index;
> +       int len, ret;
>
>         index = get_netdev_queue_index(queue);
>
> -       if (!rtnl_trylock())
> -               return restart_syscall();
> -
> -       if (dev->num_tc) {
> -               num_tc = dev->num_tc;
> -               tc = netdev_txq_to_tc(dev, index);
> -               if (tc < 0) {
> -                       ret = -EINVAL;
> -                       goto err_rtnl_unlock;
> -               }
> -       }
>         mask = bitmap_zalloc(dev->num_rx_queues, GFP_KERNEL);

The dev->num_rx_queues could change without the rtnl lock being held.
As such we should either use a READ_ONCE or we need to encapsulate the
entire thing in an rtnl_lock.

> -       if (!mask) {
> -               ret = -ENOMEM;
> -               goto err_rtnl_unlock;
> -       }
> -
> -       rcu_read_lock();
> -       dev_maps = rcu_dereference(dev->xps_rxqs_map);
> -       if (!dev_maps)
> -               goto out_no_maps;
> -
> -       for (j = -1; j = netif_attrmask_next(j, NULL, dev->num_rx_queues),
> -            j < dev->num_rx_queues;) {
> -               int i, tci = j * num_tc + tc;
> -               struct xps_map *map;
> -
> -               map = rcu_dereference(dev_maps->attr_map[tci]);
> -               if (!map)
> -                       continue;
> +       if (!mask)
> +               return -ENOMEM;
>
> -               for (i = map->len; i--;) {
> -                       if (map->queues[i] == index) {
> -                               set_bit(j, mask);
> -                               break;
> -                       }
> -               }
> +       if (!rtnl_trylock()) {
> +               bitmap_free(mask);
> +               return restart_syscall();
>         }
> -out_no_maps:
> -       rcu_read_unlock();
>
> +       ret = xps_queue_show(dev, &mask, index, true);
>         rtnl_unlock();
>
> +       if (ret) {
> +               bitmap_free(mask);
> +               return ret;
> +       }
> +
>         len = bitmap_print_to_pagebuf(false, buf, mask, dev->num_rx_queues);
>         bitmap_free(mask);
>
>         return len < PAGE_SIZE ? len : -EINVAL;
> -
> -err_rtnl_unlock:
> -       rtnl_unlock();
> -       return ret;
>  }
>
>  static ssize_t xps_rxqs_store(struct netdev_queue *queue, const char *buf,
> --
> 2.29.2
>
