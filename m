Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C1E276A6F
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 09:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbgIXHQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 03:16:34 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:4616 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726929AbgIXHQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 03:16:33 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f6c47c40001>; Thu, 24 Sep 2020 00:16:20 -0700
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 24 Sep
 2020 07:16:12 +0000
Date:   Thu, 24 Sep 2020 10:16:09 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <mst@redhat.com>, <lulu@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rob.miller@broadcom.com>, <lingshan.zhu@intel.com>,
        <eperezma@redhat.com>, <hanand@xilinx.com>,
        <mhabets@solarflare.com>, <eli@mellanox.com>,
        <amorenoz@redhat.com>, <maxime.coquelin@redhat.com>,
        <stefanha@redhat.com>, <sgarzare@redhat.com>
Subject: Re: [RFC PATCH 01/24] vhost-vdpa: fix backend feature ioctls
Message-ID: <20200924071609.GA170403@mtl-vdi-166.wap.labs.mlnx>
References: <20200924032125.18619-1-jasowang@redhat.com>
 <20200924032125.18619-2-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200924032125.18619-2-jasowang@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600931780; bh=Hq/HB1LD46HOlSBJJ6vDJszx5mb2x0xfJ/VAn/pTahk=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=LehX/+OzldpSLhAjYGbH9lHAmamm8O/OIluFU+HnLmWJPYu77zD0g9y5A1XPbd+6b
         bdeHyt9L9J5daUZlBIQmzBkNGrEBbP8nnd+mISU9OpFDIaYft4TA8b/oSeRl5Z5Nsb
         2ZClpfjk4ZB5yWPEp8MOrP4yJNi6rFJvWPgRRqDBfYmJ04GDBlwkxIn7C3bUBiC2uZ
         bi6KDsWTxu/qGvC9krfQjzBReYV7P4pNs1EKUodafxwQhE0VAAZ/Wx2BFunpd0xrwB
         4T8TfaKPxzMljEswudsf0Iz12NywlD7ZLntMrTnaOv/vv54E/ISvNnrxlyk56LZqrZ
         dcXpraXzu+f8A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 11:21:02AM +0800, Jason Wang wrote:
> Commit 653055b9acd4 ("vhost-vdpa: support get/set backend features")
> introduces two malfunction backend features ioctls:
> 
> 1) the ioctls was blindly added to vring ioctl instead of vdpa device
>    ioctl
> 2) vhost_set_backend_features() was called when dev mutex has already
>    been held which will lead a deadlock
> 

I assume this patch requires some patch in qemu as well. Do you have
such patch?

> This patch fixes the above issues.
> 
> Cc: Eli Cohen <elic@nvidia.com>
> Reported-by: Zhu Lingshan <lingshan.zhu@intel.com>
> Fixes: 653055b9acd4 ("vhost-vdpa: support get/set backend features")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vhost/vdpa.c | 30 ++++++++++++++++--------------
>  1 file changed, 16 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 3fab94f88894..796fe979f997 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -353,8 +353,6 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>  	struct vdpa_callback cb;
>  	struct vhost_virtqueue *vq;
>  	struct vhost_vring_state s;
> -	u64 __user *featurep = argp;
> -	u64 features;
>  	u32 idx;
>  	long r;
>  
> @@ -381,18 +379,6 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
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
> @@ -440,8 +426,20 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>  	struct vhost_vdpa *v = filep->private_data;
>  	struct vhost_dev *d = &v->vdev;
>  	void __user *argp = (void __user *)arg;
> +	u64 __user *featurep = argp;
> +	u64 features;
>  	long r;
>  
> +	if (cmd == VHOST_SET_BACKEND_FEATURES) {
> +		r = copy_from_user(&features, featurep, sizeof(features));
> +		if (r)
> +			return r;
> +		if (features & ~VHOST_VDPA_BACKEND_FEATURES)
> +			return -EOPNOTSUPP;
> +		vhost_set_backend_features(&v->vdev, features);
> +		return 0;
> +	}
> +
>  	mutex_lock(&d->mutex);
>  
>  	switch (cmd) {
> @@ -476,6 +474,10 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>  	case VHOST_VDPA_SET_CONFIG_CALL:
>  		r = vhost_vdpa_set_config_call(v, argp);
>  		break;
> +	case VHOST_GET_BACKEND_FEATURES:
> +		features = VHOST_VDPA_BACKEND_FEATURES;
> +		r = copy_to_user(featurep, &features, sizeof(features));
> +		break;
>  	default:
>  		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
>  		if (r == -ENOIOCTLCMD)
> -- 
> 2.20.1
> 
