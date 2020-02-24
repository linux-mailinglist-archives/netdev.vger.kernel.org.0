Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23D81169F63
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 08:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbgBXHgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 02:36:31 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:32966 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727415AbgBXHgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 02:36:15 -0500
Received: by mail-wr1-f68.google.com with SMTP id u6so9107643wrt.0
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 23:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oCTpcdnvcoh7I+TfX+mGHBkVCVBk7hB1RqzA5XyEY+4=;
        b=1EtjFsMxQw8WSF+t74sYAFoBZA7sSpckm/1qlpxVBH0TbZLHeNSTxwMz07VSlqTrjo
         tIFEKAIDFFfGJXWRvRXuXMF/LQ5hNlYbn/ucAsY82J0fhuytT8r6Jak61nFrEyxvtrdu
         gUpx3o1b5MzCaAa63v5uaNI5WkjPAoZkcE2PIdNPFS12zi8aeXu7zuY6SXU1qyyswRyf
         ECRowrhYaYNLqZNrJYvMuqgoULtfwA0UdX4xA+oi74MYfgQt48/LPoINSfi8aiHLtbe8
         scvyb19H9/ziHpw/fX0UqHMnaODUYWeCLq6ZdzgFkPWev56BUlPQoY9BJyiJzp5bvkEf
         6WEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oCTpcdnvcoh7I+TfX+mGHBkVCVBk7hB1RqzA5XyEY+4=;
        b=pfU8mwPY9fIUNHOgKGc3YNksvxyvJQoV28IMTXDERaTUZ2ADNOkfUWxl9wspeQOWXB
         fWCHvI37iA+IueLARZ5h0QVgY6iNG1G9i1ToKc6ebnje9XoNWlMS4mr2bf6NjkiRBRP1
         gB73hygKFfEHw/07SKDzqBXkrnRdH4dG9lA4W6QU2Q3KFdF+kJnOuDNbRm+Q6MlxOi5u
         n8P7YRgfBsj2hOI4JiXkMU7SQIsUW7jgGxTMYRUsazXqQ+A8822zUbx+M+qRM4K/cwhT
         AWXlgPiGTjeBo32jiFLJkxtBhr+czyaSUYdIUFGbAwvjjvhk8MqhKEZk1OKDVSQTNKJu
         /obw==
X-Gm-Message-State: APjAAAWf02zfDIQTTZrr2Bz4XFBe6gCwclQMB/b+4sNHeOJA8i4GrvlB
        09+wFb/rlulnzoVlYqO2ZxEUv7OSrKY=
X-Google-Smtp-Source: APXvYqyz92kDjoTvEdBvsiSLgHolflHyOLIK2WfFLDoPxqxc1SyKYR2eb7k6AUE8e37THp0DtBsj+Q==
X-Received: by 2002:a5d:5264:: with SMTP id l4mr13601880wrc.275.1582529774029;
        Sun, 23 Feb 2020 23:36:14 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id g2sm16679792wrw.76.2020.02.23.23.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 23:36:13 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 12/16] mlxsw: spectrum_trap: Introduce dummy group with thin policer
Date:   Mon, 24 Feb 2020 08:35:54 +0100
Message-Id: <20200224073558.26500-13-jiri@resnulli.us>
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

For "source traps" it is not possible to change HPKT action to discard.
But there is still need to disallow packets arriving to CPU as much as
possible. Handle this by introduction of a "dummy group". It has a
"thin" policer, which passes as less packets to CPU as possible. The
rest is going to be discarded there. The "dummy group" is to be used
later on by ACL trap (which is a "source trap").

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  1 +
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 24 +++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index dd6685156396..d82765191749 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5526,6 +5526,7 @@ enum mlxsw_reg_htgt_trap_group {
 
 enum mlxsw_reg_htgt_discard_trap_group {
 	MLXSW_REG_HTGT_DISCARD_TRAP_GROUP_BASE = MLXSW_REG_HTGT_TRAP_GROUP_MAX,
+	MLXSW_REG_HTGT_TRAP_GROUP_SP_DUMMY,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_L2_DISCARDS,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_L3_DISCARDS,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_TUNNEL_DISCARDS,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index f36d61ce59b2..0064470d8366 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -239,16 +239,36 @@ static const u16 mlxsw_sp_listener_devlink_map[] = {
 };
 
 #define MLXSW_SP_DISCARD_POLICER_ID	(MLXSW_REG_HTGT_TRAP_GROUP_MAX + 1)
+#define MLXSW_SP_THIN_POLICER_ID	(MLXSW_SP_DISCARD_POLICER_ID + 1)
 
 static int mlxsw_sp_trap_cpu_policers_set(struct mlxsw_sp *mlxsw_sp)
 {
 	char qpcr_pl[MLXSW_REG_QPCR_LEN];
+	int err;
 
 	mlxsw_reg_qpcr_pack(qpcr_pl, MLXSW_SP_DISCARD_POLICER_ID,
 			    MLXSW_REG_QPCR_IR_UNITS_M, false, 10 * 1024, 7);
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(qpcr), qpcr_pl);
+	if (err)
+		return err;
+
+	/* The purpose of "thin" policer is to drop as many packets
+	 * as possible. The dummy group is using it.
+	 */
+	mlxsw_reg_qpcr_pack(qpcr_pl, MLXSW_SP_THIN_POLICER_ID,
+			    MLXSW_REG_QPCR_IR_UNITS_M, false, 1, 4);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(qpcr), qpcr_pl);
 }
 
+static int mlxsw_sp_trap_dummy_group_init(struct mlxsw_sp *mlxsw_sp)
+{
+	char htgt_pl[MLXSW_REG_HTGT_LEN];
+
+	mlxsw_reg_htgt_pack(htgt_pl, MLXSW_REG_HTGT_TRAP_GROUP_SP_DUMMY,
+			    MLXSW_SP_THIN_POLICER_ID, 0, 1);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(htgt), htgt_pl);
+}
+
 int mlxsw_sp_devlink_traps_init(struct mlxsw_sp *mlxsw_sp)
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
@@ -258,6 +278,10 @@ int mlxsw_sp_devlink_traps_init(struct mlxsw_sp *mlxsw_sp)
 	if (err)
 		return err;
 
+	err = mlxsw_sp_trap_dummy_group_init(mlxsw_sp);
+	if (err)
+		return err;
+
 	if (WARN_ON(ARRAY_SIZE(mlxsw_sp_listener_devlink_map) !=
 		    ARRAY_SIZE(mlxsw_sp_listeners_arr)))
 		return -EINVAL;
-- 
2.21.1

