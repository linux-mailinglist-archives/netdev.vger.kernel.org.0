Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5427A16F9B6
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 09:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbgBZIjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 03:39:25 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41783 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbgBZIjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 03:39:24 -0500
Received: by mail-wr1-f67.google.com with SMTP id v4so1842639wrs.8
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 00:39:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MU2hlAmsYH5O7vK4ClnXzll+FNnNTx45FCdhwxT3Ed0=;
        b=1t7unTsNQfF6aSM9O8psc9KJUcdQxuVwDdjtNs2vE+9X3kjWsCauvQxSZkjAdqCG8C
         j3PZn5PPy87DMKh/3afXCXDD35pSIvC405s2zF/bZndvWjL31Yiqb0snJiitvU3Xh2J4
         UBUGb2tDRTMwo3PXJtRqjDhRbjQfnVshCJrhI5Mkyilk0pLdl1sfsMyyB8+Q4vE69MG/
         a1T62PIcaz9tLHaYF82bu9M/wiDLi36j91TtfGHqmh393idaexpd/K1r4uxQ6rhk5o2T
         nriWR/NciSGkkLXF3HRhPmioFzFpmsNPbtJtdw0whMiegj6Vm4Ut52vxtEJQPdvFwj0F
         Z6Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MU2hlAmsYH5O7vK4ClnXzll+FNnNTx45FCdhwxT3Ed0=;
        b=jKcltaOeQBPpgfrerTHxS91CBgesAtp6PKJmiaa1MZmllIBK0KQJkYiE7E2q8u8lOX
         pj7hYSfHOBEfDqxv0LYajvb/ClDbw51+wNYjpbEosMlokrGSMJQ2dW3ajlmbHxBpdlb5
         JmfNs8hGjyd1bFO0SA/owSrL99wpGp/0+Kg1qKkn1pEge09S79A2y2zjHwwf2CR5Paed
         i9VfaDAutVWx/6xazqVn8uWtlyZk4i9P3eGTrYipDUSj+0A6ZmgnDWKe+J1B+iWW12DA
         we2SCYDPXFtkZVoF35LKMTFb8JiuHL0BKeQ6czwHIxl0hhb1Zl1mCMsoMLmcdR4LklgT
         7z8g==
X-Gm-Message-State: APjAAAUvKxCBD77gRcbA2BW5fX+23DUgeq6GqI1LBU3zUhNPbuxfykQb
        7xe2ggGObWwzV+V1M1gtNJICEo/MKDM=
X-Google-Smtp-Source: APXvYqwUTWHDxWLLQVwCQn9U5ZPu/CY6safcnzTVqfbTuEpinfSxzx3OUTcepaw/gD1ylNze0iWEwg==
X-Received: by 2002:adf:ea42:: with SMTP id j2mr3933017wrn.377.1582706362932;
        Wed, 26 Feb 2020 00:39:22 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id c26sm1930640wmb.8.2020.02.26.00.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 00:39:22 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 1/4] mlxsw: spectrum_switchdev: Optimize SFN records processing
Date:   Wed, 26 Feb 2020 09:39:17 +0100
Message-Id: <20200226083920.16232-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200226083920.16232-1-jiri@resnulli.us>
References: <20200226083920.16232-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently, only one SFN query is done from repetitive work at a time,
processing 64 entries. Another work iteration is scheduled in 100ms,
that means that the max rate of learned FDB entries is limited to 6400/s.
That is slow. Fix this by doing 2 optimizations:
1) Run 10 SFN queries at a time.
2) In case the SFN is not drained, schedule work with 0 delay to allow
   to continue processing rest of the records.

On a testing setup with 500K entries the time to process decreased
from 870secs to 10secs.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Tested-by: Alex Kushnarov <alexanderk@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  2 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       | 35 ++++++++++++-------
 2 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index e22cea92fbce..26ac0a536fc0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -621,7 +621,7 @@ static inline void mlxsw_reg_sfn_pack(char *payload)
 {
 	MLXSW_REG_ZERO(sfn, payload);
 	mlxsw_reg_sfn_swid_set(payload, 0);
-	mlxsw_reg_sfn_end_set(payload, 1);
+	mlxsw_reg_sfn_end_set(payload, 0);
 	mlxsw_reg_sfn_num_rec_set(payload, MLXSW_REG_SFN_REC_MAX_COUNT);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 339c69da83b2..a26162b08b7d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2674,19 +2674,24 @@ static void mlxsw_sp_fdb_notify_rec_process(struct mlxsw_sp *mlxsw_sp,
 	}
 }
 
-static void mlxsw_sp_fdb_notify_work_schedule(struct mlxsw_sp *mlxsw_sp)
+static void mlxsw_sp_fdb_notify_work_schedule(struct mlxsw_sp *mlxsw_sp,
+					      bool no_delay)
 {
 	struct mlxsw_sp_bridge *bridge = mlxsw_sp->bridge;
+	unsigned int interval = no_delay ? 0 : bridge->fdb_notify.interval;
 
 	mlxsw_core_schedule_dw(&bridge->fdb_notify.dw,
-			       msecs_to_jiffies(bridge->fdb_notify.interval));
+			       msecs_to_jiffies(interval));
 }
 
+#define MLXSW_SP_FDB_SFN_QUERIES_PER_SESSION 10
+
 static void mlxsw_sp_fdb_notify_work(struct work_struct *work)
 {
 	struct mlxsw_sp_bridge *bridge;
 	struct mlxsw_sp *mlxsw_sp;
 	char *sfn_pl;
+	int queries;
 	u8 num_rec;
 	int i;
 	int err;
@@ -2699,20 +2704,26 @@ static void mlxsw_sp_fdb_notify_work(struct work_struct *work)
 	mlxsw_sp = bridge->mlxsw_sp;
 
 	rtnl_lock();
-	mlxsw_reg_sfn_pack(sfn_pl);
-	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(sfn), sfn_pl);
-	if (err) {
-		dev_err_ratelimited(mlxsw_sp->bus_info->dev, "Failed to get FDB notifications\n");
-		goto out;
+	queries = MLXSW_SP_FDB_SFN_QUERIES_PER_SESSION;
+	while (queries > 0) {
+		mlxsw_reg_sfn_pack(sfn_pl);
+		err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(sfn), sfn_pl);
+		if (err) {
+			dev_err_ratelimited(mlxsw_sp->bus_info->dev, "Failed to get FDB notifications\n");
+			goto out;
+		}
+		num_rec = mlxsw_reg_sfn_num_rec_get(sfn_pl);
+		for (i = 0; i < num_rec; i++)
+			mlxsw_sp_fdb_notify_rec_process(mlxsw_sp, sfn_pl, i);
+		if (num_rec != MLXSW_REG_SFN_REC_MAX_COUNT)
+			goto out;
+		queries--;
 	}
-	num_rec = mlxsw_reg_sfn_num_rec_get(sfn_pl);
-	for (i = 0; i < num_rec; i++)
-		mlxsw_sp_fdb_notify_rec_process(mlxsw_sp, sfn_pl, i);
 
 out:
 	rtnl_unlock();
 	kfree(sfn_pl);
-	mlxsw_sp_fdb_notify_work_schedule(mlxsw_sp);
+	mlxsw_sp_fdb_notify_work_schedule(mlxsw_sp, !queries);
 }
 
 struct mlxsw_sp_switchdev_event_work {
@@ -3458,7 +3469,7 @@ static int mlxsw_sp_fdb_init(struct mlxsw_sp *mlxsw_sp)
 
 	INIT_DELAYED_WORK(&bridge->fdb_notify.dw, mlxsw_sp_fdb_notify_work);
 	bridge->fdb_notify.interval = MLXSW_SP_DEFAULT_LEARNING_INTERVAL;
-	mlxsw_sp_fdb_notify_work_schedule(mlxsw_sp);
+	mlxsw_sp_fdb_notify_work_schedule(mlxsw_sp, false);
 	return 0;
 
 err_register_switchdev_blocking_notifier:
-- 
2.21.1

