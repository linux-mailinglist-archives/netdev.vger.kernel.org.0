Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C063F39A8BA
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbhFCRRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:17:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233194AbhFCRPz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:15:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A27D56140F;
        Thu,  3 Jun 2021 17:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740271;
        bh=n85FqgfOtenKWulo8E9W9HJdxjk9cGbehpPr31pLajo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AM5yCBEAEGGkDcTgTO+dLWIF0KTmlbbZ+xgbnd+FuVjYMqRVLf8vplx7RCaX1uIHI
         3gqvfuFLcSvq/0h0KS9jZ+EsvMhWVAuAxkSPAgP+Z49GynBrcpDAiDiFBtdKrtTFzD
         SZMZDGwqMyIPgmCy5fFCve0KHqgg8lhv7QX5c/nEe9X1LZ3hM12kzADDczObRHM+Tr
         VZRp9NtQ7tyHuqebZ7tKMundVnl4egLRwheE1O+NCFlTC945TNpyIREx66DAg0shwu
         yXp1UnPkrMjplvf6FXPHqz/0uAPbbj2pybietKsvsOO/AxrFEPzZlZ6M8g8Qwsppjf
         mEdB7wpRBqmRw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 15/17] bnx2x: Fix missing error code in bnx2x_iov_init_one()
Date:   Thu,  3 Jun 2021 13:10:50 -0400
Message-Id: <20210603171052.3169893-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603171052.3169893-1-sashal@kernel.org>
References: <20210603171052.3169893-1-sashal@kernel.org>
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
index e8a09d0afe1c..545b59ff5d7e 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -1240,8 +1240,10 @@ int bnx2x_iov_init_one(struct bnx2x *bp, int int_mode_param,
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

