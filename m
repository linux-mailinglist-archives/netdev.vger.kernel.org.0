Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBEE320EA8
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 01:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhBVAMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 19:12:31 -0500
Received: from mail-lj1-f178.google.com ([209.85.208.178]:34906 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbhBVAM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 19:12:29 -0500
Received: by mail-lj1-f178.google.com with SMTP id a17so53178935ljq.2;
        Sun, 21 Feb 2021 16:12:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iAV4QBzD8PGsRdJ/UfZ3CXI2nHgklw5SFON490rbnhA=;
        b=o0clzOs8k8xRQDtUS2dx/xJEHx9p0HCPbd2odOLAASQ45PputusYrx70X2Pz6RvRSd
         w+br0zH5erotXXUOH5d8PEv4Q41BzoYzl7SXVDL59WdVjNWpJYe5AMh5qBM88g3jlGG2
         zLZqEZ7oMtu7UmHcYNkkkFOgc9ZBBSCm/G1WlHRjM9hLosjaKGIToJTS+SAWqd3LaJM1
         TiX0CE4zq61nCG7sWcDMh6Yp29u9fwJKaYbeGb0x1q0G67ccEtYKn7gBqqos/yM9ptuK
         9BtmKKtK+NwarlYE3lDNdvoe+7OnSXOieb6LDRixjmu4TVf8HW+vZESFRw5D8MMMQKXW
         Nhhw==
X-Gm-Message-State: AOAM5303X3vnM8snYBjY25gyMd0EjkHn3AKvaKB7O8GDzXJvUaXFLihb
        W3UC0k8QIlHy0o8Nt72dWl8=
X-Google-Smtp-Source: ABdhPJzA6jsVAcee2KhqjJLnDSkFdh5FNVoXBAEGcc63jkoFjzBcIF3MFjeGkWfCo9NLtYA1tcU1UA==
X-Received: by 2002:a05:651c:2001:: with SMTP id s1mr13318496ljo.181.1613952705461;
        Sun, 21 Feb 2021 16:11:45 -0800 (PST)
Received: from workstation.lan ([95.155.85.46])
        by smtp.gmail.com with ESMTPSA id w6sm606166lfn.136.2021.02.21.16.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 16:11:44 -0800 (PST)
From:   =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Colin Ian King <colin.king@canonical.com>,
        Myron Stowe <myron.stowe@redhat.com>, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-net-drivers@solarflare.com,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v2] PCI: Convert enum pci_dev_flags to bit fields in struct pci_dev
Date:   Mon, 22 Feb 2021 00:11:43 +0000
Message-Id: <20210222001143.2200687-1-kw@linux.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All the flags defined in the enum pci_dev_flags are used to determine
whether a particular feature of an underlying PCI device should be used
or not - features are also often disabled via a device-specific quirk.

These flags are tightly coupled with a PCI device and primarily used in
simple binary on/off manner to check whether something is enabled or
disabled, and have almost no other users (aside of two network drivers)
outside of the PCI device drivers space.

Therefore, convert enum pci_dev_flags into a set of bit fields in the
struct pci_dev, and then drop said enum and the typedef pci_dev_flags_t.

This will keep PCI device-specific features as part of the struct
pci_dev and make the code that used to use flags simpler.

Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Krzysztof Wilczyński <kw@linux.com>
Acked-by: Martin Habets <mhabets@solarflare.com>
---
Changes in v2:
  Added missing "PCI" prefix to the subject.
  Rebased against kernel 5.11 resolving conflicts with the following:
    - drivers/pci/pci.c
    - include/linux/pci.h
  Added Martin's "Acked-by" for drivers/net/ethernet/sfc/ef10_sriov.c.

 drivers/net/ethernet/atheros/alx/main.c |  2 +-
 drivers/net/ethernet/sfc/ef10_sriov.c   |  3 +-
 drivers/pci/msi.c                       |  2 +-
 drivers/pci/pci.c                       | 23 ++++++------
 drivers/pci/probe.c                     |  2 +-
 drivers/pci/quirks.c                    | 24 ++++++-------
 drivers/pci/search.c                    |  4 +--
 drivers/pci/vpd.c                       |  4 +--
 include/linux/pci.h                     | 47 +++++++++----------------
 9 files changed, 48 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 9b7f1af5f574..c52669f8ec26 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1763,7 +1763,7 @@ static int alx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->watchdog_timeo = ALX_WATCHDOG_TIME;
 
 	if (ent->driver_data & ALX_DEV_QUIRK_MSI_INTX_DISABLE_BUG)
-		pdev->dev_flags |= PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG;
+		pdev->msi_intx_disabled = 1;
 
 	err = alx_init_sw(alx);
 	if (err) {
diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
index 21fa6c0e8873..9af7e11ea113 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -122,8 +122,7 @@ static void efx_ef10_sriov_free_vf_vports(struct efx_nic *efx)
 		struct ef10_vf *vf = nic_data->vf + i;
 
 		/* If VF is assigned, do not free the vport  */
-		if (vf->pci_dev &&
-		    vf->pci_dev->dev_flags & PCI_DEV_FLAGS_ASSIGNED)
+		if (vf->pci_dev && vf->pci_dev->flags_assigned)
 			continue;
 
 		if (vf->vport_assigned) {
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 3162f88fe940..e66a11a1d9f1 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -408,7 +408,7 @@ static void free_msi_irqs(struct pci_dev *dev)
 
 static void pci_intx_for_msi(struct pci_dev *dev, int enable)
 {
-	if (!(dev->dev_flags & PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG))
+	if (!dev->msi_intx_disabled)
 		pci_intx(dev, enable);
 }
 
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 790393d1e318..7ba09819f224 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1327,7 +1327,7 @@ int pci_set_power_state(struct pci_dev *dev, pci_power_t state)
 	 * This device is quirked not to be put into D3, so don't put it in
 	 * D3
 	 */
-	if (state >= PCI_D3hot && (dev->dev_flags & PCI_DEV_FLAGS_NO_D3))
+	if (state >= PCI_D3hot && dev->no_d3)
 		return 0;
 
 	/*
@@ -4572,7 +4572,7 @@ bool pcie_has_flr(struct pci_dev *dev)
 {
 	u32 cap;
 
-	if (dev->dev_flags & PCI_DEV_FLAGS_NO_FLR_RESET)
+	if (dev->no_flr_reset)
 		return false;
 
 	pcie_capability_read_dword(dev, PCI_EXP_DEVCAP, &cap);
@@ -4618,7 +4618,7 @@ static int pci_af_flr(struct pci_dev *dev, int probe)
 	if (!pos)
 		return -ENOTTY;
 
-	if (dev->dev_flags & PCI_DEV_FLAGS_NO_FLR_RESET)
+	if (dev->no_flr_reset)
 		return -ENOTTY;
 
 	pci_read_config_byte(dev, pos + PCI_AF_CAP, &cap);
@@ -4672,7 +4672,7 @@ static int pci_pm_reset(struct pci_dev *dev, int probe)
 {
 	u16 csr;
 
-	if (!dev->pm_cap || dev->dev_flags & PCI_DEV_FLAGS_NO_PM_RESET)
+	if (!dev->pm_cap || dev->no_pm_reset)
 		return -ENOTTY;
 
 	pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &csr);
@@ -4933,7 +4933,7 @@ static int pci_parent_bus_reset(struct pci_dev *dev, int probe)
 	struct pci_dev *pdev;
 
 	if (pci_is_root_bus(dev->bus) || dev->subordinate ||
-	    !dev->bus->self || dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET)
+	    !dev->bus->self || dev->no_bus_reset)
 		return -ENOTTY;
 
 	list_for_each_entry(pdev, &dev->bus->devices, bus_list)
@@ -4963,8 +4963,8 @@ static int pci_reset_hotplug_slot(struct hotplug_slot *hotplug, int probe)
 
 static int pci_dev_reset_slot_function(struct pci_dev *dev, int probe)
 {
-	if (dev->multifunction || dev->subordinate || !dev->slot ||
-	    dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET)
+	if (dev->multifunction || dev->subordinate ||
+	    !dev->slot || dev->no_bus_reset)
 		return -ENOTTY;
 
 	return pci_reset_hotplug_slot(dev->slot->hotplug, probe);
@@ -5232,11 +5232,11 @@ static bool pci_bus_resetable(struct pci_bus *bus)
 	struct pci_dev *dev;
 
 
-	if (bus->self && (bus->self->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET))
+	if (bus->self && bus->self->no_bus_reset)
 		return false;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
-		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
+		if (dev->no_bus_reset ||
 		    (dev->subordinate && !pci_bus_resetable(dev->subordinate)))
 			return false;
 	}
@@ -5299,14 +5299,13 @@ static bool pci_slot_resetable(struct pci_slot *slot)
 {
 	struct pci_dev *dev;
 
-	if (slot->bus->self &&
-	    (slot->bus->self->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET))
+	if (slot->bus->self && slot->bus->self->no_bus_reset)
 		return false;
 
 	list_for_each_entry(dev, &slot->bus->devices, bus_list) {
 		if (!dev->slot || dev->slot != slot)
 			continue;
-		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
+		if (dev->no_bus_reset ||
 		    (dev->subordinate && !pci_bus_resetable(dev->subordinate)))
 			return false;
 	}
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 953f15abc850..71f97bac4776 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2086,7 +2086,7 @@ static void pci_configure_relaxed_ordering(struct pci_dev *dev)
 	if (!root)
 		return;
 
-	if (root->dev_flags & PCI_DEV_FLAGS_NO_RELAXED_ORDERING) {
+	if (root->no_relaxed_ordering) {
 		pcie_capability_clear_word(dev, PCI_EXP_DEVCTL,
 					   PCI_EXP_DEVCTL_RELAX_EN);
 		pci_info(dev, "Relaxed Ordering disabled because the Root Port didn't support it\n");
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 653660e3ba9e..33bc774e372d 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1341,7 +1341,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801CA_10, qui
 /* Some ATA devices break if put into D3 */
 static void quirk_no_ata_d3(struct pci_dev *pdev)
 {
-	pdev->dev_flags |= PCI_DEV_FLAGS_NO_D3;
+	pdev->no_d3 = 1;
 }
 /* Quirk the legacy ATA devices only. The AHCI ones are ok */
 DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_SERVERWORKS, PCI_ANY_ID,
@@ -2963,7 +2963,7 @@ DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID, nv_msi_ht_cap_q
 
 static void quirk_msi_intx_disable_bug(struct pci_dev *dev)
 {
-	dev->dev_flags |= PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG;
+	dev->msi_intx_disabled = 1;
 }
 
 static void quirk_msi_intx_disable_ati_bug(struct pci_dev *dev)
@@ -2981,7 +2981,7 @@ static void quirk_msi_intx_disable_ati_bug(struct pci_dev *dev)
 		return;
 
 	if ((p->revision < 0x3B) && (p->revision >= 0x30))
-		dev->dev_flags |= PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG;
+		dev->msi_intx_disabled = 1;
 	pci_dev_put(p);
 }
 
@@ -2990,7 +2990,7 @@ static void quirk_msi_intx_disable_qca_bug(struct pci_dev *dev)
 	/* AR816X/AR817X/E210X MSI is fixed at HW level from revision 0x18 */
 	if (dev->revision < 0x18) {
 		pci_info(dev, "set MSI_INTX_DISABLE_BUG flag\n");
-		dev->dev_flags |= PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG;
+		dev->msi_intx_disabled = 1;
 	}
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
@@ -3555,7 +3555,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX, PCI_ANY_ID,
 
 static void quirk_no_bus_reset(struct pci_dev *dev)
 {
-	dev->dev_flags |= PCI_DEV_FLAGS_NO_BUS_RESET;
+	dev->no_bus_reset = 1;
 }
 
 /*
@@ -3585,7 +3585,7 @@ static void quirk_no_pm_reset(struct pci_dev *dev)
 	 * PM reset may be better than nothing.
 	 */
 	if (!pci_is_root_bus(dev->bus))
-		dev->dev_flags |= PCI_DEV_FLAGS_NO_PM_RESET;
+		dev->no_pm_reset = 1;
 }
 
 /*
@@ -4071,7 +4071,7 @@ static void quirk_use_pcie_bridge_dma_alias(struct pci_dev *pdev)
 	    pdev->hdr_type == PCI_HEADER_TYPE_BRIDGE &&
 	    !pci_is_pcie(pdev) && pci_is_pcie(pdev->bus->self) &&
 	    pci_pcie_type(pdev->bus->self) != PCI_EXP_TYPE_PCI_BRIDGE)
-		pdev->dev_flags |= PCI_DEV_FLAG_PCIE_BRIDGE_ALIAS;
+		pdev->pcie_bridge_alias = 1;
 }
 /* ASM1083/1085, https://bugzilla.kernel.org/show_bug.cgi?id=44881#c46 */
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ASMEDIA, 0x1080,
@@ -4136,7 +4136,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x295A, quirk_pex_vca_alias);
  */
 static void quirk_bridge_cavm_thrx2_pcie_root(struct pci_dev *pdev)
 {
-	pdev->dev_flags |= PCI_DEV_FLAGS_BRIDGE_XLATE_ROOT;
+	pdev->bridge_xlate_root = 1;
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_BROADCOM, 0x9000,
 				quirk_bridge_cavm_thrx2_pcie_root);
@@ -4172,7 +4172,7 @@ DECLARE_PCI_FIXUP_CLASS_EARLY(0x1797, 0x6869, PCI_CLASS_NOT_DEFINED, 8,
  */
 static void quirk_relaxedordering_disable(struct pci_dev *dev)
 {
-	dev->dev_flags |= PCI_DEV_FLAGS_NO_RELAXED_ORDERING;
+	dev->no_relaxed_ordering = 1;
 	pci_info(dev, "Disable Relaxed Ordering Attributes to avoid PCIe Completion erratum\n");
 }
 
@@ -4504,7 +4504,7 @@ static int pci_quirk_intel_pch_acs(struct pci_dev *dev, u16 acs_flags)
 	if (!pci_quirk_intel_pch_acs_match(dev))
 		return -ENOTTY;
 
-	if (dev->dev_flags & PCI_DEV_FLAGS_ACS_ENABLED_QUIRK)
+	if (dev->acs_quirk_enabled)
 		return pci_acs_ctrl_enabled(acs_flags,
 			PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
 
@@ -4915,7 +4915,7 @@ static int pci_quirk_enable_intel_pch_acs(struct pci_dev *dev)
 
 	pci_quirk_enable_intel_rp_mpc_acs(dev);
 
-	dev->dev_flags |= PCI_DEV_FLAGS_ACS_ENABLED_QUIRK;
+	dev->acs_quirk_enabled = 1;
 
 	pci_info(dev, "Intel PCH root port ACS workaround enabled\n");
 
@@ -5128,7 +5128,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x443, quirk_intel_qat_vf_cap);
  */
 static void quirk_no_flr(struct pci_dev *dev)
 {
-	dev->dev_flags |= PCI_DEV_FLAGS_NO_FLR_RESET;
+	dev->no_flr_reset = 1;
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x1487, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x148c, quirk_no_flr);
diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index 2061672954ee..b26b12e2cc3f 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -67,7 +67,7 @@ int pci_for_each_dma_alias(struct pci_dev *pdev,
 		tmp = bus->self;
 
 		/* stop at bridge where translation unit is associated */
-		if (tmp->dev_flags & PCI_DEV_FLAGS_BRIDGE_XLATE_ROOT)
+		if (tmp->bridge_xlate_root)
 			return ret;
 
 		/*
@@ -99,7 +99,7 @@ int pci_for_each_dma_alias(struct pci_dev *pdev,
 				continue;
 			}
 		} else {
-			if (tmp->dev_flags & PCI_DEV_FLAG_PCIE_BRIDGE_ALIAS)
+			if (tmp->pcie_bridge_alias)
 				ret = fn(tmp,
 					 PCI_DEVID(tmp->subordinate->number,
 						   PCI_DEVFN(0, 0)), data);
diff --git a/drivers/pci/vpd.c b/drivers/pci/vpd.c
index 7915d10f9aa1..5c4366362bd7 100644
--- a/drivers/pci/vpd.c
+++ b/drivers/pci/vpd.c
@@ -380,7 +380,7 @@ int pci_vpd_init(struct pci_dev *dev)
 		return -ENOMEM;
 
 	vpd->len = PCI_VPD_MAX_SIZE;
-	if (dev->dev_flags & PCI_DEV_FLAGS_VPD_REF_F0)
+	if (dev->pci_vpd_f0)
 		vpd->ops = &pci_vpd_f0_ops;
 	else
 		vpd->ops = &pci_vpd_ops;
@@ -536,7 +536,7 @@ static void quirk_f0_vpd_link(struct pci_dev *dev)
 
 	if (f0->vpd && dev->class == f0->class &&
 	    dev->vendor == f0->vendor && dev->device == f0->device)
-		dev->dev_flags |= PCI_DEV_FLAGS_VPD_REF_F0;
+		dev->pci_vpd_f0 = 1;
 
 	pci_dev_put(f0);
 }
diff --git a/include/linux/pci.h b/include/linux/pci.h
index b32126d26997..aee4658989f7 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -203,32 +203,6 @@ enum pcie_reset_state {
 	pcie_hot_reset = (__force pcie_reset_state_t) 3
 };
 
-typedef unsigned short __bitwise pci_dev_flags_t;
-enum pci_dev_flags {
-	/* INTX_DISABLE in PCI_COMMAND register disables MSI too */
-	PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG = (__force pci_dev_flags_t) (1 << 0),
-	/* Device configuration is irrevocably lost if disabled into D3 */
-	PCI_DEV_FLAGS_NO_D3 = (__force pci_dev_flags_t) (1 << 1),
-	/* Provide indication device is assigned by a Virtual Machine Manager */
-	PCI_DEV_FLAGS_ASSIGNED = (__force pci_dev_flags_t) (1 << 2),
-	/* Flag for quirk use to store if quirk-specific ACS is enabled */
-	PCI_DEV_FLAGS_ACS_ENABLED_QUIRK = (__force pci_dev_flags_t) (1 << 3),
-	/* Use a PCIe-to-PCI bridge alias even if !pci_is_pcie */
-	PCI_DEV_FLAG_PCIE_BRIDGE_ALIAS = (__force pci_dev_flags_t) (1 << 5),
-	/* Do not use bus resets for device */
-	PCI_DEV_FLAGS_NO_BUS_RESET = (__force pci_dev_flags_t) (1 << 6),
-	/* Do not use PM reset even if device advertises NoSoftRst- */
-	PCI_DEV_FLAGS_NO_PM_RESET = (__force pci_dev_flags_t) (1 << 7),
-	/* Get VPD from function 0 VPD */
-	PCI_DEV_FLAGS_VPD_REF_F0 = (__force pci_dev_flags_t) (1 << 8),
-	/* A non-root bridge where translation occurs, stop alias search here */
-	PCI_DEV_FLAGS_BRIDGE_XLATE_ROOT = (__force pci_dev_flags_t) (1 << 9),
-	/* Do not use FLR even if device advertises PCI_AF_CAP */
-	PCI_DEV_FLAGS_NO_FLR_RESET = (__force pci_dev_flags_t) (1 << 10),
-	/* Don't use Relaxed Ordering for TLPs directed at this device */
-	PCI_DEV_FLAGS_NO_RELAXED_ORDERING = (__force pci_dev_flags_t) (1 << 11),
-};
-
 enum pci_irq_reroute_variant {
 	INTEL_IRQ_REROUTE_VARIANT = 1,
 	MAX_IRQ_REROUTE_VARIANTS = 3
@@ -453,7 +427,20 @@ struct pci_dev {
 	unsigned int	link_active_reporting:1;/* Device capable of reporting link active */
 	unsigned int	no_vf_scan:1;		/* Don't scan for VFs after IOV enablement */
 	unsigned int	no_command_memory:1;	/* No PCI_COMMAND_MEMORY */
-	pci_dev_flags_t dev_flags;
+
+	/* PCI device flags */
+	unsigned int	flags_assigned:1;	/* Provide indication device is assigned by a Virtual Machine Manager */
+	unsigned int	msi_intx_disabled:1;	/* INTX_DISABLE in PCI_COMMAND register disables MSI too */
+	unsigned int	acs_quirk_enabled:1;	/* Flag for quirk use to store if quirk-specific ACS is enabled */
+	unsigned int	no_d3:1;		/* Device configuration is irrevocably lost if disabled into D3 */
+	unsigned int	no_bus_reset:1;		/* Don't use bus resets for device */
+	unsigned int	no_pm_reset:1;		/* Don't use PM reset even if device advertises NoSoftRst- */
+	unsigned int	no_flr_reset:1;		/* Don't use FLR even if device advertises PCI_AF_CAP */
+	unsigned int	no_relaxed_ordering:1;	/* Don't use Relaxed Ordering for TLPs directed at this device */
+	unsigned int	pcie_bridge_alias:1;	/* Use a PCIe-to-PCI bridge alias even if !pci_is_pcie */
+	unsigned int	bridge_xlate_root:1;	/* A non-root bridge where translation occurs, stop alias search here */
+	unsigned int	pci_vpd_f0:1;		/* Get VPD from function 0 VPD */
+
 	atomic_t	enable_cnt;	/* pci_enable_device has been called */
 
 	u32		saved_config_space[16]; /* Config space saved at suspend time */
@@ -2354,15 +2341,15 @@ int pci_for_each_dma_alias(struct pci_dev *pdev,
 /* Helper functions for operation of device flag */
 static inline void pci_set_dev_assigned(struct pci_dev *pdev)
 {
-	pdev->dev_flags |= PCI_DEV_FLAGS_ASSIGNED;
+	pdev->flags_assigned = 1;
 }
 static inline void pci_clear_dev_assigned(struct pci_dev *pdev)
 {
-	pdev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
+	pdev->flags_assigned = 0;
 }
 static inline bool pci_is_dev_assigned(struct pci_dev *pdev)
 {
-	return (pdev->dev_flags & PCI_DEV_FLAGS_ASSIGNED) == PCI_DEV_FLAGS_ASSIGNED;
+	return !!pdev->flags_assigned;
 }
 
 /**
-- 
2.30.0

