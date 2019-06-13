Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA6D44580
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404114AbfFMQoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:44:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730425AbfFMG07 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 02:26:59 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B6CA2084D;
        Thu, 13 Jun 2019 06:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560407218;
        bh=Bh3QU34HHdKBiVF2YQwTqAD0OhFrAl2rHrDhACFzOsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vAfdROr7h72ish/LsjZjIn5c5fyVNc2yeynJHCLphVsjOwppe4NS76R08vJGtrtcQ
         OUVsUX01OV8MBnCWIHy0rb43qiMMvK/LPK1S5v4Q9zRTFiKY4UuG0fRI4YYxRbwPAj
         ZSLm8xlhpdCIm+tKlhiB/s9hviKy/t1N1+ttK4uc=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 05/12] net/mlx5: Report a CQ error event only when a handler was set
Date:   Thu, 13 Jun 2019 09:26:33 +0300
Message-Id: <20190613062640.28958-6-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190613062640.28958-1-leon@kernel.org>
References: <20190613062640.28958-1-leon@kernel.org>
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
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 5971c1870e0d..c2a679657c34 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -494,7 +494,8 @@ static int cq_err_event_notifier(struct notifier_block *nb,
 		return NOTIFY_OK;
 	}
 
-	cq->event(cq, type);
+	if (cq->event)
+		cq->event(cq, type);
 
 	mlx5_cq_put(cq);
 
-- 
2.20.1

