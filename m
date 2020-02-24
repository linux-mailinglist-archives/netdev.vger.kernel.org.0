Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C65FE169F5A
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 08:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgBXHgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 02:36:16 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35804 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbgBXHgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 02:36:07 -0500
Received: by mail-wm1-f68.google.com with SMTP id b17so8196614wmb.0
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 23:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vSVqmRDoeGtXqy1fT3V/prdd3MtQml78TjJPvMzCblw=;
        b=U8p8NUbLMJmcGy6KDei/m3wkeVg5wQd4a4SU17zUQ7DNpOf7ljtyKTIvAFlrHALoV9
         kP8Lj8rm+Rn7OogDMJ4IiyPYkY24lQacCcA13o5Do/P9v3DCJsX1A/iEtuLKOQVEMGnr
         e615yhUWRztUobzjI6lVhiukGYMHGQTziMrDJyo7Cl4yibZa7wdMWg69YlCjBOVA0NdR
         6Vu4W2Yk9OrTOAKGTkNIX2t8XhXhgSYy/wtphJxqD6UhYWlF9SG+PtZu5W78phYcwcid
         3i9B0zPOMzP4UYYu/c+o1PEkAGExIFzQgnTkwSn+YT7zHv9kNMBz36rci+BfwzrzmWeE
         jNiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vSVqmRDoeGtXqy1fT3V/prdd3MtQml78TjJPvMzCblw=;
        b=LtVtPz1d96UZI5+YxnuvMZxqMg9jqb5fpjKV841PoVlOCS3JFOKv7RRnR0kXPvv4ch
         nq21nfLURPS5Y1U74YbkQpWVui6mYYeJBJog1nLFCfJGsTACcMoM4JtdsrG2/sDJAHdy
         JtN9vou8w+IenD+zb32qaxd/LOtIUvZlM0/EJeC7ze2zVd96ReDk8wWtwTR05m6TCiRL
         rima/8FjuGG/Zh59oWPdk4BrjmQ8F0///06dXUkp2QFaUBYjkTcUJVnca9w/3Jyqj3hf
         vGAOXjjIy4+oWcKA5vPDgHIuGSk9w+D2mUD9xaTrEEo/XEZCm2mzoi2N4YFjNzJzU3P+
         A4Ug==
X-Gm-Message-State: APjAAAUt2I5tuU1twucl6WuV7wy5UEVvKgQQVSL/2+VEVyqghIOZl1JI
        E4WYDkDmMTW+e9CPUGBMQBfH+u4OwEo=
X-Google-Smtp-Source: APXvYqzG7xw9GryBrS5mdM8yQJqiyJKTVfat0ISXX5CFbLDwcVlb9dc8rZuavrMnPEfyVgp1BmoWnw==
X-Received: by 2002:a7b:c190:: with SMTP id y16mr20790882wmi.107.1582529764410;
        Sun, 23 Feb 2020 23:36:04 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id z16sm31059wrp.33.2020.02.23.23.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 23:36:04 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 04/16] mlxsw: spectrum_trap: Prepare mlxsw_core_trap_action_set() to handle not only action
Date:   Mon, 24 Feb 2020 08:35:46 +0100
Message-Id: <20200224073558.26500-5-jiri@resnulli.us>
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

Rename function mlxsw_core_trap_action_set() to
mlxsw_core_trap_state_set() and pass bool enabled instead of action.
Figure out the action according to the enabled state there.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c          | 10 ++++++----
 drivers/net/ethernet/mellanox/mlxsw/core.h          |  6 +++---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c | 11 ++++-------
 3 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index a01868282008..167df7e4d678 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1669,17 +1669,19 @@ void mlxsw_core_trap_unregister(struct mlxsw_core *mlxsw_core,
 }
 EXPORT_SYMBOL(mlxsw_core_trap_unregister);
 
-int mlxsw_core_trap_action_set(struct mlxsw_core *mlxsw_core,
-			       const struct mlxsw_listener *listener,
-			       enum mlxsw_reg_hpkt_action action)
+int mlxsw_core_trap_state_set(struct mlxsw_core *mlxsw_core,
+			      const struct mlxsw_listener *listener,
+			      bool enabled)
 {
+	enum mlxsw_reg_hpkt_action action;
 	char hpkt_pl[MLXSW_REG_HPKT_LEN];
 
+	action = enabled ? listener->en_action : listener->dis_action;
 	mlxsw_reg_hpkt_pack(hpkt_pl, action, listener->trap_id,
 			    listener->trap_group, listener->is_ctrl);
 	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(hpkt), hpkt_pl);
 }
-EXPORT_SYMBOL(mlxsw_core_trap_action_set);
+EXPORT_SYMBOL(mlxsw_core_trap_state_set);
 
 static u64 mlxsw_core_tid_get(struct mlxsw_core *mlxsw_core)
 {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 9c4ce3f65944..b6e57cbc084e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -145,9 +145,9 @@ int mlxsw_core_trap_register(struct mlxsw_core *mlxsw_core,
 void mlxsw_core_trap_unregister(struct mlxsw_core *mlxsw_core,
 				const struct mlxsw_listener *listener,
 				void *priv);
-int mlxsw_core_trap_action_set(struct mlxsw_core *mlxsw_core,
-			       const struct mlxsw_listener *listener,
-			       enum mlxsw_reg_hpkt_action action);
+int mlxsw_core_trap_state_set(struct mlxsw_core *mlxsw_core,
+			      const struct mlxsw_listener *listener,
+			      bool enabled);
 
 typedef void mlxsw_reg_trans_cb_t(struct mlxsw_core *mlxsw_core, char *payload,
 				  size_t payload_len, unsigned long cb_priv);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 7c6a9634cdbc..afd3f28ec9f6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -320,26 +320,23 @@ int mlxsw_sp_trap_action_set(struct mlxsw_core *mlxsw_core,
 
 	for (i = 0; i < ARRAY_SIZE(mlxsw_sp_listener_devlink_map); i++) {
 		const struct mlxsw_listener *listener;
-		enum mlxsw_reg_hpkt_action hw_action;
+		bool enabled;
 		int err;
 
 		if (mlxsw_sp_listener_devlink_map[i] != trap->id)
 			continue;
 		listener = &mlxsw_sp_listeners_arr[i];
-
 		switch (action) {
 		case DEVLINK_TRAP_ACTION_DROP:
-			hw_action = listener->dis_action;
+			enabled = false;
 			break;
 		case DEVLINK_TRAP_ACTION_TRAP:
-			hw_action = listener->en_action;
+			enabled = true;
 			break;
 		default:
 			return -EINVAL;
 		}
-
-		err = mlxsw_core_trap_action_set(mlxsw_core, listener,
-						 hw_action);
+		err = mlxsw_core_trap_state_set(mlxsw_core, listener, enabled);
 		if (err)
 			return err;
 	}
-- 
2.21.1

