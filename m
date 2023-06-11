Return-Path: <netdev+bounces-9935-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5304F72B33A
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 19:23:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 926791C20A1C
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 17:22:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 297B8F509;
	Sun, 11 Jun 2023 17:21:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E83CC2E4
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 17:21:14 +0000 (UTC)
X-Greylist: delayed 92 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 11 Jun 2023 10:20:49 PDT
Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id E45F71700;
	Sun, 11 Jun 2023 10:20:48 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 4E8B29200C6; Sun, 11 Jun 2023 19:19:53 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 4858E9200B3;
	Sun, 11 Jun 2023 18:19:53 +0100 (BST)
Date: Sun, 11 Jun 2023 18:19:53 +0100 (BST)
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
Subject: [PATCH v9 10/14] PCI: Add support for polling DLLLA to
 `pcie_retrain_link'
In-Reply-To: <alpine.DEB.2.21.2305310024400.59226@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2306110310540.64925@angie.orcam.me.uk>
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

Let the caller of `pcie_retrain_link' specify whether they want to use 
the LT bit or the DLLLA bit of the Link Status Register to determine if 
link training has completed.  It is up to the caller to verify whether 
the use of the DLLLA bit, the implementation of which is optional, is 
valid for the device requested.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
---
New change in v9.
---
 drivers/pci/pci.c       |   28 ++++++++++++++++++++--------
 drivers/pci/pci.h       |    2 +-
 drivers/pci/pcie/aspm.c |    2 +-
 3 files changed, 22 insertions(+), 10 deletions(-)

linux-pcie-retrain-link-use-lt.diff
Index: linux-macro/drivers/pci/pci.c
===================================================================
--- linux-macro.orig/drivers/pci/pci.c
+++ linux-macro/drivers/pci/pci.c
@@ -4850,25 +4850,32 @@ static int pci_pm_reset(struct pci_dev *
 }
 
 /**
- * pcie_wait_for_link_status - Wait for link training end
+ * pcie_wait_for_link_status - Wait for link status change
  * @pdev: Device whose link to wait for.
+ * @use_lt: Use the LT bit if TRUE, or the DLLLA bit if FALSE.
+ * @active: Waiting for active or inactive?
  *
- * Return TRUE if successful, or FALSE if training has not completed
- * within PCIE_LINK_RETRAIN_TIMEOUT_MS milliseconds.
+ * Return TRUE if successful, or FALSE if status has not changed within
+ * PCIE_LINK_RETRAIN_TIMEOUT_MS milliseconds.
  */
-static bool pcie_wait_for_link_status(struct pci_dev *pdev)
+static bool pcie_wait_for_link_status(struct pci_dev *pdev,
+				      bool use_lt, bool active)
 {
+	u16 lnksta_mask, lnksta_match;
 	unsigned long end_jiffies;
 	u16 lnksta;
 
+	lnksta_mask = use_lt ? PCI_EXP_LNKSTA_LT : PCI_EXP_LNKSTA_DLLLA;
+	lnksta_match = active ? lnksta_mask : 0;
+
 	end_jiffies = jiffies + msecs_to_jiffies(PCIE_LINK_RETRAIN_TIMEOUT_MS);
 	do {
 		pcie_capability_read_word(pdev, PCI_EXP_LNKSTA, &lnksta);
-		if (!(lnksta & PCI_EXP_LNKSTA_LT))
+		if ((lnksta & lnksta_mask) == lnksta_match)
 			break;
 		msleep(1);
 	} while (time_before(jiffies, end_jiffies));
-	return !(lnksta & PCI_EXP_LNKSTA_LT);
+	return (lnksta & lnksta_mask) == lnksta_match;
 }
 
 /**
@@ -4937,10 +4944,15 @@ bool pcie_wait_for_link(struct pci_dev *
 /**
  * pcie_retrain_link - Request a link retrain and wait for it to complete
  * @pdev: Device whose link to retrain.
+ * @use_lt: Use the LT bit if TRUE, or the DLLLA bit if FALSE, for status.
+ *
+ * Retrain completion status is retrieved from the Link Status Register
+ * according to @use_lt.  It is not verified whether the use of the DLLLA
+ * bit is valid.
  *
  * Return TRUE if successful, or FALSE if training has not completed.
  */
-bool pcie_retrain_link(struct pci_dev *pdev)
+bool pcie_retrain_link(struct pci_dev *pdev, bool use_lt)
 {
 	u16 lnkctl;
 
@@ -4957,7 +4969,7 @@ bool pcie_retrain_link(struct pci_dev *p
 		pcie_capability_write_word(pdev, PCI_EXP_LNKCTL, lnkctl);
 	}
 
-	return pcie_wait_for_link_status(pdev);
+	return pcie_wait_for_link_status(pdev, use_lt, !use_lt);
 }
 
 /*
Index: linux-macro/drivers/pci/pci.h
===================================================================
--- linux-macro.orig/drivers/pci/pci.h
+++ linux-macro/drivers/pci/pci.h
@@ -561,7 +561,7 @@ pci_ers_result_t pcie_do_recovery(struct
 		pci_ers_result_t (*reset_subordinates)(struct pci_dev *pdev));
 
 bool pcie_wait_for_link(struct pci_dev *pdev, bool active);
-bool pcie_retrain_link(struct pci_dev *pdev);
+bool pcie_retrain_link(struct pci_dev *pdev, bool use_lt);
 #ifdef CONFIG_PCIEASPM
 void pcie_aspm_init_link_state(struct pci_dev *pdev);
 void pcie_aspm_exit_link_state(struct pci_dev *pdev);
Index: linux-macro/drivers/pci/pcie/aspm.c
===================================================================
--- linux-macro.orig/drivers/pci/pcie/aspm.c
+++ linux-macro/drivers/pci/pcie/aspm.c
@@ -257,7 +257,7 @@ static void pcie_aspm_configure_common_c
 		reg16 &= ~PCI_EXP_LNKCTL_CCC;
 	pcie_capability_write_word(parent, PCI_EXP_LNKCTL, reg16);
 
-	if (pcie_retrain_link(link->pdev))
+	if (pcie_retrain_link(link->pdev, true))
 		return;
 
 	/* Training failed. Restore common clock configurations */

