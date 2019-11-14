Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00DA9FC78A
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 14:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfKNNbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 08:31:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727133AbfKNNbs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 08:31:48 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B8AD206DC;
        Thu, 14 Nov 2019 13:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573738307;
        bh=oK6Brk56uaaFwLmfDGa8yz13wg8Fvxx4WygZXRjHuMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D7oynUVRMFwy9qOdn3FQvH5VNtHe195sRhItif+caxleRe5+aKH/7Ejka/OU8teU5
         BwO0S/41xahlKB6CBa4JdxxYdAsuHYioe0UoWomRIQEDZB2MDg8NrXz8iQYdPAmggs
         QPJlxMTlemZz0l5BncnebR7uwEwkGjYinB6+z7nE=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Danit Goldberg <danitg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 2/4] IB/core: Add interfaces to get VF node and port GUIDs
Date:   Thu, 14 Nov 2019 15:31:24 +0200
Message-Id: <20191114133126.238128-4-leon@kernel.org>
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


Provide ability to get node and port GUIDs of VFs to be symmetrical
to already existing set option.

Signed-off-by: Danit Goldberg <danitg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/device.c |  1 +
 drivers/infiniband/core/verbs.c  | 10 ++++++++++
 include/rdma/ib_verbs.h          |  6 ++++++
 3 files changed, 17 insertions(+)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 1a789d2f7a38..e2229bab304a 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2618,6 +2618,7 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, get_port_immutable);
 	SET_DEVICE_OP(dev_ops, get_vector_affinity);
 	SET_DEVICE_OP(dev_ops, get_vf_config);
+	SET_DEVICE_OP(dev_ops, get_vf_guid);
 	SET_DEVICE_OP(dev_ops, get_vf_stats);
 	SET_DEVICE_OP(dev_ops, init_port);
 	SET_DEVICE_OP(dev_ops, invalidate_range);
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 5cf32bf484b7..da77057bfe69 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2460,6 +2460,16 @@ int ib_set_vf_guid(struct ib_device *device, int vf, u8 port, u64 guid,
 }
 EXPORT_SYMBOL(ib_set_vf_guid);

+int ib_get_vf_guid(struct ib_device *device, int vf, u8 port,
+		   struct ifla_vf_guid *node_guid,
+		   struct ifla_vf_guid *port_guid)
+{
+	if (!device->ops.get_vf_guid)
+		return -EOPNOTSUPP;
+
+	return device->ops.get_vf_guid(device, vf, port, node_guid, port_guid);
+}
+EXPORT_SYMBOL(ib_get_vf_guid);
 /**
  * ib_map_mr_sg_pi() - Map the dma mapped SG lists for PI (protection
  *     information) and set an appropriate memory region for registration.
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index f9e121b03158..d8b73a89ca1a 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2472,6 +2472,9 @@ struct ib_device_ops {
 			     struct ifla_vf_info *ivf);
 	int (*get_vf_stats)(struct ib_device *device, int vf, u8 port,
 			    struct ifla_vf_stats *stats);
+	int (*get_vf_guid)(struct ib_device *device, int vf, u8 port,
+			    struct ifla_vf_guid *node_guid,
+			    struct ifla_vf_guid *port_guid);
 	int (*set_vf_guid)(struct ib_device *device, int vf, u8 port, u64 guid,
 			   int type);
 	struct ib_wq *(*create_wq)(struct ib_pd *pd,
@@ -3342,6 +3345,9 @@ int ib_get_vf_config(struct ib_device *device, int vf, u8 port,
 		     struct ifla_vf_info *info);
 int ib_get_vf_stats(struct ib_device *device, int vf, u8 port,
 		    struct ifla_vf_stats *stats);
+int ib_get_vf_guid(struct ib_device *device, int vf, u8 port,
+		    struct ifla_vf_guid *node_guid,
+		    struct ifla_vf_guid *port_guid);
 int ib_set_vf_guid(struct ib_device *device, int vf, u8 port, u64 guid,
 		   int type);

--
2.20.1

