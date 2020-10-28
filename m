Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B78629D666
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731244AbgJ1WOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731223AbgJ1WOg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:14:36 -0400
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67F2324743;
        Wed, 28 Oct 2020 22:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603923275;
        bh=/Y1YcgJEnITrM+UgkNFYD7JnHEHOoxCPlRY/J1OzAZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DeznzlD0RfhA9GQvgUcCKGZa9hAxHYxcYwK0X8TDO4mdq4CQKeavFb+kkAlktY1Sf
         NjX6L4L/Trvho+ZrVozSX9vcF96BofpIi/Z7vU764Wk5Nt0jk5eLFfxY+YQV66HfzD
         aNIe0APoXJhrftTqiM7D8R4kafGq4HXE2QtSzhxE=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next 2/5] net: phylink: allow attaching phy for SFP modules on 802.3z mode
Date:   Wed, 28 Oct 2020 23:14:24 +0100
Message-Id: <20201028221427.22968-3-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201028221427.22968-1-kabel@kernel.org>
References: <20201028221427.22968-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some SFPs may contain an internal PHY which may in some cases want to
connect with the host interface in 1000base-x/2500base-x mode.
Do not fail if such PHY is being attached in one of these PHY interface
modes.

Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 5d8c015bc9f2..52954f12ca5e 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1018,7 +1018,7 @@ static int phylink_attach_phy(struct phylink *pl, struct phy_device *phy,
 {
 	if (WARN_ON(pl->cfg_link_an_mode == MLO_AN_FIXED ||
 		    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
-		     phy_interface_mode_is_8023z(interface))))
+		     phy_interface_mode_is_8023z(interface) && !pl->sfp_bus)))
 		return -EINVAL;
 
 	if (pl->phydev)
-- 
2.26.2

