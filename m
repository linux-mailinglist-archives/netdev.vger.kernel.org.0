Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A663AA36A
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 20:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbhFPSpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 14:45:49 -0400
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:32572 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbhFPSps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 14:45:48 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d88 with ME
        id Huje2500H21Fzsu03ujeaS; Wed, 16 Jun 2021 20:43:40 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 16 Jun 2021 20:43:40 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com, davem@davemloft.net, kuba@kernel.org,
        sathya.perla@emulex.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] be2net: Fix an error handling path in 'be_probe()'
Date:   Wed, 16 Jun 2021 20:43:37 +0200
Message-Id: <971dd676b5f6a9986c5b4b0c85cf14fa667d53a2.1623868840.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
call, as already done in the remove function.

Fixes: d6b6d9877878 ("be2net: use PCIe AER capability")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/emulex/benet/be_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index b6eba29d8e99..7968568bbe21 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -5897,6 +5897,7 @@ static int be_probe(struct pci_dev *pdev, const struct pci_device_id *pdev_id)
 unmap_bars:
 	be_unmap_pci_bars(adapter);
 free_netdev:
+	pci_disable_pcie_error_reporting(pdev);
 	free_netdev(netdev);
 rel_reg:
 	pci_release_regions(pdev);
-- 
2.30.2

