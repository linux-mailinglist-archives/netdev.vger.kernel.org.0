Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C213A3BED
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 08:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhFKGPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 02:15:44 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:47209 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbhFKGPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 02:15:43 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d25 with ME
        id FiDh2500N21Fzsu03iDh1Y; Fri, 11 Jun 2021 08:13:44 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 11 Jun 2021 08:13:44 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        johannes@sipsolutions.net, bruceshenzk@gmail.com,
        dan.carpenter@oracle.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] alx: Fix an error handling path in 'alx_probe()'
Date:   Fri, 11 Jun 2021 08:13:39 +0200
Message-Id: <2d0fa41ff6266f38b04b7e46651878c70d32d5ef.1623391908.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
call, as already done in the remove function.

Fixes: ab69bde6b2e9 ("alx: add a simple AR816x/AR817x device driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/atheros/alx/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 45e380f3b065..11ef1fbe7aee 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1876,6 +1876,7 @@ static int alx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	free_netdev(netdev);
 out_pci_release:
 	pci_release_mem_regions(pdev);
+	pci_disable_pcie_error_reporting(pdev);
 out_pci_disable:
 	pci_disable_device(pdev);
 	return err;
-- 
2.30.2

