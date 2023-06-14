Return-Path: <netdev+bounces-10935-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66103730B6F
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:18:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 112D928160A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:18:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 281F3168D3;
	Wed, 14 Jun 2023 23:12:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADD1168BE
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 23:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0331C433C8;
	Wed, 14 Jun 2023 23:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686784324;
	bh=uuKmp0xLbJ5YLoXCGTYIkQIfZt6VXITzXOV+Cj45BTI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=ogTbDU4Uv9JOYzRjb1ir3GDsm+szQnq9G6AhIHnP+mhZTTtBtUt+m2dTw5fsGg+gk
	 W5XFjTwKQSWpQzYo0rEnLIrj8uImDiUupNFOHK8h68bTQR8SIrVkKgFStLpSp5EEqS
	 hyuE86lZ0Zq70qYipafi4hANX7D3suzy1H3Gx1YbaUk/FU0PjFjxf/PcfYb9bAovAr
	 D5gZZOHs4YmmU97d0RxGs3ynOj1+cR9jx75h0B32XYECrARN3IV/8v6gzSjih6AmKy
	 Urorc+arUzvzpyATsT0YOUSiz/jiz7sRxfVxknMk+zRqhfT2k+coxxBgjL7Rkank4M
	 h5oLj5W53H/Vw==
Date: Wed, 14 Jun 2023 18:12:03 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Mahesh J Salgaonkar <mahesh@linux.ibm.com>,
	Oliver O'Halloran <oohall@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
	David Abdurachmanov <david.abdurachmanov@gmail.com>,
	linux-rdma@vger.kernel.org,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	Alex Williamson <alex.williamson@redhat.com>,
	Lukas Wunner <lukas@wunner.de>, linux-pci@vger.kernel.org,
	Stefan Roese <sr@denx.de>, Jim Wilson <wilson@tuliptree.org>,
	netdev@vger.kernel.org
Subject: Re: [PATCH v9 00/14] pci: Work around ASMedia ASM2824 PCIe link
 training failures
Message-ID: <20230614231203.GA1451606@bhelgaas>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2305310024400.59226@angie.orcam.me.uk>

On Sun, Jun 11, 2023 at 06:19:08PM +0100, Maciej W. Rozycki wrote:
> Hi,
> 
>  This is v9 of the change to work around a PCIe link training phenomenon 
> where a pair of devices both capable of operating at a link speed above 
> 2.5GT/s seems unable to negotiate the link speed and continues training 
> indefinitely with the Link Training bit switching on and off repeatedly 
> and the data link layer never reaching the active state.
> 
>  With several requests addressed and a few extra issues spotted this
> version has now grown to 14 patches.  It has been verified for device 
> enumeration with and without PCI_QUIRKS enabled, using the same piece of 
> RISC-V hardware as previously.  Hot plug or reset events have not been 
> verified, as this is difficult if at all feasible with hardware in 
> question.
> 
>  Last iteration: 
> <https://lore.kernel.org/r/alpine.DEB.2.21.2304060100160.13659@angie.orcam.me.uk/>, 
> and my input to it:
> <https://lore.kernel.org/r/alpine.DEB.2.21.2306080224280.36323@angie.orcam.me.uk/>.

Thanks, I applied these to pci/enumeration for v6.5.

I tweaked a few things, so double-check to be sure I didn't break
something:

  - Moved dev->link_active_reporting init to set_pcie_port_type()
    because it does other PCIe-related stuff.

  - Reordered to keep all the link_active_reporting things together.

  - Reordered to clean up & factor pcie_retrain_link() before exposing
    it to the rest of the PCI core.

  - Moved pcie_retrain_link() a little earlier to keep it next to
    pcie_wait_for_link_status().

  - Squashed the stubs into the actual quirk so we don't have the
    intermediate state where we call the stubs but they never do
    anything (let me know if there's a reason we need your order).

  - Inline pcie_parent_link_retrain(), which seemed like it didn't add
    enough to be worthwhile.

Interdiff below:

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 80694e2574b8..f11268924c8f 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1153,27 +1153,16 @@ void pci_resume_bus(struct pci_bus *bus)
 		pci_walk_bus(bus, pci_resume_one, NULL);
 }
 
-/**
- * pcie_parent_link_retrain - Check and retrain link we are downstream from
- * @dev: PCI device to handle.
- *
- * Return TRUE if the link was retrained, FALSE otherwise.
- */
-static bool pcie_parent_link_retrain(struct pci_dev *dev)
-{
-	struct pci_dev *bridge;
-
-	bridge = pci_upstream_bridge(dev);
-	if (bridge)
-		return pcie_failed_link_retrain(bridge);
-	else
-		return false;
-}
-
 static int pci_dev_wait(struct pci_dev *dev, char *reset_type, int timeout)
 {
-	bool retrain = true;
 	int delay = 1;
+	bool retrain = false;
+	struct pci_dev *bridge;
+
+	if (pci_is_pcie(dev)) {
+		retrain = true;
+		bridge = pci_upstream_bridge(dev);
+	}
 
 	/*
 	 * After reset, the device should not silently discard config
@@ -1201,9 +1190,9 @@ static int pci_dev_wait(struct pci_dev *dev, char *reset_type, int timeout)
 		}
 
 		if (delay > PCI_RESET_WAIT) {
-			if (retrain) {
+			if (retrain && bridge) {
 				retrain = false;
-				if (pcie_parent_link_retrain(dev)) {
+				if (pcie_failed_link_retrain(bridge)) {
 					delay = 1;
 					continue;
 				}
@@ -4914,6 +4903,38 @@ static bool pcie_wait_for_link_status(struct pci_dev *pdev,
 	return (lnksta & lnksta_mask) == lnksta_match;
 }
 
+/**
+ * pcie_retrain_link - Request a link retrain and wait for it to complete
+ * @pdev: Device whose link to retrain.
+ * @use_lt: Use the LT bit if TRUE, or the DLLLA bit if FALSE, for status.
+ *
+ * Retrain completion status is retrieved from the Link Status Register
+ * according to @use_lt.  It is not verified whether the use of the DLLLA
+ * bit is valid.
+ *
+ * Return TRUE if successful, or FALSE if training has not completed
+ * within PCIE_LINK_RETRAIN_TIMEOUT_MS milliseconds.
+ */
+bool pcie_retrain_link(struct pci_dev *pdev, bool use_lt)
+{
+	u16 lnkctl;
+
+	pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &lnkctl);
+	lnkctl |= PCI_EXP_LNKCTL_RL;
+	pcie_capability_write_word(pdev, PCI_EXP_LNKCTL, lnkctl);
+	if (pdev->clear_retrain_link) {
+		/*
+		 * Due to an erratum in some devices the Retrain Link bit
+		 * needs to be cleared again manually to allow the link
+		 * training to succeed.
+		 */
+		lnkctl &= ~PCI_EXP_LNKCTL_RL;
+		pcie_capability_write_word(pdev, PCI_EXP_LNKCTL, lnkctl);
+	}
+
+	return pcie_wait_for_link_status(pdev, use_lt, !use_lt);
+}
+
 /**
  * pcie_wait_for_link_delay - Wait until link is active or inactive
  * @pdev: Bridge device
@@ -4968,37 +4989,6 @@ bool pcie_wait_for_link(struct pci_dev *pdev, bool active)
 	return pcie_wait_for_link_delay(pdev, active, 100);
 }
 
-/**
- * pcie_retrain_link - Request a link retrain and wait for it to complete
- * @pdev: Device whose link to retrain.
- * @use_lt: Use the LT bit if TRUE, or the DLLLA bit if FALSE, for status.
- *
- * Retrain completion status is retrieved from the Link Status Register
- * according to @use_lt.  It is not verified whether the use of the DLLLA
- * bit is valid.
- *
- * Return TRUE if successful, or FALSE if training has not completed.
- */
-bool pcie_retrain_link(struct pci_dev *pdev, bool use_lt)
-{
-	u16 lnkctl;
-
-	pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &lnkctl);
-	lnkctl |= PCI_EXP_LNKCTL_RL;
-	pcie_capability_write_word(pdev, PCI_EXP_LNKCTL, lnkctl);
-	if (pdev->clear_retrain_link) {
-		/*
-		 * Due to an erratum in some devices the Retrain Link bit
-		 * needs to be cleared again manually to allow the link
-		 * training to succeed.
-		 */
-		lnkctl &= ~PCI_EXP_LNKCTL_RL;
-		pcie_capability_write_word(pdev, PCI_EXP_LNKCTL, lnkctl);
-	}
-
-	return pcie_wait_for_link_status(pdev, use_lt, !use_lt);
-}
-
 /*
  * Find maximum D3cold delay required by all the devices on the bus.  The
  * spec says 100 ms, but firmware can lower it and we allow drivers to
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 016a9d4a61f7..f547db0a728f 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1526,6 +1526,7 @@ void set_pcie_port_type(struct pci_dev *pdev)
 {
 	int pos;
 	u16 reg16;
+	u32 reg32;
 	int type;
 	struct pci_dev *parent;
 
@@ -1539,6 +1540,10 @@ void set_pcie_port_type(struct pci_dev *pdev)
 	pci_read_config_dword(pdev, pos + PCI_EXP_DEVCAP, &pdev->devcap);
 	pdev->pcie_mpss = FIELD_GET(PCI_EXP_DEVCAP_PAYLOAD, pdev->devcap);
 
+	pcie_capability_read_dword(pdev, PCI_EXP_LNKCAP, &reg32);
+	if (reg32 & PCI_EXP_LNKCAP_DLLLARC)
+		pdev->link_active_reporting = 1;
+
 	parent = pci_upstream_bridge(pdev);
 	if (!parent)
 		return;
@@ -1828,7 +1833,6 @@ int pci_setup_device(struct pci_dev *dev)
 	int err, pos = 0;
 	struct pci_bus_region region;
 	struct resource *res;
-	u32 linkcap;
 
 	hdr_type = pci_hdr_type(dev);
 
@@ -1876,10 +1880,6 @@ int pci_setup_device(struct pci_dev *dev)
 	/* "Unknown power state" */
 	dev->current_state = PCI_UNKNOWN;
 
-	/* Set it early to make it available to fixups, etc.  */
-	pcie_capability_read_dword(dev, PCI_EXP_LNKCAP, &linkcap);
-	dev->link_active_reporting = !!(linkcap & PCI_EXP_LNKCAP_DLLLARC);
-
 	/* Early fixups, before probing the BARs */
 	pci_fixup_device(pci_fixup_early, dev);
 

