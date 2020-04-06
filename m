Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 564A819F604
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 14:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbgDFMp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 08:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728062AbgDFMp0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 08:45:26 -0400
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EFF022203;
        Mon,  6 Apr 2020 12:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586177125;
        bh=tiN2oTj1i0XyvRhRfdLBlfrbeamD1vChWpja08uq09w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Q7O72xtV3LBHX177tBgE4k8duWbcQLkAnOvu2i0oWsmlEVrgMpKM3Q1K8phxJkiLN
         C1GBx8jR/l4WGDlFSPD7ZybDU8FJfT2WzYUMEWgVcI4vd98Lj7j6VgsSlrnwVtFd0A
         xlZFWEjxBmW5054XDH0fJTY5IycORF0oShPo291Y=
Received: by mail-io1-f41.google.com with SMTP id y17so13492899iow.9;
        Mon, 06 Apr 2020 05:45:25 -0700 (PDT)
X-Gm-Message-State: AGi0PuZif1Sw85yrW2W2Vu5AjLHPakcbTLZ5OT9i5CoTU60GU8W2/Dx5
        Qr1jeEM8RhOEAuOgbx1YwUG/c6Uu4/iAvgBgEvY=
X-Google-Smtp-Source: APiQypJR/I5FJdjjJ5dWxK8nEozXVMsHluDJKpsrloyjYgJrmslBzZKSVlpcnCxFRDiK8soBbZ4QBOO/IENvSOEHHp4=
X-Received: by 2002:a6b:f413:: with SMTP id i19mr19532257iog.203.1586177124713;
 Mon, 06 Apr 2020 05:45:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200406121233.109889-1-mst@redhat.com> <20200406121233.109889-3-mst@redhat.com>
In-Reply-To: <20200406121233.109889-3-mst@redhat.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 6 Apr 2020 14:45:13 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFNeuZU66swwf_Cx7PrQJV34C0VJ7Rte5aga2Jx4S-yHw@mail.gmail.com>
Message-ID: <CAMj1kXFNeuZU66swwf_Cx7PrQJV34C0VJ7Rte5aga2Jx4S-yHw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] vhost: disable for OABI
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kbuild test robot <lkp@intel.com>,
        "daniel.santos@pobox.com" <daniel.santos@pobox.com>,
        Jason Wang <jasowang@redhat.com>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Apr 2020 at 14:12, Michael S. Tsirkin <mst@redhat.com> wrote:
>
> vhost is currently broken on the default ARM config.
>

Where did you get this idea? The report from the robot was using a
randconfig build, and in general, AEABI is required to run anything on
any modern ARM system .


> The reason is that that uses apcs-gnu which is the ancient OABI that is been
> deprecated for a long time.
>
> Given that virtio support on such ancient systems is not needed in the
> first place, let's just add something along the lines of
>
>         depends on !ARM || AEABI
>
> to the virtio Kconfig declaration, and add a comment that it has to do
> with struct member alignment.
>
> Note: we can't make VHOST and VHOST_RING themselves have
> a dependency since these are selected. Add a new symbol for that.
>
> Suggested-by: Ard Biesheuvel <ardb@kernel.org>
> Siggested-by: Richard Earnshaw <Richard.Earnshaw@arm.com>

typo ^^^


> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/misc/mic/Kconfig |  2 +-
>  drivers/net/caif/Kconfig |  2 +-
>  drivers/vdpa/Kconfig     |  2 +-
>  drivers/vhost/Kconfig    | 17 +++++++++++++----
>  4 files changed, 16 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/misc/mic/Kconfig b/drivers/misc/mic/Kconfig
> index 8f201d019f5a..3bfe72c59864 100644
> --- a/drivers/misc/mic/Kconfig
> +++ b/drivers/misc/mic/Kconfig
> @@ -116,7 +116,7 @@ config MIC_COSM
>
>  config VOP
>         tristate "VOP Driver"
> -       depends on VOP_BUS
> +       depends on VOP_BUS && VHOST_DPN
>         select VHOST_RING
>         select VIRTIO
>         help
> diff --git a/drivers/net/caif/Kconfig b/drivers/net/caif/Kconfig
> index 9db0570c5beb..661c25eb1c46 100644
> --- a/drivers/net/caif/Kconfig
> +++ b/drivers/net/caif/Kconfig
> @@ -50,7 +50,7 @@ config CAIF_HSI
>
>  config CAIF_VIRTIO
>         tristate "CAIF virtio transport driver"
> -       depends on CAIF && HAS_DMA
> +       depends on CAIF && HAS_DMA && VHOST_DPN
>         select VHOST_RING
>         select VIRTIO
>         select GENERIC_ALLOCATOR
> diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
> index d0cb0e583a5d..aee28def466b 100644
> --- a/drivers/vdpa/Kconfig
> +++ b/drivers/vdpa/Kconfig
> @@ -14,7 +14,7 @@ if VDPA_MENU
>
>  config VDPA_SIM
>         tristate "vDPA device simulator"
> -       depends on RUNTIME_TESTING_MENU && HAS_DMA
> +       depends on RUNTIME_TESTING_MENU && HAS_DMA && VHOST_DPN
>         select VDPA
>         select VHOST_RING
>         select VHOST_IOTLB
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index cb6b17323eb2..b3486e218f62 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -12,6 +12,15 @@ config VHOST_RING
>           This option is selected by any driver which needs to access
>           the host side of a virtio ring.
>
> +config VHOST_DPN
> +       bool "VHOST dependencies"
> +       depends on !ARM || AEABI
> +       default y
> +       help
> +         Anything selecting VHOST or VHOST_RING must depend on VHOST_DPN.
> +         This excludes the deprecated ARM ABI since that forces a 4 byte
> +         alignment on all structs - incompatible with virtio spec requirements.
> +
>  config VHOST
>         tristate
>         select VHOST_IOTLB
> @@ -27,7 +36,7 @@ if VHOST_MENU
>
>  config VHOST_NET
>         tristate "Host kernel accelerator for virtio net"
> -       depends on NET && EVENTFD && (TUN || !TUN) && (TAP || !TAP)
> +       depends on NET && EVENTFD && (TUN || !TUN) && (TAP || !TAP) && VHOST_DPN
>         select VHOST
>         ---help---
>           This kernel module can be loaded in host kernel to accelerate
> @@ -39,7 +48,7 @@ config VHOST_NET
>
>  config VHOST_SCSI
>         tristate "VHOST_SCSI TCM fabric driver"
> -       depends on TARGET_CORE && EVENTFD
> +       depends on TARGET_CORE && EVENTFD && VHOST_DPN
>         select VHOST
>         default n
>         ---help---
> @@ -48,7 +57,7 @@ config VHOST_SCSI
>
>  config VHOST_VSOCK
>         tristate "vhost virtio-vsock driver"
> -       depends on VSOCKETS && EVENTFD
> +       depends on VSOCKETS && EVENTFD && VHOST_DPN
>         select VHOST
>         select VIRTIO_VSOCKETS_COMMON
>         default n
> @@ -62,7 +71,7 @@ config VHOST_VSOCK
>
>  config VHOST_VDPA
>         tristate "Vhost driver for vDPA-based backend"
> -       depends on EVENTFD
> +       depends on EVENTFD && VHOST_DPN
>         select VHOST
>         select VDPA
>         help
> --
> MST
>
