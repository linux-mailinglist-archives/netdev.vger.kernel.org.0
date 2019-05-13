Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD5C61B077
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 08:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfEMGmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 02:42:32 -0400
Received: from mx.socionext.com ([202.248.49.38]:3119 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbfEMGmb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 02:42:31 -0400
Received: from unknown (HELO kinkan-ex.css.socionext.com) ([172.31.9.52])
  by mx.socionext.com with ESMTP; 13 May 2019 15:42:30 +0900
Received: from mail.mfilter.local (m-filter-1 [10.213.24.61])
        by kinkan-ex.css.socionext.com (Postfix) with ESMTP id 42C3C180C09;
        Mon, 13 May 2019 15:42:30 +0900 (JST)
Received: from 172.31.9.51 (172.31.9.51) by m-FILTER with ESMTP; Mon, 13 May 2019 15:42:30 +0900
Received: from plum.e01.socionext.com (unknown [10.213.132.32])
        by kinkan.css.socionext.com (Postfix) with ESMTP id ED7291A10F1;
        Mon, 13 May 2019 15:42:28 +0900 (JST)
From:   Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Subject: [PATCH net] net: phy: realtek: Replace phy functions with non-locked version in rtl8211e_config_init()
Date:   Mon, 13 May 2019 15:41:45 +0900
Message-Id: <1557729705-6443-1-git-send-email-hayashi.kunihiko@socionext.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After calling phy_select_page() and until calling phy_restore_page(),
the mutex 'mdio_lock' is already locked, so the driver should use
non-locked version of phy functions. Or there will be a deadlock with
'mdio_lock'.

This replaces phy functions called from rtl8211e_config_init() to avoid
the deadlock issue.

Fixes: f81dadbcf7fd ("net: phy: realtek: Add rtl8211e rx/tx delays config")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
---
 drivers/net/phy/realtek.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index e1f7a60..61fc76f 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -233,12 +233,12 @@ static int rtl8211e_config_init(struct phy_device *phydev)
 	if (oldpage < 0)
 		goto err_restore_page;
 
-	ret = phy_write(phydev, RTL821x_EXT_PAGE_SELECT, 0xa4);
+	ret = __phy_write(phydev, RTL821x_EXT_PAGE_SELECT, 0xa4);
 	if (ret)
 		goto err_restore_page;
 
-	ret = phy_modify(phydev, 0x1c, RTL8211E_TX_DELAY | RTL8211E_RX_DELAY,
-			 val);
+	ret = __phy_modify(phydev, 0x1c, RTL8211E_TX_DELAY | RTL8211E_RX_DELAY,
+			   val);
 
 err_restore_page:
 	return phy_restore_page(phydev, oldpage, ret);
-- 
2.7.4

