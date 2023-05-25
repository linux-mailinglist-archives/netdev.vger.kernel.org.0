Return-Path: <netdev+bounces-5460-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8717371150C
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:44:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3744728166B
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 711CD24122;
	Thu, 25 May 2023 18:43:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E7223D7B
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11F2C4339C;
	Thu, 25 May 2023 18:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685040232;
	bh=XfcKkZtxKstYYKPK9PwLNRnvqhJBvVMhgNGhqJjmmCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o6p3dJ7YLnk337oIEBkfBYFuqHYQmFPiK+9/K23ywRlh7DJWp/LFNZRN3EDDdf90W
	 FEz/5Tlux6ptv+ZrUZPzBri4uT4jOKF6/cMo3Dao+rCVrZqnKa/nXhmpX4l0y1RVZC
	 1FCLHHtunEpRayAw/9DIkmctZ46+4xU0UCpYp5STDKga7U8JD1f7TeD+CAiOW5QT7Y
	 BtHc3No3FOGcfKLedGPC/IN7g/WX8CVexmPUzRHnASdwubhQjUKJJZUERaRsP54+i1
	 ezqwHtVD6+sWIFlXgJsB9Y2WA8vnmaK4H3s/QkcIySmM0rurAPD5w6SnzXipWXAHrR
	 KXJsPMR2F8Vkg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 27/27] mdio_bus: unhide mdio_bus_init prototype
Date: Thu, 25 May 2023 14:42:36 -0400
Message-Id: <20230525184238.1943072-27-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230525184238.1943072-1-sashal@kernel.org>
References: <20230525184238.1943072-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 2e9f8ab68f42b059e80db71266c1675c07c664bd ]

mdio_bus_init() is either used as a local module_init() entry,
or it gets called in phy_device.c. In the former case, there
is no declaration, which causes a warning:

drivers/net/phy/mdio_bus.c:1371:12: error: no previous prototype for 'mdio_bus_init' [-Werror=missing-prototypes]

Remove the #ifdef around the declaration to avoid the warning..

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20230516194625.549249-4-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/phy.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 80750783b5b0a..f0b4197cfe39c 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1192,10 +1192,8 @@ int phy_ethtool_set_link_ksettings(struct net_device *ndev,
 				   const struct ethtool_link_ksettings *cmd);
 int phy_ethtool_nway_reset(struct net_device *ndev);
 
-#if IS_ENABLED(CONFIG_PHYLIB)
 int __init mdio_bus_init(void);
 void mdio_bus_exit(void);
-#endif
 
 /* Inline function for use within net/core/ethtool.c (built-in) */
 static inline int phy_ethtool_get_strings(struct phy_device *phydev, u8 *data)
-- 
2.39.2


