Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B7F39A87D
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbhFCRQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:16:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233280AbhFCROG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:14:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B89866141E;
        Thu,  3 Jun 2021 17:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740249;
        bh=QdZB6oaUzPkhXXzrrTSLwMqnHrdiW2LbpnlzOJ4ai/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h088/jity6Z/bzm7Dfhc3mL2LU8m4jy/83lWdTrrGP5Kwt3aafou7LiAmdHUIAFjZ
         8PtxY9I/iqJkTxohXjY6dw4JbD1GnvzpYDTUu/WDEj7etmxnylO8EPfx5QK4miQXeA
         heKiUpPR0x+1riqocbzWyl72NGfdr7/q4OtjyFmw7SitvH9mbPlEIkgq6YYr6kGn4R
         TBC6R8CLBl1Tkl2wMFT38atH5zxYUh8PrKzin9fJGixgNnNvVZdxJg3vOVnUZPTiXI
         W1SlTjtNEoqmJOvUsJM/J/qb73NqAdEcBXh31ajWZpTYuKDJiDbNE1CinkZQ6vWw3i
         LdQB2KPFxz9Pg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 16/18] bnx2x: Fix missing error code in bnx2x_iov_init_one()
Date:   Thu,  3 Jun 2021 13:10:27 -0400
Message-Id: <20210603171029.3169669-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603171029.3169669-1-sashal@kernel.org>
References: <20210603171029.3169669-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit 65161c35554f7135e6656b3df1ce2c500ca0bdcf ]

Eliminate the follow smatch warning:

drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c:1227
bnx2x_iov_init_one() warn: missing error code 'err'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
index 1977e0c552df..e4d1aaf838a4 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -1242,8 +1242,10 @@ int bnx2x_iov_init_one(struct bnx2x *bp, int int_mode_param,
 		goto failed;
 
 	/* SR-IOV capability was enabled but there are no VFs*/
-	if (iov->total == 0)
+	if (iov->total == 0) {
+		err = -EINVAL;
 		goto failed;
+	}
 
 	iov->nr_virtfn = min_t(u16, iov->total, num_vfs_param);
 
-- 
2.30.2

