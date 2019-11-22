Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52F99106188
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 06:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbfKVF5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 00:57:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:35646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728824AbfKVF5V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:57:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E12D120731;
        Fri, 22 Nov 2019 05:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402240;
        bh=lm4JUrKaHoWWUev9vI4Y+B/zYy7vn/Rm5z1uWi8gAJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gKt5I9WYsn3i+q4pyOoR/dtDFrvcLse/HyoMkxe5E76RDFiv5OhW4od4KgJ38SsME
         CQbnXybeyKDxzOybVBjPrPBxcCCsqa5qVI3/4261GFI5nqr9N1IJHC+CGxEFBuWDXu
         U3qHt2zz88LKqRtkiO3jLISUlksSSAumRKGvqofM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kangjie Lu <kjlu@umn.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 085/127] net: (cpts) fix a missing check of clk_prepare
Date:   Fri, 22 Nov 2019 00:55:03 -0500
Message-Id: <20191122055544.3299-84-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kangjie Lu <kjlu@umn.edu>

[ Upstream commit 2d822f2dbab7f4c820f72eb8570aacf3f35855bd ]

clk_prepare() could fail, so let's check its status, and if it fails,
return its error code upstream.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/cpts.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index e7b76f6b4f67e..7d1281d812480 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -567,7 +567,9 @@ struct cpts *cpts_create(struct device *dev, void __iomem *regs,
 		return ERR_PTR(PTR_ERR(cpts->refclk));
 	}
 
-	clk_prepare(cpts->refclk);
+	ret = clk_prepare(cpts->refclk);
+	if (ret)
+		return ERR_PTR(ret);
 
 	cpts->cc.read = cpts_systim_read;
 	cpts->cc.mask = CLOCKSOURCE_MASK(32);
-- 
2.20.1

