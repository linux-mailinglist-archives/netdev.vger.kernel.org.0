Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89CD539E25
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 13:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbfFHLmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 07:42:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727468AbfFHLmJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 07:42:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1245214D8;
        Sat,  8 Jun 2019 11:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994128;
        bh=lGQ6TM8Ks9aZEQTjN/7Q4LvqRoYdOdivuhha7Z3PTjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tDW16SmpStS3+72FUpt5t4LmSKdVAwwzY1pmMWG7eRtQ+hYq6RqAgUgzQm9/wwtEj
         tkFFrWIJwIxGEWr/BqRko2yV1aCT4BsqzbY5FZpwlUxaR7wORylhlx1wswTUqqh4yx
         eVTv/u7ZQXYhMFknNJA3/xXAzMyy7Jy2AYlBlF7A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 59/70] net: sh_eth: fix mdio access in sh_eth_close() for R-Car Gen2 and RZ/A1 SoCs
Date:   Sat,  8 Jun 2019 07:39:38 -0400
Message-Id: <20190608113950.8033-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit 315ca92dd863fecbffc0bb52ae0ac11e0398726a ]

The sh_eth_close() resets the MAC and then calls phy_stop()
so that mdio read access result is incorrect without any error
according to kernel trace like below:

ifconfig-216   [003] .n..   109.133124: mdio_access: ee700000.ethernet-ffffffff read  phy:0x01 reg:0x00 val:0xffff

According to the hardware manual, the RMII mode should be set to 1
before operation the Ethernet MAC. However, the previous code was not
set to 1 after the driver issued the soft_reset in sh_eth_dev_exit()
so that the mdio read access result seemed incorrect. To fix the issue,
this patch adds a condition and set the RMII mode register in
sh_eth_dev_exit() for R-Car Gen2 and RZ/A1 SoCs.

Note that when I have tried to move the sh_eth_dev_exit() calling
after phy_stop() on sh_eth_close(), but it gets worse (kernel panic
happened and it seems that a register is accessed while the clock is
off).

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/sh_eth.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index e33af371b169..48967dd27bbf 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -1594,6 +1594,10 @@ static void sh_eth_dev_exit(struct net_device *ndev)
 	sh_eth_get_stats(ndev);
 	mdp->cd->soft_reset(ndev);
 
+	/* Set the RMII mode again if required */
+	if (mdp->cd->rmiimode)
+		sh_eth_write(ndev, 0x1, RMIIMODE);
+
 	/* Set MAC address again */
 	update_mac_address(ndev);
 }
-- 
2.20.1

