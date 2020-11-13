Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D04A2B13A6
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 02:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgKMBFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 20:05:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43857 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725965AbgKMBFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 20:05:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605229535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BcosP8TSvNEHePRYfijs34ODy94RIXh0SoOkYYugoxY=;
        b=Z5iG0JBPo0ZIfCZn2jbV680Dbj2KYl5f9mVRFzMBuQdVwPsfzaCtcaVZZzCnAdYect2pUz
        IPqqrEyjO7cxPmsLHyW2t95mlIJy81U4cKQRQAb7RrmoLaERT1Rkl0uPskjlQbmRcoCfig
        qpksZl0GkzZkTqJZt3NDlyECE/o0EbQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-18TLJ0fdPWW1mVw3mCpWbQ-1; Thu, 12 Nov 2020 20:05:31 -0500
X-MC-Unique: 18TLJ0fdPWW1mVw3mCpWbQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4757108E1A5;
        Fri, 13 Nov 2020 01:05:29 +0000 (UTC)
Received: from [10.72.12.208] (ovpn-12-208.pek2.redhat.com [10.72.12.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A43435D9D5;
        Fri, 13 Nov 2020 01:05:21 +0000 (UTC)
Subject: Re: [PATCH netdev 1/2] virtio: add module option to turn off guest
 offloads
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, mst@redhat.com, davem@davemloft.net,
        kuba@kernel.org
References: <cover.1605184791.git.xuanzhuo@linux.alibaba.com>
 <5b2e0f71d5feddd9fe23babaad60114208731a59.1605184791.git.xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f078cd84-4d65-ceb1-e7a9-75ec22da5823@redhat.com>
Date:   Fri, 13 Nov 2020 09:05:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5b2e0f71d5feddd9fe23babaad60114208731a59.1605184791.git.xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/11/12 下午4:11, Xuan Zhuo wrote:
> * VIRTIO_NET_F_GUEST_CSUM
> * VIRTIO_NET_F_GUEST_TSO4
> * VIRTIO_NET_F_GUEST_TSO6
> * VIRTIO_NET_F_GUEST_ECN
> * VIRTIO_NET_F_GUEST_UFO
> * VIRTIO_NET_F_MTU
>
> If these features are negotiated successfully, it may cause virtio-net to
> receive large packages, which will cause xdp to fail to load. And in
> many cases, it cannot be dynamically turned off, so add a module option
> to turn off these features.


Actually we will disable those through control virtqueue. Or does it 
mean your hardware doesn't support control guest offloads?

Module parameters may introduce a lot of burden for management and 
use-ability.

Disabling guest offloads means you may suffer from low RX throughput.

Thanks


>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/net/virtio_net.c | 36 +++++++++++++++++++++++++++++++++++-
>   1 file changed, 35 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 21b7114..232a539 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -26,10 +26,11 @@
>   static int napi_weight = NAPI_POLL_WEIGHT;
>   module_param(napi_weight, int, 0444);
>   
> -static bool csum = true, gso = true, napi_tx = true;
> +static bool csum = true, gso = true, napi_tx, guest_offload = true;
>   module_param(csum, bool, 0444);
>   module_param(gso, bool, 0444);
>   module_param(napi_tx, bool, 0644);
> +module_param(guest_offload, bool, 0644);
>   
>   /* FIXME: MTU in config. */
>   #define GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
> @@ -3245,6 +3246,18 @@ static __maybe_unused int virtnet_restore(struct virtio_device *vdev)
>   	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
>   	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY
>   
> +#define VIRTNET_FEATURES_WITHOUT_GUEST_OFFLOADS \
> +	VIRTIO_NET_F_CSUM, \
> +	VIRTIO_NET_F_MAC, \
> +	VIRTIO_NET_F_HOST_TSO4, VIRTIO_NET_F_HOST_UFO, VIRTIO_NET_F_HOST_TSO6, \
> +	VIRTIO_NET_F_HOST_ECN, \
> +	VIRTIO_NET_F_MRG_RXBUF, VIRTIO_NET_F_STATUS, VIRTIO_NET_F_CTRL_VQ, \
> +	VIRTIO_NET_F_CTRL_RX, VIRTIO_NET_F_CTRL_VLAN, \
> +	VIRTIO_NET_F_GUEST_ANNOUNCE, VIRTIO_NET_F_MQ, \
> +	VIRTIO_NET_F_CTRL_MAC_ADDR, \
> +	VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
> +	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY
> +
>   static unsigned int features[] = {
>   	VIRTNET_FEATURES,
>   };
> @@ -3255,6 +3268,16 @@ static __maybe_unused int virtnet_restore(struct virtio_device *vdev)
>   	VIRTIO_F_ANY_LAYOUT,
>   };
>   
> +static unsigned int features_without_offloads[] = {
> +	VIRTNET_FEATURES_WITHOUT_GUEST_OFFLOADS,
> +};
> +
> +static unsigned int features_without_offloads_legacy[] = {
> +	VIRTNET_FEATURES_WITHOUT_GUEST_OFFLOADS,
> +	VIRTIO_NET_F_GSO,
> +	VIRTIO_F_ANY_LAYOUT,
> +};
> +
>   static struct virtio_driver virtio_net_driver = {
>   	.feature_table = features,
>   	.feature_table_size = ARRAY_SIZE(features),
> @@ -3288,6 +3311,17 @@ static __init int virtio_net_driver_init(void)
>   	if (ret)
>   		goto err_dead;
>   
> +	if (!guest_offload) {
> +		virtio_net_driver.feature_table = features_without_offloads;
> +		virtio_net_driver.feature_table_size =
> +			ARRAY_SIZE(features_without_offloads);
> +
> +		virtio_net_driver.feature_table_legacy =
> +			features_without_offloads_legacy;
> +		virtio_net_driver.feature_table_size_legacy =
> +			ARRAY_SIZE(features_without_offloads_legacy);
> +	}
> +
>           ret = register_virtio_driver(&virtio_net_driver);
>   	if (ret)
>   		goto err_virtio;

