Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6842BC485
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 09:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbgKVI3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 03:29:21 -0500
Received: from mailout09.rmx.de ([94.199.88.74]:41541 "EHLO mailout09.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727286AbgKVI3V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Nov 2020 03:29:21 -0500
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout09.rmx.de (Postfix) with ESMTPS id 4Cf3NY00lZzbkvY;
        Sun, 22 Nov 2020 09:29:17 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4Cf3NJ21VFz2TRjV;
        Sun, 22 Nov 2020 09:29:04 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.14) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Sun, 22 Nov
 2020 09:28:02 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Christian Eggers <ceggers@arri.de>,
        "Christian Eggers" <ceggers@gmx.de>,
        Petr Machata <petrm@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/3] mlxsw: spectrum_ptp: use PTP wide message type definitions
Date:   Sun, 22 Nov 2020 09:26:35 +0100
Message-ID: <20201122082636.12451-3-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201122082636.12451-1-ceggers@arri.de>
References: <20201122082636.12451-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.14]
X-RMX-ID: 20201122-092906-4Cf3NJ21VFz2TRjV-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use recently introduced PTP wide defines instead of a driver internal
enumeration.

Signed-off-by: Christian Eggers <ceggers@gmx.de>
Cc: Petr Machata <petrm@mellanox.com>
Cc: Jiri Pirko <jiri@nvidia.com>
Cc: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c | 8 ++++----
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h | 7 -------
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index ca8090a28dec..d6e9ecb14681 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -828,10 +828,10 @@ struct mlxsw_sp_ptp_state *mlxsw_sp1_ptp_init(struct mlxsw_sp *mlxsw_sp)
 		goto err_hashtable_init;
 
 	/* Delive these message types as PTP0. */
-	message_type = BIT(MLXSW_SP_PTP_MESSAGE_TYPE_SYNC) |
-		       BIT(MLXSW_SP_PTP_MESSAGE_TYPE_DELAY_REQ) |
-		       BIT(MLXSW_SP_PTP_MESSAGE_TYPE_PDELAY_REQ) |
-		       BIT(MLXSW_SP_PTP_MESSAGE_TYPE_PDELAY_RESP);
+	message_type = BIT(PTP_MSGTYPE_SYNC) |
+		       BIT(PTP_MSGTYPE_DELAY_REQ) |
+		       BIT(PTP_MSGTYPE_PDELAY_REQ) |
+		       BIT(PTP_MSGTYPE_PDELAY_RESP);
 	err = mlxsw_sp_ptp_mtptpt_set(mlxsw_sp, MLXSW_REG_MTPTPT_TRAP_ID_PTP0,
 				      message_type);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
index 8c386571afce..1d43a3755285 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
@@ -11,13 +11,6 @@ struct mlxsw_sp;
 struct mlxsw_sp_port;
 struct mlxsw_sp_ptp_clock;
 
-enum {
-	MLXSW_SP_PTP_MESSAGE_TYPE_SYNC,
-	MLXSW_SP_PTP_MESSAGE_TYPE_DELAY_REQ,
-	MLXSW_SP_PTP_MESSAGE_TYPE_PDELAY_REQ,
-	MLXSW_SP_PTP_MESSAGE_TYPE_PDELAY_RESP,
-};
-
 static inline int mlxsw_sp_ptp_get_ts_info_noptp(struct ethtool_ts_info *info)
 {
 	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
-- 
Christian Eggers
Embedded software developer

