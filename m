Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A90D2E6F9B
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 11:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgL2KWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 05:22:08 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:16453 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbgL2KWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 05:22:07 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5feb03260000>; Tue, 29 Dec 2020 02:21:26 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 29 Dec 2020 10:21:03 +0000
Date:   Tue, 29 Dec 2020 12:20:59 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <mst@redhat.com>, <eperezma@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lulu@redhat.com>, <eli@mellanox.com>, <lingshan.zhu@intel.com>,
        <rob.miller@broadcom.com>, <stefanha@redhat.com>,
        <sgarzare@redhat.com>
Subject: Re: [PATCH 10/21] vhost: support ASID in IOTLB API
Message-ID: <20201229102059.GB195479@mtl-vdi-166.wap.labs.mlnx>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20201216064818.48239-11-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201216064818.48239-11-jasowang@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609237287; bh=tofAHIAZLSGlpLXOD0ABHSWLnadAm3VNx46BUQA75N8=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=S8b+DY6upOu3dlSkH9sfgInKfPs8y3sjgmmt1MqnWAdB6ThZ/8i15LyivStkRPTIp
         0G4RPX3CZnY59juIF3ezxSJZgfdJkJf4Gqz0gnPzEcJwHAcICDXhyMlQ9xK99+sgWU
         47GTdffyZiMRDTbDatTaeL3D0q5VNcwjfWQbto6JoJsEVrjIz3aMrbxKmiwIkkm4yh
         l5ZGnycTAKkYlgAUQkPaC1ORG+aUcLByLkoV35EG1t6zRbqJkcHKEqpCIVi0Vts3F7
         UD3G1zD62b4spf1GXGq/AUWMzLdVra5dGlWHPcmbIh3PHitwnyNp0xKOYnm3RYfVr4
         g/WG8asMeoTtw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 02:48:07PM +0800, Jason Wang wrote:
> This patches allows userspace to send ASID based IOTLB message to
> vhost. This idea is to use the reserved u32 field in the existing V2
> IOTLB message. Vhost device should advertise this capability via
> VHOST_BACKEND_F_IOTLB_ASID backend feature.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vhost/vdpa.c             |  5 ++++-
>  drivers/vhost/vhost.c            | 23 ++++++++++++++++++-----
>  drivers/vhost/vhost.h            |  4 ++--
>  include/uapi/linux/vhost_types.h |  5 ++++-
>  4 files changed, 28 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 03a9b3311c6c..feb6a58df22d 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -739,7 +739,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>  	return ret;
>  }
>  
> -static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
> +static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
>  					struct vhost_iotlb_msg *msg)
>  {
>  	struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
> @@ -748,6 +748,9 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
>  	struct vhost_iotlb *iotlb = v->iotlb;
>  	int r = 0;
>  
> +	if (asid != 0)
> +		return -EINVAL;
> +
>  	r = vhost_dev_check_owner(dev);
>  	if (r)
>  		return r;
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index a262e12c6dc2..7477b724c29b 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -468,7 +468,7 @@ void vhost_dev_init(struct vhost_dev *dev,
>  		    struct vhost_virtqueue **vqs, int nvqs,
>  		    int iov_limit, int weight, int byte_weight,
>  		    bool use_worker,
> -		    int (*msg_handler)(struct vhost_dev *dev,
> +		    int (*msg_handler)(struct vhost_dev *dev, u32 asid,
>  				       struct vhost_iotlb_msg *msg))
>  {
>  	struct vhost_virtqueue *vq;
> @@ -1084,11 +1084,14 @@ static bool umem_access_ok(u64 uaddr, u64 size, int access)
>  	return true;
>  }
>  
> -static int vhost_process_iotlb_msg(struct vhost_dev *dev,
> +static int vhost_process_iotlb_msg(struct vhost_dev *dev, u16 asid,
>  				   struct vhost_iotlb_msg *msg)
>  {
>  	int ret = 0;
>  
> +	if (asid != 0)
> +		return -EINVAL;
> +
>  	mutex_lock(&dev->mutex);
>  	vhost_dev_lock_vqs(dev);
>  	switch (msg->type) {
> @@ -1135,6 +1138,7 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
>  	struct vhost_iotlb_msg msg;
>  	size_t offset;
>  	int type, ret;
> +	u16 asid = 0;

You assume asid occupies just 16 bits. So maybe you should reserve the
other 16 bits for future extension:

struct vhost_msg_v2 {
        __u32 type;
-       __u32 reserved;
+       __u16 asid;
+       __u16 reserved;
        union {

Moreover, maybe this should be reflected in previous patches that use
the asid:

-static int mlx5_vdpa_set_map(struct vdpa_device *vdev, struct vhost_iotlb *iotlb)
+static int mlx5_vdpa_set_map(struct vdpa_device *vdev, u16 asid,
+                            struct vhost_iotlb *iotlb)

-static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
+static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u16 asid,
                                        struct vhost_iotlb_msg *msg)

etc.

>  
>  	ret = copy_from_iter(&type, sizeof(type), from);
>  	if (ret != sizeof(type)) {
> @@ -1150,7 +1154,16 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
>  		offset = offsetof(struct vhost_msg, iotlb) - sizeof(int);
>  		break;
>  	case VHOST_IOTLB_MSG_V2:
> -		offset = sizeof(__u32);
> +		if (vhost_backend_has_feature(dev->vqs[0],
> +					      VHOST_BACKEND_F_IOTLB_ASID)) {
> +			ret = copy_from_iter(&asid, sizeof(asid), from);
> +			if (ret != sizeof(asid)) {
> +				ret = -EINVAL;
> +				goto done;
> +			}
> +			offset = sizeof(__u16);
> +		} else
> +			offset = sizeof(__u32);
>  		break;
>  	default:
>  		ret = -EINVAL;
> @@ -1165,9 +1178,9 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
>  	}
>  
>  	if (dev->msg_handler)
> -		ret = dev->msg_handler(dev, &msg);
> +		ret = dev->msg_handler(dev, asid, &msg);
>  	else
> -		ret = vhost_process_iotlb_msg(dev, &msg);
> +		ret = vhost_process_iotlb_msg(dev, asid, &msg);
>  	if (ret) {
>  		ret = -EFAULT;
>  		goto done;
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index b063324c7669..19753a90875c 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -162,7 +162,7 @@ struct vhost_dev {
>  	int byte_weight;
>  	u64 kcov_handle;
>  	bool use_worker;
> -	int (*msg_handler)(struct vhost_dev *dev,
> +	int (*msg_handler)(struct vhost_dev *dev, u32 asid,
>  			   struct vhost_iotlb_msg *msg);
>  };
>  
> @@ -170,7 +170,7 @@ bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total_len);
>  void vhost_dev_init(struct vhost_dev *, struct vhost_virtqueue **vqs,
>  		    int nvqs, int iov_limit, int weight, int byte_weight,
>  		    bool use_worker,
> -		    int (*msg_handler)(struct vhost_dev *dev,
> +		    int (*msg_handler)(struct vhost_dev *dev, u32 asid,
>  				       struct vhost_iotlb_msg *msg));
>  long vhost_dev_set_owner(struct vhost_dev *dev);
>  bool vhost_dev_has_owner(struct vhost_dev *dev);
> diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
> index 76ee7016c501..222fc66ce2ac 100644
> --- a/include/uapi/linux/vhost_types.h
> +++ b/include/uapi/linux/vhost_types.h
> @@ -87,7 +87,7 @@ struct vhost_msg {
>  
>  struct vhost_msg_v2 {
>  	__u32 type;
> -	__u32 reserved;
> +	__u32 asid;
>  	union {
>  		struct vhost_iotlb_msg iotlb;
>  		__u8 padding[64];
> @@ -157,5 +157,8 @@ struct vhost_vdpa_iova_range {
>  #define VHOST_BACKEND_F_IOTLB_MSG_V2 0x1
>  /* IOTLB can accept batching hints */
>  #define VHOST_BACKEND_F_IOTLB_BATCH  0x2
> +/* IOTLB can accept address space identifier through V2 type of IOTLB
> +   message */
> +#define VHOST_BACKEND_F_IOTLB_ASID  0x3
>  
>  #endif
> -- 
> 2.25.1
> 
