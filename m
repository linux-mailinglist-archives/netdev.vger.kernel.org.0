Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5887C2F124C
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 13:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbhAKM1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 07:27:08 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10748 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbhAKM1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 07:27:07 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffc43f20003>; Mon, 11 Jan 2021 04:26:26 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Mon, 11 Jan 2021 12:26:05 +0000
Date:   Mon, 11 Jan 2021 14:26:01 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <mst@redhat.com>, <eperezma@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lulu@redhat.com>, <eli@mellanox.com>, <lingshan.zhu@intel.com>,
        <rob.miller@broadcom.com>, <stefanha@redhat.com>,
        <sgarzare@redhat.com>
Subject: Re: [PATCH 21/21] vdpasim: control virtqueue support
Message-ID: <20210111122601.GA172492@mtl-vdi-166.wap.labs.mlnx>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20201216064818.48239-22-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201216064818.48239-22-jasowang@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610367986; bh=aFZhEFS/pkMLS92pBZ9tVAB3w2LwuMJJjhpkKeMn7fY=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=FS1RT6X6rPcQNuvqxDCG24FkjdA5RYTP59v6PevrJHBrbbaJq9f2++GdDfgJNx88u
         y8+hMwQ4QEvJxCV4ZzMYAJdMSaudt4CQkhtVTuzMP2kXu8dXRfwIo8rG0NHJ1XVVwr
         uMXHcu+OV1rwkwpun44dAkMe8HAUeZ+5Qs5V/y9evaJ8QYytbQLO5Yhm3lY8legUwh
         uhQWeLeYZDKtiQJIqBqzeactAjyOm0LSMWh84oo22oDB/xOT9gJOKC4JiX79BpzEHo
         VTTTnXeaEbje+UkPST974TWe2SL23vUg9DU7r4co8qMzXpVHQutZ4ZwR0Lse+IyeDS
         rnYEMYvM6GL9g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 02:48:18PM +0800, Jason Wang wrote:
> This patch introduces the control virtqueue support for vDPA
> simulator. This is a requirement for supporting advanced features like
> multiqueue.
> 
> A requirement for control virtqueue is to isolate its memory access
> from the rx/tx virtqueues. This is because when using vDPA device
> for VM, the control virqueue is not directly assigned to VM. Userspace
> (Qemu) will present a shadow control virtqueue to control for
> recording the device states.
> 
> The isolation is done via the virtqueue groups and ASID support in
> vDPA through vhost-vdpa. The simulator is extended to have:
> 
> 1) three virtqueues: RXVQ, TXVQ and CVQ (control virtqueue)
> 2) two virtqueue groups: group 0 contains RXVQ and TXVQ; group 1
>    contains CVQ
> 3) two address spaces and the simulator simply implements the address
>    spaces by mapping it 1:1 to IOTLB.
> 
> For the VM use cases, userspace(Qemu) may set AS 0 to group 0 and AS 1
> to group 1. So we have:
> 
> 1) The IOTLB for virtqueue group 0 contains the mappings of guest, so
>    RX and TX can be assigned to guest directly.
> 2) The IOTLB for virtqueue group 1 contains the mappings of CVQ which
>    is the buffers that allocated and managed by VMM only. So CVQ of
>    vhost-vdpa is visible to VMM only. And Guest can not access the CVQ
>    of vhost-vdpa.
> 
> For the other use cases, since AS 0 is associated to all virtqueue
> groups by default. All virtqueues share the same mapping by default.
> 
> To demonstrate the function, VIRITO_NET_F_CTRL_MACADDR is
> implemented in the simulator for the driver to set mac address.
> 

Hi Jason,

is there any version of qemu/libvirt available that I can see the
control virtqueue working in action?

> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vdpa/vdpa_sim/vdpa_sim.c | 189 +++++++++++++++++++++++++++----
>  1 file changed, 166 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> index fe90a783bde4..0fd06ac491cd 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -60,14 +60,18 @@ struct vdpasim_virtqueue {
>  #define VDPASIM_QUEUE_MAX 256
>  #define VDPASIM_DEVICE_ID 0x1
>  #define VDPASIM_VENDOR_ID 0
> -#define VDPASIM_VQ_NUM 0x2
> +#define VDPASIM_VQ_NUM 0x3
> +#define VDPASIM_AS_NUM 0x2
> +#define VDPASIM_GROUP_NUM 0x2
>  #define VDPASIM_NAME "vdpasim-netdev"
>  
>  static u64 vdpasim_features = (1ULL << VIRTIO_F_ANY_LAYOUT) |
>  			      (1ULL << VIRTIO_F_VERSION_1)  |
>  			      (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
> +			      (1ULL << VIRTIO_NET_F_MTU) |
>  			      (1ULL << VIRTIO_NET_F_MAC) |
> -			      (1ULL << VIRTIO_NET_F_MTU);
> +			      (1ULL << VIRTIO_NET_F_CTRL_VQ) |
> +			      (1ULL << VIRTIO_NET_F_CTRL_MAC_ADDR);
>  
>  /* State of each vdpasim device */
>  struct vdpasim {
> @@ -147,11 +151,17 @@ static void vdpasim_reset(struct vdpasim *vdpasim)
>  {
>  	int i;
>  
> -	for (i = 0; i < VDPASIM_VQ_NUM; i++)
> +	spin_lock(&vdpasim->iommu_lock);
> +
> +	for (i = 0; i < VDPASIM_VQ_NUM; i++) {
>  		vdpasim_vq_reset(&vdpasim->vqs[i]);
> +		vringh_set_iotlb(&vdpasim->vqs[i].vring,
> +				 &vdpasim->iommu[0]);
> +	}
>  
> -	spin_lock(&vdpasim->iommu_lock);
> -	vhost_iotlb_reset(vdpasim->iommu);
> +	for (i = 0; i < VDPASIM_AS_NUM; i++) {
> +		vhost_iotlb_reset(&vdpasim->iommu[i]);
> +	}
>  	spin_unlock(&vdpasim->iommu_lock);
>  
>  	vdpasim->features = 0;
> @@ -191,6 +201,81 @@ static bool receive_filter(struct vdpasim *vdpasim, size_t len)
>  	return false;
>  }
>  
> +virtio_net_ctrl_ack vdpasim_handle_ctrl_mac(struct vdpasim *vdpasim,
> +					    u8 cmd)
> +{
> +	struct vdpasim_virtqueue *cvq = &vdpasim->vqs[2];
> +	virtio_net_ctrl_ack status = VIRTIO_NET_ERR;
> +	size_t read;
> +
> +	switch (cmd) {
> +	case VIRTIO_NET_CTRL_MAC_ADDR_SET:
> +		read = vringh_iov_pull_iotlb(&cvq->vring, &cvq->in_iov,
> +					     (void *)vdpasim->config.mac,
> +					     ETH_ALEN);
> +		if (read == ETH_ALEN)
> +			status = VIRTIO_NET_OK;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return status;
> +}
> +
> +static void vdpasim_handle_cvq(struct vdpasim *vdpasim)
> +{
> +	struct vdpasim_virtqueue *cvq = &vdpasim->vqs[2];
> +	virtio_net_ctrl_ack status = VIRTIO_NET_ERR;
> +	struct virtio_net_ctrl_hdr ctrl;
> +	size_t read, write;
> +	int err;
> +
> +	if (!(vdpasim->features & (1ULL << VIRTIO_NET_F_CTRL_VQ)))
> +		return;
> +
> +	if (!cvq->ready)
> +		return;
> +
> +	while (true) {
> +		err = vringh_getdesc_iotlb(&cvq->vring, &cvq->in_iov,
> +					   &cvq->out_iov,
> +					   &cvq->head, GFP_ATOMIC);
> +		if (err <= 0)
> +			break;
> +
> +		read = vringh_iov_pull_iotlb(&cvq->vring, &cvq->in_iov, &ctrl,
> +					     sizeof(ctrl));
> +		if (read != sizeof(ctrl))
> +			break;
> +
> +		switch (ctrl.class) {
> +		case VIRTIO_NET_CTRL_MAC:
> +			status = vdpasim_handle_ctrl_mac(vdpasim, ctrl.cmd);
> +			break;
> +		default:
> +			break;
> +		}
> +
> +		/* Make sure data is wrote before advancing index */
> +		smp_wmb();
> +
> +		write = vringh_iov_push_iotlb(&cvq->vring, &cvq->out_iov,
> +					      &status, sizeof (status));
> +		vringh_complete_iotlb(&cvq->vring, cvq->head, write);
> +		vringh_kiov_cleanup(&cvq->in_iov);
> +		vringh_kiov_cleanup(&cvq->out_iov);
> +
> +		/* Make sure used is visible before rasing the interrupt. */
> +		smp_wmb();
> +
> +		local_bh_disable();
> +		if (cvq->cb)
> +			cvq->cb(cvq->private);
> +		local_bh_enable();
> +	}
> +}
> +
>  static void vdpasim_work(struct work_struct *work)
>  {
>  	struct vdpasim *vdpasim = container_of(work, struct
> @@ -276,7 +361,7 @@ static dma_addr_t vdpasim_map_page(struct device *dev, struct page *page,
>  				   unsigned long attrs)
>  {
>  	struct vdpasim *vdpasim = dev_to_sim(dev);
> -	struct vhost_iotlb *iommu = vdpasim->iommu;
> +	struct vhost_iotlb *iommu = &vdpasim->iommu[0];
>  	u64 pa = (page_to_pfn(page) << PAGE_SHIFT) + offset;
>  	int ret, perm = dir_to_perm(dir);
>  
> @@ -301,7 +386,7 @@ static void vdpasim_unmap_page(struct device *dev, dma_addr_t dma_addr,
>  			       unsigned long attrs)
>  {
>  	struct vdpasim *vdpasim = dev_to_sim(dev);
> -	struct vhost_iotlb *iommu = vdpasim->iommu;
> +	struct vhost_iotlb *iommu = &vdpasim->iommu[0];
>  
>  	spin_lock(&vdpasim->iommu_lock);
>  	vhost_iotlb_del_range(iommu, (u64)dma_addr,
> @@ -314,7 +399,7 @@ static void *vdpasim_alloc_coherent(struct device *dev, size_t size,
>  				    unsigned long attrs)
>  {
>  	struct vdpasim *vdpasim = dev_to_sim(dev);
> -	struct vhost_iotlb *iommu = vdpasim->iommu;
> +	struct vhost_iotlb *iommu = &vdpasim->iommu[0];
>  	void *addr = kmalloc(size, flag);
>  	int ret;
>  
> @@ -344,7 +429,7 @@ static void vdpasim_free_coherent(struct device *dev, size_t size,
>  				  unsigned long attrs)
>  {
>  	struct vdpasim *vdpasim = dev_to_sim(dev);
> -	struct vhost_iotlb *iommu = vdpasim->iommu;
> +	struct vhost_iotlb *iommu = &vdpasim->iommu[0];
>  
>  	spin_lock(&vdpasim->iommu_lock);
>  	vhost_iotlb_del_range(iommu, (u64)dma_addr,
> @@ -370,14 +455,17 @@ static struct vdpasim *vdpasim_create(void)
>  	struct vdpasim *vdpasim;
>  	struct device *dev;
>  	int ret = -ENOMEM;
> +	int i;
>  
>  	if (batch_mapping)
>  		ops = &vdpasim_net_batch_config_ops;
>  	else
>  		ops = &vdpasim_net_config_ops;
>  
> +	/* 3 virtqueues, 2 address spaces, 2 virtqueue groups */
>  	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
> -				    VDPASIM_VQ_NUM, 1, 1);
> +				    VDPASIM_VQ_NUM, VDPASIM_AS_NUM,
> +				    VDPASIM_GROUP_NUM);
>  	if (!vdpasim)
>  		goto err_alloc;
>  
> @@ -391,10 +479,14 @@ static struct vdpasim *vdpasim_create(void)
>  		goto err_iommu;
>  	set_dma_ops(dev, &vdpasim_dma_ops);
>  
> -	vdpasim->iommu = vhost_iotlb_alloc(2048, 0);
> +	vdpasim->iommu = kmalloc_array(VDPASIM_AS_NUM,
> +				       sizeof(*vdpasim->iommu), GFP_KERNEL);
>  	if (!vdpasim->iommu)
>  		goto err_iommu;
>  
> +	for (i = 0; i < VDPASIM_AS_NUM; i++)
> +		vhost_iotlb_init(&vdpasim->iommu[i], 0, 0);
> +
>  	vdpasim->buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
>  	if (!vdpasim->buffer)
>  		goto err_iommu;
> @@ -409,8 +501,9 @@ static struct vdpasim *vdpasim_create(void)
>  		eth_random_addr(vdpasim->config.mac);
>  	}
>  
> -	vringh_set_iotlb(&vdpasim->vqs[0].vring, vdpasim->iommu);
> -	vringh_set_iotlb(&vdpasim->vqs[1].vring, vdpasim->iommu);
> +	/* Make sure that default ASID is zero */
> +	for (i = 0; i < VDPASIM_VQ_NUM; i++)
> +		vringh_set_iotlb(&vdpasim->vqs[i].vring, &vdpasim->iommu[0]);
>  
>  	vdpasim->vdpa.dma_dev = dev;
>  	ret = vdpa_register_device(&vdpasim->vdpa);
> @@ -452,7 +545,14 @@ static void vdpasim_kick_vq(struct vdpa_device *vdpa, u16 idx)
>  	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>  	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
>  
> -	if (vq->ready)
> +	if (idx == 2) {
> +		/* Kernel virtio driver will do busy waiting for the
> +		 * result, so we can't handle cvq in the workqueue.
> +		 */
> +		spin_lock(&vdpasim->lock);
> +		vdpasim_handle_cvq(vdpasim);
> +		spin_unlock(&vdpasim->lock);
> +	} else if (vq->ready)
>  		schedule_work(&vdpasim->work);
>  }
>  
> @@ -518,7 +618,11 @@ static u32 vdpasim_get_vq_align(struct vdpa_device *vdpa)
>  
>  static u32 vdpasim_get_vq_group(struct vdpa_device *vdpa, u16 idx)
>  {
> -	return 0;
> +	/* RX and TX belongs to group 0, CVQ belongs to group 1 */
> +	if (idx == 2)
> +		return 1;
> +	else
> +		return 0;
>  }
>  
>  static u64 vdpasim_get_features(struct vdpa_device *vdpa)
> @@ -624,20 +728,52 @@ static struct vdpa_iova_range vdpasim_get_iova_range(struct vdpa_device *vdpa)
>  	return range;
>  }
>  
> +int vdpasim_set_group_asid(struct vdpa_device *vdpa, unsigned int group,
> +			   unsigned int asid)
> +{
> +	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +	struct vhost_iotlb *iommu;
> +	int i;
> +
> +	if (group > VDPASIM_GROUP_NUM)
> +		return -EINVAL;
> +
> +	if (asid > VDPASIM_AS_NUM)
> +		return -EINVAL;
> +
> +	iommu = &vdpasim->iommu[asid];
> +
> +	spin_lock(&vdpasim->lock);
> +
> +	for (i = 0; i < VDPASIM_VQ_NUM; i++)
> +		if (vdpasim_get_vq_group(vdpa, i) == group)
> +			vringh_set_iotlb(&vdpasim->vqs[i].vring, iommu);
> +
> +	spin_unlock(&vdpasim->lock);
> +
> +	return 0;
> +}
> +
>  static int vdpasim_set_map(struct vdpa_device *vdpa, unsigned int asid,
>  			   struct vhost_iotlb *iotlb)
>  {
>  	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>  	struct vhost_iotlb_map *map;
> +	struct vhost_iotlb *iommu;
>  	u64 start = 0ULL, last = 0ULL - 1;
>  	int ret;
>  
> +	if (asid >= VDPASIM_AS_NUM)
> +		return -EINVAL;
> +
>  	spin_lock(&vdpasim->iommu_lock);
> -	vhost_iotlb_reset(vdpasim->iommu);
> +
> +	iommu = &vdpasim->iommu[asid];
> +	vhost_iotlb_reset(iommu);
>  
>  	for (map = vhost_iotlb_itree_first(iotlb, start, last); map;
>  	     map = vhost_iotlb_itree_next(map, start, last)) {
> -		ret = vhost_iotlb_add_range(vdpasim->iommu, map->start,
> +		ret = vhost_iotlb_add_range(iommu, map->start,
>  					    map->last, map->addr, map->perm);
>  		if (ret)
>  			goto err;
> @@ -646,7 +782,7 @@ static int vdpasim_set_map(struct vdpa_device *vdpa, unsigned int asid,
>  	return 0;
>  
>  err:
> -	vhost_iotlb_reset(vdpasim->iommu);
> +	vhost_iotlb_reset(iommu);
>  	spin_unlock(&vdpasim->iommu_lock);
>  	return ret;
>  }
> @@ -658,9 +794,12 @@ static int vdpasim_dma_map(struct vdpa_device *vdpa, unsigned int asid,
>  	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>  	int ret;
>  
> +	if (asid >= VDPASIM_AS_NUM)
> +		return -EINVAL;
> +
>  	spin_lock(&vdpasim->iommu_lock);
> -	ret = vhost_iotlb_add_range(vdpasim->iommu, iova, iova + size - 1, pa,
> -				    perm);
> +	ret = vhost_iotlb_add_range(&vdpasim->iommu[asid], iova,
> +				    iova + size - 1, pa, perm);
>  	spin_unlock(&vdpasim->iommu_lock);
>  
>  	return ret;
> @@ -671,8 +810,11 @@ static int vdpasim_dma_unmap(struct vdpa_device *vdpa, unsigned int asid,
>  {
>  	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>  
> +	if (asid >= VDPASIM_AS_NUM)
> +		return -EINVAL;
> +
>  	spin_lock(&vdpasim->iommu_lock);
> -	vhost_iotlb_del_range(vdpasim->iommu, iova, iova + size - 1);
> +	vhost_iotlb_del_range(&vdpasim->iommu[asid], iova, iova + size - 1);
>  	spin_unlock(&vdpasim->iommu_lock);
>  
>  	return 0;
> @@ -684,8 +826,7 @@ static void vdpasim_free(struct vdpa_device *vdpa)
>  
>  	cancel_work_sync(&vdpasim->work);
>  	kfree(vdpasim->buffer);
> -	if (vdpasim->iommu)
> -		vhost_iotlb_free(vdpasim->iommu);
> +	vhost_iotlb_free(vdpasim->iommu);
>  }
>  
>  static const struct vdpa_config_ops vdpasim_net_config_ops = {
> @@ -711,6 +852,7 @@ static const struct vdpa_config_ops vdpasim_net_config_ops = {
>  	.set_config             = vdpasim_set_config,
>  	.get_generation         = vdpasim_get_generation,
>  	.get_iova_range         = vdpasim_get_iova_range,
> +	.set_group_asid         = vdpasim_set_group_asid,
>  	.dma_map                = vdpasim_dma_map,
>  	.dma_unmap              = vdpasim_dma_unmap,
>  	.free                   = vdpasim_free,
> @@ -739,6 +881,7 @@ static const struct vdpa_config_ops vdpasim_net_batch_config_ops = {
>  	.set_config             = vdpasim_set_config,
>  	.get_generation         = vdpasim_get_generation,
>  	.get_iova_range         = vdpasim_get_iova_range,
> +	.set_group_asid         = vdpasim_set_group_asid,
>  	.set_map                = vdpasim_set_map,
>  	.free                   = vdpasim_free,
>  };
> -- 
> 2.25.1
> 
