Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED52B210DCB
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 16:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731539AbgGAOde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 10:33:34 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:51369 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730852AbgGAOdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 10:33:33 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 311A55801C9;
        Wed,  1 Jul 2020 10:33:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 01 Jul 2020 10:33:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=m+dQ/jpzyNeWzyaL4ZdzLM6JDCSZfctQGAth1HeHczo=; b=YgFaQ4rS
        QPuFr/anGqR3HYy7QItYo23/hCyVlYkKfK+sHobEruwLKFgZ3C0NXDfxuP7SD+tx
        oyfwOCbC/ppicFuAMdQnlEBc9PsCn9KkkAOvzQtA4vudL+fuDuWucNGa9HNd+zCb
        Kg8D49TIN+GxJUxVQrY+KNn3ibF9XKyTcDdv7tLhoq2+XBkyDSLTgK2u4VvyiqDE
        yoYUceb4iNzdbUt/Dtvm1u4e+4r+Z9RiH4ae7msJ43O07N7uV12iHUFLn9d+UE5X
        ddgI+rYjV1tTFvNPOMsCc1rZz1eJno5B3lzhF1qgCkIyCLCr7owFGneJRgd67TUg
        wto5yIP95mzPqQ==
X-ME-Sender: <xms:vJ78XjH8OcxvfvFA1w2QVu1CpipT3BWv5T75OfYBowsa__PdswpWaw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrtddvgdejlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepudelfedrgeejrdduieehrddvhedu
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:vJ78XgWDZlARMfcfbu2nKygv3aggUkmAujbw5tx5F2U3CXtgEx3tmg>
    <xmx:vJ78XlKfWGs9seqAi6JAZVEEp8sKJMZWjZ16A68l18JVc8_FJmqktQ>
    <xmx:vJ78XhHuWpRdKe2msfjBG8O-uEUgmrETivOwHzEjBUUvUSssDS4uiw>
    <xmx:vJ78XiMJ3mXpceYCqI3gUXFmcS9_Lg6LGfE2r7fYpY6YX5lMUuk1Eg>
Received: from shredder.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8DE04328005D;
        Wed,  1 Jul 2020 10:33:28 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, michael.chan@broadcom.com,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, snelson@pensando.io, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        danieller@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 5/9] devlink: Add a new devlink port lanes attribute and pass to netlink
Date:   Wed,  1 Jul 2020 17:32:47 +0300
Message-Id: <20200701143251.456693-6-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701143251.456693-1-idosch@idosch.org>
References: <20200701143251.456693-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@mellanox.com>

Add a new devlink port attribute that indicates the port's number of lanes.

Drivers are expected to set it via devlink_port_attrs_set(), before
registering the port.

The attribute is not passed to user space in case the number of lanes is
invalid (0).

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 1 +
 include/net/devlink.h                      | 3 +++
 include/uapi/linux/devlink.h               | 2 ++
 net/core/devlink.c                         | 4 ++++
 4 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index f44cb1a537f3..6cde196f6b70 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2134,6 +2134,7 @@ static int __mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 	int err;
 
 	attrs.split = split;
+	attrs.lanes = lanes;
 	attrs.flavour = flavour;
 	attrs.phys.port_number = port_number;
 	attrs.phys.split_subport_number = split_port_subnumber;
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8f9db991192d..91752b79bb29 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -68,10 +68,13 @@ struct devlink_port_pci_vf_attrs {
  * struct devlink_port_attrs - devlink port object
  * @flavour: flavour of the port
  * @split: indicates if this is split port
+ * @lanes: maximum number of lanes the port supports.
+ *	   0 value is not passed to netlink and valid number is a power of 2.
  * @switch_id: if the port is part of switch, this is buffer with ID, otherwise this is NULL
  */
 struct devlink_port_attrs {
 	u8 split:1;
+	u32 lanes;
 	enum devlink_port_flavour flavour;
 	struct netdev_phys_item_id switch_id;
 	union {
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 87c83a82991b..f741ab8d9cf0 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -455,6 +455,8 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_INFO_BOARD_SERIAL_NUMBER,	/* string */
 
+	DEVLINK_ATTR_PORT_LANES,			/* u32 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 266936c38357..7f26d1054974 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -530,6 +530,10 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 
 	if (!devlink_port->attrs_set)
 		return 0;
+	if (attrs->lanes) {
+		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_LANES, attrs->lanes))
+			return -EMSGSIZE;
+	}
 	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_FLAVOUR, attrs->flavour))
 		return -EMSGSIZE;
 	switch (devlink_port->attrs.flavour) {
-- 
2.26.2

