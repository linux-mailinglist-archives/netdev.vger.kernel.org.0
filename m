Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA3F2E77A2
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 11:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgL3KGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 05:06:13 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8924 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgL3KGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 05:06:12 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fec50ec0000>; Wed, 30 Dec 2020 02:05:32 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 30 Dec 2020 10:05:10 +0000
Date:   Wed, 30 Dec 2020 12:05:06 +0200
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
Message-ID: <20201230100506.GB5241@mtl-vdi-166.wap.labs.mlnx>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20201216064818.48239-13-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201216064818.48239-13-jasowang@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609322732; bh=m/7nAbij4rxFHiD4MR1btYzQfgNnqXLxxEtd2IuJjhY=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=oVjLNCAbiL9Jgy8tHQnDPDoM8abNEwxkYk8bf1gOz5lM9o7zDOYKmFvFR0/Zyezdy
         wWsb9bsh0F1Bq8PUN46FzZDktTR13zM8T7B0skQf7ZZgm21Orr7V0ruunTHqLpsl8J
         QltQT052PZNr5d7zh7ZnX7NlIsy4xpC0IkGpx76Z2SeelreszflJrRAEiDiBWCvcnv
         aEuKHdpR59c0FW0CiRjJ4G1pcdNeNcjrexwyAnBA+lnjY1pGwEfzTAWycxZRl3Fbsa
         dhnqRIr+oCgpBhyyMpJdghM6njMYUdFYhxn6LoqcCnzgKWHYYBugkrlxOIlDD44qPw
         ElE3N/0v8KMFg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 02:48:09PM +0800, Jason Wang wrote:
> Follows the vDPA support for multiple address spaces, this patch
> introduce uAPI for the userspace to know the number of virtqueue
> groups supported by the vDPA device.
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

Is this and other ioctls already supported in qemu?

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
