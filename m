Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C2F1E6023
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389503AbgE1MHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 08:07:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388790AbgE1L4j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 07:56:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 976F420DD4;
        Thu, 28 May 2020 11:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590666999;
        bh=5wVdSo/m/klrs/pKqUNgd+2X0/V5oaDF1kVU9FsYKQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SCuAZ2BBliRy92EPXFSy+wb4VSuvWXpKjOcbVi7XDycqpEYKid/0GRBXMEgTPrSSd
         vNCiL6UOc8phn9MRWlkVZjBG4KB7uUV+GEkGgoPUskV8EhtWkEQ06XEugzGzBRTISb
         YBjcD0+c8dEBpd8LU+oSfxR6uRK7Ge5eRYB+RsOU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 34/47] r8169: fix OCP access on RTL8117
Date:   Thu, 28 May 2020 07:55:47 -0400
Message-Id: <20200528115600.1405808-34-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115600.1405808-1-sashal@kernel.org>
References: <20200528115600.1405808-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 561535b0f23961ced071b82575d5e83e6351a814 ]

According to r8168 vendor driver DASHv3 chips like RTL8168fp/RTL8117
need a special addressing for OCP access.
Fix is compile-tested only due to missing test hardware.

Fixes: 1287723aa139 ("r8169: add support for RTL8117")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 07a6b609f741..6e4fe2566f6b 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1044,6 +1044,13 @@ static u16 rtl_ephy_read(struct rtl8169_private *tp, int reg_addr)
 		RTL_R32(tp, EPHYAR) & EPHYAR_DATA_MASK : ~0;
 }
 
+static void r8168fp_adjust_ocp_cmd(struct rtl8169_private *tp, u32 *cmd, int type)
+{
+	/* based on RTL8168FP_OOBMAC_BASE in vendor driver */
+	if (tp->mac_version == RTL_GIGA_MAC_VER_52 && type == ERIAR_OOB)
+		*cmd |= 0x7f0 << 18;
+}
+
 DECLARE_RTL_COND(rtl_eriar_cond)
 {
 	return RTL_R32(tp, ERIAR) & ERIAR_FLAG;
@@ -1052,9 +1059,12 @@ DECLARE_RTL_COND(rtl_eriar_cond)
 static void _rtl_eri_write(struct rtl8169_private *tp, int addr, u32 mask,
 			   u32 val, int type)
 {
+	u32 cmd = ERIAR_WRITE_CMD | type | mask | addr;
+
 	BUG_ON((addr & 3) || (mask == 0));
 	RTL_W32(tp, ERIDR, val);
-	RTL_W32(tp, ERIAR, ERIAR_WRITE_CMD | type | mask | addr);
+	r8168fp_adjust_ocp_cmd(tp, &cmd, type);
+	RTL_W32(tp, ERIAR, cmd);
 
 	rtl_udelay_loop_wait_low(tp, &rtl_eriar_cond, 100, 100);
 }
@@ -1067,7 +1077,10 @@ static void rtl_eri_write(struct rtl8169_private *tp, int addr, u32 mask,
 
 static u32 _rtl_eri_read(struct rtl8169_private *tp, int addr, int type)
 {
-	RTL_W32(tp, ERIAR, ERIAR_READ_CMD | type | ERIAR_MASK_1111 | addr);
+	u32 cmd = ERIAR_READ_CMD | type | ERIAR_MASK_1111 | addr;
+
+	r8168fp_adjust_ocp_cmd(tp, &cmd, type);
+	RTL_W32(tp, ERIAR, cmd);
 
 	return rtl_udelay_loop_wait_high(tp, &rtl_eriar_cond, 100, 100) ?
 		RTL_R32(tp, ERIDR) : ~0;
-- 
2.25.1

