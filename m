Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5012318A498
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 21:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgCRUy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:54:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728113AbgCRUy5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:54:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E949F2173E;
        Wed, 18 Mar 2020 20:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564896;
        bh=isr2P6CX3Md6hzFCH0L0ehoLWHoCKsFwpn3jWPKTniQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m+06ZxKOFbgXIy+dhjdfpMmBJjq/JvLm5KrazvC6I+zuJAs5N6FW5QK1oZVuEShAa
         5rjSAJCh8miLhM7Ob3SCJHvvR4IUUlYZMinjC5Mu8LWLLYJuP4n9eQICZ+9bvYeqrm
         nOrLDpHp/jwFdUR8/rbbHFbf/MiN7/qJp1m/Gh+g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 64/73] net: mvmdio: avoid error message for optional IRQ
Date:   Wed, 18 Mar 2020 16:53:28 -0400
Message-Id: <20200318205337.16279-64-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit e1f550dc44a4d535da4e25ada1b0eaf8f3417929 ]

Per the dt-binding the interrupt is optional so use
platform_get_irq_optional() instead of platform_get_irq(). Since
commit 7723f4c5ecdb ("driver core: platform: Add an error message to
platform_get_irq*()") platform_get_irq() produces an error message

  orion-mdio f1072004.mdio: IRQ index 0 not found

which is perfectly normal if one hasn't specified the optional property
in the device tree.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvmdio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet/marvell/mvmdio.c
index 0b9e851f3da4f..d2e2dc5384287 100644
--- a/drivers/net/ethernet/marvell/mvmdio.c
+++ b/drivers/net/ethernet/marvell/mvmdio.c
@@ -347,7 +347,7 @@ static int orion_mdio_probe(struct platform_device *pdev)
 	}
 
 
-	dev->err_interrupt = platform_get_irq(pdev, 0);
+	dev->err_interrupt = platform_get_irq_optional(pdev, 0);
 	if (dev->err_interrupt > 0 &&
 	    resource_size(r) < MVMDIO_ERR_INT_MASK + 4) {
 		dev_err(&pdev->dev,
@@ -364,8 +364,8 @@ static int orion_mdio_probe(struct platform_device *pdev)
 		writel(MVMDIO_ERR_INT_SMI_DONE,
 			dev->regs + MVMDIO_ERR_INT_MASK);
 
-	} else if (dev->err_interrupt == -EPROBE_DEFER) {
-		ret = -EPROBE_DEFER;
+	} else if (dev->err_interrupt < 0) {
+		ret = dev->err_interrupt;
 		goto out_mdio;
 	}
 
-- 
2.20.1

