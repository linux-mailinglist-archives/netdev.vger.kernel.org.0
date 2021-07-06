Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5FFD3BD161
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238274AbhGFLjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:39:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237176AbhGFLf7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A002D61CD9;
        Tue,  6 Jul 2021 11:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570754;
        bh=1mtU8YSKv4BPkxTJfhmoD7GsJDIIoEDrFVjRf6WTsIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iY2eKZh0YV/42UTF2VGEd7YFXDfQZau0IPieY+44oiPjZzU1XY5cISPEoNolMwJjN
         ax3e2zKwfgTbED15RlWgGsEfregbNSqEzfn5f9Au3exy8s2ccJlQ6vLgvmfIZ7tBvr
         EUUxNq87DJS3pvGqMEAkEnCNFM3miGBYL1sQY8bNoA53YKjoZ04V9TLQx10u9E7ZFN
         tncrFep9SVe6pnZF1pbsNQQwLJWpGSkIOgigdWwkRWBbgoMpWQyjbxDi3bg14fUjFX
         Ctwmr2F4nYjulgBvsOSSGthNYLw/1wHqjusljWPqgLFTdDrt4Tn88v6Eboh29LbZs/
         2GjVf58NCMaTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Koba Ko <koba.ko@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 41/74] r8169: avoid link-up interrupt issue on RTL8106e if user enables ASPM
Date:   Tue,  6 Jul 2021 07:24:29 -0400
Message-Id: <20210706112502.2064236-41-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
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
index 661202e85412..5969f64169e5 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5190,7 +5190,6 @@ static void rtl_hw_start_8106(struct rtl8169_private *tp)
 	RTL_W8(tp, DLLPR, RTL_R8(tp, DLLPR) & ~PFM_EN);
 
 	rtl_pcie_state_l2l3_disable(tp);
-	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
 DECLARE_RTL_COND(rtl_mac_ocp_e00e_cond)
-- 
2.30.2

