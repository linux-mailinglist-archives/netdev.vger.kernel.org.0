Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251B93A4EE0
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 14:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhFLMj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 08:39:57 -0400
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:60867 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbhFLMjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 08:39:52 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d43 with ME
        id GCdp2500621Fzsu03CdpjX; Sat, 12 Jun 2021 14:37:51 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 12 Jun 2021 14:37:51 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org,
        amit.salecha@qlogic.com, sucheta.chakraborty@qlogic.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] qlcnic: Fix an error handling path in 'qlcnic_probe()'
Date:   Sat, 12 Jun 2021 14:37:46 +0200
Message-Id: <2b582e7e0f777ad2a04f9d0568045bee1483a27f.1623501317.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
call, as already done in the remove function.

Fixes: 451724c821c1 ("qlcnic: aer support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 8966f1bcda77..918220ad0d53 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -2690,6 +2690,7 @@ qlcnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	kfree(ahw);
 
 err_out_free_res:
+	pci_disable_pcie_error_reporting(pdev);
 	pci_release_regions(pdev);
 
 err_out_disable_pdev:
-- 
2.30.2

