Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA999C3D84
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 19:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731231AbfJARAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 13:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730326AbfJAQk4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:40:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8E1B2168B;
        Tue,  1 Oct 2019 16:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948055;
        bh=ttfL22i8VOJxOo90cM3zwNu7cL+4VRkRFVC1uGUgjM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wns/XgQ6vrZiGhTXNfjH2bWViXUJtVf5w8E8W+9ORYP73L1BSX1hVH6bilSnFUg1T
         tnBPCVy5Sw3ePBvPk0GGPH9mTJAkIy0dwG4LpM0OXG4LSV3d5KAmXH/Jfu3Cqs0L7J
         /u3LC81X0oUSbaMGr+5svBKT14HibKRjEGkZpLq0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 57/71] net: dsa: microchip: Always set regmap stride to 1
Date:   Tue,  1 Oct 2019 12:39:07 -0400
Message-Id: <20191001163922.14735-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001163922.14735-1-sashal@kernel.org>
References: <20191001163922.14735-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit a3aa6e65beebf3780026753ebf39db19f4c92990 ]

The regmap stride is set to 1 for regmap describing 8bit registers already.
However, for 16/32/64bit registers, the stride is 2/4/8 respectively. This
is not correct, as the switch protocol supports unaligned register reads
and writes and the KSZ87xx even uses such unaligned register accesses to
read e.g. MIB counter.

This patch fixes MIB counter access on KSZ87xx.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: George McCollister <george.mccollister@gmail.com>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: Woojung Huh <woojung.huh@microchip.com>
Fixes: 46558d601cb6 ("net: dsa: microchip: Initial SPI regmap support")
Fixes: 255b59ad0db2 ("net: dsa: microchip: Factor out regmap config generation into common header")
Reviewed-by: George McCollister <george.mccollister@gmail.com>
Tested-by: George McCollister <george.mccollister@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 72ec250b95408..823f544add0a3 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -130,7 +130,7 @@ static inline void ksz_pwrite32(struct ksz_device *dev, int port, int offset,
 	{								\
 		.name = #width,						\
 		.val_bits = (width),					\
-		.reg_stride = (width) / 8,				\
+		.reg_stride = 1,					\
 		.reg_bits = (regbits) + (regalign),			\
 		.pad_bits = (regpad),					\
 		.max_register = BIT(regbits) - 1,			\
-- 
2.20.1

