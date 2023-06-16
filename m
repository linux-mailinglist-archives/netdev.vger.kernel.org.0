Return-Path: <netdev+bounces-11592-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CA40733A8D
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:12:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCAD4280105
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:12:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9921C1F953;
	Fri, 16 Jun 2023 20:11:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FE61F160
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B4AC433C8;
	Fri, 16 Jun 2023 20:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686946294;
	bh=CcX6qRmb5g12bOWJNVADnakV12BvDSZ6higU3LGoIvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aGbf3lTM+XcO5+F61e6yX3SDl9rlSsFjelEF9Q+fccEiWcGKc64v5Lfw0QovPgsMu
	 fbO8cmRkvRVt269mLrRONo+zK6qYepPJgO7w/xnoEvB/WZhIEhddjVONIsOcw4fJZT
	 Xx94KuZeKyAvHxLsogV1POYxBlXCMMZcHx2CTEuuAwOc0jq3fXA5+2QYRJ2OZAtdLo
	 h1FntScFqed7dyGClMXFSurAxTqihbU+taZEkPY6U0L5KWZ6PCtikZjztelNx5uuu6
	 isjeF4xZ+bb/j3oLNMha5NKEB9o6vBkGVIowc5/eMxcwgCcLxkhSjPJ0YlQbyJ7F8J
	 BF0lhUYTI+hjw==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>
Subject: [net-next 03/15] net/mlx5: Check DTOR entry value is not zero
Date: Fri, 16 Jun 2023 13:11:01 -0700
Message-Id: <20230616201113.45510-4-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230616201113.45510-1-saeed@kernel.org>
References: <20230616201113.45510-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Moshe Shemesh <moshe@nvidia.com>

The Default Timeout Register (DTOR) provides timeout values to driver
for flows that are device dependent. Zero value for DTOR entry is not
valid and should not be used. In case of reading zero value from DTOR,
the driver should use the hard coded SW default value instead.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c
index a87d0178ebf3..e223e0e46433 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c
@@ -119,7 +119,8 @@ u64 _mlx5_tout_ms(struct mlx5_core_dev *dev, enum mlx5_timeouts_types type)
 #define MLX5_TIMEOUT_FILL(fld, reg_out, dev, to_type, to_extra) \
 	({ \
 	u64 fw_to = MLX5_TIMEOUT_QUERY(fld, reg_out); \
-	tout_set(dev, fw_to + (to_extra), to_type); \
+	if (fw_to) \
+		tout_set(dev, fw_to + (to_extra), to_type); \
 	fw_to; \
 	})
 
-- 
2.40.1


