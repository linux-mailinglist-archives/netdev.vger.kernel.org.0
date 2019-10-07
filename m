Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2431BCE108
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 13:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbfJGL6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 07:58:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727467AbfJGL6e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 07:58:34 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDC63206C2;
        Mon,  7 Oct 2019 11:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570449513;
        bh=urU0gpWLemuWerXs6TEo+8I0aCRLSnIPmOKzKmCpaIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OWf7uG984/OJPvzCnpw8uYcq3k2+kksFRndAU/J63FqkTZ24NGGpcqstqEsnIUykt
         q4Sv/otTz4EeGkWfqklUvMex8EGP71Lszo5w7spzJ9/b2lqdj5wzYyx53TT7IHztK3
         y0hu2jD9FHvi9fKT+L6r+d0GUggS+dUQKY9bv8tg=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v1 2/3] RDMA/rw: Support threshold for registration vs scattering to local pages
Date:   Mon,  7 Oct 2019 14:58:18 +0300
Message-Id: <20191007115819.9211-3-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191007115819.9211-1-leon@kernel.org>
References: <20191007115819.9211-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yamin Friedman <yaminf@mellanox.com>

If there are more scatter entries than the recommended limit provided by
the ib device, UMR registration is used. This will provide optimal
performance when performing large RDMA READs over devices that advertise
the threshold capability.

With ConnectX-5 running NVMeoF RDMA with FIO single QP 128KB writes:
Without use of cap: 70Gb/sec
With use of cap: 84Gb/sec

Signed-off-by: Yamin Friedman <yaminf@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/rw.c | 14 ++++++++------
 include/rdma/ib_verbs.h      |  2 ++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index 5337393d4dfe..8739bd28232b 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -20,14 +20,16 @@ module_param_named(force_mr, rdma_rw_force_mr, bool, 0);
 MODULE_PARM_DESC(force_mr, "Force usage of MRs for RDMA READ/WRITE operations");

 /*
- * Check if the device might use memory registration.  This is currently only
- * true for iWarp devices. In the future we can hopefully fine tune this based
- * on HCA driver input.
+ * Check if the device might use memory registration. This is currently
+ * true for iWarp devices and devices that have optimized SGL registration
+ * logic.
  */
 static inline bool rdma_rw_can_use_mr(struct ib_device *dev, u8 port_num)
 {
 	if (rdma_protocol_iwarp(dev, port_num))
 		return true;
+	if (dev->attrs.max_sgl_rd)
+		return true;
 	if (unlikely(rdma_rw_force_mr))
 		return true;
 	return false;
@@ -37,15 +39,15 @@ static inline bool rdma_rw_can_use_mr(struct ib_device *dev, u8 port_num)
  * Check if the device will use memory registration for this RW operation.
  * We currently always use memory registrations for iWarp RDMA READs, and
  * have a debug option to force usage of MRs.
- *
- * XXX: In the future we can hopefully fine tune this based on HCA driver
- * input.
  */
 static inline bool rdma_rw_io_needs_mr(struct ib_device *dev, u8 port_num,
 		enum dma_data_direction dir, int dma_nents)
 {
 	if (rdma_protocol_iwarp(dev, port_num) && dir == DMA_FROM_DEVICE)
 		return true;
+	if (dev->attrs.max_sgl_rd && dir == DMA_FROM_DEVICE &&
+	    dma_nents > dev->attrs.max_sgl_rd)
+		return true;
 	if (unlikely(rdma_rw_force_mr))
 		return true;
 	return false;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 4f671378dbfc..60fd98a9b7e8 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -445,6 +445,8 @@ struct ib_device_attr {
 	struct ib_tm_caps	tm_caps;
 	struct ib_cq_caps       cq_caps;
 	u64			max_dm_size;
+	/* Max entries for sgl for optimized performance per READ */
+	u32			max_sgl_rd;
 };

 enum ib_mtu {
--
2.20.1

