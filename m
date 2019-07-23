Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74E51712BB
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 09:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388303AbfGWHXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 03:23:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728016AbfGWHXC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 03:23:02 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C294822AEC;
        Tue, 23 Jul 2019 07:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563866581;
        bh=wU4/iPEw0pZRwXCljJOSQsbI+bpHixzXcTw9rApQzdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WojDOJWiCjLUds0v6zLl2Z+8xhSLHx8u6Lpbuj9DtQS+6wVDvSJbAlWygNdNQHrpe
         dsjsisXQ+96yC2BwiZcXzLbSiwe493LCC3wzdwgwNG6m1PysX4ATwGk6QXEFSFHkhi
         o1wPqUTsNXsNa6GdUYItFNVcnQg0zL2d1AjYFvuY=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Tal Gilboa <talgi@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH net 2/2] lib/dim: Fix -Wunused-const-variable warnings
Date:   Tue, 23 Jul 2019 10:22:48 +0300
Message-Id: <20190723072248.6844-3-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190723072248.6844-1-leon@kernel.org>
References: <20190723072248.6844-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

DIM causes to the following warnings during kernel compilation
which indicates that tx_profile and rx_profile are supposed to
be declared in *.c and not in *.h files.

In file included from ./include/rdma/ib_verbs.h:64,
                 from ./include/linux/mlx5/device.h:37,
                 from ./include/linux/mlx5/driver.h:51,
                 from ./include/linux/mlx5/vport.h:36,
                 from drivers/infiniband/hw/mlx5/ib_virt.c:34:
./include/linux/dim.h:326:1: warning: _tx_profile_ defined but not used [-Wunused-const-variable=]
  326 | tx_profile[DIM_CQ_PERIOD_NUM_MODES][NET_DIM_PARAMS_NUM_PROFILES] = {
      | ^~~~~~~~~~
./include/linux/dim.h:320:1: warning: _rx_profile_ defined but not used [-Wunused-const-variable=]
  320 | rx_profile[DIM_CQ_PERIOD_NUM_MODES][NET_DIM_PARAMS_NUM_PROFILES] = {
      | ^~~~~~~~~~

Fixes: 4f75da3666c0 ("linux/dim: Move implementation to .c files")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/dim.h | 56 ---------------------------------------------
 lib/dim/net_dim.c   | 56 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 56 deletions(-)

diff --git a/include/linux/dim.h b/include/linux/dim.h
index d3a0fbfff2bb..9fa4b3f88c39 100644
--- a/include/linux/dim.h
+++ b/include/linux/dim.h
@@ -272,62 +272,6 @@ dim_update_sample_with_comps(u16 event_ctr, u64 packets, u64 bytes, u64 comps,

 /* Net DIM */

-/*
- * Net DIM profiles:
- *        There are different set of profiles for each CQ period mode.
- *        There are different set of profiles for RX/TX CQs.
- *        Each profile size must be of NET_DIM_PARAMS_NUM_PROFILES
- */
-#define NET_DIM_PARAMS_NUM_PROFILES 5
-#define NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE 256
-#define NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE 128
-#define NET_DIM_DEF_PROFILE_CQE 1
-#define NET_DIM_DEF_PROFILE_EQE 1
-
-#define NET_DIM_RX_EQE_PROFILES { \
-	{1,   NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
-	{8,   NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
-	{64,  NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
-	{128, NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
-	{256, NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
-}
-
-#define NET_DIM_RX_CQE_PROFILES { \
-	{2,  256},             \
-	{8,  128},             \
-	{16, 64},              \
-	{32, 64},              \
-	{64, 64}               \
-}
-
-#define NET_DIM_TX_EQE_PROFILES { \
-	{1,   NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
-	{8,   NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
-	{32,  NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
-	{64,  NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
-	{128, NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE}   \
-}
-
-#define NET_DIM_TX_CQE_PROFILES { \
-	{5,  128},  \
-	{8,  64},  \
-	{16, 32},  \
-	{32, 32},  \
-	{64, 32}   \
-}
-
-static const struct dim_cq_moder
-rx_profile[DIM_CQ_PERIOD_NUM_MODES][NET_DIM_PARAMS_NUM_PROFILES] = {
-	NET_DIM_RX_EQE_PROFILES,
-	NET_DIM_RX_CQE_PROFILES,
-};
-
-static const struct dim_cq_moder
-tx_profile[DIM_CQ_PERIOD_NUM_MODES][NET_DIM_PARAMS_NUM_PROFILES] = {
-	NET_DIM_TX_EQE_PROFILES,
-	NET_DIM_TX_CQE_PROFILES,
-};
-
 /**
  *	net_dim_get_rx_moderation - provide a CQ moderation object for the given RX profile
  *	@cq_period_mode: CQ period mode
diff --git a/lib/dim/net_dim.c b/lib/dim/net_dim.c
index 5bcc902c5388..a4db51c21266 100644
--- a/lib/dim/net_dim.c
+++ b/lib/dim/net_dim.c
@@ -5,6 +5,62 @@

 #include <linux/dim.h>

+/*
+ * Net DIM profiles:
+ *        There are different set of profiles for each CQ period mode.
+ *        There are different set of profiles for RX/TX CQs.
+ *        Each profile size must be of NET_DIM_PARAMS_NUM_PROFILES
+ */
+#define NET_DIM_PARAMS_NUM_PROFILES 5
+#define NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE 256
+#define NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE 128
+#define NET_DIM_DEF_PROFILE_CQE 1
+#define NET_DIM_DEF_PROFILE_EQE 1
+
+#define NET_DIM_RX_EQE_PROFILES { \
+	{1,   NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
+	{8,   NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
+	{64,  NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
+	{128, NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
+	{256, NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
+}
+
+#define NET_DIM_RX_CQE_PROFILES { \
+	{2,  256},             \
+	{8,  128},             \
+	{16, 64},              \
+	{32, 64},              \
+	{64, 64}               \
+}
+
+#define NET_DIM_TX_EQE_PROFILES { \
+	{1,   NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
+	{8,   NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
+	{32,  NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
+	{64,  NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
+	{128, NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE}   \
+}
+
+#define NET_DIM_TX_CQE_PROFILES { \
+	{5,  128},  \
+	{8,  64},  \
+	{16, 32},  \
+	{32, 32},  \
+	{64, 32}   \
+}
+
+static const struct dim_cq_moder
+rx_profile[DIM_CQ_PERIOD_NUM_MODES][NET_DIM_PARAMS_NUM_PROFILES] = {
+	NET_DIM_RX_EQE_PROFILES,
+	NET_DIM_RX_CQE_PROFILES,
+};
+
+static const struct dim_cq_moder
+tx_profile[DIM_CQ_PERIOD_NUM_MODES][NET_DIM_PARAMS_NUM_PROFILES] = {
+	NET_DIM_TX_EQE_PROFILES,
+	NET_DIM_TX_CQE_PROFILES,
+};
+
 struct dim_cq_moder
 net_dim_get_rx_moderation(u8 cq_period_mode, int ix)
 {
--
2.20.1

