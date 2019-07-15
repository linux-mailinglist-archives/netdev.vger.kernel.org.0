Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18EA2690BE
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390875AbfGOOYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:24:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390860AbfGOOYI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:24:08 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3239020896;
        Mon, 15 Jul 2019 14:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200647;
        bh=mZa0/8cys8yBuLAYb3Kj91kgEQmeH9t6J0giZzAzzO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=StmpFjNOx2f+5qctOXaxQjiXB2u23QfaAs9NJ1fsAM7mTlYKEIXE7QXtbB3KeCD92
         N/KmXkIGP5r2AJGRqV2PpN2Z3xqWwUP5FRnmTNTcmZWgNLRIMAgWJrwqvtA8tQiGMJ
         oO3lO1bdxb3rONF7a7Kp43ofZS+klbDKYg0X4wmM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Icenowy Zheng <icenowy@aosc.io>, Ondrej Jirman <megous@megous.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 102/158] net: stmmac: sun8i: force select external PHY when no internal one
Date:   Mon, 15 Jul 2019 10:17:13 -0400
Message-Id: <20190715141809.8445-102-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Icenowy Zheng <icenowy@aosc.io>

[ Upstream commit 0fec7e72ae1391bb2d7527efb54fe6ae88acabce ]

The PHY selection bit also exists on SoCs without an internal PHY; if it's
set to 1 (internal PHY, default value) then the MAC will not make use of
any PHY on such SoCs.

This problem appears when adapting for H6, which has no real internal PHY
(the "internal PHY" on H6 is not on-die, but on a co-packaged AC200 chip,
connected via RMII interface at GPIO bank A).

Force the PHY selection bit to 0 when the SOC doesn't have an internal PHY,
to address the problem of a wrong default value.

Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
Signed-off-by: Ondrej Jirman <megous@megous.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 49a896a16391..79c91526f3ec 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -893,6 +893,11 @@ static int sun8i_dwmac_set_syscon(struct stmmac_priv *priv)
 		 * address. No need to mask it again.
 		 */
 		reg |= 1 << H3_EPHY_ADDR_SHIFT;
+	} else {
+		/* For SoCs without internal PHY the PHY selection bit should be
+		 * set to 0 (external PHY).
+		 */
+		reg &= ~H3_EPHY_SELECT;
 	}
 
 	if (!of_property_read_u32(node, "allwinner,tx-delay-ps", &val)) {
-- 
2.20.1

