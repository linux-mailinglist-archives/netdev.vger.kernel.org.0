Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5CE322A93
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 13:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbhBWMdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 07:33:53 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:7256 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232525AbhBWMdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 07:33:51 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6034f6060001>; Tue, 23 Feb 2021 04:33:10 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 23 Feb 2021 12:33:08 +0000
Date:   Tue, 23 Feb 2021 14:33:04 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     <jasowang@redhat.com>, <si-wei.liu@oracle.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, Parav Pandit <parav@nvidia.com>
Subject: Re: [PATCH v2] vdpa/mlx5: Enable user to add/delete vdpa device
Message-ID: <20210223123304.GA170700@mtl-vdi-166.wap.labs.mlnx>
References: <20210218074157.43220-1-elic@nvidia.com>
 <20210223072847-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210223072847-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614083590; bh=YxDhSJSVzAS3teGejlIlXaZPFD1rA9h5SnuIxAPr8J4=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=UbURpHyCBYD62NKnwRJQS6dxeNdZtkRYSAlpaZrj7BM2A7pZBlca9vSL3L1G8BWjZ
         1Q+ZD6jYrFaqEzbVtnUk1kPEXg7w6Ha1BpQ+qjcrKxJchec9gv0HNEtGm54fMg65q8
         TQ0lvMgpu5CcCNWnfP+pd2wECMueKjqCY5B0STr3ruaZ8UyEq2TBXG15mNURq9Fnas
         lX/pMdsMgFzWdkUm2sB2bDca/WywXj+hL/PGjdHVvKcBHKU8ZKB903bcGXhhheQtpQ
         0sv/QbVPkD8i/5RzEBG7qD0vduRfvWTk0VleljgQiXdZSFz1e66my+9RValX0VLmR8
         0etYc3IBMyvtw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 07:29:32AM -0500, Michael S. Tsirkin wrote:
> On Thu, Feb 18, 2021 at 09:41:57AM +0200, Eli Cohen wrote:
> > Allow to control vdpa device creation and destruction using the vdpa
> > management tool.
> > 
> > Examples:
> > 1. List the management devices
> > $ vdpa mgmtdev show
> > pci/0000:3b:00.1:
> >   supported_classes net
> > 
> > 2. Create vdpa instance
> > $ vdpa dev add mgmtdev pci/0000:3b:00.1 name vdpa0
> > 
> > 3. Show vdpa devices
> > $ vdpa dev show
> > vdpa0: type network mgmtdev pci/0000:3b:00.1 vendor_id 5555 max_vqs 16 \
> > max_vq_size 256
> > 
> > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > Reviewed-by: Parav Pandit <parav@nvidia.com>
> 
> Not sure which tree this is for, I could not apply this.
> 

Depends on Parav's vdpa tool patches. We'll send the entire series again
- Parav's and my patches.

> > ---
> > v0->v1:
> > set mgtdev->ndev NULL on dev delete
> > v1->v2: Resend
> > 
> >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 79 +++++++++++++++++++++++++++----
> >  1 file changed, 70 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > index a51b0f86afe2..08fb481ddc4f 100644
> > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > @@ -1974,23 +1974,32 @@ static void init_mvqs(struct mlx5_vdpa_net *ndev)
> >  	}
> >  }
> >  
> > -static int mlx5v_probe(struct auxiliary_device *adev,
> > -		       const struct auxiliary_device_id *id)
> > +struct mlx5_vdpa_mgmtdev {
> > +	struct vdpa_mgmt_dev mgtdev;
> > +	struct mlx5_adev *madev;
> > +	struct mlx5_vdpa_net *ndev;
> > +};
> > +
> > +static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name)
> >  {
> > -	struct mlx5_adev *madev = container_of(adev, struct mlx5_adev, adev);
> > -	struct mlx5_core_dev *mdev = madev->mdev;
> > +	struct mlx5_vdpa_mgmtdev *mgtdev = container_of(v_mdev, struct mlx5_vdpa_mgmtdev, mgtdev);
> >  	struct virtio_net_config *config;
> >  	struct mlx5_vdpa_dev *mvdev;
> >  	struct mlx5_vdpa_net *ndev;
> > +	struct mlx5_core_dev *mdev;
> >  	u32 max_vqs;
> >  	int err;
> >  
> > +	if (mgtdev->ndev)
> > +		return -ENOSPC;
> > +
> > +	mdev = mgtdev->madev->mdev;
> >  	/* we save one virtqueue for control virtqueue should we require it */
> >  	max_vqs = MLX5_CAP_DEV_VDPA_EMULATION(mdev, max_num_virtio_queues);
> >  	max_vqs = min_t(u32, max_vqs, MLX5_MAX_SUPPORTED_VQS);
> >  
> >  	ndev = vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device, &mlx5_vdpa_ops,
> > -				 2 * mlx5_vdpa_max_qps(max_vqs), NULL);
> > +				 2 * mlx5_vdpa_max_qps(max_vqs), name);
> >  	if (IS_ERR(ndev))
> >  		return PTR_ERR(ndev);
> >  
> > @@ -2018,11 +2027,12 @@ static int mlx5v_probe(struct auxiliary_device *adev,
> >  	if (err)
> >  		goto err_res;
> >  
> > -	err = vdpa_register_device(&mvdev->vdev);
> > +	mvdev->vdev.mdev = &mgtdev->mgtdev;
> > +	err = _vdpa_register_device(&mvdev->vdev);
> >  	if (err)
> >  		goto err_reg;
> >  
> > -	dev_set_drvdata(&adev->dev, ndev);
> > +	mgtdev->ndev = ndev;
> >  	return 0;
> >  
> >  err_reg:
> > @@ -2035,11 +2045,62 @@ static int mlx5v_probe(struct auxiliary_device *adev,
> >  	return err;
> >  }
> >  
> > +static void mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *dev)
> > +{
> > +	struct mlx5_vdpa_mgmtdev *mgtdev = container_of(v_mdev, struct mlx5_vdpa_mgmtdev, mgtdev);
> > +
> > +	_vdpa_unregister_device(dev);
> > +	mgtdev->ndev = NULL;
> > +}
> > +
> > +static const struct vdpa_mgmtdev_ops mdev_ops = {
> > +	.dev_add = mlx5_vdpa_dev_add,
> > +	.dev_del = mlx5_vdpa_dev_del,
> > +};
> > +
> > +static struct virtio_device_id id_table[] = {
> > +	{ VIRTIO_ID_NET, VIRTIO_DEV_ANY_ID },
> > +	{ 0 },
> > +};
> > +
> > +static int mlx5v_probe(struct auxiliary_device *adev,
> > +		       const struct auxiliary_device_id *id)
> > +
> > +{
> > +	struct mlx5_adev *madev = container_of(adev, struct mlx5_adev, adev);
> > +	struct mlx5_core_dev *mdev = madev->mdev;
> > +	struct mlx5_vdpa_mgmtdev *mgtdev;
> > +	int err;
> > +
> > +	mgtdev = kzalloc(sizeof(*mgtdev), GFP_KERNEL);
> > +	if (!mgtdev)
> > +		return -ENOMEM;
> > +
> > +	mgtdev->mgtdev.ops = &mdev_ops;
> > +	mgtdev->mgtdev.device = mdev->device;
> > +	mgtdev->mgtdev.id_table = id_table;
> > +	mgtdev->madev = madev;
> > +
> > +	err = vdpa_mgmtdev_register(&mgtdev->mgtdev);
> > +	if (err)
> > +		goto reg_err;
> > +
> > +	dev_set_drvdata(&adev->dev, mgtdev);
> > +
> > +	return 0;
> > +
> > +reg_err:
> > +	kfree(mdev);
> > +	return err;
> > +}
> > +
> >  static void mlx5v_remove(struct auxiliary_device *adev)
> >  {
> > -	struct mlx5_vdpa_dev *mvdev = dev_get_drvdata(&adev->dev);
> > +	struct mlx5_vdpa_mgmtdev *mgtdev;
> >  
> > -	vdpa_unregister_device(&mvdev->vdev);
> > +	mgtdev = dev_get_drvdata(&adev->dev);
> > +	vdpa_mgmtdev_unregister(&mgtdev->mgtdev);
> > +	kfree(mgtdev);
> >  }
> >  
> >  static const struct auxiliary_device_id mlx5v_id_table[] = {
> > -- 
> > 2.29.2
> 
