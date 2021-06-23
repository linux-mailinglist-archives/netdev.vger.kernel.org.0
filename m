Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16493B154F
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 10:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhFWIEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 04:04:00 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:44439 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230290AbhFWIDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 04:03:41 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id BB54658070C;
        Wed, 23 Jun 2021 04:01:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 23 Jun 2021 04:01:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=23wsahIQosPUvOapAIZyoWqr8C8IjN+CjOMSeRFXJvA=; b=qJPdedD5
        VyB8X9jtozadJ7GZk42fBhh9eJngIsPyfz7XvYA3l1MZOE/3XCc8wMoGNkfnZKYV
        aSpq7Rw2RF/ia7mK/C/jW8bFbnY2aCzpjD6GOUpaKdRphPSBoD0AXUj02KpHaqET
        Ih9+Vc0rbiZQU5kNyEMdiPE/BFzPpY0xKH63Jug2tOtu0moTpjDmpv8GO0DQ5s0t
        7xE6PQNaKta/hf8bEtcC9QeiXkc6HePVKmqq34R/XxeDlQB87tlTWhe+ZfjzySL3
        36S63BekcE48trDbiPSIYDCzwFAVe1vA1tbBuZwwyMVn03jLipFV2/0o8opNPDF+
        MKSEduVseUu06Q==
X-ME-Sender: <xms:VOrSYAxBTWxVgam7MmdPmDaw-TceAG7wLmY55HJekJRU1-jr4v_vpQ>
    <xme:VOrSYESWWyzrVOZU5wFZPmvyNDNZj-a4ieR3FPQ9fngdRcGnp09bEfDkTag4rFoR9
    ta7bFx2ohjHNm0>
X-ME-Received: <xmr:VOrSYCVrEKJDTFC7BMXrVX3TejhnxtW6SW4v-YZYGVd9t309f-Z_L-j_FcWX9VkLYvMym789klOBt3XZNGz7sJJEFjbHPahorM7Fsi0Q-68BMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeegvddguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:VOrSYOhIQOKSeFuZyQwUGPdwwLmBFBqPvPt9V-UWC46z_Dzcl6RfLg>
    <xmx:VOrSYCA_A7mexreA9GUO64jdYxktbH9Jv7_pSeVggV4tMJYuyDrmog>
    <xmx:VOrSYPI8fyMwS8j7VRGMZ5FyGgwKDfTjN6Es2lFhg_uIZd_rVlqv9A>
    <xmx:VOrSYO1mdOveCZ1ARi23-rEm24cRYxIz9h7pSRUWyxOMlfbqCf7c7A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 23 Jun 2021 04:01:22 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, vladyslavt@nvidia.com, moshe@nvidia.com,
        vadimp@nvidia.com, mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 4/4] mlxsw: core: Add support for module EEPROM write by page
Date:   Wed, 23 Jun 2021 10:59:25 +0300
Message-Id: <20210623075925.2610908-5-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210623075925.2610908-1-idosch@idosch.org>
References: <20210623075925.2610908-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add support for ethtool_ops::set_module_eeprom_by_page() which allows
user space to write to transceiver module EEPROM based on passed
parameters.

The I2C address is not validated in order to avoid module-specific code.
In case of wrong address, error will be returned from device's firmware.

Tested by writing to page 3 (User EEPROM) on a QSFP-DD module:

 # ethtool -m swp11 offset 0x80 length 3 page 3 bank 0 i2c 0x50
 Offset          Values
 ------          ------
 0x0080:         00 00 00
 # ethtool -M swp11 offset 0x80 page 3 bank 0 i2c 0x50 value 0x44
 # ethtool -M swp11 offset 0x81 page 3 bank 0 i2c 0x50 value 0x41
 # ethtool -M swp11 offset 0x82 page 3 bank 0 i2c 0x50 value 0x44
 # ethtool -m swp11 offset 0x80 length 3 page 3 bank 0 i2c 0x50
 Offset          Values
 ------          ------
 0x0080:         44 41 44

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 44 +++++++++++++++++++
 .../net/ethernet/mellanox/mlxsw/core_env.h    |  5 +++
 drivers/net/ethernet/mellanox/mlxsw/minimal.c | 13 ++++++
 .../mellanox/mlxsw/spectrum_ethtool.c         | 14 ++++++
 4 files changed, 76 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 3713c45cfa1e..4cb69eddbd1e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -389,6 +389,50 @@ mlxsw_env_get_module_eeprom_by_page(struct mlxsw_core *mlxsw_core, u8 module,
 }
 EXPORT_SYMBOL(mlxsw_env_get_module_eeprom_by_page);
 
+int
+mlxsw_env_set_module_eeprom_by_page(struct mlxsw_core *mlxsw_core, u8 module,
+				    const struct ethtool_module_eeprom *page,
+				    struct netlink_ext_ack *extack)
+{
+	u32 bytes_written = 0;
+	u16 device_addr;
+
+	/* Offset cannot be larger than 2 * ETH_MODULE_EEPROM_PAGE_LEN */
+	device_addr = page->offset;
+
+	while (bytes_written < page->length) {
+		char eeprom_tmp[MLXSW_REG_MCIA_EEPROM_SIZE] = {};
+		char mcia_pl[MLXSW_REG_MCIA_LEN];
+		u8 size;
+		int err;
+
+		size = min_t(u8, page->length - bytes_written,
+			     MLXSW_REG_MCIA_EEPROM_SIZE);
+
+		mlxsw_reg_mcia_pack(mcia_pl, module, 0, page->page,
+				    device_addr + bytes_written, size,
+				    page->i2c_address);
+		mlxsw_reg_mcia_bank_number_set(mcia_pl, page->bank);
+		memcpy(eeprom_tmp, page->data + bytes_written, size);
+		mlxsw_reg_mcia_eeprom_memcpy_to(mcia_pl, eeprom_tmp);
+
+		err = mlxsw_reg_write(mlxsw_core, MLXSW_REG(mcia), mcia_pl);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to access module's EEPROM");
+			return err;
+		}
+
+		err = mlxsw_env_mcia_status_process(mcia_pl, extack);
+		if (err)
+			return err;
+
+		bytes_written += size;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(mlxsw_env_set_module_eeprom_by_page);
+
 static int mlxsw_env_module_has_temp_sensor(struct mlxsw_core *mlxsw_core,
 					    u8 module,
 					    bool *p_has_temp_sensor)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.h b/drivers/net/ethernet/mellanox/mlxsw/core_env.h
index 0bf5bd0f8a7e..e07f48ffbf2b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.h
@@ -24,6 +24,11 @@ mlxsw_env_get_module_eeprom_by_page(struct mlxsw_core *mlxsw_core, u8 module,
 				    const struct ethtool_module_eeprom *page,
 				    struct netlink_ext_ack *extack);
 
+int
+mlxsw_env_set_module_eeprom_by_page(struct mlxsw_core *mlxsw_core, u8 module,
+				    const struct ethtool_module_eeprom *page,
+				    struct netlink_ext_ack *extack);
+
 int
 mlxsw_env_module_overheat_counter_get(struct mlxsw_core *mlxsw_core, u8 module,
 				      u64 *p_counter);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index d9d56c44e994..b795520566bb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -124,11 +124,24 @@ mlxsw_m_get_module_eeprom_by_page(struct net_device *netdev,
 						   page, extack);
 }
 
+static int
+mlxsw_m_set_module_eeprom_by_page(struct net_device *netdev,
+				  const struct ethtool_module_eeprom *page,
+				  struct netlink_ext_ack *extack)
+{
+	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(netdev);
+	struct mlxsw_core *core = mlxsw_m_port->mlxsw_m->core;
+
+	return mlxsw_env_set_module_eeprom_by_page(core, mlxsw_m_port->module,
+						   page, extack);
+}
+
 static const struct ethtool_ops mlxsw_m_port_ethtool_ops = {
 	.get_drvinfo		= mlxsw_m_module_get_drvinfo,
 	.get_module_info	= mlxsw_m_get_module_info,
 	.get_module_eeprom	= mlxsw_m_get_module_eeprom,
 	.get_module_eeprom_by_page = mlxsw_m_get_module_eeprom_by_page,
+	.set_module_eeprom_by_page = mlxsw_m_set_module_eeprom_by_page,
 };
 
 static int
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 267590a0eee7..2e7f57a6fbb2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -1063,6 +1063,19 @@ mlxsw_sp_get_module_eeprom_by_page(struct net_device *dev,
 						   extack);
 }
 
+static int
+mlxsw_sp_set_module_eeprom_by_page(struct net_device *dev,
+				   const struct ethtool_module_eeprom *page,
+				   struct netlink_ext_ack *extack)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	u8 module = mlxsw_sp_port->mapping.module;
+
+	return mlxsw_env_set_module_eeprom_by_page(mlxsw_sp->core, module, page,
+						   extack);
+}
+
 static int
 mlxsw_sp_get_ts_info(struct net_device *netdev, struct ethtool_ts_info *info)
 {
@@ -1213,6 +1226,7 @@ const struct ethtool_ops mlxsw_sp_port_ethtool_ops = {
 	.get_module_info		= mlxsw_sp_get_module_info,
 	.get_module_eeprom		= mlxsw_sp_get_module_eeprom,
 	.get_module_eeprom_by_page	= mlxsw_sp_get_module_eeprom_by_page,
+	.set_module_eeprom_by_page	= mlxsw_sp_set_module_eeprom_by_page,
 	.get_ts_info			= mlxsw_sp_get_ts_info,
 	.get_eth_phy_stats		= mlxsw_sp_get_eth_phy_stats,
 	.get_eth_mac_stats		= mlxsw_sp_get_eth_mac_stats,
-- 
2.31.1

