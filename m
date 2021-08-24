Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F3D3F551B
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 02:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbhHXA7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 20:59:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234486AbhHXA5P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 20:57:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01EEC615E0;
        Tue, 24 Aug 2021 00:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766544;
        bh=AUH35JSSsY17ol35rLqw1Deg7KdQeZy6AL5d2IXjs4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IIM31lmdIrjqVySZD0b7vE6vgIm+yIlfFdy4VjeiwqgON8v+fUkXuDCBPXr0717fz
         iOf/aVygGLxmznWhfPlZGE58/8p4jkCCVKaYl5wIgtRp1peEjTJHesIx/rJ/fyVtZR
         w89jgF1paaqpDit2L5QQ1I6KOZGwLE5BE/tbzJJWzLpsB8tg8ZX2ZcH7amJqVWdo3s
         CU94E318VnQ1UB41lTiDYYj7kXe3oNOn2KQ1qr1u5yfKxLS+aNfCf/GKP36KZJupW2
         0QGhMXHrN1M5X1f5en5o9VngNQ25uwc7vzj3+MZnQnZqoF/+ncYfYY/+pgojNHoC2l
         4ozyN7asFZAvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gerd Rausch <gerd.rausch@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: [PATCH AUTOSEL 4.9 3/3] net/rds: dma_map_sg is entitled to merge entries
Date:   Mon, 23 Aug 2021 20:55:39 -0400
Message-Id: <20210824005539.631820-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005539.631820-1-sashal@kernel.org>
References: <20210824005539.631820-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gerd Rausch <gerd.rausch@oracle.com>

[ Upstream commit fb4b1373dcab086d0619c29310f0466a0b2ceb8a ]

Function "dma_map_sg" is entitled to merge adjacent entries
and return a value smaller than what was passed as "nents".

Subsequently "ib_map_mr_sg" needs to work with this value ("sg_dma_len")
rather than the original "nents" parameter ("sg_len").

This old RDS bug was exposed and reliably causes kernel panics
(using RDMA operations "rds-stress -D") on x86_64 starting with:
commit c588072bba6b ("iommu/vt-d: Convert intel iommu driver to the iommu ops")

Simply put: Linux 5.11 and later.

Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Link: https://lore.kernel.org/r/60efc69f-1f35-529d-a7ef-da0549cad143@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/ib_frmr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
index 3d9c4c6397c3..20d045faf07c 100644
--- a/net/rds/ib_frmr.c
+++ b/net/rds/ib_frmr.c
@@ -112,9 +112,9 @@ static int rds_ib_post_reg_frmr(struct rds_ib_mr *ibmr)
 		cpu_relax();
 	}
 
-	ret = ib_map_mr_sg_zbva(frmr->mr, ibmr->sg, ibmr->sg_len,
+	ret = ib_map_mr_sg_zbva(frmr->mr, ibmr->sg, ibmr->sg_dma_len,
 				&off, PAGE_SIZE);
-	if (unlikely(ret != ibmr->sg_len))
+	if (unlikely(ret != ibmr->sg_dma_len))
 		return ret < 0 ? ret : -EINVAL;
 
 	/* Perform a WR for the fast_reg_mr. Each individual page
-- 
2.30.2

