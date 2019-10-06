Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27E17CCF02
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 08:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfJFGf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 02:35:28 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60501 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726270AbfJFGfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 02:35:25 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 918442104C;
        Sun,  6 Oct 2019 02:35:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 06 Oct 2019 02:35:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=v0P+QmA8SdVjya/Fi9Wlr0DWzggxiDAvd9QZhf8OYRw=; b=QY7gzuAj
        KFjIwwZoj1qm1ADpeGad4AIDK4vrioomeAqNExODZsWxS7jHQUhSr8kL5YHVhLNW
        Jff5W7jiJYh3JjI9zWn5g0R5bOLwnoLvquyGp/PlF4plhJxwjTgEvt4IR7Y1nTVA
        6adsxFwPFKgmXGb/jIaxA8HlVFJfn41fvywG92F5wcBaNg7HQMRQgaU1uYz3W3Hf
        dVZ81mCcaUOAo1z8G6HVhSxpFCcbTEbtqrg9rkbob2p/uB3cGvW30mj/RLcdcTEs
        pVxPLJCOcg+F6YkIBGF1E/EtfaMVHEOeMZlDxhjbS2xj/AvtDJaQrbgDzto4BpGr
        m4m9PWGySZJeBg==
X-ME-Sender: <xms:LIuZXTlqyZAk1-lhZw5bOSTXhX9TFmwGX-Xbx0MZv0wuwv5toVwoFw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheeggdejhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepfe
X-ME-Proxy: <xmx:LIuZXay358M93LqKq5bkRg9CejfVE00B7Gc2DjU05y1nMIOQ_X-Wdg>
    <xmx:LIuZXSL8-lv41OxTn7e4rbAOQjtrSPP4ssuah871rqBZWfL8DnS8zg>
    <xmx:LIuZXVL3lwV6t62N-Look5HF6n2FRYNFHCLqwoWRYjye-NE18qyDnQ>
    <xmx:LIuZXdSwz_A6VGZZ4TZ9Q5wgzUJ-QbpuGvCR7wh3C201lWphSvrddg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 447CCD6005A;
        Sun,  6 Oct 2019 02:35:23 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, vadimp@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 5/5] mlxsw: minimal: Add validation for FW version
Date:   Sun,  6 Oct 2019 09:34:52 +0300
Message-Id: <20191006063452.7666-6-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191006063452.7666-1-idosch@idosch.org>
References: <20191006063452.7666-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

Add validation for FW version in order to prevent driver initialization
in case FW version is older than expected. FW version validation is
necessary, because use of a new field 'num_of_modules' in MGPIR register
is not backward compatible. FW 'minor' and 'subminor' versions are
expected to be greater than or equal to 2000 and 1886, respectively.

Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/minimal.c | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index 5edd8de57a24..2b543911ae00 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -16,6 +16,14 @@
 
 static const char mlxsw_m_driver_name[] = "mlxsw_minimal";
 
+#define MLXSW_M_FWREV_MINOR	2000
+#define MLXSW_M_FWREV_SUBMINOR	1886
+
+static const struct mlxsw_fw_rev mlxsw_m_fw_rev = {
+	.minor = MLXSW_M_FWREV_MINOR,
+	.subminor = MLXSW_M_FWREV_SUBMINOR,
+};
+
 struct mlxsw_m_port;
 
 struct mlxsw_m {
@@ -326,6 +334,24 @@ static void mlxsw_m_ports_remove(struct mlxsw_m *mlxsw_m)
 	kfree(mlxsw_m->ports);
 }
 
+static int mlxsw_m_fw_rev_validate(struct mlxsw_m *mlxsw_m)
+{
+	const struct mlxsw_fw_rev *rev = &mlxsw_m->bus_info->fw_rev;
+
+	/* Validate driver and FW are compatible.
+	 * Do not check major version, since it defines chip type, while
+	 * driver is supposed to support any type.
+	 */
+	if (mlxsw_core_fw_rev_minor_subminor_validate(rev, &mlxsw_m_fw_rev))
+		return 0;
+
+	dev_err(mlxsw_m->bus_info->dev, "The firmware version %d.%d.%d is incompatible with the driver (required >= %d.%d.%d)\n",
+		rev->major, rev->minor, rev->subminor, rev->major,
+		mlxsw_m_fw_rev.minor, mlxsw_m_fw_rev.subminor);
+
+	return -EINVAL;
+}
+
 static int mlxsw_m_init(struct mlxsw_core *mlxsw_core,
 			const struct mlxsw_bus_info *mlxsw_bus_info,
 			struct netlink_ext_ack *extack)
@@ -336,6 +362,10 @@ static int mlxsw_m_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_m->core = mlxsw_core;
 	mlxsw_m->bus_info = mlxsw_bus_info;
 
+	err = mlxsw_m_fw_rev_validate(mlxsw_m);
+	if (err)
+		return err;
+
 	err = mlxsw_m_base_mac_get(mlxsw_m);
 	if (err) {
 		dev_err(mlxsw_m->bus_info->dev, "Failed to get base mac\n");
-- 
2.21.0

