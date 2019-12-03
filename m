Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4274310FCB6
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 12:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfLCLrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 06:47:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:49394 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725773AbfLCLrw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Dec 2019 06:47:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6C137B183;
        Tue,  3 Dec 2019 11:47:49 +0000 (UTC)
From:   Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
To:     andrew.murray@arm.com, maz@kernel.org, linux-kernel@vger.kernel.org
Cc:     james.quinlan@broadcom.com, mbrugger@suse.com,
        f.fainelli@gmail.com, phil@raspberrypi.org, wahrenst@gmx.net,
        jeremy.linton@arm.com, linux-pci@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Robin Murphy <robin.murphy@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-rdma@vger.kernel.org, iommu@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-rockchip@lists.infradead.org,
        kexec@lists.infradead.org, linux-nfs@vger.kernel.org
Subject: [PATCH v4 0/8] Raspberry Pi 4 PCIe support
Date:   Tue,  3 Dec 2019 12:47:33 +0100
Message-Id: <20191203114743.1294-1-nsaenzjulienne@suse.de>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series aims at providing support for Raspberry Pi 4's PCIe
controller, which is also shared with the Broadcom STB family of
devices.

There was a previous attempt to upstream this some years ago[1] but was
blocked as most STB PCIe integrations have a sparse DMA mapping[2] which
is something currently not supported by the kernel.  Luckily this is not
the case for the Raspberry Pi 4.

Note that the driver code is to be based on top of Rob Herring's series
simplifying inbound and outbound range parsing.

[1] https://patchwork.kernel.org/cover/10605933/
[2] https://patchwork.kernel.org/patch/10605957/

---

Changes since v3:
  - Moved all the log2.h related changes at the end of the series, as I
    presume they will be contentious and I don't want the PCIe patches
    to depend on them. Ultimately I think I'll respin them on their own
    series but wanted to keep them in for this submission just for the
    sake of continuity.
  - Addressed small nits here and there.

Changes since v2:
  - Redo register access in driver avoiding indirection while keeping
    the naming intact
  - Add patch editing ARM64's config
  - Last MSI cleanups, notably removing MSIX flag
  - Got rid of all _RB writes
  - Got rid of all of_data
  - Overall churn removal
  - Address the rest of Andrew's comments

Changes since v1:
  - add generic rounddown/roundup_pow_two64() patch
  - Add MAINTAINERS patch
  - Fix Kconfig
  - Cleanup probe, use up to date APIs, exit on MSI failure
  - Get rid of linux,pci-domain and other unused constructs
  - Use edge triggered setup for MSI
  - Cleanup MSI implementation
  - Fix multiple cosmetic issues
  - Remove supend/resume code

Jim Quinlan (3):
  dt-bindings: PCI: Add bindings for brcmstb's PCIe device
  PCI: brcmstb: Add Broadcom STB PCIe host controller driver
  PCI: brcmstb: Add MSI support

Nicolas Saenz Julienne (5):
  ARM: dts: bcm2711: Enable PCIe controller
  MAINTAINERS: Add brcmstb PCIe controller
  arm64: defconfig: Enable Broadcom's STB PCIe controller
  linux/log2.h: Fix 64bit calculations in roundup/down_pow_two()
  linux/log2.h: Use roundup/dow_pow_two() on 64bit calculations

 .../bindings/pci/brcm,stb-pcie.yaml           |   97 ++
 MAINTAINERS                                   |    4 +
 arch/arm/boot/dts/bcm2711.dtsi                |   37 +
 arch/arm64/configs/defconfig                  |    1 +
 drivers/acpi/arm64/iort.c                     |    2 +-
 drivers/clk/clk-divider.c                     |    8 +-
 drivers/clk/sunxi/clk-sunxi.c                 |    2 +-
 drivers/infiniband/hw/hfi1/chip.c             |    4 +-
 drivers/infiniband/hw/hfi1/init.c             |    4 +-
 drivers/infiniband/hw/mlx4/srq.c              |    2 +-
 drivers/infiniband/hw/mthca/mthca_srq.c       |    2 +-
 drivers/infiniband/sw/rxe/rxe_qp.c            |    4 +-
 drivers/iommu/intel-iommu.c                   |    4 +-
 drivers/iommu/intel-svm.c                     |    4 +-
 drivers/iommu/intel_irq_remapping.c           |    2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c  |    4 +-
 drivers/net/ethernet/marvell/sky2.c           |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_clock.c |    3 +-
 drivers/net/ethernet/rocker/rocker_hw.h       |    4 +-
 drivers/net/ethernet/sfc/ef10.c               |    2 +-
 drivers/net/ethernet/sfc/efx.h                |    2 +-
 drivers/net/ethernet/sfc/falcon/efx.h         |    2 +-
 drivers/of/device.c                           |    3 +-
 drivers/pci/controller/Kconfig                |    9 +
 drivers/pci/controller/Makefile               |    1 +
 .../pci/controller/cadence/pcie-cadence-ep.c  |    3 +-
 drivers/pci/controller/cadence/pcie-cadence.c |    3 +-
 drivers/pci/controller/pcie-brcmstb.c         | 1008 +++++++++++++++++
 drivers/pci/controller/pcie-rockchip-ep.c     |    5 +-
 drivers/pci/msi.c                             |    2 +-
 include/linux/log2.h                          |   44 +-
 kernel/dma/direct.c                           |    2 +-
 kernel/kexec_core.c                           |    3 +-
 lib/rhashtable.c                              |    2 +-
 net/sunrpc/xprtrdma/verbs.c                   |    2 +-
 35 files changed, 1211 insertions(+), 72 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pci/brcm,stb-pcie.yaml
 create mode 100644 drivers/pci/controller/pcie-brcmstb.c

-- 
2.24.0

