Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C092E1023A
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 00:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfD3WJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 18:09:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50584 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726048AbfD3WJQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 18:09:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=e+s9QOQICa43x+MYdahIz843iibV/jU0UgKcynXx6q4=; b=r4MsbC61n0gQEj/sShLanit10/
        vHkFaktCuJot6UGr9zKBzxnMAa9pzNoSX+7e8zdlPah2yHpx9c87y53xetaxTbPyWu5mW7WwOeH0X
        RoL90e3azWU8VEaDPUYHDXsmGV/xyDi5b83bsa6D9l0l3JAdGN/YT1OHX99OkN63/Lhw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hLavX-00055L-AT; Wed, 01 May 2019 00:08:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 1/2] net: dsa: mv88e6xxx: Set STP disable state in port_disable
Date:   Wed,  1 May 2019 00:08:30 +0200
Message-Id: <20190430220831.19505-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190430220831.19505-1-andrew@lunn.ch>
References: <20190430220831.19505-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When requested to disable a port, set the port STP state to disabled.
This fully disables the port and should save some power.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 489a899c80b6..dc891d83610e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2428,6 +2428,9 @@ static void mv88e6xxx_port_disable(struct dsa_switch *ds, int port)
 
 	mutex_lock(&chip->reg_lock);
 
+	if (mv88e6xxx_port_set_state(chip, port, BR_STATE_DISABLED))
+		dev_err(chip->dev, "failed to disable port\n");
+
 	if (chip->info->ops->serdes_irq_free)
 		chip->info->ops->serdes_irq_free(chip, port);
 
-- 
2.20.1

