Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 720F63BCC96
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbhGFLTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:19:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232758AbhGFLTF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:19:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 735BC61C4C;
        Tue,  6 Jul 2021 11:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570187;
        bh=5TOr71VUDOiqYVGvZq2pvb41l1QmDcVK6CxhXV/U/8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=enFms4T1IPeN9lTcyMGxUR/7lggBnypnlKznvJ4HKDPnhJr08MxP63i0HD652uXsW
         /dNN4hYdm5kFXIW+v6nKfPyzFNJaqaCx1U0j4xWfPlayQwApbIiTFfawj+ewkZslri
         /RRN04b0AGVXeTlJXPj6r7z2OR9HYIAeT5+IpkgYySksLUL7kFiMROXnZ4ehFLHovb
         ds/UguvBfR3xKgcVd2YmRfnWhC0tbCJIucJX/Q4rfolUPp7HsXdRz08YcQhuBG41Te
         /YwMdp8E6ZbD59MFT3MMJV2Ae1yVF3t1Nhb9DmOmFK7HEiA3Mey9fR9yJpH/1zLMmO
         uRSi35OfDs1uQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Koba Ko <koba.ko@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 102/189] r8169: avoid link-up interrupt issue on RTL8106e if user enables ASPM
Date:   Tue,  6 Jul 2021 07:12:42 -0400
Message-Id: <20210706111409.2058071-102-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 1ee8856de82faec9bc8bd0f2308a7f27e30ba207 ]

It has been reported that on RTL8106e the link-up interrupt may be
significantly delayed if the user enables ASPM L1. Per default ASPM
is disabled. The change leaves L1 enabled on the PCIe link (thus still
allowing to reach higher package power saving states), but the
NIC won't actively trigger it.

Reported-by: Koba Ko <koba.ko@canonical.com>
Tested-by: Koba Ko <koba.ko@canonical.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 2ee72dc431cd..a0d4e052a79e 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3510,7 +3510,6 @@ static void rtl_hw_start_8106(struct rtl8169_private *tp)
 	rtl_eri_write(tp, 0x1b0, ERIAR_MASK_0011, 0x0000);
 
 	rtl_pcie_state_l2l3_disable(tp);
-	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
 DECLARE_RTL_COND(rtl_mac_ocp_e00e_cond)
-- 
2.30.2

