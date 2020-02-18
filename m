Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32552163382
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgBRUxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 15:53:04 -0500
Received: from gateway23.websitewelcome.com ([192.185.49.124]:43883 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726612AbgBRUxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 15:53:04 -0500
X-Greylist: delayed 1370 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Feb 2020 15:53:03 EST
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 8EF85F250
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 14:28:34 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 49TujkZDtEfyq49TujsbIz; Tue, 18 Feb 2020 14:28:34 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=yNvO5nQCXupbNxiTPEhF0b9Zhr1y/1EPEHY68gcTols=; b=HVA6K5DSwDnJ2wcNKVGN3ndT0+
        xc5xOSjwtCEZsZmQQmmjETJfq6qMBzKdcBIHg1zljNkFqd2mZseSt4k+zQXolEkMVY29c3MeUEBkC
        yMTuTU/+H3c4SkQ53ncAIHJtGWAQESRUWY7DkvbzKzob8Xbnzo9NxQF8EfuXNGQoX4X4biy5S5JJl
        jYSNVYBo8dW1FM2POANAJb9sA3mTH5eKNrBPtgplqR/O39q+vuJtyBpnZHhpaOfSXxhv3T5GGNL1U
        tWjfBQbKDQdmrsbEhyDxiVQJWAkI4KOzvLpVvr3MvJPQTGHnhLd1PSD6Qv/Dyv3vHajRiCb5rgi6A
        tq/Gkl9g==;
Received: from [200.68.140.26] (port=8034 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j49Tr-000H4c-J9; Tue, 18 Feb 2020 14:28:31 -0600
Date:   Tue, 18 Feb 2020 14:31:14 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Boris Pismenny <borisp@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net/mlx5e: Replace zero-length array with
 flexible-array member
Message-ID: <20200218203114.GA27096@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 200.68.140.26
X-Source-L: No
X-Exim-ID: 1j49Tr-000H4c-J9
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.68.140.26]:8034
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 12
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h          | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c  | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 220ef9f06f84..a960099cd7aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -204,7 +204,7 @@ struct mlx5e_tx_wqe {
 
 struct mlx5e_rx_wqe_ll {
 	struct mlx5_wqe_srq_next_seg  next;
-	struct mlx5_wqe_data_seg      data[0];
+	struct mlx5_wqe_data_seg      data[];
 };
 
 struct mlx5e_rx_wqe_cyc {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
index 4c61d25d2e88..b794888fa3ba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
@@ -57,7 +57,7 @@ struct mlx5_fpga_ipsec_cmd_context {
 	struct completion complete;
 	struct mlx5_fpga_device *dev;
 	struct list_head list; /* Item in pending_cmds */
-	u8 command[0];
+	u8 command[];
 };
 
 struct mlx5_fpga_esp_xfrm;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
index ab69effb056d..f43caefd07a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
@@ -470,7 +470,7 @@ struct mlx5_fc_bulk {
 	u32 base_id;
 	int bulk_len;
 	unsigned long *bitmask;
-	struct mlx5_fc fcs[0];
+	struct mlx5_fc fcs[];
 };
 
 static void mlx5_fc_init(struct mlx5_fc *counter, struct mlx5_fc_bulk *bulk,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
index c87962cab921..de7e01a027bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
@@ -56,7 +56,7 @@ struct mlx5i_priv {
 	u32    qkey;
 	u16    pkey_index;
 	struct mlx5i_pkey_qpn_ht *qpn_htbl;
-	char  *mlx5e_priv[0];
+	char  *mlx5e_priv[];
 };
 
 int mlx5i_create_tis(struct mlx5_core_dev *mdev, u32 underlay_qpn, u32 *tisn);
@@ -107,7 +107,7 @@ struct mlx5i_tx_wqe {
 	struct mlx5_wqe_datagram_seg datagram;
 	struct mlx5_wqe_eth_pad      pad;
 	struct mlx5_wqe_eth_seg      eth;
-	struct mlx5_wqe_data_seg     data[0];
+	struct mlx5_wqe_data_seg     data[];
 };
 
 static inline void mlx5i_sq_fetch_wqe(struct mlx5e_txqsq *sq,
-- 
2.25.0

