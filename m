Return-Path: <netdev+bounces-9936-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5020572B33C
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 19:23:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93BD51C20A69
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 17:23:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B35B5101C8;
	Sun, 11 Jun 2023 17:21:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A893AE568
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 17:21:19 +0000 (UTC)
Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id CCE1719AA;
	Sun, 11 Jun 2023 10:20:54 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 6DEA69200CB; Sun, 11 Jun 2023 19:20:06 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 66A4F9200CA;
	Sun, 11 Jun 2023 18:20:06 +0100 (BST)
Date: Sun, 11 Jun 2023 18:20:06 +0100 (BST)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Bjorn Helgaas <bhelgaas@google.com>, 
    Mahesh J Salgaonkar <mahesh@linux.ibm.com>, 
    Oliver O'Halloran <oohall@gmail.com>, 
    Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
    Christophe Leroy <christophe.leroy@csgroup.eu>, 
    Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
    "David S. Miller" <davem@davemloft.net>, 
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
    Paolo Abeni <pabeni@redhat.com>
cc: Alex Williamson <alex.williamson@redhat.com>, 
    Lukas Wunner <lukas@wunner.de>, 
    Mika Westerberg <mika.westerberg@linux.intel.com>, 
    Stefan Roese <sr@denx.de>, Jim Wilson <wilson@tuliptree.org>, 
    David Abdurachmanov <david.abdurachmanov@gmail.com>, 
    =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, linux-pci@vger.kernel.org, 
    linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org, 
    netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 13/14] PCI: Add failed link recovery for device reset
 events
In-Reply-To: <alpine.DEB.2.21.2305310024400.59226@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2306111631050.64925@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2305310024400.59226@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Request failed link recovery with any upstream bridge where a device has 
not come back after reset within PCI_RESET_WAIT time.  Reset the polling 
interval if recovery succeeded, otherwise continue as usual.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
---
New change in v9, factored out from 7/7:

- Remove duplicate succesful completion report previously added (not sure 
  where it came from, possibly an unnoticed leftover from experiments).

- Make the type of `retrain' variable `bool' rather than `int' and invert
  the logic used.

- Rename `pcie_downstream_link_retrain' to `pcie_failed_link_retrain'.

- Rename `pcie_upstream_link_retrain' to `pcie_parent_link_retrain'.  Add 
  documentation.
---
 drivers/pci/pci.c |   39 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

linux-pcie-dev-wait-link-retrain.diff
Index: linux-macro/drivers/pci/pci.c
===================================================================
--- linux-macro.orig/drivers/pci/pci.c
+++ linux-macro/drivers/pci/pci.c
@@ -1146,10 +1146,27 @@ void pci_resume_bus(struct pci_bus *bus)
 		pci_walk_bus(bus, pci_resume_one, NULL);
 }
 
+/**
+ * pcie_parent_link_retrain - Check and retrain link we are downstream from
+ * @dev: PCI device to handle.
+ *
+ * Return TRUE if the link was retrained, FALSE otherwise.
+ */
+static bool pcie_parent_link_retrain(struct pci_dev *dev)
+{
+	struct pci_dev *bridge;
+
+	bridge = pci_upstream_bridge(dev);
+	if (bridge)
+		return pcie_failed_link_retrain(bridge);
+	else
+		return false;
+}
+
 static int pci_dev_wait(struct pci_dev *dev, char *reset_type, int timeout)
 {
+	bool retrain = true;
 	int delay = 1;
-	u32 id;
 
 	/*
 	 * After reset, the device should not silently discard config
@@ -1163,21 +1180,33 @@ static int pci_dev_wait(struct pci_dev *
 	 * Command register instead of Vendor ID so we don't have to
 	 * contend with the CRS SV value.
 	 */
-	pci_read_config_dword(dev, PCI_COMMAND, &id);
-	while (PCI_POSSIBLE_ERROR(id)) {
+	for (;;) {
+		u32 id;
+
+		pci_read_config_dword(dev, PCI_COMMAND, &id);
+		if (!PCI_POSSIBLE_ERROR(id))
+			break;
+
 		if (delay > timeout) {
 			pci_warn(dev, "not ready %dms after %s; giving up\n",
 				 delay - 1, reset_type);
 			return -ENOTTY;
 		}
 
-		if (delay > PCI_RESET_WAIT)
+		if (delay > PCI_RESET_WAIT) {
+			if (retrain) {
+				retrain = false;
+				if (pcie_parent_link_retrain(dev)) {
+					delay = 1;
+					continue;
+				}
+			}
 			pci_info(dev, "not ready %dms after %s; waiting\n",
 				 delay - 1, reset_type);
+		}
 
 		msleep(delay);
 		delay *= 2;
-		pci_read_config_dword(dev, PCI_COMMAND, &id);
 	}
 
 	if (delay > PCI_RESET_WAIT)

