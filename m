Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E20B2E6EC1
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 08:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgL2H3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 02:29:40 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15611 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbgL2H3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 02:29:39 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5feadaba0004>; Mon, 28 Dec 2020 23:28:58 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 29 Dec 2020 07:28:36 +0000
Date:   Tue, 29 Dec 2020 09:28:32 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <mst@redhat.com>, <eperezma@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lulu@redhat.com>, <eli@mellanox.com>, <lingshan.zhu@intel.com>,
        <rob.miller@broadcom.com>, <stefanha@redhat.com>,
        <sgarzare@redhat.com>
Subject: Re: [PATCH 07/21] vdpa: multiple address spaces support
Message-ID: <20201229072832.GA195479@mtl-vdi-166.wap.labs.mlnx>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20201216064818.48239-8-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201216064818.48239-8-jasowang@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609226938; bh=R/V0vt8/4HAt6ASEgs3+v8zsmonkQ9Vc0lRmyFgjOmU=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=djyKmMbICjK+INvH2+ql+NlPk4h9eYnmlIn0DKIMWlDi60tPaAIG2PoSkpjxLuRrU
         A0ddN4c9qFtLJTa5OZSfheO0ZC7qyeCnsWpB7tUg9iAxRg3D0Mjk+LB4QkdXgWEb+6
         5Gb+VxqQuXVBvaDf5XJdsNWDewkgA2rW7fnNSyZ3L7NN5BuJkjbqfTPE3PtfGRzUnq
         Baolo4AcLNY6EAUlwCOoQCLe6kyWtdI1DAZMtJSM0P92AlN/THKs9A/8cyLfratUGz
         jb5GktUX+O7gh2ezgFoiHj6oF3CRPPnYDRtuB245SUcgv98qwCfA+FA3Fe9/Tp66RZ
         nhZeIMDvOfVrA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 02:48:04PM +0800, Jason Wang wrote:
> This patches introduces the multiple address spaces support for vDPA
> device. This idea is to identify a specific address space via an
> dedicated identifier - ASID.
> 
> During vDPA device allocation, vDPA device driver needs to report the
> number of address spaces supported by the device then the DMA mapping
> ops of the vDPA device needs to be extended to support ASID.
> 
> This helps to isolate the environments for the virtqueue that will not
> be assigned directly. E.g in the case of virtio-net, the control
> virtqueue will not be assigned directly to guest.
> 
> As a start, simply claim 1 virtqueue groups and 1 address spaces for
> all vDPA devices. And vhost-vDPA will simply reject the device with
> more than 1 virtqueue groups or address spaces.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vdpa/ifcvf/ifcvf_main.c   |  2 +-
>  drivers/vdpa/mlx5/net/mlx5_vnet.c |  5 +++--
>  drivers/vdpa/vdpa.c               |  4 +++-
>  drivers/vdpa/vdpa_sim/vdpa_sim.c  | 10 ++++++----
>  drivers/vhost/vdpa.c              | 14 +++++++++-----
>  include/linux/vdpa.h              | 23 ++++++++++++++++-------
>  6 files changed, 38 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index c629f4fcc738..8a43f562b169 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -445,7 +445,7 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  
>  	adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
>  				    dev, &ifc_vdpa_ops,
> -				    IFCVF_MAX_QUEUE_PAIRS * 2, 1);
> +				    IFCVF_MAX_QUEUE_PAIRS * 2, 1, 1);
>  
>  	if (adapter == NULL) {
>  		IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 719b52fcc547..7aaf0a4ee80d 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1804,7 +1804,8 @@ static u32 mlx5_vdpa_get_generation(struct vdpa_device *vdev)
>  	return mvdev->generation;
>  }
>  
> -static int mlx5_vdpa_set_map(struct vdpa_device *vdev, struct vhost_iotlb *iotlb)
> +static int mlx5_vdpa_set_map(struct vdpa_device *vdev, unsigned int asid,
> +			     struct vhost_iotlb *iotlb)
>  {
>  	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
>  	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
> @@ -1947,7 +1948,7 @@ void *mlx5_vdpa_add_dev(struct mlx5_core_dev *mdev)
>  	max_vqs = min_t(u32, max_vqs, MLX5_MAX_SUPPORTED_VQS);
>  
>  	ndev = vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device, &mlx5_vdpa_ops,
> -				 2 * mlx5_vdpa_max_qps(max_vqs), 1);
> +				 2 * mlx5_vdpa_max_qps(max_vqs), 1, 1);
>  	if (IS_ERR(ndev))
>  		return ndev;
>  
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index 46399746ec7c..05195fa7865d 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -63,6 +63,7 @@ static void vdpa_release_dev(struct device *d)
>   * @config: the bus operations that is supported by this device
>   * @nvqs: number of virtqueues supported by this device
>   * @ngroups: number of groups supported by this device
> + * @nas: number of address spaces supported by this device
>   * @size: size of the parent structure that contains private data
>   *
>   * Driver should use vdpa_alloc_device() wrapper macro instead of
> @@ -74,7 +75,7 @@ static void vdpa_release_dev(struct device *d)
>  struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>  					const struct vdpa_config_ops *config,
>  					int nvqs, unsigned int ngroups,
> -					size_t size)
> +					unsigned int nas, size_t size)
>  {
>  	struct vdpa_device *vdev;
>  	int err = -EINVAL;
> @@ -102,6 +103,7 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>  	vdev->features_valid = false;
>  	vdev->nvqs = nvqs;
>  	vdev->ngroups = ngroups;
> +	vdev->nas = nas;
>  
>  	err = dev_set_name(&vdev->dev, "vdpa%u", vdev->index);
>  	if (err)
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> index 5d554b3cd152..140de45ffff2 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -359,7 +359,7 @@ static struct vdpasim *vdpasim_create(void)
>  		ops = &vdpasim_net_config_ops;
>  
>  	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
> -				    VDPASIM_VQ_NUM, 1);
> +				    VDPASIM_VQ_NUM, 1, 1);
>  	if (!vdpasim)
>  		goto err_alloc;
>  
> @@ -606,7 +606,7 @@ static struct vdpa_iova_range vdpasim_get_iova_range(struct vdpa_device *vdpa)
>  	return range;
>  }
>  
> -static int vdpasim_set_map(struct vdpa_device *vdpa,
> +static int vdpasim_set_map(struct vdpa_device *vdpa, unsigned int asid,
>  			   struct vhost_iotlb *iotlb)
>  {
>  	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> @@ -633,7 +633,8 @@ static int vdpasim_set_map(struct vdpa_device *vdpa,
>  	return ret;
>  }
>  
> -static int vdpasim_dma_map(struct vdpa_device *vdpa, u64 iova, u64 size,
> +static int vdpasim_dma_map(struct vdpa_device *vdpa, unsigned int asid,
> +			   u64 iova, u64 size,
>  			   u64 pa, u32 perm)
>  {
>  	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> @@ -647,7 +648,8 @@ static int vdpasim_dma_map(struct vdpa_device *vdpa, u64 iova, u64 size,
>  	return ret;
>  }
>  
> -static int vdpasim_dma_unmap(struct vdpa_device *vdpa, u64 iova, u64 size)
> +static int vdpasim_dma_unmap(struct vdpa_device *vdpa, unsigned int asid,
> +			     u64 iova, u64 size)
>  {
>  	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>  
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 9bcc03d4e68b..03a9b3311c6c 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -570,10 +570,10 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
>  		return r;
>  
>  	if (ops->dma_map) {
> -		r = ops->dma_map(vdpa, iova, size, pa, perm);
> +		r = ops->dma_map(vdpa, 0, iova, size, pa, perm);
>  	} else if (ops->set_map) {
>  		if (!v->in_batch)
> -			r = ops->set_map(vdpa, iotlb);
> +			r = ops->set_map(vdpa, 0, iotlb);
>  	} else {
>  		r = iommu_map(v->domain, iova, pa, size,
>  			      perm_to_iommu_flags(perm));
> @@ -597,10 +597,10 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v,
>  	vhost_vdpa_iotlb_unmap(v, iotlb, iova, iova + size - 1);
>  
>  	if (ops->dma_map) {
> -		ops->dma_unmap(vdpa, iova, size);
> +		ops->dma_unmap(vdpa, 0, iova, size);
>  	} else if (ops->set_map) {
>  		if (!v->in_batch)
> -			ops->set_map(vdpa, iotlb);
> +			ops->set_map(vdpa, 0, iotlb);
>  	} else {
>  		iommu_unmap(v->domain, iova, size);
>  	}
> @@ -764,7 +764,7 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
>  		break;
>  	case VHOST_IOTLB_BATCH_END:
>  		if (v->in_batch && ops->set_map)
> -			ops->set_map(vdpa, iotlb);
> +			ops->set_map(vdpa, 0, iotlb);
>  		v->in_batch = false;
>  		break;
>  	default:
> @@ -1032,6 +1032,10 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
>  	int minor;
>  	int r;
>  
> +	/* Only support 1 address space and 1 groups */
> +	if (vdpa->ngroups != 1 || vdpa->nas != 1)
> +		return -ENOTSUPP;
> +
>  	/* Currently, we only accept the network devices. */
>  	if (ops->get_device_id(vdpa) != VIRTIO_ID_NET)
>  		return -ENOTSUPP;
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index bfc6790b263e..0a9a754f8180 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -43,6 +43,8 @@ struct vdpa_vq_state {
>   * @index: device index
>   * @features_valid: were features initialized? for legacy guests
>   * @nvqs: the number of virtqueues
> + * @ngroups: the number of virtqueue groups
> + * @nas: the number of address spaces

I am not sure these can be categorised as part of the state of the VQ.
It's more of a property so maybe we can have a callback to get the
properties of the VQ?

Moreover, I think they should be handled in the hardware drivers to
return 1 for both ngroups and nas.

>   */
>  struct vdpa_device {
>  	struct device dev;
> @@ -52,6 +54,7 @@ struct vdpa_device {
>  	bool features_valid;
>  	int nvqs;
>  	unsigned int ngroups;
> +	unsigned int nas;
>  };
>  
>  /**
> @@ -175,6 +178,7 @@ struct vdpa_iova_range {
>   *				Needed for device that using device
>   *				specific DMA translation (on-chip IOMMU)
>   *				@vdev: vdpa device
> + *				@asid: address space identifier
>   *				@iotlb: vhost memory mapping to be
>   *				used by the vDPA
>   *				Returns integer: success (0) or error (< 0)
> @@ -183,6 +187,7 @@ struct vdpa_iova_range {
>   *				specific DMA translation (on-chip IOMMU)
>   *				and preferring incremental map.
>   *				@vdev: vdpa device
> + *				@asid: address space identifier
>   *				@iova: iova to be mapped
>   *				@size: size of the area
>   *				@pa: physical address for the map
> @@ -194,6 +199,7 @@ struct vdpa_iova_range {
>   *				specific DMA translation (on-chip IOMMU)
>   *				and preferring incremental unmap.
>   *				@vdev: vdpa device
> + *				@asid: address space identifier
>   *				@iova: iova to be unmapped
>   *				@size: size of the area
>   *				Returns integer: success (0) or error (< 0)
> @@ -240,10 +246,12 @@ struct vdpa_config_ops {
>  	struct vdpa_iova_range (*get_iova_range)(struct vdpa_device *vdev);
>  
>  	/* DMA ops */
> -	int (*set_map)(struct vdpa_device *vdev, struct vhost_iotlb *iotlb);
> -	int (*dma_map)(struct vdpa_device *vdev, u64 iova, u64 size,
> -		       u64 pa, u32 perm);
> -	int (*dma_unmap)(struct vdpa_device *vdev, u64 iova, u64 size);
> +	int (*set_map)(struct vdpa_device *vdev, unsigned int asid,
> +		       struct vhost_iotlb *iotlb);
> +	int (*dma_map)(struct vdpa_device *vdev, unsigned int asid,
> +		       u64 iova, u64 size, u64 pa, u32 perm);
> +	int (*dma_unmap)(struct vdpa_device *vdev, unsigned int asid,
> +			 u64 iova, u64 size);
>  
>  	/* Free device resources */
>  	void (*free)(struct vdpa_device *vdev);
> @@ -252,11 +260,12 @@ struct vdpa_config_ops {
>  struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>  					const struct vdpa_config_ops *config,
>  					int nvqs, unsigned int ngroups,
> -					size_t size);
> +					unsigned int nas, size_t size);
>  
> -#define vdpa_alloc_device(dev_struct, member, parent, config, nvqs, ngroups) \
> +#define vdpa_alloc_device(dev_struct, member, parent, config, nvqs, \
> +			  ngroups, nas)				    \
>  			  container_of(__vdpa_alloc_device( \
> -				       parent, config, nvqs, ngroups, \
> +				       parent, config, nvqs, ngroups, nas,  \
>  				       sizeof(dev_struct) + \
>  				       BUILD_BUG_ON_ZERO(offsetof( \
>  				       dev_struct, member))), \
> -- 
> 2.25.1
> 
