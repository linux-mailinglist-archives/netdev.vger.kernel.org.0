Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10DA16D8BBB
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 02:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbjDFAWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 20:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234614AbjDFAVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 20:21:51 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E5227D85;
        Wed,  5 Apr 2023 17:21:28 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 7BD5792009C; Thu,  6 Apr 2023 02:21:27 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 74D9492009B;
        Thu,  6 Apr 2023 01:21:27 +0100 (BST)
Date:   Thu, 6 Apr 2023 01:21:27 +0100 (BST)
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
Subject: [PATCH v8 6/7] net/mlx5: Rely on `link_active_reporting'
In-Reply-To: <alpine.DEB.2.21.2304060100160.13659@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2304060115270.13659@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2304060100160.13659@angie.orcam.me.uk>
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

Use `link_active_reporting' to determine whether Data Link Layer Link 
Active Reporting is available rather than re-retrieving the capability.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
---
NB this has been compile-tested only with PPC64LE and x86-64 
configurations.

Changes from v7:

- Reorder from 5/7.

Changes from v6:

- Regenerate against 6.3-rc5.

New change in v6.
---
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

linux-pcie-link-active-reporting-mlx5.diff
Index: linux-macro/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
===================================================================
--- linux-macro.orig/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ linux-macro/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -307,7 +307,6 @@ static int mlx5_pci_link_toggle(struct m
 	unsigned long timeout;
 	struct pci_dev *sdev;
 	int cap, err;
-	u32 reg32;
 
 	/* Check that all functions under the pci bridge are PFs of
 	 * this device otherwise fail this function.
@@ -346,11 +345,8 @@ static int mlx5_pci_link_toggle(struct m
 		return err;
 
 	/* Check link */
-	err = pci_read_config_dword(bridge, cap + PCI_EXP_LNKCAP, &reg32);
-	if (err)
-		return err;
-	if (!(reg32 & PCI_EXP_LNKCAP_DLLLARC)) {
-		mlx5_core_warn(dev, "No PCI link reporting capability (0x%08x)\n", reg32);
+	if (!bridge->link_active_reporting) {
+		mlx5_core_warn(dev, "No PCI link reporting capability\n");
 		msleep(1000);
 		goto restore;
 	}
