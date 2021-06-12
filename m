Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548943A4EF2
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 14:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbhFLMzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 08:55:15 -0400
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:43195 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhFLMzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 08:55:15 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d43 with ME
        id GCtE2500421Fzsu03CtESd; Sat, 12 Jun 2021 14:53:14 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 12 Jun 2021 14:53:14 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     manishc@marvell.com, rahulv@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org,
        amit.salecha@qlogic.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] netxen_nic: Fix an error handling path in 'netxen_nic_probe()'
Date:   Sat, 12 Jun 2021 14:53:12 +0200
Message-Id: <bb27f74af33b2b5eb238598fbd8aaafa51ccb50c.1623502316.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
call, as already done in the remove function.

Fixes: e87ad5539343 ("netxen: support pci error handlers")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 7e6bac85495d..344ea1143454 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -1602,6 +1602,8 @@ netxen_nic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	free_netdev(netdev);
 
 err_out_free_res:
+	if (NX_IS_REVISION_P3(pdev->revision))
+		pci_disable_pcie_error_reporting(pdev);
 	pci_release_regions(pdev);
 
 err_out_disable_pdev:
-- 
2.30.2

