Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5781285D24
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 10:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731550AbfHHIoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 04:44:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728289AbfHHIoQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 04:44:16 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A84302173C;
        Thu,  8 Aug 2019 08:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565253855;
        bh=zfXrYbZgAI2l9+qZcGRipjsZJ2zc/2vmcUK5eXukgCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZcQEndYZ1nuz4D9XOMnkJOXz0eN9DpSvaROmXSzx5Pdk2EDhG+bU4hHTrcpyGmzX
         7ZVoxNK2zpbmXnP/kCUYUzc2Ggtxzl0BDLwXeJn3t1JMcjXV7QcrhkfoyjWVFEEGVH
         h5wFg9JW7Eornmqf0D/m9WcoHerL2RgaVUpwrrPU=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Edward Srouji <edwards@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 3/4] IB/mlx5: Add legacy events to DEVX list
Date:   Thu,  8 Aug 2019 11:43:57 +0300
Message-Id: <20190808084358.29517-4-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190808084358.29517-1-leon@kernel.org>
References: <20190808084358.29517-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Add two events that were defined in the device specification but were
not exposed in the driver list.

Post this patch those events can be read over the DEVX events interface
once be reported by the firmware.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Edward Srouji <edwards@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c | 8 ++++++++
 include/linux/mlx5/device.h       | 9 +++++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index fd577ffd7864..3dbdfe0eb5e4 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -233,6 +233,8 @@ static bool is_legacy_obj_event_num(u16 event_num)
 	case MLX5_EVENT_TYPE_SRQ_CATAS_ERROR:
 	case MLX5_EVENT_TYPE_DCT_DRAINED:
 	case MLX5_EVENT_TYPE_COMP:
+	case MLX5_EVENT_TYPE_DCT_KEY_VIOLATION:
+	case MLX5_EVENT_TYPE_XRQ_ERROR:
 		return true;
 	default:
 		return false;
@@ -315,8 +317,10 @@ static u16 get_event_obj_type(unsigned long event_type, struct mlx5_eqe *eqe)
 	case MLX5_EVENT_TYPE_SRQ_CATAS_ERROR:
 		return eqe->data.qp_srq.type;
 	case MLX5_EVENT_TYPE_CQ_ERROR:
+	case MLX5_EVENT_TYPE_XRQ_ERROR:
 		return 0;
 	case MLX5_EVENT_TYPE_DCT_DRAINED:
+	case MLX5_EVENT_TYPE_DCT_KEY_VIOLATION:
 		return MLX5_EVENT_QUEUE_TYPE_DCT;
 	default:
 		return MLX5_GET(affiliated_event_header, &eqe->data, obj_type);
@@ -2300,7 +2304,11 @@ static u32 devx_get_obj_id_from_event(unsigned long event_type, void *data)
 	case MLX5_EVENT_TYPE_WQ_ACCESS_ERROR:
 		obj_id = be32_to_cpu(eqe->data.qp_srq.qp_srq_n) & 0xffffff;
 		break;
+	case MLX5_EVENT_TYPE_XRQ_ERROR:
+		obj_id = be32_to_cpu(eqe->data.xrq_err.type_xrqn) & 0xffffff;
+		break;
 	case MLX5_EVENT_TYPE_DCT_DRAINED:
+	case MLX5_EVENT_TYPE_DCT_KEY_VIOLATION:
 		obj_id = be32_to_cpu(eqe->data.dct.dctn) & 0xffffff;
 		break;
 	case MLX5_EVENT_TYPE_CQ_ERROR:
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index ce9839c8bc1a..e427af260ebe 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -328,6 +328,7 @@ enum mlx5_event {
 	MLX5_EVENT_TYPE_GPIO_EVENT	   = 0x15,
 	MLX5_EVENT_TYPE_PORT_MODULE_EVENT  = 0x16,
 	MLX5_EVENT_TYPE_TEMP_WARN_EVENT    = 0x17,
+	MLX5_EVENT_TYPE_XRQ_ERROR	   = 0x18,
 	MLX5_EVENT_TYPE_REMOTE_CONFIG	   = 0x19,
 	MLX5_EVENT_TYPE_GENERAL_EVENT	   = 0x22,
 	MLX5_EVENT_TYPE_MONITOR_COUNTER    = 0x24,
@@ -345,6 +346,7 @@ enum mlx5_event {
 	MLX5_EVENT_TYPE_ESW_FUNCTIONS_CHANGED = 0xe,
 
 	MLX5_EVENT_TYPE_DCT_DRAINED        = 0x1c,
+	MLX5_EVENT_TYPE_DCT_KEY_VIOLATION  = 0x1d,
 
 	MLX5_EVENT_TYPE_FPGA_ERROR         = 0x20,
 	MLX5_EVENT_TYPE_FPGA_QP_ERROR      = 0x21,
@@ -584,6 +586,12 @@ struct mlx5_eqe_cq_err {
 	u8	syndrome;
 };
 
+struct mlx5_eqe_xrq_err {
+	__be32	reserved1[5];
+	__be32	type_xrqn;
+	__be32	reserved2;
+};
+
 struct mlx5_eqe_port_state {
 	u8	reserved0[8];
 	u8	port;
@@ -698,6 +706,7 @@ union ev_data {
 	struct mlx5_eqe_pps		pps;
 	struct mlx5_eqe_dct             dct;
 	struct mlx5_eqe_temp_warning	temp_warning;
+	struct mlx5_eqe_xrq_err		xrq_err;
 } __packed;
 
 struct mlx5_eqe {
-- 
2.20.1

