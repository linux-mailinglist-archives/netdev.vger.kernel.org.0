Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B867E46A964
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 22:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350448AbhLFVRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 16:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350452AbhLFVRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 16:17:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249ADC0611F7;
        Mon,  6 Dec 2021 13:13:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 32587CE17E3;
        Mon,  6 Dec 2021 21:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A94C341C6;
        Mon,  6 Dec 2021 21:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825216;
        bh=01A2+zIPO4o+Dmgp8Q9y/Jlu4dUUNtnMB0nQdN71ZZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AK6K6BZwQ8g4dLb1A94ZZzYJQVaJf/c/SqmimgAz/tdIB0kwv4pA7/db3WL1g4k1c
         M8zN+0dhOnaGckMjO0+2h6Wb5Y2gNk5z7e0WxgK4LWaf0lmh5x552pHev2ueYqN7Ud
         9T+FEGE2HmpzoQZkD8RGD2We2ogZC2bNtflwFtZURvcSQj9Wd+kTuOhaYIZ0IBv1e3
         7pnRo5wrxOOZsecncoH9iDc/u++k2jv6Gdaa/SHesvbuBoxAw5yvPImY98a1qEkh3c
         5+XGQQ7yl4hHSAXbsofiTH2asDz4+0yckRNY4oTrqe0waaGSmDsjf5PvGz/AcQRq4v
         MnFMU+d8K9W2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Erik Ekman <erik@kryo.se>,
        Michael Stapelberg <michael@stapelberg.ch>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 09/24] net/mlx4_en: Update reported link modes for 1/10G
Date:   Mon,  6 Dec 2021 16:12:14 -0500
Message-Id: <20211206211230.1660072-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211230.1660072-1-sashal@kernel.org>
References: <20211206211230.1660072-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erik Ekman <erik@kryo.se>

[ Upstream commit 2191b1dfef7d45f44b5008d2148676d9f2c82874 ]

When link modes were initially added in commit 2c762679435dc
("net/mlx4_en: Use PTYS register to query ethtool settings") and
later updated for the new ethtool API in commit 3d8f7cc78d0eb
("net: mlx4: use new ETHTOOL_G/SSETTINGS API") the only 1/10G non-baseT
link modes configured were 1000baseKX, 10000baseKX4 and 10000baseKR.
It looks like these got picked to represent other modes since nothing
better was available.

Switch to using more specific link modes added in commit 5711a98221443
("net: ethtool: add support for 1000BaseX and missing 10G link modes").

Tested with MCX311A-XCAT connected via DAC.
Before:

% sudo ethtool enp3s0
Settings for enp3s0:
	Supported ports: [ FIBRE ]
	Supported link modes:   1000baseKX/Full
	                        10000baseKR/Full
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: No
	Supported FEC modes: Not reported
	Advertised link modes:  1000baseKX/Full
	                        10000baseKR/Full
	Advertised pause frame use: Symmetric
	Advertised auto-negotiation: No
	Advertised FEC modes: Not reported
	Speed: 10000Mb/s
	Duplex: Full
	Auto-negotiation: off
	Port: Direct Attach Copper
	PHYAD: 0
	Transceiver: internal
	Supports Wake-on: d
	Wake-on: d
        Current message level: 0x00000014 (20)
                               link ifdown
	Link detected: yes

With this change:

% sudo ethtool enp3s0
	Settings for enp3s0:
	Supported ports: [ FIBRE ]
	Supported link modes:   1000baseX/Full
	                        10000baseCR/Full
 	                        10000baseSR/Full
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: No
	Supported FEC modes: Not reported
	Advertised link modes:  1000baseX/Full
 	                        10000baseCR/Full
 	                        10000baseSR/Full
	Advertised pause frame use: Symmetric
	Advertised auto-negotiation: No
	Advertised FEC modes: Not reported
	Speed: 10000Mb/s
	Duplex: Full
	Auto-negotiation: off
	Port: Direct Attach Copper
	PHYAD: 0
	Transceiver: internal
	Supports Wake-on: d
	Wake-on: d
        Current message level: 0x00000014 (20)
                               link ifdown
	Link detected: yes

Tested-by: Michael Stapelberg <michael@stapelberg.ch>
Signed-off-by: Erik Ekman <erik@kryo.se>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index ef518b1040f72..fde521b1eecad 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -663,7 +663,7 @@ void __init mlx4_en_init_ptys2ethtool_map(void)
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_1000BASE_T, SPEED_1000,
 				       ETHTOOL_LINK_MODE_1000baseT_Full_BIT);
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_1000BASE_CX_SGMII, SPEED_1000,
-				       ETHTOOL_LINK_MODE_1000baseKX_Full_BIT);
+				       ETHTOOL_LINK_MODE_1000baseX_Full_BIT);
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_1000BASE_KX, SPEED_1000,
 				       ETHTOOL_LINK_MODE_1000baseKX_Full_BIT);
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_10GBASE_T, SPEED_10000,
@@ -675,9 +675,9 @@ void __init mlx4_en_init_ptys2ethtool_map(void)
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_10GBASE_KR, SPEED_10000,
 				       ETHTOOL_LINK_MODE_10000baseKR_Full_BIT);
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_10GBASE_CR, SPEED_10000,
-				       ETHTOOL_LINK_MODE_10000baseKR_Full_BIT);
+				       ETHTOOL_LINK_MODE_10000baseCR_Full_BIT);
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_10GBASE_SR, SPEED_10000,
-				       ETHTOOL_LINK_MODE_10000baseKR_Full_BIT);
+				       ETHTOOL_LINK_MODE_10000baseSR_Full_BIT);
 	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_20GBASE_KR2, SPEED_20000,
 				       ETHTOOL_LINK_MODE_20000baseMLD2_Full_BIT,
 				       ETHTOOL_LINK_MODE_20000baseKR2_Full_BIT);
-- 
2.33.0

