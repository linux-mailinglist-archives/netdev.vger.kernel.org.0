Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14196463C6A
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 18:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244529AbhK3RFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 12:05:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47996 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238207AbhK3RFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 12:05:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BEC2B81A96
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 17:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32535C53FC1;
        Tue, 30 Nov 2021 17:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638291720;
        bh=XbH9m+q7F0+Av6Yj+qhCxdjZmtMFeO/dybQQf3u18/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+GnsAvOZq9s+qnuhMPfv+2h07sQi5tzCCYTVUOxVgvBJ0oT+SrIqALP9dPYWDq/G
         Fzyu132GkbE77ckPf9AyFtSOaB81y8EmEJtBhSGzqp96z6WqxFkolCEPv2g3HhPY2y
         O19r/a4rYQ/7w3tmMn4gBbgSAu90UR17WlnCrM4SKOZlH9Zk+c2iaz5sr3yVS7xJNq
         X4LZCD7zNOX60PdJCmSfFP3j6Gb5iBjUC8AD/+uVUpYE+xthynK2RwHQttek/tYcCq
         4OyRlqZm6xS7nPW43T0kIjvzV9PASonthLEYCwPYXc0PR6Up56TsGicnvmVkXDGCkE
         kr1lskqoiSsbw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net v2 2/6] net: dsa: mv88e6xxx: Drop unnecessary check in mv88e6393x_serdes_erratum_4_6()
Date:   Tue, 30 Nov 2021 18:01:47 +0100
Message-Id: <20211130170151.7741-3-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211130170151.7741-1-kabel@kernel.org>
References: <20211130170151.7741-1-kabel@kernel.org>
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

