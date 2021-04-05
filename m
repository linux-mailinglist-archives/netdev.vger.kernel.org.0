Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5631D353BDE
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 07:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbhDEFuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 01:50:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229727AbhDEFuO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 01:50:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42EA761399;
        Mon,  5 Apr 2021 05:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617601808;
        bh=F5IJVEwD/ds8nR2UWRrmKXAI11023OkVeObLtcX5Os8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NODekafGzp5kSojCg+hpr6B9AlQvD3zKz1kSQUnnab6bpFEEOrBv7H4HhlV/xDoFY
         TqFAkD/p2pVLkh3I28NPd/1jujvuwkWrGbTce9KKjJN/16uPujucZoym8KBnN1wLlc
         QKvVKGhzBkFZWDuJHsCWo1j2ZxDkXtxY53SB2B/tPDIPN7O8ZOy0WgPKkTKjRH+lQW
         C07RwZj1T/8gB8IjoV1gkCqJobugEN3Ocv/6PIomvbhVfoWbJP1831Zr9n3Xnb6wdM
         v7QgnCVGlTYCiSGHb7jlz3Xm72ANX8GWg/U5Rafawy+7PiQVcdMJ8O/EQs4ePWufCD
         EjCIRobdjqIrA==
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
Subject: [PATCH rdma-next 2/8] RDMA/cma: Skip device which doesn't support CM
Date:   Mon,  5 Apr 2021 08:49:54 +0300
Message-Id: <20210405055000.215792-3-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405055000.215792-1-leon@kernel.org>
References: <20210405055000.215792-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

A switchdev RDMA device do not support IB CM. When such device is added
to the RDMA CM's device list, when application invokes rdma_listen(),
cma attempts to listen to such device, however it has IB CM attribute
disabled.

Due to this, rdma_listen() call fails to listen for other non
switchdev devices as well.

A below error message can be seen.

infiniband mlx5_0: RDMA CMA: cma_listen_on_dev, error -38

A failing call flow is below.

rdma_listen()
  cma_listen_on_all()
    cma_listen_on_dev()
      _cma_attach_to_dev()
      rdma_listen() <- fails on a specific switchdev device

Hence, when a IB device doesn't support IB CM or IW CM, avoid adding
such device to the cma list.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/cma.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 42a1c8955c50..80156faf90de 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -157,11 +157,13 @@ EXPORT_SYMBOL(rdma_res_to_id);
 
 static int cma_add_one(struct ib_device *device);
 static void cma_remove_one(struct ib_device *device, void *client_data);
+static bool cma_supported(struct ib_device *device);
 
 static struct ib_client cma_client = {
 	.name   = "cma",
 	.add    = cma_add_one,
-	.remove = cma_remove_one
+	.remove = cma_remove_one,
+	.is_supported = cma_supported,
 };
 
 static struct ib_sa_client sa_client;
@@ -4870,6 +4872,17 @@ static void cma_process_remove(struct cma_device *cma_dev)
 	wait_for_completion(&cma_dev->comp);
 }
 
+static bool cma_supported(struct ib_device *device)
+{
+	u32 i;
+
+	rdma_for_each_port(device, i) {
+		if (rdma_cap_ib_cm(device, i) || rdma_cap_iw_cm(device, i))
+			return true;
+	}
+	return false;
+}
+
 static int cma_add_one(struct ib_device *device)
 {
 	struct rdma_id_private *to_destroy;
-- 
2.30.2

