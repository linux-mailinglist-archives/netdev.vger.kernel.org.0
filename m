Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52753BCEE6
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbhGFL1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:27:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234891AbhGFLZL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:25:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 013EB61D42;
        Tue,  6 Jul 2021 11:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570351;
        bh=ejLs/9B8myPw5TPe2fDeG1oNOhZQi2VNiScpEUlppV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BSt//SlTLwFvlnJsVeJcAfRH5QrLDml/MVnbYROMfk2LDdxlFxjbnOtonL8J+QNpY
         7/uwZnqifoR8z6YDzn1GLqaX+mzdgj/Nre9JvCKDHjvqdzdpi59lRcxrvQDk4pWu3/
         vZXUCGesoG7zT+JxTOI2IglOowWPW58FCspsUOU2CeUND0LiYhrjwSTj30hB4Duqdd
         b9c8VbdEZAox70IMq4NTYdH0vgQMom0MF8RkpwefOkiKiiqTsuHc8WgUIFqRZgficB
         kMioItnt9024jPQQyuLQ8cazJEoD+374GQnBcX7TzagdtyTJOt9U6DzJpQmZOzExg8
         tn9TW3qtzBK7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 033/160] net: xilinx_emaclite: Do not print real IOMEM pointer
Date:   Tue,  6 Jul 2021 07:16:19 -0400
Message-Id: <20210706111827.2060499-33-sashal@kernel.org>
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
index 007840d4a807..3ffe8d2a1f14 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1193,9 +1193,8 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
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

