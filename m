Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8313DDC40
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 17:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234859AbhHBPWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 11:22:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234603AbhHBPWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 11:22:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64E5A60725;
        Mon,  2 Aug 2021 15:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627917726;
        bh=scBi9JQGesVoVdIDm8pTXxoX8QYbu2/TP4O6Bq8cYIc=;
        h=From:To:Cc:Subject:Date:From;
        b=ERMtwfPGy17ZOZXbqimbuLFIscdtR/cPoILVcD7UMRwQaifZp9aGX/YtHZYfJeafK
         xC+lPSE3hVAYoaGGbpEz6OTaq6oAVae70OrCSGJjIhSHv5YqNgXl87uuUccd/MIGaf
         eKmF5G3uBv7lJuahx3AOKXkzWZZSoWkdOoAEJTSCvqIG7G11lXRGxpJ2yDsGWGmsbd
         eB6PnxBSKSF+01wgU/drkbNzVG0c50MSKHFTFTYtSiEvna5bTFq+uYIbq55Oj2VEtv
         72DcLW8dQP9RMVeOLV1s9bEJ6gUY0NSSpuoF6utqzpEiGSta6lbGAwp/JbsrF/Wgb3
         bwV46o/WQSGwA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: sparx5: fix bitmask on 32-bit targets
Date:   Mon,  2 Aug 2021 17:21:53 +0200
Message-Id: <20210802152201.1158412-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

I saw the build failure that was fixed in commit 6387f65e2acb ("net:
sparx5: fix compiletime_assert for GCC 4.9") and noticed another
issue that was introduced in the same patch: Using GENMASK() to
create a 64-bit mask does not work on 32-bit architectures.

This probably won't ever happen on this driver since it's specific
to a 64-bit SoC, but it's better to write it portably, so use
GENMASK_ULL() instead.

Fixes: f3cad2611a77 ("net: sparx5: add hostmode with phylink support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
index 1a240e6bddd0..cb68eaaac881 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
@@ -32,7 +32,7 @@ static void __ifh_encode_bitfield(void *ifh, u64 value, u32 pos, u32 width)
 	u32 byte = (35 - (pos / 8));
 	/* Calculate the Start bit position in the Start IFH byte */
 	u32 bit  = (pos % 8);
-	u64 encode = GENMASK(bit + width - 1, bit) & (value << bit);
+	u64 encode = GENMASK_ULL(bit + width - 1, bit) & (value << bit);
 
 	/* The b0-b7 goes into the start IFH byte */
 	if (encode & 0xFF)
-- 
2.29.2

