Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED1943BB4A
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 21:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239026AbhJZT7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 15:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237233AbhJZT7j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 15:59:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF30960200;
        Tue, 26 Oct 2021 19:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635278235;
        bh=agXhZXdORInKzk2eJULI7CqzZDwX5Xq3pOnCJ2/ScLg=;
        h=From:To:Cc:Subject:Date:From;
        b=SHPxH0PQ0kPedkeoP18C7vSPjzjwXLsPZhs01EXvNqrnSJkZLS95YCImQezOH2hd4
         Ob7rBaO9B3kI3L7uP8eMyAFB/2tAFYLvjFMT6KX+O8x6omZa7oKzAwBH5JY9Q29SyY
         VsH12efAmqs/mBxsaZppy+wrxLxKOAhw82RvvmF4QOlPaXeK5G2Jos46Fx3MtBZjUo
         Avn0clAwDhYpKTe5Z4zukX/lizpQ/ALbAE6gf9DKExAorb2NmdqlNmDLNp3cHyq8A/
         BBruMcwaTwrX6ZpoCNBZohTufZJ/qOMb00ftj4RFYRKiNs55ShucpEapXQTPkhUe/p
         6MJZwMFUEUcZQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH net-next] net: ax88796c: fix -Wpointer-bool-conversion warning
Date:   Tue, 26 Oct 2021 21:56:39 +0200
Message-Id: <20211026195711.16152-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

ax_local->phydev->advertising is an array, not a pointer, so
clang points out that checking for NULL is unnecessary:

drivers/net/ethernet/asix/ax88796c_main.c:851:24: error: address of array 'ax_local->phydev->advertising' will always evaluate to 'true' [-Werror,-Wpointer-bool-conversion]
        if (ax_local->phydev->advertising &&
            ~~~~~~~~~~~~~~~~~~^~~~~~~~~~~ ~~

Fixes: a97c69ba4f30 ("net: ax88796c: ASIX AX88796C SPI Ethernet Adapter Driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/asix/ax88796c_main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethernet/asix/ax88796c_main.c
index cfc597f72e3d..846a04922561 100644
--- a/drivers/net/ethernet/asix/ax88796c_main.c
+++ b/drivers/net/ethernet/asix/ax88796c_main.c
@@ -848,11 +848,10 @@ ax88796c_open(struct net_device *ndev)
 	/* Setup flow-control configuration */
 	phy_support_asym_pause(ax_local->phydev);
 
-	if (ax_local->phydev->advertising &&
-	    (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
-			       ax_local->phydev->advertising) ||
-	     linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
-			       ax_local->phydev->advertising)))
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+			      ax_local->phydev->advertising) ||
+	    linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+			      ax_local->phydev->advertising))
 		fc |= AX_FC_ANEG;
 
 	fc |= linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
-- 
2.29.2

