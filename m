Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6638A35DA68
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 10:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243811AbhDMIzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 04:55:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28498 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230124AbhDMIzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 04:55:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618304095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CKPKEZ9FRbFkC2KSVQ4DBOrlcHV/4kIBTz0bbRwMv7o=;
        b=NEbdMAjK6+hFQ7riLYUMytPwZmSr7E70bwY6VRIzMXqHe4QwzZ8DNL0mfYXXpKJq5WOzLP
        UwvVcLTfUEP62uRzedtVu0rRNcRHtQf7DuuK2LDWY5GQZgzSQ4w+wEwbljvdbky7YxaKVX
        DSxj9j9WRVFnfgHVXReIih26UkPHTUo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-Q6cfJx75NQuy_ZphtauNww-1; Tue, 13 Apr 2021 04:54:52 -0400
X-MC-Unique: Q6cfJx75NQuy_ZphtauNww-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D15DE83DD38;
        Tue, 13 Apr 2021 08:54:50 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-128.pek2.redhat.com [10.72.13.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 17B751A86F;
        Tue, 13 Apr 2021 08:54:44 +0000 (UTC)
Subject: Re: [PATCH RFC v2 3/4] virtio_net: move tx vq operation under tx
 queue lock
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org
References: <20210413054733.36363-1-mst@redhat.com>
 <20210413054733.36363-4-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <805053bf-960f-3c34-ce23-012d121ca937@redhat.com>
Date:   Tue, 13 Apr 2021 16:54:42 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210413054733.36363-4-mst@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/4/13 ÏÂÎç1:47, Michael S. Tsirkin Ð´µÀ:
> It's unsafe to operate a vq from multiple threads.
> Unfortunately this is exactly what we do when invoking
> clean tx poll from rx napi.
> As a fix move everything that deals with the vq to under tx lock.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>   drivers/net/virtio_net.c | 22 +++++++++++++++++++++-
>   1 file changed, 21 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 16d5abed582c..460ccdbb840e 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1505,6 +1505,8 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
>   	struct virtnet_info *vi = sq->vq->vdev->priv;
>   	unsigned int index = vq2txq(sq->vq);
>   	struct netdev_queue *txq;
> +	int opaque;
> +	bool done;
>   
>   	if (unlikely(is_xdp_raw_buffer_queue(vi, index))) {
>   		/* We don't need to enable cb for XDP */
> @@ -1514,10 +1516,28 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
>   
>   	txq = netdev_get_tx_queue(vi->dev, index);
>   	__netif_tx_lock(txq, raw_smp_processor_id());
> +	virtqueue_disable_cb(sq->vq);
>   	free_old_xmit_skbs(sq, true);
> +
> +	opaque = virtqueue_enable_cb_prepare(sq->vq);
> +
> +	done = napi_complete_done(napi, 0);
> +
> +	if (!done)
> +		virtqueue_disable_cb(sq->vq);
> +
>   	__netif_tx_unlock(txq);
>   
> -	virtqueue_napi_complete(napi, sq->vq, 0);


So I wonder why not simply move __netif_tx_unlock() after 
virtqueue_napi_complete()?

Thanks


> +	if (done) {
> +		if (unlikely(virtqueue_poll(sq->vq, opaque))) {
> +			if (napi_schedule_prep(napi)) {
> +				__netif_tx_lock(txq, raw_smp_processor_id());
> +				virtqueue_disable_cb(sq->vq);
> +				__netif_tx_unlock(txq);
> +				__napi_schedule(napi);
> +			}
> +		}
> +	}
>   
>   	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
>   		netif_tx_wake_queue(txq);

