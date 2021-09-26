Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7EB41864B
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 06:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhIZEiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 00:38:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43585 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230378AbhIZEiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 00:38:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632630984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A3TJd6GzFVSVVOJY3XqWPWv+a42nUjfPicLF03kwZQQ=;
        b=PoLXodFk0fCg/9kthKM6q49zQaR6cLqvVYTjl1ofInRhBd31AWnfTuCUCsEiv+3+XJnQ6i
        iXXTB1tusd8aDjEoOigqn9lsWCn8n/MpG/nVgnGejsFDdm+fBQutNbv+j4lFOmiarbI/Sx
        ITpevTCrzwZNr8QKijI2Fv+TQCW0H88=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-SAjd1RBXNrmAezUHu1f3NQ-1; Sun, 26 Sep 2021 00:36:22 -0400
X-MC-Unique: SAjd1RBXNrmAezUHu1f3NQ-1
Received: by mail-lf1-f72.google.com with SMTP id o4-20020a056512230400b003fc39bb96c7so13009644lfu.8
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 21:36:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A3TJd6GzFVSVVOJY3XqWPWv+a42nUjfPicLF03kwZQQ=;
        b=amu2pZ5GSYyUWfKYwxkKQiputMYxLuVF16ZIghf/EWS5FAIMiW1ZlVyhgXunduDA8f
         IZMJurHStHYsZY4/rRZnAslGsE8aOSw0FarI0jN1sABKCkGjJD5dPyY/8Qoyk4JdKAPW
         c/KW+d/8Ew3ugIWX6eTSb0tDGJ1z9E372V557Fn/LiCNhWXmvlZ8ttIFnOcoc7g5spWi
         K7aA7Zaud1RLTlPSMCz/0WVHCl8n0t9WSYj9JS6d1ZDUZN0pSJdJBuVDZMJuHeeLVTkV
         U5MHY78Uy42MG2V+c06xm81M7iX1kPae8U5mWyk1XTqoCXd4Vv8aAZGXfh4BDg9CH9lh
         DpVQ==
X-Gm-Message-State: AOAM533WkgGcfs63d1zgeSwNpzU8MOlLHnUdoxrqRJKP9orkAx5wChbm
        13lYArIBJ5JkQjh9gc9+gVEl87V6HMMcLp8/M2GPLULOqm4tqIXRukKkF6hR6D4sMZ3FiSoI9Tx
        JYtoH4GFF5Qu8aBifk62IZTmywRq2ebLg
X-Received: by 2002:a2e:5c7:: with SMTP id 190mr20389491ljf.277.1632630981049;
        Sat, 25 Sep 2021 21:36:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9YGAG8k1uMU/NRbqwufFMI0+XuF0lYCsEm7Wci0/HUz3DTa33uDCquEE41I7Vbnj9MjFnJGixkLZfi32LCOc=
X-Received: by 2002:a2e:5c7:: with SMTP id 190mr20389477ljf.277.1632630980863;
 Sat, 25 Sep 2021 21:36:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210917084004.44332-1-tonylu@linux.alibaba.com>
In-Reply-To: <20210917084004.44332-1-tonylu@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Sun, 26 Sep 2021 12:36:10 +0800
Message-ID: <CACGkMEstVmGizjSCoZR2ruRSfuqpJPwsVifCYOuJ2po8U79-Kw@mail.gmail.com>
Subject: Re: [PATCH] virtio_net: introduce TX timeout watchdog
To:     tonylu_linux <tonylu@linux.alibaba.com>
Cc:     mst <mst@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        davem <davem@davemloft.net>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 4:45 PM tonylu_linux <tonylu@linux.alibaba.com> wrote:
>
> From: Tony Lu <tony.ly@linux.alibaba.com>
>
> This implements ndo_tx_timeout handler and put this into stats. When
> there is something wrong to send out packets, we could notice tx timeout
> events and total timeout counter.
>
> We have suffered send timeout issues due to the backends hung. With this,
> we can find the details, and collect the counters by monitor systems.
>
> Signed-off-by: Tony Lu <tony.ly@linux.alibaba.com>

Note that we support non tx interrupt mode (which could be turned on
via ethtool).

I wonder if this can work well in that case.

Or maybe it's the time to remove the non tx interrupt mode completely.
Want to do that?

Thanks

> ---
>  drivers/net/virtio_net.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 271d38c1d9f8..90fed0fdc40f 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -80,6 +80,7 @@ struct virtnet_sq_stats {
>         u64 xdp_tx;
>         u64 xdp_tx_drops;
>         u64 kicks;
> +       u64 tx_timeouts;
>  };
>
>  struct virtnet_rq_stats {
> @@ -103,6 +104,7 @@ static const struct virtnet_stat_desc virtnet_sq_stats_desc[] = {
>         { "xdp_tx",             VIRTNET_SQ_STAT(xdp_tx) },
>         { "xdp_tx_drops",       VIRTNET_SQ_STAT(xdp_tx_drops) },
>         { "kicks",              VIRTNET_SQ_STAT(kicks) },
> +       { "tx_timeouts",        VIRTNET_SQ_STAT(tx_timeouts) },
>  };
>
>  static const struct virtnet_stat_desc virtnet_rq_stats_desc[] = {
> @@ -1856,7 +1858,7 @@ static void virtnet_stats(struct net_device *dev,
>         int i;
>
>         for (i = 0; i < vi->max_queue_pairs; i++) {
> -               u64 tpackets, tbytes, rpackets, rbytes, rdrops;
> +               u64 tpackets, tbytes, terrors, rpackets, rbytes, rdrops;
>                 struct receive_queue *rq = &vi->rq[i];
>                 struct send_queue *sq = &vi->sq[i];
>
> @@ -1864,6 +1866,7 @@ static void virtnet_stats(struct net_device *dev,
>                         start = u64_stats_fetch_begin_irq(&sq->stats.syncp);
>                         tpackets = sq->stats.packets;
>                         tbytes   = sq->stats.bytes;
> +                       terrors  = sq->stats.tx_timeouts;
>                 } while (u64_stats_fetch_retry_irq(&sq->stats.syncp, start));
>
>                 do {
> @@ -1878,6 +1881,7 @@ static void virtnet_stats(struct net_device *dev,
>                 tot->rx_bytes   += rbytes;
>                 tot->tx_bytes   += tbytes;
>                 tot->rx_dropped += rdrops;
> +               tot->tx_errors  += terrors;
>         }
>
>         tot->tx_dropped = dev->stats.tx_dropped;
> @@ -2659,6 +2663,21 @@ static int virtnet_set_features(struct net_device *dev,
>         return 0;
>  }
>
> +static void virtnet_tx_timeout(struct net_device *dev, unsigned int txqueue)
> +{
> +       struct virtnet_info *priv = netdev_priv(dev);
> +       struct send_queue *sq = &priv->sq[txqueue];
> +       struct netdev_queue *txq = netdev_get_tx_queue(dev, txqueue);
> +
> +       u64_stats_update_begin(&sq->stats.syncp);
> +       sq->stats.tx_timeouts++;
> +       u64_stats_update_end(&sq->stats.syncp);
> +
> +       netdev_err(dev, "TX timeout on queue: %u, sq: %s, vq: 0x%x, name: %s, %u usecs ago\n",
> +                  txqueue, sq->name, sq->vq->index, sq->vq->name,
> +                  jiffies_to_usecs(jiffies - txq->trans_start));
> +}
> +
>  static const struct net_device_ops virtnet_netdev = {
>         .ndo_open            = virtnet_open,
>         .ndo_stop            = virtnet_close,
> @@ -2674,6 +2693,7 @@ static const struct net_device_ops virtnet_netdev = {
>         .ndo_features_check     = passthru_features_check,
>         .ndo_get_phys_port_name = virtnet_get_phys_port_name,
>         .ndo_set_features       = virtnet_set_features,
> +       .ndo_tx_timeout         = virtnet_tx_timeout,
>  };
>
>  static void virtnet_config_changed_work(struct work_struct *work)
> --
> 2.19.1.6.gb485710b
>

