Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20EC615FF4C
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 17:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgBOQyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 11:54:37 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:45156 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgBOQyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 11:54:37 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48KbvG4HCwz1rY6H;
        Sat, 15 Feb 2020 17:54:34 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48KbvG3Jjsz1r0bw;
        Sat, 15 Feb 2020 17:54:34 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id snukEF1JEYNr; Sat, 15 Feb 2020 17:54:33 +0100 (CET)
X-Auth-Info: 2MfpVunrofObmBxO5npE1j+UdWO5B6uL1+EbRnnaXh0=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sat, 15 Feb 2020 17:54:33 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V2 2/3] net: ks8851-ml: Fix 16-bit data access
Date:   Sat, 15 Feb 2020 17:54:18 +0100
Message-Id: <20200215165419.3901611-2-marex@denx.de>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200215165419.3901611-1-marex@denx.de>
References: <20200215165419.3901611-1-marex@denx.de>
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
V2: Replace swab16 with be16_to_cpu()/cpu_to_be16()
---
 drivers/net/ethernet/micrel/ks8851_mll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_mll.c b/drivers/net/ethernet/micrel/ks8851_mll.c
index e2fb20154511..5ae206ae5d2b 100644
--- a/drivers/net/ethernet/micrel/ks8851_mll.c
+++ b/drivers/net/ethernet/micrel/ks8851_mll.c
@@ -197,7 +197,7 @@ static inline void ks_inblk(struct ks_net *ks, u16 *wptr, u32 len)
 {
 	len >>= 1;
 	while (len--)
-		*wptr++ = (u16)ioread16(ks->hw_addr);
+		*wptr++ = be16_to_cpu(ioread16(ks->hw_addr));
 }
 
 /**
@@ -211,7 +211,7 @@ static inline void ks_outblk(struct ks_net *ks, u16 *wptr, u32 len)
 {
 	len >>= 1;
 	while (len--)
-		iowrite16(*wptr++, ks->hw_addr);
+		iowrite16(cpu_to_be16(*wptr++), ks->hw_addr);
 }
 
 static void ks_disable_int(struct ks_net *ks)
-- 
2.25.0

