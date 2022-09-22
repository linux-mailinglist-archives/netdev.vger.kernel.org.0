Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25545E5825
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 03:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbiIVBjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 21:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiIVBjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 21:39:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F141903B
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 18:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663810774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TyylI6S78D0to8KJOV4qn2CDFp5MIulvTk/8RhI9Ulo=;
        b=hwFu2xaDdbuweyQJ9j3JEDU1bKUYj0+1AObNjge3MH+BxA0nJBq5sVm5W64ZlZh2/g8abK
        v086yEf+TbhRjuXhQwNYftPA2/WCXeKD1e+93DM+bXBP1LPhynBRCGZjEwE5myT9Wrl112
        0wI10WbzFaaQMdCUYLO8npdXq7QqB24=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-331-0V1UVBBTPsWanSKAt9O_aw-1; Wed, 21 Sep 2022 21:39:32 -0400
X-MC-Unique: 0V1UVBBTPsWanSKAt9O_aw-1
Received: by mail-pg1-f198.google.com with SMTP id l72-20020a63914b000000b00434ac6f8214so4396312pge.13
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 18:39:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=TyylI6S78D0to8KJOV4qn2CDFp5MIulvTk/8RhI9Ulo=;
        b=bL8e1rIT5nT1GiwDST8XmxjJh8+/cSlQ/+gisSvTwDBsMdarYdT+VppoxtQMFdhmLu
         WZwTWSI10yx52ki+cG0yCW0JMfd3wv7tjhITQnwYntnrJI8kYptJWzAp61offSsHLPXJ
         2z2jHZ5Fzy95x+rNhV2ECkWq6ibuBzNHg0Gbg871G1IGcXcTBOcI4t82UL7Ruk3opPIW
         friFtUiE5hYgMCa8BpV5yPsm3nCkQfWG5VudvqGumFa+GRbo5r53XRuADv3CejuTF4zc
         w2LnHiD76dp0hjLo0NAPCLj76lWIAOT1bUvyplczIyPhTPPF2uAWFuo2t4ifYO0N7iwL
         DPFA==
X-Gm-Message-State: ACrzQf15BJZJiU7HK2yJwBnmfw3PHVwALARlWTc+kqlKfsxYXzL4HO6f
        b56rKMByQVMVx0iig44DUlBaMCgayfu5qX0ZA9VWU9OAiomRkWDm/U/6pY9RvqoDtgiC+UPGGKg
        ZdfCbG3f6r9kGTdZo
X-Received: by 2002:a17:90b:3843:b0:202:df54:4c10 with SMTP id nl3-20020a17090b384300b00202df544c10mr1061623pjb.100.1663810771716;
        Wed, 21 Sep 2022 18:39:31 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6oFwx6a3DI+cicj7tL8pB2twl8+JQcb9PbYq2RXcEBMLEV3v3tVv9iJA92MJX2lydUK7QqOA==
X-Received: by 2002:a17:90b:3843:b0:202:df54:4c10 with SMTP id nl3-20020a17090b384300b00202df544c10mr1061600pjb.100.1663810771419;
        Wed, 21 Sep 2022 18:39:31 -0700 (PDT)
Received: from [10.72.13.82] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id k18-20020aa79732000000b00545832dd969sm2908568pfg.145.2022.09.21.18.39.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 18:39:30 -0700 (PDT)
Message-ID: <5bab74d1-64fe-423c-32e8-c0047577bb68@redhat.com>
Date:   Thu, 22 Sep 2022 09:39:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v6 1/2] virtio-net: introduce and use helper function for
 guest gso support checks
Content-Language: en-US
To:     Gavin Li <gavinl@nvidia.com>, mst@redhat.com,
        stephen@networkplumber.org, davem@davemloft.net,
        jesse.brandeburg@intel.com, kuba@kernel.org,
        sridhar.samudrala@intel.com, loseweigh@gmail.com,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        virtio-dev@lists.oasis-open.org
Cc:     Gavi Teitz <gavi@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
References: <20220914144911.56422-1-gavinl@nvidia.com>
 <20220914144911.56422-2-gavinl@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220914144911.56422-2-gavinl@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/9/14 22:49, Gavin Li 写道:
> Probe routine is already several hundred lines.
> Use helper function for guest gso support check.
>
> Signed-off-by: Gavin Li <gavinl@nvidia.com>
> Reviewed-by: Gavi Teitz <gavi@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
> changelog:
> v4->v5
> - Addressed comments from Michael S. Tsirkin
> - Remove unnecessary () in return clause
> v1->v2
> - Add new patch
> ---
>   drivers/net/virtio_net.c | 13 +++++++++----
>   1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index e0e57083d442..f54c7182758f 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3682,6 +3682,14 @@ static int virtnet_validate(struct virtio_device *vdev)
>   	return 0;
>   }
>   
> +static bool virtnet_check_guest_gso(const struct virtnet_info *vi)
> +{
> +	return virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> +		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
> +		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
> +		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO);
> +}
> +
>   static int virtnet_probe(struct virtio_device *vdev)
>   {
>   	int i, err = -ENOMEM;
> @@ -3777,10 +3785,7 @@ static int virtnet_probe(struct virtio_device *vdev)
>   	spin_lock_init(&vi->refill_lock);
>   
>   	/* If we can receive ANY GSO packets, we must allocate large ones. */
> -	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> -	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6) ||
> -	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_ECN) ||
> -	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_UFO))
> +	if (virtnet_check_guest_gso(vi))
>   		vi->big_packets = true;
>   
>   	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))

