Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10EF2738D5
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 04:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729024AbgIVCrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 22:47:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:57976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728854AbgIVCrk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 22:47:40 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 925772396D;
        Tue, 22 Sep 2020 02:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600742860;
        bh=I1qCc0bHPaOJf/KIe3ivPbT/e+nHrHq2bchrh7WEDDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZUGodu/OiiKdwxI2lZCWi2eZN8g1n/EUGZ+kfSn3jdT418Eh3V9DR4H/lR+rzm266
         Sts+TWcOkZUo7PY9fQuekZ9yupnApUXdnLlxahuR3sNxv49dndsvZOKCxfXpQnLBjU
         Yr7NB+XQzI0MtFLdPFSqWQQf0Ynf9MAcWeW1O1kk=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V3 01/12] net/mlx5e: Refactor inline header size calculation in the TX path
Date:   Mon, 21 Sep 2020 19:46:53 -0700
Message-Id: <20200922024704.544482-2-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200922024704.544482-1-saeed@kernel.org>
References: <20200922024704.544482-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

As preparation for the next patch, don't increase ihs to calculate
ds_cnt and then decrease it, but rather calculate the intermediate value
temporarily. This code has the same amount of arithmetic operations, but
now allows to split out ds_cnt calculation, which will be performed in
the next patch.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index da596de3abba..e15aa53ff83e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -307,9 +307,9 @@ void mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	ds_cnt += skb_shinfo(skb)->nr_frags;
 
 	if (ihs) {
-		ihs += !!skb_vlan_tag_present(skb) * VLAN_HLEN;
+		u16 inl = ihs + !!skb_vlan_tag_present(skb) * VLAN_HLEN - INL_HDR_START_SZ;
 
-		ds_cnt_inl = DIV_ROUND_UP(ihs - INL_HDR_START_SZ, MLX5_SEND_WQE_DS);
+		ds_cnt_inl = DIV_ROUND_UP(inl, MLX5_SEND_WQE_DS);
 		ds_cnt += ds_cnt_inl;
 	}
 
@@ -348,12 +348,12 @@ void mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	eseg->mss = mss;
 
 	if (ihs) {
-		eseg->inline_hdr.sz = cpu_to_be16(ihs);
 		if (skb_vlan_tag_present(skb)) {
-			ihs -= VLAN_HLEN;
+			eseg->inline_hdr.sz = cpu_to_be16(ihs + VLAN_HLEN);
 			mlx5e_insert_vlan(eseg->inline_hdr.start, skb, ihs);
 			stats->added_vlan_packets++;
 		} else {
+			eseg->inline_hdr.sz = cpu_to_be16(ihs);
 			memcpy(eseg->inline_hdr.start, skb->data, ihs);
 		}
 		dseg += ds_cnt_inl;
-- 
2.26.2

