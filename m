Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECD7C1485ED
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 14:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389652AbgAXNYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 08:24:23 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58625 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389645AbgAXNYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 08:24:21 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9989A21B74;
        Fri, 24 Jan 2020 08:24:20 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 24 Jan 2020 08:24:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=vUcOJ4sKuOiWdfIPW1XgBSMFdYbFXGhAgdTiol8oAic=; b=VWlspZJd
        b0ascmmhs3Ct9oV9UFNKTtISL9TJdM+hYw+ZtRglf9sEfr2Qx+SDHIRyt0E7hvDz
        ZQTS+yvN7omPRatyw5vHbrEwS4tzHfWvS/ZUmLiDOIWqB+TGKlZj7DRIBEacMp9U
        1xo7x8yXBz47lAjV78JQg5a4vK20irYf0XnHtyHg53ralQGMlQZNpSEFVX8GKPUu
        Sv9AJXHXaaLGH6EF0ooMy30HT6MtndmZBWiNRSOvAAikYmu1llZmv13EtNCx6S40
        ET0lvLDCx32KBU3WT8fyPjyNJhyN3kv4v5Ix+tHlJw2awvSHcEwhee4LH7wdEJuO
        o2neWddYLXh+wA==
X-ME-Sender: <xms:BPAqXpbeZrZg-QQPqUGTHK2H7wQR_Q_Jkcw8QRSIXhbDXqKbUNADIw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrvdeggdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukeefrddutdejrdduvddtnecuvehluhhsthgvrh
    fuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:BPAqXh-GFiWoSeoi1MG10wyyii0oZFZB_M2FcX3lvrsXvtzsoYnoSQ>
    <xmx:BPAqXiTcdgUp3ACnh4fqY3GliSOrrVDCr4qYDwPh2xpws9Dt1n88eA>
    <xmx:BPAqXjdMOrp05Ffzr0ZEsd1ZwgZdmby2qktyyMihKah5Xh7GYXVz-w>
    <xmx:BPAqXgGY4bD0-KIANwmUIkP4hN1z_cOaC6PGoC1EJQ35NJOTBjPyGg>
Received: from splinter.mtl.com (bzq-79-183-107-120.red.bezeqint.net [79.183.107.120])
        by mail.messagingengine.com (Postfix) with ESMTPA id 93F4B306114A;
        Fri, 24 Jan 2020 08:24:18 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 08/14] mlxsw: spectrum: Add lowest_shaper_bs to struct mlxsw_sp
Date:   Fri, 24 Jan 2020 15:23:12 +0200
Message-Id: <20200124132318.712354-9-idosch@idosch.org>
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

Lower limit of burst size configuration is dependent on system type. Add a
datum to track the value. Initialize as appropriate in mlxsw_spX_init().

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 3 +++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 9eb3ac7669f7..72d24595df7a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -5173,6 +5173,7 @@ static int mlxsw_sp1_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->span_ops = &mlxsw_sp1_span_ops;
 	mlxsw_sp->listeners = mlxsw_sp1_listener;
 	mlxsw_sp->listeners_count = ARRAY_SIZE(mlxsw_sp1_listener);
+	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP1;
 
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
 }
@@ -5197,6 +5198,7 @@ static int mlxsw_sp2_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->port_type_speed_ops = &mlxsw_sp2_port_type_speed_ops;
 	mlxsw_sp->ptp_ops = &mlxsw_sp2_ptp_ops;
 	mlxsw_sp->span_ops = &mlxsw_sp2_span_ops;
+	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP2;
 
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
 }
@@ -5219,6 +5221,7 @@ static int mlxsw_sp3_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->port_type_speed_ops = &mlxsw_sp2_port_type_speed_ops;
 	mlxsw_sp->ptp_ops = &mlxsw_sp2_ptp_ops;
 	mlxsw_sp->span_ops = &mlxsw_sp2_span_ops;
+	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP3;
 
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 5f3b74360dc8..bbc23939964e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -189,6 +189,7 @@ struct mlxsw_sp {
 	const struct mlxsw_sp_span_ops *span_ops;
 	const struct mlxsw_listener *listeners;
 	size_t listeners_count;
+	u32 lowest_shaper_bs;
 };
 
 static inline struct mlxsw_sp_upper *
-- 
2.24.1

