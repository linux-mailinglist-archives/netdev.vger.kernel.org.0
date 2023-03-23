Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C54136C5EBB
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjCWFXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbjCWFXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:23:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EE81BCB
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 22:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679548946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BLcxbzzhY9zGwedJgHXfBjK4zUokcCkg7Ykgylsb7+g=;
        b=dW/OWYDoQPlGrXNjuO/b7EQ6Sr11Djt02I01PlDj1+SjfwvWhsCrPI9yEnLBwyAPdSE8IG
        ikoc85GQF2pLDmEWY62bHQjzLlfSFzMrV79prbX0Me9wHWT3RSmi6nRJor/OQGGmzqnAiH
        Ehq47vcxFHiEta85Ao+ZczjkfwTlo3Q=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-167-p22JVLoFPtOyX-lm_CyixA-1; Thu, 23 Mar 2023 01:22:17 -0400
X-MC-Unique: p22JVLoFPtOyX-lm_CyixA-1
Received: by mail-ot1-f70.google.com with SMTP id g19-20020a056830161300b0069d6fbb1a72so9267336otr.11
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 22:22:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679548936;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BLcxbzzhY9zGwedJgHXfBjK4zUokcCkg7Ykgylsb7+g=;
        b=HwEkaTfjw8rj2ENRCnTBwqoVfreWvWfvrVODQTC+5qTb9ZAXDQO/MNNChx6Mih0uG3
         DFdkVxinyyX/ZokRgRa0LEwvZBqkHEGss0eXIsYkqWuDHTjAVlMyGUtbqlQi3AmRljvU
         OxJGEtnDEu4hwZa/Q1widzg8/3vBtZUTaMQxtwFGMj4z89/GlfKAMYFTfQPzDUpeMO7S
         c22PSxiqBQBcscYNVP0Alw/VsJDzKjS+riLYqeiT6PHIFElwU6JhT+HHabC5wgtw+BMy
         81PMFJPkMJg649wCVefWU/hGGR7jw5wTIZWULf85/2RTlxuCOrJA8hCBP9RqP9zWUaui
         g9Vw==
X-Gm-Message-State: AAQBX9cOhmciMNnapXExxrkr/b/d9vwX8xtEljZJfzTzd5MHgiSY41GF
        aRB9WrCn7DtLMb3HOk8mvWzvJAN8PovQH7UJhBPxeTLCgnleNAbkzh2m7rRfC/VhD+yqr9S2KJq
        zVa4Cez3wMKDzrrY892gBPwzCWx1bYTgW/Sf1wcjAiI6/zQ==
X-Received: by 2002:a05:6871:6c97:b0:17e:7674:8df0 with SMTP id zj23-20020a0568716c9700b0017e76748df0mr715183oab.9.1679548936189;
        Wed, 22 Mar 2023 22:22:16 -0700 (PDT)
X-Google-Smtp-Source: AK7set8DG9LPnymTQpgsBkm0pxZvr9CPs3Ycm4lzdZUZn6krhMr5nVyrzyrCLHp+9uix7Q5huyJOIaDBOOxdFVqhhLA=
X-Received: by 2002:a05:6871:6c97:b0:17e:7674:8df0 with SMTP id
 zj23-20020a0568716c9700b0017e76748df0mr715177oab.9.1679548935799; Wed, 22 Mar
 2023 22:22:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230322191038.44037-1-shannon.nelson@amd.com> <20230322191038.44037-9-shannon.nelson@amd.com>
In-Reply-To: <20230322191038.44037-9-shannon.nelson@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 23 Mar 2023 13:22:04 +0800
Message-ID: <CACGkMEvnZY8x+Wmz48ULBWsT4xEKtdW0Tyx+MOE+OGoca74Owg@mail.gmail.com>
Subject: Re: [PATCH v3 virtio 8/8] pds_vdpa: pds_vdps.rst and Kconfig
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 3:11=E2=80=AFAM Shannon Nelson <shannon.nelson@amd.=
com> wrote:
>
> Add the documentation and Kconfig entry for pds_vdpa driver.
>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  .../device_drivers/ethernet/amd/pds_vdpa.rst  | 84 +++++++++++++++++++
>  .../device_drivers/ethernet/index.rst         |  1 +

I wonder if it's better to have a dedicated directory for vDPA.

>  MAINTAINERS                                   |  4 +
>  drivers/vdpa/Kconfig                          |  8 ++
>  4 files changed, 97 insertions(+)
>  create mode 100644 Documentation/networking/device_drivers/ethernet/amd/=
pds_vdpa.rst
>
> diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds_vdp=
a.rst b/Documentation/networking/device_drivers/ethernet/amd/pds_vdpa.rst
> new file mode 100644
> index 000000000000..d41f6dd66e3e
> --- /dev/null
> +++ b/Documentation/networking/device_drivers/ethernet/amd/pds_vdpa.rst
> @@ -0,0 +1,84 @@
> +.. SPDX-License-Identifier: GPL-2.0+
> +.. note: can be edited and viewed with /usr/bin/formiko-vim
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +PCI vDPA driver for the AMD/Pensando(R) DSC adapter family
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +AMD/Pensando vDPA VF Device Driver
> +Copyright(c) 2023 Advanced Micro Devices, Inc
> +
> +Overview
> +=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The ``pds_vdpa`` driver is an auxiliary bus driver that supplies
> +a vDPA device for use by the virtio network stack.  It is used with
> +the Pensando Virtual Function devices that offer vDPA and virtio queue
> +services.  It depends on the ``pds_core`` driver and hardware for the PF
> +and VF PCI handling as well as for device configuration services.
> +
> +Using the device
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The ``pds_vdpa`` device is enabled via multiple configuration steps and
> +depends on the ``pds_core`` driver to create and enable SR-IOV Virtual
> +Function devices.
> +
> +Shown below are the steps to bind the driver to a VF and also to the
> +associated auxiliary device created by the ``pds_core`` driver.
> +
> +.. code-block:: bash
> +
> +  #!/bin/bash
> +
> +  modprobe pds_core
> +  modprobe vdpa
> +  modprobe pds_vdpa
> +
> +  PF_BDF=3D`grep -H "vDPA.*1" /sys/kernel/debug/pds_core/*/viftypes | he=
ad -1 | awk -F / '{print $6}'`

This seems to require debugfs, I wonder if it's better to switch to
using /sys/bus/pci ?

Others look good.

Thanks

> +
> +  # Enable vDPA VF auxiliary device(s) in the PF
> +  devlink dev param set pci/$PF_BDF name enable_vnet value true cmode ru=
ntime
> +
> +  # Create a VF for vDPA use
> +  echo 1 > /sys/bus/pci/drivers/pds_core/$PF_BDF/sriov_numvfs
> +
> +  # Find the vDPA services/devices available
> +  PDS_VDPA_MGMT=3D`vdpa mgmtdev show | grep vDPA | head -1 | cut -d: -f1=
`
> +
> +  # Create a vDPA device for use in virtio network configurations
> +  vdpa dev add name vdpa1 mgmtdev $PDS_VDPA_MGMT mac 00:11:22:33:44:55
> +
> +  # Set up an ethernet interface on the vdpa device
> +  modprobe virtio_vdpa
> +
> +
> +
> +Enabling the driver
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The driver is enabled via the standard kernel configuration system,
> +using the make command::
> +
> +  make oldconfig/menuconfig/etc.
> +
> +The driver is located in the menu structure at:
> +
> +  -> Device Drivers
> +    -> Network device support (NETDEVICES [=3Dy])
> +      -> Ethernet driver support
> +        -> Pensando devices
> +          -> Pensando Ethernet PDS_VDPA Support
> +
> +Support
> +=3D=3D=3D=3D=3D=3D=3D
> +
> +For general Linux networking support, please use the netdev mailing
> +list, which is monitored by Pensando personnel::
> +
> +  netdev@vger.kernel.org
> +
> +For more specific support needs, please use the Pensando driver support
> +email::
> +
> +  drivers@pensando.io
> diff --git a/Documentation/networking/device_drivers/ethernet/index.rst b=
/Documentation/networking/device_drivers/ethernet/index.rst
> index eaaf284e69e6..88dd38c7eb6d 100644
> --- a/Documentation/networking/device_drivers/ethernet/index.rst
> +++ b/Documentation/networking/device_drivers/ethernet/index.rst
> @@ -14,6 +14,7 @@ Contents:
>     3com/vortex
>     amazon/ena
>     amd/pds_core
> +   amd/pds_vdpa
>     altera/altera_tse
>     aquantia/atlantic
>     chelsio/cxgb
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 95b5f25a2c06..2af133861068 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22108,6 +22108,10 @@ SNET DPU VIRTIO DATA PATH ACCELERATOR
>  R:     Alvaro Karsz <alvaro.karsz@solid-run.com>
>  F:     drivers/vdpa/solidrun/
>
> +PDS DSC VIRTIO DATA PATH ACCELERATOR
> +R:     Shannon Nelson <shannon.nelson@amd.com>
> +F:     drivers/vdpa/pds/
> +
>  VIRTIO BALLOON
>  M:     "Michael S. Tsirkin" <mst@redhat.com>
>  M:     David Hildenbrand <david@redhat.com>
> diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
> index cd6ad92f3f05..c910cb119c1b 100644
> --- a/drivers/vdpa/Kconfig
> +++ b/drivers/vdpa/Kconfig
> @@ -116,4 +116,12 @@ config ALIBABA_ENI_VDPA
>           This driver includes a HW monitor device that
>           reads health values from the DPU.
>
> +config PDS_VDPA
> +       tristate "vDPA driver for AMD/Pensando DSC devices"
> +       depends on PDS_CORE
> +       help
> +         VDPA network driver for AMD/Pensando's PDS Core devices.
> +         With this driver, the VirtIO dataplane can be
> +         offloaded to an AMD/Pensando DSC device.
> +
>  endif # VDPA
> --
> 2.17.1
>

