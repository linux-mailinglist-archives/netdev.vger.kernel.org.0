Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D61341F79
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 15:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhCSOcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 10:32:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230145AbhCSOcV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 10:32:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E6F864F18;
        Fri, 19 Mar 2021 14:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616164341;
        bh=zME9b7vor8T7wmc5Hzy3iV1AFZLNERar9u4bF522I40=;
        h=From:To:Cc:Subject:Date:From;
        b=CwpOFYlDMOWvwA0PqqRLa14MxC36dPIbHTfFMpq6qNYReSiwguR049y3pvQY/rtq2
         8YmnAIn8emjFxM0lkKeEsMTE/a1bvJJ/C1iqPEoyIh9Ux9t5mxnrMQ4x5tyHUBeyLc
         FL8HQu++MAipyYUmkRzC6ghNyusH8eHDU0naQ96YBFxjmt6kfGCESRgO/3Phy3vNsP
         n+PAPXdLSdCAfdDvi48Ry3PLU2zIEWxrrZEQY2/QWHY4Oq1xfY9EJ1VR57Fx3zjpU5
         zoOc1srhDA+/7mxx+i13M9kLWFTY7kXBgpZ9pyD7YqbnYunVCn9IYKGm7tjI2QBIma
         xMWWYPXV6IH/w==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next] net: dsa: mv88e6xxx: cosmetic fix
Date:   Fri, 19 Mar 2021 15:31:49 +0100
Message-Id: <20210319143149.823-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We know that the `lane == MV88E6393X_PORT0_LANE`, so we can pass `lane`
to mv88e6390_serdes_read() instead of MV88E6393X_PORT0_LANE.

All other occurances in this function are using the `lane` variable.

It seems I forgot to change it at this one place after refactoring.

Signed-off-by: Marek Behún <kabel@kernel.org>
Fixes: de776d0d316f7 ("net: dsa: mv88e6xxx: add support for ...")
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 470856bcd2f3..f96c6ece4d75 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -1285,8 +1285,7 @@ static int mv88e6393x_serdes_port_errata(struct mv88e6xxx_chip *chip, int lane)
 	 * powered up (the bit is cleared), so power it down.
 	 */
 	if (lane == MV88E6393X_PORT0_LANE) {
-		err = mv88e6390_serdes_read(chip, MV88E6393X_PORT0_LANE,
-					    MDIO_MMD_PHYXS,
+		err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
 					    MV88E6393X_SERDES_POC, &reg);
 		if (err)
 			return err;
-- 
2.26.2

