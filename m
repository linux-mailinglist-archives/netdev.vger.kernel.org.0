Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3553169F5E
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 08:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgBXHgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 02:36:20 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:32969 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727438AbgBXHgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 02:36:17 -0500
Received: by mail-wr1-f67.google.com with SMTP id u6so9107708wrt.0
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 23:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pPd3X1m78oMmZwPxGsto5nkx2uuLKq4mnIDrxDwtsxw=;
        b=fBhXckaXlGiygBpoRdsKu1y8ltd+ob7Tdcbi3yogA4AfRCJkI0n7KiBjuKQelr7unL
         RpDtx8G1TV8NRF1EJQgtwEcskRh38m1gzVIv0+AXTSztmnFjuYfGqnzelTzfufN0oJ0z
         9MEf9guaKbrouXoVt7Zrc6eVjKD59Hljom29JwxrVP+fzoX6iBnqlhuGYWKB7mWm4F6o
         ZbSYlE3CT0+EJbHmRI3pj1EdGzB3gyAm609R6n9oaqbMG8NX4XgaXJQtiq7DP7J8Zc5O
         muMAFjXK8OsJsHB1jJ/pGjimVQKBbW0mnYJsmOa1qVewxOC2Q0Y4HM4Gez9hMNHeVXtG
         Qv6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pPd3X1m78oMmZwPxGsto5nkx2uuLKq4mnIDrxDwtsxw=;
        b=AhIlRbXCxLGDSn+iir19g5OMm9YG1COtSnMG+De1A7Vwu/NO0Kt9Ff0SQ/JpdV4Uru
         3zuRcfq+bwFT6tlaGJJz7G2ebi4NETy+0NOs2UoXaMIefjRin04aeiluCK1zqU9nfJTg
         prv1YVcYlrOTwxNBhmz3CKMTtD13bJs8R4patiJXlilKf+z9THoA5ag47y4AIUYni4+r
         FrLdoqxBQCBa+6GnI75Hs9kg9Tgu26ioZSPamMc/KUYVt80yiz8/sTBMHUqzkrWaRigg
         DcJsxv/wO19uDwcY1mYyFFKmWvEtkrLyzr0hqVddJ4lCJFBXeAicRgx21S4m4EUzo+uH
         MaeQ==
X-Gm-Message-State: APjAAAXIy4qb9O6lQuTCdZ3qfZM/BPPB7dwSJd8OguvFomyfYtAKX4YH
        ye6yPgxGKk/T4AjTpvnVQVifSmZB72o=
X-Google-Smtp-Source: APXvYqxQ8J504T4n3Cje7zzwyDkjbwpmMzQGSmmTJEe7xohQ2KT9NX/1LvhztO9vsSJjj69nbY0yrg==
X-Received: by 2002:adf:fac9:: with SMTP id a9mr1127716wrs.232.1582529775088;
        Sun, 23 Feb 2020 23:36:15 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id b18sm17152480wru.50.2020.02.23.23.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 23:36:14 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 13/16] mlxsw: spectrum_trap: Add ACL devlink-trap support
Date:   Mon, 24 Feb 2020 08:35:55 +0100
Message-Id: <20200224073558.26500-14-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200224073558.26500-1-jiri@resnulli.us>
References: <20200224073558.26500-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Add the trap group used to report ACL drops. Setup the trap IDs for
ingress/egress flow action drop. Register the two packet traps
associated with ACL trap group with devlink during driver
initialization. As these are "source traps", set the disabled
trap group to be the dummy, discarding as many packets in HW
as possible.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h       |  1 +
 .../net/ethernet/mellanox/mlxsw/spectrum_trap.c | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index d82765191749..e22cea92fbce 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5530,6 +5530,7 @@ enum mlxsw_reg_htgt_discard_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_L2_DISCARDS,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_L3_DISCARDS,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_TUNNEL_DISCARDS,
+	MLXSW_REG_HTGT_TRAP_GROUP_SP_ACL_DISCARDS,
 };
 
 /* reg_htgt_trap_group
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 0064470d8366..04f2445f6d43 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -122,6 +122,11 @@ static void mlxsw_sp_rx_exception_listener(struct sk_buff *skb, u8 local_port,
 		      TRAP_EXCEPTION_TO_CPU, false, SP_##_group_id,	      \
 		      SET_FW_DEFAULT, SP_##_group_id)
 
+#define MLXSW_SP_RXL_ACL_DISCARD(_id, _en_group_id, _dis_group_id)	      \
+	MLXSW_RXL_DIS(mlxsw_sp_rx_drop_listener, DISCARD_##_id,		      \
+		      TRAP_EXCEPTION_TO_CPU, false, SP_##_en_group_id,	      \
+		      SET_FW_DEFAULT, SP_##_dis_group_id)
+
 #define MLXSW_SP_RXL_EXCEPTION(_id, _group_id, _action)			      \
 	MLXSW_RXL(mlxsw_sp_rx_exception_listener, _id,			      \
 		   _action, false, SP_##_group_id, SET_FW_DEFAULT)
@@ -155,6 +160,8 @@ static const struct devlink_trap mlxsw_sp_traps_arr[] = {
 	MLXSW_SP_TRAP_DROP(NON_ROUTABLE, L3_DROPS),
 	MLXSW_SP_TRAP_EXCEPTION(DECAP_ERROR, TUNNEL_DROPS),
 	MLXSW_SP_TRAP_DROP(OVERLAY_SMAC_MC, TUNNEL_DROPS),
+	MLXSW_SP_TRAP_DROP(INGRESS_FLOW_ACTION_DROP, ACL_DROPS),
+	MLXSW_SP_TRAP_DROP(EGRESS_FLOW_ACTION_DROP, ACL_DROPS),
 };
 
 static const struct mlxsw_listener mlxsw_sp_listeners_arr[] = {
@@ -196,6 +203,8 @@ static const struct mlxsw_listener mlxsw_sp_listeners_arr[] = {
 	MLXSW_SP_RXL_EXCEPTION(DISCARD_DEC_PKT, TUNNEL_DISCARDS,
 			       TRAP_EXCEPTION_TO_CPU),
 	MLXSW_SP_RXL_DISCARD(OVERLAY_SMAC_MC, TUNNEL_DISCARDS),
+	MLXSW_SP_RXL_ACL_DISCARD(INGRESS_ACL, ACL_DISCARDS, DUMMY),
+	MLXSW_SP_RXL_ACL_DISCARD(EGRESS_ACL, ACL_DISCARDS, DUMMY),
 };
 
 /* Mapping between hardware trap and devlink trap. Multiple hardware traps can
@@ -236,6 +245,8 @@ static const u16 mlxsw_sp_listener_devlink_map[] = {
 	DEVLINK_TRAP_GENERIC_ID_DECAP_ERROR,
 	DEVLINK_TRAP_GENERIC_ID_DECAP_ERROR,
 	DEVLINK_TRAP_GENERIC_ID_OVERLAY_SMAC_MC,
+	DEVLINK_TRAP_GENERIC_ID_INGRESS_FLOW_ACTION_DROP,
+	DEVLINK_TRAP_GENERIC_ID_EGRESS_FLOW_ACTION_DROP,
 };
 
 #define MLXSW_SP_DISCARD_POLICER_ID	(MLXSW_REG_HTGT_TRAP_GROUP_MAX + 1)
@@ -394,6 +405,12 @@ int mlxsw_sp_trap_group_init(struct mlxsw_core *mlxsw_core,
 		priority = 0;
 		tc = 1;
 		break;
+	case DEVLINK_TRAP_GROUP_GENERIC_ID_ACL_DROPS:
+		group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_ACL_DISCARDS;
+		policer_id = MLXSW_SP_DISCARD_POLICER_ID;
+		priority = 0;
+		tc = 1;
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
2.21.1

