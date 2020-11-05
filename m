Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBFB72A8878
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732200AbgKEU7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:59:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:50980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbgKEU7Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 15:59:25 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D803120719;
        Thu,  5 Nov 2020 20:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604609963;
        bh=DRNl3UpSeodOLfeM+mn+V6LFTVAs94M33BnMQXxp74U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=zpSpNwA2dgS6fJ+B3dMKuscWCUALftl/jghIIz+UBAaXGmwNUQvYCnRqRa6zQJz25
         yiqapd3x1bT55OkjGFZoKE/7/a1x/kBEtAudGHZxpNvAswRS0pD1rLUZkRZxeleGub
         gRtcneWhJDOrkAvTeXNBS4DuFPGKJQo84UouINRQ=
Message-ID: <d10e7a08200458c1bddb72fc983a5917daebc8f1.camel@kernel.org>
Subject: Re: [PATCH mlx5-next v1 05/11] net/mlx5: Register mlx5 devices to
 auxiliary virtual bus
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        gregkh <gregkh@linuxfoundation.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-rdma@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        alsa-devel@alsa-project.org, tiwai@suse.de, broonie@kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, fred.oh@linux.intel.com,
        shiraz.saleem@intel.com, dan.j.williams@intel.com,
        kiran.patil@intel.com, linux-kernel@vger.kernel.org
Date:   Thu, 05 Nov 2020 12:59:20 -0800
In-Reply-To: <20201101201542.2027568-6-leon@kernel.org>
References: <20201101201542.2027568-1-leon@kernel.org>
         <20201101201542.2027568-6-leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-11-01 at 22:15 +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Create auxiliary devices under new virtual bus. This will replace
> the custom-made mlx5 ->add()/->remove() interfaces and next patches
> will fill the missing callback and remove the old interface logic.
> 
> The attachment of auxiliary drivers to the devices is possible in
> 1-to-1 manner only and it requires us to create device for every
> protocol,
> so that device (module) will be able to connect to it.
> 
> System with 2 IB and 1 RoCE cards:
> [leonro@vm ~]$ lspci |grep nox
> 00:09.0 Ethernet controller: Mellanox Technologies MT27800 Family
> [ConnectX-5]
> 00:0a.0 Ethernet controller: Mellanox Technologies MT28908 Family
> [ConnectX-6]
> 00:0b.0 Ethernet controller: Mellanox Technologies MT2910 Family
> [ConnectX-7]
> [leonro@vm ~]$ ls -l /sys/bus/auxiliary/devices/
>  mlx5_core.eth.2 ->
> ../../../devices/pci0000:00/0000:00:0b.0/mlx5_core.eth.2
>  mlx5_core.rdma.0 ->
> ../../../devices/pci0000:00/0000:00:09.0/mlx5_core.rdma.0
>  mlx5_core.rdma.1 ->
> ../../../devices/pci0000:00/0000:00:0a.0/mlx5_core.rdma.1
>  mlx5_core.rdma.2 ->
> ../../../devices/pci0000:00/0000:00:0b.0/mlx5_core.rdma.2
>  mlx5_core.vdpa.1 ->
> ../../../devices/pci0000:00/0000:00:0a.0/mlx5_core.vdpa.1
>  mlx5_core.vdpa.2 ->
> ../../../devices/pci0000:00/0000:00:0b.0/mlx5_core.vdpa.2
> [leonro@vm ~]$ rdma dev
> 0: ibp0s9: node_type ca fw 4.6.9999 node_guid 5254:00c0:fe12:3455
> sys_image_guid 5254:00c0:fe12:3455
> 1: ibp0s10: node_type ca fw 4.6.9999 node_guid 5254:00c0:fe12:3456
> sys_image_guid 5254:00c0:fe12:3456
> 2: rdmap0s11: node_type ca fw 4.6.9999 node_guid 5254:00c0:fe12:3457
> sys_image_guid 5254:00c0:fe12:3457
> 
> System with RoCE SR-IOV card with 4 VFs:
> [leonro@vm ~]$ lspci |grep nox
> 01:00.0 Ethernet controller: Mellanox Technologies MT28908 Family
> [ConnectX-6]
> 01:00.1 Ethernet controller: Mellanox Technologies MT28908 Family
> [ConnectX-6 Virtual Function]
> 01:00.2 Ethernet controller: Mellanox Technologies MT28908 Family
> [ConnectX-6 Virtual Function]
> 01:00.3 Ethernet controller: Mellanox Technologies MT28908 Family
> [ConnectX-6 Virtual Function]
> 01:00.4 Ethernet controller: Mellanox Technologies MT28908 Family
> [ConnectX-6 Virtual Function]
> [leonro@vm ~]$ ls -l /sys/bus/auxiliary/devices/
>  mlx5_core.eth.0 ->
> ../../../devices/pci0000:00/0000:00:09.0/0000:01:00.0/mlx5_core.eth.0
>  mlx5_core.eth.1 ->
> ../../../devices/pci0000:00/0000:00:09.0/0000:01:00.1/mlx5_core.eth.1
>  mlx5_core.eth.2 ->
> ../../../devices/pci0000:00/0000:00:09.0/0000:01:00.2/mlx5_core.eth.2
>  mlx5_core.eth.3 ->
> ../../../devices/pci0000:00/0000:00:09.0/0000:01:00.3/mlx5_core.eth.3
>  mlx5_core.eth.4 ->
> ../../../devices/pci0000:00/0000:00:09.0/0000:01:00.4/mlx5_core.eth.4
>  mlx5_core.rdma.0 ->
> ../../../devices/pci0000:00/0000:00:09.0/0000:01:00.0/mlx5_core.rdma.
> 0
>  mlx5_core.rdma.1 ->
> ../../../devices/pci0000:00/0000:00:09.0/0000:01:00.1/mlx5_core.rdma.
> 1
>  mlx5_core.rdma.2 ->
> ../../../devices/pci0000:00/0000:00:09.0/0000:01:00.2/mlx5_core.rdma.
> 2
>  mlx5_core.rdma.3 ->
> ../../../devices/pci0000:00/0000:00:09.0/0000:01:00.3/mlx5_core.rdma.
> 3
>  mlx5_core.rdma.4 ->
> ../../../devices/pci0000:00/0000:00:09.0/0000:01:00.4/mlx5_core.rdma.
> 4
>  mlx5_core.vdpa.1 ->
> ../../../devices/pci0000:00/0000:00:09.0/0000:01:00.1/mlx5_core.vdpa.
> 1
>  mlx5_core.vdpa.2 ->
> ../../../devices/pci0000:00/0000:00:09.0/0000:01:00.2/mlx5_core.vdpa.
> 2
>  mlx5_core.vdpa.3 ->
> ../../../devices/pci0000:00/0000:00:09.0/0000:01:00.3/mlx5_core.vdpa.
> 3
>  mlx5_core.vdpa.4 ->
> ../../../devices/pci0000:00/0000:00:09.0/0000:01:00.4/mlx5_core.vdpa.
> 4
> [leonro@vm ~]$ rdma dev
> 0: rocep1s0f0: node_type ca fw 4.6.9999 node_guid 5254:00c0:fe12:3455
> sys_image_guid 5254:00c0:fe12:3455
> 1: rocep1s0f0v0: node_type ca fw 4.6.9999 node_guid
> 0000:0000:0000:0000 sys_image_guid 5254:00c0:fe12:3456
> 2: rocep1s0f0v1: node_type ca fw 4.6.9999 node_guid
> 0000:0000:0000:0000 sys_image_guid 5254:00c0:fe12:3457
> 3: rocep1s0f0v2: node_type ca fw 4.6.9999 node_guid
> 0000:0000:0000:0000 sys_image_guid 5254:00c0:fe12:3458
> 4: rocep1s0f0v3: node_type ca fw 4.6.9999 node_guid
> 0000:0000:0000:0000 sys_image_guid 5254:00c0:fe12:3459
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/Kconfig   |   1 +
>  drivers/net/ethernet/mellanox/mlx5/core/dev.c | 265
> +++++++++++++++++-
>  .../net/ethernet/mellanox/mlx5/core/main.c    |  24 +-
>  .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  20 +-
>  include/linux/mlx5/driver.h                   |  26 +-
>  5 files changed, 325 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> index 99f1ec3b2575..485478979b1a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> @@ -6,6 +6,7 @@
>  config MLX5_CORE
>  	tristate "Mellanox 5th generation network adapters (ConnectX
> series) core driver"
>  	depends on PCI
> +	select AUXILIARY_BUS
>  	select NET_DEVLINK
>  	depends on VXLAN || !VXLAN
>  	depends on MLXFW || !MLXFW
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
> b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
> index 1972ddd12704..8ddf469b2d05 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
> @@ -37,6 +37,7 @@ static LIST_HEAD(intf_list);
>  static LIST_HEAD(mlx5_dev_list);
>  /* intf dev list mutex */
>  static DEFINE_MUTEX(mlx5_intf_mutex);
> +static DEFINE_IDA(mlx5_adev_ida);
> 
>  struct mlx5_device_context {
>  	struct list_head	list;
> @@ -50,6 +51,39 @@ enum {
>  	MLX5_INTERFACE_ATTACHED,
>  };
> 
> +static const struct mlx5_adev_device {
> +	const char *suffix;
> +	bool (*is_supported)(struct mlx5_core_dev *dev);
> +} mlx5_adev_devices[1] = {};
> +
> +int mlx5_adev_idx_alloc(void)
> +{
> +	return ida_alloc(&mlx5_adev_ida, GFP_KERNEL);
> +}
> +
> +void mlx5_adev_idx_free(int idx)
> +{
> +	ida_free(&mlx5_adev_ida, idx);
> +}
> +
> +int mlx5_adev_init(struct mlx5_core_dev *dev)
> +{
> +	struct mlx5_priv *priv = &dev->priv;
> +
> +	priv->adev = kcalloc(ARRAY_SIZE(mlx5_adev_devices),
> +			     sizeof(struct mlx5_adev *), GFP_KERNEL);
> +	if (!priv->adev)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
> +void mlx5_adev_cleanup(struct mlx5_core_dev *dev)
> +{
> +	struct mlx5_priv *priv = &dev->priv;
> +
> +	kfree(priv->adev);
> +}
> 
>  void mlx5_add_device(struct mlx5_interface *intf, struct mlx5_priv
> *priv)
>  {
> @@ -135,15 +169,99 @@ static void mlx5_attach_interface(struct
> mlx5_interface *intf, struct mlx5_priv
>  	}
>  }
> 
> -void mlx5_attach_device(struct mlx5_core_dev *dev)
> +static void adev_release(struct device *dev)
> +{
> +	struct mlx5_adev *mlx5_adev =
> +		container_of(dev, struct mlx5_adev, adev.dev);
> +	struct mlx5_priv *priv = &mlx5_adev->mdev->priv;
> +	int idx = mlx5_adev->idx;
> +
> +	kfree(mlx5_adev);
> +	priv->adev[idx] = NULL;
> +}
> +
> +static struct mlx5_adev *add_adev(struct mlx5_core_dev *dev, int
> idx)
> +{
> +	const char *suffix = mlx5_adev_devices[idx].suffix;
> +	struct auxiliary_device *adev;
> +	struct mlx5_adev *madev;
> +	int ret;
> +
> +	madev = kzalloc(sizeof(*madev), GFP_KERNEL);
> +	if (!madev)
> +		return ERR_PTR(-ENOMEM);
> +
> +	adev = &madev->adev;
> +	adev->id = dev->priv.adev_idx;
> +	adev->name = suffix;
> +	adev->dev.parent = dev->device;
> +	adev->dev.release = adev_release;
> +	madev->mdev = dev;
> +	madev->idx = idx;
> +
> +	ret = auxiliary_device_init(adev);
> +	if (ret) {
> +		kfree(madev);
> +		return ERR_PTR(ret);
> +	}
> +
> +	ret = auxiliary_device_add(adev);
> +	if (ret) {
> +		auxiliary_device_uninit(adev);
> +		return ERR_PTR(ret);
> +	}
> +	return madev;
> +}
> +
> +static void del_adev(struct auxiliary_device *adev)
> +{
> +	auxiliary_device_delete(adev);
> +	auxiliary_device_uninit(adev);
> +}
> +
> +int mlx5_attach_device(struct mlx5_core_dev *dev)
>  {
>  	struct mlx5_priv *priv = &dev->priv;
> +	struct auxiliary_device *adev;
> +	struct auxiliary_driver *adrv;
>  	struct mlx5_interface *intf;
> +	int ret = 0, i;
> 
>  	mutex_lock(&mlx5_intf_mutex);
> +	for (i = 0; i < ARRAY_SIZE(mlx5_adev_devices); i++) {
> +		if (!priv->adev[i]) {
> +			bool is_supported = false;
> +
> +			if (mlx5_adev_devices[i].is_supported)
> +				is_supported =
> mlx5_adev_devices[i].is_supported(dev);
> +
> +			if (!is_supported)
> +				continue;
> +
> +			priv->adev[i] = add_adev(dev, i);
> +			if (IS_ERR(priv->adev[i])) {
> +				ret = PTR_ERR(priv->adev[i]);
> +				priv->adev[i] = NULL;
> +			}
> +		} else {
> +			adev = &priv->adev[i]->adev;
> +			adrv = to_auxiliary_drv(adev->dev.driver);
> +
> +			if (adrv->resume)
> +				ret = adrv->resume(adev);
> +		}
> +		if (ret) {
> +			mlx5_core_warn(dev, "Device[%d] (%s) failed to
> load\n",
> +				       i, mlx5_adev_devices[i].suffix);
> +
> +			break;
> +		}
> +	}
> +
>  	list_for_each_entry(intf, &intf_list, list)
>  		mlx5_attach_interface(intf, priv);
>  	mutex_unlock(&mlx5_intf_mutex);
> +	return ret;
>  }
> 
>  static void mlx5_detach_interface(struct mlx5_interface *intf,
> struct mlx5_priv *priv)
> @@ -171,9 +289,29 @@ static void mlx5_detach_interface(struct
> mlx5_interface *intf, struct mlx5_priv
>  void mlx5_detach_device(struct mlx5_core_dev *dev)
>  {
>  	struct mlx5_priv *priv = &dev->priv;
> +	struct auxiliary_device *adev;
> +	struct auxiliary_driver *adrv;
>  	struct mlx5_interface *intf;
> +	pm_message_t pm = {};
> +	int i;
> 
>  	mutex_lock(&mlx5_intf_mutex);
> +	for (i = ARRAY_SIZE(mlx5_adev_devices) - 1; i >= 0; i--) {
> +		if (!priv->adev[i])
> +			continue;
> +
> +		adev = &priv->adev[i]->adev;
> +		adrv = to_auxiliary_drv(adev->dev.driver);
> +
> +		if (adrv->suspend) {
> +			adrv->suspend(adev, pm);
> +			continue;
> +		}
> +
> +		del_adev(&priv->adev[i]->adev);
> +		priv->adev[i] = NULL;
> +	}
> +
>  	list_for_each_entry(intf, &intf_list, list)
>  		mlx5_detach_interface(intf, priv);
>  	mutex_unlock(&mlx5_intf_mutex);
> @@ -193,16 +331,30 @@ bool mlx5_device_registered(struct
> mlx5_core_dev *dev)
>  	return found;
>  }
> 
> -void mlx5_register_device(struct mlx5_core_dev *dev)
> +int mlx5_register_device(struct mlx5_core_dev *dev)
>  {
>  	struct mlx5_priv *priv = &dev->priv;
>  	struct mlx5_interface *intf;
> +	int ret;
> +
> +	mutex_lock(&mlx5_intf_mutex);
> +	dev->priv.flags &= ~MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
> +	ret = mlx5_rescan_drivers_locked(dev);
> +	mutex_unlock(&mlx5_intf_mutex);
> +	if (ret)
> +		goto add_err;
> 
>  	mutex_lock(&mlx5_intf_mutex);
>  	list_add_tail(&priv->dev_list, &mlx5_dev_list);
>  	list_for_each_entry(intf, &intf_list, list)
>  		mlx5_add_device(intf, priv);
>  	mutex_unlock(&mlx5_intf_mutex);
> +
> +	return 0;
> +
> +add_err:
> +	mlx5_unregister_device(dev);
> +	return ret;
>  }
> 
>  void mlx5_unregister_device(struct mlx5_core_dev *dev)
> @@ -214,6 +366,9 @@ void mlx5_unregister_device(struct mlx5_core_dev
> *dev)
>  	list_for_each_entry_reverse(intf, &intf_list, list)
>  		mlx5_remove_device(intf, priv);
>  	list_del(&priv->dev_list);
> +
> +	dev->priv.flags |= MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
> +	mlx5_rescan_drivers_locked(dev);
>  	mutex_unlock(&mlx5_intf_mutex);
>  }
> 
> @@ -246,6 +401,77 @@ void mlx5_unregister_interface(struct
> mlx5_interface *intf)
>  }
>  EXPORT_SYMBOL(mlx5_unregister_interface);
> 
> +static int add_drivers(struct mlx5_core_dev *dev)
> +{
> +	struct mlx5_priv *priv = &dev->priv;
> +	int i, ret = 0;
> +
> +	for (i = 0; i < ARRAY_SIZE(mlx5_adev_devices); i++) {
> +		bool is_supported = false;
> +
> +		if (priv->adev[i])
> +			continue;
> +
> +		if (mlx5_adev_devices[i].is_supported)
> +			is_supported =
> mlx5_adev_devices[i].is_supported(dev);
> +
> +		if (!is_supported)
> +			continue;
> +

I think this is wrong for two reasons.

1. is_supported should belong to the ulp aux device itself, and must be
performed before probe. drivers should be added unconditionally and
is_supproted should be checked only prior to probe.

2. you can always load a driver without its underlying device existed.
for example, you can load a pci device driver/module and it will load
and wait for pci devices to pop up, the subsysetem infrastructure will
match between drivers and devices and probe them.

Aux should be the same with the small change that all ulp aux devices
should implement is_supported if they need, since they are virtual
devices they might have some other constrains other than just matching
device ids.



I would suggest the following infra/API semantics changes:

Aux bus parent device:
mlx5_core pci device load/probe(pci_dev) 
{
  struct aux_device *mlx5_aux_dev = alloc_aux_device()

  mlx5_aux_dev->priv = pci_dev;
  register_aux_device("mlx5_core", mlx5_aux_dev);
}



Aux ULP driver:

struct aux_driver mlx5_vpda_aux_driver {

      .name = "vdpa",
       /* match this driver with mlx5_core devices */
      .id_table = {"mlx5_core"}, 
      .ops {
            /* called before probe on actual aux mlx5_core device */
           .is_supported(struct aux_device); 

           .probe = mlx5v_probe,
           .remove = mlx5v_remove,
        }
}

mlx5_vdpa_module_init():
    register_aux_driver(mlx5_vpda_aux_driver);



Aux infrastructure semantics:

  a) on  register_aux_device("mlx5_core", mlx5_aux_dev); 
     it will match all drivers and probe them if is_supported is true,
     reveres flow on unregister_aux_device()

  b) on register_aux_driver(); probe driver on all current devices with
matching ids if is_supported() returned ture


So you don't really need to re-implement mlx5_rescan_drivers_locked and
mlx5_add_drivers in each and every aux device/driver providers, this
should be a aux bus infra' logic.


