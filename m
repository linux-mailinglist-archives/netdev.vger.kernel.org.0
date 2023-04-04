Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8BD66D6F63
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 23:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236563AbjDDV40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 17:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236600AbjDDV4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 17:56:18 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A67195256;
        Tue,  4 Apr 2023 14:56:10 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id EC2989200BC; Tue,  4 Apr 2023 23:56:09 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id E422492009D;
        Tue,  4 Apr 2023 22:56:09 +0100 (BST)
Date:   Tue, 4 Apr 2023 22:56:09 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Mahesh J Salgaonkar <mahesh@linux.ibm.com>,
        Oliver O'Halloran <oohall@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lukas Wunner <lukas@wunner.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Stefan Roese <sr@denx.de>, Jim Wilson <wilson@tuliptree.org>,
        David Abdurachmanov <david.abdurachmanov@gmail.com>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        linux-pci@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 3/7] PCI: Initialize `link_active_reporting' earlier
In-Reply-To: <alpine.DEB.2.21.2304042200040.37565@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2304042236170.37565@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2304042200040.37565@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Determine whether Data Link Layer Link Active Reporting is available 
ahead of calling any fixups so that the cached value can be used there 
and later on.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
---
Changes from v6:

- Regenerate against 6.3-rc5.

New change in v6.
---
 drivers/pci/probe.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

linux-pcie-link-active-reporting-early.diff
Index: linux-macro/drivers/pci/probe.c
===================================================================
--- linux-macro.orig/drivers/pci/probe.c
+++ linux-macro/drivers/pci/probe.c
@@ -820,7 +820,6 @@ static void pci_set_bus_speed(struct pci
 
 		pcie_capability_read_dword(bridge, PCI_EXP_LNKCAP, &linkcap);
 		bus->max_bus_speed = pcie_link_speed[linkcap & PCI_EXP_LNKCAP_SLS];
-		bridge->link_active_reporting = !!(linkcap & PCI_EXP_LNKCAP_DLLLARC);
 
 		pcie_capability_read_word(bridge, PCI_EXP_LNKSTA, &linksta);
 		pcie_update_link_speed(bus, linksta);
@@ -1829,6 +1828,7 @@ int pci_setup_device(struct pci_dev *dev
 	int pos = 0;
 	struct pci_bus_region region;
 	struct resource *res;
+	u32 linkcap;
 
 	hdr_type = pci_hdr_type(dev);
 
@@ -1876,6 +1876,10 @@ int pci_setup_device(struct pci_dev *dev
 	/* "Unknown power state" */
 	dev->current_state = PCI_UNKNOWN;
 
+	/* Set it early to make it available to fixups, etc.  */
+	pcie_capability_read_dword(dev, PCI_EXP_LNKCAP, &linkcap);
+	dev->link_active_reporting = !!(linkcap & PCI_EXP_LNKCAP_DLLLARC);
+
 	/* Early fixups, before probing the BARs */
 	pci_fixup_device(pci_fixup_early, dev);
 
