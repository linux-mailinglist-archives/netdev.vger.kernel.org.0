Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3836A161DF0
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 00:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgBQXfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 18:35:54 -0500
Received: from mout-p-101.mailbox.org ([80.241.56.151]:10152 "EHLO
        mout-p-101.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgBQXfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 18:35:53 -0500
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 48M0jM1wXBzKmbD;
        Tue, 18 Feb 2020 00:35:51 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id q6VG5-iJ1cyA; Tue, 18 Feb 2020 00:35:48 +0100 (CET)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     davem@davemloft.net, linux@rempel-privat.de
Cc:     netdev@vger.kernel.org, jcliburn@gmail.com, chris.snook@gmail.com,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] ag71xx: Call ag71xx_hw_disable() in case phy_conenct fails
Date:   Tue, 18 Feb 2020 00:35:17 +0100
Message-Id: <20200217233518.3159-2-hauke@hauke-m.de>
In-Reply-To: <20200217233518.3159-1-hauke@hauke-m.de>
References: <20200217233518.3159-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the ag71xx_phy_connect() failed only parts of the actions done
previously in this function were reverted, because only
ag71xx_rings_cleanup() was called. My system crashed the next time
open() was called because napi_disable() was not called again and this
resulted in two calls to napi_enable(), which is not allowed.

Fix this by disabling the device again.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
---
 drivers/net/ethernet/atheros/ag71xx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 6f7281f38d5a..7d3fec009030 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1263,18 +1263,18 @@ static int ag71xx_open(struct net_device *ndev)
 
 	ret = ag71xx_hw_enable(ag);
 	if (ret)
-		goto err;
+		return ret;
 
 	ret = ag71xx_phy_connect(ag);
 	if (ret)
-		goto err;
+		goto err_hw_disable;
 
 	phy_start(ndev->phydev);
 
 	return 0;
 
-err:
-	ag71xx_rings_cleanup(ag);
+err_hw_disable:
+	ag71xx_hw_disable(ag);
 	return ret;
 }
 
-- 
2.20.1

