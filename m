Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC947334767
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbhCJTEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:04:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:44300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233723AbhCJTDz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 14:03:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB8BB64FD3;
        Wed, 10 Mar 2021 19:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615403035;
        bh=vWKCxkdlG/VxjJdSvPNM52aYuPBtHXpYMFFydwDAf8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PseMnWMoZsSMe+WkdsChB4rmTykCe6YjoNvruKLAZDZZt2Hu/17PUeSdkh///hqR8
         Ia3ckTlo8SgT4rdxo5v2vcfb1jVYe8iIsNauFlqp+og0fhuxp7kP+n2jOXedyzPTzJ
         2M41+kZZG7KoqWQdj3gem6UX1KckEjRQm4QZsDGDUFagDUgpfWpNzuZEu+rgJMkugo
         AzWX1Q9QlErzodKhAhZwYV6Sxnvwuu1oT6tTVn009fDkS6MTZBuTpdHChWZ+i9ZscX
         cTbtkUUr52VxoXnZkn9ES66qsq38figwSMfamttJ/HPNZoe9pREkO5nsUxKEwKCJ/5
         pKzsQ/k3P+hyw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Aya Levin <ayal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 04/18] net/mlx5e: Set PTP channel pointer explicitly to NULL
Date:   Wed, 10 Mar 2021 11:03:28 -0800
Message-Id: <20210310190342.238957-5-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310190342.238957-1-saeed@kernel.org>
References: <20210310190342.238957-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

When closing the PTP channel, set its pointer explicitly to NULL. PTP
channel is opened on demand, the code verify the pointer validity before
access. Nullify it when closing the PTP channel to avoid unexpected
behavior.

Fixes: 145e5637d941 ("net/mlx5e: Add TX PTP port object support")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 9e2a30dc5e4f..66d23cd275c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2503,8 +2503,10 @@ void mlx5e_close_channels(struct mlx5e_channels *chs)
 {
 	int i;
 
-	if (chs->port_ptp)
+	if (chs->port_ptp) {
 		mlx5e_port_ptp_close(chs->port_ptp);
+		chs->port_ptp = NULL;
+	}
 
 	for (i = 0; i < chs->num; i++)
 		mlx5e_close_channel(chs->c[i]);
-- 
2.29.2

