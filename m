Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1D1353BE6
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 07:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbhDEFuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 01:50:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232078AbhDEFuV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 01:50:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECC0A6138A;
        Mon,  5 Apr 2021 05:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617601815;
        bh=OZcrC5GanjfRIBMiqGHldB7KHYyxXozI8j3d7T22USc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mi3dfg3at4/ueREeId3jg7bTAy/4OXL1XBmR9UH001oVmWDFY8KoNBkRoWlTR8Dx/
         zHryp2NxJGbOPHv2uvxSwTXG2LIx2oop0vngtomkWjljR2ADN3sOthTu8bYalDEXSk
         jWhO6eqOzd5P5JlBNEtn5CbxWW56Y7jaREo0AgW3sGasikYwtia1fQUIuDq9vHP4wI
         Wltdboz7BB2mUeogc0dTNFtkfC6s8VOw8+cRbPjByJXPD0Xcj69LVZ3/CuXXG9UpEP
         7nptGF1rYPcCt6/dj1sU/Ysa2bOANGNInQRP4el2NdanyOvhl1FwX+KpQmkyims/sN
         CcuTKY03/Kxmw==
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
Subject: [PATCH rdma-next 1/8] RDMA/core: Check if client supports IB device or not
Date:   Mon,  5 Apr 2021 08:49:53 +0300
Message-Id: <20210405055000.215792-2-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405055000.215792-1-leon@kernel.org>
References: <20210405055000.215792-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

RDMA devices are of different transport(iWarp, IB, RoCE) and have
different attributes.
Not all clients are interested in all type of devices.

Implement a generic callback that each IB client can implement to decide
if client add() or remove() should be done by the IB core or not for a
given IB device, client combination.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/device.c | 3 +++
 include/rdma/ib_verbs.h          | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index c660cef66ac6..c9af2deba8c1 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -691,6 +691,9 @@ static int add_client_context(struct ib_device *device,
 	if (!device->kverbs_provider && !client->no_kverbs_req)
 		return 0;
 
+	if (client->is_supported && !client->is_supported(device))
+		return 0;
+
 	down_write(&device->client_data_rwsem);
 	/*
 	 * So long as the client is registered hold both the client and device
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 59138174affa..777fbcbd4858 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2756,6 +2756,15 @@ struct ib_client {
 			const union ib_gid *gid,
 			const struct sockaddr *addr,
 			void *client_data);
+	/*
+	 * Returns if the client is supported for a given device or not.
+	 * @dev: An RDMA device to check if client can support this RDMA or not.
+	 *
+	 * A client that is interested in specific device attributes, should
+	 * implement it to check if client can be supported for this device or
+	 * not.
+	 */
+	bool (*is_supported)(struct ib_device *dev);
 
 	refcount_t uses;
 	struct completion uses_zero;
-- 
2.30.2

