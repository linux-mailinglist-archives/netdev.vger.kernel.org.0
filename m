Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED6B39A7D2
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbhFCRMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:12:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231790AbhFCRL5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:11:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 850D7613F4;
        Thu,  3 Jun 2021 17:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740194;
        bh=DyPufrIQO7Oz9T/tZb14Y2MiwNFdBpCWs46Swdsf2ZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OHCT0UHAYSrThK/51TwBug+/TM+vsCC4ncJOMC9GKEeK3/LywX+B4cdTDa9wMdH2I
         3YcdLAufa0s0vpHLlZwAxrMdzxgVrXrVOkFDWSxRkcKOsCoc7VhXJh8IXGp8x+yTTV
         sWMJ8NA/K7luj+jv7NEGK6dZxQoKS4TtbeEziQzfrT9aRJkf7YGGCUqVfDI1ZrG7fb
         fs+m2tk4Picy2OoJjqjUVG4z4w+11yIxZNodMwllOLo4dsRyc03SqWivLfNktokmTU
         CSgRVwWzRzWsZneZci2TitY5xohVa0mXTBCVR03MrDeq50KVezXYiu1IA0ubnVTold
         HNHJwHX3T30BQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 28/31] bnx2x: Fix missing error code in bnx2x_iov_init_one()
Date:   Thu,  3 Jun 2021 13:09:16 -0400
Message-Id: <20210603170919.3169112-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170919.3169112-1-sashal@kernel.org>
References: <20210603170919.3169112-1-sashal@kernel.org>
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
index 5097a44686b3..cf39623b828b 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -1245,8 +1245,10 @@ int bnx2x_iov_init_one(struct bnx2x *bp, int int_mode_param,
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

