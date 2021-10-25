Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0164743A59A
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 23:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234980AbhJYVPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 17:15:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232947AbhJYVPc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 17:15:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9821D61076;
        Mon, 25 Oct 2021 21:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635196390;
        bh=c6x2a88MQiWLoeRudW1085kFp+7uZbDkUgE4fWXHX6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V11DS4EhoXg/IP836OngKffoHlWvCmfDiYB+ZyodhbececGE+474cAzIoM2YE1ZB8
         QRymtDMVVMFaGmCFiaRfKII90IBhWZo1Uvk5Rq1ihjhVtHf/qXuiIP/jFMINQCFFmW
         S/hyRUg8H6Jq9Jis7Xf5TPCFHjjZA4ZYT6OB7Ax3uNfbK0n7yzGbrdGgBw82xmYkj8
         7RRVJSVvVl3xARpU0PReLY9pdqSirIsz5vTdaihbG9hM+HBAzdXPg8bYloX715t8Tp
         +3FSNs9Fwu9VfXqNenD52Ir6pwtaMRdOLYLWbdvyYjO5ByeZA7JpT5ZdEIgb5OSzI+
         SWPtMom0xD0iw==
From:   Nathan Chancellor <nathan@kernel.org>
To:     =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 2/2] net: ax88796c: Remove pointless check in ax88796c_open()
Date:   Mon, 25 Oct 2021 14:12:39 -0700
Message-Id: <20211025211238.178768-2-nathan@kernel.org>
X-Mailer: git-send-email 2.33.1.637.gf443b226ca
In-Reply-To: <20211025211238.178768-1-nathan@kernel.org>
References: <20211025211238.178768-1-nathan@kernel.org>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns:

drivers/net/ethernet/asix/ax88796c_main.c:851:24: error: address of
array 'ax_local->phydev->advertising' will always evaluate to 'true'
[-Werror,-Wpointer-bool-conversion]
        if (ax_local->phydev->advertising &&
            ~~~~~~~~~~~~~~~~~~^~~~~~~~~~~ ~~

advertising cannot be NULL here if ax_local is not NULL, which cannot
happen due to the check in ax88796c_probe(). Remove the check.

Link: https://github.com/ClangBuiltLinux/linux/issues/1492
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/net/ethernet/asix/ax88796c_main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethernet/asix/ax88796c_main.c
index cf0f96f93f3b..528a0c43540b 100644
--- a/drivers/net/ethernet/asix/ax88796c_main.c
+++ b/drivers/net/ethernet/asix/ax88796c_main.c
@@ -850,11 +850,10 @@ ax88796c_open(struct net_device *ndev)
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
2.33.1.637.gf443b226ca

