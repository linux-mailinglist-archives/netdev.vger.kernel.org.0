Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE0D3BCFA6
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234471AbhGFLa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:30:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233796AbhGFL24 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:28:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3A4C61D8E;
        Tue,  6 Jul 2021 11:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570423;
        bh=FB+80IiK/GSGLAobmQcnfjTV7K1piegwndlOBhjA61o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PLUV/GUz4WInd3/uH1G3b+Hjy9nNGT86r2awQdAY/djVzhyYFb1PGmFr0WRJhE4rm
         7RzlYn2XJoz+jb9gNP3ScRb9xll6HpVprXtW0tum+K9itCm763xq0GQ8XwyqfgiE6d
         vbtj4XP3lndwqHTaYW7xSrMlGr000m3n0z9Ql6VerZWP4PXk5KBIf+UYp5fTsxXNta
         W4mx+3Jv2IsN+CsdyQm1B2CGYLv8HYIeenEbsRPuwRoiU83ByUy6tUV7IC/t0vDpDq
         MAiQOxflTY8Mt8ZpwL7d8d1sXWyjxeEa/rnu7MYRaC/z0MbpUEvI+L8DDquxyxLMyX
         FQVFei/fjt4Xw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Koba Ko <koba.ko@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 087/160] r8169: avoid link-up interrupt issue on RTL8106e if user enables ASPM
Date:   Tue,  6 Jul 2021 07:17:13 -0400
Message-Id: <20210706111827.2060499-87-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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
index f7a56e05ec8a..552164af2dd4 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3477,7 +3477,6 @@ static void rtl_hw_start_8106(struct rtl8169_private *tp)
 	rtl_eri_write(tp, 0x1b0, ERIAR_MASK_0011, 0x0000);
 
 	rtl_pcie_state_l2l3_disable(tp);
-	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
 DECLARE_RTL_COND(rtl_mac_ocp_e00e_cond)
-- 
2.30.2

