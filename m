Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADCE39A67D
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 18:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhFCRBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:01:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229719AbhFCRBR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:01:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44AA461159;
        Thu,  3 Jun 2021 16:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622739572;
        bh=2bpSvYxrY6Qyoz1hWqDvV4VCCHIO33THExEDG03/W3k=;
        h=From:To:Cc:Subject:Date:From;
        b=fV5pSS4urHEafoFoZwLNHvHg9OTCMFs+Cm+gxmYqs6XZWm/xmfgGGs1ag3mSztZ3P
         TvktoNobawWbgUuzATf6FieJXcv2EuX4oKDwWu7v2pgYcZlOGIqbRYZUiK+lsH7vWz
         PR3WxR2cC3ouzxOw+Lcq6vBX/YAugHrPYYRGWI1ujxozzINwBfTOkmrxbS2mQ4RqUa
         awPbtlmFY4KgeHm8eIG5vxFVe8tyj2519mLC8W8kmPh929q3f/+EN2cXUgwDjoSHA3
         /m0tBjx6/bomrbi3XoaUvdWAd4fX4iierZo4Tz3GLPGmlgedx1sbFC4W2tonVD+9IJ
         JpSaA9LtWe12w==
From:   Nathan Chancellor <nathan@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH net-next] net: ks8851: Make ks8851_read_selftest() return void
Date:   Thu,  3 Jun 2021 09:56:13 -0700
Message-Id: <20210603165612.2088040-1-nathan@kernel.org>
X-Mailer: git-send-email 2.32.0.rc0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang points out that ret in ks8851_read_selftest() is set but unused:

drivers/net/ethernet/micrel/ks8851_common.c:1028:6: warning: variable
'ret' set but not used [-Wunused-but-set-variable]
        int ret = 0;
            ^
1 warning generated.

The return code of this function has never been checked so just remove
ret and make the function return void.

Fixes: 3ba81f3ece3c ("net: Micrel KS8851 SPI network driver")
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/net/ethernet/micrel/ks8851_common.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
index 13eef6e9bd2d..831518466de2 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -1022,30 +1022,23 @@ static int ks8851_mdio_write(struct mii_bus *bus, int phy_id, int reg, u16 val)
  *
  * Read and check the TX/RX memory selftest information.
  */
-static int ks8851_read_selftest(struct ks8851_net *ks)
+static void ks8851_read_selftest(struct ks8851_net *ks)
 {
 	unsigned both_done = MBIR_TXMBF | MBIR_RXMBF;
-	int ret = 0;
 	unsigned rd;
 
 	rd = ks8851_rdreg16(ks, KS_MBIR);
 
 	if ((rd & both_done) != both_done) {
 		netdev_warn(ks->netdev, "Memory selftest not finished\n");
-		return 0;
+		return;
 	}
 
-	if (rd & MBIR_TXMBFA) {
+	if (rd & MBIR_TXMBFA)
 		netdev_err(ks->netdev, "TX memory selftest fail\n");
-		ret |= 1;
-	}
 
-	if (rd & MBIR_RXMBFA) {
+	if (rd & MBIR_RXMBFA)
 		netdev_err(ks->netdev, "RX memory selftest fail\n");
-		ret |= 2;
-	}
-
-	return 0;
 }
 
 /* driver bus management functions */

base-commit: 270d47dc1fc4756a0158778084a236bc83c156d2
-- 
2.32.0.rc0

