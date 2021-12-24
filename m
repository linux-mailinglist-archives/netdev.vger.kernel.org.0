Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47EA47F0B7
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 20:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353551AbhLXT04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 14:26:56 -0500
Received: from relmlor1.renesas.com ([210.160.252.171]:32129 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1353470AbhLXT0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 14:26:49 -0500
X-IronPort-AV: E=Sophos;i="5.88,233,1635174000"; 
   d="scan'208";a="104635857"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 25 Dec 2021 04:26:48 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 9B29440F520F;
        Sat, 25 Dec 2021 04:26:46 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     netdev@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH 6/8] wcn36xx: Use platform_get_irq_byname() to get the interrupt
Date:   Fri, 24 Dec 2021 19:26:24 +0000
Message-Id: <20211224192626.15843-7-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211224192626.15843-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211224192626.15843-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

platform_get_resource_byname(pdev, IORESOURCE_IRQ, ..) relies on static
allocation of IRQ resources in DT core code, this causes an issue
when using hierarchical interrupt domains using "interrupts" property
in the node as this bypasses the hierarchical setup and messes up the
irq chaining.

In preparation for removal of static setup of IRQ resource from DT core
code use platform_get_irq_byname().

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 9575d7373bf2..bd334a302057 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -1446,25 +1446,20 @@ static int wcn36xx_platform_get_resources(struct wcn36xx *wcn,
 {
 	struct device_node *mmio_node;
 	struct device_node *iris_node;
-	struct resource *res;
 	int index;
 	int ret;
 
 	/* Set TX IRQ */
-	res = platform_get_resource_byname(pdev, IORESOURCE_IRQ, "tx");
-	if (!res) {
-		wcn36xx_err("failed to get tx_irq\n");
-		return -ENOENT;
-	}
-	wcn->tx_irq = res->start;
+	ret = platform_get_irq_byname(pdev, "tx");
+	if (ret < 0)
+		return ret;
+	wcn->tx_irq = ret;
 
 	/* Set RX IRQ */
-	res = platform_get_resource_byname(pdev, IORESOURCE_IRQ, "rx");
-	if (!res) {
-		wcn36xx_err("failed to get rx_irq\n");
-		return -ENOENT;
-	}
-	wcn->rx_irq = res->start;
+	ret = platform_get_irq_byname(pdev, "rx");
+	if (ret < 0)
+		return ret;
+	wcn->rx_irq = ret;
 
 	/* Acquire SMSM tx enable handle */
 	wcn->tx_enable_state = qcom_smem_state_get(&pdev->dev,
-- 
2.17.1

