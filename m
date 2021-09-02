Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB33C3FF3CC
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 21:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347336AbhIBTHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 15:07:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347303AbhIBTHE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 15:07:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D03A610A0;
        Thu,  2 Sep 2021 19:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630609565;
        bh=wAdmOa1WcHmFTPJYkPiFDZPgYtyYeliL3NHPbcuH4CQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Di9x1DMuNJocclNjDsYyvcbnmopHrwfM1vzzhb/VlFgpEKZC9mt2h1cnIVx3hy9IC
         OnihTLcSGTu1OhilJFmBTr5SiZgEy1LoYI+NMK0GU6FxlPOrE7+2AQf49X5Rs1dcHP
         paUvEaJnuy+4dlodEbkQpgwOdyXPb88grLV4gzuB1CySN8c0ttRBV6no2UQL+Oqpdm
         1w2CibLkbCL3hr+bDnTIM0rVJ++dnrqPGyopqZ2mxa6ivWrs0dPFTMfkt1GO1G7F6W
         ke7Vwank7Vn0uKexHhkHJAUupwfhag5yIPrTkfCRLrPJHHYVB5LlPMfUxUlOkAAth0
         iP1iaEX6Tfnxg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Colin King <colin.king@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/15] net/mlx5: Bridge, fix uninitialized variable usage
Date:   Thu,  2 Sep 2021 12:05:42 -0700
Message-Id: <20210902190554.211497-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210902190554.211497-1-saeed@kernel.org>
References: <20210902190554.211497-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

In some conditions variable 'err' is not assigned with value in
mlx5_esw_bridge_port_obj_attr_set() and mlx5_esw_bridge_port_changeupper()
functions after recent changes to support LAG. Initialize the variable with
zero value in both cases.

Reported-by: Colin King <colin.king@canonical.com>
Reported-by: Tim Gardner <tim.gardner@canonical.com>
Fixes: ff9b7521468b ("net/mlx5: Bridge, support LAG")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index 0c38c2e319be..b5ddaa82755f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -137,7 +137,7 @@ static int mlx5_esw_bridge_port_changeupper(struct notifier_block *nb, void *ptr
 	u16 vport_num, esw_owner_vhca_id;
 	struct netlink_ext_ack *extack;
 	int ifindex = upper->ifindex;
-	int err;
+	int err = 0;
 
 	if (!netif_is_bridge_master(upper))
 		return 0;
@@ -244,7 +244,7 @@ mlx5_esw_bridge_port_obj_attr_set(struct net_device *dev,
 	struct netlink_ext_ack *extack = switchdev_notifier_info_to_extack(&port_attr_info->info);
 	const struct switchdev_attr *attr = port_attr_info->attr;
 	u16 vport_num, esw_owner_vhca_id;
-	int err;
+	int err = 0;
 
 	if (!mlx5_esw_bridge_lower_rep_vport_num_vhca_id_get(dev, br_offloads->esw, &vport_num,
 							     &esw_owner_vhca_id))
-- 
2.31.1

