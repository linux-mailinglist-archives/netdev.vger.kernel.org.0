Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A2D2243AB
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 21:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgGQTCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 15:02:21 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43317 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726650AbgGQTCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 15:02:20 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 363625C018C;
        Fri, 17 Jul 2020 15:02:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 17 Jul 2020 15:02:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=pLpSfdqph2Ipw30Qe
        iD6QCa4Ffgxs3SExf0kTvuyFcI=; b=nMIDKDZ2gR67z1qSJ5ZNWSOHB2WU/u5D/
        ABK+5Q8a+OFdCr9OvuDnQvV88OtN1cWJfSfMwBuD8djHL56PrG81gMh7ctkFgAaN
        aVJ2mCU77sxVzy8HfzEYIGh5Dl9df690VcSsTjsvwtx4+rYk2ifDbWYPmWxuDNYr
        MskRzRxEZ++dknBk1g3HBP8VoZmBEom9VUtg8KPYoCV6/kM3/HkuLqapUWndlvnj
        rkBxkNB4r00izub0jjfUtLAHlTQCx96jfRRcfK9Wzx78TuAOh88RrliyiqOQ1PAY
        c1aq4fUFE5iQRtKCu1XEn9YwIo8y+5wTJVeou+93IBzW2QfZKNYvQ==
X-ME-Sender: <xms:uvURXxYoTiTx3rLEtLXRHbOs3UEIl0W11inzwhDZfJkDcyxEVtoTZw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfeejgdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucfkphepuddtledrieeirdduledrudeffeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:uvURX4bxiP2bd4mistjwZ_wLC_4q9x9-1Rju9O-kTNA_xyp3jqLYhg>
    <xmx:uvURXz-SNc-NRI70tuRQtOQA88FekjRgavrKWUkUeOUP9iK9o2yVNA>
    <xmx:uvURX_pKKxTem7nsTL8uHmlCunqhte63qLxb6EkreNi6eZgCrynGgQ>
    <xmx:u_URXz1pH0jA8N4QdK6oWuudi9DVkKFiUplxFk2IM9gMCvtitwR5sg>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7A7DA30600A3;
        Fri, 17 Jul 2020 15:02:16 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net] mlxsw: core: Fix wrong SFP EEPROM reading for upper pages 1-3
Date:   Fri, 17 Jul 2020 22:01:43 +0300
Message-Id: <20200717190143.563235-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

Fix wrong reading of upper pages for SFP EEPROM. According to "Memory
Organization" figure in SFF-8472 spec: When reading upper pages 1, 2 and
3 the offset should be set relative to zero and I2C high address 0x51
[1010001X (A2h)] is to be used.

Fixes: a45bfb5a5070 ("mlxsw: core: Extend QSFP EEPROM size for ethtool")
Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 48 ++++++++++++-------
 1 file changed, 32 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 08215fed193d..a7d86df7123f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -45,7 +45,7 @@ static int mlxsw_env_validate_cable_ident(struct mlxsw_core *core, int id,
 static int
 mlxsw_env_query_module_eeprom(struct mlxsw_core *mlxsw_core, int module,
 			      u16 offset, u16 size, void *data,
-			      unsigned int *p_read_size)
+			      bool qsfp, unsigned int *p_read_size)
 {
 	char eeprom_tmp[MLXSW_REG_MCIA_EEPROM_SIZE];
 	char mcia_pl[MLXSW_REG_MCIA_LEN];
@@ -54,6 +54,10 @@ mlxsw_env_query_module_eeprom(struct mlxsw_core *mlxsw_core, int module,
 	int status;
 	int err;
 
+	/* MCIA register accepts buffer size <= 48. Page of size 128 should be
+	 * read by chunks of size 48, 48, 32. Align the size of the last chunk
+	 * to avoid reading after the end of the page.
+	 */
 	size = min_t(u16, size, MLXSW_REG_MCIA_EEPROM_SIZE);
 
 	if (offset < MLXSW_REG_MCIA_EEPROM_PAGE_LENGTH &&
@@ -63,18 +67,25 @@ mlxsw_env_query_module_eeprom(struct mlxsw_core *mlxsw_core, int module,
 
 	i2c_addr = MLXSW_REG_MCIA_I2C_ADDR_LOW;
 	if (offset >= MLXSW_REG_MCIA_EEPROM_PAGE_LENGTH) {
-		page = MLXSW_REG_MCIA_PAGE_GET(offset);
-		offset -= MLXSW_REG_MCIA_EEPROM_UP_PAGE_LENGTH * page;
-		/* When reading upper pages 1, 2 and 3 the offset starts at
-		 * 128. Please refer to "QSFP+ Memory Map" figure in SFF-8436
-		 * specification for graphical depiction.
-		 * MCIA register accepts buffer size <= 48. Page of size 128
-		 * should be read by chunks of size 48, 48, 32. Align the size
-		 * of the last chunk to avoid reading after the end of the
-		 * page.
-		 */
-		if (offset + size > MLXSW_REG_MCIA_EEPROM_PAGE_LENGTH)
-			size = MLXSW_REG_MCIA_EEPROM_PAGE_LENGTH - offset;
+		if (qsfp) {
+			/* When reading upper pages 1, 2 and 3 the offset
+			 * starts at 128. Please refer to "QSFP+ Memory Map"
+			 * figure in SFF-8436 specification for graphical
+			 * depiction.
+			 */
+			page = MLXSW_REG_MCIA_PAGE_GET(offset);
+			offset -= MLXSW_REG_MCIA_EEPROM_UP_PAGE_LENGTH * page;
+			if (offset + size > MLXSW_REG_MCIA_EEPROM_PAGE_LENGTH)
+				size = MLXSW_REG_MCIA_EEPROM_PAGE_LENGTH - offset;
+		} else {
+			/* When reading upper pages 1, 2 and 3 the offset
+			 * starts at 0 and I2C high address is used. Please refer
+			 * refer to "Memory Organization" figure in SFF-8472
+			 * specification for graphical depiction.
+			 */
+			i2c_addr = MLXSW_REG_MCIA_I2C_ADDR_HIGH;
+			offset -= MLXSW_REG_MCIA_EEPROM_PAGE_LENGTH;
+		}
 	}
 
 	mlxsw_reg_mcia_pack(mcia_pl, module, 0, page, offset, size, i2c_addr);
@@ -166,7 +177,7 @@ int mlxsw_env_get_module_info(struct mlxsw_core *mlxsw_core, int module,
 	int err;
 
 	err = mlxsw_env_query_module_eeprom(mlxsw_core, module, 0, offset,
-					    module_info, &read_size);
+					    module_info, false, &read_size);
 	if (err)
 		return err;
 
@@ -197,7 +208,7 @@ int mlxsw_env_get_module_info(struct mlxsw_core *mlxsw_core, int module,
 		/* Verify if transceiver provides diagnostic monitoring page */
 		err = mlxsw_env_query_module_eeprom(mlxsw_core, module,
 						    SFP_DIAGMON, 1, &diag_mon,
-						    &read_size);
+						    false, &read_size);
 		if (err)
 			return err;
 
@@ -225,17 +236,22 @@ int mlxsw_env_get_module_eeprom(struct net_device *netdev,
 	int offset = ee->offset;
 	unsigned int read_size;
 	int i = 0;
+	bool qsfp;
 	int err;
 
 	if (!ee->len)
 		return -EINVAL;
 
 	memset(data, 0, ee->len);
+	/* Validate module identifier value. */
+	err = mlxsw_env_validate_cable_ident(mlxsw_core, module, &qsfp);
+	if (err)
+		return err;
 
 	while (i < ee->len) {
 		err = mlxsw_env_query_module_eeprom(mlxsw_core, module, offset,
 						    ee->len - i, data + i,
-						    &read_size);
+						    qsfp, &read_size);
 		if (err) {
 			netdev_err(netdev, "Eeprom query failed\n");
 			return err;
-- 
2.26.2

