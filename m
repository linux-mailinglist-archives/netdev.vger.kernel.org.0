Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C29E512B696
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbfL0Rnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:43:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:41020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728240AbfL0Rn3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:43:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7BCB20740;
        Fri, 27 Dec 2019 17:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468608;
        bh=Y0vXUBeuKRW/UFRvZ9ySh1jlsDUIrfD/fRAxueT6KcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DOAqylamjek0dmcDIJqHPBouJHWdhW+tnXvYkKzZKrokIwDzOkhJJn2wsK0nzbiW1
         h5BwWyA4285BqoeKVTO5ouuX7Ey5qA3Zpm+uDrn0FzWs07m6VN/NU7VcVscrTSu4gO
         R7P0C4XcTp15JVCyQVRXUnJFK6zJGdx3aUYQ4hz8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 128/187] net: dsa: b53: Fix egress flooding settings
Date:   Fri, 27 Dec 2019 12:39:56 -0500
Message-Id: <20191227174055.4923-128-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 63cc54a6f0736a432b04308a74677ab0ba8a58ee ]

There were several issues with 53568438e381 ("net: dsa: b53: Add support for port_egress_floods callback") that resulted in breaking connectivity for standalone ports:

- both user and CPU ports must allow unicast and multicast forwarding by
  default otherwise this just flat out breaks connectivity for
  standalone DSA ports
- IP multicast is treated similarly as multicast, but has separate
  control registers
- the UC, MC and IPMC lookup failure register offsets were wrong, and
  instead used bit values that are meaningful for the
  B53_IP_MULTICAST_CTRL register

Fixes: 53568438e381 ("net: dsa: b53: Add support for port_egress_floods callback")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index cc3536315eff..a7132c1593c3 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -347,7 +347,7 @@ static void b53_set_forwarding(struct b53_device *dev, int enable)
 	 * frames should be flooded or not.
 	 */
 	b53_read8(dev, B53_CTRL_PAGE, B53_IP_MULTICAST_CTRL, &mgmt);
-	mgmt |= B53_UC_FWD_EN | B53_MC_FWD_EN;
+	mgmt |= B53_UC_FWD_EN | B53_MC_FWD_EN | B53_IPMC_FWD_EN;
 	b53_write8(dev, B53_CTRL_PAGE, B53_IP_MULTICAST_CTRL, mgmt);
 }
 
@@ -526,6 +526,8 @@ int b53_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy)
 
 	cpu_port = ds->ports[port].cpu_dp->index;
 
+	b53_br_egress_floods(ds, port, true, true);
+
 	if (dev->ops->irq_enable)
 		ret = dev->ops->irq_enable(dev, port);
 	if (ret)
@@ -641,6 +643,8 @@ static void b53_enable_cpu_port(struct b53_device *dev, int port)
 	b53_write8(dev, B53_CTRL_PAGE, B53_PORT_CTRL(port), port_ctrl);
 
 	b53_brcm_hdr_setup(dev->ds, port);
+
+	b53_br_egress_floods(dev->ds, port, true, true);
 }
 
 static void b53_enable_mib(struct b53_device *dev)
@@ -1766,19 +1770,26 @@ int b53_br_egress_floods(struct dsa_switch *ds, int port,
 	struct b53_device *dev = ds->priv;
 	u16 uc, mc;
 
-	b53_read16(dev, B53_CTRL_PAGE, B53_UC_FWD_EN, &uc);
+	b53_read16(dev, B53_CTRL_PAGE, B53_UC_FLOOD_MASK, &uc);
 	if (unicast)
 		uc |= BIT(port);
 	else
 		uc &= ~BIT(port);
-	b53_write16(dev, B53_CTRL_PAGE, B53_UC_FWD_EN, uc);
+	b53_write16(dev, B53_CTRL_PAGE, B53_UC_FLOOD_MASK, uc);
+
+	b53_read16(dev, B53_CTRL_PAGE, B53_MC_FLOOD_MASK, &mc);
+	if (multicast)
+		mc |= BIT(port);
+	else
+		mc &= ~BIT(port);
+	b53_write16(dev, B53_CTRL_PAGE, B53_MC_FLOOD_MASK, mc);
 
-	b53_read16(dev, B53_CTRL_PAGE, B53_MC_FWD_EN, &mc);
+	b53_read16(dev, B53_CTRL_PAGE, B53_IPMC_FLOOD_MASK, &mc);
 	if (multicast)
 		mc |= BIT(port);
 	else
 		mc &= ~BIT(port);
-	b53_write16(dev, B53_CTRL_PAGE, B53_MC_FWD_EN, mc);
+	b53_write16(dev, B53_CTRL_PAGE, B53_IPMC_FLOOD_MASK, mc);
 
 	return 0;
 
-- 
2.20.1

