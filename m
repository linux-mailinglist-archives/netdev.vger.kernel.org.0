Return-Path: <netdev+bounces-9933-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C741972B337
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 19:22:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83757281181
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 17:22:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B32FE556;
	Sun, 11 Jun 2023 17:20:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F31C8F9
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 17:20:55 +0000 (UTC)
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7BCA110D0;
	Sun, 11 Jun 2023 10:20:29 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 90AD99200C1; Sun, 11 Jun 2023 19:19:49 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 8B5119200B3;
	Sun, 11 Jun 2023 18:19:49 +0100 (BST)
Date: Sun, 11 Jun 2023 18:19:49 +0100 (BST)
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
Subject: [PATCH v9 09/14] PCI: Factor our waiting for link training end
In-Reply-To: <alpine.DEB.2.21.2305310024400.59226@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2306111605060.64925@angie.orcam.me.uk>
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

Move code polling for the Link Training bit to clear into a function of 
its own.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
---
New change in v9.
---
 drivers/pci/pci.c |   37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

linux-pcie-wait-for-link-status.diff
Index: linux-macro/drivers/pci/pci.c
===================================================================
--- linux-macro.orig/drivers/pci/pci.c
+++ linux-macro/drivers/pci/pci.c
@@ -4850,6 +4850,28 @@ static int pci_pm_reset(struct pci_dev *
 }
 
 /**
+ * pcie_wait_for_link_status - Wait for link training end
+ * @pdev: Device whose link to wait for.
+ *
+ * Return TRUE if successful, or FALSE if training has not completed
+ * within PCIE_LINK_RETRAIN_TIMEOUT_MS milliseconds.
+ */
+static bool pcie_wait_for_link_status(struct pci_dev *pdev)
+{
+	unsigned long end_jiffies;
+	u16 lnksta;
+
+	end_jiffies = jiffies + msecs_to_jiffies(PCIE_LINK_RETRAIN_TIMEOUT_MS);
+	do {
+		pcie_capability_read_word(pdev, PCI_EXP_LNKSTA, &lnksta);
+		if (!(lnksta & PCI_EXP_LNKSTA_LT))
+			break;
+		msleep(1);
+	} while (time_before(jiffies, end_jiffies));
+	return !(lnksta & PCI_EXP_LNKSTA_LT);
+}
+
+/**
  * pcie_wait_for_link_delay - Wait until link is active or inactive
  * @pdev: Bridge device
  * @active: waiting for active or inactive?
@@ -4916,14 +4938,11 @@ bool pcie_wait_for_link(struct pci_dev *
  * pcie_retrain_link - Request a link retrain and wait for it to complete
  * @pdev: Device whose link to retrain.
  *
- * Return TRUE if successful, or FALSE if training has not completed
- * within PCIE_LINK_RETRAIN_TIMEOUT_MS milliseconds.
+ * Return TRUE if successful, or FALSE if training has not completed.
  */
 bool pcie_retrain_link(struct pci_dev *pdev)
 {
-	unsigned long end_jiffies;
 	u16 lnkctl;
-	u16 lnksta;
 
 	pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &lnkctl);
 	lnkctl |= PCI_EXP_LNKCTL_RL;
@@ -4938,15 +4957,7 @@ bool pcie_retrain_link(struct pci_dev *p
 		pcie_capability_write_word(pdev, PCI_EXP_LNKCTL, lnkctl);
 	}
 
-	/* Wait for link training end. Break out after waiting for timeout. */
-	end_jiffies = jiffies + msecs_to_jiffies(PCIE_LINK_RETRAIN_TIMEOUT_MS);
-	do {
-		pcie_capability_read_word(pdev, PCI_EXP_LNKSTA, &lnksta);
-		if (!(lnksta & PCI_EXP_LNKSTA_LT))
-			break;
-		msleep(1);
-	} while (time_before(jiffies, end_jiffies));
-	return !(lnksta & PCI_EXP_LNKSTA_LT);
+	return pcie_wait_for_link_status(pdev);
 }
 
 /*

