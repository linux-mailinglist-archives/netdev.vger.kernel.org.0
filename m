Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59EB3353BF2
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 07:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbhDEFue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 01:50:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232167AbhDEFub (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 01:50:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A28A6138A;
        Mon,  5 Apr 2021 05:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617601825;
        bh=rtcMcUL397sY/syxPEZjzfWCRFmVIU4Faf5zTlLK6L0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yhpy+5QmDVh1oxOKBVc9OjoRKKEF5l5jFNKO2B57otK0z0i680Jz7N92YtGNZBOd6
         7S7Q/9UJv1AxU8fQ5/0U8qyi9Jn2BuAB2+SQcmNyV72/Twt3woLd2DXVGtijgC1Kwo
         4tesDNu1hEwgN64PYFdTykUpxEqzJFf9cE0nNzvoK4fEAsve8lZhCJs1GQT7Rw8KW2
         /fVQ/6wOKF97hqIcWnLVC7JcpCEyxV9rjW73srjbuhnnq5vAq/kNuH0+jWoDOY16CQ
         I9VqKAnIi1ex3J9jVtKwxflEHqCLPOtk8f1alhZSADrkFYllOq0Z0kjjuqXrfHDf2W
         yO25ShUdCHODg==
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
Subject: [PATCH rdma-next 7/8] net/smc: Move to client_supported callback
Date:   Mon,  5 Apr 2021 08:49:59 +0300
Message-Id: <20210405055000.215792-8-leon@kernel.org>
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
additional if the RDMA device is not of IB type.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/smc/smc_ib.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 6b65c5d1f957..f7186d9d1299 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -767,6 +767,11 @@ void smc_ib_ndev_change(struct net_device *ndev, unsigned long event)
 	mutex_unlock(&smc_ib_devices.mutex);
 }
 
+static bool smc_client_supported(struct ib_device *ibdev)
+{
+	return ibdev->node_type == RDMA_NODE_IB_CA;
+}
+
 /* callback function for ib_register_client() */
 static int smc_ib_add_dev(struct ib_device *ibdev)
 {
@@ -774,9 +779,6 @@ static int smc_ib_add_dev(struct ib_device *ibdev)
 	u8 port_cnt;
 	int i;
 
-	if (ibdev->node_type != RDMA_NODE_IB_CA)
-		return -EOPNOTSUPP;
-
 	smcibdev = kzalloc(sizeof(*smcibdev), GFP_KERNEL);
 	if (!smcibdev)
 		return -ENOMEM;
@@ -840,6 +842,7 @@ static struct ib_client smc_ib_client = {
 	.name	= "smc_ib",
 	.add	= smc_ib_add_dev,
 	.remove = smc_ib_remove_dev,
+	.is_supported = smc_client_supported,
 };
 
 int __init smc_ib_register_client(void)
-- 
2.30.2

