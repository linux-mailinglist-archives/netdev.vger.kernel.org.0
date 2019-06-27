Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27185583E6
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 15:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfF0Nxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 09:53:53 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46809 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727016AbfF0Nxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 09:53:50 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 85E7D21F30;
        Thu, 27 Jun 2019 09:53:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 27 Jun 2019 09:53:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=ORxLzjxMUoK7OfArqxM+BId430uk8pwcFzNeIG7KfRc=; b=APT1FITc
        IVdwB8OWSMj+0J0aoomKEEHgQT6trERYh0S0I11ZJrvSferacrsqibavuRvpmU5x
        khhVqP+u+Msi435kSr/l66I3Ia1ABowaitXqpF6mBDr/XzIINHVvKZDe+urWvxT4
        ELw/8sgVzsiEKHyRYt+bfb/T9rYhMRFPB2tbuumuBi7dr11zNY87Zc5q/ntZ+iVS
        JY4Y9ytsK6UPYw+Cb4oguJMjELz9InDK9QH4W0NdZIhbEHQlmtO5WBx92/M3cTht
        NySbqOme9TtCcUKoZhm86z4nlvALFoQidzfs0B7SUxTB0td/GJIaP0AbSXBdMzMI
        F8+6AtJWmycbtA==
X-ME-Sender: <xms:bcoUXbAjd8-Z8mOgqslXvaV4c7xaVaJJoY65H6vm8DGn2cqVu_NWGw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudekgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepge
X-ME-Proxy: <xmx:bcoUXbmxVzhqXtWW_WsuKhPd25qeOfkfyF83xwqxlzI8E7bRKj3CDg>
    <xmx:bcoUXWc9aX996QFaj1HzxgIq-Qfz5oCxKT1kl_sbToo3y4fiHWU2zA>
    <xmx:bcoUXfSpVkhxwYT8yVEzc8oA4E_JuWUzKnBH-Dr3PiXZtGukf0hqng>
    <xmx:bcoUXZiI6GrUOCGuLJWdIkl-GBEB0qfX4z48To_LONy5YFMFPxPvfg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 24E598005A;
        Thu, 27 Jun 2019 09:53:48 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 06/16] mlxsw: spectrum: Add support for traps specific to Spectrum-1
Date:   Thu, 27 Jun 2019 16:52:49 +0300
Message-Id: <20190627135259.7292-7-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627135259.7292-1-idosch@idosch.org>
References: <20190627135259.7292-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

On Spectrum-1, timestamps for PTP packets are delivered through queues
of ingress and egress timestamps. There are two event traps
corresponding to activity on each of those queues. This mechanism is
absent on Spectrum-2, and therefore the traps should only be registered
on Spectrum-1.

Carry a chip-specific listener array in mlxsw_sp->listeners and
listeners_count. Register listeners from that array in
mlxsw_sp_traps_init(). Add a new listener array for Spectrum-1 traps and
configure the newly-added mlxsw_sp->listeners with this array.

The listener array is empty for now, the events will be added in a later
patch.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 25 +++++++++++++++++--
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  2 ++
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 0119efe0ea7a..91486193454a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4114,6 +4114,9 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	MLXSW_SP_RXL_NO_MARK(NVE_DECAP_ARP, TRAP_TO_CPU, ARP, false),
 };
 
+static const struct mlxsw_listener mlxsw_sp1_listener[] = {
+};
+
 static int mlxsw_sp_cpu_policers_set(struct mlxsw_core *mlxsw_core)
 {
 	char qpcr_pl[MLXSW_REG_QPCR_LEN];
@@ -4302,12 +4305,28 @@ static int mlxsw_sp_traps_init(struct mlxsw_sp *mlxsw_sp)
 	if (err)
 		return err;
 
-	return mlxsw_sp_traps_register(mlxsw_sp, mlxsw_sp_listener,
-				       ARRAY_SIZE(mlxsw_sp_listener));
+	err = mlxsw_sp_traps_register(mlxsw_sp, mlxsw_sp_listener,
+				      ARRAY_SIZE(mlxsw_sp_listener));
+	if (err)
+		return err;
+
+	err = mlxsw_sp_traps_register(mlxsw_sp, mlxsw_sp->listeners,
+				      mlxsw_sp->listeners_count);
+	if (err)
+		goto err_extra_traps_init;
+
+	return 0;
+
+err_extra_traps_init:
+	mlxsw_sp_traps_unregister(mlxsw_sp, mlxsw_sp_listener,
+				  ARRAY_SIZE(mlxsw_sp_listener));
+	return err;
 }
 
 static void mlxsw_sp_traps_fini(struct mlxsw_sp *mlxsw_sp)
 {
+	mlxsw_sp_traps_unregister(mlxsw_sp, mlxsw_sp->listeners,
+				  mlxsw_sp->listeners_count);
 	mlxsw_sp_traps_unregister(mlxsw_sp, mlxsw_sp_listener,
 				  ARRAY_SIZE(mlxsw_sp_listener));
 }
@@ -4566,6 +4585,8 @@ static int mlxsw_sp1_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->sb_vals = &mlxsw_sp1_sb_vals;
 	mlxsw_sp->port_type_speed_ops = &mlxsw_sp1_port_type_speed_ops;
 	mlxsw_sp->ptp_ops = &mlxsw_sp1_ptp_ops;
+	mlxsw_sp->listeners = mlxsw_sp1_listener;
+	mlxsw_sp->listeners_count = ARRAY_SIZE(mlxsw_sp1_listener);
 
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info);
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 84f4276193b3..9136a86dc55f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -175,6 +175,8 @@ struct mlxsw_sp {
 	const struct mlxsw_sp_sb_vals *sb_vals;
 	const struct mlxsw_sp_port_type_speed_ops *port_type_speed_ops;
 	const struct mlxsw_sp_ptp_ops *ptp_ops;
+	const struct mlxsw_listener *listeners;
+	size_t listeners_count;
 };
 
 static inline struct mlxsw_sp_upper *
-- 
2.20.1

