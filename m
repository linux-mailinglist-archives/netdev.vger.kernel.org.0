Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66CB889963
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 11:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfHLJGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 05:06:43 -0400
Received: from foss.arm.com ([217.140.110.172]:46194 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727233AbfHLJGn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 05:06:43 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6039915A2;
        Mon, 12 Aug 2019 02:06:42 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ACD743F718;
        Mon, 12 Aug 2019 02:06:41 -0700 (PDT)
Date:   Mon, 12 Aug 2019 10:06:40 +0100
From:   Andrew Murray <andrew.murray@arm.com>
To:     Denis Efremov <efremov@linux.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Peter Jones <pjones@redhat.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-fbdev@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, linux-s390@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Add definition for the number of standard PCI BARs
Message-ID: <20190812090639.GX56241@e119886-lin.cambridge.arm.com>
References: <20190811150802.2418-1-efremov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190811150802.2418-1-efremov@linux.com>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 11, 2019 at 06:07:55PM +0300, Denis Efremov wrote:
> Code that iterates over all standard PCI BARs typically uses
> PCI_STD_RESOURCE_END, but this is error-prone because it requires
> "i <= PCI_STD_RESOURCE_END" rather than something like
> "i < PCI_STD_NUM_BARS". We could add such a definition and use it the same
> way PCI_SRIOV_NUM_BARS is used. There is already the definition
> PCI_BAR_COUNT for s390 only. Thus, this patchset introduces it globally.
> 
> The patch is splitted into 7 parts for different drivers/subsystems for
> easy readability.
> 
> Denis Efremov (7):
>   PCI: Add define for the number of standard PCI BARs
>   s390/pci: Replace PCI_BAR_COUNT with PCI_STD_NUM_BARS
>   x86/PCI: Use PCI_STD_NUM_BARS in loops instead of PCI_STD_RESOURCE_END
>   PCI/net: Use PCI_STD_NUM_BARS in loops instead of PCI_STD_RESOURCE_END
>   rapidio/tsi721: use PCI_STD_NUM_BARS in loops instead of
>     PCI_STD_RESOURCE_END
>   efifb: Use PCI_STD_NUM_BARS in loops instead of PCI_STD_RESOURCE_END
>   vfio_pci: Use PCI_STD_NUM_BARS in loops instead of
>     PCI_STD_RESOURCE_END
> 
>  arch/s390/include/asm/pci.h                      |  5 +----
>  arch/s390/include/asm/pci_clp.h                  |  6 +++---
>  arch/s390/pci/pci.c                              | 16 ++++++++--------
>  arch/s390/pci/pci_clp.c                          |  6 +++---
>  arch/x86/pci/common.c                            |  2 +-
>  drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c |  4 ++--
>  drivers/net/ethernet/synopsys/dwc-xlgmac-pci.c   |  2 +-
>  drivers/pci/quirks.c                             |  2 +-
>  drivers/rapidio/devices/tsi721.c                 |  2 +-
>  drivers/vfio/pci/vfio_pci.c                      |  4 ++--
>  drivers/vfio/pci/vfio_pci_config.c               |  2 +-
>  drivers/vfio/pci/vfio_pci_private.h              |  4 ++--
>  drivers/video/fbdev/efifb.c                      |  2 +-
>  include/linux/pci.h                              |  2 +-
>  include/uapi/linux/pci_regs.h                    |  1 +

Hi Denis,

You could also fix up a few cases where the number of BARs is hard coded in
loops, e.g.

drivers/pci/controller/pci-hyperv.c - look for uses of probed_bar in loops
drivers/pci/pci.c - pci_release_selected_regions and __pci_request_selected_regions
drivers/pci/quirks.c - quirk_alder_ioapic

Thanks,

Andrew Murray

>  15 files changed, 29 insertions(+), 31 deletions(-)
> 
> -- 
> 2.21.0
> 
