Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8578BCD34A
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 18:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfJFQAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 12:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726349AbfJFQAU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Oct 2019 12:00:20 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A425620862;
        Sun,  6 Oct 2019 16:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570377620;
        bh=DGKP/JNhMkqhnGAiwp2ESxKKl7LcAXgnEh2r/sQavvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U3BE3AQ5m+tOUayCLSXn3hfpASlJYoLyq2VzAY3B1DoGHiBB/l5lmDl7eqqSUkY3o
         P3YJu4aCbaSDpXlW1izAg9p3FIl0T/DCQt+/lWvmicnoj6OWh+V/8jnYwRjvA85+Ba
         Ra1KokSwq3y9/ZAXwolVOVrxmoH1kR8mEWcOHfjo=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 3/3] RDMA/rw: Support threshold for registration vs scattering to local pages
Date:   Sun,  6 Oct 2019 18:59:55 +0300
Message-Id: <20191006155955.31445-4-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191006155955.31445-1-leon@kernel.org>
References: <20191006155955.31445-1-leon@kernel.org>
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
 drivers/infiniband/core/rw.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index 5337393d4dfe..ecff40efcb88 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -20,9 +20,7 @@ module_param_named(force_mr, rdma_rw_force_mr, bool, 0);
 MODULE_PARM_DESC(force_mr, "Force usage of MRs for RDMA READ/WRITE operations");
 
 /*
- * Check if the device might use memory registration.  This is currently only
- * true for iWarp devices. In the future we can hopefully fine tune this based
- * on HCA driver input.
+ * Check if the device might use memory registration.
  */
 static inline bool rdma_rw_can_use_mr(struct ib_device *dev, u8 port_num)
 {
@@ -30,6 +28,8 @@ static inline bool rdma_rw_can_use_mr(struct ib_device *dev, u8 port_num)
 		return true;
 	if (unlikely(rdma_rw_force_mr))
 		return true;
+	if (dev->attrs.max_sgl_rd)
+		return true;
 	return false;
 }
 
@@ -37,9 +37,6 @@ static inline bool rdma_rw_can_use_mr(struct ib_device *dev, u8 port_num)
  * Check if the device will use memory registration for this RW operation.
  * We currently always use memory registrations for iWarp RDMA READs, and
  * have a debug option to force usage of MRs.
- *
- * XXX: In the future we can hopefully fine tune this based on HCA driver
- * input.
  */
 static inline bool rdma_rw_io_needs_mr(struct ib_device *dev, u8 port_num,
 		enum dma_data_direction dir, int dma_nents)
@@ -48,6 +45,9 @@ static inline bool rdma_rw_io_needs_mr(struct ib_device *dev, u8 port_num,
 		return true;
 	if (unlikely(rdma_rw_force_mr))
 		return true;
+	if (dev->attrs.max_sgl_rd && dir == DMA_FROM_DEVICE
+	    && dma_nents > dev->attrs.max_sgl_rd)
+		return true;
 	return false;
 }
 
-- 
2.20.1

