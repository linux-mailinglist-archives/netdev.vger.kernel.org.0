Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 629881485EE
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 14:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389683AbgAXNYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 08:24:25 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33165 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389661AbgAXNYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 08:24:24 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 15A3521F3C;
        Fri, 24 Jan 2020 08:24:23 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 24 Jan 2020 08:24:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=zE9BVUvdtlFgRvKF08x2wQH5C21rIL2LpRIM7b+ILVQ=; b=wCvQigxX
        ffcki/bbXoK6JrF+TwhYj1aUaqrVSZR0li1+5vBNKkmujSkMzaMi6J9acFQMSfVC
        Iapf7ObfMTkRJMJdA2F4e+fqL/7qOW0BTglTvS74T4a6vhOQcGOIJTu7wFdlxCII
        EMJCkmwtWmxFg3kwTO+OKIByYP980keOXcCnDLMw87UBT2XxeosDPiQ/Ao7C02GB
        XATYGzVDc7DRfR7j8Jfw3ICZ/dCwJMPnId1BxQcC7aCAInK5YNtwQcvSHo2YOyLZ
        euR2thu6loMwITdxp+uaKHQqb4pA3ERMS/pbUPUvjUv7qlNJsuW0W4gSOY/i0T69
        XkXGEEBTOIsK+g==
X-ME-Sender: <xms:BvAqXlQASj3ejIMfI_icM07n75KpqsHDAqhawYcIEy4RE1kYHxSckQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrvdeggdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukeefrddutdejrdduvddtnecuvehluhhsthgvrh
    fuihiivgepkeenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:BvAqXuDT895_MPy-4v6O6njRejp7VfGe6J6fkK6BcZcKxj9sKjCh9A>
    <xmx:BvAqXtpqC6s1pAO60kUVJzHJGgHqDfRIohlxzbqgjn1Ql1OwEXEnOg>
    <xmx:BvAqXkgyph_sXijh7O_i3RoISnG7-a03W_tSE_oyh_rhCV6O9tor2Q>
    <xmx:B_AqXrbRdICWjn9llapWQ5UHtuySC_CYXLZQ4ojfy8I4Ry5tctSKig>
Received: from splinter.mtl.com (bzq-79-183-107-120.red.bezeqint.net [79.183.107.120])
        by mail.messagingengine.com (Postfix) with ESMTPA id D1A0A3061106;
        Fri, 24 Jan 2020 08:24:20 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 09/14] mlxsw: spectrum: Configure shaper rate and burst size together
Date:   Fri, 24 Jan 2020 15:23:13 +0200
Message-Id: <20200124132318.712354-10-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200124132318.712354-1-idosch@idosch.org>
References: <20200124132318.712354-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

In order to allow configuration of burst size together with shaper rate,
extend mlxsw_sp_port_ets_maxrate_set() with a burst_size argument. Convert
call sites to pass 0 (for default).

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     | 11 ++++++-----
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c |  5 +++--
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 72d24595df7a..021664c62bba 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3577,7 +3577,7 @@ int mlxsw_sp_port_ets_set(struct mlxsw_sp_port *mlxsw_sp_port,
 
 int mlxsw_sp_port_ets_maxrate_set(struct mlxsw_sp_port *mlxsw_sp_port,
 				  enum mlxsw_reg_qeec_hr hr, u8 index,
-				  u8 next_index, u32 maxrate)
+				  u8 next_index, u32 maxrate, u8 burst_size)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	char qeec_pl[MLXSW_REG_QEEC_LEN];
@@ -3586,6 +3586,7 @@ int mlxsw_sp_port_ets_maxrate_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			    next_index);
 	mlxsw_reg_qeec_mase_set(qeec_pl, true);
 	mlxsw_reg_qeec_max_shaper_rate_set(qeec_pl, maxrate);
+	mlxsw_reg_qeec_max_shaper_bs_set(qeec_pl, burst_size);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(qeec), qeec_pl);
 }
 
@@ -3654,14 +3655,14 @@ static int mlxsw_sp_port_ets_init(struct mlxsw_sp_port *mlxsw_sp_port)
 	 */
 	err = mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
 					    MLXSW_REG_QEEC_HR_PORT, 0, 0,
-					    MLXSW_REG_QEEC_MAS_DIS);
+					    MLXSW_REG_QEEC_MAS_DIS, 0);
 	if (err)
 		return err;
 	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		err = mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
 						    MLXSW_REG_QEEC_HR_SUBGROUP,
 						    i, 0,
-						    MLXSW_REG_QEEC_MAS_DIS);
+						    MLXSW_REG_QEEC_MAS_DIS, 0);
 		if (err)
 			return err;
 	}
@@ -3669,14 +3670,14 @@ static int mlxsw_sp_port_ets_init(struct mlxsw_sp_port *mlxsw_sp_port)
 		err = mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
 						    MLXSW_REG_QEEC_HR_TC,
 						    i, i,
-						    MLXSW_REG_QEEC_MAS_DIS);
+						    MLXSW_REG_QEEC_MAS_DIS, 0);
 		if (err)
 			return err;
 
 		err = mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
 						    MLXSW_REG_QEEC_HR_TC,
 						    i + 8, i,
-						    MLXSW_REG_QEEC_MAS_DIS);
+						    MLXSW_REG_QEEC_MAS_DIS, 0);
 		if (err)
 			return err;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index bbc23939964e..a2393c02a5e5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -488,7 +488,7 @@ int __mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port, int mtu,
 				 struct ieee_pfc *my_pfc);
 int mlxsw_sp_port_ets_maxrate_set(struct mlxsw_sp_port *mlxsw_sp_port,
 				  enum mlxsw_reg_qeec_hr hr, u8 index,
-				  u8 next_index, u32 maxrate);
+				  u8 next_index, u32 maxrate, u8 burst_size);
 enum mlxsw_reg_spms_state mlxsw_sp_stp_spms_state(u8 stp_state);
 int mlxsw_sp_port_vid_stp_set(struct mlxsw_sp_port *mlxsw_sp_port, u16 vid,
 			      u8 state);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
index db66f2b56a6d..49a72a8f1f57 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
@@ -526,7 +526,7 @@ static int mlxsw_sp_dcbnl_ieee_setmaxrate(struct net_device *dev,
 		err = mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
 						    MLXSW_REG_QEEC_HR_SUBGROUP,
 						    i, 0,
-						    maxrate->tc_maxrate[i]);
+						    maxrate->tc_maxrate[i], 0);
 		if (err) {
 			netdev_err(dev, "Failed to set maxrate for TC %d\n", i);
 			goto err_port_ets_maxrate_set;
@@ -541,7 +541,8 @@ static int mlxsw_sp_dcbnl_ieee_setmaxrate(struct net_device *dev,
 	for (i--; i >= 0; i--)
 		mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
 					      MLXSW_REG_QEEC_HR_SUBGROUP,
-					      i, 0, my_maxrate->tc_maxrate[i]);
+					      i, 0,
+					      my_maxrate->tc_maxrate[i], 0);
 	return err;
 }
 
-- 
2.24.1

