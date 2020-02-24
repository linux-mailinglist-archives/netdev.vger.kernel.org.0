Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4957169F54
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 08:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbgBXHgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 02:36:04 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41052 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgBXHgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 02:36:03 -0500
Received: by mail-wr1-f66.google.com with SMTP id c9so9084828wrw.8
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 23:36:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zkqTNoSBGliT2CXZc8qzSZO4CqThApF2gA0YBw/q72Y=;
        b=QvwTxNQwGzSi4sf5yRfYpwX+kSJl1f96uwNpJ215PlviamkGslXy5QWMKQAOwFxZzI
         Lm9cMsCYgodjSAzoy7eukCv3BCO2UtTQf13Xz+iWnbb/FGlFxu/psZs7pB1bCfFojdrC
         9opQzk0srC2P2Olt112MJ4k5MdKbhamcndyyznRVGc+AShzGp1R81ZtaG2nU12xrBgIe
         sjdTC9if3h01khwIRNCq/zfkKLy9tZTp6QDq+ak98yoQT1S2pTQsr/OO+6zAOkR0M2ja
         tQw8FSFdpmJMnlXCsP3AF9xfvf9vqJ4Vu3d4IpxWxA9yynvaOHI9+OhhP78f3NMswbwn
         DdeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zkqTNoSBGliT2CXZc8qzSZO4CqThApF2gA0YBw/q72Y=;
        b=iZfXKHBUfO9liS574Q30tuSgCUmFgFoPIj7/c45Vrigo4qvIkIe5g5M08eaxQ1EZMK
         H+d2awSBXD07rBoiaT826iCgTmBl+VCX6KOkkWTp7CnBC5h2JTSlUrr0+nSEjHNRMTQx
         8YzHg04/4OWjG6GKiPr9l7dALFBJtPhbRXoIxGXuj8oJrvrjdzYxt79oy9Si5bHY9oFw
         P8caimeNpi4VqpqIAuLImjbpULABSOIzsdfP52ckSW3qy5OJ5eH1NhCPETMx5Xu/N6aB
         R8SHUkhO6MPMjOEOTLs54uE1NgHJfV3249pjRX9DsPgLQKIpNLzCvV69dEI+hNy+xeG5
         YEBw==
X-Gm-Message-State: APjAAAVYeCTAKRfuY0CMeaAsK85Ccdf30/mWbS/YnuTnreyapT8/FLrB
        zJyeTtxzRA07EGl44mJXJ+NKtHBopnk=
X-Google-Smtp-Source: APXvYqw2D/pvM1xv3c4hFY4s70dXKGGoeKIHCyJCtEzZHsVVyiisI9E3AFpkO5reyhE31UC7vpBHLA==
X-Received: by 2002:a5d:6087:: with SMTP id w7mr63697157wrt.36.1582529762061;
        Sun, 23 Feb 2020 23:36:02 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id m68sm16852657wme.48.2020.02.23.23.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 23:36:01 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 02/16] mlxsw: core: Allow to register disabled traps using MLXSW_RXL_DIS
Date:   Mon, 24 Feb 2020 08:35:44 +0100
Message-Id: <20200224073558.26500-3-jiri@resnulli.us>
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

Introduce a new macro MLXSW_RXL_DIS that allows to register listeners
as disabled. That allows that from now on, the "action" can be
understood always as "enabled action" and "unreg_action" as "disabled
action". Rename them and treat them accordingly.

Use the new macro for defining drops in spectrum_trap.c.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  7 +++--
 drivers/net/ethernet/mellanox/mlxsw/core.h    | 31 ++++++++++++++-----
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |  5 +--
 3 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 4b92ba574073..a01868282008 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1628,6 +1628,7 @@ static void mlxsw_core_listener_unregister(struct mlxsw_core *mlxsw_core,
 int mlxsw_core_trap_register(struct mlxsw_core *mlxsw_core,
 			     const struct mlxsw_listener *listener, void *priv)
 {
+	enum mlxsw_reg_hpkt_action action;
 	char hpkt_pl[MLXSW_REG_HPKT_LEN];
 	int err;
 
@@ -1635,7 +1636,9 @@ int mlxsw_core_trap_register(struct mlxsw_core *mlxsw_core,
 	if (err)
 		return err;
 
-	mlxsw_reg_hpkt_pack(hpkt_pl, listener->action, listener->trap_id,
+	action = listener->enabled_on_register ? listener->en_action :
+						 listener->dis_action;
+	mlxsw_reg_hpkt_pack(hpkt_pl, action, listener->trap_id,
 			    listener->trap_group, listener->is_ctrl);
 	err = mlxsw_reg_write(mlxsw_core,  MLXSW_REG(hpkt), hpkt_pl);
 	if (err)
@@ -1656,7 +1659,7 @@ void mlxsw_core_trap_unregister(struct mlxsw_core *mlxsw_core,
 	char hpkt_pl[MLXSW_REG_HPKT_LEN];
 
 	if (!listener->is_event) {
-		mlxsw_reg_hpkt_pack(hpkt_pl, listener->unreg_action,
+		mlxsw_reg_hpkt_pack(hpkt_pl, listener->dis_action,
 				    listener->trap_id, listener->trap_group,
 				    listener->is_ctrl);
 		mlxsw_reg_write(mlxsw_core, MLXSW_REG(hpkt), hpkt_pl);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 5773e25ecf98..9c4ce3f65944 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -76,15 +76,18 @@ struct mlxsw_listener {
 		struct mlxsw_rx_listener rx_listener;
 		struct mlxsw_event_listener event_listener;
 	};
-	enum mlxsw_reg_hpkt_action action;
-	enum mlxsw_reg_hpkt_action unreg_action;
+	enum mlxsw_reg_hpkt_action en_action; /* Action when enabled */
+	enum mlxsw_reg_hpkt_action dis_action; /* Action when disabled */
 	u8 trap_group;
 	u8 is_ctrl:1, /* should go via control buffer or not */
-	   is_event:1;
+	   is_event:1,
+	   enabled_on_register:1; /* Trap should be enabled when listener
+				   * is registered.
+				   */
 };
 
-#define MLXSW_RXL(_func, _trap_id, _action, _is_ctrl, _trap_group,	\
-		  _unreg_action)					\
+#define __MLXSW_RXL(_func, _trap_id, _en_action, _is_ctrl, _trap_group,	\
+		    _dis_action, _enabled_on_register)			\
 	{								\
 		.trap_id = MLXSW_TRAP_ID_##_trap_id,			\
 		.rx_listener =						\
@@ -93,12 +96,23 @@ struct mlxsw_listener {
 			.local_port = MLXSW_PORT_DONT_CARE,		\
 			.trap_id = MLXSW_TRAP_ID_##_trap_id,		\
 		},							\
-		.action = MLXSW_REG_HPKT_ACTION_##_action,		\
-		.unreg_action = MLXSW_REG_HPKT_ACTION_##_unreg_action,	\
+		.en_action = MLXSW_REG_HPKT_ACTION_##_en_action,	\
+		.dis_action = MLXSW_REG_HPKT_ACTION_##_dis_action,	\
 		.trap_group = MLXSW_REG_HTGT_TRAP_GROUP_##_trap_group,	\
 		.is_ctrl = _is_ctrl,					\
+		.enabled_on_register = _enabled_on_register,		\
 	}
 
+#define MLXSW_RXL(_func, _trap_id, _en_action, _is_ctrl, _trap_group,		\
+		  _dis_action)							\
+	__MLXSW_RXL(_func, _trap_id, _en_action, _is_ctrl, _trap_group,		\
+		    _dis_action, true)
+
+#define MLXSW_RXL_DIS(_func, _trap_id, _en_action, _is_ctrl, _trap_group,	\
+		      _dis_action)						\
+	__MLXSW_RXL(_func, _trap_id, _en_action, _is_ctrl, _trap_group,		\
+		    _dis_action, false)
+
 #define MLXSW_EVENTL(_func, _trap_id, _trap_group)			\
 	{								\
 		.trap_id = MLXSW_TRAP_ID_##_trap_id,			\
@@ -107,9 +121,10 @@ struct mlxsw_listener {
 			.func = _func,					\
 			.trap_id = MLXSW_TRAP_ID_##_trap_id,		\
 		},							\
-		.action = MLXSW_REG_HPKT_ACTION_TRAP_TO_CPU,		\
+		.en_action = MLXSW_REG_HPKT_ACTION_TRAP_TO_CPU,		\
 		.trap_group = MLXSW_REG_HTGT_TRAP_GROUP_##_trap_group,	\
 		.is_event = true,					\
+		.enabled_on_register = true,				\
 	}
 
 int mlxsw_core_rx_listener_register(struct mlxsw_core *mlxsw_core,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 1622fec6512d..7b0fb3cf71ea 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -118,8 +118,9 @@ static void mlxsw_sp_rx_exception_listener(struct sk_buff *skb, u8 local_port,
 			     MLXSW_SP_TRAP_METADATA)
 
 #define MLXSW_SP_RXL_DISCARD(_id, _group_id)				      \
-	MLXSW_RXL(mlxsw_sp_rx_drop_listener, DISCARD_##_id, SET_FW_DEFAULT,   \
-		  false, SP_##_group_id, SET_FW_DEFAULT)
+	MLXSW_RXL_DIS(mlxsw_sp_rx_drop_listener, DISCARD_##_id,		      \
+		      TRAP_EXCEPTION_TO_CPU, false, SP_##_group_id,	      \
+		      SET_FW_DEFAULT)
 
 #define MLXSW_SP_RXL_EXCEPTION(_id, _group_id, _action)			      \
 	MLXSW_RXL(mlxsw_sp_rx_exception_listener, _id,			      \
-- 
2.21.1

