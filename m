Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 282101582D3
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 19:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbgBJSl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 13:41:57 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:52368 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727572AbgBJSl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 13:41:57 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48GZWR1cHRz1qqkn;
        Mon, 10 Feb 2020 19:41:55 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48GZWQ74GXz1qxyh;
        Mon, 10 Feb 2020 19:41:54 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id xWJoiW-4rfgI; Mon, 10 Feb 2020 19:41:54 +0100 (CET)
X-Auth-Info: i2t6YZ1wFuWNgacg1XPwQavnB8N+BVGuZg2GytsYP7U=
Received: from chi.lan (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon, 10 Feb 2020 19:41:54 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH 2/3] net: ks8851-ml: Fix 16-bit data access
Date:   Mon, 10 Feb 2020 19:41:38 +0100
Message-Id: <20200210184139.342716-2-marex@denx.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200210184139.342716-1-marex@denx.de>
References: <20200210184139.342716-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The packet data written to and read from Micrel KSZ8851-16MLLI must be
byte-swapped in 16-bit mode, add this byte-swapping.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/micrel/ks8851_mll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_mll.c b/drivers/net/ethernet/micrel/ks8851_mll.c
index e2fb20154511..e9ca198a67a4 100644
--- a/drivers/net/ethernet/micrel/ks8851_mll.c
+++ b/drivers/net/ethernet/micrel/ks8851_mll.c
@@ -197,7 +197,7 @@ static inline void ks_inblk(struct ks_net *ks, u16 *wptr, u32 len)
 {
 	len >>= 1;
 	while (len--)
-		*wptr++ = (u16)ioread16(ks->hw_addr);
+		*wptr++ = swab16(ioread16(ks->hw_addr));
 }
 
 /**
@@ -211,7 +211,7 @@ static inline void ks_outblk(struct ks_net *ks, u16 *wptr, u32 len)
 {
 	len >>= 1;
 	while (len--)
-		iowrite16(*wptr++, ks->hw_addr);
+		iowrite16(swab16(*wptr++), ks->hw_addr);
 }
 
 static void ks_disable_int(struct ks_net *ks)
-- 
2.24.1

