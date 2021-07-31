Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F483DC655
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 16:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbhGaOjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 10:39:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233147AbhGaOja (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Jul 2021 10:39:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7129F60C3F;
        Sat, 31 Jul 2021 14:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627742363;
        bh=AKrk37W3J+Qc1vsOls7j9PcAcdJzI1GvPxAcbK/wpkg=;
        h=From:To:Cc:Subject:Date:From;
        b=M0b8s5yJOimu70ZdL5KWc97Jd3N1UArCd/V7pHVIZaQzi+M3XiO9TRayrlfyNbYbZ
         XNPYmjus/vPqGQPrfAROnJgH5QZYGSolGYgWum3y8jU7fwBokCUZGTMpAZN96xVSXz
         yf3dRoSAh099BhEYHhtLY7/B1YyQRTkmtrq03ecXrc3nW3f06zTX8blClIoxI6nGnu
         cBh4C3C+J1W3FgeK9mnX7iZSxpqzEQ/aaQ3EQ5Y82oN+9720ay0GbKaFgYTwXPxzdi
         zdcVBBRCjSM8SBs3f1qcY3wIjYFW68WXyluzg/w+VVm+98/Gh4dbseZiYGZwUg0+ZN
         jk3XBj2bfshNA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        bjarni.jonasson@microchip.com, Jakub Kicinski <kuba@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH net] net: sparx5: fix compiletime_assert for GCC 4.9
Date:   Sat, 31 Jul 2021 07:39:17 -0700
Message-Id: <20210731143917.994166-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen reports sparx5 broke GCC 4.9 build.
Move the compiletime_assert() out of the static function.
Compile-tested only, no object code changes.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: f3cad2611a77 ("net: sparx5: add hostmode with phylink support")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../ethernet/microchip/sparx5/sparx5_netdev.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
index 9d485a9d1f1f..1a240e6bddd0 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
@@ -13,7 +13,19 @@
  */
 #define VSTAX 73
 
-static void ifh_encode_bitfield(void *ifh, u64 value, u32 pos, u32 width)
+#define ifh_encode_bitfield(ifh, value, pos, _width)			\
+	({								\
+		u32 width = (_width);					\
+									\
+		/* Max width is 5 bytes - 40 bits. In worst case this will
+		 * spread over 6 bytes - 48 bits
+		 */							\
+		compiletime_assert(width <= 40,				\
+				   "Unsupported width, must be <= 40");	\
+		__ifh_encode_bitfield((ifh), (value), (pos), width);	\
+	})
+
+static void __ifh_encode_bitfield(void *ifh, u64 value, u32 pos, u32 width)
 {
 	u8 *ifh_hdr = ifh;
 	/* Calculate the Start IFH byte position of this IFH bit position */
@@ -22,11 +34,6 @@ static void ifh_encode_bitfield(void *ifh, u64 value, u32 pos, u32 width)
 	u32 bit  = (pos % 8);
 	u64 encode = GENMASK(bit + width - 1, bit) & (value << bit);
 
-	/* Max width is 5 bytes - 40 bits. In worst case this will
-	 * spread over 6 bytes - 48 bits
-	 */
-	compiletime_assert(width <= 40, "Unsupported width, must be <= 40");
-
 	/* The b0-b7 goes into the start IFH byte */
 	if (encode & 0xFF)
 		ifh_hdr[byte] |= (u8)((encode & 0xFF));
-- 
2.31.1

