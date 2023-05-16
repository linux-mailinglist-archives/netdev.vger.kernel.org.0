Return-Path: <netdev+bounces-3105-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D9F77057D2
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 21:47:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 126E22813C8
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:47:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81621168A2;
	Tue, 16 May 2023 19:47:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B862910E
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 19:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82409C433D2;
	Tue, 16 May 2023 19:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684266445;
	bh=WJ7zJ8wKo3Z+xOwBRYH0RqKqN+ywQ2CmZE2kNKIwXgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ScBp9XTf1mm/fEQERYAAs/zBoK/nbDJ0uqqFSmni2XihRGPIdvbwY3lfhG/YoV7Wk
	 J5ctZDxpFI4vdvE84yROlQOdZt++NmUbf0ePCEcq3gAf4W0ER+QCu1TjjKdJMg8zwy
	 XzcERynrFL0aWUV/od/4XdAGFFJAP1P/a3abFTGixVQcJ33obSRvsNIjuk5Dh9YzUq
	 XlqokYWCIuxrYW2FM0CBvyrojG4GVxKaasDcH4rVYv3DL3b4MDus35EXkiWnSsy/9o
	 GadEdoq7H/lLC2q01zg2HgZH0AXVtKEimojnWjMKwIvD36ya3ynPySjY3QcVIeXoGG
	 XJY5mD3O5V5rQ==
From: Arnd Bergmann <arnd@kernel.org>
To: netdev@vger.kernel.org,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] mdio_bus: unhide mdio_bus_init prototype
Date: Tue, 16 May 2023 21:45:36 +0200
Message-Id: <20230516194625.549249-4-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230516194625.549249-1-arnd@kernel.org>
References: <20230516194625.549249-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

mdio_bus_init() is either used as a local module_init() entry,
or it gets called in phy_device.c. In the former case, there
is no declaration, which causes a warning:

drivers/net/phy/mdio_bus.c:1371:12: error: no previous prototype for 'mdio_bus_init' [-Werror=missing-prototypes]

Remove the #ifdef around the declaration to avoid the warning..

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/phy.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index c5a0dc829714..6478838405a0 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1900,10 +1900,8 @@ void phy_package_leave(struct phy_device *phydev);
 int devm_phy_package_join(struct device *dev, struct phy_device *phydev,
 			  int addr, size_t priv_size);
 
-#if IS_ENABLED(CONFIG_PHYLIB)
 int __init mdio_bus_init(void);
 void mdio_bus_exit(void);
-#endif
 
 int phy_ethtool_get_strings(struct phy_device *phydev, u8 *data);
 int phy_ethtool_get_sset_count(struct phy_device *phydev);
-- 
2.39.2


