Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E90B41567F
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 05:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239539AbhIWDlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 23:41:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239380AbhIWDkq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 23:40:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBD9461214;
        Thu, 23 Sep 2021 03:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368354;
        bh=Dd1GqI2Jphg7qSSjWvRMhq+VxeITvpprokuSUFoLe7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jwbknRezj8FAJxsCssvmsqqkWKTMKrfm0wseMHtZOIDXXPMb5UcwyEIaFWUMpoJwY
         tK8xN52R2b1IuwPflKVfWu9j6TQPY1j2q4gOUIuRgefkYlCarnULCVfspMLjtxz0Ty
         Wl4wuvoITy+zg6BQ7zm/vHaF42C8hcurSYtrJa7TP3iip11L5Pz2dYgSvtRtikxvl1
         SZ3jdEurEg6sMP6Q9Kc9wLvSN+e+4a3SQzWeG1/uFBbrwjDh3OvWEUUp3Z5yzFkI9q
         LB9Qqvs6/K0EiWMUM5obxgIt8i7b96dvuI7tYfxzhqZZpsuVx722RyPhxjDRn19Hh7
         UBw9xju4r5eKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, arnd@arndb.de, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/19] net: i825xx: Use absolute_pointer for memcpy from fixed memory location
Date:   Wed, 22 Sep 2021 23:38:46 -0400
Message-Id: <20210923033853.1421193-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923033853.1421193-1-sashal@kernel.org>
References: <20210923033853.1421193-1-sashal@kernel.org>
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
index 92929750f832..54d5b402b0e8 100644
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

