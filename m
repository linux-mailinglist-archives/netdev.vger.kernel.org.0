Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D699C357A71
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 04:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhDHChD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 22:37:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40843 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229600AbhDHChC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 22:37:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617849411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6bIDlF6/Na7KbH3uL/VJXSdSX8DFa729DboJpmqpTTo=;
        b=O8ALbZp7r4J2ziUZsU0W/xmJcUEb7rhIWED3rz5fymGVYzk7EwnIuqMapul2CSsewRJrAO
        D/8NivpTCaAmIyhDlKRlfNMygWgy4usyTfIafAuWioKeMCMCqROgrUZDrSjc8I4043+MoD
        BkN82gcpZkD/qjN6yol40jfin1Rt9TA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-LcXRj1WPM_-7o8OuYqjwTg-1; Wed, 07 Apr 2021 22:36:47 -0400
X-MC-Unique: LcXRj1WPM_-7o8OuYqjwTg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3262764157;
        Thu,  8 Apr 2021 02:36:45 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-194.pek2.redhat.com [10.72.12.194])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBE1D10013D7;
        Thu,  8 Apr 2021 02:36:31 +0000 (UTC)
Subject: Re: [PATCH v6 07/10] vdpa: Support transferring virtual addressing
 during DMA mapping
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        hch@infradead.org, christian.brauner@canonical.com,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20210331080519.172-1-xieyongji@bytedance.com>
 <20210331080519.172-8-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e9bdee99-49b1-3e3b-8769-6e8a9783c418@redhat.com>
Date:   Thu, 8 Apr 2021 10:36:30 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210331080519.172-8-xieyongji@bytedance.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/3/31 ÏÂÎç4:05, Xie Yongji Ð´µÀ:
> This patch introduces an attribute for vDPA device to indicate
> whether virtual address can be used. If vDPA device driver set
> it, vhost-vdpa bus driver will not pin user page and transfer
> userspace virtual address instead of physical address during
> DMA mapping. And corresponding vma->vm_file and offset will be
> also passed as an opaque pointer.
>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/ifcvf/ifcvf_main.c   |  2 +-
>   drivers/vdpa/mlx5/net/mlx5_vnet.c |  2 +-
>   drivers/vdpa/vdpa.c               |  9 +++-
>   drivers/vdpa/vdpa_sim/vdpa_sim.c  |  2 +-
>   drivers/vdpa/virtio_pci/vp_vdpa.c |  2 +-
>   drivers/vhost/vdpa.c              | 99 ++++++++++++++++++++++++++++++++++-----
>   include/linux/vdpa.h              | 19 ++++++--
>   7 files changed, 116 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index d555a6a5d1ba..aee013f3eb5f 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -431,7 +431,7 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   	}
>   
>   	adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
> -				    dev, &ifc_vdpa_ops, NULL);
> +				    dev, &ifc_vdpa_ops, NULL, false);
>   	if (adapter == NULL) {
>   		IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
>   		return -ENOMEM;
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 71397fdafa6a..fb62ebcf464a 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1982,7 +1982,7 @@ static int mlx5v_probe(struct auxiliary_device *adev,
>   	max_vqs = min_t(u32, max_vqs, MLX5_MAX_SUPPORTED_VQS);
>   
>   	ndev = vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device, &mlx5_vdpa_ops,
> -				 NULL);
> +				 NULL, false);
>   	if (IS_ERR(ndev))
>   		return PTR_ERR(ndev);
>   
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index 5cffce67cab0..97fbac276c72 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -71,6 +71,7 @@ static void vdpa_release_dev(struct device *d)
>    * @config: the bus operations that is supported by this device
>    * @size: size of the parent structure that contains private data
>    * @name: name of the vdpa device; optional.
> + * @use_va: indicate whether virtual address must be used by this device
>    *
>    * Driver should use vdpa_alloc_device() wrapper macro instead of
>    * using this directly.
> @@ -80,7 +81,8 @@ static void vdpa_release_dev(struct device *d)
>    */
>   struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>   					const struct vdpa_config_ops *config,
> -					size_t size, const char *name)
> +					size_t size, const char *name,
> +					bool use_va)
>   {
>   	struct vdpa_device *vdev;
>   	int err = -EINVAL;
> @@ -91,6 +93,10 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>   	if (!!config->dma_map != !!config->dma_unmap)
>   		goto err;
>   
> +	/* It should only work for the device that use on-chip IOMMU */
> +	if (use_va && !(config->dma_map || config->set_map))
> +		goto err;
> +
>   	err = -ENOMEM;
>   	vdev = kzalloc(size, GFP_KERNEL);
>   	if (!vdev)
> @@ -106,6 +112,7 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>   	vdev->index = err;
>   	vdev->config = config;
>   	vdev->features_valid = false;
> +	vdev->use_va = use_va;
>   
>   	if (name)
>   		err = dev_set_name(&vdev->dev, "%s", name);
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> index ff331f088baf..d26334e9a412 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -235,7 +235,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
>   		ops = &vdpasim_config_ops;
>   
>   	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
> -				    dev_attr->name);
> +				    dev_attr->name, false);
>   	if (!vdpasim)
>   		goto err_alloc;
>   
> diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
> index 1321a2fcd088..03b36aed48d6 100644
> --- a/drivers/vdpa/virtio_pci/vp_vdpa.c
> +++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
> @@ -377,7 +377,7 @@ static int vp_vdpa_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   		return ret;
>   
>   	vp_vdpa = vdpa_alloc_device(struct vp_vdpa, vdpa,
> -				    dev, &vp_vdpa_ops, NULL);
> +				    dev, &vp_vdpa_ops, NULL, false);
>   	if (vp_vdpa == NULL) {
>   		dev_err(dev, "vp_vdpa: Failed to allocate vDPA structure\n");
>   		return -ENOMEM;
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index f9aab9013745..613ea400e0e5 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -505,8 +505,28 @@ static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, u64 start, u64 last)
>   	}
>   }
>   
> +static void vhost_vdpa_va_unmap(struct vhost_vdpa *v, u64 start, u64 last)
> +{
> +	struct vhost_dev *dev = &v->vdev;
> +	struct vhost_iotlb *iotlb = dev->iotlb;
> +	struct vhost_iotlb_map *map;
> +	struct vdpa_map_file *map_file;
> +
> +	while ((map = vhost_iotlb_itree_first(iotlb, start, last)) != NULL) {
> +		map_file = (struct vdpa_map_file *)map->opaque;
> +		fput(map_file->file);
> +		kfree(map_file);
> +		vhost_iotlb_map_free(iotlb, map);
> +	}
> +}
> +
>   static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 last)
>   {
> +	struct vdpa_device *vdpa = v->vdpa;
> +
> +	if (vdpa->use_va)
> +		return vhost_vdpa_va_unmap(v, start, last);
> +
>   	return vhost_vdpa_pa_unmap(v, start, last);
>   }
>   
> @@ -541,21 +561,21 @@ static int perm_to_iommu_flags(u32 perm)
>   	return flags | IOMMU_CACHE;
>   }
>   
> -static int vhost_vdpa_map(struct vhost_vdpa *v,
> -			  u64 iova, u64 size, u64 pa, u32 perm)
> +static int vhost_vdpa_map(struct vhost_vdpa *v, u64 iova,
> +			  u64 size, u64 pa, u32 perm, void *opaque)
>   {
>   	struct vhost_dev *dev = &v->vdev;
>   	struct vdpa_device *vdpa = v->vdpa;
>   	const struct vdpa_config_ops *ops = vdpa->config;
>   	int r = 0;
>   
> -	r = vhost_iotlb_add_range(dev->iotlb, iova, iova + size - 1,
> -				  pa, perm);
> +	r = vhost_iotlb_add_range_ctx(dev->iotlb, iova, iova + size - 1,
> +				      pa, perm, opaque);
>   	if (r)
>   		return r;
>   
>   	if (ops->dma_map) {
> -		r = ops->dma_map(vdpa, iova, size, pa, perm, NULL);
> +		r = ops->dma_map(vdpa, iova, size, pa, perm, opaque);
>   	} else if (ops->set_map) {
>   		if (!v->in_batch)
>   			r = ops->set_map(vdpa, dev->iotlb);
> @@ -563,13 +583,15 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
>   		r = iommu_map(v->domain, iova, pa, size,
>   			      perm_to_iommu_flags(perm));
>   	}
> -
> -	if (r)
> +	if (r) {
>   		vhost_iotlb_del_range(dev->iotlb, iova, iova + size - 1);
> -	else
> +		return r;
> +	}
> +
> +	if (!vdpa->use_va)
>   		atomic64_add(size >> PAGE_SHIFT, &dev->mm->pinned_vm);
>   
> -	return r;
> +	return 0;
>   }
>   
>   static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size)
> @@ -590,6 +612,56 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size)
>   	}
>   }
>   
> +static int vhost_vdpa_va_map(struct vhost_vdpa *v,
> +			     u64 iova, u64 size, u64 uaddr, u32 perm)
> +{
> +	struct vhost_dev *dev = &v->vdev;
> +	u64 offset, map_size, map_iova = iova;
> +	struct vdpa_map_file *map_file;
> +	struct vm_area_struct *vma;
> +	int ret;
> +
> +	mmap_read_lock(dev->mm);
> +
> +	while (size) {
> +		vma = find_vma(dev->mm, uaddr);
> +		if (!vma) {
> +			ret = -EINVAL;
> +			break;
> +		}
> +		map_size = min(size, vma->vm_end - uaddr);
> +		if (!(vma->vm_file && (vma->vm_flags & VM_SHARED) &&
> +			!(vma->vm_flags & (VM_IO | VM_PFNMAP))))
> +			goto next;
> +
> +		map_file = kzalloc(sizeof(*map_file), GFP_KERNEL);
> +		if (!map_file) {
> +			ret = -ENOMEM;
> +			break;
> +		}
> +		offset = (vma->vm_pgoff << PAGE_SHIFT) + uaddr - vma->vm_start;
> +		map_file->offset = offset;
> +		map_file->file = get_file(vma->vm_file);
> +		ret = vhost_vdpa_map(v, map_iova, map_size, uaddr,
> +				     perm, map_file);
> +		if (ret) {
> +			fput(map_file->file);
> +			kfree(map_file);
> +			break;
> +		}
> +next:
> +		size -= map_size;
> +		uaddr += map_size;
> +		map_iova += map_size;
> +	}
> +	if (ret)
> +		vhost_vdpa_unmap(v, iova, map_iova - iova);
> +
> +	mmap_read_unlock(dev->mm);
> +
> +	return ret;
> +}
> +
>   static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
>   			     u64 iova, u64 size, u64 uaddr, u32 perm)
>   {
> @@ -656,7 +728,7 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
>   				csize = (last_pfn - map_pfn + 1) << PAGE_SHIFT;
>   				ret = vhost_vdpa_map(v, iova, csize,
>   						     map_pfn << PAGE_SHIFT,
> -						     perm);
> +						     perm, NULL);
>   				if (ret) {
>   					/*
>   					 * Unpin the pages that are left unmapped
> @@ -685,7 +757,7 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
>   
>   	/* Pin the rest chunk */
>   	ret = vhost_vdpa_map(v, iova, (last_pfn - map_pfn + 1) << PAGE_SHIFT,
> -			     map_pfn << PAGE_SHIFT, perm);
> +			     map_pfn << PAGE_SHIFT, perm, NULL);
>   out:
>   	if (ret) {
>   		if (nchunks) {
> @@ -718,6 +790,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>   					   struct vhost_iotlb_msg *msg)
>   {
>   	struct vhost_dev *dev = &v->vdev;
> +	struct vdpa_device *vdpa = v->vdpa;
>   	struct vhost_iotlb *iotlb = dev->iotlb;
>   
>   	if (msg->iova < v->range.first ||
> @@ -728,6 +801,10 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>   				    msg->iova + msg->size - 1))
>   		return -EEXIST;
>   
> +	if (vdpa->use_va)
> +		return vhost_vdpa_va_map(v, msg->iova, msg->size,
> +					 msg->uaddr, msg->perm);
> +
>   	return vhost_vdpa_pa_map(v, msg->iova, msg->size, msg->uaddr,
>   				 msg->perm);
>   }
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index b01f7c9096bf..e67404e4b23e 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -44,6 +44,7 @@ struct vdpa_mgmt_dev;
>    * @config: the configuration ops for this device.
>    * @index: device index
>    * @features_valid: were features initialized? for legacy guests
> + * @use_va: indicate whether virtual address must be used by this device
>    * @nvqs: maximum number of supported virtqueues
>    * @mdev: management device pointer; caller must setup when registering device as part
>    *	  of dev_add() mgmtdev ops callback before invoking _vdpa_register_device().
> @@ -54,6 +55,7 @@ struct vdpa_device {
>   	const struct vdpa_config_ops *config;
>   	unsigned int index;
>   	bool features_valid;
> +	bool use_va;
>   	int nvqs;
>   	struct vdpa_mgmt_dev *mdev;
>   };
> @@ -69,6 +71,16 @@ struct vdpa_iova_range {
>   };
>   
>   /**
> + * Corresponding file area for device memory mapping
> + * @file: vma->vm_file for the mapping
> + * @offset: mapping offset in the vm_file
> + */
> +struct vdpa_map_file {
> +	struct file *file;
> +	u64 offset;
> +};
> +
> +/**
>    * vDPA_config_ops - operations for configuring a vDPA device.
>    * Note: vDPA device drivers are required to implement all of the
>    * operations unless it is mentioned to be optional in the following
> @@ -250,14 +262,15 @@ struct vdpa_config_ops {
>   
>   struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>   					const struct vdpa_config_ops *config,
> -					size_t size, const char *name);
> +					size_t size, const char *name,
> +					bool use_va);
>   
> -#define vdpa_alloc_device(dev_struct, member, parent, config, name)   \
> +#define vdpa_alloc_device(dev_struct, member, parent, config, name, use_va)   \
>   			  container_of(__vdpa_alloc_device( \
>   				       parent, config, \
>   				       sizeof(dev_struct) + \
>   				       BUILD_BUG_ON_ZERO(offsetof( \
> -				       dev_struct, member)), name), \
> +				       dev_struct, member)), name, use_va), \
>   				       dev_struct, member)
>   
>   int vdpa_register_device(struct vdpa_device *vdev, int nvqs);

