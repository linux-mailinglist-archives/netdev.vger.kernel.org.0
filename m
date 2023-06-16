Return-Path: <netdev+bounces-11590-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5314F733A87
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:11:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84DFA1C20B5D
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:11:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB9A21F198;
	Fri, 16 Jun 2023 20:11:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1991F160
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:11:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35DBC433C9;
	Fri, 16 Jun 2023 20:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686946292;
	bh=CB44sEKks9tGKIk+7evSULJHCZ6qOmwE8fELbhzovWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onTgqQgxyWEAbU6WruYYaowwqGQCC8iuA6wfi/6BpJiFEBw+Eb1FJLqrR/KzAh/ja
	 3DkdjafFHKgxZobHG5W12bukZMx6Zjp9QHXTBW+yAjDBVAcu238RcTU3edrEfVJtEC
	 VskR/eAZdewwHqOGlqpY2ADLcatTS68imbEFik9M7q3lvJxHujwxZ3GH2fYNbh2SaA
	 L2pTlA5zjG1V9VPtE6XWRaili09RcFITZr+J9wLAe+1WgnmFz4ZOOe8LSrY9myYjkH
	 dnPV6GChf1eI1N1xf08P1I9u/uYY6dC8JOIrmeXeigmmY/nzFb76UXhvckP3epz74v
	 oP1Ta+No6/RmQ==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Shay Drory <shayd@nvidia.com>
Subject: [net-next 01/15] net/mlx5: Ack on sync_reset_request only if PF can do reset_now
Date: Fri, 16 Jun 2023 13:10:59 -0700
Message-Id: <20230616201113.45510-2-saeed@kernel.org>
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

Verify at reset_request stage that PF is capable to do reset_now. In
case PF is not capable, notify the firmware that the sync reset can not
happen and so firmware will abort the sync reset at early stage and will
not send reset_now event to any PF.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 57 ++++++++++++++-----
 1 file changed, 44 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 50022e7565f1..952cc340b510 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -276,6 +276,44 @@ static void mlx5_fw_live_patch_event(struct work_struct *work)
 		mlx5_core_err(dev, "Failed to reload FW tracer\n");
 }
 
+static int mlx5_check_dev_ids(struct mlx5_core_dev *dev, u16 dev_id)
+{
+	struct pci_bus *bridge_bus = dev->pdev->bus;
+	struct pci_dev *sdev;
+	u16 sdev_id;
+	int err;
+
+	/* Check that all functions under the pci bridge are PFs of
+	 * this device otherwise fail this function.
+	 */
+	list_for_each_entry(sdev, &bridge_bus->devices, bus_list) {
+		err = pci_read_config_word(sdev, PCI_DEVICE_ID, &sdev_id);
+		if (err)
+			return err;
+		if (sdev_id != dev_id) {
+			mlx5_core_warn(dev, "unrecognized dev_id (0x%x)\n", sdev_id);
+			return -EPERM;
+		}
+	}
+	return 0;
+}
+
+static bool mlx5_is_reset_now_capable(struct mlx5_core_dev *dev)
+{
+	u16 dev_id;
+	int err;
+
+	if (!MLX5_CAP_GEN(dev, fast_teardown)) {
+		mlx5_core_warn(dev, "fast teardown is not supported by firmware\n");
+		return -EOPNOTSUPP;
+	}
+
+	err = pci_read_config_word(dev->pdev, PCI_DEVICE_ID, &dev_id);
+	if (err)
+		return false;
+	return (!mlx5_check_dev_ids(dev, dev_id));
+}
+
 static void mlx5_sync_reset_request_event(struct work_struct *work)
 {
 	struct mlx5_fw_reset *fw_reset = container_of(work, struct mlx5_fw_reset,
@@ -283,7 +321,8 @@ static void mlx5_sync_reset_request_event(struct work_struct *work)
 	struct mlx5_core_dev *dev = fw_reset->dev;
 	int err;
 
-	if (test_bit(MLX5_FW_RESET_FLAGS_NACK_RESET_REQUEST, &fw_reset->reset_flags)) {
+	if (test_bit(MLX5_FW_RESET_FLAGS_NACK_RESET_REQUEST, &fw_reset->reset_flags) ||
+	    !mlx5_is_reset_now_capable(dev)) {
 		err = mlx5_fw_reset_set_reset_sync_nack(dev);
 		mlx5_core_warn(dev, "PCI Sync FW Update Reset Nack %s",
 			       err ? "Failed" : "Sent");
@@ -303,26 +342,18 @@ static int mlx5_pci_link_toggle(struct mlx5_core_dev *dev)
 {
 	struct pci_bus *bridge_bus = dev->pdev->bus;
 	struct pci_dev *bridge = bridge_bus->self;
-	u16 reg16, dev_id, sdev_id;
 	unsigned long timeout;
 	struct pci_dev *sdev;
+	u16 reg16, dev_id;
 	int cap, err;
 	u32 reg32;
 
-	/* Check that all functions under the pci bridge are PFs of
-	 * this device otherwise fail this function.
-	 */
 	err = pci_read_config_word(dev->pdev, PCI_DEVICE_ID, &dev_id);
 	if (err)
 		return err;
-	list_for_each_entry(sdev, &bridge_bus->devices, bus_list) {
-		err = pci_read_config_word(sdev, PCI_DEVICE_ID, &sdev_id);
-		if (err)
-			return err;
-		if (sdev_id != dev_id)
-			return -EPERM;
-	}
-
+	err = mlx5_check_dev_ids(dev, dev_id);
+	if (err)
+		return err;
 	cap = pci_find_capability(bridge, PCI_CAP_ID_EXP);
 	if (!cap)
 		return -EOPNOTSUPP;
-- 
2.40.1


