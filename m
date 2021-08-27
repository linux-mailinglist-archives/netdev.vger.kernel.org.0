Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572BF3F91AE
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 03:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244143AbhH0A7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 20:59:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244060AbhH0A7E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 20:59:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34066610A3;
        Fri, 27 Aug 2021 00:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630025896;
        bh=D17zNr1ZaPvOeAayzx8Tp95Y+d2V8s7MliarCe21NyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R3GFIpCE0+hL3J87xxSr/dy/HIYpMGcW7L0icKDH+ZS4rZwNWw2Drz+z1EYfdXtN1
         PCtpkJ73jX/ef1Gf+Vsd6oC/GZJDYmOrVtQRZMNmi3V6uoQQU+Y5tdiHw9KRtjw4NG
         5JUv/7aqK5WmjpAf4ZEfDaFaVzNIP8Ki9LBtZz7YtV9MkjCPRJt5VXjBCn4WX+59kZ
         7FaS9Ci8JkZu7YLFrTQOaK6vYt01ZL6xzvb5ywipVD71iFplxKPeKz6XkqDUlmTLgA
         M+Unvkjzer5QPyn0jW2K7YIjH3N3sKcGC/YMSIHcVvFmE3BEX0dTkc4DA9HqI/XICr
         PkRzw0jbX0ilQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/17] net/mlx5: DR, Enable QP retransmission
Date:   Thu, 26 Aug 2021 17:57:49 -0700
Message-Id: <20210827005802.236119-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827005802.236119-1-saeed@kernel.org>
References: <20210827005802.236119-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Under high stress, SW steering might get stuck on polling for completion
that never comes.
For such cases QP needs to have protocol retransmission mechanism enabled.
Currently the retransmission timeout is defined as 0 (unlimited). Fix this
by defining a real timeout.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 8a1623a4d8bc..24f40e17f176 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -620,6 +620,7 @@ static int dr_cmd_modify_qp_rtr2rts(struct mlx5_core_dev *mdev,
 
 	MLX5_SET(qpc, qpc, retry_count, attr->retry_cnt);
 	MLX5_SET(qpc, qpc, rnr_retry, attr->rnr_retry);
+	MLX5_SET(qpc, qpc, primary_address_path.ack_timeout, 0x8); /* ~1ms */
 
 	MLX5_SET(rtr2rts_qp_in, in, opcode, MLX5_CMD_OP_RTR2RTS_QP);
 	MLX5_SET(rtr2rts_qp_in, in, qpn, dr_qp->qpn);
-- 
2.31.1

