Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9677C3F5516
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 02:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235391AbhHXA7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 20:59:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233971AbhHXA5N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 20:57:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 837AD61528;
        Tue, 24 Aug 2021 00:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766538;
        bh=vSW7KQeakcHYXjDc8nLEj/T4IT9NFEEg150K6geatiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AWYwwwlI7wN5i5SgYifBxQf6jB6Jd19hw27Xs06k8tfDirtROG1TjNdOt+7RG7Gl5
         bDejjHLLdxqHoWYXhagKhYXoj/BKWt9UUvTGdzVZsuMFG/ygVqH2AkxjtviqePq3TZ
         nxAAgQfXYweOJiMPKKR5hmL0TcjjiDcJAmcWJrRVOuTcjtTf9EEZnRbJUPU+yEQU9E
         r7UdBsoGaiQAOiel1RiSEtFVeSM2ipc6zf8Kz8eYi5/d/SesdYwdY3p8RIDLh9AJ3P
         SFidTef10nRQ5lX/FwGS/TRjn5uUJ+BOz8JgUYcn25nPwNKTvzXM3OKvrj7XvVO0BP
         dc2LRqwSbooBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gerd Rausch <gerd.rausch@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: [PATCH AUTOSEL 4.14 7/7] net/rds: dma_map_sg is entitled to merge entries
Date:   Mon, 23 Aug 2021 20:55:28 -0400
Message-Id: <20210824005528.631702-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005528.631702-1-sashal@kernel.org>
References: <20210824005528.631702-1-sashal@kernel.org>
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
index d290416e79e9..9fd550d4116c 100644
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

