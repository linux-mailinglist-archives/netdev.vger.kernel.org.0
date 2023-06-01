Return-Path: <netdev+bounces-7010-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15E077192F7
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:06:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4A79280E80
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 06:06:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BD7819E78;
	Thu,  1 Jun 2023 06:01:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA461801B
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 06:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70ED6C433A8;
	Thu,  1 Jun 2023 06:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685599307;
	bh=8vqUbKUiaG/ypku0ewaamstXgI6GIEicqfAkF1Wo1c0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lpeRaPcagbVcYnqenPF8T7yz8S4u+G59S2m+MZjnmJZYAiZw8+C5lL5Q9TUflNl7g
	 HeLfyHlupimYFN3GxuIcHO5gXf39ZJmNKGJPqf4c+NJwEc+041Osbu4lbtVV3IeUh9
	 9GZALkhOfGeS/ZAYEPGm8pQRM6hbUp57Ji5gIKVnBlo11aBBWzS6wpaIpMxRHd9PVa
	 U2vnfn1nuqO1Xxh+rhJbP4Dsep7jUvFNydECWeXGbde9qXSgji8oaVszsDfUlkMaww
	 8hFjID+Y4qbgmrh2BmeOr4Aolnk1/m2wGbFk7AM1iwF7REFdwKXQ/2727p8XhrdNZh
	 N+YUhmwqHJ1Ag==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Roi Dayan <roid@nvidia.com>
Subject: [net-next 14/14] net/mlx5: Devcom, extend mlx5_devcom_send_event to work with more than two devices
Date: Wed, 31 May 2023 23:01:18 -0700
Message-Id: <20230601060118.154015-15-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601060118.154015-1-saeed@kernel.org>
References: <20230601060118.154015-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

mlx5_devcom_send_event is used to send event from one eswitch to the
other. In other words, only one event is sent, which means, no error
mechanism is needed.
However, In case devcom have more than two eswitches, a proper error
mechanism is needed. Hence, in case of error, devcom will perform the
error unwind, since devcom knows how many events were successful.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c       |  4 +++-
 .../ethernet/mellanox/mlx5/core/lib/devcom.c    | 17 +++++++++++++++--
 .../ethernet/mellanox/mlx5/core/lib/devcom.h    |  2 +-
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 09367a320741..29de4e759f4f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2892,7 +2892,8 @@ void mlx5_esw_offloads_devcom_init(struct mlx5_eswitch *esw)
 	esw->num_peers = 0;
 	mlx5_devcom_send_event(devcom,
 			       MLX5_DEVCOM_ESW_OFFLOADS,
-			       ESW_OFFLOADS_DEVCOM_PAIR, esw);
+			       ESW_OFFLOADS_DEVCOM_PAIR,
+			       ESW_OFFLOADS_DEVCOM_UNPAIR, esw);
 }
 
 void mlx5_esw_offloads_devcom_cleanup(struct mlx5_eswitch *esw)
@@ -2906,6 +2907,7 @@ void mlx5_esw_offloads_devcom_cleanup(struct mlx5_eswitch *esw)
 		return;
 
 	mlx5_devcom_send_event(devcom, MLX5_DEVCOM_ESW_OFFLOADS,
+			       ESW_OFFLOADS_DEVCOM_UNPAIR,
 			       ESW_OFFLOADS_DEVCOM_UNPAIR, esw);
 
 	mlx5_devcom_unregister_component(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
index 96a3b7b9a5cd..8472bbb3cd58 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
@@ -193,7 +193,7 @@ void mlx5_devcom_unregister_component(struct mlx5_devcom *devcom,
 
 int mlx5_devcom_send_event(struct mlx5_devcom *devcom,
 			   enum mlx5_devcom_components id,
-			   int event,
+			   int event, int rollback_event,
 			   void *event_data)
 {
 	struct mlx5_devcom_component *comp;
@@ -210,10 +210,23 @@ int mlx5_devcom_send_event(struct mlx5_devcom *devcom,
 
 		if (i != devcom->idx && data) {
 			err = comp->handler(event, data, event_data);
-			break;
+			if (err)
+				goto rollback;
 		}
 	}
 
+	up_write(&comp->sem);
+	return 0;
+
+rollback:
+	while (i--) {
+		void *data = rcu_dereference_protected(comp->device[i].data,
+						       lockdep_is_held(&comp->sem));
+
+		if (i != devcom->idx && data)
+			comp->handler(rollback_event, data, event_data);
+	}
+
 	up_write(&comp->sem);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.h
index b7f72f1a5367..bb1970ba8730 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.h
@@ -30,7 +30,7 @@ void mlx5_devcom_unregister_component(struct mlx5_devcom *devcom,
 
 int mlx5_devcom_send_event(struct mlx5_devcom *devcom,
 			   enum mlx5_devcom_components id,
-			   int event,
+			   int event, int rollback_event,
 			   void *event_data);
 
 void mlx5_devcom_comp_set_ready(struct mlx5_devcom *devcom,
-- 
2.40.1


