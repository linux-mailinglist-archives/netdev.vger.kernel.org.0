Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58693DDB79
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbhHBOsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:48:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234008AbhHBOsb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 10:48:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37D8760F51;
        Mon,  2 Aug 2021 14:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627915702;
        bh=7LZ+RJ0Hi/u0L7+8fl9svS8TaK1SE+sy+Aaxg/1q60o=;
        h=From:To:Cc:Subject:Date:From;
        b=JTyAaXXm7a2pMrK8j3CpeAm4SzIYEwKRCmUDhrghmygh0eG1ih/BJfuDqxqeWNmcx
         /+ZjjI0tsyMFkFM6z6AaJb+WlH20BoluD71CBUJyWRm9zDPngqrbCM6b34EC12wslx
         5tLtxvV/oGNU0aaDgch616021i+yjg2PTT6QP++QPvk4nvILh7IRJfcn4y1k/tlyFW
         BZX2YuBWlypqld7oJJybsWrq0UiR/xbo/T/GSboQ197H/qnbNbArn3ri2L9ila23T7
         UGgyQNRZuM9ZqbS7KNPTVw5w727vvinrMzGkjzccliSnrFiiOr/Iwvhnfp0Gm+9dCs
         IBvt7C+069tcA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Parav Pandit <parav@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH] switchdev: add Kconfig dependencies for bridge
Date:   Mon,  2 Aug 2021 16:47:28 +0200
Message-Id: <20210802144813.1152762-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Multiple switchdev drivers depend on CONFIG_NET_SWITCHDEV in Kconfig,
but have also gained a dependency on the bridge driver as they now
call switchdev_bridge_port_offload():

drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.o: In function `sparx5_netdevice_event':
sparx5_switchdev.c:(.text+0x3cc): undefined reference to `switchdev_bridge_port_offload'
drivers/net/ethernet/ti/cpsw_new.o: In function `cpsw_netdevice_event':
cpsw_new.c:(.text+0x1098): undefined reference to `switchdev_bridge_port_offload'

Some of these drivers already have a 'BRIDGE || !BRIDGE' dependency
that avoids the link failure, but the 'rocker' driver was missing this

For MLXSW/MLX5, SPARX5_SWITCH, and TI_K3_AM65_CPSW_NUSS, the
driver can conditionally use switchdev support, which is then guarded
by another Kconfig symbol. For these, add a dependency on a new Kconfig
symbol NET_MAY_USE_SWITCHDEV that is defined to correctly model the
dependency: if switchdev support is enabled, these drivers cannot be
built-in when bridge support is in a module, but if either bridge or
switchdev is disabled, or both are built-in, there is no such restriction.

Fixes: 2f5dc00f7a3e ("net: bridge: switchdev: let drivers inform which bridge ports are offloaded")
Fixes: b0e81817629a ("net: build all switchdev drivers as modules when the bridge is a module")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
This version seems to pass my randconfig builds for the moment,
but that doesn't mean it's correct either. Please have a closer
look before this gets applied.
---
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 1 +
 drivers/net/ethernet/mellanox/mlxsw/Kconfig     | 1 +
 drivers/net/ethernet/netronome/Kconfig          | 1 +
 drivers/net/ethernet/ti/Kconfig                 | 1 +
 net/switchdev/Kconfig                           | 5 +++++
 5 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index e1a5a79e27c7..3a752e57c1e5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -12,6 +12,7 @@ config MLX5_CORE
 	depends on MLXFW || !MLXFW
 	depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
 	depends on PCI_HYPERV_INTERFACE || !PCI_HYPERV_INTERFACE
+	depends on NET_MAY_USE_SWITCHDEV
 	help
 	  Core driver for low level functionality of the ConnectX-4 and
 	  Connect-IB cards by Mellanox Technologies.
diff --git a/drivers/net/ethernet/mellanox/mlxsw/Kconfig b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
index 12871c8dc7c1..dee3925bdaea 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
@@ -5,6 +5,7 @@
 
 config MLXSW_CORE
 	tristate "Mellanox Technologies Switch ASICs support"
+	depends on NET_MAY_USE_SWITCHDEV
 	select NET_DEVLINK
 	select MLXFW
 	help
diff --git a/drivers/net/ethernet/netronome/Kconfig b/drivers/net/ethernet/netronome/Kconfig
index b82758d5beed..a298d19e8383 100644
--- a/drivers/net/ethernet/netronome/Kconfig
+++ b/drivers/net/ethernet/netronome/Kconfig
@@ -21,6 +21,7 @@ config NFP
 	depends on PCI && PCI_MSI
 	depends on VXLAN || VXLAN=n
 	depends on TLS && TLS_DEVICE || TLS_DEVICE=n
+	depends on NET_MAY_USE_SWITCHDEV
 	select NET_DEVLINK
 	select CRC32
 	help
diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index 07192613256e..a73c6c236b25 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -93,6 +93,7 @@ config TI_CPTS
 config TI_K3_AM65_CPSW_NUSS
 	tristate "TI K3 AM654x/J721E CPSW Ethernet driver"
 	depends on OF && TI_K3_UDMA_GLUE_LAYER
+	depends on NET_MAY_USE_SWITCHDEV
 	select NET_DEVLINK
 	select TI_DAVINCI_MDIO
 	imply PHY_TI_GMII_SEL
diff --git a/net/switchdev/Kconfig b/net/switchdev/Kconfig
index 18a2d980e11d..3b0e627a4519 100644
--- a/net/switchdev/Kconfig
+++ b/net/switchdev/Kconfig
@@ -12,3 +12,8 @@ config NET_SWITCHDEV
 	  meaning of the word "switch". This include devices supporting L2/L3 but
 	  also various flow offloading chips, including switches embedded into
 	  SR-IOV NICs.
+
+config NET_MAY_USE_SWITCHDEV
+	def_tristate y
+	depends on NET_SWITCHDEV || NET_SWITCHDEV=n
+	depends on BRIDGE || NET_SWITCHDEV=n
-- 
2.29.2

