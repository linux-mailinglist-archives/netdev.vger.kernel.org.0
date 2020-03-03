Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8250F176BAD
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 03:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgCCCuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:50:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:46976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728482AbgCCCuQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:50:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE3472468D;
        Tue,  3 Mar 2020 02:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203815;
        bh=ABU12IfNmFeJk/drjZr/gSCCysZwfcqqTJ7L/m1fD/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tHfsE9DX56H6V0vyed2WCfbBV4qKlECEXi6wNly6q7Oe64niwLy8NgAh9rH44vxUs
         Qz1/9UtxwiGcOB4QOwOvWe2dWB6h9V621n1kbDtk/blcg4vbSlIdyv6eoOWTQWB6k9
         nMBs2si35KbnSihpuERicj3lvCfKQW2HtQPbbzGs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 09/13] net: ks8851-ml: Fix 16-bit data access
Date:   Mon,  2 Mar 2020 21:49:58 -0500
Message-Id: <20200303025002.10600-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303025002.10600-1-sashal@kernel.org>
References: <20200303025002.10600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit edacb098ea9c31589276152f09b4439052c0f2b1 ]

The packet data written to and read from Micrel KSZ8851-16MLLI must be
byte-swapped in 16-bit mode, add this byte-swapping.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/micrel/ks8851_mll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_mll.c b/drivers/net/ethernet/micrel/ks8851_mll.c
index 721f851674531..20356976b9772 100644
--- a/drivers/net/ethernet/micrel/ks8851_mll.c
+++ b/drivers/net/ethernet/micrel/ks8851_mll.c
@@ -515,7 +515,7 @@ static inline void ks_inblk(struct ks_net *ks, u16 *wptr, u32 len)
 {
 	len >>= 1;
 	while (len--)
-		*wptr++ = (u16)ioread16(ks->hw_addr);
+		*wptr++ = be16_to_cpu(ioread16(ks->hw_addr));
 }
 
 /**
@@ -529,7 +529,7 @@ static inline void ks_outblk(struct ks_net *ks, u16 *wptr, u32 len)
 {
 	len >>= 1;
 	while (len--)
-		iowrite16(*wptr++, ks->hw_addr);
+		iowrite16(cpu_to_be16(*wptr++), ks->hw_addr);
 }
 
 static void ks_disable_int(struct ks_net *ks)
-- 
2.20.1

