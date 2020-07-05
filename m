Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A33214EEA
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 21:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgGETiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 15:38:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47652 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727842AbgGETiW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 15:38:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsASw-003jXx-H8; Sun, 05 Jul 2020 21:38:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 1/4] net: dsa: mv88e6xxx: Fix sparse warnings from GENMASK
Date:   Sun,  5 Jul 2020 21:38:07 +0200
Message-Id: <20200705193810.890020-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200705193810.890020-1-andrew@lunn.ch>
References: <20200705193810.890020-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oddly, GENMASK() requires signed bit numbers, so that it can compare
them for < 0. If passed an unsigned type, we get warnings about the
test never being true.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index e5430cf2ad71..1c541b074256 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -167,7 +167,7 @@ struct mv88e6xxx_irq {
 	u16 masked;
 	struct irq_chip chip;
 	struct irq_domain *domain;
-	unsigned int nirqs;
+	int nirqs;
 };
 
 /* state flags for mv88e6xxx_port_hwtstamp::state */
@@ -654,7 +654,7 @@ static inline unsigned int mv88e6xxx_num_ports(struct mv88e6xxx_chip *chip)
 
 static inline u16 mv88e6xxx_port_mask(struct mv88e6xxx_chip *chip)
 {
-	return GENMASK(mv88e6xxx_num_ports(chip) - 1, 0);
+	return GENMASK((s32)mv88e6xxx_num_ports(chip) - 1, 0);
 }
 
 static inline unsigned int mv88e6xxx_num_gpio(struct mv88e6xxx_chip *chip)
-- 
2.27.0.rc2

