Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA75C453F8B
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 05:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbhKQEhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 23:37:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:41490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233084AbhKQEhH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 23:37:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D41EA613A2;
        Wed, 17 Nov 2021 04:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637123649;
        bh=/QWsJdm9P/gzLtpcchtBuSjP8/VuvdlsIhZ1cDIlVF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TsyLJ/uFXW+w+4CmPGdZ2La9iSULHWY4qNg9ezt6bO0d9JWuDZApjis5NpAl2qR25
         gw2I20YGGSK85Y389u8kifkSHcKWNsCLMvZTK4aK4gUZSGSnYNn6EzSAdjSHX4zGr2
         BEabXxuRU34eas+cCGBbJPRLLByhB5iWdoVe+aZ4fNZ7Tk1Xij0y8kWKID5YogUQ1i
         QNhLr/LYJj2uZJHRJfeCQfIym/C2KjDnRjhiOZlq694g7bFJqznDkW8/zpNitZBfaG
         OzvRtVDRhmgBQQrLzn+AgWQ5SmTPWegF5Sj6/N5FdRV2vpr0erhyEGaaThqEaqdEbF
         CalueyOqRQWCw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yihao Han <hanyihao@vivo.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 06/15] net/mlx5: TC, using swap() instead of tmp variable
Date:   Tue, 16 Nov 2021 20:33:48 -0800
Message-Id: <20211117043357.345072-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211117043357.345072-1-saeed@kernel.org>
References: <20211117043357.345072-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yihao Han <hanyihao@vivo.com>

swap() was used instead of the tmp variable to swap values

Signed-off-by: Yihao Han <hanyihao@vivo.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index f89a4c7a4f71..9a31f45a9d9b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -907,12 +907,9 @@ mlx5_tc_ct_shared_counter_get(struct mlx5_tc_ct_priv *ct_priv,
 	struct mlx5_ct_tuple rev_tuple = entry->tuple;
 	struct mlx5_ct_counter *shared_counter;
 	struct mlx5_ct_entry *rev_entry;
-	__be16 tmp_port;
 
 	/* get the reversed tuple */
-	tmp_port = rev_tuple.port.src;
-	rev_tuple.port.src = rev_tuple.port.dst;
-	rev_tuple.port.dst = tmp_port;
+	swap(rev_tuple.port.src, rev_tuple.port.dst);
 
 	if (rev_tuple.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
 		__be32 tmp_addr = rev_tuple.ip.src_v4;
-- 
2.31.1

