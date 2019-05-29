Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4CC2D434
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 05:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfE2DWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 23:22:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbfE2DWw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 23:22:52 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D2D51308425C;
        Wed, 29 May 2019 03:22:51 +0000 (UTC)
Received: from [10.72.12.48] (ovpn-12-48.pek2.redhat.com [10.72.12.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D46731972B;
        Wed, 29 May 2019 03:22:42 +0000 (UTC)
Subject: Re: [PATCH 3/4] vsock/virtio: fix flush of works during the .remove()
To:     Stefano Garzarella <sgarzare@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>
References: <20190528105623.27983-1-sgarzare@redhat.com>
 <20190528105623.27983-4-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9ac9fc4b-5c39-2503-dfbb-660a7bdcfbfd@redhat.com>
Date:   Wed, 29 May 2019 11:22:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190528105623.27983-4-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 29 May 2019 03:22:51 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/28 下午6:56, Stefano Garzarella wrote:
> We flush all pending works before to call vdev->config->reset(vdev),
> but other works can be queued before the vdev->config->del_vqs(vdev),
> so we add another flush after it, to avoid use after free.
>
> Suggested-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>   net/vmw_vsock/virtio_transport.c | 23 +++++++++++++++++------
>   1 file changed, 17 insertions(+), 6 deletions(-)
>
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index e694df10ab61..ad093ce96693 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -660,6 +660,15 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>   	return ret;
>   }
>   
> +static void virtio_vsock_flush_works(struct virtio_vsock *vsock)
> +{
> +	flush_work(&vsock->loopback_work);
> +	flush_work(&vsock->rx_work);
> +	flush_work(&vsock->tx_work);
> +	flush_work(&vsock->event_work);
> +	flush_work(&vsock->send_pkt_work);
> +}
> +
>   static void virtio_vsock_remove(struct virtio_device *vdev)
>   {
>   	struct virtio_vsock *vsock = vdev->priv;
> @@ -668,12 +677,6 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
>   	mutex_lock(&the_virtio_vsock_mutex);
>   	the_virtio_vsock = NULL;
>   
> -	flush_work(&vsock->loopback_work);
> -	flush_work(&vsock->rx_work);
> -	flush_work(&vsock->tx_work);
> -	flush_work(&vsock->event_work);
> -	flush_work(&vsock->send_pkt_work);
> -
>   	/* Reset all connected sockets when the device disappear */
>   	vsock_for_each_connected_socket(virtio_vsock_reset_sock);
>   
> @@ -690,6 +693,9 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
>   	vsock->event_run = false;
>   	mutex_unlock(&vsock->event_lock);
>   
> +	/* Flush all pending works */
> +	virtio_vsock_flush_works(vsock);
> +
>   	/* Flush all device writes and interrupts, device will not use any
>   	 * more buffers.
>   	 */
> @@ -726,6 +732,11 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
>   	/* Delete virtqueues and flush outstanding callbacks if any */
>   	vdev->config->del_vqs(vdev);
>   
> +	/* Other works can be queued before 'config->del_vqs()', so we flush
> +	 * all works before to free the vsock object to avoid use after free.
> +	 */
> +	virtio_vsock_flush_works(vsock);


Some questions after a quick glance:

1) It looks to me that the work could be queued from the path of 
vsock_transport_cancel_pkt() . Is that synchronized here?

2) If we decide to flush after dev_vqs(), is tx_run/rx_run/event_run 
still needed? It looks to me we've already done except that we need 
flush rx_work in the end since send_pkt_work can requeue rx_work.

Thanks


> +
>   	kfree(vsock);
>   	mutex_unlock(&the_virtio_vsock_mutex);
>   }
