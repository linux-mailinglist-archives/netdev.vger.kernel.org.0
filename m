Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C60F18AA4F
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 02:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgCSB3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 21:29:43 -0400
Received: from mail.nic.cz ([217.31.204.67]:39740 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbgCSB3n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 21:29:43 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id E23D1141B54;
        Thu, 19 Mar 2020 02:29:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1584581382; bh=smPg6bUN9iYsjOGsgMn5scMwqFNNXz6iBZhhcj1gDdE=;
        h=From:To:Date;
        b=JE4H85XMcYVZ1IdcD+NCNJHg8Do5/EwI4had+P/22q7end3aHKjpJhwfz3mgC7qCU
         6nwPG0Q8czxgZQl3X1MnT5H5zP3voaCl0x9LNmo5O9ZqeHJDaRp41/lsscxL64rXqJ
         0hhLZGvoAQglzfQwsbMHZ+pyNhOmfk2PsSntPPxI=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: mvmdio: fix driver probe on missing irq
Date:   Thu, 19 Mar 2020 02:29:40 +0100
Message-Id: <20200319012940.14490-1-marek.behun@nic.cz>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Spam-Status: No, score=0.00
X-Spamd-Bar: /
X-Virus-Scanned: clamav-milter 0.101.4 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit e1f550dc44a4 made the use of platform_get_irq_optional, which can
return -ENXIO when interrupt is missing. Handle this as non-error,
otherwise the driver won't probe.

Fixes: e1f550dc44a4 ("net: mvmdio: avoid error message for optional...")
Signed-off-by: Marek Behún <marek.behun@nic.cz>
Cc: Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/marvell/mvmdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet/marvell/mvmdio.c
index d2e2dc538428..f9f09da57031 100644
--- a/drivers/net/ethernet/marvell/mvmdio.c
+++ b/drivers/net/ethernet/marvell/mvmdio.c
@@ -364,7 +364,7 @@ static int orion_mdio_probe(struct platform_device *pdev)
 		writel(MVMDIO_ERR_INT_SMI_DONE,
 			dev->regs + MVMDIO_ERR_INT_MASK);
 
-	} else if (dev->err_interrupt < 0) {
+	} else if (dev->err_interrupt < 0 && dev->err_interrupt != -ENXIO) {
 		ret = dev->err_interrupt;
 		goto out_mdio;
 	}
-- 
2.24.1

