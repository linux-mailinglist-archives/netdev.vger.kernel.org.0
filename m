Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA651F36A7
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 11:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbgFIJM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 05:12:27 -0400
Received: from mga07.intel.com ([134.134.136.100]:64812 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726903AbgFIJMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 05:12:25 -0400
IronPort-SDR: 17jAvLCsSzqm2MnJ9js7gNER5F6PJE2PlQS20rKULSjzSybmRccHkvReEcz6+rQY6swGcBIvjd
 hOhq6pgxTIBQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2020 02:12:23 -0700
IronPort-SDR: qGJGbkP6jIjb06yFErHeRABfowARu5mYzAUtOXYGw11Yc0sLPVFLbgrHJYpz0pR5pOnUg+Kqew
 W6B/kl9/AsNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,491,1583222400"; 
   d="scan'208";a="306121697"
Received: from gklab-125-110.igk.intel.com ([10.91.125.110])
  by fmsmga002.fm.intel.com with ESMTP; 09 Jun 2020 02:12:14 -0700
From:   Piotr Stankiewicz <piotr.stankiewicz@intel.com>
To:     Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Gustavo Pimentel <gustavo.pimentel@synopsys.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        David Zhou <David1.Zhou@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Brian King <brking@us.ibm.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jim Gill <jgill@vmware.com>, linux-doc@vger.kernel.org,
        linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Piotr Stankiewicz <piotr.stankiewicz@intel.com>
Subject: [PATCH v3 00/15] Forward MSI-X vector enable error code in pci_alloc_irq_vectors_affinity()
Date:   Tue,  9 Jun 2020 11:11:48 +0200
Message-Id: <20200609091148.32749-1-piotr.stankiewicz@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200603114212.12525-1-piotr.stankiewicz@intel.com>
References: <20200603114212.12525-1-piotr.stankiewicz@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The primary objective of this patch series is to change the behaviour
of pci_alloc_irq_vectors_affinity() such that it forwards the MSI-X enable
error code when appropriate. In the process, though, it was pointed out
that there are multiple places in the kernel which check/ask for message
signalled interrupts (MSI or MSI-X), which spawned the first patch adding
PCI_IRQ_MSI_TYPES. Finally the rest of the chain converts all users to
take advantage of PCI_IRQ_MSI_TYPES or PCI_IRQ_ALL_TYPES, as
appropriate.

Piotr Stankiewicz (15):
  PCI/MSI: Forward MSI-X vector enable error code in
    pci_alloc_irq_vectors_affinity()
  PCI: Add macro for message signalled interrupt types
  PCI: Use PCI_IRQ_MSI_TYPES where appropriate
  ahci: Use PCI_IRQ_MSI_TYPES where appropriate
  crypto: inside-secure - Use PCI_IRQ_MSI_TYPES where appropriate
  dmaengine: dw-edma: Use PCI_IRQ_MSI_TYPES  where appropriate
  drm/amdgpu: Use PCI_IRQ_MSI_TYPES where appropriate
  IB/qib: Use PCI_IRQ_MSI_TYPES where appropriate
  media: ddbridge: Use PCI_IRQ_MSI_TYPES where appropriate
  vmw_vmci: Use PCI_IRQ_ALL_TYPES where appropriate
  mmc: sdhci: Use PCI_IRQ_MSI_TYPES where appropriate
  amd-xgbe: Use PCI_IRQ_MSI_TYPES where appropriate
  aquantia: atlantic: Use PCI_IRQ_ALL_TYPES where appropriate
  net: hns3: Use PCI_IRQ_MSI_TYPES where appropriate
  scsi: Use PCI_IRQ_MSI_TYPES and PCI_IRQ_ALL_TYPES where appropriate

 Documentation/PCI/msi-howto.rst               |  5 +++--
 drivers/ata/ahci.c                            |  2 +-
 drivers/crypto/inside-secure/safexcel.c       |  2 +-
 drivers/dma/dw-edma/dw-edma-pcie.c            |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c       | 11 +---------
 drivers/infiniband/hw/qib/qib_pcie.c          |  6 +++--
 drivers/media/pci/ddbridge/ddbridge-main.c    |  2 +-
 drivers/misc/vmw_vmci/vmci_guest.c            |  3 +--
 drivers/mmc/host/sdhci-pci-gli.c              |  3 +--
 drivers/mmc/host/sdhci-pci-o2micro.c          |  3 +--
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c      |  2 +-
 .../ethernet/aquantia/atlantic/aq_pci_func.c  |  4 +---
 .../hisilicon/hns3/hns3pf/hclge_main.c        |  3 +--
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  3 +--
 drivers/pci/msi.c                             | 22 ++++++++-----------
 drivers/pci/pcie/portdrv_core.c               |  4 ++--
 drivers/pci/switch/switchtec.c                |  3 +--
 drivers/scsi/ipr.c                            |  5 +++--
 drivers/scsi/vmw_pvscsi.c                     |  2 +-
 include/linux/pci.h                           |  4 ++--
 20 files changed, 37 insertions(+), 54 deletions(-)

-- 
2.17.2

