Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0E6C176BAA
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 03:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbgCCCuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:50:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:47028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729114AbgCCCuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:50:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 099F0246DE;
        Tue,  3 Mar 2020 02:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203817;
        bh=JWZ9FwWt1KKnILBTWu7vLkJhY59MMHT8tRRn+QvVnhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hiPLmha1XMBj7OSfwknAmjJgIebYzH/J20gg3il9H70TgQXA7VDWyEkXBOwddVm2M
         uj9dsj//fcVqw5DMCJE90KCBQ1wmLIjQKP9jBV5QDdV/cOPYhE+MzWnXhxnFFyIIw9
         nmWHu8KB8aXZlDjxRq/sR2jrMWJQYB2cXS5MCj5Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 10/13] net: ks8851-ml: Fix 16-bit IO operation
Date:   Mon,  2 Mar 2020 21:49:59 -0500
Message-Id: <20200303025002.10600-10-sashal@kernel.org>
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

[ Upstream commit 58292104832fef6cb4a89f736012c0e0724c3442 ]

The Micrel KSZ8851-16MLLI datasheet DS00002357B page 12 states that
BE[3:0] signals are active high. This contradicts the measurements
of the behavior of the actual chip, where these signals behave as
active low. For example, to read the CIDER register, the bus must
expose 0xc0c0 during the address phase, which means BE[3:0]=4'b1100.

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
index 20356976b9772..d94e151cff12b 100644
--- a/drivers/net/ethernet/micrel/ks8851_mll.c
+++ b/drivers/net/ethernet/micrel/ks8851_mll.c
@@ -484,7 +484,7 @@ static int msg_enable;
 
 static u16 ks_rdreg16(struct ks_net *ks, int offset)
 {
-	ks->cmd_reg_cache = (u16)offset | ((BE1 | BE0) << (offset & 0x02));
+	ks->cmd_reg_cache = (u16)offset | ((BE3 | BE2) >> (offset & 0x02));
 	iowrite16(ks->cmd_reg_cache, ks->hw_addr_cmd);
 	return ioread16(ks->hw_addr);
 }
@@ -499,7 +499,7 @@ static u16 ks_rdreg16(struct ks_net *ks, int offset)
 
 static void ks_wrreg16(struct ks_net *ks, int offset, u16 value)
 {
-	ks->cmd_reg_cache = (u16)offset | ((BE1 | BE0) << (offset & 0x02));
+	ks->cmd_reg_cache = (u16)offset | ((BE3 | BE2) >> (offset & 0x02));
 	iowrite16(ks->cmd_reg_cache, ks->hw_addr_cmd);
 	iowrite16(value, ks->hw_addr);
 }
-- 
2.20.1

