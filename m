Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7C41E5F89
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389299AbgE1MC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 08:02:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389053AbgE1L5j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 07:57:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E038C2177B;
        Thu, 28 May 2020 11:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590667058;
        bh=kFj+SjSIbGOFJxaG38QX2KW45bxkUIIoObfSmZsIAV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKe537KLDvouZpjAmVCpwhqkble0fse3SX4YlOTi9pB2AJL8CPlrL5CxrgoC5H3bN
         XCthiBqRkrOmRD8+v/YougZI/S3N0TPqTBY+BwoSAqHLAZ4bnK8HPgE9lsGpuyzfWT
         fvj8XA/He+aZAf8NyN29KAAkNk1645IfUeqZWm08=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Valentin Longchamp <valentin@longchamp.me>,
        Matteo Ghidoni <matteo.ghidoni@ch.abb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 12/17] net/ethernet/freescale: rework quiesce/activate for ucc_geth
Date:   Thu, 28 May 2020 07:57:19 -0400
Message-Id: <20200528115724.1406376-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115724.1406376-1-sashal@kernel.org>
References: <20200528115724.1406376-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Valentin Longchamp <valentin@longchamp.me>

[ Upstream commit 79dde73cf9bcf1dd317a2667f78b758e9fe139ed ]

ugeth_quiesce/activate are used to halt the controller when there is a
link change that requires to reconfigure the mac.

The previous implementation called netif_device_detach(). This however
causes the initial activation of the netdevice to fail precisely because
it's detached. For details, see [1].

A possible workaround was the revert of commit
net: linkwatch: add check for netdevice being present to linkwatch_do_dev
However, the check introduced in the above commit is correct and shall be
kept.

The netif_device_detach() is thus replaced with
netif_tx_stop_all_queues() that prevents any tranmission. This allows to
perform mac config change required by the link change, without detaching
the corresponding netdevice and thus not preventing its initial
activation.

[1] https://lists.openwall.net/netdev/2020/01/08/201

Signed-off-by: Valentin Longchamp <valentin@longchamp.me>
Acked-by: Matteo Ghidoni <matteo.ghidoni@ch.abb.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index a5bf02ae4bc5..5de6f7c73c1f 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -45,6 +45,7 @@
 #include <soc/fsl/qe/ucc.h>
 #include <soc/fsl/qe/ucc_fast.h>
 #include <asm/machdep.h>
+#include <net/sch_generic.h>
 
 #include "ucc_geth.h"
 
@@ -1551,11 +1552,8 @@ static int ugeth_disable(struct ucc_geth_private *ugeth, enum comm_dir mode)
 
 static void ugeth_quiesce(struct ucc_geth_private *ugeth)
 {
-	/* Prevent any further xmits, plus detach the device. */
-	netif_device_detach(ugeth->ndev);
-
-	/* Wait for any current xmits to finish. */
-	netif_tx_disable(ugeth->ndev);
+	/* Prevent any further xmits */
+	netif_tx_stop_all_queues(ugeth->ndev);
 
 	/* Disable the interrupt to avoid NAPI rescheduling. */
 	disable_irq(ugeth->ug_info->uf_info.irq);
@@ -1568,7 +1566,10 @@ static void ugeth_activate(struct ucc_geth_private *ugeth)
 {
 	napi_enable(&ugeth->napi);
 	enable_irq(ugeth->ug_info->uf_info.irq);
-	netif_device_attach(ugeth->ndev);
+
+	/* allow to xmit again  */
+	netif_tx_wake_all_queues(ugeth->ndev);
+	__netdev_watchdog_up(ugeth->ndev);
 }
 
 /* Called every time the controller might need to be made
-- 
2.25.1

