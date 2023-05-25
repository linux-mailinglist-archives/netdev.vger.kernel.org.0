Return-Path: <netdev+bounces-5204-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D4897710372
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:50:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 978BC1C202ED
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 03:50:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FF951FC6;
	Thu, 25 May 2023 03:49:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE743C17
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 03:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABFAFC433D2;
	Thu, 25 May 2023 03:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684986542;
	bh=ee/w79+1R96hRYK+RsSUuNsiH1ATTvJYML7vf4Sdba4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bvbgQVgFJli9sKoVAyYYZ+cpKKF6/eYkBbBUlzUWpUJZ/X+fhW1z+G2f1/UCqJXDe
	 fbVFrLk5wmNebhBLTgF1hctQ9ns44R9gPQ6xhOX/uJ4vd1oKJUbDvmpemI2IluENYp
	 wy0UBmysuzkIbLoAv6CXYxvor1DO77pdn3qoanDaElbSV1Dfy3fehLPF4G09NVKlKZ
	 Gt67mu9nIBLZ5RczmvOCZeVaXcnXC0QucQC15RB//397xDf/8FxPhYMxbPa3V5VJJT
	 AlcJtcLxu1f5y1UmPZ58n4SdCNTqqH5njuwbq7RsjOX8iAXXwHSm6JbxZOBpbVNI8z
	 EBBcP5Tanm5Tg==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>
Subject: [net 04/17] net/mlx5e: Do not update SBCM when prio2buffer command is invalid
Date: Wed, 24 May 2023 20:48:34 -0700
Message-Id: <20230525034847.99268-5-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230525034847.99268-1-saeed@kernel.org>
References: <20230525034847.99268-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Maher Sanalla <msanalla@nvidia.com>

The shared buffer pools configuration which are stored in the SBCM
register are updated when the user changes the prio2buffer mapping.

However, in case the user desired prio2buffer change is invalid,
which can occur due to mapping a lossless priority to a not large enough
buffer, the SBCM update should not be performed, as the user command is
failed.

Thus, Perform the SBCM update only after xoff threshold calculation is
performed and the user prio2buffer mapping is validated.

Fixes: a440030d8946 ("net/mlx5e: Update shared buffer along with device buffer changes")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
index 0d78527451bc..7e8e96cc5cd0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
@@ -442,11 +442,11 @@ static int update_buffer_lossy(struct mlx5_core_dev *mdev,
 	}
 
 	if (changed) {
-		err = port_update_pool_cfg(mdev, port_buffer);
+		err = update_xoff_threshold(port_buffer, xoff, max_mtu, port_buff_cell_sz);
 		if (err)
 			return err;
 
-		err = update_xoff_threshold(port_buffer, xoff, max_mtu, port_buff_cell_sz);
+		err = port_update_pool_cfg(mdev, port_buffer);
 		if (err)
 			return err;
 
-- 
2.40.1


