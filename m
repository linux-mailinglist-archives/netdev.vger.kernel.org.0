Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A710176D25
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 04:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgCCDBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 22:01:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:41750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727822AbgCCCrA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:47:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8DE82468E;
        Tue,  3 Mar 2020 02:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203619;
        bh=m1bj2nosYZ8MFQjvjfH7oDSog1qvxQmq/5hcWMEBSgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jvb/SifAczYjxSHzHX6t5c88HvRYlJYfImEJoxxy8XPptB6OcKdHJmV3b/SDMoUko
         kpze2myosgh8wMombCLnhHfAWGJ/lAccn+Yt7D018JJX2czE5mIWjVXCcGwQZU7Ilg
         74+z1teLEqwJC504bHr6jWzk5QlKVLFDw5Ws0JIs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 35/66] net: ks8851-ml: Fix 16-bit IO operation
Date:   Mon,  2 Mar 2020 21:45:44 -0500
Message-Id: <20200303024615.8889-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024615.8889-1-sashal@kernel.org>
References: <20200303024615.8889-1-sashal@kernel.org>
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
index 5ae206ae5d2b3..1c9e70c8cc30f 100644
--- a/drivers/net/ethernet/micrel/ks8851_mll.c
+++ b/drivers/net/ethernet/micrel/ks8851_mll.c
@@ -166,7 +166,7 @@ static int msg_enable;
 
 static u16 ks_rdreg16(struct ks_net *ks, int offset)
 {
-	ks->cmd_reg_cache = (u16)offset | ((BE1 | BE0) << (offset & 0x02));
+	ks->cmd_reg_cache = (u16)offset | ((BE3 | BE2) >> (offset & 0x02));
 	iowrite16(ks->cmd_reg_cache, ks->hw_addr_cmd);
 	return ioread16(ks->hw_addr);
 }
@@ -181,7 +181,7 @@ static u16 ks_rdreg16(struct ks_net *ks, int offset)
 
 static void ks_wrreg16(struct ks_net *ks, int offset, u16 value)
 {
-	ks->cmd_reg_cache = (u16)offset | ((BE1 | BE0) << (offset & 0x02));
+	ks->cmd_reg_cache = (u16)offset | ((BE3 | BE2) >> (offset & 0x02));
 	iowrite16(ks->cmd_reg_cache, ks->hw_addr_cmd);
 	iowrite16(value, ks->hw_addr);
 }
-- 
2.20.1

