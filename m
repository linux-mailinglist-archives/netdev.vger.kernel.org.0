Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFFC5A2DB7
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbfH3D4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:56:08 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43625 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728116AbfH3Dzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 23:55:49 -0400
Received: by mail-pg1-f194.google.com with SMTP id k3so2785431pgb.10
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 20:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JrJ4TbbrOuOGtUJnSVXM6sTkNKrEDDRAVWodt9L4XjM=;
        b=bGGuLdYcZvyu6co4Ez14MuALDBrjfV1Jsrmeu08RWPknP34hViRU8LVqmg5croCD/4
         1r4Rd4ln+WRFZPb6xz11H40BEVOroVhoue0jdbLrd0al5GpGfX88gDB57fpCzkrzeEZf
         sgv7ntMMyBGMb8zWc5GX90HtbupqoyB+Dop7E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JrJ4TbbrOuOGtUJnSVXM6sTkNKrEDDRAVWodt9L4XjM=;
        b=CpCryrnnGOCC4o+97NCN546VIQfqnBmW0m8HOmmeBMoERqLCy0rONTxo6yGRYYd8O5
         fA95sLbl2Az4RVj1Z/iuQN9H4E8Wc7nAvmEgN2mBpQ3s54UUBh+rk2+53rUuyYNq080o
         rOZaceDiGva2duxLkHqEO9gQPM2CV/GPxeFqucGzyHcDmRsZqMS/pQy7GQv9HwWOf/uL
         DcCVq2IL6cMRncNEn917mA0AvCbrNOVofE7VDpLDf1M3wql0HQAU19nCkY/T4SeOtw5P
         8IhukgpNA2a1dbbzND03mtAboI5pThd1EhKmmRYihvQlHaMZwP0kGRLgANdqSFgwqQK4
         IDmw==
X-Gm-Message-State: APjAAAXRzNdBN7cIBmHkVI/+9cmg1rrLkd2tnDBLpcKVz8daMHRg4Th/
        2luTDVVPSq+4Jt7pFZzPiAdUZg==
X-Google-Smtp-Source: APXvYqziz590WgqJ0G0O92WnYTSJ0J42jzs0mD/GI+7iEvdINNFKhLTs5b5aujP6doUx+dEa9gwlAg==
X-Received: by 2002:a17:90a:f0d8:: with SMTP id fa24mr14121708pjb.142.1567137348557;
        Thu, 29 Aug 2019 20:55:48 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l3sm3658877pjq.24.2019.08.29.20.55.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 20:55:47 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        ray.jui@broadcom.com, Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next v2 17/22] bnxt_en: Add devlink health reset reporter.
Date:   Thu, 29 Aug 2019 23:55:00 -0400
Message-Id: <1567137305-5853-18-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
References: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Add devlink health reporter for the firmware reset event.  Once we get
the notification from firmware about the impending reset, the driver
will report this to devlink and the call to bnxt_fw_reset() will be
initiated to complete the reset sequence.

Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |  3 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  5 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 52 +++++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h |  1 +
 4 files changed, 61 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 98b15551..cd20067 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10167,6 +10167,9 @@ static void bnxt_sp_task(struct work_struct *work)
 	if (test_and_clear_bit(BNXT_RESET_TASK_SILENT_SP_EVENT, &bp->sp_event))
 		bnxt_reset(bp, true);
 
+	if (test_and_clear_bit(BNXT_FW_RESET_NOTIFY_SP_EVENT, &bp->sp_event))
+		bnxt_devlink_health_report(bp, BNXT_FW_RESET_NOTIFY_SP_EVENT);
+
 	smp_mb__before_atomic();
 	clear_bit(BNXT_STATE_IN_SP_TASK, &bp->state);
 }
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index c78aa51..d65625f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1371,6 +1371,11 @@ struct bnxt_fw_health {
 	u32 fw_reset_seq_vals[16];
 	u32 fw_reset_seq_delay_msec[16];
 	struct devlink_health_reporter	*fw_reporter;
+	struct devlink_health_reporter *fw_reset_reporter;
+};
+
+struct bnxt_fw_reporter_ctx {
+	unsigned long sp_event;
 };
 
 #define BNXT_FW_HEALTH_REG_TYPE_MASK	3
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index e15d5dc..8512467 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -65,6 +65,24 @@ static const struct devlink_health_reporter_ops bnxt_dl_fw_reporter_ops = {
 	.diagnose = bnxt_fw_reporter_diagnose,
 };
 
+static int bnxt_fw_reset_recover(struct devlink_health_reporter *reporter,
+				 void *priv_ctx)
+{
+	struct bnxt *bp = devlink_health_reporter_priv(reporter);
+
+	if (!priv_ctx)
+		return -EOPNOTSUPP;
+
+	bnxt_fw_reset(bp);
+	return 0;
+}
+
+static const
+struct devlink_health_reporter_ops bnxt_dl_fw_reset_reporter_ops = {
+	.name = "fw_reset",
+	.recover = bnxt_fw_reset_recover,
+};
+
 static void bnxt_dl_fw_reporters_create(struct bnxt *bp)
 {
 	struct bnxt_fw_health *health = bp->fw_health;
@@ -80,6 +98,16 @@ static void bnxt_dl_fw_reporters_create(struct bnxt *bp)
 			    PTR_ERR(health->fw_reporter));
 		health->fw_reporter = NULL;
 	}
+
+	health->fw_reset_reporter =
+		devlink_health_reporter_create(bp->dl,
+					       &bnxt_dl_fw_reset_reporter_ops,
+					       0, true, bp);
+	if (IS_ERR(health->fw_reset_reporter)) {
+		netdev_warn(bp->dev, "Failed to create FW fatal health reporter, rc = %ld\n",
+			    PTR_ERR(health->fw_reset_reporter));
+		health->fw_reset_reporter = NULL;
+	}
 }
 
 static void bnxt_dl_fw_reporters_destroy(struct bnxt *bp)
@@ -91,6 +119,30 @@ static void bnxt_dl_fw_reporters_destroy(struct bnxt *bp)
 
 	if (health->fw_reporter)
 		devlink_health_reporter_destroy(health->fw_reporter);
+
+	if (health->fw_reset_reporter)
+		devlink_health_reporter_destroy(health->fw_reset_reporter);
+}
+
+void bnxt_devlink_health_report(struct bnxt *bp, unsigned long event)
+{
+	struct bnxt_fw_health *fw_health = bp->fw_health;
+	struct bnxt_fw_reporter_ctx fw_reporter_ctx;
+
+	if (!fw_health)
+		return;
+
+	fw_reporter_ctx.sp_event = event;
+	switch (event) {
+	case BNXT_FW_RESET_NOTIFY_SP_EVENT:
+		if (!fw_health->fw_reset_reporter)
+			return;
+
+		devlink_health_report(fw_health->fw_reset_reporter,
+				      "FW non-fatal reset event received",
+				      &fw_reporter_ctx);
+		return;
+	}
 }
 
 static const struct devlink_ops bnxt_dl_ops = {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
index 5b6b2c7..b97e0ba 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
@@ -55,6 +55,7 @@ struct bnxt_dl_nvm_param {
 	u16 num_bits;
 };
 
+void bnxt_devlink_health_report(struct bnxt *bp, unsigned long event);
 int bnxt_dl_register(struct bnxt *bp);
 void bnxt_dl_unregister(struct bnxt *bp);
 
-- 
2.5.1

