Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F80F109B1E
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 10:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbfKZJUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 04:20:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:47876 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727150AbfKZJUi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Nov 2019 04:20:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 853D2BA60;
        Tue, 26 Nov 2019 09:20:35 +0000 (UTC)
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
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-rockchip@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH v3 0/7] Raspberry Pi 4 PCIe support
Date:   Tue, 26 Nov 2019 10:19:38 +0100
Message-Id: <20191126091946.7970-1-nsaenzjulienne@suse.de>
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
  PCI: brcmstb: add Broadcom STB PCIe host controller driver
  PCI: brcmstb: add MSI capability

Nicolas Saenz Julienne (4):
  linux/log2.h: Add roundup/rounddown_pow_two64() family of functions
  ARM: dts: bcm2711: Enable PCIe controller
  MAINTAINERS: Add brcmstb PCIe controller
  arm64: defconfig: Enable Broadcom's STB PCIe controller

 .../bindings/pci/brcm,stb-pcie.yaml           |   97 ++
 MAINTAINERS                                   |    4 +
 arch/arm/boot/dts/bcm2711.dtsi                |   41 +
 arch/arm64/configs/defconfig                  |    1 +
 drivers/acpi/arm64/iort.c                     |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_clock.c |    3 +-
 drivers/of/device.c                           |    2 +-
 drivers/pci/controller/Kconfig                |    9 +
 drivers/pci/controller/Makefile               |    1 +
 .../pci/controller/cadence/pcie-cadence-ep.c  |    7 +-
 drivers/pci/controller/cadence/pcie-cadence.c |    7 +-
 drivers/pci/controller/pcie-brcmstb.c         | 1012 +++++++++++++++++
 drivers/pci/controller/pcie-rockchip-ep.c     |    9 +-
 include/linux/log2.h                          |   52 +
 kernel/dma/direct.c                           |    3 +-
 15 files changed, 1230 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pci/brcm,stb-pcie.yaml
 create mode 100644 drivers/pci/controller/pcie-brcmstb.c

-- 
2.24.0

