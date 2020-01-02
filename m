Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC2112E744
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 15:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbgABOeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 09:34:03 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45184 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728425AbgABOeC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jan 2020 09:34:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9cijHxvq6hVJXJ7FywKVqDaxPz6YWqX2rA+HUx8caeI=; b=Z3bvCIjef4y3Fzq0yrlKi+RY1r
        Wfb52zxmVIbEtn172kEAwHpJy1G3T0DcAOFAP138ehb5yyZZn/3RzF8Nq/52W9LgzM9QENcj3G2NJ
        ywLUB7n4oWv5T15yCQmhwE/jTSx9NUm1tHiGIpZOBtDJuwIMyy9PaKjbzyuPYbDq3bNQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1in1Xx-0007CT-Vi; Thu, 02 Jan 2020 15:33:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, fugang.duan@nxp.com,
        Chris Healy <Chris.Healy@zii.aero>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net] net: freescale: fec: Fix ethtool -d runtime PM
Date:   Thu,  2 Jan 2020 15:33:34 +0100
Message-Id: <20200102143334.27613-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to dump the FECs registers the clocks have to be ticking,
otherwise a data abort occurs.  Add calls to runtime PM so they are
enabled and later disabled.

Fixes: e8fcfcd5684a ("net: fec: optimize the clock management to save power")
Reported-by: Chris Healy <Chris.Healy@zii.aero>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/freescale/fec_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 05c1899f6628..9294027e9d90 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2199,8 +2199,14 @@ static void fec_enet_get_regs(struct net_device *ndev,
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	u32 __iomem *theregs = (u32 __iomem *)fep->hwp;
+	struct device *dev = &fep->pdev->dev;
 	u32 *buf = (u32 *)regbuf;
 	u32 i, off;
+	int ret;
+
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0)
+		return;
 
 	regs->version = fec_enet_register_version;
 
@@ -2216,6 +2222,9 @@ static void fec_enet_get_regs(struct net_device *ndev,
 		off >>= 2;
 		buf[off] = readl(&theregs[off]);
 	}
+
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_autosuspend(dev);
 }
 
 static int fec_enet_get_ts_info(struct net_device *ndev,
-- 
2.24.0

