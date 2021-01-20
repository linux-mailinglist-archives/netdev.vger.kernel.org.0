Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601232FC997
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731506AbhATDt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 22:49:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21867 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730757AbhATDsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 22:48:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611114424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=61kBWcJtmQFIvGjS1IKO0RhJ1LrkMQqyt5uWZQ6fQwI=;
        b=P4NHjfcSD8KOO5BQ95x1Yc1YI2hgOvjWQzpXnZ2f1SCvTFlgRW6xHkJa0GXsFetw2pshxB
        pjAZ3JdLhTqSf5zgeSV3YysFZZFPlZUI6MLWs9jxkYyMHK6KfDuGjp6ebfi9Pt/IsAiVmE
        dtWDKK6f2Uzh508m1VLwRXSF25sKZ2I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-pTfqDSdGP9CR1YEzofLBAw-1; Tue, 19 Jan 2021 22:47:02 -0500
X-MC-Unique: pTfqDSdGP9CR1YEzofLBAw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD934800D53;
        Wed, 20 Jan 2021 03:47:00 +0000 (UTC)
Received: from [10.72.13.124] (ovpn-13-124.pek2.redhat.com [10.72.13.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DB3E9CA0;
        Wed, 20 Jan 2021 03:46:39 +0000 (UTC)
Subject: Re: [RFC v3 03/11] vdpa: Remove the restriction that only supports
 virtio-net devices
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        bob.liu@oracle.com, hch@infradead.org, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210119045920.447-1-xieyongji@bytedance.com>
 <20210119045920.447-4-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <310d7793-e4ff-fba3-f358-418cb64c7988@redhat.com>
Date:   Wed, 20 Jan 2021 11:46:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210119045920.447-4-xieyongji@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/19 下午12:59, Xie Yongji wrote:
> With VDUSE, we should be able to support all kinds of virtio devices.
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>   drivers/vhost/vdpa.c | 29 +++--------------------------
>   1 file changed, 3 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 29ed4173f04e..448be7875b6d 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -22,6 +22,7 @@
>   #include <linux/nospec.h>
>   #include <linux/vhost.h>
>   #include <linux/virtio_net.h>
> +#include <linux/virtio_blk.h>
>   
>   #include "vhost.h"
>   
> @@ -185,26 +186,6 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
>   	return 0;
>   }
>   
> -static int vhost_vdpa_config_validate(struct vhost_vdpa *v,
> -				      struct vhost_vdpa_config *c)
> -{
> -	long size = 0;
> -
> -	switch (v->virtio_id) {
> -	case VIRTIO_ID_NET:
> -		size = sizeof(struct virtio_net_config);
> -		break;
> -	}
> -
> -	if (c->len == 0)
> -		return -EINVAL;
> -
> -	if (c->len > size - c->off)
> -		return -E2BIG;
> -
> -	return 0;
> -}


I think we should use a separate patch for this.

Thanks


> -
>   static long vhost_vdpa_get_config(struct vhost_vdpa *v,
>   				  struct vhost_vdpa_config __user *c)
>   {
> @@ -215,7 +196,7 @@ static long vhost_vdpa_get_config(struct vhost_vdpa *v,
>   
>   	if (copy_from_user(&config, c, size))
>   		return -EFAULT;
> -	if (vhost_vdpa_config_validate(v, &config))
> +	if (config.len == 0)
>   		return -EINVAL;
>   	buf = kvzalloc(config.len, GFP_KERNEL);
>   	if (!buf)
> @@ -243,7 +224,7 @@ static long vhost_vdpa_set_config(struct vhost_vdpa *v,
>   
>   	if (copy_from_user(&config, c, size))
>   		return -EFAULT;
> -	if (vhost_vdpa_config_validate(v, &config))
> +	if (config.len == 0)
>   		return -EINVAL;
>   	buf = kvzalloc(config.len, GFP_KERNEL);
>   	if (!buf)
> @@ -1025,10 +1006,6 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
>   	int minor;
>   	int r;
>   
> -	/* Currently, we only accept the network devices. */
> -	if (ops->get_device_id(vdpa) != VIRTIO_ID_NET)
> -		return -ENOTSUPP;
> -
>   	v = kzalloc(sizeof(*v), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>   	if (!v)
>   		return -ENOMEM;

