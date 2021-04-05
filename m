Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F04353BFA
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 07:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbhDEFuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 01:50:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232255AbhDEFui (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 01:50:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8D1E61393;
        Mon,  5 Apr 2021 05:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617601832;
        bh=aLTaImJggynKE0fFKmCwvZD8aLmzRiT3oFV9D4hqRH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBEl2X9GiSm4UPtHzNNkC4LUzQNdfuB635NeE5hgeOA3mPdYwbgUyhCU6yJd9KUzc
         VfgQVLZORn20ZxtS98o4tzuUl0E/VQwxgJFPITucrHLeQJVQ3FkPnECqG4iD3MfNTi
         3eK4gPXB16QStM+0heMrBy+wrOZLHwt2BU4xxnhTIJE3ZOgue1LozQ236iBnz5Kbx4
         t44Kz+mpwFSYuIK7dFJQGuUsT1f7R+54ASJ25x6DwanfrpRVP6PS03yZ64EO9VOFyr
         Q5SRb+5La0oxL5Xic6JHxQ3Z3oZS5xPFGyMhqa+UbpDfatKeUNGjmuhQ3yDlmdeToL
         qOe6+InnDm3jQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Karsten Graul <kgraul@linux.ibm.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: [PATCH rdma-next 8/8] net/rds: Move to client_supported callback
Date:   Mon,  5 Apr 2021 08:50:00 +0300
Message-Id: <20210405055000.215792-9-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405055000.215792-1-leon@kernel.org>
References: <20210405055000.215792-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Use newly introduced client_supported() callback to avoid client
additional if the RDMA device is not of IB type or if it doesn't
support device memory extensions.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/rds/ib.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/rds/ib.c b/net/rds/ib.c
index 24c9a9005a6f..bd2ff7d5a718 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -125,18 +125,23 @@ void rds_ib_dev_put(struct rds_ib_device *rds_ibdev)
 		queue_work(rds_wq, &rds_ibdev->free_work);
 }
 
-static int rds_ib_add_one(struct ib_device *device)
+static bool rds_client_supported(struct ib_device *device)
 {
-	struct rds_ib_device *rds_ibdev;
-	int ret;
-
 	/* Only handle IB (no iWARP) devices */
 	if (device->node_type != RDMA_NODE_IB_CA)
-		return -EOPNOTSUPP;
+		return false;
 
 	/* Device must support FRWR */
 	if (!(device->attrs.device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS))
-		return -EOPNOTSUPP;
+		return false;
+
+	return true;
+}
+
+static int rds_ib_add_one(struct ib_device *device)
+{
+	struct rds_ib_device *rds_ibdev;
+	int ret;
 
 	rds_ibdev = kzalloc_node(sizeof(struct rds_ib_device), GFP_KERNEL,
 				 ibdev_to_node(device));
@@ -288,7 +293,8 @@ static void rds_ib_remove_one(struct ib_device *device, void *client_data)
 struct ib_client rds_ib_client = {
 	.name   = "rds_ib",
 	.add    = rds_ib_add_one,
-	.remove = rds_ib_remove_one
+	.remove = rds_ib_remove_one,
+	.is_supported = rds_client_supported,
 };
 
 static int rds_ib_conn_info_visitor(struct rds_connection *conn,
-- 
2.30.2

