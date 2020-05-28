Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07081E5FEB
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388881AbgE1L44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 07:56:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388597AbgE1L4x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 07:56:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 418B221532;
        Thu, 28 May 2020 11:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590667012;
        bh=yU3uM29KX3qFLteU6zpD378KlUSl1Mc08N73Woceycc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a6ge4CrTEIYrJ7qD97xRa3KK7UDes8xgBsvFkT5XZUjYJNT35wltX2SQh/IXgwt2m
         tJ1qRtFe5EK5g5GZtjRQTtpHFoEOtGk2zJ3DihgzRyFmRPsfOmKbPeLOl+gaoyLnhU
         Dhc2m0THhXt5/9bzfQEKvg9TBreNNBxZjwv4EwRU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiushi Wu <wu000273@umn.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 46/47] net/mlx4_core: fix a memory leak bug.
Date:   Thu, 28 May 2020 07:55:59 -0400
Message-Id: <20200528115600.1405808-46-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115600.1405808-1-sashal@kernel.org>
References: <20200528115600.1405808-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit febfd9d3c7f74063e8e630b15413ca91b567f963 ]

In function mlx4_opreq_action(), pointer "mailbox" is not released,
when mlx4_cmd_box() return and error, causing a memory leak bug.
Fix this issue by going to "out" label, mlx4_free_cmd_mailbox() can
free this pointer.

Fixes: fe6f700d6cbb ("net/mlx4_core: Respond to operation request by firmware")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index 6e501af0e532..f6ff9620a137 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -2734,7 +2734,7 @@ void mlx4_opreq_action(struct work_struct *work)
 		if (err) {
 			mlx4_err(dev, "Failed to retrieve required operation: %d\n",
 				 err);
-			return;
+			goto out;
 		}
 		MLX4_GET(modifier, outbox, GET_OP_REQ_MODIFIER_OFFSET);
 		MLX4_GET(token, outbox, GET_OP_REQ_TOKEN_OFFSET);
-- 
2.25.1

