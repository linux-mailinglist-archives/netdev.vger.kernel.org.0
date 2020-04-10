Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF51E1A4325
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 09:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgDJHpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 03:45:21 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:46017 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgDJHpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 03:45:21 -0400
Received: by mail-ot1-f65.google.com with SMTP id 60so1105941otl.12;
        Fri, 10 Apr 2020 00:45:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c9BJA5kwXSY009wyyInjyYUXASRt/6Rey8B6iWb2SF0=;
        b=hW3niZuHTfO6f6EDkTivYaptI/J0x5mqwSBzCcEclX3WduKkyX5pQp6MS7O6Stn6o/
         e0QKRXi80+ZS14K+vVt5AX3u33JuKyG+jKM2WUoQo2aGJwqPr1eumsnP6Gq527WpFcPc
         6AvCDk6kfQd6VlmApXEfQuuYJ3+4CpIpWb/xexzMoZL5miH3Lscvz9Nzjc5h1hT3Re7i
         9rqnfur30Hv6M5X/CrYQjptJzKIZ0pkMuju9TRA7uXTMTSWY4zYNEkInBV/sOwq8Q/bt
         FL+cUbWOkQDJytMnZ8G4y/i6gdulwstdiOS9CzNrVjjDqi8ESLcj/ICt5SYOTMltAaDy
         YUqw==
X-Gm-Message-State: AGi0PuZdNC4bppeNJs9Y4PFsLMDziRyKvqvpYeL6EQW4ldX8WcufIdVj
        q0D0+TgJMROTI0JiAR6+uTtJTp1IrCTmWlx7lTs=
X-Google-Smtp-Source: APiQypKISMwlaDr4vBs+Tumqx8h8r7SK5oimoKVzWxc+LbQ7UeKu9R+aW/E1Uql3e3RFjK7nUu4xiGQ99QHzWy0fNR8=
X-Received: by 2002:a05:6830:1e0e:: with SMTP id s14mr3093072otr.107.1586504720818;
 Fri, 10 Apr 2020 00:45:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200326140125.19794-1-jasowang@redhat.com> <20200326140125.19794-9-jasowang@redhat.com>
In-Reply-To: <20200326140125.19794-9-jasowang@redhat.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 10 Apr 2020 09:45:09 +0200
Message-ID: <CAMuHMdUis3O_mJKOb2s=_=Zs61iHus5Aq74N3-xs7kmjN+egoQ@mail.gmail.com>
Subject: Re: [PATCH V9 8/9] vdpasim: vDPA device simulator
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>,
        Jason Gunthorpe <jgg@mellanox.com>, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, kevin.tian@intel.com, stefanha@redhat.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, aadam@redhat.com,
        Jiri Pirko <jiri@mellanox.com>, shahafs@mellanox.com,
        hanand@xilinx.com, Martin Habets <mhabets@solarflare.com>,
        gdawar@xilinx.com, saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,

On Thu, Mar 26, 2020 at 3:07 PM Jason Wang <jasowang@redhat.com> wrote:
> This patch implements a software vDPA networking device. The datapath
> is implemented through vringh and workqueue. The device has an on-chip
> IOMMU which translates IOVA to PA. For kernel virtio drivers, vDPA
> simulator driver provides dma_ops. For vhost driers, set_map() methods
> of vdpa_config_ops is implemented to accept mappings from vhost.
>
> Currently, vDPA device simulator will loopback TX traffic to RX. So
> the main use case for the device is vDPA feature testing, prototyping
> and development.
>
> Note, there's no management API implemented, a vDPA device will be
> registered once the module is probed. We need to handle this in the
> future development.
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

This is now commit 2c53d0f64c06f458 ("vdpasim: vDPA device simulator").

> --- a/drivers/virtio/vdpa/Kconfig
> +++ b/drivers/virtio/vdpa/Kconfig
> @@ -5,3 +5,22 @@ config VDPA
>           Enable this module to support vDPA device that uses a
>           datapath which complies with virtio specifications with
>           vendor specific control path.
> +
> +menuconfig VDPA_MENU
> +       bool "VDPA drivers"
> +       default n

    *
    * VDPA drivers
    *
    VDPA drivers (VDPA_MENU) [N/y/?] (NEW) ?

    There is no help available for this option.
    Symbol: VDPA_MENU [=n]
    Type  : bool
    Defined at drivers/vdpa/Kconfig:9
     Prompt: VDPA drivers
     Location:
       -> Device Drivers

I think this deserves a help text, so users know if they want to enable this
option or not.

I had a quick look, but couldn't find the meaning of "vdpa" in the whole kernel
source tree.

Thanks!

> +
> +if VDPA_MENU
> +
> +config VDPA_SIM
> +       tristate "vDPA device simulator"
> +       depends on RUNTIME_TESTING_MENU
> +       select VDPA
> +       select VHOST_RING
> +       default n
> +       help
> +         vDPA networking device simulator which loop TX traffic back
> +         to RX. This device is used for testing, prototyping and
> +         development of vDPA.
> +
> +endif # VDPA_MENU

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
