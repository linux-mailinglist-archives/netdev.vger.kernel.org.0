Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715B535E7F9
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 23:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243087AbhDMVDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 17:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244938AbhDMVDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 17:03:15 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F90C061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 14:02:55 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 047271F42520
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     netdev@vger.kernel.org, linux-rockchip@lists.infradead.org
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>, kernel@collabora.com
Subject: [PATCH net-next 1/3] net: stmmac: Don't set has_gmac if has_gmac4 is set
Date:   Tue, 13 Apr 2021 18:02:33 -0300
Message-Id: <20210413210235.489467-2-ezequiel@collabora.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210413210235.489467-1-ezequiel@collabora.com>
References: <20210413210235.489467-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some Rockchip platforms have a GMAC4 core, and therefore
'plat_stmmacenet_data.has_gmac' shouldn't be set if
'plat_stmmacenet_data.has_gmac4' is set.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index 6ef30252bfe0..c432a9592489 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -1400,7 +1400,11 @@ static int rk_gmac_probe(struct platform_device *pdev)
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
-	plat_dat->has_gmac = true;
+	/* If the stmmac is not already selected as gmac4,
+	 * then make sure we fallback to gmac.
+	 */
+	if (!plat_dat->has_gmac4)
+		plat_dat->has_gmac = true;
 	plat_dat->fix_mac_speed = rk_fix_speed;
 
 	plat_dat->bsp_priv = rk_gmac_setup(pdev, plat_dat, data);
-- 
2.30.0

