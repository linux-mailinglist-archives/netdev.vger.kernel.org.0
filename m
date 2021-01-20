Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0D82FC994
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbhATDrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 22:47:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46121 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731542AbhATDqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 22:46:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611114274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BHJzsbGQ3zxMDMbJJfdomjMvNc/E1eGKV+czPVXzYNc=;
        b=cU2LU63/dKTtn2SfSQjtJYrVfutH/Pj8vm7EbsjUw1QyGpA9UoDGbpZe5LD9wmvXV0gFW8
        403TTatXPPhBHXkiJl9ZaYgSR+pCjashSEMgUod4jSJnP5nFnSVXBcWMR0WkPBSK9r0I4V
        +r2gUNe94UQxv60f6fL7dnJBBE/i6rI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-MChJ_65cNhSYzTRY33kfEQ-1; Tue, 19 Jan 2021 22:44:33 -0500
X-MC-Unique: MChJ_65cNhSYzTRY33kfEQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1D3A800D53;
        Wed, 20 Jan 2021 03:44:30 +0000 (UTC)
Received: from [10.72.13.124] (ovpn-13-124.pek2.redhat.com [10.72.13.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8FDF760C9C;
        Wed, 20 Jan 2021 03:44:19 +0000 (UTC)
Subject: Re: [RFC v3 04/11] vhost-vdpa: protect concurrent access to vhost
 device iotlb
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        bob.liu@oracle.com, hch@infradead.org, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210119045920.447-1-xieyongji@bytedance.com>
 <20210119045920.447-5-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8fbcb4c3-a09a-a00a-97e2-dde0a03be5a9@redhat.com>
Date:   Wed, 20 Jan 2021 11:44:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210119045920.447-5-xieyongji@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/19 下午12:59, Xie Yongji wrote:
> Introduce a mutex to protect vhost device iotlb from
> concurrent access.
>
> Fixes: 4c8cf318("vhost: introduce vDPA-based backend")
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>   drivers/vhost/vdpa.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 448be7875b6d..4a241d380c40 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -49,6 +49,7 @@ struct vhost_vdpa {
>   	struct eventfd_ctx *config_ctx;
>   	int in_batch;
>   	struct vdpa_iova_range range;
> +	struct mutex mutex;


Let's use the device mutex like what vhost_process_iotlb_msg() did.

Thanks


>   };
>   
>   static DEFINE_IDA(vhost_vdpa_ida);
> @@ -728,6 +729,7 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
>   	if (r)
>   		return r;
>   
> +	mutex_lock(&v->mutex);
>   	switch (msg->type) {
>   	case VHOST_IOTLB_UPDATE:
>   		r = vhost_vdpa_process_iotlb_update(v, msg);
> @@ -747,6 +749,7 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
>   		r = -EINVAL;
>   		break;
>   	}
> +	mutex_unlock(&v->mutex);
>   
>   	return r;
>   }
> @@ -1017,6 +1020,7 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
>   		return minor;
>   	}
>   
> +	mutex_init(&v->mutex);
>   	atomic_set(&v->opened, 0);
>   	v->minor = minor;
>   	v->vdpa = vdpa;

