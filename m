Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D0D3B373D
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 21:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbhFXTuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 15:50:02 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52601 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232178AbhFXTuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 15:50:01 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 695B05C009F;
        Thu, 24 Jun 2021 15:47:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 24 Jun 2021 15:47:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=MK+q1hQUCTqqHFhq/
        4Rx/Gj2L1Pdnb8ujnL73wOnz8o=; b=OqncCxoemIcyFxFF0e+lpBQT5ba5FL/eS
        sc8j+PtG4c1qrNhtLYCXB9TfY0aHteH02nDZ/jDYocdJKZg6Uk5dteWoxZ2Rbu+1
        HGfdWNWzU5yj+o9fUV4hqMAjcJrGmDUkP4KsX0ro82/X7wGU2heSRnPbO6pQkPl5
        mLfcAEOkkqTJ7qVPfoYavaYKipHGkUCg0ub3M7Q5VD3e8eG0AbLac9656EdxY3u+
        ZdkLX5fQjUFCYT50nAuX2CrdgcK+7zAbGAJf1iiBQiKG+UQh0Wy7LtG0lCsjbXdn
        hfnT4AUYCY4XcReLK+z+hvvi4Iv07WTRjXpF1W/CK9bBqNbA+Pa/w==
X-ME-Sender: <xms:XeHUYHGamqxVbZCcCtwCIlvArR-IbgM_fPbYONxhu0jFzKcp6P66Kg>
    <xme:XeHUYEVktwqbSBbxPYUkhx3TlPAOzWcw0HuutV27fYnd2qBHmjVNzc8i7CuKL6qbD
    oz4ekm8pjY4d08>
X-ME-Received: <xmr:XeHUYJIHKJG1Wx28sBO6KC_DPn7c5VsilJif0WK2J0Lh5Eeo9K1GjriG0DD85iJlbUExuu4XtKKrc5LqMbYD_F2nJue1vXkLgw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeghedgudegudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuhe
    ehteffieekgeehveefvdegledvffduhfenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:XeHUYFHRU6Bh36JWOLV4GdgsZ51dDX1QxXH195g4n4zhg2slvs1cGg>
    <xmx:XeHUYNWprgLPkuvaphDbz3W_B6VFAuBURxxcWBJI1J-fPh_1IJ6SgA>
    <xmx:XeHUYANKNthMOgS-dnzKC--6NSKgrC8laHn65npyFhnhOjM_gfZIlg>
    <xmx:XeHUYDyCwr74ewAzwlEAC6OnHM38qnAovZar-sJRxOqdqHIRx1b63A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Jun 2021 15:47:39 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next] mlxsw: core_env: Avoid unnecessary memcpy()s
Date:   Thu, 24 Jun 2021 22:47:24 +0300
Message-Id: <20210624194724.2681198-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Simply get a pointer to the data in the register payload instead of
copying it to a temporary buffer.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_env.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 4a0dbdb6730b..3713c45cfa1e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -26,8 +26,8 @@ struct mlxsw_env {
 static int mlxsw_env_validate_cable_ident(struct mlxsw_core *core, int id,
 					  bool *qsfp, bool *cmis)
 {
-	char eeprom_tmp[MLXSW_REG_MCIA_EEPROM_SIZE];
 	char mcia_pl[MLXSW_REG_MCIA_LEN];
+	char *eeprom_tmp;
 	u8 ident;
 	int err;
 
@@ -36,7 +36,7 @@ static int mlxsw_env_validate_cable_ident(struct mlxsw_core *core, int id,
 	err = mlxsw_reg_query(core, MLXSW_REG(mcia), mcia_pl);
 	if (err)
 		return err;
-	mlxsw_reg_mcia_eeprom_memcpy_from(mcia_pl, eeprom_tmp);
+	eeprom_tmp = mlxsw_reg_mcia_eeprom_data(mcia_pl);
 	ident = eeprom_tmp[0];
 	*cmis = false;
 	switch (ident) {
@@ -64,8 +64,8 @@ mlxsw_env_query_module_eeprom(struct mlxsw_core *mlxsw_core, int module,
 			      u16 offset, u16 size, void *data,
 			      bool qsfp, unsigned int *p_read_size)
 {
-	char eeprom_tmp[MLXSW_REG_MCIA_EEPROM_SIZE];
 	char mcia_pl[MLXSW_REG_MCIA_LEN];
+	char *eeprom_tmp;
 	u16 i2c_addr;
 	u8 page = 0;
 	int status;
@@ -116,7 +116,7 @@ mlxsw_env_query_module_eeprom(struct mlxsw_core *mlxsw_core, int module,
 	if (status)
 		return -EIO;
 
-	mlxsw_reg_mcia_eeprom_memcpy_from(mcia_pl, eeprom_tmp);
+	eeprom_tmp = mlxsw_reg_mcia_eeprom_data(mcia_pl);
 	memcpy(data, eeprom_tmp, size);
 	*p_read_size = size;
 
@@ -127,13 +127,13 @@ int mlxsw_env_module_temp_thresholds_get(struct mlxsw_core *core, int module,
 					 int off, int *temp)
 {
 	unsigned int module_temp, module_crit, module_emerg;
-	char eeprom_tmp[MLXSW_REG_MCIA_EEPROM_SIZE];
 	union {
 		u8 buf[MLXSW_REG_MCIA_TH_ITEM_SIZE];
 		u16 temp;
 	} temp_thresh;
 	char mcia_pl[MLXSW_REG_MCIA_LEN] = {0};
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
+	char *eeprom_tmp;
 	bool qsfp, cmis;
 	int page;
 	int err;
@@ -195,7 +195,7 @@ int mlxsw_env_module_temp_thresholds_get(struct mlxsw_core *core, int module,
 	if (err)
 		return err;
 
-	mlxsw_reg_mcia_eeprom_memcpy_from(mcia_pl, eeprom_tmp);
+	eeprom_tmp = mlxsw_reg_mcia_eeprom_data(mcia_pl);
 	memcpy(temp_thresh.buf, eeprom_tmp, MLXSW_REG_MCIA_TH_ITEM_SIZE);
 	*temp = temp_thresh.temp * 1000;
 
@@ -357,8 +357,8 @@ mlxsw_env_get_module_eeprom_by_page(struct mlxsw_core *mlxsw_core, u8 module,
 	device_addr = page->offset;
 
 	while (bytes_read < page->length) {
-		char eeprom_tmp[MLXSW_REG_MCIA_EEPROM_SIZE];
 		char mcia_pl[MLXSW_REG_MCIA_LEN];
+		char *eeprom_tmp;
 		u8 size;
 		int err;
 
@@ -380,7 +380,7 @@ mlxsw_env_get_module_eeprom_by_page(struct mlxsw_core *mlxsw_core, u8 module,
 		if (err)
 			return err;
 
-		mlxsw_reg_mcia_eeprom_memcpy_from(mcia_pl, eeprom_tmp);
+		eeprom_tmp = mlxsw_reg_mcia_eeprom_data(mcia_pl);
 		memcpy(page->data + bytes_read, eeprom_tmp, size);
 		bytes_read += size;
 	}
-- 
2.31.1

