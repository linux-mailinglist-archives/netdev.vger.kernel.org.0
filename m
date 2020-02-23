Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCF716969D
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 08:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgBWHbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 02:31:53 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36527 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgBWHbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 02:31:52 -0500
Received: by mail-wm1-f68.google.com with SMTP id p17so6109736wma.1
        for <netdev@vger.kernel.org>; Sat, 22 Feb 2020 23:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BSyYlqaE5i6MhOfJpfXXOWm7o9kL3ED97OvxqP16Sp4=;
        b=WL0RwSbQ1xmAQTGcFtP3vWPJlShA5hUamo0bscuWUb4PCV0FqxMsVFoitL6z3Bq0iC
         54rkw0gOVOSsZ50LYJ0mOWfMlmtKq/+xf9b0L25PxwPGgR+mWherMdbsdOMzqTjbb+Pj
         hHaAyWQnfd/eWwAxz1FL8SLFVMUCfHRdBFvkEyU/7BTXv2P6PmnML+9MFmFIvrVlOKGb
         sUc/bhx2+SSxH4CKb48IlIOrJx4TrHOZ5pUYDGvxRvvV/GbBG9482nWWnV2Z+VQfInRS
         uStvaa0/qRr+Zuq2t1CBFgKMceMKiYOBcvTx94smcb5jglrtGNZAvvLDIJT9pUM7bH/z
         2Wbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BSyYlqaE5i6MhOfJpfXXOWm7o9kL3ED97OvxqP16Sp4=;
        b=pIoMCpjCYpxCaKCMjF1Dk40z4+543aDBcvNLj5p4OHiNm8P+5Zz30xtMbge9QepBsc
         XlkcGNGyGCjlQ74M6cceArrx0t6zVMGsfmyMA8LqIdzGRg7X+94jTprDYkQxqlY/lUZS
         HtEPOo29V9WVQzPAEZRiP7X4hzrc7np931dTZ2jvXdyTl0cdh73oeLxj/4l7LuiXQHsT
         5jmWa7Uk1/XZbGRwWh9QE3sNHlIfE+wzKuhs9y64nA9gFYzMEKX4jy6TYeSG+hGkdBtV
         T3mrAoSWxHAj46MiVnfhvfjspn6LbeLHIqpkxe91hWg1Vl/RG7jCoN+egcRfrsZar01y
         pqqg==
X-Gm-Message-State: APjAAAU1sHq1n43uVG+3l1OxsRvG7UU1Jy9NXr6Ugq7DZ4C1mN4J1VGF
        pYAFmL89LonpojESJw5CagX0S7/snT8=
X-Google-Smtp-Source: APXvYqzKN+IqERuroJOZmOEFEzbR65O2f7DOACYWEqlCS/r2G8munamnUAiWh6+IzcBbOXKlBV1QWw==
X-Received: by 2002:a05:600c:2:: with SMTP id g2mr14366244wmc.18.1582443110489;
        Sat, 22 Feb 2020 23:31:50 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id a135sm11530646wme.47.2020.02.22.23.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2020 23:31:50 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 04/12] mlxsw: spectrum_trap: Move policer initialization to mlxsw_sp_trap_init()
Date:   Sun, 23 Feb 2020 08:31:36 +0100
Message-Id: <20200223073144.28529-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200223073144.28529-1-jiri@resnulli.us>
References: <20200223073144.28529-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

No need to initialize a single policer multiple times for each group.
So move the initialization to be done from mlxsw_sp_trap_init(), making
the function much simpler. Also, rename it so it is with sync with
spectrum.c policers initialization.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 72 +++++--------------
 1 file changed, 19 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 4f38681afa34..871bd609b0c9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -237,9 +237,25 @@ static u16 mlxsw_sp_listener_devlink_map[] = {
 	DEVLINK_TRAP_GENERIC_ID_OVERLAY_SMAC_MC,
 };
 
+#define MLXSW_SP_DISCARD_POLICER_ID	(MLXSW_REG_HTGT_TRAP_GROUP_MAX + 1)
+
+static int mlxsw_sp_trap_cpu_policers_set(struct mlxsw_sp *mlxsw_sp)
+{
+	char qpcr_pl[MLXSW_REG_QPCR_LEN];
+
+	mlxsw_reg_qpcr_pack(qpcr_pl, MLXSW_SP_DISCARD_POLICER_ID,
+			    MLXSW_REG_QPCR_IR_UNITS_M, false, 10 * 1024, 7);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(qpcr), qpcr_pl);
+}
+
 int mlxsw_sp_devlink_traps_init(struct mlxsw_sp *mlxsw_sp)
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
+	int err;
+
+	err = mlxsw_sp_trap_cpu_policers_set(mlxsw_sp);
+	if (err)
+		return err;
 
 	if (WARN_ON(ARRAY_SIZE(mlxsw_sp_listener_devlink_map) !=
 		    ARRAY_SIZE(mlxsw_sp_listeners_arr)))
@@ -330,41 +346,8 @@ int mlxsw_sp_trap_action_set(struct mlxsw_core *mlxsw_core,
 	return 0;
 }
 
-#define MLXSW_SP_DISCARD_POLICER_ID	(MLXSW_REG_HTGT_TRAP_GROUP_MAX + 1)
-
-static int
-mlxsw_sp_trap_group_policer_init(struct mlxsw_sp *mlxsw_sp,
-				 const struct devlink_trap_group *group)
-{
-	enum mlxsw_reg_qpcr_ir_units ir_units;
-	char qpcr_pl[MLXSW_REG_QPCR_LEN];
-	u16 policer_id;
-	u8 burst_size;
-	bool is_bytes;
-	u32 rate;
-
-	switch (group->id) {
-	case DEVLINK_TRAP_GROUP_GENERIC_ID_L2_DROPS: /* fall through */
-	case DEVLINK_TRAP_GROUP_GENERIC_ID_L3_DROPS: /* fall through */
-	case DEVLINK_TRAP_GROUP_GENERIC_ID_TUNNEL_DROPS:
-		policer_id = MLXSW_SP_DISCARD_POLICER_ID;
-		ir_units = MLXSW_REG_QPCR_IR_UNITS_M;
-		is_bytes = false;
-		rate = 10 * 1024; /* 10Kpps */
-		burst_size = 7;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	mlxsw_reg_qpcr_pack(qpcr_pl, policer_id, ir_units, is_bytes, rate,
-			    burst_size);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(qpcr), qpcr_pl);
-}
-
-static int
-__mlxsw_sp_trap_group_init(struct mlxsw_sp *mlxsw_sp,
-			   const struct devlink_trap_group *group)
+int mlxsw_sp_trap_group_init(struct mlxsw_core *mlxsw_core,
+			     const struct devlink_trap_group *group)
 {
 	char htgt_pl[MLXSW_REG_HTGT_LEN];
 	u8 priority, tc, group_id;
@@ -394,22 +377,5 @@ __mlxsw_sp_trap_group_init(struct mlxsw_sp *mlxsw_sp,
 	}
 
 	mlxsw_reg_htgt_pack(htgt_pl, group_id, policer_id, priority, tc);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(htgt), htgt_pl);
-}
-
-int mlxsw_sp_trap_group_init(struct mlxsw_core *mlxsw_core,
-			     const struct devlink_trap_group *group)
-{
-	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
-	int err;
-
-	err = mlxsw_sp_trap_group_policer_init(mlxsw_sp, group);
-	if (err)
-		return err;
-
-	err = __mlxsw_sp_trap_group_init(mlxsw_sp, group);
-	if (err)
-		return err;
-
-	return 0;
+	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(htgt), htgt_pl);
 }
-- 
2.21.1

