Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29F93635B8
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 15:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhDRNu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 09:50:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230330AbhDRNuT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Apr 2021 09:50:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86F756052B;
        Sun, 18 Apr 2021 13:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618753791;
        bh=xD+ZP0WjiFFrCyDO6piK5xL2ZTY9dh3MNhhBW2QRA+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GHLq5uv5vkXKqto8kSzOZ5ea4Saru+rh+J9c6hG2xrdsywhzgknWLbIKnSlNWCTes
         BqY7Ycq6ELkn8OUh6+ivOL5keVLUbt/t0bFO1kSCv36KOZI3sROyQtp2A9gRezKmlA
         0B6K+JjyCOPdDmT/XZBFZqUXefRkdFWfol/G1ZXk9RFH08fk8yJf2Ly23MezKKY8MS
         O4mDoyBMf1AQBDSlCOZPHXV2Fa753KwKLV1EBVIMRh0k5dBdu06lDT44lY1g/Cy7iW
         KrrM0HiLk11oFPDWiBK3fXRbVCWVdE5U22m6+uwxmX3H5dv7uR21cshCJz+E1X4LhB
         WE8vq1+jXWTBA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Parav Pandit <parav@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next 1/2] IB/mlx5: Set right RoCE l3 type and roce version while deleting GID
Date:   Sun, 18 Apr 2021 16:49:39 +0300
Message-Id: <d3f54129c90ca329caf438dbe31875d8ad08d91a.1618753425.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1618753425.git.leonro@nvidia.com>
References: <cover.1618753425.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Currently when GID is deleted, it zero out all the fields of the RoCE
address in the SET_ROCE_ADDRESS command for a specified index.

roce_version = 0 means RoCEv1 in the SET_ROCE_ADDRESS command.

This assumes that device has RoCEv1 always enabled which is not always
correct. For example Subfunction does not support RoCEv1.

Due to this assumption a previously added RoCEv2 GID is always deleted as
RoCEv1 GID. This results in a below syndrome.

mlx5_core.sf mlx5_core.sf.4: mlx5_cmd_check:777:(pid 4256): SET_ROCE_ADDRESS(0x761) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x12822d)

Hence set the right RoCE version during GID deletion provided by the
core.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c                 | 8 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 7ea6137f8d12..6d1dd09a4388 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -555,15 +555,15 @@ static int set_roce_addr(struct mlx5_ib_dev *dev, u32 port_num,
 			 unsigned int index, const union ib_gid *gid,
 			 const struct ib_gid_attr *attr)
 {
-	enum ib_gid_type gid_type = IB_GID_TYPE_ROCE;
+	enum ib_gid_type gid_type;
 	u16 vlan_id = 0xffff;
 	u8 roce_version = 0;
 	u8 roce_l3_type = 0;
 	u8 mac[ETH_ALEN];
 	int ret;
 
+	gid_type = attr->gid_type;
 	if (gid) {
-		gid_type = attr->gid_type;
 		ret = rdma_read_gid_l2_fields(attr, &vlan_id, &mac[0]);
 		if (ret)
 			return ret;
@@ -575,7 +575,7 @@ static int set_roce_addr(struct mlx5_ib_dev *dev, u32 port_num,
 		break;
 	case IB_GID_TYPE_ROCE_UDP_ENCAP:
 		roce_version = MLX5_ROCE_VERSION_2;
-		if (ipv6_addr_v4mapped((void *)gid))
+		if (gid && ipv6_addr_v4mapped((void *)gid))
 			roce_l3_type = MLX5_ROCE_L3_TYPE_IPV4;
 		else
 			roce_l3_type = MLX5_ROCE_L3_TYPE_IPV6;
@@ -602,7 +602,7 @@ static int mlx5_ib_del_gid(const struct ib_gid_attr *attr,
 			   __always_unused void **context)
 {
 	return set_roce_addr(to_mdev(attr->device), attr->port_num,
-			     attr->index, NULL, NULL);
+			     attr->index, NULL, attr);
 }
 
 __be16 mlx5_get_roce_udp_sport_min(const struct mlx5_ib_dev *dev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c
index a68738c8f4bc..215fa8bdce48 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c
@@ -142,10 +142,10 @@ int mlx5_core_roce_gid_set(struct mlx5_core_dev *dev, unsigned int index,
 		}
 
 		ether_addr_copy(addr_mac, mac);
-		MLX5_SET_RA(in_addr, roce_version, roce_version);
-		MLX5_SET_RA(in_addr, roce_l3_type, roce_l3_type);
 		memcpy(addr_l3_addr, gid, gidsz);
 	}
+	MLX5_SET_RA(in_addr, roce_version, roce_version);
+	MLX5_SET_RA(in_addr, roce_l3_type, roce_l3_type);
 
 	if (MLX5_CAP_GEN(dev, num_vhca_ports) > 0)
 		MLX5_SET(set_roce_address_in, in, vhca_port_num, port_num);
-- 
2.30.2

