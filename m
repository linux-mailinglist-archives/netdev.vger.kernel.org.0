Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360BC50D984
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 08:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241409AbiDYGft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 02:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241401AbiDYGf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 02:35:26 -0400
Received: from mail.tkos.co.il (mail.tkos.co.il [84.110.109.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D8D286C1
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 23:32:08 -0700 (PDT)
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.tkos.co.il (Postfix) with ESMTPS id 5FA59440862;
        Mon, 25 Apr 2022 09:31:20 +0300 (IDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tkos.co.il;
        s=default; t=1650868280;
        bh=QkhIlW9lc4bDRCYhVb37/JFwTDyJBflaRPQ0q1CoRDk=;
        h=From:To:Cc:Subject:Date:From;
        b=t6815p+mVWYhsqyhyWfGd0laiGTI4ihHSFY0qstGvjE5MMuOFVwYvipLn1+X+u28Y
         Xk0WNzkkoWekg6aT5LkZx31FXNqU6HOmAEuhUf9NpXEusHnOSjX6Fy6XwfXqz9x/bF
         KNtPYAZUC7pnjCQdmkWyZl/zxiQu3GeLFnnGQJHm+u2a7ZGNehXdh+fn871/qpkCby
         Pp8qlbw3uBCb/iQkSRVNPnuLpN5YD6/V1teAaISQktuDkCSvxPjApZHgT3D0nQVXV8
         1qeK3XNDpN7nL/a1mQDbpNgm4H+ZaJtFtOmZ6/pF1Li3mgfSwH7XDjUfzZom0BFRS2
         1JHtlEAw1vSjA==
From:   Baruch Siach <baruch@tkos.co.il>
To:     Russell King <linux@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Baruch Siach <baruch.siach@siklu.com>
Subject: [PATCH] net: phy: marvell10g: fix return value on error
Date:   Mon, 25 Apr 2022 09:27:38 +0300
Message-Id: <f47cb031aeae873bb008ba35001607304a171a20.1650868058.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baruch Siach <baruch.siach@siklu.com>

Return back the error value that we get from phy_read_mmd().

Fixes: c84786fa8f91 ("net: phy: marvell10g: read copper results from CSSR1")
Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
---
 drivers/net/phy/marvell10g.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index b6fea119fe13..2b7d0720720b 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -880,7 +880,7 @@ static int mv3310_read_status_copper(struct phy_device *phydev)
 
 	cssr1 = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_CSSR1);
 	if (cssr1 < 0)
-		return val;
+		return cssr1;
 
 	/* If the link settings are not resolved, mark the link down */
 	if (!(cssr1 & MV_PCS_CSSR1_RESOLVED)) {
-- 
2.35.1

