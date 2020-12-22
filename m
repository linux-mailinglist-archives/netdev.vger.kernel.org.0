Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E162E1056
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 23:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbgLVWeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 17:34:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43505 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728437AbgLVWeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 17:34:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608676355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IonW2o/1Jm2bgtMHyV7imS+O9e7gTHGtzSzw1CivbwI=;
        b=Gxmfqg5D/L3nANOKHAyvk3fPo5DB57L1KgZo4ZED4r/PIzs6SwEO8NfZXDmz1rilvbly5q
        17Op7dUbuBd6xkC6MqYVwRg0KedS3ZUJVp5U6RuCGO/R42K11VGUcSnGgmQFilzAzKfQTk
        ukjUfw6i/ZCpuzJVmLvgk4ZSTgJ9jyg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-oiKYSVesMjSsD7C-__sCRQ-1; Tue, 22 Dec 2020 17:32:33 -0500
X-MC-Unique: oiKYSVesMjSsD7C-__sCRQ-1
Received: by mail-wm1-f70.google.com with SMTP id t134so2321924wmt.7
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 14:32:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IonW2o/1Jm2bgtMHyV7imS+O9e7gTHGtzSzw1CivbwI=;
        b=g3bJBxGr0FM7mKkcdtKBRX+1EBshGS/eK5WcAjFvfiYr4fRb7i1IHnL8DFRtFdDgrz
         P1HJq2NVyzBzu3SsiBfW017GEefCOGAyuVbL8gq3VHPFjCGxf9C5+feKfkWRjWDlkDnM
         Ml6Ya8/uX8Pu7q2C2p6XnXKAjOjXvdsp6qnePj5S8gq5D2d6Wlw3zUFTnGUmPBOVaobw
         lAWbfihXd1fxzNRBzu8XBH6r8CmkkQzq+/ZWAVB9Lf3AB+tD6AVigg6VVCKVyhKG24Iv
         LX43YuznS13BZhkq348d19eXbkNvYNDOLhcTYNRKqM1uJPP+l6wfxuGFcAzF6602jkhS
         KOHg==
X-Gm-Message-State: AOAM533Q0+Nvcm4CS3XuG6pIftedZyVx8AJ2FdGycP8XuwEHBal0GBUl
        mqhrRtkhciRE9feN0nKMXRNvC5FI/BazJMdTofyYcTf5qlQrmmZ4cxbbu3eleMUxfUaDdnZBIWI
        vd/QwH8CUohF/KMpW
X-Received: by 2002:adf:d085:: with SMTP id y5mr26964699wrh.41.1608676352525;
        Tue, 22 Dec 2020 14:32:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyGpvAo0f4ZPURjmyIvE7jVhc03kO5QJPSr/r1EHgA8Wh6rOqz9nWLh09xqTdwx0CHWVxhJmw==
X-Received: by 2002:adf:d085:: with SMTP id y5mr26964692wrh.41.1608676352382;
        Tue, 22 Dec 2020 14:32:32 -0800 (PST)
Received: from redhat.com (bzq-79-178-32-166.red.bezeqint.net. [79.178.32.166])
        by smtp.gmail.com with ESMTPSA id r82sm28894756wma.18.2020.12.22.14.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 14:32:31 -0800 (PST)
Date:   Tue, 22 Dec 2020 17:32:29 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jeff Dike <jdike@akamai.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] virtio_net: Fix recursive call to cpus_read_lock()
Message-ID: <20201222173209-mutt-send-email-mst@kernel.org>
References: <20201222033648.14752-1-jdike@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201222033648.14752-1-jdike@akamai.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 10:36:48PM -0500, Jeff Dike wrote:
> virtnet_set_channels can recursively call cpus_read_lock if CONFIG_XPS
> and CONFIG_HOTPLUG are enabled.
> 
> The path is:
>     virtnet_set_channels - calls get_online_cpus(), which is a trivial
> wrapper around cpus_read_lock()
>     netif_set_real_num_tx_queues
>     netif_reset_xps_queues_gt
>     netif_reset_xps_queues - calls cpus_read_lock()
> 
> This call chain and potential deadlock happens when the number of TX
> queues is reduced.
> 
> This commit the removes netif_set_real_num_[tr]x_queues calls from
> inside the get/put_online_cpus section, as they don't require that it
> be held.
> 
> Signed-off-by: Jeff Dike <jdike@akamai.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/net/virtio_net.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 052975ea0af4..e02c7e0f1cf9 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2093,14 +2093,16 @@ static int virtnet_set_channels(struct net_device *dev,
>  
>  	get_online_cpus();
>  	err = _virtnet_set_queues(vi, queue_pairs);
> -	if (!err) {
> -		netif_set_real_num_tx_queues(dev, queue_pairs);
> -		netif_set_real_num_rx_queues(dev, queue_pairs);
> -
> -		virtnet_set_affinity(vi);
> +	if (err){
> +		put_online_cpus();
> +		goto err;
>  	}
> +	virtnet_set_affinity(vi);
>  	put_online_cpus();
>  
> +	netif_set_real_num_tx_queues(dev, queue_pairs);
> +	netif_set_real_num_rx_queues(dev, queue_pairs);
> + err:
>  	return err;
>  }
>  
> -- 
> 2.17.1

