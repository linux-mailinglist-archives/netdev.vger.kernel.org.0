Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E423837C1
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 17:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244615AbhEQPqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 11:46:49 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:52982 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245274AbhEQPmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 11:42:13 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id DCA571F423BC
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     netdev@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        David Wu <david.wu@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>,
        Johan Jonker <jbx6244@gmail.com>,
        Chen-Yu Tsai <wens213@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v3 net-next 1/4] net: stmmac: Don't set has_gmac if has_gmac4 is set
Date:   Mon, 17 May 2021 12:40:34 -0300
Message-Id: <20210517154037.37946-2-ezequiel@collabora.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210517154037.37946-1-ezequiel@collabora.com>
References: <20210517154037.37946-1-ezequiel@collabora.com>
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
index 584db4ce6e39..56034f21fcef 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -1448,7 +1448,11 @@ static int rk_gmac_probe(struct platform_device *pdev)
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

