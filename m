Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2241DDD3B9
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 00:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731789AbfJRWGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 18:06:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731717AbfJRWGf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 18:06:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E07B222D1;
        Fri, 18 Oct 2019 22:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436395;
        bh=S+UP34fBgco5qEy2lVaj8NvPWE1I+JMG2cDvjgizkSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SfcqN+19ZnxdkADOKVReuvA0OvE/dqWzK9GAmJO3FycB7Qr2nqjNmFcOesM9g6cP4
         NlFk6/PqefmKHgM9Gy14sgmE1QZ4b3QO19pgbdOdNhksX4QJBGGstuAfXQNeffKZV9
         zgi8nCxCyk5gvin6rABd4GlL6kZKj1gWJHDeUp14=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 046/100] net: dsa: mv88e6xxx: Release lock while requesting IRQ
Date:   Fri, 18 Oct 2019 18:04:31 -0400
Message-Id: <20191018220525.9042-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit 342a0ee70acbee97fdeb91349420f8744eb291fb ]

There is no need to hold the register lock while requesting the GPIO
interrupt. By not holding it we can also avoid a false positive
lockdep splat.

Reported-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 703e6bdaf0e1f..d075f0f7a3de8 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -456,10 +456,12 @@ static int mv88e6xxx_g1_irq_setup(struct mv88e6xxx_chip *chip)
 	 */
 	irq_set_lockdep_class(chip->irq, &lock_key, &request_key);
 
+	mutex_unlock(&chip->reg_lock);
 	err = request_threaded_irq(chip->irq, NULL,
 				   mv88e6xxx_g1_irq_thread_fn,
 				   IRQF_ONESHOT,
 				   dev_name(chip->dev), chip);
+	mutex_lock(&chip->reg_lock);
 	if (err)
 		mv88e6xxx_g1_irq_free_common(chip);
 
-- 
2.20.1

