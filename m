Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7593F3F54AB
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 02:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbhHXA4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 20:56:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233804AbhHXAzR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 20:55:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22DFE61501;
        Tue, 24 Aug 2021 00:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766470;
        bh=mhnDZFp6Bvgo7d3AsSNxcg0qsh7TMyBGCIQMQVcAJ2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gygA7mGNIvTcJTmQRj1+Nu4k6TORBRbN1DtYPNh0mgiKrSC0kOmIS2bpJklBokda/
         Xe/Z9IWoVR9orgPuRHxzTyJ+hlc4jiDgBDE8/moGNchnTg15LWXILOcixLqoTHhVzT
         ve9CTtIW3Zo4p9VRB+LJcErKwOtS1N1wFyVkavn1gV5eUQiGHjdmFkcNU20ANrbuDt
         w9/K2KjcicjNwvBaz4/u1WVTAdyIz/aVzjY9U5NJdPx8nZUXiIUn9/o/dkdNEP/ycX
         o9XrIeSSPDKW+q2UBR90qBBvJXzVGhF7yD6F9l/Ct+CEhmSpyBJw67MFUXEY3HnfzN
         Wb5mdD3OkoLzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gerd Rausch <gerd.rausch@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: [PATCH AUTOSEL 5.13 25/26] net/rds: dma_map_sg is entitled to merge entries
Date:   Mon, 23 Aug 2021 20:53:55 -0400
Message-Id: <20210824005356.630888-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005356.630888-1-sashal@kernel.org>
References: <20210824005356.630888-1-sashal@kernel.org>
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
index 9b6ffff72f2d..28c1b0022178 100644
--- a/net/rds/ib_frmr.c
+++ b/net/rds/ib_frmr.c
@@ -131,9 +131,9 @@ static int rds_ib_post_reg_frmr(struct rds_ib_mr *ibmr)
 		cpu_relax();
 	}
 
-	ret = ib_map_mr_sg_zbva(frmr->mr, ibmr->sg, ibmr->sg_len,
+	ret = ib_map_mr_sg_zbva(frmr->mr, ibmr->sg, ibmr->sg_dma_len,
 				&off, PAGE_SIZE);
-	if (unlikely(ret != ibmr->sg_len))
+	if (unlikely(ret != ibmr->sg_dma_len))
 		return ret < 0 ? ret : -EINVAL;
 
 	if (cmpxchg(&frmr->fr_state,
-- 
2.30.2

