Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59685583E9
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 15:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfF0Nx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 09:53:57 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:36643 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727042AbfF0Nxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 09:53:53 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 70E9421FE2;
        Thu, 27 Jun 2019 09:53:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 27 Jun 2019 09:53:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=oS0qVlY2sRDBJkAMh/QVzHWNOGXf6GIi8FjLTpZE5rc=; b=YmWtAt3o
        Ayiuw0nUCoX9n0Ux4bFDVoH0ZFRQXIEsMcOsU/+Zsh10/awP9UvnURu7BV0Oo2Rs
        TYDW4I3Jkemo0op+1Q12Hb/zCkKKxDY6CMnwKuVtwhab6QatTnPxtCsCLbE06ip0
        gRgRA1hZskXKet2ymz7GbsXH++bi3/w3lwnv3bDY4YV+YYM6s/cWqN6PKeHgD9uD
        LaPD7kLly6ymhXiGM9jRK0kHpbizqONAS6SBRmZfvph+U/8wRTHG03W2goq90iNR
        OqiM5s7rdhBWDmaHG9PBuKmgmwadLnGsTnJ//O8HO2ntA0fSNDn7J1+VvoyAliXa
        Bt7IhqoTw7r2tA==
X-ME-Sender: <xms:cMoUXf2lOwqRzOWftAm6_niIayYlW_jCOdHkFK2rOcjUFzduvCoHgw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudekgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepge
X-ME-Proxy: <xmx:cMoUXUj9Km1ndUjvT6kVcXV_kldcA-DfNwTRqiP42rjJiKTZdd37ZA>
    <xmx:cMoUXYu-a9eBbD74zqWi4Qxy5DjHvKqtWFAJqwG7qcsW6s5x8LJ8Ig>
    <xmx:cMoUXUH35CjAugk4llMRY9B7F_Evj2M0CfAWmcm3v7WTS7n5ZwBOEQ>
    <xmx:cMoUXe1TF1RinugraTG8uGsXmxO7h3844TvHEjQCVkhXqXnoHba5lQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id ECDCA8005A;
        Thu, 27 Jun 2019 09:53:50 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 08/16] mlxsw: core: Add support for using SKB control buffer
Date:   Thu, 27 Jun 2019 16:52:51 +0300
Message-Id: <20190627135259.7292-9-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627135259.7292-1-idosch@idosch.org>
References: <20190627135259.7292-1-idosch@idosch.org>
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

