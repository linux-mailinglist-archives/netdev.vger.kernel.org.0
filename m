Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92D38FC787
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 14:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfKNNbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 08:31:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:45164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727134AbfKNNbp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 08:31:45 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D827B205C9;
        Thu, 14 Nov 2019 13:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573738304;
        bh=DY1NJIYWIGWG99+4n8+vknfj2UfNByQ/y9ppYdflykE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K4wCtEeMw37H/72DEy/NWBiPZ44KV8KeqVkiLEZktfgQMP2ac2TvOzChWO8HMLB8k
         EvrWYZ/lGxrGk+SpjQsDH0E9yiWq9GIFRZqTN/o5DfeLe/eC14izuVhS/N5Run394t
         xcemia1z2wkcPaM4iY0Yps6l+tfbXaTpDF8+nZuw=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Danit Goldberg <danitg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 4/4] IB/mlx5: Implement callbacks for getting VFs GUID attributes
Date:   Thu, 14 Nov 2019 15:31:26 +0200
Message-Id: <20191114133126.238128-6-leon@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191114133126.238128-1-leon@kernel.org>
References: <20191114133126.238128-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danit Goldberg <danitg@mellanox.com>

Implement the IB defined callback mlx5_ib_get_vf_guid used to query FW
for VFs attributes and return node and port GUIDs.

Signed-off-by: Danit Goldberg <danitg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/ib_virt.c | 24 ++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/main.c    |  1 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  3 +++
 3 files changed, 28 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/ib_virt.c b/drivers/infiniband/hw/mlx5/ib_virt.c
index 649a3364f838..4f0edd4832bd 100644
--- a/drivers/infiniband/hw/mlx5/ib_virt.c
+++ b/drivers/infiniband/hw/mlx5/ib_virt.c
@@ -201,3 +201,27 @@ int mlx5_ib_set_vf_guid(struct ib_device *device, int vf, u8 port,

 	return -EINVAL;
 }
+
+int mlx5_ib_get_vf_guid(struct ib_device *device, int vf, u8 port,
+			struct ifla_vf_guid *node_guid,
+			struct ifla_vf_guid *port_guid)
+{
+	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_core_dev *mdev = dev->mdev;
+	struct mlx5_hca_vport_context *rep;
+	int err;
+
+	rep = kzalloc(sizeof(*rep), GFP_KERNEL);
+	if (!rep)
+		return -ENOMEM;
+
+	err = mlx5_query_hca_vport_context(mdev, 1, 1, vf+1, rep);
+	if (err)
+		goto ex;
+
+	port_guid->guid = rep->port_guid;
+	node_guid->guid = rep->node_guid;
+ex:
+	kfree(rep);
+	return err;
+}
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 2d83f8c1d7ba..7127cdd313c1 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -6313,6 +6313,7 @@ static const struct ib_device_ops mlx5_ib_dev_ipoib_enhanced_ops = {

 static const struct ib_device_ops mlx5_ib_dev_sriov_ops = {
 	.get_vf_config = mlx5_ib_get_vf_config,
+	.get_vf_guid = mlx5_ib_get_vf_guid,
 	.get_vf_stats = mlx5_ib_get_vf_stats,
 	.set_vf_guid = mlx5_ib_set_vf_guid,
 	.set_vf_link_state = mlx5_ib_set_vf_link_state,
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 00fd412ef686..3ad20b120bf4 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1315,6 +1315,9 @@ int mlx5_ib_set_vf_link_state(struct ib_device *device, int vf,
 			      u8 port, int state);
 int mlx5_ib_get_vf_stats(struct ib_device *device, int vf,
 			 u8 port, struct ifla_vf_stats *stats);
+int mlx5_ib_get_vf_guid(struct ib_device *device, int vf, u8 port,
+			struct ifla_vf_guid *node_guid,
+			struct ifla_vf_guid *port_guid);
 int mlx5_ib_set_vf_guid(struct ib_device *device, int vf, u8 port,
 			u64 guid, int type);

--
2.20.1

