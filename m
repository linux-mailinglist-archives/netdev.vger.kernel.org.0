Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5754B13D977
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 13:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgAPMA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 07:00:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:46924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgAPMA4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 07:00:56 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEF49205F4;
        Thu, 16 Jan 2020 12:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579176054;
        bh=IC6zp8yS0YQyOs1fKIGr8dqajez6JDY7q1Bbd0/Xclk=;
        h=From:To:Cc:Subject:Date:From;
        b=1m/bOv0oSFqUWK/kqiRHOuIeCkqZs+Yx89vFf3omdVK8B1/qqGK7Q5jl6/UB/MfYT
         FwiK+sUFXrF0FT4JtBh+8fhghuPph6rgBVBfrRFN9799OWE0U0L5tc1qAvq/mrF+xn
         mceNAncK9kH6loBDD0bL7ceX0cIgUZ0F+j6hRXw4=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Danit Goldberg <danitg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH mlx5-next] IB/mlx5: Return the administrative GUID if exists
Date:   Thu, 16 Jan 2020 14:00:48 +0200
Message-Id: <20200116120048.12744-1-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danit Goldberg <danitg@mellanox.com>

A user can achieve the operational GUID (a.k.a affective GUID) through
link/infiniband. Therefore it is preferred to return the administrative
GUID if exists instead of the operational.
This way the PF can query which VF GUID will be set in the next bind.
In order to align with MAC address, zero is returned if
administrative GUID is not set.

For example:
- Before setting administrative GUID:
ip link show
ib0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 4092 qdisc mq state UP mode DEFAULT group default qlen 256
link/infiniband 00:00:00:08:fe:80:00:00:00:00:00:00:52:54:00:c0:fe:12:34:55 brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
vf 0     link/infiniband 00:00:00:08:fe:80:00:00:00:00:00:00:52:54:00:c0:fe:12:34:55 brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff,
spoof checking off, NODE_GUID 00:00:00:00:00:00:00:00, PORT_GUID 00:00:00:00:00:00:00:00, link-state auto, trust off, query_rss off

ip link set ib0 vf 0 node_guid 11:00:af:21:cb:05:11:00
ip link set ib0 vf 0 port_guid 22:11:af:21:cb:05:11:00

- After setting administrative GUID:
ip link show
ib0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 4092 qdisc mq state UP mode DEFAULT group default qlen 256
link/infiniband 00:00:00:08:fe:80:00:00:00:00:00:00:52:54:00:c0:fe:12:34:55 brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
vf 0     link/infiniband 00:00:00:08:fe:80:00:00:00:00:00:00:52:54:00:c0:fe:12:34:55 brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff,
spoof checking off, NODE_GUID 11:00:af:21:cb:05:11:00, PORT_GUID 22:11:af:21:cb:05:11:00, link-state auto, trust off, query_rss off

Fixes: 9c0015ef0928 ("IB/mlx5: Implement callbacks for getting VFs GUID attributes")
Signed-off-by: Danit Goldberg <danitg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/ib_virt.c | 28 ++++++++++++----------------
 include/linux/mlx5/driver.h          |  5 +++++
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_virt.c b/drivers/infiniband/hw/mlx5/ib_virt.c
index 4f0edd4832bd..b61165359954 100644
--- a/drivers/infiniband/hw/mlx5/ib_virt.c
+++ b/drivers/infiniband/hw/mlx5/ib_virt.c
@@ -164,8 +164,10 @@ static int set_vf_node_guid(struct ib_device *device, int vf, u8 port, u64 guid)
 	in->field_select = MLX5_HCA_VPORT_SEL_NODE_GUID;
 	in->node_guid = guid;
 	err = mlx5_core_modify_hca_vport_context(mdev, 1, 1, vf + 1, in);
-	if (!err)
+	if (!err) {
 		vfs_ctx[vf].node_guid = guid;
+		vfs_ctx[vf].node_guid_valid = 1;
+	}
 	kfree(in);
 	return err;
 }
@@ -185,8 +187,10 @@ static int set_vf_port_guid(struct ib_device *device, int vf, u8 port, u64 guid)
 	in->field_select = MLX5_HCA_VPORT_SEL_PORT_GUID;
 	in->port_guid = guid;
 	err = mlx5_core_modify_hca_vport_context(mdev, 1, 1, vf + 1, in);
-	if (!err)
+	if (!err) {
 		vfs_ctx[vf].port_guid = guid;
+		vfs_ctx[vf].port_guid_valid = 1;
+	}
 	kfree(in);
 	return err;
 }
@@ -208,20 +212,12 @@ int mlx5_ib_get_vf_guid(struct ib_device *device, int vf, u8 port,
 {
 	struct mlx5_ib_dev *dev = to_mdev(device);
 	struct mlx5_core_dev *mdev = dev->mdev;
-	struct mlx5_hca_vport_context *rep;
-	int err;
-
-	rep = kzalloc(sizeof(*rep), GFP_KERNEL);
-	if (!rep)
-		return -ENOMEM;
+	struct mlx5_vf_context *vfs_ctx = mdev->priv.sriov.vfs_ctx;
 
-	err = mlx5_query_hca_vport_context(mdev, 1, 1, vf+1, rep);
-	if (err)
-		goto ex;
+	node_guid->guid =
+		vfs_ctx[vf].node_guid_valid ? vfs_ctx[vf].node_guid : 0;
+	port_guid->guid =
+		vfs_ctx[vf].port_guid_valid ? vfs_ctx[vf].port_guid : 0;
 
-	port_guid->guid = rep->port_guid;
-	node_guid->guid = rep->node_guid;
-ex:
-	kfree(rep);
-	return err;
+	return 0;
 }
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 27200dea0297..a24937fc56b9 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -461,6 +461,11 @@ struct mlx5_vf_context {
 	int	enabled;
 	u64	port_guid;
 	u64	node_guid;
+	/* Valid bits are used to validate administrative guid only.
+	 * Enabled after ndo_set_vf_guid
+	 */
+	u8	port_guid_valid:1;
+	u8	node_guid_valid:1;
 	enum port_state_policy	policy;
 };
 
-- 
2.20.1

