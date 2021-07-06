Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD4C3BD5AC
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236514AbhGFMYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:24:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235997AbhGFLbq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:31:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 531BE61CFB;
        Tue,  6 Jul 2021 11:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570556;
        bh=pCcN7BDwCybXFoZyfxMlftp9PONrIJ9xYGZ2x7wtsgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gYJ4sawt6C/t7URWIyJl2mmW3KWz+HvuDKxv3WVG25pqCdboKAFrMqXqNfBdR9wkf
         Ssmdb+GRm9tdg+BbASQEemQEMpdnD/yVyv2FS3VSwgn9wWGKYtlSj1hAjdjkQiW0UZ
         l97SSiszj9m8toiqf5MIgOPpv0fsqEA5NQXcc/5pTxPZVQShv0y+MwiLNfSLiBp8Z3
         V/FZgb6ZHJ3S0WiMQ39CILgKWPcMZ/6a1Kk8AIDa+67/sF0dJc9EjeLRJ8aSOG4Mi9
         qU1EU2UzxKSrR7V1YejwskmxSkYzKlxo6693etFBDTv8Hc70nd70/xNPiWgohTABDf
         U4Q1wqDBTxqNQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 024/137] net: mdio: provide shim implementation of devm_of_mdiobus_register
Date:   Tue,  6 Jul 2021 07:20:10 -0400
Message-Id: <20210706112203.2062605-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
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
index cfe8c607a628..f56c6a9230ac 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -75,6 +75,13 @@ static inline int of_mdiobus_register(struct mii_bus *mdio, struct device_node *
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

