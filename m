Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0385D347092
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 05:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbhCXEqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 00:46:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43200 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232727AbhCXEp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 00:45:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616561155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wHehOERrAJPJrkG9TfBBSJhEhdYmMieQY+5EDb8k3i4=;
        b=BM0mlFnDW6figb306KnfI+2PgikU2rz6dUPV3OF+NAry9f8oD6DM17vr/LWQknc1obMH3O
        GTGc8UmrL2xPl1jknwLAoz/oImxujm2Y6odbCcABq9UdkD6JOKcPu+J74Qj4nQBw6Epr9N
        if5K1OhmpFAWFPn58P/ciGkT1IcVJKI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-SfJEFJOPPBi6Wzkb3Ah2iA-1; Wed, 24 Mar 2021 00:45:53 -0400
X-MC-Unique: SfJEFJOPPBi6Wzkb3Ah2iA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7E20107ACCD;
        Wed, 24 Mar 2021 04:45:51 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-134.pek2.redhat.com [10.72.12.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D6F35D9CA;
        Wed, 24 Mar 2021 04:45:37 +0000 (UTC)
Subject: Re: [PATCH v5 10/11] vduse: Add config interrupt support
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        bob.liu@oracle.com, hch@infradead.org, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20210315053721.189-1-xieyongji@bytedance.com>
 <20210315053721.189-11-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9a2835b1-1f0e-5646-6c77-524e6ccdc613@redhat.com>
Date:   Wed, 24 Mar 2021 12:45:35 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210315053721.189-11-xieyongji@bytedance.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/3/15 ÏÂÎç1:37, Xie Yongji Ð´µÀ:
> This patch introduces a new ioctl VDUSE_INJECT_CONFIG_IRQ
> to support injecting config interrupt.
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>


I suggest to squash this into path 9.

Other looks good.

Thanks


> ---
>   drivers/vdpa/vdpa_user/vduse_dev.c | 24 +++++++++++++++++++++++-
>   include/uapi/linux/vduse.h         |  3 +++
>   2 files changed, 26 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
> index 07d0ae92d470..cc12b58bdc09 100644
> --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> @@ -64,6 +64,8 @@ struct vduse_dev {
>   	struct list_head send_list;
>   	struct list_head recv_list;
>   	struct list_head list;
> +	struct vdpa_callback config_cb;
> +	spinlock_t irq_lock;
>   	bool connected;
>   	int minor;
>   	u16 vq_size_max;
> @@ -439,6 +441,11 @@ static void vduse_dev_reset(struct vduse_dev *dev)
>   	vduse_domain_reset_bounce_map(dev->domain);
>   	vduse_dev_update_iotlb(dev, 0ULL, ULLONG_MAX);
>   
> +	spin_lock(&dev->irq_lock);
> +	dev->config_cb.callback = NULL;
> +	dev->config_cb.private = NULL;
> +	spin_unlock(&dev->irq_lock);
> +
>   	for (i = 0; i < dev->vq_num; i++) {
>   		struct vduse_virtqueue *vq = &dev->vqs[i];
>   
> @@ -557,7 +564,12 @@ static int vduse_vdpa_set_features(struct vdpa_device *vdpa, u64 features)
>   static void vduse_vdpa_set_config_cb(struct vdpa_device *vdpa,
>   				  struct vdpa_callback *cb)
>   {
> -	/* We don't support config interrupt */
> +	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
> +
> +	spin_lock(&dev->irq_lock);
> +	dev->config_cb.callback = cb->callback;
> +	dev->config_cb.private = cb->private;
> +	spin_unlock(&dev->irq_lock);
>   }
>   
>   static u16 vduse_vdpa_get_vq_num_max(struct vdpa_device *vdpa)
> @@ -842,6 +854,15 @@ static long vduse_dev_ioctl(struct file *file, unsigned int cmd,
>   		ret = 0;
>   		queue_work(vduse_irq_wq, &dev->vqs[arg].inject);
>   		break;
> +	case VDUSE_INJECT_CONFIG_IRQ:
> +		ret = -EINVAL;
> +		spin_lock_irq(&dev->irq_lock);
> +		if (dev->config_cb.callback) {
> +			dev->config_cb.callback(dev->config_cb.private);
> +			ret = 0;
> +		}
> +		spin_unlock_irq(&dev->irq_lock);
> +		break;
>   	default:
>   		ret = -ENOIOCTLCMD;
>   		break;
> @@ -918,6 +939,7 @@ static struct vduse_dev *vduse_dev_create(void)
>   	INIT_LIST_HEAD(&dev->send_list);
>   	INIT_LIST_HEAD(&dev->recv_list);
>   	atomic64_set(&dev->msg_unique, 0);
> +	spin_lock_init(&dev->irq_lock);
>   
>   	init_waitqueue_head(&dev->waitq);
>   
> diff --git a/include/uapi/linux/vduse.h b/include/uapi/linux/vduse.h
> index 37f7d7059aa8..337e766f5622 100644
> --- a/include/uapi/linux/vduse.h
> +++ b/include/uapi/linux/vduse.h
> @@ -150,4 +150,7 @@ struct vduse_vq_eventfd {
>   /* Inject an interrupt for specific virtqueue */
>   #define VDUSE_INJECT_VQ_IRQ	_IO(VDUSE_BASE, 0x05)
>   
> +/* Inject a config interrupt */
> +#define VDUSE_INJECT_CONFIG_IRQ	_IO(VDUSE_BASE, 0x06)
> +
>   #endif /* _UAPI_VDUSE_H_ */

