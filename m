Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6975462496
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 23:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbhK2WWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 17:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbhK2WUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 17:20:32 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B298C08EA7F
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 11:58:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 96C50CE13C4
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 19:58:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D999C53FAD;
        Mon, 29 Nov 2021 19:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638215911;
        bh=XbH9m+q7F0+Av6Yj+qhCxdjZmtMFeO/dybQQf3u18/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NrLcMlZNftnxDVS7o5LdOp5HF9ScliA7nN9w1Kxqlls125zf0LUvnnMvD+LkgYu28
         mIKz5sqmCJccEDnHu9en27bsjx3VkbLPuFcrQc6xjxDbN/kpD0+voq1JNFbVxXxXkJ
         /tLWGOOMH46EnYX/KGGVShGWCH0RaVyhiRrevKgneiogHCBVcAmeL67trbC9jzOtQB
         85W8vqmOPBvRqHTHKM8OHZpxD1bTy7V4u0+Znf8a1Gco3q5h+GVjUpV9KYCKUZRG8R
         wwxhvIEoslVPQo1vWlILuvkD3Bva8uZnHKq/qUkQC8Iak/bTtSN/XJUUf7o/qWIB8b
         sW5H+/DYt8HLQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net 2/6] net: dsa: mv88e6xxx: Drop unnecessary check in mv88e6393x_serdes_erratum_4_6()
Date:   Mon, 29 Nov 2021 20:58:19 +0100
Message-Id: <20211129195823.11766-3-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211129195823.11766-1-kabel@kernel.org>
References: <20211129195823.11766-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The check for lane is unnecessary, since the function is called only
with allowed lane argument.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 0658ee3b014c..3a6244596a67 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -1284,26 +1284,20 @@ static int mv88e6393x_serdes_erratum_4_6(struct mv88e6xxx_chip *chip, int lane)
 	 * It seems that after this workaround the SERDES is automatically
 	 * powered up (the bit is cleared), so power it down.
 	 */
-	if (lane == MV88E6393X_PORT0_LANE || lane == MV88E6393X_PORT9_LANE ||
-	    lane == MV88E6393X_PORT10_LANE) {
-		err = mv88e6390_serdes_read(chip, lane,
-					    MDIO_MMD_PHYXS,
-					    MV88E6393X_SERDES_POC, &reg);
-		if (err)
-			return err;
+	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6393X_SERDES_POC, &reg);
+	if (err)
+		return err;
 
-		reg &= ~MV88E6393X_SERDES_POC_PDOWN;
-		reg |= MV88E6393X_SERDES_POC_RESET;
+	reg &= ~MV88E6393X_SERDES_POC_PDOWN;
+	reg |= MV88E6393X_SERDES_POC_RESET;
 
-		err = mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
-					     MV88E6393X_SERDES_POC, reg);
-		if (err)
-			return err;
-
-		return mv88e6390_serdes_power_sgmii(chip, lane, false);
-	}
+	err = mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
+				     MV88E6393X_SERDES_POC, reg);
+	if (err)
+		return err;
 
-	return 0;
+	return mv88e6390_serdes_power_sgmii(chip, lane, false);
 }
 
 int mv88e6393x_serdes_setup_errata(struct mv88e6xxx_chip *chip)
-- 
2.32.0

