Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6380D6958A
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389800AbfGOOUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:20:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390169AbfGOOTo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:19:44 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBB5D206B8;
        Mon, 15 Jul 2019 14:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200383;
        bh=RYrGBCO24OZWvrQxwop4I/ta7IVGY9R0HWwt9l2BfBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=le5b0LKqVK/7WMaFvpZh2oCD9EPBRCWN/WIiOj/xCXcaresfMPy/6qKMZWxX6Gm3f
         Mux5pZRVNbPjtA7Ut6LYquB/np5Kzu7DDTfD4i8/cPmPyM4XTZMHAV+GQSqWep/82a
         /cHagP8jMK+aj/gLtoNzqSIGpObitzrPHygfkRs0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 032/158] net: phy: Check against net_device being NULL
Date:   Mon, 15 Jul 2019 10:16:03 -0400
Message-Id: <20190715141809.8445-32-sashal@kernel.org>
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

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 82c76aca81187b3d28a6fb3062f6916450ce955e ]

In general, we don't want MAC drivers calling phy_attach_direct with the
net_device being NULL. Add checks against this in all the functions
calling it: phy_attach() and phy_connect_direct().

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8a96d985a52f..6144146aec29 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -757,6 +757,9 @@ int phy_connect_direct(struct net_device *dev, struct phy_device *phydev,
 {
 	int rc;
 
+	if (!dev)
+		return -EINVAL;
+
 	rc = phy_attach_direct(dev, phydev, phydev->dev_flags, interface);
 	if (rc)
 		return rc;
@@ -1098,6 +1101,9 @@ struct phy_device *phy_attach(struct net_device *dev, const char *bus_id,
 	struct device *d;
 	int rc;
 
+	if (!dev)
+		return ERR_PTR(-EINVAL);
+
 	/* Search the list of PHY devices on the mdio bus for the
 	 * PHY with the requested name
 	 */
-- 
2.20.1

