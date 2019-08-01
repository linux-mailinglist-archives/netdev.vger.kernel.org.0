Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C70287DB4C
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 14:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731164AbfHAMVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 08:21:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:32984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728791AbfHAMVy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 08:21:54 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1761520838;
        Thu,  1 Aug 2019 12:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564662113;
        bh=cdIzpma59+8ccw4pf9IkQYTsoLRo13CbMbJywDBJas4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wQbtPdl2mA5rriIOnvjPjrRsULhDZlV7jTX97S3BV3tQ8bqFITOV8wCsDGhkdVBpO
         sd+VP7PwZVchZm6mzVmqiPxU4mPvXxV60lWQoDMtOAt6UeDOvM6A9jxoQwrH/vbzzz
         eO0y3FcEDMGwnPV1GY3RJOs1W/NjEyQqMJOEtLhM=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 3/3] IB/mlx5: Add page fault handler for DC initiator WQE
Date:   Thu,  1 Aug 2019 15:21:39 +0300
Message-Id: <20190801122139.25224-4-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190801122139.25224-1-leon@kernel.org>
References: <20190801122139.25224-1-leon@kernel.org>
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
Reviewed-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/odp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 5e87a5e25574..6f1de5edbe8e 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1065,6 +1065,12 @@ static int mlx5_ib_mr_initiator_pfault_handler(
 	case IB_QPT_UD:
 		transport_caps = dev->odp_caps.per_transport_caps.ud_odp_caps;
 		break;
+	case IB_QPT_DRIVER:
+		if (qp->qp_sub_type == MLX5_IB_QPT_DCI) {
+			transport_caps = dev->dc_odp_caps;
+			break;
+		}
+		/* fall through */
 	default:
 		mlx5_ib_err(dev, "ODP fault on QP of an unsupported transport 0x%x\n",
 			    qp->ibqp.qp_type);
@@ -1078,7 +1084,8 @@ static int mlx5_ib_mr_initiator_pfault_handler(
 		return -EFAULT;
 	}
 
-	if (qp->ibqp.qp_type == IB_QPT_UD) {
+	if (qp->ibqp.qp_type == IB_QPT_UD ||
+	    qp->qp_sub_type == MLX5_IB_QPT_DCI) {
 		av = *wqe;
 		if (av->dqp_dct & cpu_to_be32(MLX5_EXTENDED_UD_AV))
 			*wqe += sizeof(struct mlx5_av);
-- 
2.20.1

