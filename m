Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB9E6BA8BB
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbjCOHH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbjCOHHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:07:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF52F65455
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678863965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=21PStzEz1jRA5vdQ8HyLpGRj1pTm7pwftVwgmgKMnTM=;
        b=W5hyGcsl2qwKYBFk4VV/ZIFluzH9mRxldjVGaBXnRO5kqPuFtY+cqf7ecu08DdOWcnSvuO
        0OnCpeA4L3WZTF68U5CDKv8uOYQOh75/5vX6VYVRXXNlVgOLfP3y90KdmjTreQGqJEMoZ3
        moiJ+2cEATa7WJ3rwnmMgXPg49XNMr4=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-467-mYDHyR1MOGuRNxAadZkM7Q-1; Wed, 15 Mar 2023 03:06:03 -0400
X-MC-Unique: mYDHyR1MOGuRNxAadZkM7Q-1
Received: by mail-ot1-f70.google.com with SMTP id 71-20020a9d064d000000b00697e5dc461bso1571859otn.7
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:06:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678863963;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=21PStzEz1jRA5vdQ8HyLpGRj1pTm7pwftVwgmgKMnTM=;
        b=qVHI1f+NLBYbviOapusl65xQAP8ZAdIM+xEGoTO3Tcdhyi+QmeboLcVv/HTAQoRxhz
         /HZiRgoAUp3FKZtia9BIZth7G6tOAh8Lz68QJPXeMHAiHQSKhJOrJGthciyYn6iFSXQJ
         ST4cYirh/B/O7aB++gA40+bTjvZoHCMKMuBqMe02EX/mrFIL1se3LAsWYu6s75SZHk/R
         C0q+WtrI2353SBGyf3j+lCS0fKqzc5kIgU42ecvOf441mNjro+5+3jHJHzeHErTHdIc6
         Zv0sq6iB2OoghKi0FyZ5+OJ6GcwhDUP9TdKTQzd0CvwntJLzOQxlyJgOGbDlj3JjNcj4
         0xZQ==
X-Gm-Message-State: AO0yUKV/eCqOL68bAITziY/UX+tSHjegohRt/PnDJVVNPNCSQxlXKo3E
        ZrKy/4L0jt0NOCN/EaFyhhOgmHFpECQF452mEe7ADLAtKrCV2dB2ykRQkYyeOzxuPOXMBqnRDhi
        eFDjadh0m2HRJEENUidqeGybBmM3ERKrH
X-Received: by 2002:a05:6870:649f:b0:177:9f9c:dc5 with SMTP id cz31-20020a056870649f00b001779f9c0dc5mr5038272oab.9.1678863963012;
        Wed, 15 Mar 2023 00:06:03 -0700 (PDT)
X-Google-Smtp-Source: AK7set8pEnOJZbt4dAlXxX1QWi0bfR11fY7jA9dcWl13QD0Yn3HDJZy6smnPnQEkGmS1L1ucv9bRI4Eh905cGt0Yzt8=
X-Received: by 2002:a05:6870:649f:b0:177:9f9c:dc5 with SMTP id
 cz31-20020a056870649f00b001779f9c0dc5mr5038260oab.9.1678863962782; Wed, 15
 Mar 2023 00:06:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230309013046.23523-1-shannon.nelson@amd.com> <20230309013046.23523-8-shannon.nelson@amd.com>
In-Reply-To: <20230309013046.23523-8-shannon.nelson@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 15 Mar 2023 15:05:51 +0800
Message-ID: <CACGkMEsuG98ASnuS2zjfro3ZkBhAr5KnhWYWqBkyT9ZzPvLXiw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 virtio 7/7] pds_vdpa: pds_vdps.rst and Kconfig
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 9, 2023 at 9:31=E2=80=AFAM Shannon Nelson <shannon.nelson@amd.c=
om> wrote:
>
> Add the documentation and Kconfig entry for pds_vdpa driver.
>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  .../ethernet/pensando/pds_vdpa.rst            | 84 +++++++++++++++++++
>  MAINTAINERS                                   |  4 +
>  drivers/vdpa/Kconfig                          |  8 ++
>  3 files changed, 96 insertions(+)
>  create mode 100644 Documentation/networking/device_drivers/ethernet/pens=
ando/pds_vdpa.rst
>
> diff --git a/Documentation/networking/device_drivers/ethernet/pensando/pd=
s_vdpa.rst b/Documentation/networking/device_drivers/ethernet/pensando/pds_=
vdpa.rst
> new file mode 100644
> index 000000000000..d41f6dd66e3e
> --- /dev/null
> +++ b/Documentation/networking/device_drivers/ethernet/pensando/pds_vdpa.=
rst
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
> +
> +  # Enable vDPA VF auxiliary device(s) in the PF
> +  devlink dev param set pci/$PF_BDF name enable_vnet value true cmode ru=
ntime
> +

Does this mean we can't do per VF configuration for vDPA enablement
(e.g VF0 for vdpa VF1 to other type)?

Thanks


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
> diff --git a/MAINTAINERS b/MAINTAINERS
> index cb21dcd3a02a..da981c5bc830 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22120,6 +22120,10 @@ SNET DPU VIRTIO DATA PATH ACCELERATOR
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

