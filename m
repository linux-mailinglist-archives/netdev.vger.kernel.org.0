Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8333BCBF5
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbhGFLSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:18:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232071AbhGFLRg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:17:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75EA0610F7;
        Tue,  6 Jul 2021 11:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570097;
        bh=d09ir3kgb9xtU564t4rO0NluCjTTcHfF8TAcNZAL3Ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A2OQ7cPg9reqNbspL/043nc17LiKrXW1y40FmfIPQGHtblahSvRsjI3rB6r871KBX
         rKN1US+EUqzh7uDLWUFN05ZDi+WtrZdrrrzITKGyNb/Ih5OpOgkpHBwQKkK320r7fh
         H00AzVSuH/IcvOO6SJHuLp0ID9FttJytZEhFVQjCZ/Y/X32jbx3WwurELiHlu0qe4e
         50uD37z08vY5QAtSFTWoyBbrcEokBUD1lKt41CoJilHUw29/KHaKRbTo6sC1mTrdKK
         zqkKiG7fTJAAH0HZO0d056vd8ZeXSuY+FncfdKhMDbVM3gsO2FW/i9/SWhXVtxQRVK
         iFObD2VPAE5YA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 033/189] net: mdio: provide shim implementation of devm_of_mdiobus_register
Date:   Tue,  6 Jul 2021 07:11:33 -0400
Message-Id: <20210706111409.2058071-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

[ Upstream commit 86544c3de6a2185409c5a3d02f674ea223a14217 ]

Similar to the way in which of_mdiobus_register() has a fallback to the
non-DT based mdiobus_register() when CONFIG_OF is not set, we can create
a shim for the device-managed devm_of_mdiobus_register() which calls
devm_mdiobus_register() and discards the struct device_node *.

In particular, this solves a build issue with the qca8k DSA driver which
uses devm_of_mdiobus_register and can be compiled without CONFIG_OF.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/of_mdio.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index 2b05e7f7c238..da633d34ab86 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -72,6 +72,13 @@ static inline int of_mdiobus_register(struct mii_bus *mdio, struct device_node *
 	return mdiobus_register(mdio);
 }
 
+static inline int devm_of_mdiobus_register(struct device *dev,
+					   struct mii_bus *mdio,
+					   struct device_node *np)
+{
+	return devm_mdiobus_register(dev, mdio);
+}
+
 static inline struct mdio_device *of_mdio_find_device(struct device_node *np)
 {
 	return NULL;
-- 
2.30.2

