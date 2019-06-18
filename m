Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09B7D4A806
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730053AbfFRRQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:16:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728572AbfFRRQA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 13:16:00 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 978E020B1F;
        Tue, 18 Jun 2019 17:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560878159;
        bh=hHJn+EwBV2dBJUe9VVfHTe5a7cdACQwbjVLR1tbht4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q6KCIbm1mc5nDYZzniAPtiBP03gdLle3Pyt62tA+UTzWy3Fx7lL4YA7xUZyy1ipbW
         0Ll3yR/DXvFUh0gWg6GYKGZNH05q1PkwmxCIcQncxGIvwee+g5/YttR930X+C2tiLr
         zB+sw79rEw7WFOxeDC4mZ7QTaBYto6AXz7qLOPow=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next v1 05/12] net/mlx5: Report a CQ error event only when a handler was set
Date:   Tue, 18 Jun 2019 20:15:33 +0300
Message-Id: <20190618171540.11729-6-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190618171540.11729-1-leon@kernel.org>
References: <20190618171540.11729-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Report a CQ error event only when a handler was set.

This enables mlx5_ib to not set a handler upon CQ creation and use some
other mechanism to get this event as of other events by the
mlx5_eq_notifier_register API.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index a7a8bf73e465..316fbed81470 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -503,7 +503,8 @@ static int cq_err_event_notifier(struct notifier_block *nb,
 		return NOTIFY_OK;
 	}
 
-	cq->event(cq, type);
+	if (cq->event)
+		cq->event(cq, type);
 
 	mlx5_cq_put(cq);
 
-- 
2.20.1

