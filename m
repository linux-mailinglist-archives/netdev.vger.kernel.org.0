Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62EEB9003E
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 12:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfHPKvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 06:51:32 -0400
Received: from foss.arm.com ([217.140.110.172]:54910 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbfHPKvc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 06:51:32 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C4E9B28;
        Fri, 16 Aug 2019 03:51:30 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1F1073F706;
        Fri, 16 Aug 2019 03:51:30 -0700 (PDT)
Date:   Fri, 16 Aug 2019 11:51:28 +0100
From:   Andrew Murray <andrew.murray@arm.com>
To:     Denis Efremov <efremov@linux.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Sebastian Ott <sebott@linux.ibm.com>,
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
        Jose Abreu <Jose.Abreu@synopsys.com>, kvm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, netdev@vger.kernel.org,
        x86@kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 00/10] Add definition for the number of standard PCI
 BARs
Message-ID: <20190816105128.GD14111@e119886-lin.cambridge.arm.com>
References: <20190816092437.31846-1-efremov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816092437.31846-1-efremov@linux.com>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 16, 2019 at 12:24:27PM +0300, Denis Efremov wrote:
> Code that iterates over all standard PCI BARs typically uses
> PCI_STD_RESOURCE_END, but this is error-prone because it requires
> "i <= PCI_STD_RESOURCE_END" rather than something like
> "i < PCI_STD_NUM_BARS". We could add such a definition and use it the same
> way PCI_SRIOV_NUM_BARS is used. There is already the definition
> PCI_BAR_COUNT for s390 only. Thus, this patchset introduces it globally.
> 
> Changes in v2:
>   - Reverse checks in pci_iomap_range,pci_iomap_wc_range.
>   - Refactor loops in vfio_pci to keep PCI_STD_RESOURCES.
>   - Add 2 new patches to replace the magic constant with new define.
>   - Split net patch in v1 to separate stmmac and dwc-xlgmac patches.
> 
> Denis Efremov (10):
>   PCI: Add define for the number of standard PCI BARs
>   s390/pci: Loop using PCI_STD_NUM_BARS
>   x86/PCI: Loop using PCI_STD_NUM_BARS
>   stmmac: pci: Loop using PCI_STD_NUM_BARS
>   net: dwc-xlgmac: Loop using PCI_STD_NUM_BARS
>   rapidio/tsi721: Loop using PCI_STD_NUM_BARS
>   efifb: Loop using PCI_STD_NUM_BARS
>   vfio_pci: Loop using PCI_STD_NUM_BARS
>   PCI: hv: Use PCI_STD_NUM_BARS
>   PCI: Use PCI_STD_NUM_BARS
> 
>  arch/s390/include/asm/pci.h                      |  5 +----
>  arch/s390/include/asm/pci_clp.h                  |  6 +++---
>  arch/s390/pci/pci.c                              | 16 ++++++++--------
>  arch/s390/pci/pci_clp.c                          |  6 +++---
>  arch/x86/pci/common.c                            |  2 +-
>  drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c |  4 ++--
>  drivers/net/ethernet/synopsys/dwc-xlgmac-pci.c   |  2 +-
>  drivers/pci/controller/pci-hyperv.c              | 10 +++++-----
>  drivers/pci/pci.c                                | 11 ++++++-----
>  drivers/pci/quirks.c                             |  4 ++--
>  drivers/rapidio/devices/tsi721.c                 |  2 +-
>  drivers/vfio/pci/vfio_pci.c                      | 11 +++++++----
>  drivers/vfio/pci/vfio_pci_config.c               | 10 ++++++----
>  drivers/vfio/pci/vfio_pci_private.h              |  4 ++--
>  drivers/video/fbdev/efifb.c                      |  2 +-
>  include/linux/pci.h                              |  2 +-
>  include/uapi/linux/pci_regs.h                    |  1 +
>  17 files changed, 51 insertions(+), 47 deletions(-)

I've come across a few more places where this change can be made. There
may be multiple instances in the same file, but only the first is shown
below:

drivers/misc/pci_endpoint_test.c:       for (bar = BAR_0; bar <= BAR_5; bar++) {
drivers/net/ethernet/intel/e1000/e1000_main.c:          for (i = BAR_1; i <= BAR_5; i++) {
drivers/net/ethernet/intel/ixgb/ixgb_main.c:    for (i = BAR_1; i <= BAR_5; i++) {
drivers/pci/controller/dwc/pci-dra7xx.c:        for (bar = BAR_0; bar <= BAR_5; bar++)
drivers/pci/controller/dwc/pci-layerscape-ep.c: for (bar = BAR_0; bar <= BAR_5; bar++)
drivers/pci/controller/dwc/pcie-artpec6.c:      for (bar = BAR_0; bar <= BAR_5; bar++)
drivers/pci/controller/dwc/pcie-designware-plat.c:      for (bar = BAR_0; bar <= BAR_5; bar++)
drivers/pci/endpoint/functions/pci-epf-test.c:  for (bar = BAR_0; bar <= BAR_5; bar++) {
include/linux/pci-epc.h:        u64     bar_fixed_size[BAR_5 + 1];
drivers/scsi/pm8001/pm8001_hwi.c:       for (bar = 0; bar < 6; bar++) {
drivers/scsi/pm8001/pm8001_init.c:      for (bar = 0; bar < 6; bar++) {
drivers/ata/sata_nv.c:  for (bar = 0; bar < 6; bar++)
drivers/video/fbdev/core/fbmem.c:       for (idx = 0, bar = 0; bar < PCI_ROM_RESOURCE; bar++) {
drivers/staging/gasket/gasket_core.c:   for (i = 0; i < GASKET_NUM_BARS; i++) {
drivers/tty/serial/8250/8250_pci.c:     for (i = 0; i < PCI_NUM_BAR_RESOURCES; i++) { <-----------

It looks like BARs are often iterated with PCI_NUM_BAR_RESOURCES, there
are a load of these too found with:

git grep PCI_ROM_RESOURCE | grep "< "

I'm happy to share patches if preferred.

Thanks,

Andrew Murray

> 
> -- 
> 2.21.0
> 
