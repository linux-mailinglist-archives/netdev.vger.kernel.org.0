Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 185F3D4FDE
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 15:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbfJLNBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 09:01:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55226 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbfJLNBg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Oct 2019 09:01:36 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0B34AC05AA65;
        Sat, 12 Oct 2019 13:01:36 +0000 (UTC)
Received: from [10.72.12.16] (ovpn-12-16.pek2.redhat.com [10.72.12.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD7911C945;
        Sat, 12 Oct 2019 13:01:30 +0000 (UTC)
Subject: Re: [PATCH RFC net-next 2/2] drivers: net: virtio_net: Add tx_timeout
 function
To:     jcfaracco@gmail.com, netdev@vger.kernel.org
Cc:     mst@redhat.com, davem@davemloft.net,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, dnmendes76@gmail.com
References: <20191006184515.23048-1-jcfaracco@gmail.com>
 <20191006184515.23048-3-jcfaracco@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6c7a48ee-b900-c77d-8d12-35fd242f2e6f@redhat.com>
Date:   Sat, 12 Oct 2019 21:01:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191006184515.23048-3-jcfaracco@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Sat, 12 Oct 2019 13:01:36 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/7 上午2:45, jcfaracco@gmail.com wrote:
> From: Julio Faracco <jcfaracco@gmail.com>
>
> To enable dev_watchdog, virtio_net should have a tx_timeout defined
> (.ndo_tx_timeout). This is only a skeleton to throw a warn message. It
> notifies the event in some specific queue of device. This function
> still counts tx_timeout statistic and consider this event as an error
> (one error per queue), reporting it.
>
> Signed-off-by: Julio Faracco <jcfaracco@gmail.com>
> Signed-off-by: Daiane Mendes <dnmendes76@gmail.com>
> Cc: Jason Wang <jasowang@redhat.com>
> ---
>   drivers/net/virtio_net.c | 27 +++++++++++++++++++++++++++
>   1 file changed, 27 insertions(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 27f9b212c9f5..4b703b4b9441 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2585,6 +2585,29 @@ static int virtnet_set_features(struct net_device *dev,
>   	return 0;
>   }
>   
> +static void virtnet_tx_timeout(struct net_device *dev)
> +{
> +	struct virtnet_info *vi = netdev_priv(dev);
> +	u32 i;
> +
> +	/* find the stopped queue the same way dev_watchdog() does */
> +	for (i = 0; i < vi->curr_queue_pairs; i++) {
> +		struct send_queue *sq = &vi->sq[i];
> +
> +		if (!netif_xmit_stopped(netdev_get_tx_queue(dev, i)))
> +			continue;
> +
> +		u64_stats_update_begin(&sq->stats.syncp);
> +		sq->stats.tx_timeouts++;
> +		u64_stats_update_end(&sq->stats.syncp);
> +
> +		netdev_warn(dev, "TX timeout on send queue: %d, sq: %s, vq: %d, name: %s\n",
> +			    i, sq->name, sq->vq->index, sq->vq->name);


If this is just a warn for a specific queue, maybe it's better to do it 
in the dev_watchdog()?

Or we may want more information like avail,used idx etc.

And usually there will be a reset, any reason for not doing this?

Thanks


> +
> +		dev->stats.tx_errors++;
> +	}
> +}
> +
>   static const struct net_device_ops virtnet_netdev = {
>   	.ndo_open            = virtnet_open,
>   	.ndo_stop   	     = virtnet_close,
> @@ -2600,6 +2623,7 @@ static const struct net_device_ops virtnet_netdev = {
>   	.ndo_features_check	= passthru_features_check,
>   	.ndo_get_phys_port_name	= virtnet_get_phys_port_name,
>   	.ndo_set_features	= virtnet_set_features,
> +	.ndo_tx_timeout		= virtnet_tx_timeout,
>   };
>   
>   static void virtnet_config_changed_work(struct work_struct *work)
> @@ -3018,6 +3042,9 @@ static int virtnet_probe(struct virtio_device *vdev)
>   	dev->netdev_ops = &virtnet_netdev;
>   	dev->features = NETIF_F_HIGHDMA;
>   
> +	/* Set up dev_watchdog cycle. */
> +	dev->watchdog_timeo = 5 * HZ;
> +
>   	dev->ethtool_ops = &virtnet_ethtool_ops;
>   	SET_NETDEV_DEV(dev, &vdev->dev);
>   
