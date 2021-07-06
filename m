Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059AC3BCBFC
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbhGFLSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:18:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232248AbhGFLRq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:17:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D981E61C3B;
        Tue,  6 Jul 2021 11:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570108;
        bh=ObAFjK18truRzozmZTUYHgyUs896X41mEoMJYQq6MB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RvSFgAE7ez8UlPDoRuLvf1o2UsLlO0f2kx5RAQezIypcqbuhBlg32Ff49KAsAeEIq
         +/OHJiFKp2rLLIWrpnB/Po1jXm31+TFgR7KPq+aBC6/wQQ1JCRsHKEm4kT/0fm/Rn8
         vVl+viuSwNTU/xk7yKSebqkdU+VQA5OMzUxpFhBU3Y0yxvrLS5XFp09UNlUlt6HgEI
         kAUVJpfeON1wkV77ckIyhROs3KDz3Kxp947aAbeXH5VJ1yL7k24VKe3yUtfKRsEre4
         1g/FZFa+ySSIN5/YROeiBx2OQErNAMmDaW4pg6dLG6/od5Gp2TmftijLSu2hjepvsJ
         Xe0G8LLsqIsHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 041/189] net: xilinx_emaclite: Do not print real IOMEM pointer
Date:   Tue,  6 Jul 2021 07:11:41 -0400
Message-Id: <20210706111409.2058071-41-sashal@kernel.org>
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

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit d0d62baa7f505bd4c59cd169692ff07ec49dde37 ]

Printing kernel pointers is discouraged because they might leak kernel
memory layout.  This fixes smatch warning:

drivers/net/ethernet/xilinx/xilinx_emaclite.c:1191 xemaclite_of_probe() warn:
 argument 4 to %08lX specifier is cast from pointer

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index d9d58a7dabee..b06377fe7293 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1189,9 +1189,8 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
 	}
 
 	dev_info(dev,
-		 "Xilinx EmacLite at 0x%08lX mapped to 0x%08lX, irq=%d\n",
-		 (unsigned long __force)ndev->mem_start,
-		 (unsigned long __force)lp->base_addr, ndev->irq);
+		 "Xilinx EmacLite at 0x%08lX mapped to 0x%p, irq=%d\n",
+		 (unsigned long __force)ndev->mem_start, lp->base_addr, ndev->irq);
 	return 0;
 
 error:
-- 
2.30.2

