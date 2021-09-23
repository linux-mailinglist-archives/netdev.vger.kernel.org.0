Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43454156F5
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 05:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239260AbhIWDpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 23:45:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239884AbhIWDnC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 23:43:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6E0961263;
        Thu, 23 Sep 2021 03:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368437;
        bh=IdEcxKlqrg2cR74Um15fzJELuPq7pW0NGWIePThekts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jog9SUzqrQjKNfHVODdoOBSlnoBGp+Aqy6n7tGVc7hkUS/4Z5RrSK2sqcn/rcept8
         O6rhKhwZr6Ijug0W1dgBMVdHG1HWEm2yuenN/9CKwmriEj8POEkALS13JIKNjKoW0+
         yir8U48vx/xFPvDoKILBz7eLlTijRU27Y+3EocMkCunn0GnXTHqGemYD4JyHBLnGC1
         rC0xO6puxsEvLuDGm0x4H6K4tMwfXPAV6WeqZ64dp5UYibKFdRKGdffeeWWR1wIKnl
         lPht7tICxwv5iLimlAhYPFYzcC5bYFV9B5UXOYlRvNnDhDjTs3ggzbTu9VU/0iNk6v
         XFTliMhIBehyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, arnd@arndb.de, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 04/11] net: i825xx: Use absolute_pointer for memcpy from fixed memory location
Date:   Wed, 22 Sep 2021 23:40:20 -0400
Message-Id: <20210923034028.1421876-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923034028.1421876-1-sashal@kernel.org>
References: <20210923034028.1421876-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit dff2d13114f0beec448da9b3716204eb34b0cf41 ]

gcc 11.x reports the following compiler warning/error.

  drivers/net/ethernet/i825xx/82596.c: In function 'i82596_probe':
  arch/m68k/include/asm/string.h:72:25: error:
	'__builtin_memcpy' reading 6 bytes from a region of size 0 [-Werror=stringop-overread]

Use absolute_pointer() to work around the problem.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/i825xx/82596.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/i825xx/82596.c b/drivers/net/ethernet/i825xx/82596.c
index ce235b776793..299628931bdb 100644
--- a/drivers/net/ethernet/i825xx/82596.c
+++ b/drivers/net/ethernet/i825xx/82596.c
@@ -1155,7 +1155,7 @@ struct net_device * __init i82596_probe(int unit)
 			err = -ENODEV;
 			goto out;
 		}
-		memcpy(eth_addr, (void *) 0xfffc1f2c, ETH_ALEN);	/* YUCK! Get addr from NOVRAM */
+		memcpy(eth_addr, absolute_pointer(0xfffc1f2c), ETH_ALEN); /* YUCK! Get addr from NOVRAM */
 		dev->base_addr = MVME_I596_BASE;
 		dev->irq = (unsigned) MVME16x_IRQ_I596;
 		goto found;
-- 
2.30.2

