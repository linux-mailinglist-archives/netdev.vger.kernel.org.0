Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE193380B0
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 23:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhCKWhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 17:37:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:33522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229920AbhCKWhj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 17:37:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B200664F95;
        Thu, 11 Mar 2021 22:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615502259;
        bh=iyXZND3MqNacgLep+0fiEzl+N28WQ8/WXqIRY+qxlvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bIMTdZkpNAM6G0zMJwoisqjInw/YevuAxR6u+6A2jlcUDfllN2PKG4ijc2a/D9D6j
         3Th2xKI3G5o8U7CquYT8mlY60BLsg68NuepUge5Q/Pey2BgoJP95hcbmyPsb+FSrje
         SQ1kebW7DTnSI5tL0y1tIinPOW0V0JNH9WNWReSnXZznnegwC/0ySGR6QjRxqpsO4C
         2qMQyggnIzdN0bm9EMbx+KaUElMa1g8LsaMLlsf29aoGMCE3cKVDTrGmhQK2qI82v5
         +jIw4qyQkvFy5IPBVbTLmkJabLFr28LEf47hPwPITRhwg38a1IX/Sh9/o0Ft31JsWR
         0vSUDEQYGBwmQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        kernel test robot <lkp@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/15] net/mlx5: Fix indir stable stubs
Date:   Thu, 11 Mar 2021 14:37:18 -0800
Message-Id: <20210311223723.361301-11-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311223723.361301-1-saeed@kernel.org>
References: <20210311223723.361301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Some of the stubs for CONFIG_MLX5_CLS_ACT==disabled are missing "static
inline" in their definition which causes the following compilation
warnings:

   In file included from drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c:41:
>> drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.h:34:1: warning: no previous prototype for function 'mlx5_esw_indir_table_init' [-Wmissing-prototypes]
   mlx5_esw_indir_table_init(void)
   ^
   drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.h:33:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   struct mlx5_esw_indir_table *
   ^
   static
>> drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.h:40:1: warning: no previous prototype for function 'mlx5_esw_indir_table_destroy' [-Wmissing-prototypes]
   mlx5_esw_indir_table_destroy(struct mlx5_esw_indir_table *indir)
   ^
   drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.h:39:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void
   ^
   static
>> drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.h:61:1: warning: no previous prototype for function 'mlx5_esw_indir_table_needed' [-Wmissing-prototypes]
   mlx5_esw_indir_table_needed(struct mlx5_eswitch *esw,
   ^
   drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.h:60:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   bool
   ^
   static
   3 warnings generated.

Add "static inline" prefix to signatures of stubs that were missing it.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.h
index cb9eafd1b4ee..21d56b49d14b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.h
@@ -30,13 +30,13 @@ mlx5_esw_indir_table_decap_vport(struct mlx5_flow_attr *attr);
 
 #else
 /* indir API stubs */
-struct mlx5_esw_indir_table *
+static inline struct mlx5_esw_indir_table *
 mlx5_esw_indir_table_init(void)
 {
 	return NULL;
 }
 
-void
+static inline void
 mlx5_esw_indir_table_destroy(struct mlx5_esw_indir_table *indir)
 {
 }
@@ -57,7 +57,7 @@ mlx5_esw_indir_table_put(struct mlx5_eswitch *esw,
 {
 }
 
-bool
+static inline bool
 mlx5_esw_indir_table_needed(struct mlx5_eswitch *esw,
 			    struct mlx5_flow_attr *attr,
 			    u16 vport_num,
-- 
2.29.2

