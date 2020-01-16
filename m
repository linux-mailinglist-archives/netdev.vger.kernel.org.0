Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26C2F13F163
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404002AbgAPS2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:28:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:34598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392257AbgAPR0K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:26:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC923246AF;
        Thu, 16 Jan 2020 17:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195569;
        bh=8CbT8TZ2iRcbrH7EgaNzFCMgeHLem/RyTXHo5n0sxLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=upjhgeqTEa9I7f0z8fkDy5mN6KU0kX8OOM5/PdQQ8oSOnyK3jSXS+DOUlcMGt5+SY
         czR0qbT7StlaYVtU7VAJFtOR7QYjisPj2Zs64mOOvKSd2ef/eCjoxXoJMCL4sC6hO4
         QVvgJQ8IdAzO48Sn+LU0BassjTb47gIDim+ErO0Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Mukesh Ojha <mojha@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, dccp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 154/371] dccp: Fix memleak in __feat_register_sp
Date:   Thu, 16 Jan 2020 12:20:26 -0500
Message-Id: <20200116172403.18149-97-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 1d3ff0950e2b40dc861b1739029649d03f591820 ]

If dccp_feat_push_change fails, we forget free the mem
which is alloced by kmemdup in dccp_feat_clone_sp_val.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: e8ef967a54f4 ("dccp: Registration routines for changing feature values")
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dccp/feat.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/dccp/feat.c b/net/dccp/feat.c
index f227f002c73d..db87d9f58019 100644
--- a/net/dccp/feat.c
+++ b/net/dccp/feat.c
@@ -738,7 +738,12 @@ static int __feat_register_sp(struct list_head *fn, u8 feat, u8 is_local,
 	if (dccp_feat_clone_sp_val(&fval, sp_val, sp_len))
 		return -ENOMEM;
 
-	return dccp_feat_push_change(fn, feat, is_local, mandatory, &fval);
+	if (dccp_feat_push_change(fn, feat, is_local, mandatory, &fval)) {
+		kfree(fval.sp.vec);
+		return -ENOMEM;
+	}
+
+	return 0;
 }
 
 /**
-- 
2.20.1

