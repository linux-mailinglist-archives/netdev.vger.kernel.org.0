Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B566BDFD8
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 04:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjCQDzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 23:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjCQDzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 23:55:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461931EBDA
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 20:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679025268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pNiiXyLRN4+3GNHiN/Qpks6nZCViksZo2O1kEdEX10A=;
        b=a0sDY3x/jZraOrjidO8Fz47T0skM9Jso+FWqwFNPowg/1qxCjCcnR60+/HZ0T+CEVgiJFn
        zPAEUzsu8ba9T39QQarDea3UJLR8FJEhdLtfWyV/qCIM9GcBSxUPgTmoCyQOrxDi1k/QWk
        o6fh5LEzsSF30JOVmK3oSStfOGgSil8=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-455-bFjBhUg7OTulu_d9yltJ6w-1; Thu, 16 Mar 2023 23:54:27 -0400
X-MC-Unique: bFjBhUg7OTulu_d9yltJ6w-1
Received: by mail-oi1-f198.google.com with SMTP id bh14-20020a056808180e00b00364c7610c6aso1767411oib.6
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 20:54:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679025266;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pNiiXyLRN4+3GNHiN/Qpks6nZCViksZo2O1kEdEX10A=;
        b=ZrB08drX/aPTLYmx74eWgpnKQ4MH4JODjEXFAHeTTDtbb2iEN8uoDLW/qZoEMDf5oM
         9tq0WjEmNa9PUndfFqFZtkoe8wtUNroocPnAvUXWYTXmKUDdEBikchAkaiMS8/ZJaPcT
         KO53ZL3RxA1Jfdo1XS/jXGOp8Gzd8EHlZEnym5hL7HkYLTIr+3xwGtn++Wl8+PB7gdRg
         ZnkdWFFrIIqFLFlGkcyrUPa7AKVPYEwXVUL30iFmgavIR3aYkmg2LfMia3oq7VG+EiG/
         K0i8YI3S4VctSXr24AHwwLs3/e+NzQ7WCsgojrLzfLZzfx3jouEFVgV2Ihxhvn5aTomS
         CC4A==
X-Gm-Message-State: AO0yUKXCOD6M+4f/JXcoMJCYM6MeGth0sZgfhsFvvECQqUOCv3NNXXQk
        XEhxkr5dcRG3MzMyRrhiVPIGVfNSpBPzUQWVX3yNQmN+bWaOcC0/tA9+5hT6Ma7bRSbv4oBeHWL
        iJF6MNVeSAIvg/LbcQWZBdhmgzrTbxOiC
X-Received: by 2002:a9d:16e:0:b0:69d:23ff:3316 with SMTP id 101-20020a9d016e000000b0069d23ff3316mr1465727otu.2.1679025266303;
        Thu, 16 Mar 2023 20:54:26 -0700 (PDT)
X-Google-Smtp-Source: AK7set9TBoaC44hcOch8wUd8zHnLW3Mu4+ivVVknKxv99iXX0ryv3uk7saIfBtW3eq4rsnehZdVhL0+R9NnKEhb7Jww=
X-Received: by 2002:a9d:16e:0:b0:69d:23ff:3316 with SMTP id
 101-20020a9d016e000000b0069d23ff3316mr1465721otu.2.1679025266080; Thu, 16 Mar
 2023 20:54:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230309013046.23523-1-shannon.nelson@amd.com>
 <20230309013046.23523-8-shannon.nelson@amd.com> <CACGkMEsuG98ASnuS2zjfro3ZkBhAr5KnhWYWqBkyT9ZzPvLXiw@mail.gmail.com>
 <fda7a918-342b-bdf9-7845-2863056290fc@amd.com>
In-Reply-To: <fda7a918-342b-bdf9-7845-2863056290fc@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 17 Mar 2023 11:54:15 +0800
Message-ID: <CACGkMEtvgGvdB1VDyv=V36SQEw+cBrrq91vhcGtHCk1ZiwhcMg@mail.gmail.com>
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

On Thu, Mar 16, 2023 at 11:25=E2=80=AFAM Shannon Nelson <shannon.nelson@amd=
.com> wrote:
>
> On 3/15/23 12:05 AM, Jason Wang wrote:
> > On Thu, Mar 9, 2023 at 9:31=E2=80=AFAM Shannon Nelson <shannon.nelson@a=
md.com> wrote:
> >>
> >> Add the documentation and Kconfig entry for pds_vdpa driver.
> >>
> >> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> >> ---
> >>   .../ethernet/pensando/pds_vdpa.rst            | 84 +++++++++++++++++=
++
> >>   MAINTAINERS                                   |  4 +
> >>   drivers/vdpa/Kconfig                          |  8 ++
> >>   3 files changed, 96 insertions(+)
> >>   create mode 100644 Documentation/networking/device_drivers/ethernet/=
pensando/pds_vdpa.rst
> >>
> >> diff --git a/Documentation/networking/device_drivers/ethernet/pensando=
/pds_vdpa.rst b/Documentation/networking/device_drivers/ethernet/pensando/p=
ds_vdpa.rst
> >> new file mode 100644
> >> index 000000000000..d41f6dd66e3e
> >> --- /dev/null
> >> +++ b/Documentation/networking/device_drivers/ethernet/pensando/pds_vd=
pa.rst
> >> @@ -0,0 +1,84 @@
> >> +.. SPDX-License-Identifier: GPL-2.0+
> >> +.. note: can be edited and viewed with /usr/bin/formiko-vim
> >> +
> >> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> +PCI vDPA driver for the AMD/Pensando(R) DSC adapter family
> >> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> +
> >> +AMD/Pensando vDPA VF Device Driver
> >> +Copyright(c) 2023 Advanced Micro Devices, Inc
> >> +
> >> +Overview
> >> +=3D=3D=3D=3D=3D=3D=3D=3D
> >> +
> >> +The ``pds_vdpa`` driver is an auxiliary bus driver that supplies
> >> +a vDPA device for use by the virtio network stack.  It is used with
> >> +the Pensando Virtual Function devices that offer vDPA and virtio queu=
e
> >> +services.  It depends on the ``pds_core`` driver and hardware for the=
 PF
> >> +and VF PCI handling as well as for device configuration services.
> >> +
> >> +Using the device
> >> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> +
> >> +The ``pds_vdpa`` device is enabled via multiple configuration steps a=
nd
> >> +depends on the ``pds_core`` driver to create and enable SR-IOV Virtua=
l
> >> +Function devices.
> >> +
> >> +Shown below are the steps to bind the driver to a VF and also to the
> >> +associated auxiliary device created by the ``pds_core`` driver.
> >> +
> >> +.. code-block:: bash
> >> +
> >> +  #!/bin/bash
> >> +
> >> +  modprobe pds_core
> >> +  modprobe vdpa
> >> +  modprobe pds_vdpa
> >> +
> >> +  PF_BDF=3D`grep -H "vDPA.*1" /sys/kernel/debug/pds_core/*/viftypes |=
 head -1 | awk -F / '{print $6}'`
> >> +
> >> +  # Enable vDPA VF auxiliary device(s) in the PF
> >> +  devlink dev param set pci/$PF_BDF name enable_vnet value true cmode=
 runtime
> >> +
> >
> > Does this mean we can't do per VF configuration for vDPA enablement
> > (e.g VF0 for vdpa VF1 to other type)?
>
> For now, yes, a PF only supports one VF type at a time.  We've thought
> about possibilities for some heterogeneous configurations, and tried to
> do some planning for future flexibility, but our current needs don't go
> that far.  If and when we get there, we might look at how Guatam's group
> did their VF personalities in their EF100 driver, or some other
> possibilities.

That's fine.


>
> Thanks for looking through these, I appreciate your time and comments.

You are welcome.

Thanks

>
> sln
>
>
> >
> > Thanks
> >
> >
> >> +  # Create a VF for vDPA use
> >> +  echo 1 > /sys/bus/pci/drivers/pds_core/$PF_BDF/sriov_numvfs
> >> +
> >> +  # Find the vDPA services/devices available
> >> +  PDS_VDPA_MGMT=3D`vdpa mgmtdev show | grep vDPA | head -1 | cut -d: =
-f1`
> >> +
> >> +  # Create a vDPA device for use in virtio network configurations
> >> +  vdpa dev add name vdpa1 mgmtdev $PDS_VDPA_MGMT mac 00:11:22:33:44:5=
5
> >> +
> >> +  # Set up an ethernet interface on the vdpa device
> >> +  modprobe virtio_vdpa
> >> +
> >> +
> >> +
> >> +Enabling the driver
> >> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> +
> >> +The driver is enabled via the standard kernel configuration system,
> >> +using the make command::
> >> +
> >> +  make oldconfig/menuconfig/etc.
> >> +
> >> +The driver is located in the menu structure at:
> >> +
> >> +  -> Device Drivers
> >> +    -> Network device support (NETDEVICES [=3Dy])
> >> +      -> Ethernet driver support
> >> +        -> Pensando devices
> >> +          -> Pensando Ethernet PDS_VDPA Support
> >> +
> >> +Support
> >> +=3D=3D=3D=3D=3D=3D=3D
> >> +
> >> +For general Linux networking support, please use the netdev mailing
> >> +list, which is monitored by Pensando personnel::
> >> +
> >> +  netdev@vger.kernel.org
> >> +
> >> +For more specific support needs, please use the Pensando driver suppo=
rt
> >> +email::
> >> +
> >> +  drivers@pensando.io
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index cb21dcd3a02a..da981c5bc830 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -22120,6 +22120,10 @@ SNET DPU VIRTIO DATA PATH ACCELERATOR
> >>   R:     Alvaro Karsz <alvaro.karsz@solid-run.com>
> >>   F:     drivers/vdpa/solidrun/
> >>
> >> +PDS DSC VIRTIO DATA PATH ACCELERATOR
> >> +R:     Shannon Nelson <shannon.nelson@amd.com>
> >> +F:     drivers/vdpa/pds/
> >> +
> >>   VIRTIO BALLOON
> >>   M:     "Michael S. Tsirkin" <mst@redhat.com>
> >>   M:     David Hildenbrand <david@redhat.com>
> >> diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
> >> index cd6ad92f3f05..c910cb119c1b 100644
> >> --- a/drivers/vdpa/Kconfig
> >> +++ b/drivers/vdpa/Kconfig
> >> @@ -116,4 +116,12 @@ config ALIBABA_ENI_VDPA
> >>            This driver includes a HW monitor device that
> >>            reads health values from the DPU.
> >>
> >> +config PDS_VDPA
> >> +       tristate "vDPA driver for AMD/Pensando DSC devices"
> >> +       depends on PDS_CORE
> >> +       help
> >> +         VDPA network driver for AMD/Pensando's PDS Core devices.
> >> +         With this driver, the VirtIO dataplane can be
> >> +         offloaded to an AMD/Pensando DSC device.
> >> +
> >>   endif # VDPA
> >> --
> >> 2.17.1
> >>
> >
>

