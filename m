Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541172EC446
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 20:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbhAFTzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 14:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbhAFTzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 14:55:03 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55796C06134C
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 11:54:23 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id m23so3905365ioy.2
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 11:54:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yqxD5DGmQzql6e/bYmAXmjGDIRjOO1l2zM2klhlTIlA=;
        b=q/omerwQ8qY79ZBRsYjuQSBZoN+oeS0RKW0Z3Y1YoqMn+pt5FLGixhv3WWXSjdYVwA
         zz1epxZM5T32pOmk06M0f6xC9XVhNR9uzdtbbQSAoOXCtmjftHF/xzL/4q33ZotOofuU
         MTTtYNSIsdnG4FfyTEPDA46F/O9G4o5r0HedVG5fUkhSNkdkDD/3cIN4cmhTnd1soPzf
         5zWVE+6G/af/zEHLeLcFmvcJEqDqLCKZylH4c/GakEJEnvZN4R9Kdyzf1bAW1TVCF0GY
         OF1xf0FD8Z5ZgPaRvWv/ULYn7Z6tpypCqTCTi4SgvY70H1rlfmmejKi+8cXmdcCKtMpy
         uBJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yqxD5DGmQzql6e/bYmAXmjGDIRjOO1l2zM2klhlTIlA=;
        b=Jk1Ci5Izw/Nqs+4t1qPDa7Q6ol1cHMMi0qwXzfjuupuW1Uo1/HOzU62BnhqnUgRsfr
         AfYxiHfJeIV+EKcmud+V3oHfGashHLw8ec3qWf4sIKcadtnNo6zbyRF9h0vNHqfFBcF8
         a7hnLdRwWFPkFtC046jSeUFXE+gJMZIRHszJ8Idlg+rRVFOibYz3y8rHF8Olp67T3G5/
         qpDIv65cjB2/CLbZla5rD0b2njg8bIkmPqiKmMl/TBtlC/mkN0lPGf96WVkQ7Ra2nlUH
         hPVS84ul6yLLljr7nvnSeg5yr99YNg8AzYpX4T+Juq4jpyN/yXwCxX1SEl1oq78p2yce
         AwxA==
X-Gm-Message-State: AOAM532AeH01qUs67IF2ns80K8nJR+qXs21sGONRFpX4R8FR52xKY7jZ
        boqSN148S0Bltx4pB5sKocBdlvcftFM+7MEu/tB66Opi8qA=
X-Google-Smtp-Source: ABdhPJxlhVMKIm9/Tlsv/Wq2uXiFPn9OJO1GL10+wWbotyrgXROMBHGUosuUK/TUjMza+TkJiIBFuG2BJMlwVUo336Q=
X-Received: by 2002:a02:b011:: with SMTP id p17mr5104932jah.114.1609962862532;
 Wed, 06 Jan 2021 11:54:22 -0800 (PST)
MIME-Version: 1.0
References: <20210106180428.722521-1-atenart@kernel.org> <20210106180428.722521-4-atenart@kernel.org>
In-Reply-To: <20210106180428.722521-4-atenart@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 6 Jan 2021 11:54:11 -0800
Message-ID: <CAKgT0UdZs7ER84PmeM5EV6rAKWiqu-5Ma47bh8qf-68fjsfbAw@mail.gmail.com>
Subject: Re: [PATCH net 3/3] net-sysfs: move the xps cpus/rxqs retrieval in a
 common function
To:     Antoine Tenart <atenart@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 6, 2021 at 10:04 AM Antoine Tenart <atenart@kernel.org> wrote:
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

Why pass dev and index instead of just the queue which already
contains both? I think it would make more sense to just stick to
passing the queue through along with a pointer to the xps_dev_maps
value that we need to read.

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

So if we store the num_tc and nr_ids in the dev_maps structure then we
could simplify this a bit by pulling the num_tc info out of the
dev_map and only asking the Tx queue for the tc in that case and
validating it against (tc <0 || num_tc <= tc) and returning an error
if either are true.

This would also allow us to address the fact that the rxqs feature
doesn't support the subordinate devices as you could pull out the bit
above related to the sb_dev and instead call that prior to calling
xps_queue_show so that you are operating on the correct device map.

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

I think Jakub had mentioned earlier the idea of possibly moving some
fields into the xps_cpus_map and xps_rxqs_map in order to reduce the
complexity of this so that certain values would be protected by the
RCU lock.

This might be a good time to look at encoding things like the number
of IDs and the number of TCs there in order to avoid a bunch of this
duplication. Then you could just pass a pointer to the map you want to
display and the code should be able to just dump the values.:

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
