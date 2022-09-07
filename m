Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014845B0D1D
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 21:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiIGTV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 15:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiIGTVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 15:21:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9747FBFC78
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 12:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662578482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=acYYGDic5ZvUP/P7Wj3EoypZhdavjGHx3YAqaWmNtf4=;
        b=Co67kG5sA0Nlss2/j95tLI3KnxyxVWc6hRpZHUA73hwWqD9h0YMSTUw1egET4PeVHnQiG0
        XsVLPKqKC9FicoOj7VDmHOnN5jdEwkBER7iUP8H1vdHtjUmKlbUcLDExUvnLhy1Dq7UOdk
        VbTYcitU0/vdFPYC9TtqaKP8o2Aaf5o=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-367-R56ZNJW7N9OCTtGM0pjJyA-1; Wed, 07 Sep 2022 15:21:21 -0400
X-MC-Unique: R56ZNJW7N9OCTtGM0pjJyA-1
Received: by mail-il1-f198.google.com with SMTP id i20-20020a056e020d9400b002e377b02d4cso12678857ilj.7
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 12:21:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=acYYGDic5ZvUP/P7Wj3EoypZhdavjGHx3YAqaWmNtf4=;
        b=XWFRD8a+tYmUAKd4TQpdu6LwDqcU1Y+6+u6KuWNx7twsqgKDYwKNS86VsaMPE/oq8I
         +J4BxUKFkgGpLSmVdIXaNdv6ZD3mIYZ3WeZ6Uf0S1n/moDT+HaN411Kr6Ejzmz8rlOKZ
         qgdBP04zT1qwidwV2H2mML+l5nYhx9m70+MzmRXYPA4j7u+hYdLA3Mjs1JJCMlH5lX9U
         fliK57NEaxUAbJ3+51asuO9oOuhT1VmWll8u06ZMQsJEvCMyIXCH/crhcRoAflYd2ezM
         +xQHp0UOGxeckpfOna0dfc4T6AmP1P3DjYgt8AeHm9k8anePPWJ1AxJitVjllMintaYo
         X5bw==
X-Gm-Message-State: ACgBeo0iyFXJ5s/NhlKOzIrTHQ/JAZZVTcNHjsTDXth14+ILcKvy+ObM
        uvmTsJhUVrttnzl1jelvkZkKyYeYKjaysHh3lHvggZrViQaXzPOjm+ECbP2fTFYDdNPu3YhkpJ8
        KhpJ0YwIW8iX18R66
X-Received: by 2002:a05:6638:16c2:b0:351:f0d0:b68b with SMTP id g2-20020a05663816c200b00351f0d0b68bmr2904793jat.60.1662578480805;
        Wed, 07 Sep 2022 12:21:20 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6VZ3L6PHOchZCgz1yg93wzLUDlo0CbIRpxVXJ618s/3KmRyaPz8bQXK+QtAeJh32mXlEvNSw==
X-Received: by 2002:a05:6638:16c2:b0:351:f0d0:b68b with SMTP id g2-20020a05663816c200b00351f0d0b68bmr2904781jat.60.1662578480535;
        Wed, 07 Sep 2022 12:21:20 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id m6-20020a056e021c2600b002df2d6769b3sm88947ilh.45.2022.09.07.12.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 12:21:20 -0700 (PDT)
Date:   Wed, 7 Sep 2022 13:21:19 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     saeedm@nvidia.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, kevin.tian@intel.com, joao.m.martins@oracle.com,
        leonro@nvidia.com, yishaih@nvidia.com, maorg@nvidia.com,
        cohuck@redhat.com
Subject: Re: [GIT PULL] Please pull mlx5 vfio changes
Message-ID: <20220907132119.447b9219.alex.williamson@redhat.com>
In-Reply-To: <20220907094344.381661-1-leon@kernel.org>
References: <20220907094344.381661-1-leon@kernel.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  7 Sep 2022 12:43:44 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> Hi Alex,
> 
> This series is based on clean 6.0-rc4 as such it causes to two small merge
> conficts whis vfio-next. One is in thrird patch where you should take whole
> chunk for include/uapi/linux/vfio.h as is. Another is in vfio_main.c around
> header includes, which you should take too.

Is there any reason you can't provide a topic branch for the two
net/mlx5 patches and the remainder are rebased and committed through
the vfio tree?  I don't see this as an exceptional case that requires
resolving conflicts in merge commits.  Thanks,

Alex


> ----------------------------------------------------------------
> The following changes since commit 7e18e42e4b280c85b76967a9106a13ca61c16179:
> 
>   Linux 6.0-rc4 (2022-09-04 13:10:01 -0700)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git tags/mlx5-dma-logging
> 
> for you to fetch changes up to 7f5dc74155a9de8bf6adc86d84e26c5a1e762431:
> 
>   vfio/mlx5: Set the driver DMA logging callbacks (2022-09-07 12:11:22 +0300)
> 
> ----------------------------------------------------------------
> Add device DMA logging support for mlx5 driver
> 
> From Yishai:
> 
> This series adds device DMA logging uAPIs and their implementation as
> part of mlx5 driver.
> 
> DMA logging allows a device to internally record what DMAs the device is
> initiating and report them back to userspace. It is part of the VFIO
> migration infrastructure that allows implementing dirty page tracking
> during the pre copy phase of live migration. Only DMA WRITEs are logged,
> and this API is not connected to VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.
> 
> The uAPIs are based on the FEATURE ioctl as were introduced earlier by
> the below RFC [1] and follows the notes that were discussed in the
> mailing list.
> 
> It includes:
> - A PROBE option to detect if the device supports DMA logging.
> - A SET option to start device DMA logging in given IOVAs ranges.
> - A GET option to read back and clear the device DMA log.
> - A SET option to stop device DMA logging that was previously started.
> 
> Extra details exist as part of relevant patches in the series.
> 
> In addition, the series adds some infrastructure support for managing an
> IOVA bitmap done by Joao Martins.
> 
> It abstracts how an IOVA range is represented in a bitmap that is
> granulated by a given page_size. So it translates all the lifting of
> dealing with user pointers into its corresponding kernel addresses.
> This new functionality abstracts the complexity of user/kernel bitmap
> pointer usage and finally enables an API to set some bits.
> 
> This functionality will be used as part of IOMMUFD series for the system
> IOMMU tracking.
> 
> Finally, we come with mlx5 implementation based on its device
> specification for the DMA logging APIs.
> 
> The matching qemu changes can be previewed here [2].
> They come on top of the v2 migration protocol patches that were sent
> already to the mailing list.
> 
> Note:
> - As this series touched mlx5_core parts we may need to send the
>   net/mlx5 patches as a pull request format to VFIO to avoid conflicts
>   before acceptance.
> 
> [1] https://lore.kernel.org/all/20220501123301.127279-1-yishaih@nvidia.com/T/
> [2] https://github.com/avihai1122/qemu/commits/device_dirty_tracking
> 
> Link: https://lore.kernel.org/all/20220905105852.26398-1-yishaih@nvidia.com/
> Signed-of-by: Leon Romanovsky <leon@kernel.org>
> 
> ----------------------------------------------------------------
> Joao Martins (1):
>       vfio: Add an IOVA bitmap support
> 
> Yishai Hadas (9):
>       net/mlx5: Introduce ifc bits for page tracker
>       net/mlx5: Query ADV_VIRTUALIZATION capabilities
>       vfio: Introduce DMA logging uAPIs
>       vfio: Introduce the DMA logging feature support
>       vfio/mlx5: Init QP based resources for dirty tracking
>       vfio/mlx5: Create and destroy page tracker object
>       vfio/mlx5: Report dirty pages from tracker
>       vfio/mlx5: Manage error scenarios on tracker
>       vfio/mlx5: Set the driver DMA logging callbacks
> 
>  drivers/net/ethernet/mellanox/mlx5/core/fw.c   |   6 +
>  drivers/net/ethernet/mellanox/mlx5/core/main.c |   1 +
>  drivers/vfio/Kconfig                           |   1 +
>  drivers/vfio/Makefile                          |   6 +-
>  drivers/vfio/iova_bitmap.c                     | 422 +++++++++++
>  drivers/vfio/pci/mlx5/cmd.c                    | 995 ++++++++++++++++++++++++-
>  drivers/vfio/pci/mlx5/cmd.h                    |  63 +-
>  drivers/vfio/pci/mlx5/main.c                   |   9 +-
>  drivers/vfio/pci/vfio_pci_core.c               |   5 +
>  drivers/vfio/vfio_main.c                       | 175 +++++
>  include/linux/iova_bitmap.h                    |  26 +
>  include/linux/mlx5/device.h                    |   9 +
>  include/linux/mlx5/mlx5_ifc.h                  |  83 ++-
>  include/linux/vfio.h                           |  28 +-
>  include/uapi/linux/vfio.h                      |  86 +++
>  15 files changed, 1895 insertions(+), 20 deletions(-)
>  create mode 100644 drivers/vfio/iova_bitmap.c
>  create mode 100644 include/linux/iova_bitmap.h
> 

