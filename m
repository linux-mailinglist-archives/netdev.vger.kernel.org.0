Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A76718A698
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgCRVJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:09:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727345AbgCRUxu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:53:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E09EA2098B;
        Wed, 18 Mar 2020 20:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564829;
        bh=2RbZQy9o2JoKpR7NM7jBOBCn95Y96OZN0YzOzbE9UTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hVY1rJx3QxeFiNNYsbZZgTDpBK3kBFycySW6SKTDAEM2lK240vAW6LrB51TH3aCaG
         tC7D5YNhCLP+kopCQ2EoxVGPlJCvKTunKayn4RjcKvmzL2KPVetWlxQhjiKrJNmNfX
         95LnT73nNQ5H+AXT54s4MUu7r+dEcqYpWzbaNCIc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 10/73] net: dsa: mv88e6xxx: fix lockup on warm boot
Date:   Wed, 18 Mar 2020 16:52:34 -0400
Message-Id: <20200318205337.16279-10-sashal@kernel.org>
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

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 0395823b8d9a4d87bd1bf74359123461c2ae801b ]

If the switch is not hardware reset on a warm boot, interrupts can be
left enabled, and possibly pending. This will cause us to enter an
infinite loop trying to service an interrupt we are unable to handle,
thereby preventing the kernel from booting.

Ensure that the global 2 interrupt sources are disabled before we claim
the parent interrupt.

Observed on the ZII development revision B and C platforms with
reworked serdes support, and using reboot -f to reboot the platform.

Fixes: dc30c35be720 ("net: dsa: mv88e6xxx: Implement interrupt support.")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/global2.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
index bdbb72fc20ede..6240976679e1e 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.c
+++ b/drivers/net/dsa/mv88e6xxx/global2.c
@@ -1083,6 +1083,13 @@ int mv88e6xxx_g2_irq_setup(struct mv88e6xxx_chip *chip)
 {
 	int err, irq, virq;
 
+	chip->g2_irq.masked = ~0;
+	mv88e6xxx_reg_lock(chip);
+	err = mv88e6xxx_g2_int_mask(chip, ~chip->g2_irq.masked);
+	mv88e6xxx_reg_unlock(chip);
+	if (err)
+		return err;
+
 	chip->g2_irq.domain = irq_domain_add_simple(
 		chip->dev->of_node, 16, 0, &mv88e6xxx_g2_irq_domain_ops, chip);
 	if (!chip->g2_irq.domain)
@@ -1092,7 +1099,6 @@ int mv88e6xxx_g2_irq_setup(struct mv88e6xxx_chip *chip)
 		irq_create_mapping(chip->g2_irq.domain, irq);
 
 	chip->g2_irq.chip = mv88e6xxx_g2_irq_chip;
-	chip->g2_irq.masked = ~0;
 
 	chip->device_irq = irq_find_mapping(chip->g1_irq.domain,
 					    MV88E6XXX_G1_STS_IRQ_DEVICE);
-- 
2.20.1

