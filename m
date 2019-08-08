Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6A985D20
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 10:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731493AbfHHIoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 04:44:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730678AbfHHIoJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 04:44:09 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35C152173C;
        Thu,  8 Aug 2019 08:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565253848;
        bh=NZNTcb5u7zKUtGMPcMt7y9ZPwP2CnSNSshE7gew5V6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PPSX9zJ+2pBK8Uq1vjXs7tqT2oHQZWIiKMjdawMFDHW6DM3xsAA3zsHoPpv9hgXQz
         Kl8IEY5d+Vr3rAoe/iMIqbLiaoSWGRct/M68qLKespPh4ORP+l0IXu109nOswJRDDP
         Be03q2hmQDt8xdcnyE7gizE++TNgnA8US7iK1PVs=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Edward Srouji <edwards@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 2/4] net/mlx5: Add XRQ legacy commands opcodes
Date:   Thu,  8 Aug 2019 11:43:56 +0300
Message-Id: <20190808084358.29517-3-leon@kernel.org>
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

Add XRQ legacy commands opcodes, will be used via the DEVX interface.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 4 ++++
 include/linux/mlx5/mlx5_ifc.h                 | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 8cdd7e66f8df..53d09620e215 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -446,6 +446,8 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_CREATE_UMEM:
 	case MLX5_CMD_OP_DESTROY_UMEM:
 	case MLX5_CMD_OP_ALLOC_MEMIC:
+	case MLX5_CMD_OP_MODIFY_XRQ:
+	case MLX5_CMD_OP_RELEASE_XRQ_ERROR:
 		*status = MLX5_DRIVER_STATUS_ABORTED;
 		*synd = MLX5_DRIVER_SYND;
 		return -EIO;
@@ -637,6 +639,8 @@ const char *mlx5_command_str(int command)
 	MLX5_COMMAND_STR_CASE(DESTROY_UCTX);
 	MLX5_COMMAND_STR_CASE(CREATE_UMEM);
 	MLX5_COMMAND_STR_CASE(DESTROY_UMEM);
+	MLX5_COMMAND_STR_CASE(RELEASE_XRQ_ERROR);
+	MLX5_COMMAND_STR_CASE(MODIFY_XRQ);
 	default: return "unknown command opcode";
 	}
 }
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 82470b670cb7..080bba20b129 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -172,6 +172,8 @@ enum {
 	MLX5_CMD_OP_QUERY_XRQ_DC_PARAMS_ENTRY     = 0x725,
 	MLX5_CMD_OP_SET_XRQ_DC_PARAMS_ENTRY       = 0x726,
 	MLX5_CMD_OP_QUERY_XRQ_ERROR_PARAMS        = 0x727,
+	MLX5_CMD_OP_RELEASE_XRQ_ERROR             = 0x729,
+	MLX5_CMD_OP_MODIFY_XRQ                    = 0x72a,
 	MLX5_CMD_OP_QUERY_ESW_FUNCTIONS           = 0x740,
 	MLX5_CMD_OP_QUERY_VPORT_STATE             = 0x750,
 	MLX5_CMD_OP_MODIFY_VPORT_STATE            = 0x751,
-- 
2.20.1

