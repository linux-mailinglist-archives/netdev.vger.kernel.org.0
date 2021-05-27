Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C1A392585
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 05:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234686AbhE0DnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 23:43:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26496 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233656AbhE0DnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 23:43:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622086902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=owGdohWgeueCs/0bpmzG2a18Ycc1oYO2UMZ3CQnhszs=;
        b=HUoGhgKPGyH3o5odC2NJnBDIwxz6hIXaa7Zn5aThw9JEtQxaVniSii+c9q6hvgEdYw7ftF
        Lcno+LfJKQ/6mFV1juuGNVRQyZr2IBxhwNVOZ5ktnipFEHTYyZMFXA3vKerf18/6mj+TfL
        QAO1VTdFa5OTYgig9V7+j9lJ2uyn2yM=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-EFny_c8ePTGiA4pMJOgq2Q-1; Wed, 26 May 2021 23:41:41 -0400
X-MC-Unique: EFny_c8ePTGiA4pMJOgq2Q-1
Received: by mail-pf1-f197.google.com with SMTP id 64-20020a6215430000b02902df2a3e11caso2032204pfv.3
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 20:41:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=owGdohWgeueCs/0bpmzG2a18Ycc1oYO2UMZ3CQnhszs=;
        b=YXm0MJMiZdgUQYIkJJ+LoorhqJVQtU/JlM5ie/5EB2yZ7oryyvP7E8pwilL+t5yp1M
         FXb86TyvZsQXMkWZUDsYLuTMWLP41fjIi72aNpOF6HSwcwhIMGNZO6vJLpI5Jw97dkOX
         ws54Oz4xe6TiOqDk4W2TYp9FJFDAfow5+fyvmCtIt64UgE+PZo2gqUF2K2NdTQnnslML
         uMK/fz6sZVTQRUtCwpt95j31j1LkD0KMT1qzyvTNWyrY7I931vsfMb8TzDZUIngTf9QK
         hC1KENIKgG6bKE0dbFL7vbXpgUvuPlrWILVo8kZ2PYInyy/j+LuOZY+J+4ZbkS3b42cs
         HXPw==
X-Gm-Message-State: AOAM533zes9Dl6ruB72oTjzMrjbb/D6t2RSULyaRpvHktSnBeiJj8yut
        jPuHZ4mBbTb7/vVhOpl1tCDSYUF8zLBuL6PJFqu6T4SsOPTgIwwaTFtb6PkdAmIsx3HuPOyuc8C
        6YD3LELe328ZKkAW/
X-Received: by 2002:a17:902:9004:b029:f0:b40d:38d with SMTP id a4-20020a1709029004b02900f0b40d038dmr1348718plp.85.1622086900073;
        Wed, 26 May 2021 20:41:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxlloFsLSTo3NBjczWn6jhZffi5xMtvZghbENGdeQMOi1/9v8B7I5OYeenQXdt7FxlJZADScQ==
X-Received: by 2002:a17:902:9004:b029:f0:b40d:38d with SMTP id a4-20020a1709029004b02900f0b40d038dmr1348697plp.85.1622086899770;
        Wed, 26 May 2021 20:41:39 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 15sm545681pjt.17.2021.05.26.20.41.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 20:41:39 -0700 (PDT)
Subject: Re: [PATCH v3 1/4] virtio_net: move tx vq operation under tx queue
 lock
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org
References: <20210526082423.47837-1-mst@redhat.com>
 <20210526082423.47837-2-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <476e9418-156d-dbc9-5105-11d2816b95f7@redhat.com>
Date:   Thu, 27 May 2021 11:41:31 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210526082423.47837-2-mst@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/5/26 ÏÂÎç4:24, Michael S. Tsirkin Ð´µÀ:
> It's unsafe to operate a vq from multiple threads.
> Unfortunately this is exactly what we do when invoking
> clean tx poll from rx napi.
> Same happens with napi-tx even without the
> opportunistic cleaning from the receive interrupt: that races
> with processing the vq in start_xmit.
>
> As a fix move everything that deals with the vq to under tx lock.
>
> Fixes: b92f1e6751a6 ("virtio-net: transmit napi")
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>   drivers/net/virtio_net.c | 22 +++++++++++++++++++++-
>   1 file changed, 21 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index ac0c143f97b4..12512d1002ec 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1508,6 +1508,8 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
>   	struct virtnet_info *vi = sq->vq->vdev->priv;
>   	unsigned int index = vq2txq(sq->vq);
>   	struct netdev_queue *txq;
> +	int opaque;
> +	bool done;
>   
>   	if (unlikely(is_xdp_raw_buffer_queue(vi, index))) {
>   		/* We don't need to enable cb for XDP */
> @@ -1517,10 +1519,28 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
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


Interesting, this looks like somehwo a open-coded version of 
virtqueue_napi_complete(). I wonder if we can simply keep using 
virtqueue_napi_complete() by simply moving the __netif_tx_unlock() after 
that:

netif_tx_lock(txq);
free_old_xmit_skbs(sq, true);
virtqueue_napi_complete(napi, sq->vq, 0);
__netif_tx_unlock(txq);

Thanks


>   
>   	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
>   		netif_tx_wake_queue(txq);

