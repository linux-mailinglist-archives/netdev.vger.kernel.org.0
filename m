Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9032E709E
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 13:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgL2M0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 07:26:00 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:9593 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbgL2MZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 07:25:59 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5feb202e0000>; Tue, 29 Dec 2020 04:25:19 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 29 Dec 2020 12:24:59 +0000
Date:   Tue, 29 Dec 2020 14:24:55 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <mst@redhat.com>, <eperezma@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lulu@redhat.com>, <eli@mellanox.com>, <lingshan.zhu@intel.com>,
        <rob.miller@broadcom.com>, <stefanha@redhat.com>,
        <sgarzare@redhat.com>
Subject: Re: [PATCH 12/21] vhost-vdpa: introduce uAPI to get the number of
 virtqueue groups
Message-ID: <20201229122455.GF195479@mtl-vdi-166.wap.labs.mlnx>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20201216064818.48239-13-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201216064818.48239-13-jasowang@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609244719; bh=+8XYiEi/q5HKDzvQqa54cYO3f355IXFB+ScLRAlWPsU=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=HEIV+t0INic4qaBqWeWtT1rImVh+TVLiIuy0ssZa7v8n9braezHUy8yWm8jfhv1RP
         9O2x1pRC6cQfcfT92Nd4Zn8Yv7lsRCv4sqclt2+VwJl0YIsfZL71x45F6yf6o/mdoD
         fowN+93qOFelfgnoNVdnlBP9KyArRK+BC+WRiZDwowB3GgRQ2tO48Wp3TLXkBJ3Aj4
         65TjbJs7ZuxerySPtKqIkbU3PezcUc9gqabkZ+XjZWe4rYTgUYRpkEqTelpX+q8nKd
         /5QQgbVvukaARhEF+RXup8rHENxhubw8p65Mo/9cz0RgQoM8JPwkTNan9Bte4OFR86
         yg8gu5sglRmNg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 02:48:09PM +0800, Jason Wang wrote:
> Follows the vDPA support for multiple address spaces, this patch
> introduce uAPI for the userspace to know the number of virtqueue
> groups supported by the vDPA device.

Can you explain what exactly you mean be userspace? Is it just qemu or
is it destined to the virtio_net driver run by the qemu process?
Also can you say for what purpose?

> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vhost/vdpa.c       | 4 ++++
>  include/uapi/linux/vhost.h | 3 +++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 060d5b5b7e64..1ba5901b28e7 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -536,6 +536,10 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>  	case VHOST_VDPA_GET_VRING_NUM:
>  		r = vhost_vdpa_get_vring_num(v, argp);
>  		break;
> +	case VHOST_VDPA_GET_GROUP_NUM:
> +		r = copy_to_user(argp, &v->vdpa->ngroups,
> +				 sizeof(v->vdpa->ngroups));
> +		break;
>  	case VHOST_SET_LOG_BASE:
>  	case VHOST_SET_LOG_FD:
>  		r = -ENOIOCTLCMD;
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index 59c6c0fbaba1..8a4e6e426bbf 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -145,4 +145,7 @@
>  /* Get the valid iova range */
>  #define VHOST_VDPA_GET_IOVA_RANGE	_IOR(VHOST_VIRTIO, 0x78, \
>  					     struct vhost_vdpa_iova_range)
> +/* Get the number of virtqueue groups. */
> +#define VHOST_VDPA_GET_GROUP_NUM	_IOR(VHOST_VIRTIO, 0x79, unsigned int)
> +
>  #endif
> -- 
> 2.25.1
> 
