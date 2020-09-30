Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094B627E823
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 14:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729584AbgI3MCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 08:02:21 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:11095 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728235AbgI3MCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 08:02:20 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7473990002>; Wed, 30 Sep 2020 05:01:29 -0700
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 30 Sep
 2020 12:02:06 +0000
Date:   Wed, 30 Sep 2020 15:02:02 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <mst@redhat.com>, <lulu@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rob.miller@broadcom.com>, <lingshan.zhu@intel.com>,
        <eperezma@redhat.com>, <hanand@xilinx.com>,
        <mhabets@solarflare.com>, <elic@nvidia.com>, <amorenoz@redhat.com>,
        <maxime.coquelin@redhat.com>, <stefanha@redhat.com>,
        <sgarzare@redhat.com>
Subject: Re: [RFC PATCH 06/24] vhost-vdpa: switch to use vhost-vdpa specific
 IOTLB
Message-ID: <20200930120202.GA229518@mtl-vdi-166.wap.labs.mlnx>
References: <20200924032125.18619-1-jasowang@redhat.com>
 <20200924032125.18619-7-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200924032125.18619-7-jasowang@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601467289; bh=HTWvti/vuxtKoYKzUD6BxgnjRBPp9SCs9dRrrQvaN+c=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=FVu00aG3ONgcRFrBmD7zJd8ni1KmaI0rxs/mH8LJzd74Y4kLlSvizri95M/muuVm7
         XSs2w3M5mZG/Vm9aBREZPBmOGHF4X8T+9DfbKBg/rxQWP3I0d9dTF2ym3W2YIAYDeD
         ZDabCWv5vzTEjbNbsG8JbZ+PEjM1AeuCEilCKCYpRXW1mZDoSIonUclkyDSrK10oLa
         cgWFnl2UcRrtKiaaewi3k9sz89p3M6q22jmOJ4FU0HWqOcmGc0JKtGV/y4Qi8wjqk8
         tQZqXeIdZTHsxiw+wqKCdNnpQb9IL1ztePuGxy8aq+mSfMIja2rP8c2Ue8wKVieYFh
         xiRgekRLah/Xg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 11:21:07AM +0800, Jason Wang wrote:
> To ease the implementation of per group ASID support for vDPA
> device. This patch switches to use a vhost-vdpa specific IOTLB to
> avoid the unnecessary refactoring of the vhost core.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vhost/vdpa.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 74bef1c15a70..ec3c94f706c1 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -40,6 +40,7 @@ struct vhost_vdpa {
>  	struct vhost_virtqueue *vqs;
>  	struct completion completion;
>  	struct vdpa_device *vdpa;
> +	struct vhost_iotlb *iotlb;
>  	struct device dev;
>  	struct cdev cdev;
>  	atomic_t opened;
> @@ -514,12 +515,11 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
>  
>  static void vhost_vdpa_iotlb_free(struct vhost_vdpa *v)
>  {
> -	struct vhost_dev *dev = &v->vdev;
> -	struct vhost_iotlb *iotlb = dev->iotlb;
> +	struct vhost_iotlb *iotlb = v->iotlb;
>  
>  	vhost_vdpa_iotlb_unmap(v, iotlb, 0ULL, 0ULL - 1);
> -	kfree(dev->iotlb);
> -	dev->iotlb = NULL;
> +	kfree(v->iotlb);
> +	v->iotlb = NULL;
>  }
>  
>  static int perm_to_iommu_flags(u32 perm)
> @@ -681,7 +681,7 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
>  	struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
>  	struct vdpa_device *vdpa = v->vdpa;
>  	const struct vdpa_config_ops *ops = vdpa->config;
> -	struct vhost_iotlb *iotlb = dev->iotlb;
> +	struct vhost_iotlb *iotlb = v->iotlb;
>  	int r = 0;
>  
>  	r = vhost_dev_check_owner(dev);
> @@ -812,12 +812,14 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>  
>  	r = vhost_vdpa_alloc_domain(v);
>  	if (r)
> -		goto err_init_iotlb;
> +		goto err_alloc_domain;

You're still using this:
dev->iotlb = vhost_iotlb_alloc(0, 0);

Shouldn't you use
v->iotlb = host_iotlb_alloc(0, 0);

to set the vdpa device iotlb field?

>  
>  	filep->private_data = v;
>  
>  	return 0;
>  
> +err_alloc_domain:
> +	vhost_vdpa_iotlb_free(v);
>  err_init_iotlb:
>  	vhost_vdpa_cleanup(v);
>  err:
> -- 
> 2.20.1
> 
