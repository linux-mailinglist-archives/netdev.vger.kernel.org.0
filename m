Return-Path: <netdev+bounces-4544-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D74F70D34C
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:46:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08019281265
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:46:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 168391D2CE;
	Tue, 23 May 2023 05:43:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5861C742
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:43:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC62C4339B;
	Tue, 23 May 2023 05:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684820583;
	bh=L9FcmO7N4WztrKgBaZu1Spra/oSXx3vkOL6v8cokFH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sl+JuFaaZ5+F5ho0Yvt/+LzHZ71Ce+lJsk0kzJZZi3XdsHs/wrFmNS3gvGXAc3+dK
	 Mdy6+5Im34BTB2u5pjNriYeC97mbnYC9CnsexsOHr+xVEn8ihvEPIbSgyyiLgMY+Ub
	 gTvQZNJAmTJCcobr1VcOFFe31dA2FPITqlhzIuyHKt0Lotyqj7FYQcAmjEphw1pilR
	 b7oAZsgzQKlf6LSaLTyOUyjGzwiOKFaQfkUFArCCeICpcWX9jH3NLp6cKFaVbdq5EE
	 w0R4QS2ItD+mEO3Fr8llPGzqfefOqBebiZolIF7nWNmxK1Btoejo4WqZXTWY1S61OZ
	 8u5FM3UdUrOsg==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>
Subject: [net 10/15] net/mlx5: E-switch, Devcom, sync devcom events and devcom comp register
Date: Mon, 22 May 2023 22:42:37 -0700
Message-Id: <20230523054242.21596-11-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230523054242.21596-1-saeed@kernel.org>
References: <20230523054242.21596-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

devcom events are sent to all registered component. Following the
cited patch, it is possible for two components, e.g.: two eswitches,
to send devcom events, while both components are registered. This
means eswitch layer will do double un/pairing, which is double
allocation and free of resources, even though only one un/pairing is
needed. flow example:

	cpu0					cpu1
	----					----

 mlx5_devlink_eswitch_mode_set(dev0)
  esw_offloads_devcom_init()
   mlx5_devcom_register_component(esw0)
                                         mlx5_devlink_eswitch_mode_set(dev1)
                                          esw_offloads_devcom_init()
                                           mlx5_devcom_register_component(esw1)
                                           mlx5_devcom_send_event()
   mlx5_devcom_send_event()

Hence, check whether the eswitches are already un/paired before
free/allocation of resources.

Fixes: 09b278462f16 ("net: devlink: enable parallel ops on netlink interface")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h        | 1 +
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c   | 9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 9f007c5438ee..add6cfa432a5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -342,6 +342,7 @@ struct mlx5_eswitch {
 		u32             large_group_num;
 	}  params;
 	struct blocking_notifier_head n_head;
+	bool paired[MLX5_MAX_PORTS];
 };
 
 void esw_offloads_disable(struct mlx5_eswitch *esw);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 7c34c7cf506f..8d19c20d3447 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2742,6 +2742,9 @@ static int mlx5_esw_offloads_devcom_event(int event,
 		    mlx5_eswitch_vport_match_metadata_enabled(peer_esw))
 			break;
 
+		if (esw->paired[mlx5_get_dev_index(peer_esw->dev)])
+			break;
+
 		err = mlx5_esw_offloads_set_ns_peer(esw, peer_esw, true);
 		if (err)
 			goto err_out;
@@ -2753,14 +2756,18 @@ static int mlx5_esw_offloads_devcom_event(int event,
 		if (err)
 			goto err_pair;
 
+		esw->paired[mlx5_get_dev_index(peer_esw->dev)] = true;
+		peer_esw->paired[mlx5_get_dev_index(esw->dev)] = true;
 		mlx5_devcom_set_paired(devcom, MLX5_DEVCOM_ESW_OFFLOADS, true);
 		break;
 
 	case ESW_OFFLOADS_DEVCOM_UNPAIR:
-		if (!mlx5_devcom_is_paired(devcom, MLX5_DEVCOM_ESW_OFFLOADS))
+		if (!esw->paired[mlx5_get_dev_index(peer_esw->dev)])
 			break;
 
 		mlx5_devcom_set_paired(devcom, MLX5_DEVCOM_ESW_OFFLOADS, false);
+		esw->paired[mlx5_get_dev_index(peer_esw->dev)] = false;
+		peer_esw->paired[mlx5_get_dev_index(esw->dev)] = false;
 		mlx5_esw_offloads_unpair(peer_esw);
 		mlx5_esw_offloads_unpair(esw);
 		mlx5_esw_offloads_set_ns_peer(esw, peer_esw, false);
-- 
2.40.1


