Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0141E5B096
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 18:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfF3QX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 12:23:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbfF3QX6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 12:23:58 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FDB120828;
        Sun, 30 Jun 2019 16:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561911837;
        bh=OMnakVtvRGXI8xpRDl0AAsiJCT9IYcldsvHakL6wSvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3PEHBBDouITZz1kuF5JUQSX04r6u3HrOH4afl14iWxplyz4di3scjkq0Bg8TE1t2
         oXaj1eTGce8igixWD2uF3npoDyb6fPdZrVphlivSC7OKUC/YByOjqmGj9uQkE9rd+F
         NeM6HCvRpO3rESRSK2Wkbs2MQMDKae5K+LMXONvM=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next v2 05/13] net/mlx5: Report a CQ error event only when a handler was set
Date:   Sun, 30 Jun 2019 19:23:26 +0300
Message-Id: <20190630162334.22135-6-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190630162334.22135-1-leon@kernel.org>
References: <20190630162334.22135-1-leon@kernel.org>
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
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index c634a78d5cdd..678454535460 100644
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

