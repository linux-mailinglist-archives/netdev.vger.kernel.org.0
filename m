Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C432D45E61B
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358877AbhKZCt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:49:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:51518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358265AbhKZCrN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 21:47:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F59461206;
        Fri, 26 Nov 2021 02:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894220;
        bh=mrB9ZfL/6zJKt4/Rk1cwFKErBGwvAzza/sx7TBu4Nas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kR4t7gyDUQTE5onUt0Nwm0Qy2t3oy2B59D1mrI4UAhUdAKhwtLjg9NwaH4c/d8/Qm
         HnI/H6Xs59+TBPn7Ig5uPGINpKOtgAA1jHJkKRwtuUB62dG/NPlZzqcHDbAZhggNTl
         /dwFalSJaNMEF+2f56N/THEOT2QAv3PUFCYMfqv2FWYSMC8LayElI+/tTTmhaYOqD3
         RC8i8vOKA3Px+y3HSFlYwPRz7uMxBCIYgEKUdvvn2b6Xg+PO/ALLpTTliaxvXf01Om
         uaClWXdL7QCX6FqseFE9gfvk5qdwD+jbxYbE1fB7F1m5js2VDjfxQe47nSDPNxUqG7
         y91fEULLEa4ig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Teng Qi <starmiku1207184332@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        zhangyue1@kylinos.cn, tanghui20@huawei.com, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 8/8] net: ethernet: dec: tulip: de4x5: fix possible array overflows in type3_infoblock()
Date:   Thu, 25 Nov 2021 21:36:40 -0500
Message-Id: <20211126023640.443271-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023640.443271-1-sashal@kernel.org>
References: <20211126023640.443271-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Teng Qi <starmiku1207184332@gmail.com>

[ Upstream commit 0fa68da72c3be09e06dd833258ee89c33374195f ]

The definition of macro MOTO_SROM_BUG is:
  #define MOTO_SROM_BUG    (lp->active == 8 && (get_unaligned_le32(
  dev->dev_addr) & 0x00ffffff) == 0x3e0008)

and the if statement
  if (MOTO_SROM_BUG) lp->active = 0;

using this macro indicates lp->active could be 8. If lp->active is 8 and
the second comparison of this macro is false. lp->active will remain 8 in:
  lp->phy[lp->active].gep = (*p ? p : NULL); p += (2 * (*p) + 1);
  lp->phy[lp->active].rst = (*p ? p : NULL); p += (2 * (*p) + 1);
  lp->phy[lp->active].mc  = get_unaligned_le16(p); p += 2;
  lp->phy[lp->active].ana = get_unaligned_le16(p); p += 2;
  lp->phy[lp->active].fdx = get_unaligned_le16(p); p += 2;
  lp->phy[lp->active].ttm = get_unaligned_le16(p); p += 2;
  lp->phy[lp->active].mci = *p;

However, the length of array lp->phy is 8, so array overflows can occur.
To fix these possible array overflows, we first check lp->active and then
return -EINVAL if it is greater or equal to ARRAY_SIZE(lp->phy) (i.e. 8).

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Teng Qi <starmiku1207184332@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/dec/tulip/de4x5.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c b/drivers/net/ethernet/dec/tulip/de4x5.c
index b39e8315e4e27..a5a291b848b06 100644
--- a/drivers/net/ethernet/dec/tulip/de4x5.c
+++ b/drivers/net/ethernet/dec/tulip/de4x5.c
@@ -4704,6 +4704,10 @@ type3_infoblock(struct net_device *dev, u_char count, u_char *p)
         lp->ibn = 3;
         lp->active = *p++;
 	if (MOTO_SROM_BUG) lp->active = 0;
+	/* if (MOTO_SROM_BUG) statement indicates lp->active could
+	 * be 8 (i.e. the size of array lp->phy) */
+	if (WARN_ON(lp->active >= ARRAY_SIZE(lp->phy)))
+		return -EINVAL;
 	lp->phy[lp->active].gep = (*p ? p : NULL); p += (2 * (*p) + 1);
 	lp->phy[lp->active].rst = (*p ? p : NULL); p += (2 * (*p) + 1);
 	lp->phy[lp->active].mc  = get_unaligned_le16(p); p += 2;
-- 
2.33.0

