Return-Path: <netdev+bounces-11600-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4F6E733A97
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:15:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22BFA1C210A1
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:15:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B47421CCC;
	Fri, 16 Jun 2023 20:11:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5803C2108C
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCADC4160E;
	Fri, 16 Jun 2023 20:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686946305;
	bh=wlU8xINgfDVQY+Ph7pJ7SYid0sXAGePWuq8znapg5aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vkl8G5+NDmZ4Z1mYeRFch862Eak3O8dfN6n+UqsL/1ksePJADjf6alqAyZHaqAfrB
	 WRNLuAHuDDlDkRgC2fU3oHhAM+Y2Fx82iIb3v9OojsRMgNAq3cPYtCfVGcJTjV78K/
	 17Az2ll0Pc10ITn8pkrknpVFeIr5xJLd6fk2mOFQagWzC4ywpCjQTqKk7OgU2lDinx
	 rPNMhFtnubBp7k1cFJpBiXHO2OCSx4vsd1G1Pu45tH6jmR9EN4sbhmoaO6RgbPnl2u
	 nNh0spQRM05icFTMC+EVxaCtV/NeHoTJUMF04pFWoJeWSHD65xoYN/1LL6g41mCIJV
	 QeQZkBdwsXNxw==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Or Har-Toov <ohartoov@nvidia.com>,
	Avihai Horon <avihaih@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: [net-next 11/15] net/mlx5e: Add local loopback counter to vport stats
Date: Fri, 16 Jun 2023 13:11:09 -0700
Message-Id: <20230616201113.45510-12-saeed@kernel.org>
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

From: Or Har-Toov <ohartoov@nvidia.com>

Add counter for number of unicast, multicast and broadcast packets/
octets that were loopback.

Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Avihai Horon <avihaih@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/counters.rst       | 10 ++++++++
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 23 ++++++++++++++++++-
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/counters.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/counters.rst
index 6b2d1fe74ecf..a395df9c2751 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/counters.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/counters.rst
@@ -797,6 +797,16 @@ Counters on the NIC port that is connected to a eSwitch.
        RoCE/UD/RC traffic) [#accel]_.
      - Acceleration
 
+   * - `vport_loopback_packets`
+     - Unicast, multicast and broadcast packets that were loop-back (received
+       and transmitted), IB/Eth  [#accel]_.
+     - Acceleration
+
+   * - `vport_loopback_bytes`
+     - Unicast, multicast and broadcast bytes that were loop-back (received
+       and transmitted), IB/Eth  [#accel]_.
+     - Acceleration
+
    * - `rx_steer_missed_packets`
      - Number of packets that was received by the NIC, however was discarded
        because it did not match any flow in the NIC flow table.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index f1d9596905c6..25a6c596300d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -748,11 +748,22 @@ static const struct counter_desc vport_stats_desc[] = {
 		VPORT_COUNTER_OFF(transmitted_ib_multicast.octets) },
 };
 
+static const struct counter_desc vport_loopback_stats_desc[] = {
+	{ "vport_loopback_packets",
+		VPORT_COUNTER_OFF(local_loopback.packets) },
+	{ "vport_loopback_bytes",
+		VPORT_COUNTER_OFF(local_loopback.octets) },
+};
+
 #define NUM_VPORT_COUNTERS		ARRAY_SIZE(vport_stats_desc)
+#define NUM_VPORT_LOOPBACK_COUNTERS(dev) \
+	(MLX5_CAP_GEN(dev, vport_counter_local_loopback) ? \
+	 ARRAY_SIZE(vport_loopback_stats_desc) : 0)
 
 static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(vport)
 {
-	return NUM_VPORT_COUNTERS;
+	return NUM_VPORT_COUNTERS +
+		NUM_VPORT_LOOPBACK_COUNTERS(priv->mdev);
 }
 
 static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(vport)
@@ -761,6 +772,11 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(vport)
 
 	for (i = 0; i < NUM_VPORT_COUNTERS; i++)
 		strcpy(data + (idx++) * ETH_GSTRING_LEN, vport_stats_desc[i].format);
+
+	for (i = 0; i < NUM_VPORT_LOOPBACK_COUNTERS(priv->mdev); i++)
+		strcpy(data + (idx++) * ETH_GSTRING_LEN,
+		       vport_loopback_stats_desc[i].format);
+
 	return idx;
 }
 
@@ -771,6 +787,11 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(vport)
 	for (i = 0; i < NUM_VPORT_COUNTERS; i++)
 		data[idx++] = MLX5E_READ_CTR64_BE(priv->stats.vport.query_vport_out,
 						  vport_stats_desc, i);
+
+	for (i = 0; i < NUM_VPORT_LOOPBACK_COUNTERS(priv->mdev); i++)
+		data[idx++] = MLX5E_READ_CTR64_BE(priv->stats.vport.query_vport_out,
+						  vport_loopback_stats_desc, i);
+
 	return idx;
 }
 
-- 
2.40.1


