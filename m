Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D046C92312
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 14:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbfHSMI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 08:08:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726987AbfHSMI2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 08:08:28 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3633D20851;
        Mon, 19 Aug 2019 12:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566216507;
        bh=LkiTbhQy0Vf8VC6YojsyRQ2jwhvO0AJ/ASXLiU9Nljk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HpfAEm1tO3I2rltaeDUUwZWLpjC5Qd+79FlI/SXmogUqSJIv+Zb/wrMUQoqwp/cin
         2sA1hm96p/yS8itq7WxNouoPeQvRJTXBkBzddt92ZDHP/Q6Q5a98UO+l3lyTzfszVN
         BI8a6LvzqnZM5q+r9uWi0xrVFH82q6T71rv6Tho0=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v3 3/3] IB/mlx5: Add page fault handler for DC initiator WQE
Date:   Mon, 19 Aug 2019 15:08:15 +0300
Message-Id: <20190819120815.21225-4-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190819120815.21225-1-leon@kernel.org>
References: <20190819120815.21225-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

Parsing DC initiator WQEs upon page fault requires skipping an address
vector segment, as in UD WQEs.

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/odp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index e7a4ea979209..e6903e90aaf1 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1022,7 +1022,8 @@ static int mlx5_ib_mr_initiator_pfault_handler(
 	if (qp->ibqp.qp_type == IB_QPT_XRC_INI)
 		*wqe += sizeof(struct mlx5_wqe_xrc_seg);
 
-	if (qp->ibqp.qp_type == IB_QPT_UD) {
+	if (qp->ibqp.qp_type == IB_QPT_UD ||
+	    qp->qp_sub_type == MLX5_IB_QPT_DCI) {
 		av = *wqe;
 		if (av->dqp_dct & cpu_to_be32(MLX5_EXTENDED_UD_AV))
 			*wqe += sizeof(struct mlx5_av);
-- 
2.20.1

