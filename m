Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6207C322440
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 03:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhBWCmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 21:42:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30121 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230144AbhBWCmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 21:42:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614048056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9zPDpbJNZdQ9hi/5YT6ebJh2aTRbwiJFCyJYts7Zasc=;
        b=FVpeH/QwP1UuCH6TVrC9k+CBOJi4FcHebsRxTVQ5xpz1p8QRNbtzkNV7Qw6KKofxGMqw0h
        FpteocaN8fEobMCeQPI09uBU2ZGMlUbOds1OsYeWO+QlnhuDVU4T4zCkuIDGopK+dE2FFs
        ZbxnFSSKOXEm3qwRW93TW4Zsbg8QmC0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-WEOsLhA2PXChyEjD8HQpQQ-1; Mon, 22 Feb 2021 21:40:54 -0500
X-MC-Unique: WEOsLhA2PXChyEjD8HQpQQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD3991868405;
        Tue, 23 Feb 2021 02:40:52 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-175.pek2.redhat.com [10.72.13.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 283F75D74F;
        Tue, 23 Feb 2021 02:40:46 +0000 (UTC)
Subject: Re: [PATCH 2/2 v1] vdpa/mlx5: Enable user to add/delete vdpa device
To:     Eli Cohen <elic@nvidia.com>, mst@redhat.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     Parav Pandit <parav@nvidia.com>
References: <20210217113136.10215-1-elic@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ffee8558-e34f-310d-39a1-36b6615f9a92@redhat.com>
Date:   Tue, 23 Feb 2021 10:40:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210217113136.10215-1-elic@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/17 7:31 下午, Eli Cohen wrote:
> Allow to control vdpa device creation and destruction using the vdpa
> management tool.
>
> Examples:
> 1. List the management devices
> $ vdpa mgmtdev show
> pci/0000:3b:00.1:
>    supported_classes net
>
> 2. Create vdpa instance
> $ vdpa dev add mgmtdev pci/0000:3b:00.1 name vdpa0
>
> 3. Show vdpa devices
> $ vdpa dev show
> vdpa0: type network mgmtdev pci/0000:3b:00.1 vendor_id 5555 max_vqs 16 \
> max_vq_size 256
>
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
> v0->v1:
> set mgtdev->ndev NULL on dev delete
>
>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 79 +++++++++++++++++++++++++++----
>   1 file changed, 70 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index a51b0f86afe2..08fb481ddc4f 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1974,23 +1974,32 @@ static void init_mvqs(struct mlx5_vdpa_net *ndev)
>   	}
>   }
>   
> -static int mlx5v_probe(struct auxiliary_device *adev,
> -		       const struct auxiliary_device_id *id)
> +struct mlx5_vdpa_mgmtdev {
> +	struct vdpa_mgmt_dev mgtdev;
> +	struct mlx5_adev *madev;
> +	struct mlx5_vdpa_net *ndev;
> +};
> +
> +static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name)
>   {
> -	struct mlx5_adev *madev = container_of(adev, struct mlx5_adev, adev);
> -	struct mlx5_core_dev *mdev = madev->mdev;
> +	struct mlx5_vdpa_mgmtdev *mgtdev = container_of(v_mdev, struct mlx5_vdpa_mgmtdev, mgtdev);
>   	struct virtio_net_config *config;
>   	struct mlx5_vdpa_dev *mvdev;
>   	struct mlx5_vdpa_net *ndev;
> +	struct mlx5_core_dev *mdev;
>   	u32 max_vqs;
>   	int err;
>   
> +	if (mgtdev->ndev)
> +		return -ENOSPC;
> +
> +	mdev = mgtdev->madev->mdev;
>   	/* we save one virtqueue for control virtqueue should we require it */
>   	max_vqs = MLX5_CAP_DEV_VDPA_EMULATION(mdev, max_num_virtio_queues);
>   	max_vqs = min_t(u32, max_vqs, MLX5_MAX_SUPPORTED_VQS);
>   
>   	ndev = vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device, &mlx5_vdpa_ops,
> -				 2 * mlx5_vdpa_max_qps(max_vqs), NULL);
> +				 2 * mlx5_vdpa_max_qps(max_vqs), name);
>   	if (IS_ERR(ndev))
>   		return PTR_ERR(ndev);
>   
> @@ -2018,11 +2027,12 @@ static int mlx5v_probe(struct auxiliary_device *adev,
>   	if (err)
>   		goto err_res;
>   
> -	err = vdpa_register_device(&mvdev->vdev);
> +	mvdev->vdev.mdev = &mgtdev->mgtdev;
> +	err = _vdpa_register_device(&mvdev->vdev);
>   	if (err)
>   		goto err_reg;
>   
> -	dev_set_drvdata(&adev->dev, ndev);
> +	mgtdev->ndev = ndev;
>   	return 0;
>   
>   err_reg:
> @@ -2035,11 +2045,62 @@ static int mlx5v_probe(struct auxiliary_device *adev,
>   	return err;
>   }
>   
> +static void mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *dev)
> +{
> +	struct mlx5_vdpa_mgmtdev *mgtdev = container_of(v_mdev, struct mlx5_vdpa_mgmtdev, mgtdev);
> +
> +	_vdpa_unregister_device(dev);
> +	mgtdev->ndev = NULL;
> +}
> +
> +static const struct vdpa_mgmtdev_ops mdev_ops = {
> +	.dev_add = mlx5_vdpa_dev_add,
> +	.dev_del = mlx5_vdpa_dev_del,
> +};
> +
> +static struct virtio_device_id id_table[] = {
> +	{ VIRTIO_ID_NET, VIRTIO_DEV_ANY_ID },
> +	{ 0 },
> +};
> +
> +static int mlx5v_probe(struct auxiliary_device *adev,
> +		       const struct auxiliary_device_id *id)
> +
> +{
> +	struct mlx5_adev *madev = container_of(adev, struct mlx5_adev, adev);
> +	struct mlx5_core_dev *mdev = madev->mdev;
> +	struct mlx5_vdpa_mgmtdev *mgtdev;
> +	int err;
> +
> +	mgtdev = kzalloc(sizeof(*mgtdev), GFP_KERNEL);
> +	if (!mgtdev)
> +		return -ENOMEM;
> +
> +	mgtdev->mgtdev.ops = &mdev_ops;
> +	mgtdev->mgtdev.device = mdev->device;
> +	mgtdev->mgtdev.id_table = id_table;
> +	mgtdev->madev = madev;
> +
> +	err = vdpa_mgmtdev_register(&mgtdev->mgtdev);
> +	if (err)
> +		goto reg_err;
> +
> +	dev_set_drvdata(&adev->dev, mgtdev);
> +
> +	return 0;
> +
> +reg_err:
> +	kfree(mdev);
> +	return err;
> +}
> +
>   static void mlx5v_remove(struct auxiliary_device *adev)
>   {
> -	struct mlx5_vdpa_dev *mvdev = dev_get_drvdata(&adev->dev);
> +	struct mlx5_vdpa_mgmtdev *mgtdev;
>   
> -	vdpa_unregister_device(&mvdev->vdev);
> +	mgtdev = dev_get_drvdata(&adev->dev);
> +	vdpa_mgmtdev_unregister(&mgtdev->mgtdev);
> +	kfree(mgtdev);
>   }
>   
>   static const struct auxiliary_device_id mlx5v_id_table[] = {

