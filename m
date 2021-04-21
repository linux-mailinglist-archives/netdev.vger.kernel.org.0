Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E5336742F
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 22:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245647AbhDUUfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 16:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244991AbhDUUfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 16:35:01 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3792C06174A
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 13:34:25 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 60F351F4268B
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     netdev@vger.kernel.org, linux-rockchip@lists.infradead.org
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        David Wu <david.wu@rock-chips.com>,
        Ezequiel Garcia <ezequiel@collabora.com>, kernel@collabora.com
Subject: [PATCH v2 1/3] net: stmmac: Don't set has_gmac if has_gmac4 is set
Date:   Wed, 21 Apr 2021 17:34:07 -0300
Message-Id: <20210421203409.40717-2-ezequiel@collabora.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210421203409.40717-1-ezequiel@collabora.com>
References: <20210421203409.40717-1-ezequiel@collabora.com>
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

