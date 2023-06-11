Return-Path: <netdev+bounces-9934-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C819072B339
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 19:22:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77EE52810AB
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 17:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1082F154A7;
	Sun, 11 Jun 2023 17:20:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B3F154A2
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 17:20:56 +0000 (UTC)
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 21BFFE6F;
	Sun, 11 Jun 2023 10:20:30 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 529979200C9; Sun, 11 Jun 2023 19:20:02 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 4E1479200C0;
	Sun, 11 Jun 2023 18:20:02 +0100 (BST)
Date: Sun, 11 Jun 2023 18:20:02 +0100 (BST)
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
Subject: [PATCH v9 12/14] PCI: Provide stub failed link recovery for device
 probing and hot plug
In-Reply-To: <alpine.DEB.2.21.2305310024400.59226@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2306111619570.64925@angie.orcam.me.uk>
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

This now fails unconditionally and will be always optimised away, but 
provides for quirks to implement recovery for failed links detected in 
device probing and device hot plug events.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
---
New change in v9, factored out from 7/7:

- Rename `pcie_downstream_link_retrain' to `pcie_failed_link_retrain'.

- Add stub implementation in "pci.h".
---
 drivers/pci/pci.c   |    2 ++
 drivers/pci/pci.h   |    4 ++++
 drivers/pci/probe.c |    2 ++
 3 files changed, 8 insertions(+)

linux-pcie-failed-link-retrain.diff
Index: linux-macro/drivers/pci/pci.c
===================================================================
--- linux-macro.orig/drivers/pci/pci.c
+++ linux-macro/drivers/pci/pci.c
@@ -4912,6 +4912,8 @@ static bool pcie_wait_for_link_delay(str
 	if (active)
 		msleep(20);
 	ret = pcie_wait_for_link_status(pdev, false, active);
+	if (active && !ret)
+		ret = pcie_failed_link_retrain(pdev);
 	if (active && ret)
 		msleep(delay);
 
Index: linux-macro/drivers/pci/pci.h
===================================================================
--- linux-macro.orig/drivers/pci/pci.h
+++ linux-macro/drivers/pci/pci.h
@@ -554,6 +554,10 @@ static inline int pci_dev_specific_disab
 	return -ENOTTY;
 }
 #endif
+static inline bool pcie_failed_link_retrain(struct pci_dev *dev)
+{
+	return false;
+}
 
 /* PCI error reporting and recovery */
 pci_ers_result_t pcie_do_recovery(struct pci_dev *dev,
Index: linux-macro/drivers/pci/probe.c
===================================================================
--- linux-macro.orig/drivers/pci/probe.c
+++ linux-macro/drivers/pci/probe.c
@@ -2549,6 +2549,8 @@ void pci_device_add(struct pci_dev *dev,
 	dma_set_max_seg_size(&dev->dev, 65536);
 	dma_set_seg_boundary(&dev->dev, 0xffffffff);
 
+	pcie_failed_link_retrain(dev);
+
 	/* Fix up broken headers */
 	pci_fixup_device(pci_fixup_header, dev);
 

