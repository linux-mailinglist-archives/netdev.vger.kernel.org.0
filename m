Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5BA1D2B14
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 15:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388287AbfJJNTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 09:19:01 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42760 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387664AbfJJNS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 09:18:58 -0400
Received: by mail-wr1-f67.google.com with SMTP id n14so7838423wrw.9
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 06:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LM6cFBPp3CDNz1sjZBsu45pZ5JW4xwrotf5tv22e8k8=;
        b=LLr5jyZhqE8Jq5NyGP3MJ3FnUsKNnu/GpncBrBwp1zgnbN3Hi3/jsEDmCp/YAzMw+a
         lQBxHPVx2066HXhsKnSe+verk7yPdRs/UM42/PTRMNEMqLsYhIBV1YCktTL501xnqtjK
         Ctsq2zH6AapJ+FlgpR0c5i1iPS1Lhy/0/QZpDgF4/G4IWhncxBmL0JH5Gyfo0yJbc0qM
         QXgYTKEZUo+g1yWN/xyMl1pXKMeOP8wfgcAw6HtcY5EB+VWgJvMqCo5q9Igr/Oqh9cKL
         8c4RWS4ZZeViRH/+Aca5lxYw1IUwqwj4WTLNTxtGp1guafQbER/93Q1fUJI+VANgbida
         QSkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LM6cFBPp3CDNz1sjZBsu45pZ5JW4xwrotf5tv22e8k8=;
        b=rGxNau3Gw1dpnKtR/0A6NnLLsB0qInp8tfY1NPiHXPc8c4uQ/tRcYwaftw7STKSynU
         ++OHZzBe4dqXa4cuHPjjTpFz7rifYptCoCuHYO3qKrJNB1fkNUDsg+m5Jwu6xq0dTQMQ
         vVjoPzh1+EDHE1Xdq2lWe/JdP4uoN0lmleE8nJc2FRA0x81pA4k+NtFj19sb89sUzZIT
         BX0+GGF2LklM6DHTXPuIcuVZHORuPXV5d2YkxHek9C/dg0h4iBgulkECpBIQwLuiRAOk
         HaB7KYf+w0LmD6Q3UvMpGNSHmXzl5ooSMIu/F7dr3IKiabzIxmodTrN2StCy+amB8EkG
         D1JA==
X-Gm-Message-State: APjAAAU0OMArIx8BJR7QyhUwMI+55gmW0I10AipDm5FG3i5oo9sz4+ny
        EZ7g8rZypk0ksxZcFgNnZkVy+Z42cW0=
X-Google-Smtp-Source: APXvYqwFtaJou7cK4ZHe2qgsb9Seu7ysYKGDr+qYWw2NtQ/6+cW1Y1nUczf1enADfnsZPhqdZEyqlA==
X-Received: by 2002:adf:f90f:: with SMTP id b15mr8554272wrr.76.1570713535507;
        Thu, 10 Oct 2019 06:18:55 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id t13sm12640152wra.70.2019.10.10.06.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 06:18:55 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        ayal@mellanox.com, moshe@mellanox.com, eranbe@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next v2 2/4] devlink: propagate extack down to health reporter ops
Date:   Thu, 10 Oct 2019 15:18:49 +0200
Message-Id: <20191010131851.21438-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191010131851.21438-1-jiri@resnulli.us>
References: <20191010131851.21438-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

During health reporter operations, driver might want to fill-up
the extack message, so propagate extack down to the health reporter ops.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  9 ++++++---
 .../mellanox/mlx5/core/en/reporter_rx.c       |  6 ++++--
 .../mellanox/mlx5/core/en/reporter_tx.c       |  6 ++++--
 .../net/ethernet/mellanox/mlx5/core/health.c  | 12 +++++++----
 include/net/devlink.h                         |  9 ++++++---
 net/core/devlink.c                            | 20 ++++++++++---------
 6 files changed, 39 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index e664392dccc0..ff1bc0ec2e7c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -16,7 +16,8 @@
 #include "bnxt_devlink.h"
 
 static int bnxt_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
-				     struct devlink_fmsg *fmsg)
+				     struct devlink_fmsg *fmsg,
+				     struct netlink_ext_ack *extack)
 {
 	struct bnxt *bp = devlink_health_reporter_priv(reporter);
 	struct bnxt_fw_health *health = bp->fw_health;
@@ -66,7 +67,8 @@ static const struct devlink_health_reporter_ops bnxt_dl_fw_reporter_ops = {
 };
 
 static int bnxt_fw_reset_recover(struct devlink_health_reporter *reporter,
-				 void *priv_ctx)
+				 void *priv_ctx,
+				 struct netlink_ext_ack *extack)
 {
 	struct bnxt *bp = devlink_health_reporter_priv(reporter);
 
@@ -84,7 +86,8 @@ struct devlink_health_reporter_ops bnxt_dl_fw_reset_reporter_ops = {
 };
 
 static int bnxt_fw_fatal_recover(struct devlink_health_reporter *reporter,
-				 void *priv_ctx)
+				 void *priv_ctx,
+				 struct netlink_ext_ack *extack)
 {
 	struct bnxt *bp = devlink_health_reporter_priv(reporter);
 	struct bnxt_fw_reporter_ctx *fw_reporter_ctx = priv_ctx;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index b860569d4247..6c72b592315b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -222,7 +222,8 @@ static int mlx5e_rx_reporter_recover_from_ctx(struct mlx5e_err_ctx *err_ctx)
 }
 
 static int mlx5e_rx_reporter_recover(struct devlink_health_reporter *reporter,
-				     void *context)
+				     void *context,
+				     struct netlink_ext_ack *extack)
 {
 	struct mlx5e_priv *priv = devlink_health_reporter_priv(reporter);
 	struct mlx5e_err_ctx *err_ctx = context;
@@ -301,7 +302,8 @@ static int mlx5e_rx_reporter_build_diagnose_output(struct mlx5e_rq *rq,
 }
 
 static int mlx5e_rx_reporter_diagnose(struct devlink_health_reporter *reporter,
-				      struct devlink_fmsg *fmsg)
+				      struct devlink_fmsg *fmsg,
+				      struct netlink_ext_ack *extack)
 {
 	struct mlx5e_priv *priv = devlink_health_reporter_priv(reporter);
 	struct mlx5e_params *params = &priv->channels.params;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index bfed558637c2..b468549e96ff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -135,7 +135,8 @@ static int mlx5e_tx_reporter_recover_from_ctx(struct mlx5e_err_ctx *err_ctx)
 }
 
 static int mlx5e_tx_reporter_recover(struct devlink_health_reporter *reporter,
-				     void *context)
+				     void *context,
+				     struct netlink_ext_ack *extack)
 {
 	struct mlx5e_priv *priv = devlink_health_reporter_priv(reporter);
 	struct mlx5e_err_ctx *err_ctx = context;
@@ -205,7 +206,8 @@ mlx5e_tx_reporter_build_diagnose_output(struct devlink_fmsg *fmsg,
 }
 
 static int mlx5e_tx_reporter_diagnose(struct devlink_health_reporter *reporter,
-				      struct devlink_fmsg *fmsg)
+				      struct devlink_fmsg *fmsg,
+				      struct netlink_ext_ack *extack)
 {
 	struct mlx5e_priv *priv = devlink_health_reporter_priv(reporter);
 	struct mlx5e_txqsq *generic_sq = priv->txq2sq[0];
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index d685122d9ff7..be3c3c704bfc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -390,7 +390,8 @@ static void print_health_info(struct mlx5_core_dev *dev)
 
 static int
 mlx5_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
-			  struct devlink_fmsg *fmsg)
+			  struct devlink_fmsg *fmsg,
+			  struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_health_reporter_priv(reporter);
 	struct mlx5_core_health *health = &dev->priv.health;
@@ -491,7 +492,8 @@ mlx5_fw_reporter_heath_buffer_data_put(struct mlx5_core_dev *dev,
 
 static int
 mlx5_fw_reporter_dump(struct devlink_health_reporter *reporter,
-		      struct devlink_fmsg *fmsg, void *priv_ctx)
+		      struct devlink_fmsg *fmsg, void *priv_ctx,
+		      struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_health_reporter_priv(reporter);
 	int err;
@@ -545,7 +547,8 @@ static const struct devlink_health_reporter_ops mlx5_fw_reporter_ops = {
 
 static int
 mlx5_fw_fatal_reporter_recover(struct devlink_health_reporter *reporter,
-			       void *priv_ctx)
+			       void *priv_ctx,
+			       struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_health_reporter_priv(reporter);
 
@@ -555,7 +558,8 @@ mlx5_fw_fatal_reporter_recover(struct devlink_health_reporter *reporter,
 #define MLX5_CR_DUMP_CHUNK_SIZE 256
 static int
 mlx5_fw_fatal_reporter_dump(struct devlink_health_reporter *reporter,
-			    struct devlink_fmsg *fmsg, void *priv_ctx)
+			    struct devlink_fmsg *fmsg, void *priv_ctx,
+			    struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_health_reporter_priv(reporter);
 	u32 crdump_size = dev->priv.health.crdump_size;
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 4095657fc23f..d35a1be107b5 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -507,11 +507,14 @@ enum devlink_health_reporter_state {
 struct devlink_health_reporter_ops {
 	char *name;
 	int (*recover)(struct devlink_health_reporter *reporter,
-		       void *priv_ctx);
+		       void *priv_ctx, struct netlink_ext_ack *extack);
 	int (*dump)(struct devlink_health_reporter *reporter,
-		    struct devlink_fmsg *fmsg, void *priv_ctx);
+		    struct devlink_fmsg *fmsg, void *priv_ctx,
+		    struct netlink_ext_ack *extack);
 	int (*diagnose)(struct devlink_health_reporter *reporter,
-			struct devlink_fmsg *fmsg);
+			struct devlink_fmsg *fmsg,
+			struct netlink_ext_ack *extack);
+
 };
 
 /**
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 95887462eecf..97e9a2246929 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4847,7 +4847,7 @@ EXPORT_SYMBOL_GPL(devlink_health_reporter_state_update);
 
 static int
 devlink_health_reporter_recover(struct devlink_health_reporter *reporter,
-				void *priv_ctx)
+				void *priv_ctx, struct netlink_ext_ack *extack)
 {
 	int err;
 
@@ -4857,7 +4857,7 @@ devlink_health_reporter_recover(struct devlink_health_reporter *reporter,
 	if (!reporter->ops->recover)
 		return -EOPNOTSUPP;
 
-	err = reporter->ops->recover(reporter, priv_ctx);
+	err = reporter->ops->recover(reporter, priv_ctx, extack);
 	if (err)
 		return err;
 
@@ -4878,7 +4878,8 @@ devlink_health_dump_clear(struct devlink_health_reporter *reporter)
 }
 
 static int devlink_health_do_dump(struct devlink_health_reporter *reporter,
-				  void *priv_ctx)
+				  void *priv_ctx,
+				  struct netlink_ext_ack *extack)
 {
 	int err;
 
@@ -4899,7 +4900,7 @@ static int devlink_health_do_dump(struct devlink_health_reporter *reporter,
 		goto dump_err;
 
 	err = reporter->ops->dump(reporter, reporter->dump_fmsg,
-				  priv_ctx);
+				  priv_ctx, extack);
 	if (err)
 		goto dump_err;
 
@@ -4946,11 +4947,12 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
 
 	mutex_lock(&reporter->dump_lock);
 	/* store current dump of current error, for later analysis */
-	devlink_health_do_dump(reporter, priv_ctx);
+	devlink_health_do_dump(reporter, priv_ctx, NULL);
 	mutex_unlock(&reporter->dump_lock);
 
 	if (reporter->auto_recover)
-		return devlink_health_reporter_recover(reporter, priv_ctx);
+		return devlink_health_reporter_recover(reporter,
+						       priv_ctx, NULL);
 
 	return 0;
 }
@@ -5188,7 +5190,7 @@ static int devlink_nl_cmd_health_reporter_recover_doit(struct sk_buff *skb,
 	if (!reporter)
 		return -EINVAL;
 
-	err = devlink_health_reporter_recover(reporter, NULL);
+	err = devlink_health_reporter_recover(reporter, NULL, info->extack);
 
 	devlink_health_reporter_put(reporter);
 	return err;
@@ -5221,7 +5223,7 @@ static int devlink_nl_cmd_health_reporter_diagnose_doit(struct sk_buff *skb,
 	if (err)
 		goto out;
 
-	err = reporter->ops->diagnose(reporter, fmsg);
+	err = reporter->ops->diagnose(reporter, fmsg, info->extack);
 	if (err)
 		goto out;
 
@@ -5256,7 +5258,7 @@ devlink_nl_cmd_health_reporter_dump_get_dumpit(struct sk_buff *skb,
 	}
 	mutex_lock(&reporter->dump_lock);
 	if (!start) {
-		err = devlink_health_do_dump(reporter, NULL);
+		err = devlink_health_do_dump(reporter, NULL, cb->extack);
 		if (err)
 			goto unlock;
 		cb->args[1] = reporter->dump_ts;
-- 
2.21.0

