Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889644A6B39
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 06:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244733AbiBBFG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 00:06:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234013AbiBBFGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 00:06:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A992BC06174E
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 21:06:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70CD0B83009
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 05:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA57FC004E1;
        Wed,  2 Feb 2022 05:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643778397;
        bh=8WrPCVsHGNIxbC1SohTfKrKAP6GU+VRL3s4moqklJTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tUVA4QT0H1RiNJ9fkysUhTVJS+dSG/q/mmr57BzAnXebxWWnNsjHM2K/TT+DPaLCs
         ofwXYyYL0sT0nwn/Y7Joyhp3bqAhrsN+JH20/T1xWOgAn/2GYwKlahIoTRbGhLI7LO
         ITO0gSQ/WhbZA6h0bf+tUxm8XvuOh7XmiaD7uUvn/kWje6Q7J+XIdcT0Le83TRfTq1
         z+F/f8P77n1a1elXTCIgV6oQmYfyS8KzQqVlCDGqa/yXhvkocrmYUfa3wzwKYRp6g6
         cms7YfFGoa/J0npg8ixDVYvYeXWx1FrhYAyE5v3hLs1tcW4bqO0k2KOkMp/gV+dSDD
         M1DmKhNPrpozg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Khalid Manaa <khalidm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 09/18] net/mlx5e: Fix wrong calculation of header index in HW_GRO
Date:   Tue,  1 Feb 2022 21:03:55 -0800
Message-Id: <20220202050404.100122-10-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220202050404.100122-1-saeed@kernel.org>
References: <20220202050404.100122-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Khalid Manaa <khalidm@nvidia.com>

The HW doesn't wrap the CQE.shampo.header_index field according to the
headers buffer size, instead it always increases it until reaching overflow
of u16 size.

Thus the mlx5e_handle_rx_cqe_mpwrq_shampo handler should mask the
CQE header_index field to find the actual header index in the headers buffer.

Fixes: f97d5c2a453e ("net/mlx5e: Add handle SHAMPO cqe support")
Signed-off-by: Khalid Manaa <khalidm@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h | 5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   | 4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 4cdf8e5b24c2..b789af07829c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -167,6 +167,11 @@ static inline u16 mlx5e_txqsq_get_next_pi(struct mlx5e_txqsq *sq, u16 size)
 	return pi;
 }
 
+static inline u16 mlx5e_shampo_get_cqe_header_index(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
+{
+	return be16_to_cpu(cqe->shampo.header_entry_index) & (rq->mpwqe.shampo->hd_per_wq - 1);
+}
+
 struct mlx5e_shampo_umr {
 	u16 len;
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index e86ccc22fb82..3a79ecd38003 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1117,7 +1117,7 @@ static void mlx5e_shampo_update_ipv6_udp_hdr(struct mlx5e_rq *rq, struct ipv6hdr
 static void mlx5e_shampo_update_fin_psh_flags(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 					      struct tcphdr *skb_tcp_hd)
 {
-	u16 header_index = be16_to_cpu(cqe->shampo.header_entry_index);
+	u16 header_index = mlx5e_shampo_get_cqe_header_index(rq, cqe);
 	struct tcphdr *last_tcp_hd;
 	void *last_hd_addr;
 
@@ -1973,7 +1973,7 @@ mlx5e_free_rx_shampo_hd_entry(struct mlx5e_rq *rq, u16 header_index)
 static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 {
 	u16 data_bcnt		= mpwrq_get_cqe_byte_cnt(cqe) - cqe->shampo.header_size;
-	u16 header_index	= be16_to_cpu(cqe->shampo.header_entry_index);
+	u16 header_index	= mlx5e_shampo_get_cqe_header_index(rq, cqe);
 	u32 wqe_offset		= be32_to_cpu(cqe->shampo.data_offset);
 	u16 cstrides		= mpwrq_get_cqe_consumed_strides(cqe);
 	u32 data_offset		= wqe_offset & (PAGE_SIZE - 1);
-- 
2.34.1

