Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A10392590
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 05:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234770AbhE0DuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 23:50:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33753 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231470AbhE0DuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 23:50:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622087324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MndI0BhBeUi0uQEoIZPrttCcXIDrDdb+yFsBIF9E5vo=;
        b=AccJWYss/Te/UD1RWUo7yzuQ3r3zz/DpErmkZcUGAtrUccYrJ75cJWPAVWI8UNieC/GsYh
        TtqiWxYxcMTK+vZtf5sNBatRPgEZ4FTRpes9MJHq0cKxsnsbRJyQ54CdROXrk0oqJM5qrA
        C3LMXBj8vdxLrtoOp802O9k5Z/8zCZQ=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-8oUjOb9xPmSltIisffQNAA-1; Wed, 26 May 2021 23:48:42 -0400
X-MC-Unique: 8oUjOb9xPmSltIisffQNAA-1
Received: by mail-pj1-f69.google.com with SMTP id i8-20020a17090a7188b029015f9564a698so1695513pjk.8
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 20:48:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=MndI0BhBeUi0uQEoIZPrttCcXIDrDdb+yFsBIF9E5vo=;
        b=FsxRNJ/BHv/1MaRaYXsGpN+VE1LnnKnH1C092UrWIogEylXbWWeYYzqkm0VqM/BPg2
         FIyVsriq0b5D6ubFWx29b5Rb701pPKxqdjFGDWCgrwlfjB78ztcw1Wz4TFmZ13T2M70j
         xhif7qFaitq6+PZlKkUkovWoZM7Wnd+tZuyFUbkGjvfABXtrOgpwhDr1ap8NoTz6QFXc
         Po6RJW8x1c1MMTk4BBvn9SiZxP++ZM+47vlelyWcOE4vZUkjQqwutEmZB7kef4pd+hre
         bO3cKtqtxR9UV+tN/2G9/af1/MkWj8mnZGYL0DdgpE6AA2HysoQGo88/iIDTLqu4HpZt
         Qj2w==
X-Gm-Message-State: AOAM531KOg/troxs2nxGKFuFsOJfffhMktseGPUUCGJimBXMFomiAlvQ
        Tp1+mwV/xfVwy9Upof3yHPA1ItGXkNUm7J+D33UKmad8jxYWm60+rLhZu/fub74A8YE+axwTkj6
        Xl1Ez86lQOyPpV4Le
X-Received: by 2002:a17:90a:a014:: with SMTP id q20mr216638pjp.124.1622087321502;
        Wed, 26 May 2021 20:48:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNORR0VqV287Fr5cVhBXhwufI/OJV8Yc3ib3KYYstK5HpQVoRCvYfjDvdmrv8qmwzcLetATA==
X-Received: by 2002:a17:90a:a014:: with SMTP id q20mr216615pjp.124.1622087321271;
        Wed, 26 May 2021 20:48:41 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s1sm553256pfc.6.2021.05.26.20.48.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 20:48:40 -0700 (PDT)
Subject: Re: [PATCH v3 2/4] virtio_net: move txq wakeups under tx q lock
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org
References: <20210526082423.47837-1-mst@redhat.com>
 <20210526082423.47837-3-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <30c69182-cc6c-3e45-1db9-5b061e43e1d6@redhat.com>
Date:   Thu, 27 May 2021 11:48:33 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210526082423.47837-3-mst@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/5/26 ÏÂÎç4:24, Michael S. Tsirkin Ð´µÀ:
> We currently check num_free outside tx q lock
> which is unsafe: new packets can arrive meanwhile
> and there won't be space in the queue.
> Thus a spurious queue wakeup causing overhead
> and even packet drops.
>
> Move the check under the lock to fix that.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/net/virtio_net.c | 13 +++++++------
>   1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 12512d1002ec..c29f42d1e04f 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1434,11 +1434,12 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
>   
>   	if (__netif_tx_trylock(txq)) {
>   		free_old_xmit_skbs(sq, true);
> +
> +		if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
> +			netif_tx_wake_queue(txq);
> +
>   		__netif_tx_unlock(txq);
>   	}
> -
> -	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
> -		netif_tx_wake_queue(txq);
>   }
>   
>   static int virtnet_poll(struct napi_struct *napi, int budget)
> @@ -1522,6 +1523,9 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
>   	virtqueue_disable_cb(sq->vq);
>   	free_old_xmit_skbs(sq, true);
>   
> +	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
> +		netif_tx_wake_queue(txq);
> +
>   	opaque = virtqueue_enable_cb_prepare(sq->vq);
>   
>   	done = napi_complete_done(napi, 0);
> @@ -1542,9 +1546,6 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
>   		}
>   	}
>   
> -	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
> -		netif_tx_wake_queue(txq);
> -
>   	return 0;
>   }
>   

