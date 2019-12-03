Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC66710FCC0
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 12:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfLCLsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 06:48:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:49822 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726653AbfLCLsG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Dec 2019 06:48:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 523B6AF93;
        Tue,  3 Dec 2019 11:48:03 +0000 (UTC)
From:   Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
To:     andrew.murray@arm.com, maz@kernel.org,
        linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <wahrenst@gmx.net>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     james.quinlan@broadcom.com, mbrugger@suse.com,
        phil@raspberrypi.org, jeremy.linton@arm.com,
        linux-pci@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        devicetree@vger.kernel.org, linux-rockchip@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH v4 8/8] linux/log2.h: Use roundup/dow_pow_two() on 64bit calculations
Date:   Tue,  3 Dec 2019 12:47:41 +0100
Message-Id: <20191203114743.1294-9-nsaenzjulienne@suse.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203114743.1294-1-nsaenzjulienne@suse.de>
References: <20191203114743.1294-1-nsaenzjulienne@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function now is safe to use while expecting a 64bit value. Use it
where relevant.

Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
---
 drivers/acpi/arm64/iort.c                        | 2 +-
 drivers/net/ethernet/mellanox/mlx4/en_clock.c    | 3 ++-
 drivers/of/device.c                              | 3 ++-
 drivers/pci/controller/cadence/pcie-cadence-ep.c | 3 ++-
 drivers/pci/controller/cadence/pcie-cadence.c    | 3 ++-
 drivers/pci/controller/pcie-brcmstb.c            | 3 ++-
 drivers/pci/controller/pcie-rockchip-ep.c        | 5 +++--
 kernel/dma/direct.c                              | 2 +-
 8 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/arm64/iort.c b/drivers/acpi/arm64/iort.c
index 33f71983e001..9950c9757092 100644
--- a/drivers/acpi/arm64/iort.c
+++ b/drivers/acpi/arm64/iort.c
@@ -1090,7 +1090,7 @@ void iort_dma_setup(struct device *dev, u64 *dma_addr, u64 *dma_size)
 		 * firmware.
 		 */
 		end = dmaaddr + size - 1;
-		mask = DMA_BIT_MASK(ilog2(end) + 1);
+		mask = roundup_pow_of_two(end) - 1;
 		dev->bus_dma_limit = end;
 		dev->coherent_dma_mask = mask;
 		*dev->dma_mask = mask;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_clock.c b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
index 024788549c25..23dcb18224d4 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_clock.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
@@ -33,6 +33,7 @@
 
 #include <linux/mlx4/device.h>
 #include <linux/clocksource.h>
+#include <linux/log2.h>
 
 #include "mlx4_en.h"
 
@@ -252,7 +253,7 @@ static u32 freq_to_shift(u16 freq)
 {
 	u32 freq_khz = freq * 1000;
 	u64 max_val_cycles = freq_khz * 1000 * MLX4_EN_WRAP_AROUND_SEC;
-	u64 max_val_cycles_rounded = 1ULL << fls64(max_val_cycles - 1);
+	u64 max_val_cycles_rounded = roundup_pow_of_two(max_val_cycles);
 	/* calculate max possible multiplier in order to fit in 64bit */
 	u64 max_mul = div64_u64(ULLONG_MAX, max_val_cycles_rounded);
 
diff --git a/drivers/of/device.c b/drivers/of/device.c
index e9127db7b067..7259922d2078 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -11,6 +11,7 @@
 #include <linux/mod_devicetable.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
+#include <linux/log2.h>
 
 #include <asm/errno.h>
 #include "of_private.h"
@@ -149,7 +150,7 @@ int of_dma_configure(struct device *dev, struct device_node *np, bool force_dma)
 	 * set by the driver.
 	 */
 	end = dma_addr + size - 1;
-	mask = DMA_BIT_MASK(ilog2(end) + 1);
+	mask = roundup_pow_of_two(end) - 1;
 	dev->coherent_dma_mask &= mask;
 	*dev->dma_mask &= mask;
 	/* ...but only set bus limit if we found valid dma-ranges earlier */
diff --git a/drivers/pci/controller/cadence/pcie-cadence-ep.c b/drivers/pci/controller/cadence/pcie-cadence-ep.c
index 1c173dad67d1..72eda0b2f939 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-ep.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-ep.c
@@ -10,6 +10,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/sizes.h>
+#include <linux/log2.h>
 
 #include "pcie-cadence.h"
 
@@ -65,7 +66,7 @@ static int cdns_pcie_ep_set_bar(struct pci_epc *epc, u8 fn,
 	 * roundup_pow_of_two() returns an unsigned long, which is not suited
 	 * for 64bit values.
 	 */
-	sz = 1ULL << fls64(sz - 1);
+	sz = roundup_pow_of_two(sz);
 	aperture = ilog2(sz) - 7; /* 128B -> 0, 256B -> 1, 512B -> 2, ... */
 
 	if ((flags & PCI_BASE_ADDRESS_SPACE) == PCI_BASE_ADDRESS_SPACE_IO) {
diff --git a/drivers/pci/controller/cadence/pcie-cadence.c b/drivers/pci/controller/cadence/pcie-cadence.c
index cd795f6fc1e2..b1689f725b41 100644
--- a/drivers/pci/controller/cadence/pcie-cadence.c
+++ b/drivers/pci/controller/cadence/pcie-cadence.c
@@ -4,6 +4,7 @@
 // Author: Cyrille Pitchen <cyrille.pitchen@free-electrons.com>
 
 #include <linux/kernel.h>
+#include <linux/log2.h>
 
 #include "pcie-cadence.h"
 
@@ -15,7 +16,7 @@ void cdns_pcie_set_outbound_region(struct cdns_pcie *pcie, u8 fn,
 	 * roundup_pow_of_two() returns an unsigned long, which is not suited
 	 * for 64bit values.
 	 */
-	u64 sz = 1ULL << fls64(size - 1);
+	u64 sz = roundup_pow_of_two(size);
 	int nbits = ilog2(sz);
 	u32 addr0, addr1, desc0, desc1;
 
diff --git a/drivers/pci/controller/pcie-brcmstb.c b/drivers/pci/controller/pcie-brcmstb.c
index 7ba06a0e1a71..e705d9d73030 100644
--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -627,7 +627,8 @@ static inline int brcm_pcie_get_rc_bar2_size_and_offset(struct brcm_pcie *pcie,
 		return -ENODEV;
 
 	*rc_bar2_offset = -entry->offset;
-	*rc_bar2_size = 1ULL << fls64(entry->res->end - entry->res->start);
+	*rc_bar2_size = roundup_pow_of_two(entry->res->end -
+					   entry->res->start + 1);
 
 	/*
 	 * We validate the inbound memory view even though we should trust
diff --git a/drivers/pci/controller/pcie-rockchip-ep.c b/drivers/pci/controller/pcie-rockchip-ep.c
index d743b0a48988..83665f5f804a 100644
--- a/drivers/pci/controller/pcie-rockchip-ep.c
+++ b/drivers/pci/controller/pcie-rockchip-ep.c
@@ -16,6 +16,7 @@
 #include <linux/platform_device.h>
 #include <linux/pci-epf.h>
 #include <linux/sizes.h>
+#include <linux/log2.h>
 
 #include "pcie-rockchip.h"
 
@@ -70,7 +71,7 @@ static void rockchip_pcie_prog_ep_ob_atu(struct rockchip_pcie *rockchip, u8 fn,
 					 u32 r, u32 type, u64 cpu_addr,
 					 u64 pci_addr, size_t size)
 {
-	u64 sz = 1ULL << fls64(size - 1);
+	u64 sz = roundup_pow_of_two(size);
 	int num_pass_bits = ilog2(sz);
 	u32 addr0, addr1, desc0, desc1;
 	bool is_nor_msg = (type == AXI_WRAPPER_NOR_MSG);
@@ -176,7 +177,7 @@ static int rockchip_pcie_ep_set_bar(struct pci_epc *epc, u8 fn,
 	 * roundup_pow_of_two() returns an unsigned long, which is not suited
 	 * for 64bit values.
 	 */
-	sz = 1ULL << fls64(sz - 1);
+	sz = roundup_pow_of_two(sz);
 	aperture = ilog2(sz) - 7; /* 128B -> 0, 256B -> 1, 512B -> 2, ... */
 
 	if ((flags & PCI_BASE_ADDRESS_SPACE) == PCI_BASE_ADDRESS_SPACE_IO) {
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 6af7ae83c4ad..056886c4efec 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -53,7 +53,7 @@ u64 dma_direct_get_required_mask(struct device *dev)
 {
 	u64 max_dma = phys_to_dma_direct(dev, (max_pfn - 1) << PAGE_SHIFT);
 
-	return (1ULL << (fls64(max_dma) - 1)) * 2 - 1;
+	return rounddown_pow_of_two(max_dma) * 2 - 1;
 }
 
 static gfp_t __dma_direct_optimal_gfp_mask(struct device *dev, u64 dma_mask,
-- 
2.24.0

