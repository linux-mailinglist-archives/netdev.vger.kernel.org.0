Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC5B2E04D8
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 04:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgLVDum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 22:50:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49189 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725969AbgLVDum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 22:50:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608608955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LP/jJCPXp1ZjxGWbs4WF0FNxRzF7g1uBxZujdFuaZik=;
        b=CwYzGcC/LnRuGCdrdTpllvICU3HlNUjEyfn0iy1IA5m/AfxholOGMgrhZx+4U1tf+il+7p
        BANMLEFR1SaNgbz2NkoKc78CsSUwpQaUB/VS7aQxfD5jMlVbeqCkANUPhfN1o8gUV5ntRI
        c3klVxIBnoU7Ba4ftjh8AldPTBiMPZY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-DnmK1liDNoCCV-6_azYVEw-1; Mon, 21 Dec 2020 22:49:11 -0500
X-MC-Unique: DnmK1liDNoCCV-6_azYVEw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50399801817;
        Tue, 22 Dec 2020 03:49:10 +0000 (UTC)
Received: from [10.72.13.168] (ovpn-13-168.pek2.redhat.com [10.72.13.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 948DC1B534;
        Tue, 22 Dec 2020 03:49:05 +0000 (UTC)
Subject: Re: [PATCH] virtio_net: Fix recursive call to cpus_read_lock()
To:     Jeff Dike <jdike@akamai.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20201222033648.14752-1-jdike@akamai.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e8379ba8-6578-baa0-8a67-1deada809271@redhat.com>
Date:   Tue, 22 Dec 2020 11:49:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201222033648.14752-1-jdike@akamai.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/22 上午11:36, Jeff Dike wrote:
> virtnet_set_channels can recursively call cpus_read_lock if CONFIG_XPS
> and CONFIG_HOTPLUG are enabled.
>
> The path is:
>      virtnet_set_channels - calls get_online_cpus(), which is a trivial
> wrapper around cpus_read_lock()
>      netif_set_real_num_tx_queues
>      netif_reset_xps_queues_gt
>      netif_reset_xps_queues - calls cpus_read_lock()
>
> This call chain and potential deadlock happens when the number of TX
> queues is reduced.
>
> This commit the removes netif_set_real_num_[tr]x_queues calls from
> inside the get/put_online_cpus section, as they don't require that it
> be held.
>
> Signed-off-by: Jeff Dike <jdike@akamai.com>
> ---


Adding netdev.

The patch can go with -net and is needed for -stable.

Acked-by: Jason Wang <jasowang@redhat.com>


>   drivers/net/virtio_net.c | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 052975ea0af4..e02c7e0f1cf9 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2093,14 +2093,16 @@ static int virtnet_set_channels(struct net_device *dev,
>   
>   	get_online_cpus();
>   	err = _virtnet_set_queues(vi, queue_pairs);
> -	if (!err) {
> -		netif_set_real_num_tx_queues(dev, queue_pairs);
> -		netif_set_real_num_rx_queues(dev, queue_pairs);
> -
> -		virtnet_set_affinity(vi);
> +	if (err){
> +		put_online_cpus();
> +		goto err;
>   	}
> +	virtnet_set_affinity(vi);
>   	put_online_cpus();
>   
> +	netif_set_real_num_tx_queues(dev, queue_pairs);
> +	netif_set_real_num_rx_queues(dev, queue_pairs);
> + err:
>   	return err;
>   }
>   

