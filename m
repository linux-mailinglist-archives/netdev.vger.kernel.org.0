Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B271C66BFFF
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbjAPNmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:42:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbjAPNmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:42:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3960B1D90C
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 05:41:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673876506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dy1VK4lCS2RdiiWOjQOjdjHQSzkWQSXFlBq6wGn15DM=;
        b=LrtyNmXOYov8ewAKviOXrSbStdjvV8E6xhdz0x/Vk2BfxisEhtn/FYqRjjEsRAq8KAyv/v
        o81f8JC4YQTtCPUGWd1SiqUIVELNmRXav2x7uL0PWv/gR+qcHIX3dfiei5UKD/rMxCTBdi
        ANHjhz4o5RZp2LjZeQ6kx8jot8X9xmw=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-241-g5ULs8GEPH2zCuRPR1Gssg-1; Mon, 16 Jan 2023 08:41:45 -0500
X-MC-Unique: g5ULs8GEPH2zCuRPR1Gssg-1
Received: by mail-vk1-f200.google.com with SMTP id j17-20020a1f2311000000b003bd40550849so8392308vkj.6
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 05:41:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dy1VK4lCS2RdiiWOjQOjdjHQSzkWQSXFlBq6wGn15DM=;
        b=fi+Ynv4jAm2As8x51mm18VxYrP7THGavcVCR0L3B2SKMMm6Y4Czhz446f2b7TTKELl
         8wdrulv6aJEUCPIzTtLns9qQjXzdo7AWspPtTXL4xaGTBW69+sfwBAN7lfn0xuv+iixM
         vvVhtxGJnsVWI5T452z4Whhj1kF26flKTupQR9e9yJPaHSy4EvpKiJGSv9A4tKM5wp7p
         krN891lVGPJ4Zg4vLjQoKjmHoQplKVQBu2+l3ZZJpqUgwaHHxU6lc3t3dbBbZKWzxeYq
         +JjEPi0hc1a6b0vrBg+Pp3uvFCfa9kcdfrCa17B3GJleCH/JHzWGd67En5+f+H9bTFCx
         ew+A==
X-Gm-Message-State: AFqh2kpfacuw5rCFlXxG742xGmebZoGHMJnScpas6DKJ3bMGCG+Zy2oB
        DrXcquxNQdMMeJ9xyEAL/s+ljkGncRHTHaFYTClz1u8BJmHkVeyZRqpqXrXNSLbO71ohC9yEyal
        p03KFdaKj3SlckyC5
X-Received: by 2002:a05:6102:3f90:b0:3d0:ee83:95a8 with SMTP id o16-20020a0561023f9000b003d0ee8395a8mr9681700vsv.22.1673876504562;
        Mon, 16 Jan 2023 05:41:44 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvYhRgRNllMe5psFSkuJuj41TDkdErcxfLGtCYOgT62YtFZx3O5juVXyyxqx+mq0RIA79mPcw==
X-Received: by 2002:a05:6102:3f90:b0:3d0:ee83:95a8 with SMTP id o16-20020a0561023f9000b003d0ee8395a8mr9681683vsv.22.1673876504271;
        Mon, 16 Jan 2023 05:41:44 -0800 (PST)
Received: from [192.168.100.30] ([82.142.8.70])
        by smtp.gmail.com with ESMTPSA id az31-20020a05620a171f00b006fbbdc6c68fsm18203746qkb.68.2023.01.16.05.41.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 05:41:43 -0800 (PST)
Message-ID: <a5990064-df57-f991-832d-56d1156dc3f8@redhat.com>
Date:   Mon, 16 Jan 2023 14:41:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 4/4] virtio_net: disable cb aggressively
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20210526082423.47837-1-mst@redhat.com>
 <20210526082423.47837-5-mst@redhat.com>
From:   Laurent Vivier <lvivier@redhat.com>
In-Reply-To: <20210526082423.47837-5-mst@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_PDS_OTHER_BAD_TLD autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On 5/26/21 10:24, Michael S. Tsirkin wrote:
> There are currently two cases where we poll TX vq not in response to a
> callback: start xmit and rx napi.  We currently do this with callbacks
> enabled which can cause extra interrupts from the card.  Used not to be
> a big issue as we run with interrupts disabled but that is no longer the
> case, and in some cases the rate of spurious interrupts is so high
> linux detects this and actually kills the interrupt.
> 
> Fix up by disabling the callbacks before polling the tx vq.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>   drivers/net/virtio_net.c | 16 ++++++++++++----
>   1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index c29f42d1e04f..a83dc038d8af 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1433,7 +1433,10 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
>   		return;
>   
>   	if (__netif_tx_trylock(txq)) {
> -		free_old_xmit_skbs(sq, true);
> +		do {
> +			virtqueue_disable_cb(sq->vq);
> +			free_old_xmit_skbs(sq, true);
> +		} while (unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
>   
>   		if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
>   			netif_tx_wake_queue(txq);
> @@ -1605,12 +1608,17 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>   	struct netdev_queue *txq = netdev_get_tx_queue(dev, qnum);
>   	bool kick = !netdev_xmit_more();
>   	bool use_napi = sq->napi.weight;
> +	unsigned int bytes = skb->len;
>   
>   	/* Free up any pending old buffers before queueing new ones. */
> -	free_old_xmit_skbs(sq, false);
> +	do {
> +		if (use_napi)
> +			virtqueue_disable_cb(sq->vq);
>   
> -	if (use_napi && kick)
> -		virtqueue_enable_cb_delayed(sq->vq);
> +		free_old_xmit_skbs(sq, false);
> +
> +	} while (use_napi && kick &&
> +	       unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
>   
>   	/* timestamp packet in software */
>   	skb_tx_timestamp(skb);

This patch seems to introduce a problem with QEMU connected to passt using netdev stream 
backend.

When I run an iperf3 test I get after 1 or 2 seconds of test:

[  254.035559] NETDEV WATCHDOG: ens3 (virtio_net): transmit queue 0 timed out
...
[  254.060962] virtio_net virtio1 ens3: TX timeout on queue: 0, sq: output.0, vq: 0x1, 
name: output.0, 8856000 usecs ago
[  259.155150] virtio_net virtio1 ens3: TX timeout on queue: 0, sq: output.0, vq: 0x1, 
name: output.0, 13951000 usecs ago

In QEMU, I can see in virtio_net_tx_bh() the function virtio_net_flush_tx() has flushed 
all the queue entries and re-enabled the queue notification with 
virtio_queue_set_notification() and tries to flush again the queue and as it is empty it 
does nothing more and then rely on a kernel notification to re-enable the bottom half 
function. As this notification never comes the queue is stuck and kernel add entries but 
QEMU doesn't remove them:

2812 static void virtio_net_tx_bh(void *opaque)
2813 {
...
2833     ret = virtio_net_flush_tx(q);

-> flush the queue and ret is not an error and not n->tx_burst (that would re-schedule the 
function)

...
2850     virtio_queue_set_notification(q->tx_vq, 1);

-> re-enable the queue notification

2851     ret = virtio_net_flush_tx(q);
2852     if (ret == -EINVAL) {
2853         return;
2854     } else if (ret > 0) {
2855         virtio_queue_set_notification(q->tx_vq, 0);
2856         qemu_bh_schedule(q->tx_bh);
2857         q->tx_waiting = 1;
2858     }

-> ret is 0, exit the function without re-scheduling the function.
...
2859 }

If I revert this patch in the kernel (a7766ef18b33 ("virtio_net: disable cb 
aggressively")), it works fine.

How to reproduce it:

I start passt (https://passt.top/passt):

passt -f

and then QEMU

qemu-system-x86_64 ... --netdev 
stream,id=netdev0,server=off,addr.type=unix,addr.path=/tmp/passt_1.socket -device 
virtio-net,mac=9a:2b:2c:2d:2e:2f,netdev=netdev0

Host side:

sysctl -w net.core.rmem_max=134217728
sysctl -w net.core.wmem_max=134217728
iperf3 -s

Guest side:

sysctl -w net.core.rmem_max=536870912
sysctl -w net.core.wmem_max=536870912

ip link set dev $DEV mtu 256
iperf3 -c $HOST -t10 -i0 -Z -P 8 -l 1M --pacing-timer 1000000 -w 4M

Any idea of what is the problem?

Thanks,
Laurent


