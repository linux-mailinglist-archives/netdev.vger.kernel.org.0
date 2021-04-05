Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBD7353BE1
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 07:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbhDEFuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 01:50:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:34270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232054AbhDEFuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 01:50:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B1EC6138A;
        Mon,  5 Apr 2021 05:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617601812;
        bh=PsROXfLh1PLcHMlKcwD6/kCYX1+1tHQ0rQ8neODxlfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0FAGW+541Z00Z1bI3RulQKM/s0QIS0cuSGHw/14luvghB1iYsKox5jHVeR1lI2bi
         qB8vcBK6/3Ar8Sw+el7Ed++NRSbD7E6Dvj2WyIDsk/MwiajX+53FRf3CoSRAMuBEc/
         gV2jo1Feyzz62ybr0BgEgJv0VCleevlXrMyoXNhM0OkeraAc/46NOy6FUne8F9Uxpv
         qsHUphlPdcetw+nuSI1hAfevmQqpJ2jjoGd7B1S7aIbgvoQL9Iy3lVjqo3vHhfJSc/
         KQg6VNmC9Mu0bb5GBqMzu+ELRy9e+ZmNhu6kKmOG04nX6prLNp8qOyJr0m1rUUP6tO
         I0eqv0aGIrOkw==
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
Subject: [PATCH rdma-next 3/8] IB/cm: Skip device which doesn't support IB CM
Date:   Mon,  5 Apr 2021 08:49:55 +0300
Message-Id: <20210405055000.215792-4-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405055000.215792-1-leon@kernel.org>
References: <20210405055000.215792-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

There are at least 3 types of RDMA devices which do not support IB CM.
They are
(1) A (eswitch) switchdev RDMA device,
(2) iWARP device and
(3) RDMA device without a RoCE capability

Hence, avoid IB CM initialization for such devices.

This saves 8Kbytes of memory for eswitch device consist of 512 ports and
also avoids unnecessary initialization for all above 3 types of devices.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/cm.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 8a7791ebae69..5025f2c1347b 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -87,6 +87,7 @@ struct cm_id_private;
 struct cm_work;
 static int cm_add_one(struct ib_device *device);
 static void cm_remove_one(struct ib_device *device, void *client_data);
+static bool cm_supported(struct ib_device *device);
 static void cm_process_work(struct cm_id_private *cm_id_priv,
 			    struct cm_work *work);
 static int cm_send_sidr_rep_locked(struct cm_id_private *cm_id_priv,
@@ -103,7 +104,8 @@ static int cm_send_rej_locked(struct cm_id_private *cm_id_priv,
 static struct ib_client cm_client = {
 	.name   = "cm",
 	.add    = cm_add_one,
-	.remove = cm_remove_one
+	.remove = cm_remove_one,
+	.is_supported = cm_supported,
 };
 
 static struct ib_cm {
@@ -4371,6 +4373,17 @@ static void cm_remove_port_fs(struct cm_port *port)
 
 }
 
+static bool cm_supported(struct ib_device *device)
+{
+	u32 i;
+
+	rdma_for_each_port(device, i) {
+		if (rdma_cap_ib_cm(device, i))
+			return true;
+	}
+	return false;
+}
+
 static int cm_add_one(struct ib_device *ib_device)
 {
 	struct cm_device *cm_dev;
-- 
2.30.2

