Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6DB51AF46
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 22:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237004AbiEDUiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 16:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235624AbiEDUiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 16:38:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F9BF50049
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 13:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651696476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7bK5Zm/qrBOcE2iwMG+IP1VKikjVLdiredOhBdY4cJY=;
        b=UriN5rUKS01P3syulIbiL8Qu++rd/Sgmi9RRj5hi7OZ/uzAQ7z3Lpuv6Zc5tSx3g51lKJ4
        OHoh9iiuvs+J1k42H7AaJ0/+lPI04401FUFzr02fPIEUz6yaStqdoGVzSlyltYYgwlzL6y
        sCLOOOyYsgDR5eT/Fji3/igS0LApyb8=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-7YjzDzxuOMOPfOgFRXfSxg-1; Wed, 04 May 2022 16:34:34 -0400
X-MC-Unique: 7YjzDzxuOMOPfOgFRXfSxg-1
Received: by mail-io1-f72.google.com with SMTP id t1-20020a056602140100b0065393cc1dc3so1713688iov.5
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 13:34:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=7bK5Zm/qrBOcE2iwMG+IP1VKikjVLdiredOhBdY4cJY=;
        b=kvSKzQRbVkSpbNEUkFvq/NR/WzDx1kEDAU8ruRr8zk5PSNdBVdzcXbxXL/CPG1boiX
         bbyfdzjjhPgskvKRiBUrfHs37tiORoWtOwV1lDqO2TiLyPsbZ/ajmskypIMe2HSaoWCV
         YPmDnblry8LfljBMLlB5s/EjxB0gPxEgylSf3MUNY9mmrZjMyS+lh8e1mGH9Gm7DD/PZ
         z8UUcUswYn8V+VNUvlSLsaRrkv6a94SEGiG4zaZtw9gDtKMzmNI/t7lwWwmHdncHdzif
         1OWVZ8IEdWigF7HD+gBt9T0lCU3n0AV39WwjaIg6/C4IFoRPoJGIDyP8GNlQ0Gbt+rEM
         AK9g==
X-Gm-Message-State: AOAM532axjBfwzzfowVpeU+O91PL1DVyWANIFgFJeT8UPx2wY3oKDQeb
        7aI0IOZDunoyNEdsxzghh3+L8kRfvUlr0gFRXO/ONH6Wdd+X+mFfg8t2GOPwdhA0J7oqnkcQT8L
        27nK7p0oK2PmRxcmW
X-Received: by 2002:a05:6602:2b87:b0:645:db81:a5ab with SMTP id r7-20020a0566022b8700b00645db81a5abmr8969187iov.71.1651696473509;
        Wed, 04 May 2022 13:34:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygADkqBXww587j07g2++KErHkimUSGMHRGcZlOE77WX8Bm11Xt7XuRw24PvvRHPHLNm1KN8Q==
X-Received: by 2002:a05:6602:2b87:b0:645:db81:a5ab with SMTP id r7-20020a0566022b8700b00645db81a5abmr8969168iov.71.1651696473143;
        Wed, 04 May 2022 13:34:33 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id w27-20020a02cf9b000000b0032b3a7817aasm4955286jar.110.2022.05.04.13.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 13:34:32 -0700 (PDT)
Date:   Wed, 4 May 2022 14:34:31 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <maorg@nvidia.com>, <cohuck@redhat.com>
Subject: Re: [PATCH mlx5-next 3/5] vfio/mlx5: Manage the VF attach/detach
 callback from the PF
Message-ID: <20220504143431.2fdd4ea5.alex.williamson@redhat.com>
In-Reply-To: <20220427093120.161402-4-yishaih@nvidia.com>
References: <20220427093120.161402-1-yishaih@nvidia.com>
        <20220427093120.161402-4-yishaih@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Apr 2022 12:31:18 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> Manage the VF attach/detach callback from the PF.
> 
> This lets the driver to enable parallel VFs migration as will be
> introduced in the next patch.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/vfio/pci/mlx5/cmd.c  | 59 +++++++++++++++++++++++++++++++++---
>  drivers/vfio/pci/mlx5/cmd.h  | 23 +++++++++++++-
>  drivers/vfio/pci/mlx5/main.c | 25 ++++-----------
>  3 files changed, 82 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
> index d608b8167f58..1f84d7b9b9e5 100644
> --- a/drivers/vfio/pci/mlx5/cmd.c
> +++ b/drivers/vfio/pci/mlx5/cmd.c
> @@ -71,21 +71,70 @@ int mlx5vf_cmd_query_vhca_migration_state(struct pci_dev *pdev, u16 vhca_id,
>  	return ret;
>  }
>  
> -bool mlx5vf_cmd_is_migratable(struct pci_dev *pdev)
> +static int mlx5fv_vf_event(struct notifier_block *nb,
> +			   unsigned long event, void *data)
>  {
> -	struct mlx5_core_dev *mdev = mlx5_vf_get_core_dev(pdev);
> +	struct mlx5vf_pci_core_device *mvdev =
> +		container_of(nb, struct mlx5vf_pci_core_device, nb);
> +
> +	mutex_lock(&mvdev->state_mutex);
> +	switch (event) {
> +	case MLX5_PF_NOTIFY_ENABLE_VF:
> +		mvdev->mdev_detach = false;
> +		break;
> +	case MLX5_PF_NOTIFY_DISABLE_VF:
> +		mvdev->mdev_detach = true;
> +		break;
> +	default:
> +		break;
> +	}
> +	mlx5vf_state_mutex_unlock(mvdev);
> +	return 0;
> +}
> +
> +void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev)
> +{
> +	mlx5_sriov_blocking_notifier_unregister(mvdev->mdev, mvdev->vf_id,
> +						&mvdev->nb);
> +}
> +
> +bool mlx5vf_cmd_is_migratable(struct mlx5vf_pci_core_device *mvdev)

Why did the original implementation take a pdev knowing we're going to
gut it in the next patch to use an mvdev?  The diff would be easier to
read.

There's also quite a lot of setup here now, it's no longer a simple
test whether the device supports migration which makes the name
misleading.  This looks like a "setup migration" function that should
return 0/-errno.

> +{
> +	struct pci_dev *pdev = mvdev->core_device.pdev;
>  	bool migratable = false;
> +	int ret;
>  
> -	if (!mdev)
> +	mvdev->mdev = mlx5_vf_get_core_dev(pdev);
> +	if (!mvdev->mdev)
>  		return false;
> +	if (!MLX5_CAP_GEN(mvdev->mdev, migration))
> +		goto end;
> +	mvdev->vf_id = pci_iov_vf_id(pdev);
> +	if (mvdev->vf_id < 0)
> +		goto end;
>  
> -	if (!MLX5_CAP_GEN(mdev, migration))
> +	mutex_init(&mvdev->state_mutex);
> +	spin_lock_init(&mvdev->reset_lock);
> +	mvdev->nb.notifier_call = mlx5fv_vf_event;
> +	ret = mlx5_sriov_blocking_notifier_register(mvdev->mdev, mvdev->vf_id,
> +						    &mvdev->nb);
> +	if (ret)
>  		goto end;
>  
> +	mutex_lock(&mvdev->state_mutex);
> +	if (mvdev->mdev_detach)
> +		goto unreg;
> +
> +	mlx5vf_state_mutex_unlock(mvdev);
>  	migratable = true;
> +	goto end;
>  
> +unreg:
> +	mlx5vf_state_mutex_unlock(mvdev);
> +	mlx5_sriov_blocking_notifier_unregister(mvdev->mdev, mvdev->vf_id,
> +						&mvdev->nb);
>  end:
> -	mlx5_vf_put_core_dev(mdev);
> +	mlx5_vf_put_core_dev(mvdev->mdev);
>  	return migratable;
>  }
>  
> diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
> index 2da6a1c0ec5c..f47174eab4b8 100644
> --- a/drivers/vfio/pci/mlx5/cmd.h
> +++ b/drivers/vfio/pci/mlx5/cmd.h
> @@ -7,6 +7,7 @@
>  #define MLX5_VFIO_CMD_H
>  
>  #include <linux/kernel.h>
> +#include <linux/vfio_pci_core.h>
>  #include <linux/mlx5/driver.h>
>  
>  struct mlx5_vf_migration_file {
> @@ -24,14 +25,34 @@ struct mlx5_vf_migration_file {
>  	unsigned long last_offset;
>  };
>  
> +struct mlx5vf_pci_core_device {
> +	struct vfio_pci_core_device core_device;
> +	int vf_id;
> +	u16 vhca_id;
> +	u8 migrate_cap:1;
> +	u8 deferred_reset:1;
> +	/* protect migration state */
> +	struct mutex state_mutex;
> +	enum vfio_device_mig_state mig_state;
> +	/* protect the reset_done flow */
> +	spinlock_t reset_lock;
> +	struct mlx5_vf_migration_file *resuming_migf;
> +	struct mlx5_vf_migration_file *saving_migf;
> +	struct notifier_block nb;
> +	struct mlx5_core_dev *mdev;
> +	u8 mdev_detach:1;
> +};
> +
>  int mlx5vf_cmd_suspend_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod);
>  int mlx5vf_cmd_resume_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod);
>  int mlx5vf_cmd_query_vhca_migration_state(struct pci_dev *pdev, u16 vhca_id,
>  					  size_t *state_size);
>  int mlx5vf_cmd_get_vhca_id(struct pci_dev *pdev, u16 function_id, u16 *vhca_id);
> -bool mlx5vf_cmd_is_migratable(struct pci_dev *pdev);
> +bool mlx5vf_cmd_is_migratable(struct mlx5vf_pci_core_device *mvdev);
> +void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev);
>  int mlx5vf_cmd_save_vhca_state(struct pci_dev *pdev, u16 vhca_id,
>  			       struct mlx5_vf_migration_file *migf);
>  int mlx5vf_cmd_load_vhca_state(struct pci_dev *pdev, u16 vhca_id,
>  			       struct mlx5_vf_migration_file *migf);
> +void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev);
>  #endif /* MLX5_VFIO_CMD_H */
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index 2578f61eaeae..445c516d38d9 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -17,7 +17,6 @@
>  #include <linux/uaccess.h>
>  #include <linux/vfio.h>
>  #include <linux/sched/mm.h>
> -#include <linux/vfio_pci_core.h>
>  #include <linux/anon_inodes.h>
>  
>  #include "cmd.h"
> @@ -25,20 +24,6 @@
>  /* Arbitrary to prevent userspace from consuming endless memory */
>  #define MAX_MIGRATION_SIZE (512*1024*1024)
>  
> -struct mlx5vf_pci_core_device {
> -	struct vfio_pci_core_device core_device;
> -	u16 vhca_id;
> -	u8 migrate_cap:1;
> -	u8 deferred_reset:1;
> -	/* protect migration state */
> -	struct mutex state_mutex;
> -	enum vfio_device_mig_state mig_state;
> -	/* protect the reset_done flow */
> -	spinlock_t reset_lock;
> -	struct mlx5_vf_migration_file *resuming_migf;
> -	struct mlx5_vf_migration_file *saving_migf;
> -};
> -
>  static struct page *
>  mlx5vf_get_migration_page(struct mlx5_vf_migration_file *migf,
>  			  unsigned long offset)
> @@ -444,7 +429,7 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
>   * This function is called in all state_mutex unlock cases to
>   * handle a 'deferred_reset' if exists.
>   */
> -static void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev)
> +void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev)
>  {
>  again:
>  	spin_lock(&mvdev->reset_lock);
> @@ -597,13 +582,11 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>  		return -ENOMEM;
>  	vfio_pci_core_init_device(&mvdev->core_device, pdev, &mlx5vf_pci_ops);
>  
> -	if (pdev->is_virtfn && mlx5vf_cmd_is_migratable(pdev)) {
> +	if (pdev->is_virtfn && mlx5vf_cmd_is_migratable(mvdev)) {
>  		mvdev->migrate_cap = 1;
>  		mvdev->core_device.vdev.migration_flags =
>  			VFIO_MIGRATION_STOP_COPY |
>  			VFIO_MIGRATION_P2P;

Why do these aspects of setting up migration remain here?  Do we even
need this new function to have a return value?  It looks like all of
this and testing whether the pdev->is_virtfn could be pushed into the
new function, which could then return void.  Thanks,

Alex

> -		mutex_init(&mvdev->state_mutex);
> -		spin_lock_init(&mvdev->reset_lock);
>  	}
>  
>  	ret = vfio_pci_core_register_device(&mvdev->core_device);
> @@ -614,6 +597,8 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>  	return 0;
>  
>  out_free:
> +	if (mvdev->migrate_cap)
> +		mlx5vf_cmd_remove_migratable(mvdev);
>  	vfio_pci_core_uninit_device(&mvdev->core_device);
>  	kfree(mvdev);
>  	return ret;
> @@ -624,6 +609,8 @@ static void mlx5vf_pci_remove(struct pci_dev *pdev)
>  	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
>  
>  	vfio_pci_core_unregister_device(&mvdev->core_device);
> +	if (mvdev->migrate_cap)
> +		mlx5vf_cmd_remove_migratable(mvdev);
>  	vfio_pci_core_uninit_device(&mvdev->core_device);
>  	kfree(mvdev);
>  }

