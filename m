Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0D3276B25
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 09:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbgIXHsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 03:48:45 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:19035 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbgIXHso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 03:48:44 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f6c4efc0000>; Thu, 24 Sep 2020 00:47:09 -0700
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 24 Sep
 2020 07:48:20 +0000
Date:   Thu, 24 Sep 2020 10:48:16 +0300
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
Subject: Re: [RFC PATCH 02/24] vhost-vdpa: fix vqs leak in vhost_vdpa_open()
Message-ID: <20200924074816.GC170403@mtl-vdi-166.wap.labs.mlnx>
References: <20200924032125.18619-1-jasowang@redhat.com>
 <20200924032125.18619-3-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200924032125.18619-3-jasowang@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600933629; bh=rNTNNkETGhPd0luFzWcBZwK95dJtpJNa49ZvIYcU5ac=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=hVgjlZ6oPWtli0dvdp+IUdd+m1SU/fPaCMDO78V1mbNMd3gr4cXF4WQ3+W31lUrcv
         yGISMw3YZTGVgn0v4Q22mmb2OFE0EkhgPd9/balo7MUdky2h1L0KaGqLM6G5Z0LpfK
         EYHlPpytHc6F4koOdryNIEZjF4cLnIoAugNP7BLvwq8cIk7L2yAUs5cx5CkfpGv/lW
         s7I+N/r/954oV01jW6v++Fbn5/LAx8D2048aF64dBi61axKko9X0aX/LTeKycmL1en
         nTY7k9GhV3S9rZjyQNKhg7idusXUiwGF965aa9GQTHlkvPh9WCWOQvpG/9knvZe4XB
         G84YAXHAqTulg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 11:21:03AM +0800, Jason Wang wrote:
> We need to free vqs during the err path after it has been allocated
> since vhost won't do that for us.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vhost/vdpa.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 796fe979f997..9c641274b9f3 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -764,6 +764,12 @@ static void vhost_vdpa_free_domain(struct vhost_vdpa *v)
>  	v->domain = NULL;
>  }
>  
> +static void vhost_vdpa_cleanup(struct vhost_vdpa *v)
> +{
> +	vhost_dev_cleanup(&v->vdev);
> +	kfree(v->vdev.vqs);
> +}
> +

Wouldn't it be cleaner to call kfree(vqs) explicilty inside
vhost_vdpa_open() in case of failure and keep the symetry of
vhost_dev_init()/vhost_dev_cleanup()?

>  static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>  {
>  	struct vhost_vdpa *v;
> @@ -809,7 +815,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>  	return 0;
>  
>  err_init_iotlb:
> -	vhost_dev_cleanup(&v->vdev);
> +	vhost_vdpa_cleanup(v);
>  err:
>  	atomic_dec(&v->opened);
>  	return r;
> @@ -840,8 +846,7 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
>  	vhost_vdpa_free_domain(v);
>  	vhost_vdpa_config_put(v);
>  	vhost_vdpa_clean_irq(v);
> -	vhost_dev_cleanup(&v->vdev);
> -	kfree(v->vdev.vqs);
> +	vhost_vdpa_cleanup(v);
>  	mutex_unlock(&d->mutex);
>  
>  	atomic_dec(&v->opened);
> -- 
> 2.20.1
> 
