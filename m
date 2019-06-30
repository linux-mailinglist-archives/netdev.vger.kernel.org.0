Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B07F25AECF
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 08:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfF3GGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 02:06:03 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35471 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726671AbfF3GGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 02:06:02 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 00EF4210AF;
        Sun, 30 Jun 2019 02:06:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 30 Jun 2019 02:06:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=oS0qVlY2sRDBJkAMh/QVzHWNOGXf6GIi8FjLTpZE5rc=; b=g01t7nwI
        OBKkjXZo8Nr61WuH1nxpx0Upue7sdV3D5UmAA12YRAN1ZSbUUd1bWygeKcCSgPpA
        6Jh4s1RfeIMPV1DzqSeu/FVy2EtYELaKUMrdh+tJmY2Vq04DCkKJNgxK18fuPbeD
        IU4JG9cnT2qCwGti89/6CWI4lIlFHlf2kj6Aj+9Vx04gEsKPJcwWvJ6ul3B7VYqH
        PWvIulZdioEgRvt+UkoV8x/tm0pF8hJ0E3nRlg5qHwD6KC6xzBF+BMljDgbytpbG
        QpwCH3cICrEugXPQ0ZRRvwjBQ1qsA5uEH5eNnX6VO+uxly8C0bZz3Fx52eNvfvaw
        bLGNdnLBVP/33g==
X-ME-Sender: <xms:SVEYXUuTxVMQVs1DjyiaEPx0RqUbHYMktdrrBw3nYaUfbTk4SJrlqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvdefgddutddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeeh
X-ME-Proxy: <xmx:SVEYXVvlwNJvljq5cISPoJ0Et_KPuw4CqDk-v4AvfAO1l93e-DYLIA>
    <xmx:SVEYXcsh_W23N1FQ_gku_7godePrgEjqRT-k6fMLb3rEelklTIToxg>
    <xmx:SVEYXV5G11Ub_P_zQ8_ig5iooREcd8T9SVD8vBUsPRywbo6njKmhDA>
    <xmx:SVEYXVjS6YghcUlaMWsn9-DsK8X-DRIef4jPN398k-51DACQhOxyyQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id CCD928005A;
        Sun, 30 Jun 2019 02:05:59 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 08/16] mlxsw: core: Add support for using SKB control buffer
Date:   Sun, 30 Jun 2019 09:04:52 +0300
Message-Id: <20190630060500.7882-9-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190630060500.7882-1-idosch@idosch.org>
References: <20190630060500.7882-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

The SKB control buffer is useful (and used) for bookkeeping of information
related to that SKB. Add helpers so that the mlxsw driver(s) can safely use
the buffer as well. The structure is currently empty, individual users will
add members to it as necessary.

Note that SKB allocation functions already clear the buffer, so the cleanup
is only necessary when ndo_start_xmit is called.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.h     | 9 +++++++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 2 ++
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c | 2 ++
 3 files changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 6dbb0ede502e..06babcc58c7a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -418,4 +418,13 @@ enum mlxsw_devlink_param_id {
 	MLXSW_DEVLINK_PARAM_ID_ACL_REGION_REHASH_INTERVAL,
 };
 
+struct mlxsw_skb_cb {
+};
+
+static inline struct mlxsw_skb_cb *mlxsw_skb_cb(struct sk_buff *skb)
+{
+	BUILD_BUG_ON(sizeof(mlxsw_skb_cb) > sizeof(skb->cb));
+	return (struct mlxsw_skb_cb *) skb->cb;
+}
+
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 84f4077b4b37..a0376d4f94a8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -790,6 +790,8 @@ static netdev_tx_t mlxsw_sp_port_xmit(struct sk_buff *skb,
 	u64 len;
 	int err;
 
+	memset(skb->cb, 0, sizeof(struct mlxsw_skb_cb));
+
 	if (mlxsw_core_skb_transmit_busy(mlxsw_sp->core, &tx_info))
 		return NETDEV_TX_BUSY;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
index fc4f19167262..bdab96f5bc70 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -299,6 +299,8 @@ static netdev_tx_t mlxsw_sx_port_xmit(struct sk_buff *skb,
 	u64 len;
 	int err;
 
+	memset(skb->cb, 0, sizeof(struct mlxsw_skb_cb));
+
 	if (mlxsw_core_skb_transmit_busy(mlxsw_sx->core, &tx_info))
 		return NETDEV_TX_BUSY;
 
-- 
2.20.1

