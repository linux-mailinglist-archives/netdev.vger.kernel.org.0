Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153F5262544
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 04:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgIICit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 22:38:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38075 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726642AbgIICio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 22:38:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599619122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B8V/E1J+FloLvbRgdM82im9tBAuMNmHArMRMtM0VkOI=;
        b=idlO/KHXnXCq3h0H0UeulHCcABa0SmRljp9w1JadEiYGZrChUa+1rJbUN2lCsm0uRXkv4v
        Qy3XTAgWkxfVkxnTVrB63QVdZBvZf+AtgfzqzH31uodMYx8g9LyhpDLlXY1TTl+Gq0oq0r
        3DGhRnRcJtetKQplDG1hnGi3JmPgHxo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-eUh4UVXXN-StxtVZTGDaIw-1; Tue, 08 Sep 2020 22:38:40 -0400
X-MC-Unique: eUh4UVXXN-StxtVZTGDaIw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08ABF800EBB;
        Wed,  9 Sep 2020 02:38:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EEC4C60C0F;
        Wed,  9 Sep 2020 02:38:38 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id E01EA7A00C;
        Wed,  9 Sep 2020 02:38:38 +0000 (UTC)
Date:   Tue, 8 Sep 2020 22:38:37 -0400 (EDT)
From:   Jason Wang <jasowang@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Message-ID: <2104155542.16285964.1599619117641.JavaMail.zimbra@redhat.com>
In-Reply-To: <20200909022233.26559-1-lingshan.zhu@intel.com>
References: <20200909022233.26559-1-lingshan.zhu@intel.com>
Subject: Re: [PATCH] vhost: new vhost_vdpa SET/GET_BACKEND_FEATURES handlers
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.68.5.20, 10.4.195.10]
Thread-Topic: vhost: new vhost_vdpa SET/GET_BACKEND_FEATURES handlers
Thread-Index: 7zVLAssoNeH734drqaqg1blqsRLnOA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
> This commit introduced vhost_vdpa_set/get_backend_features() to
> resolve these issues:
> (1)In vhost_vdpa ioctl SET_BACKEND_FEATURES path, currect code
> would try to acquire vhost dev mutex twice
> (first shown in vhost_vdpa_unlocked_ioctl), which can lead
> to a dead lock issue.
> (2)SET_BACKEND_FEATURES was blindly added to vring ioctl instead
> of vdpa device ioctl
> 
> To resolve these issues, this commit (1)removed mutex operations
> in vhost_set_backend_features. (2)Handle ioctl
> SET/GET_BACKEND_FEATURES in vdpa ioctl. (3)introduce a new
> function vhost_net_set_backend_features() for vhost_net,
> which is a wrap of vhost_set_backend_features() with
> necessary mutex lockings.
> 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>

So this patch touches not only vhost-vDPA.

Though the function looks correct, I'd prefer you do cleanup on top of
my patches which has been tested by Eli.

Note that, vhost generic handlers tend to hold mutex by itself.

So we probably need more thought on this.

Thanks

> ---
>  drivers/vhost/net.c   |  9 ++++++++-
>  drivers/vhost/vdpa.c  | 47 ++++++++++++++++++++++++++++++-------------
>  drivers/vhost/vhost.c |  2 --
>  3 files changed, 41 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 531a00d703cd..e01da77538c8 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -1679,6 +1679,13 @@ static long vhost_net_set_owner(struct vhost_net *n)
>  	return r;
>  }
>  
> +static void vhost_net_set_backend_features(struct vhost_dev *dev, u64
> features)
> +{
> +	mutex_lock(&dev->mutex);
> +	vhost_set_backend_features(dev, features);
> +	mutex_unlock(&dev->mutex);
> +}
> +
>  static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
>  			    unsigned long arg)
>  {
> @@ -1715,7 +1722,7 @@ static long vhost_net_ioctl(struct file *f, unsigned
> int ioctl,
>  			return -EFAULT;
>  		if (features & ~VHOST_NET_BACKEND_FEATURES)
>  			return -EOPNOTSUPP;
> -		vhost_set_backend_features(&n->dev, features);
> +		vhost_net_set_backend_features(&n->dev, features);
>  		return 0;
>  	case VHOST_RESET_OWNER:
>  		return vhost_net_reset_owner(n);
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 3fab94f88894..ade33c566a81 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -344,6 +344,33 @@ static long vhost_vdpa_set_config_call(struct vhost_vdpa
> *v, u32 __user *argp)
>  	return 0;
>  }
>  
> +
> +static long vhost_vdpa_get_backend_features(void __user *argp)
> +{
> +	u64 features = VHOST_VDPA_BACKEND_FEATURES;
> +	u64 __user *featurep = argp;
> +	long r;
> +
> +	r = copy_to_user(featurep, &features, sizeof(features));
> +
> +	return r;
> +}
> +static long vhost_vdpa_set_backend_features(struct vhost_vdpa *v, void
> __user *argp)
> +{
> +	u64 __user *featurep = argp;
> +	u64 features;
> +
> +	if (copy_from_user(&features, featurep, sizeof(features)))
> +		return -EFAULT;
> +
> +	if (features & ~VHOST_VDPA_BACKEND_FEATURES)
> +		return -EOPNOTSUPP;
> +
> +	vhost_set_backend_features(&v->vdev, features);
> +
> +	return 0;
> +}
> +
>  static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>  				   void __user *argp)
>  {
> @@ -353,8 +380,6 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v,
> unsigned int cmd,
>  	struct vdpa_callback cb;
>  	struct vhost_virtqueue *vq;
>  	struct vhost_vring_state s;
> -	u64 __user *featurep = argp;
> -	u64 features;
>  	u32 idx;
>  	long r;
>  
> @@ -381,18 +406,6 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v,
> unsigned int cmd,
>  
>  		vq->last_avail_idx = vq_state.avail_index;
>  		break;
> -	case VHOST_GET_BACKEND_FEATURES:
> -		features = VHOST_VDPA_BACKEND_FEATURES;
> -		if (copy_to_user(featurep, &features, sizeof(features)))
> -			return -EFAULT;
> -		return 0;
> -	case VHOST_SET_BACKEND_FEATURES:
> -		if (copy_from_user(&features, featurep, sizeof(features)))
> -			return -EFAULT;
> -		if (features & ~VHOST_VDPA_BACKEND_FEATURES)
> -			return -EOPNOTSUPP;
> -		vhost_set_backend_features(&v->vdev, features);
> -		return 0;
>  	}
>  
>  	r = vhost_vring_ioctl(&v->vdev, cmd, argp);
> @@ -476,6 +489,12 @@ static long vhost_vdpa_unlocked_ioctl(struct file
> *filep,
>  	case VHOST_VDPA_SET_CONFIG_CALL:
>  		r = vhost_vdpa_set_config_call(v, argp);
>  		break;
> +	case VHOST_SET_BACKEND_FEATURES:
> +		r = vhost_vdpa_set_backend_features(v, argp);
> +		break;
> +	case VHOST_GET_BACKEND_FEATURES:
> +		r = vhost_vdpa_get_backend_features(argp);
> +		break;
>  	default:
>  		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
>  		if (r == -ENOIOCTLCMD)
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index b45519ca66a7..e03c9e6f058f 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2591,14 +2591,12 @@ void vhost_set_backend_features(struct vhost_dev
> *dev, u64 features)
>  	struct vhost_virtqueue *vq;
>  	int i;
>  
> -	mutex_lock(&dev->mutex);
>  	for (i = 0; i < dev->nvqs; ++i) {
>  		vq = dev->vqs[i];
>  		mutex_lock(&vq->mutex);
>  		vq->acked_backend_features = features;
>  		mutex_unlock(&vq->mutex);
>  	}
> -	mutex_unlock(&dev->mutex);
>  }
>  EXPORT_SYMBOL_GPL(vhost_set_backend_features);
>  
> --
> 2.18.4
> 
> 

