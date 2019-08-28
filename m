Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0664A06AE
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 17:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbfH1PzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 11:55:07 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:59113 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726513AbfH1PzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 11:55:06 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 731F42211E;
        Wed, 28 Aug 2019 11:55:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 28 Aug 2019 11:55:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=IqLJQFGN1ml47RjwLCM6K+cmUOxR03Jn2Clbz75MdFE=; b=ZnelYxai
        84uMKpQTKoJ1l2vgeLmbAW8fztVzBVupPRJA/AM2BUXfaDbF4jCzJAp+us5n00Ir
        JKbKaD2mzfCubmOPXKSGzrmFxTM6O/pw9zf/9ccFDaS92qFdRaHpaDbDhomNojkT
        x+Ul103lPz+6VYkYgwYSlQRyywKphXY12JEl8NpIX/24JmbMSM92n+aFcsSgY1zM
        tlc6IYA1cuzKZoaRsJt5qJ0VD3UBbHDs6fCPpZynkhVCRfGqmoCUOKvyN7Azkdvr
        UCYCdFnnN4TSvnjAFuYjXbJHRYw4dhdeQUbXLQ7rUUXGNV3NArrff2ktT8OoSpjp
        h9dJ15UIIeRXxg==
X-ME-Sender: <xms:2aNmXcRbNHHckB8mBsHum3Y9B_OPm_79A0qyjzSWxnEFbb7Q8594cg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeitddgleegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:2aNmXc96Ssz7IdXu-iKnaD49xwhA_-QnAIUodeIDmcGoB8ZDF9q6nw>
    <xmx:2aNmXV9gOhptDnIrk8w4jpnrCpxR6rb-N1TxgZ7P2vOeaBh5-25KvQ>
    <xmx:2aNmXadmzFkJB_SGhs3UwRx1c3D6S6CZcmLrPdw5PSiHe8wBXEiA9Q>
    <xmx:2aNmXXd5MgFw9uAluRhuJU2CRTUp8edx4btLiDJWFOQrgROpZD2FsA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 18042D60057;
        Wed, 28 Aug 2019 11:55:03 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Amit Cohen <amitc@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/4] mlxsw: Remove 56G speed support
Date:   Wed, 28 Aug 2019 18:54:34 +0300
Message-Id: <20190828155437.9852-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828155437.9852-1-idosch@idosch.org>
References: <20190828155437.9852-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Commit 275e928f1911 ("mlxsw: spectrum: Prevent force of 56G") prevented
the driver from setting a speed of 56G when auto-negotiation is off.
This is the only speed supported by mlxsw that cannot be set when
auto-negotiation is off, which makes it difficult to write generic
tests.

Further, the speed is not supported by newer ASICs such as Spectrum-2
and to the best of our knowledge it is not used by current users.

Therefore, remove 56G support from mlxsw.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  1 -
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 24 -------------------
 .../net/ethernet/mellanox/mlxsw/switchx2.c    |  6 -----
 3 files changed, 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index baa20cdd65df..5494cf93f34c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -4126,7 +4126,6 @@ MLXSW_ITEM32(reg, ptys, ext_eth_proto_cap, 0x08, 0, 32);
 #define MLXSW_REG_PTYS_ETH_SPEED_20GBASE_KR2		BIT(5)
 #define MLXSW_REG_PTYS_ETH_SPEED_40GBASE_CR4		BIT(6)
 #define MLXSW_REG_PTYS_ETH_SPEED_40GBASE_KR4		BIT(7)
-#define MLXSW_REG_PTYS_ETH_SPEED_56GBASE_R4		BIT(8)
 #define MLXSW_REG_PTYS_ETH_SPEED_10GBASE_CR		BIT(12)
 #define MLXSW_REG_PTYS_ETH_SPEED_10GBASE_SR		BIT(13)
 #define MLXSW_REG_PTYS_ETH_SPEED_10GBASE_ER_LR		BIT(14)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 7de9833fc60b..4d1f8b9c46a7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2608,26 +2608,6 @@ static const struct mlxsw_sp1_port_link_mode mlxsw_sp1_port_link_mode[] = {
 		.mask_ethtool	= ETHTOOL_LINK_MODE_50000baseSR2_Full_BIT,
 		.speed		= SPEED_50000,
 	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_56GBASE_R4,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_56000baseKR4_Full_BIT,
-		.speed		= SPEED_56000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_56GBASE_R4,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_56000baseCR4_Full_BIT,
-		.speed		= SPEED_56000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_56GBASE_R4,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_56000baseSR4_Full_BIT,
-		.speed		= SPEED_56000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_56GBASE_R4,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_56000baseLR4_Full_BIT,
-		.speed		= SPEED_56000,
-	},
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_100GBASE_CR4,
 		.mask_ethtool	= ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
@@ -3301,10 +3281,6 @@ mlxsw_sp_port_set_link_ksettings(struct net_device *dev,
 	ops->reg_ptys_eth_unpack(mlxsw_sp, ptys_pl, &eth_proto_cap, NULL, NULL);
 
 	autoneg = cmd->base.autoneg == AUTONEG_ENABLE;
-	if (!autoneg && cmd->base.speed == SPEED_56000) {
-		netdev_err(dev, "56G not supported with autoneg off\n");
-		return -EINVAL;
-	}
 	eth_proto_new = autoneg ?
 		ops->to_ptys_advert_link(mlxsw_sp, cmd) :
 		ops->to_ptys_speed(mlxsw_sp, cmd->base.speed);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
index bdab96f5bc70..1c14c051ee52 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -636,12 +636,6 @@ static const struct mlxsw_sx_port_link_mode mlxsw_sx_port_link_mode[] = {
 				  MLXSW_REG_PTYS_ETH_SPEED_50GBASE_KR2,
 		.speed		= 50000,
 	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_56GBASE_R4,
-		.supported	= SUPPORTED_56000baseKR4_Full,
-		.advertised	= ADVERTISED_56000baseKR4_Full,
-		.speed		= 56000,
-	},
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_100GBASE_CR4 |
 				  MLXSW_REG_PTYS_ETH_SPEED_100GBASE_SR4 |
-- 
2.21.0

