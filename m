Return-Path: <netdev+bounces-9932-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EFBE372B336
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 19:22:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9EB75280F7E
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 17:22:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 519DEDDB0;
	Sun, 11 Jun 2023 17:20:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47264C2E4
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 17:20:49 +0000 (UTC)
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B5ED199E;
	Sun, 11 Jun 2023 10:20:21 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id E73559200C7; Sun, 11 Jun 2023 19:19:57 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id E0F309200C0;
	Sun, 11 Jun 2023 18:19:57 +0100 (BST)
Date: Sun, 11 Jun 2023 18:19:57 +0100 (BST)
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
Subject: [PATCH v9 11/14] PCI: Use `pcie_wait_for_link_status' in
 `pcie_wait_for_link_delay'
In-Reply-To: <alpine.DEB.2.21.2305310024400.59226@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2306111611170.64925@angie.orcam.me.uk>
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

Remove a DLLLA status bit polling loop from `pcie_wait_for_link_delay' 
and call almost identical code in `pcie_wait_for_link_status' instead.  
This reduces the lower bound on the polling interval from 10ms to 1ms, 
possibly increasing the CPU load on the system in favour to reducing 
the wait time.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
---
New change in v9.
---
 drivers/pci/pci.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

linux-pcie-wait-for-link-delay-status.diff
Index: linux-macro/drivers/pci/pci.c
===================================================================
--- linux-macro.orig/drivers/pci/pci.c
+++ linux-macro/drivers/pci/pci.c
@@ -4889,16 +4889,14 @@ static bool pcie_wait_for_link_status(st
 static bool pcie_wait_for_link_delay(struct pci_dev *pdev, bool active,
 				     int delay)
 {
-	int timeout = PCIE_LINK_RETRAIN_TIMEOUT_MS;
 	bool ret;
-	u16 lnk_status;
 
 	/*
 	 * Some controllers might not implement link active reporting. In this
 	 * case, we wait for 1000 ms + any delay requested by the caller.
 	 */
 	if (!pdev->link_active_reporting) {
-		msleep(timeout + delay);
+		msleep(PCIE_LINK_RETRAIN_TIMEOUT_MS + delay);
 		return true;
 	}
 
@@ -4913,20 +4911,11 @@ static bool pcie_wait_for_link_delay(str
 	 */
 	if (active)
 		msleep(20);
-	for (;;) {
-		pcie_capability_read_word(pdev, PCI_EXP_LNKSTA, &lnk_status);
-		ret = !!(lnk_status & PCI_EXP_LNKSTA_DLLLA);
-		if (ret == active)
-			break;
-		if (timeout <= 0)
-			break;
-		msleep(10);
-		timeout -= 10;
-	}
+	ret = pcie_wait_for_link_status(pdev, false, active);
 	if (active && ret)
 		msleep(delay);
 
-	return ret == active;
+	return ret;
 }
 
 /**

