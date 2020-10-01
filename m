Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D47280028
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 15:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732339AbgJAN3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 09:29:44 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9518 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731993AbgJAN3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 09:29:44 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f75d9600000>; Thu, 01 Oct 2020 06:28:00 -0700
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 1 Oct
 2020 13:29:30 +0000
Date:   Thu, 1 Oct 2020 16:29:27 +0300
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
Subject: Re: [RFC PATCH 10/24] vdpa: introduce config operations for
 associating ASID to a virtqueue group
Message-ID: <20201001132927.GC32363@mtl-vdi-166.wap.labs.mlnx>
References: <20200924032125.18619-1-jasowang@redhat.com>
 <20200924032125.18619-11-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200924032125.18619-11-jasowang@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601558880; bh=6rUIYxTqLpEGk7XTShhqnq3D5EFt6vSHTg69vpLWGeQ=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=GpLRXZyhptnP7rVs6yQIvxud1J5ga64TktlPBlbPCV7p5QPTxdlQXEvfCafEvlWad
         qKC7u7mWIk7+eStjB5Qtpgl6iJw6Ow4YEQacgYTlKj5rI+2uQ9cSQaASN2TR47dpoH
         NEYWJtXg41UvbPhmVg0Px+EDuq/y9nd5t7PzIf/KEZLCMmujay0TS1g6Mpf++ttnWZ
         gyT0b8ZZwxFKXkluCAar0+bqcJxS8ZD9jpf+gQlcrig+DZcySjRDZ4U6xg1RLTwJLg
         fdTXTh5iSg4JRRyG0M1diaxcN3UoPfdotMNi1aGDEZ1oA+69y5iR+kySog9WcZso68
         UV5kdLPfA6FtQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 11:21:11AM +0800, Jason Wang wrote:
> This patch introduces a new bus operation to allow the vDPA bus driver
> to associate an ASID to a virtqueue group.
>

So in case of virtio_net, I would expect that all the data virtqueues
will be associated with the same address space identifier. Moreover,
this assignment should be provided before the set_map call that provides
the iotlb for the address space, correct?

> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  include/linux/vdpa.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index 1e1163daa352..e2394995a3cd 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -160,6 +160,12 @@ struct vdpa_device {
>   * @get_generation:		Get device config generation (optional)
>   *				@vdev: vdpa device
>   *				Returns u32: device generation
> + * @set_group_asid:		Set address space identifier for a
> + *				virtqueue group
> + *				@vdev: vdpa device
> + *				@group: virtqueue group
> + *				@asid: address space id for this group
> + *				Returns integer: success (0) or error (< 0)
>   * @set_map:			Set device memory mapping (optional)
>   *				Needed for device that using device
>   *				specific DMA translation (on-chip IOMMU)
> @@ -237,6 +243,10 @@ struct vdpa_config_ops {
>  		       u64 iova, u64 size, u64 pa, u32 perm);
>  	int (*dma_unmap)(struct vdpa_device *vdev, unsigned int asid,
>  			 u64 iova, u64 size);
> +	int (*set_group_asid)(struct vdpa_device *vdev, unsigned int group,
> +			      unsigned int asid);
> +
> +

Extra space
>  
>  	/* Free device resources */
>  	void (*free)(struct vdpa_device *vdev);
> -- 
> 2.20.1
> 
