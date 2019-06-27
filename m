Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45974589B7
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 20:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfF0SSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 14:18:09 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:34156 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbfF0SSJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 14:18:09 -0400
Received: from tarshish.tkos.co.il (unknown [10.0.8.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id A50E2440271;
        Thu, 27 Jun 2019 21:17:49 +0300 (IDT)
From:   Baruch Siach <baruch@tkos.co.il>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH v2] net: dsa: mv88e6xxx: wait after reset deactivation
Date:   Thu, 27 Jun 2019 21:17:39 +0300
Message-Id: <2e272a4e588ae44137864237d0cd73e2208f2c60.1561659459.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a 1ms delay after reset deactivation. Otherwise the chip returns
bogus ID value. This is observed with 88E6390 (Peridot) chip.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
v2: Address Andrew Lunn's comments:
  Use usleep_range.
  Delay only when reset line is valid.
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index ae750ab9a4d7..5f81d9a3a2a6 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4910,6 +4910,8 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 		err = PTR_ERR(chip->reset);
 		goto out;
 	}
+	if (chip->reset)
+		usleep_range(1000, 2000);
 
 	err = mv88e6xxx_detect(chip);
 	if (err)
-- 
2.20.1

