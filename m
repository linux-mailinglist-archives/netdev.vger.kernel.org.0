Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A094A432C30
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 05:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbhJSDXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 23:23:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231226AbhJSDXD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 23:23:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9278C61355;
        Tue, 19 Oct 2021 03:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634613651;
        bh=5s1FvX4jwNnb3MJCcHKe8pbpW8z0vRtGjFdFaGsiTJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mAB4N9+RzmY9B9PRzdMSlivHgSrlGO4g34tFtM+lu3slYpGOH3RRpnzdd+Cr3tITH
         QUYk6XIoP/vQz2aHBaoyXiac1LN1TqW4moEIwHGOKiXZGtbfMuzbUjstZA+Ls2QRye
         O5OET9mEu+0S7fbQwXsTtoCnRRfLpsL1e6qZsRibkbdjy+erWAEYnqYrgdKf21Hr+o
         UNRE7uXgAn015OuSwSnRzXYrkFCv5J+Rw9wfzmb7B0yvwYGzakluTHKA5rJgwhyfoN
         paX0OILv5a8swKy62GDY2YpXTGmct89KG+lxTERdtbt7UcotVrwpekrLmt0hKpmBCg
         gBkQeiqcBchbQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/13] net/mlx5: Lag, move lag files into directory
Date:   Mon, 18 Oct 2021 20:20:39 -0700
Message-Id: <20211019032047.55660-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019032047.55660-1-saeed@kernel.org>
References: <20211019032047.55660-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

Downstream patches add another lag related file so it makes
sense to have all the lag files in a dedicated directory.

Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Makefile              | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/{ => lag}/lag.c       | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/{ => lag}/lag.h       | 2 +-
 .../net/ethernet/mellanox/mlx5/core/{lag_mp.c => lag/mp.c}    | 4 ++--
 .../net/ethernet/mellanox/mlx5/core/{lag_mp.h => lag/mp.h}    | 0
 5 files changed, 6 insertions(+), 6 deletions(-)
 rename drivers/net/ethernet/mellanox/mlx5/core/{ => lag}/lag.c (99%)
 rename drivers/net/ethernet/mellanox/mlx5/core/{ => lag}/lag.h (98%)
 rename drivers/net/ethernet/mellanox/mlx5/core/{lag_mp.c => lag/mp.c} (99%)
 rename drivers/net/ethernet/mellanox/mlx5/core/{lag_mp.h => lag/mp.h} (100%)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index a151575be51f..fb123e26927d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -14,7 +14,7 @@ obj-$(CONFIG_MLX5_CORE) += mlx5_core.o
 mlx5_core-y :=	main.o cmd.o debugfs.o fw.o eq.o uar.o pagealloc.o \
 		health.o mcg.o cq.o alloc.o port.o mr.o pd.o \
 		transobj.o vport.o sriov.o fs_cmd.o fs_core.o pci_irq.o \
-		fs_counters.o fs_ft_pool.o rl.o lag.o dev.o events.o wq.o lib/gid.o \
+		fs_counters.o fs_ft_pool.o rl.o lag/lag.o dev.o events.o wq.o lib/gid.o \
 		lib/devcom.o lib/pci_vsc.o lib/dm.o lib/fs_ttc.o diag/fs_tracepoint.o \
 		diag/fw_tracer.o diag/crdump.o devlink.o diag/rsc_dump.o \
 		fw_reset.o qos.o lib/tout.o
@@ -37,7 +37,7 @@ mlx5_core-$(CONFIG_MLX5_EN_ARFS)     += en_arfs.o
 mlx5_core-$(CONFIG_MLX5_EN_RXNFC)    += en_fs_ethtool.o
 mlx5_core-$(CONFIG_MLX5_CORE_EN_DCB) += en_dcbnl.o en/port_buffer.o
 mlx5_core-$(CONFIG_PCI_HYPERV_INTERFACE) += en/hv_vhca_stats.o
-mlx5_core-$(CONFIG_MLX5_ESWITCH)     += lag_mp.o lib/geneve.o lib/port_tun.o \
+mlx5_core-$(CONFIG_MLX5_ESWITCH)     += lag/mp.o lib/geneve.o lib/port_tun.o \
 					en_rep.o en/rep/bond.o en/mod_hdr.o \
 					en/mapping.o
 mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en_tc.o en/rep/tc.o en/rep/neigh.o \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
similarity index 99%
rename from drivers/net/ethernet/mellanox/mlx5/core/lag.c
rename to drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index f35c8ba48aac..b37724fc5387 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -38,7 +38,7 @@
 #include "mlx5_core.h"
 #include "eswitch.h"
 #include "lag.h"
-#include "lag_mp.h"
+#include "mp.h"
 
 /* General purpose, use for short periods of time.
  * Beware of lock dependencies (preferably, no locks should be acquired
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
similarity index 98%
rename from drivers/net/ethernet/mellanox/mlx5/core/lag.h
rename to drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index d4bae528954e..c268663c89b4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -5,7 +5,7 @@
 #define __MLX5_LAG_H__
 
 #include "mlx5_core.h"
-#include "lag_mp.h"
+#include "mp.h"
 
 enum {
 	MLX5_LAG_P1,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
similarity index 99%
rename from drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
rename to drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
index f239b352a58a..810a15b83b9f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
@@ -3,8 +3,8 @@
 
 #include <linux/netdevice.h>
 #include <net/nexthop.h>
-#include "lag.h"
-#include "lag_mp.h"
+#include "lag/lag.h"
+#include "lag/mp.h"
 #include "mlx5_core.h"
 #include "eswitch.h"
 #include "lib/mlx5.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.h
similarity index 100%
rename from drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h
rename to drivers/net/ethernet/mellanox/mlx5/core/lag/mp.h
-- 
2.31.1

