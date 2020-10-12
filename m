Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62FD328C0F1
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 21:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390771AbgJLTHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 15:07:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390541AbgJLTD0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 15:03:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 044A8221FF;
        Mon, 12 Oct 2020 19:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602529401;
        bh=ptha9/6vbYax2Cmn6fZT5FA9ybQKKoEsnoXVXkEp964=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B/xkgECQtnq/OvhnqjccSuvRNIeHLVfvTr5IjS4f9MwnVBZ0H9fHb2chNNnCzo+es
         67mzUzAYhbPAIIsXxhTtERVIIWnMpoYK5IGe9lxfQtMV47lh2rs2IagKhSqfUsgXq4
         GxKvDwQVHRVhprwcOnqGfKEfxjUntx3a0PNNtl/k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jamie Iles <jamie@nuviainc.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/15] net/fsl: quieten expected MDIO access failures
Date:   Mon, 12 Oct 2020 15:03:03 -0400
Message-Id: <20201012190313.3279397-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012190313.3279397-1-sashal@kernel.org>
References: <20201012190313.3279397-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jamie Iles <jamie@nuviainc.com>

[ Upstream commit 1ec8e74855588cecb2620b28b877c08f45765374 ]

MDIO reads can happen during PHY probing, and printing an error with
dev_err can result in a large number of error messages during device
probe.  On a platform with a serial console this can result in
excessively long boot times in a way that looks like an infinite loop
when multiple busses are present.  Since 0f183fd151c (net/fsl: enable
extended scanning in xgmac_mdio) we perform more scanning so there are
potentially more failures.

Reduce the logging level to dev_dbg which is consistent with the
Freescale enetc driver.

Cc: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Jamie Iles <jamie@nuviainc.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/xgmac_mdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index c82c85ef5fb34..61cb4ba0005bd 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -229,7 +229,7 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 	/* Return all Fs if nothing was there */
 	if ((xgmac_read32(&regs->mdio_stat, endian) & MDIO_STAT_RD_ER) &&
 	    !priv->has_a011043) {
-		dev_err(&bus->dev,
+		dev_dbg(&bus->dev,
 			"Error while reading PHY%d reg at %d.%hhu\n",
 			phy_id, dev_addr, regnum);
 		return 0xffff;
-- 
2.25.1

