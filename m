Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6458E478165
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 01:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbhLQAfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 19:35:47 -0500
Received: from relmlor2.renesas.com ([210.160.252.172]:42225 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230354AbhLQAfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 19:35:47 -0500
X-IronPort-AV: E=Sophos;i="5.88,212,1635174000"; 
   d="scan'208";a="104217566"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 17 Dec 2021 09:35:45 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 011A3415CA7A;
        Fri, 17 Dec 2021 09:35:43 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH] net: mv643xx_eth: Propagate errors from of_irq_to_resource()
Date:   Fri, 17 Dec 2021 00:35:40 +0000
Message-Id: <20211217003540.21344-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver overrides the error code returned by of_irq_to_resource() to
-EINVAL. Switch to propagating the error code upstream so that errors
such as -EPROBE_DEFER are handled.

While at it drop the memset() operation as of_irq_to_resource()
does call memset() before filling in the IRQ resource.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 105247582684..7a5ff629d158 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2716,10 +2716,10 @@ static int mv643xx_eth_shared_of_add_port(struct platform_device *pdev,
 	memset(&ppd, 0, sizeof(ppd));
 	ppd.shared = pdev;
 
-	memset(&res, 0, sizeof(res));
-	if (of_irq_to_resource(pnp, 0, &res) <= 0) {
+	ret = of_irq_to_resource(pnp, 0, &res);
+	if (ret <= 0) {
 		dev_err(&pdev->dev, "missing interrupt on %pOFn\n", pnp);
-		return -EINVAL;
+		return ret ? ret : -ENXIO;
 	}
 
 	if (of_property_read_u32(pnp, "reg", &ppd.port_number)) {
-- 
2.17.1

