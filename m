Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867EE41B833
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 22:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242704AbhI1UPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 16:15:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232756AbhI1UPL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 16:15:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4177C601FC;
        Tue, 28 Sep 2021 20:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632860011;
        bh=po+9kYDDgjfbfvvYQ07OcmfQEVl4eYh+maNs0aRKbX8=;
        h=Date:From:To:Cc:Subject:From;
        b=bA+3AIRTcidhuvV1nYj45uxbCWRdRX6cpp+ty9s7D9DcO0rrdFyFelzsNjgPVrJgw
         JouZu5y8kogDClaJO7PWZh2sex67nJZraAy7LiQvVmBK0/lkZ8K0uARxyO48DKfzKe
         tC4nKUVaLKfmbZgkeQDrpY8NT9TGZWQv4yYcQUXv/T3iD5cQlrl6xNniJlF7yW1LRJ
         oLC9w4AdvzbNyoVso4kWJnR0sedTowyv4jJoWWlAxWH3SPq18hZ6G9cGEZlq+yvy87
         zKeDpgje6hhv8yXB7+wDZZFTekimUYHMbUtmBMakjMmn/3KEyf0vO2Y8BYfxRdB0Ii
         4tMJu168f8oSw==
Date:   Tue, 28 Sep 2021 15:17:33 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][net-next] net/mlx4: Use array_size() helper in copy_to_user()
Message-ID: <20210928201733.GA268467@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use array_size() helper instead of the open-coded version in
copy_to_user(). These sorts of multiplication factors need
to be wrapped in array_size().

Link: https://github.com/KSPP/linux/issues/160
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/cq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cq.c b/drivers/net/ethernet/mellanox/mlx4/cq.c
index f7053a74e6a8..4d4f9cf9facb 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cq.c
@@ -314,7 +314,8 @@ static int mlx4_init_user_cqes(void *buf, int entries, int cqe_size)
 			buf += PAGE_SIZE;
 		}
 	} else {
-		err = copy_to_user((void __user *)buf, init_ents, entries * cqe_size) ?
+		err = copy_to_user((void __user *)buf, init_ents,
+				   array_size(entries, cqe_size)) ?
 			-EFAULT : 0;
 	}
 
-- 
2.27.0

