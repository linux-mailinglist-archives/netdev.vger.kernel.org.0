Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACDBD16F9B7
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 09:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbgBZIj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 03:39:28 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35793 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgBZIj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 03:39:27 -0500
Received: by mail-wm1-f65.google.com with SMTP id m3so2042259wmi.0
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 00:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hvmV7gSiLS/y3kIA2FYk5Vy/Vp26vqhEwjxk0iHzfNc=;
        b=xNx1jVOphozBHPBFJe00x4XKsCQfEwFnYFY1FB6ImRbeqvEfyTas1uZF5h5zCx5Pxc
         1amBsxb/OQKKoUUVwEnROrN4Oc/s2/eGa7bGuu3ELnFCH71EplgD9sEXVSr/D8zTbz8x
         5vUcBGUQDowrv9y+6bf9u8cYQ3kc3pvek1uIyv3BnkWbrNxjlBb+BxvqkRSWUtTn7fzH
         pNudBogjU91xibXGaL89Pi3RVjS6+lmnK8nPTEz+GJ4Rp53iy1/7TRpMd4jVdlSwmgH3
         2D308tVOUA46a80E2UvNQEpW4DJHANojpmOVY/mKgOH1GdKgreJXdTFZe8AskQ1hkHqW
         CE9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hvmV7gSiLS/y3kIA2FYk5Vy/Vp26vqhEwjxk0iHzfNc=;
        b=hv3u+QG9FOHS6E3VwtEmKIY6D4vAYhl2txUK+d0SeCobtmw5xNRfNmkqYPB+LKFcU5
         gMcyk3p+2xNgQ3J/G2BMmsvtu6olsviFrxcZxi5WvcoZLCxQwmgaEh/WDTAeqwMol1vC
         JpnAyqvX6/nHxypfRHtkgOpfB1agi1kj5z9RvcTeGZ3gbqUkt6i57ey4tGrY162cl/Z9
         mwxM1wyW30hQPh21jBntvExvVoVgDKDSAYxwI/YksBKcmKV9u4Zm/tm0QV6MITCZded6
         wDjNmyep8LpS1c2L3Z/9AbF0nUvAjyokubWbEH/1Nn1SiodKwVoG86WgRMR9113E7xXw
         usSA==
X-Gm-Message-State: APjAAAWGXpz6a7ztw76OPfHQdK5kbTCFM7HSJpxDfURzscRHw3Zfn/KQ
        Epq3NxzOLWrrfQ5IJgqF7txBab5i2gI=
X-Google-Smtp-Source: APXvYqwPsA7O8o9uW1vT9YR7ueD9VMVMrPnTLQ0TN6KK5TZE4si7/Hvje7Z5O2XOX7h2fAQFKyKHgQ==
X-Received: by 2002:a05:600c:2283:: with SMTP id 3mr4137460wmf.100.1582706365368;
        Wed, 26 Feb 2020 00:39:25 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id v16sm1974254wml.11.2020.02.26.00.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 00:39:24 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 3/4] mlxsw: spectrum: Initialize advertised speeds to supported speeds
Date:   Wed, 26 Feb 2020 09:39:19 +0100
Message-Id: <20200226083920.16232-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200226083920.16232-1-jiri@resnulli.us>
References: <20200226083920.16232-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

During port initialization the driver instructs the device to only
advertise speeds that can be supported by the port's current width.

Since the device now returns the supported speeds based on the port's
current width, the driver no longer needs to compute the speeds that can
be advertised.

Simplify port initialization by setting the advertised speeds to the
queried supported speeds.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 86 ++-----------------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  6 --
 2 files changed, 8 insertions(+), 84 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 1aae1c06077a..17190ff55555 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2798,27 +2798,6 @@ static u32 mlxsw_sp1_to_ptys_speed(struct mlxsw_sp *mlxsw_sp, u8 width,
 	return ptys_proto;
 }
 
-static u32
-mlxsw_sp1_to_ptys_upper_speed(struct mlxsw_sp *mlxsw_sp, u32 upper_speed)
-{
-	u32 ptys_proto = 0;
-	int i;
-
-	for (i = 0; i < MLXSW_SP1_PORT_LINK_MODE_LEN; i++) {
-		if (mlxsw_sp1_port_link_mode[i].speed <= upper_speed)
-			ptys_proto |= mlxsw_sp1_port_link_mode[i].mask;
-	}
-	return ptys_proto;
-}
-
-static int
-mlxsw_sp1_port_speed_base(struct mlxsw_sp *mlxsw_sp, u8 local_port,
-			  u32 *base_speed)
-{
-	*base_speed = MLXSW_SP_PORT_BASE_SPEED_25G;
-	return 0;
-}
-
 static void
 mlxsw_sp1_reg_ptys_eth_pack(struct mlxsw_sp *mlxsw_sp, char *payload,
 			    u8 local_port, u32 proto_admin, bool autoneg)
@@ -2843,8 +2822,6 @@ mlxsw_sp1_port_type_speed_ops = {
 	.from_ptys_speed_duplex		= mlxsw_sp1_from_ptys_speed_duplex,
 	.to_ptys_advert_link		= mlxsw_sp1_to_ptys_advert_link,
 	.to_ptys_speed			= mlxsw_sp1_to_ptys_speed,
-	.to_ptys_upper_speed		= mlxsw_sp1_to_ptys_upper_speed,
-	.port_speed_base		= mlxsw_sp1_port_speed_base,
 	.reg_ptys_eth_pack		= mlxsw_sp1_reg_ptys_eth_pack,
 	.reg_ptys_eth_unpack		= mlxsw_sp1_reg_ptys_eth_unpack,
 };
@@ -3245,51 +3222,6 @@ static u32 mlxsw_sp2_to_ptys_speed(struct mlxsw_sp *mlxsw_sp,
 	return ptys_proto;
 }
 
-static u32
-mlxsw_sp2_to_ptys_upper_speed(struct mlxsw_sp *mlxsw_sp, u32 upper_speed)
-{
-	u32 ptys_proto = 0;
-	int i;
-
-	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
-		if (mlxsw_sp2_port_link_mode[i].speed <= upper_speed)
-			ptys_proto |= mlxsw_sp2_port_link_mode[i].mask;
-	}
-	return ptys_proto;
-}
-
-static int
-mlxsw_sp2_port_speed_base(struct mlxsw_sp *mlxsw_sp, u8 local_port,
-			  u32 *base_speed)
-{
-	char ptys_pl[MLXSW_REG_PTYS_LEN];
-	u32 eth_proto_cap;
-	int err;
-
-	/* In Spectrum-2, the speed of 1x can change from port to port, so query
-	 * it from firmware.
-	 */
-	mlxsw_reg_ptys_ext_eth_pack(ptys_pl, local_port, 0, false);
-	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(ptys), ptys_pl);
-	if (err)
-		return err;
-	mlxsw_reg_ptys_ext_eth_unpack(ptys_pl, &eth_proto_cap, NULL, NULL);
-
-	if (eth_proto_cap &
-	    MLXSW_REG_PTYS_EXT_ETH_SPEED_50GAUI_1_LAUI_1_50GBASE_CR_KR) {
-		*base_speed = MLXSW_SP_PORT_BASE_SPEED_50G;
-		return 0;
-	}
-
-	if (eth_proto_cap &
-	    MLXSW_REG_PTYS_EXT_ETH_SPEED_25GAUI_1_25GBASE_CR_KR) {
-		*base_speed = MLXSW_SP_PORT_BASE_SPEED_25G;
-		return 0;
-	}
-
-	return -EIO;
-}
-
 static void
 mlxsw_sp2_reg_ptys_eth_pack(struct mlxsw_sp *mlxsw_sp, char *payload,
 			    u8 local_port, u32 proto_admin,
@@ -3315,8 +3247,6 @@ mlxsw_sp2_port_type_speed_ops = {
 	.from_ptys_speed_duplex		= mlxsw_sp2_from_ptys_speed_duplex,
 	.to_ptys_advert_link		= mlxsw_sp2_to_ptys_advert_link,
 	.to_ptys_speed			= mlxsw_sp2_to_ptys_speed,
-	.to_ptys_upper_speed		= mlxsw_sp2_to_ptys_upper_speed,
-	.port_speed_base		= mlxsw_sp2_port_speed_base,
 	.reg_ptys_eth_pack		= mlxsw_sp2_reg_ptys_eth_pack,
 	.reg_ptys_eth_unpack		= mlxsw_sp2_reg_ptys_eth_unpack,
 };
@@ -3530,24 +3460,24 @@ static int
 mlxsw_sp_port_speed_by_width_set(struct mlxsw_sp_port *mlxsw_sp_port)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	u32 eth_proto_cap, eth_proto_admin, eth_proto_oper;
 	const struct mlxsw_sp_port_type_speed_ops *ops;
 	char ptys_pl[MLXSW_REG_PTYS_LEN];
-	u32 eth_proto_admin;
-	u32 upper_speed;
-	u32 base_speed;
 	int err;
 
 	ops = mlxsw_sp->port_type_speed_ops;
 
-	err = ops->port_speed_base(mlxsw_sp, mlxsw_sp_port->local_port,
-				   &base_speed);
+	/* Set advertised speeds to supported speeds. */
+	ops->reg_ptys_eth_pack(mlxsw_sp, ptys_pl, mlxsw_sp_port->local_port,
+			       0, false);
+	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(ptys), ptys_pl);
 	if (err)
 		return err;
-	upper_speed = base_speed * mlxsw_sp_port->mapping.width;
 
-	eth_proto_admin = ops->to_ptys_upper_speed(mlxsw_sp, upper_speed);
+	ops->reg_ptys_eth_unpack(mlxsw_sp, ptys_pl, &eth_proto_cap,
+				 &eth_proto_admin, &eth_proto_oper);
 	ops->reg_ptys_eth_pack(mlxsw_sp, ptys_pl, mlxsw_sp_port->local_port,
-			       eth_proto_admin, mlxsw_sp_port->link.autoneg);
+			       eth_proto_cap, mlxsw_sp_port->link.autoneg);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ptys), ptys_pl);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 3522f9674577..9708156e7871 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -33,9 +33,6 @@
 
 #define MLXSW_SP_MID_MAX 7000
 
-#define MLXSW_SP_PORT_BASE_SPEED_25G 25000 /* Mb/s */
-#define MLXSW_SP_PORT_BASE_SPEED_50G 50000 /* Mb/s */
-
 #define MLXSW_SP_KVD_LINEAR_SIZE 98304 /* entries */
 #define MLXSW_SP_KVD_GRANULARITY 128
 
@@ -310,9 +307,6 @@ struct mlxsw_sp_port_type_speed_ops {
 	u32 (*to_ptys_advert_link)(struct mlxsw_sp *mlxsw_sp, u8 width,
 				   const struct ethtool_link_ksettings *cmd);
 	u32 (*to_ptys_speed)(struct mlxsw_sp *mlxsw_sp, u8 width, u32 speed);
-	u32 (*to_ptys_upper_speed)(struct mlxsw_sp *mlxsw_sp, u32 upper_speed);
-	int (*port_speed_base)(struct mlxsw_sp *mlxsw_sp, u8 local_port,
-			       u32 *base_speed);
 	void (*reg_ptys_eth_pack)(struct mlxsw_sp *mlxsw_sp, char *payload,
 				  u8 local_port, u32 proto_admin, bool autoneg);
 	void (*reg_ptys_eth_unpack)(struct mlxsw_sp *mlxsw_sp, char *payload,
-- 
2.21.1

