Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC43231D0EB
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 20:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbhBPTWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 14:22:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:52052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230355AbhBPTWJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 14:22:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 862EA64E7A;
        Tue, 16 Feb 2021 19:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613503288;
        bh=C55g7mCUuCjm7Ez3PWGLGQz+jfvuDmdosTrWGgfK1AM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ozMnd0ikBYDQ7Nk2Hyyr0PJ+xVLwXyZtvYvOgnBwzrRqCzQvorOw8eex4PtozvIus
         cjG8Og0ft3IVPOivVZgYs89BSaGfmcm4a0/ypEUi3LVhLspSRJnzYggRnkbO8denWH
         zLSoiDP2M85vjRbCRgGWlmgLiuEl887TpjVl/xcgZyQU8EkkCTk2Y9iF2Z26hBJTOw
         vRuKmGQWEMg3Fc8mgftEshcDB4iymFOwBY+jQ/LEGH7yrneotA7Hdl1deAtZhXtisy
         uexpHQwSXsilOZ4eGfizZSO76EuRpCDVAMD4hyECbhzb8ZMWIUPwcKAldE75DzYUo/
         dRQYhtwxRmziw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        davem@davemloft.net, kuba@kernel.org
Cc:     pavana.sharma@digi.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, lkp@intel.com, ashkan.boldaji@digi.com,
        andrew@lunn.ch, Chris Packham <chris.packham@alliedtelesis.co.nz>,
        olteanv@gmail.com,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 4/4] sfp: add support for 5gbase-t SFPs
Date:   Tue, 16 Feb 2021 20:20:55 +0100
Message-Id: <20210216192055.7078-5-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210216192055.7078-1-kabel@kernel.org>
References: <20210216192055.7078-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sfp_parse_support() function is setting 5000baseT_Full in some cases.
Now that we have PHY_INTERFACE_MODE_5GBASER interface mode available,
change sfp_select_interface() to return PHY_INTERFACE_MODE_5GBASER if
5000baseT_Full is set in the link mode mask.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/sfp-bus.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 3cfd773ae5f4..2e11176c6b94 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -400,6 +400,9 @@ phy_interface_t sfp_select_interface(struct sfp_bus *bus,
 	    phylink_test(link_modes, 10000baseT_Full))
 		return PHY_INTERFACE_MODE_10GBASER;
 
+	if (phylink_test(link_modes, 5000baseT_Full))
+		return PHY_INTERFACE_MODE_5GBASER;
+
 	if (phylink_test(link_modes, 2500baseX_Full))
 		return PHY_INTERFACE_MODE_2500BASEX;
 
-- 
2.26.2

