Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08303DDB9E
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbhHBOzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:55:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233962AbhHBOzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 10:55:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FCAB603E9;
        Mon,  2 Aug 2021 14:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627916094;
        bh=gd6OQ4Zwz+1XcZxjkz5g5AcMnW2ndyrD0KHsCPTjG68=;
        h=From:To:Cc:Subject:Date:From;
        b=d6TyXtee1UNYvKa4NyfTbn9v8ArDxAZs9TEMf6TOKU6UFANyssy4+uO9AEH4hnE7g
         Z7XSy/gjLuNlLUczAPVgfLL1mQoEdwjfTZtoKUuqChgwPcF4WVpZ9I9oTkPs8+ChLH
         YAIb7/5m16kZEWF+FJkleGb/ZfjhqxNzfLNZjP46NDEDvfNTn/wh/am1/lv1dVc+Qa
         ZLD7uAZrVoGu5sVoa1uKVR5PmgNNN3Xli2ZXW1qIQkhrR0ez6isJhd8sMETzZ+AVOv
         HrScd/admooZDplS2Xn+n2nX7MxtiY4+QtuwjFA9zcHUwpYDBaXo2wk90NeeD72rqi
         WAfZbZXDSF6xQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: sparx5: fix bitmask check
Date:   Mon,  2 Aug 2021 16:54:37 +0200
Message-Id: <20210802145449.1154565-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Older compilers such as gcc-5.5 produce a warning in this driver
when ifh_encode_bitfield() is not getting inlined:

drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c: In function 'ifh_encode_bitfield':
include/linux/compiler_types.h:333:38: error: call to '__compiletime_assert_545' declared with attribute error: Unsupported width, must be <= 40
drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c:28:2: note: in expansion of macro 'compiletime_assert'
  compiletime_assert(width <= 40, "Unsupported width, must be <= 40");
  ^

Mark the function as __always_inline to make the check work correctly
on all compilers. To make this also work on 32-bit architectures, change
the GENMASK() to GENMASK_ULL().

Fixes: f3cad2611a77 ("net: sparx5: add hostmode with phylink support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
index 9d485a9d1f1f..6f362f6708c6 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
@@ -13,14 +13,15 @@
  */
 #define VSTAX 73
 
-static void ifh_encode_bitfield(void *ifh, u64 value, u32 pos, u32 width)
+static __always_inline void ifh_encode_bitfield(void *ifh, u64 value,
+						u32 pos, u32 width)
 {
 	u8 *ifh_hdr = ifh;
 	/* Calculate the Start IFH byte position of this IFH bit position */
 	u32 byte = (35 - (pos / 8));
 	/* Calculate the Start bit position in the Start IFH byte */
 	u32 bit  = (pos % 8);
-	u64 encode = GENMASK(bit + width - 1, bit) & (value << bit);
+	u64 encode = GENMASK_ULL(bit + width - 1, bit) & (value << bit);
 
 	/* Max width is 5 bytes - 40 bits. In worst case this will
 	 * spread over 6 bytes - 48 bits
-- 
2.29.2

