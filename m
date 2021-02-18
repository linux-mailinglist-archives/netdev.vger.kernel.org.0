Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA9031E6DB
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 08:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhBRHUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 02:20:48 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11968 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbhBRHNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 02:13:44 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602e132a0003>; Wed, 17 Feb 2021 23:11:38 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 18 Feb 2021 07:11:36 +0000
Date:   Thu, 18 Feb 2021 09:11:33 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     <jasowang@redhat.com>, <si-wei.liu@oracle.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, Parav Pandit <parav@nvidia.com>
Subject: Re: [PATCH 2/2 v1] vdpa/mlx5: Enable user to add/delete vdpa device
Message-ID: <20210218071133.GA174998@mtl-vdi-166.wap.labs.mlnx>
References: <20210217113136.10215-1-elic@nvidia.com>
 <20210217121315-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210217121315-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613632298; bh=xw9huqWbeDspVAD8DJrF7bRBMcq1jhn7EkZ5VV/beVU=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=qEf9rFywCfO/USLszDI8EeBefaraTFdzQAfAj8QB9EHGezn9aA8fmB01JQeB8dHL/
         J2KsNdFsc6BQBV4LxL+RejAVqVww9LgPbzAoelAIzEQm1rBNTRKQQVwdyPRsj2V6YY
         gzfmvcNSdslrh5WcDL7gD7HeO+5Kpxk4ekVIPO1HnvPyVt/aHHz5hrieBZSUmpN75F
         eYR0sBPjbz0jLYEyOi1ZQaSV5jmTweGM7nrDFu+VkcCW4zAxmalw1f1r06gvalcsa9
         HWgiC8Sw1pcZKp56QjdFwyeQgPt/JrNlI6G8wyLJ1FlQWsdqw7WCB31Vz7/VkdUPr2
         s0miPabRWz3ag==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 12:13:37PM -0500, Michael S. Tsirkin wrote:
> On Wed, Feb 17, 2021 at 01:31:36PM +0200, Eli Cohen wrote:
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
> where's the rest of the patchset though? I only got 2/2 ... confused.

Sorry, I hade two unrelated patches that git format patch named them
0001... and 0002... git send email added 1/2 and 2/2 even though I sent
them seperately.

I will send them again.

> 
> > ---
> > v0->v1:
> > set mgtdev->ndev NULL on dev delete 
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
