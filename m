Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9FD2A2DB0
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbfH3Dzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:55:52 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40681 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728075AbfH3Dzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 23:55:46 -0400
Received: by mail-pg1-f196.google.com with SMTP id w10so2801661pgj.7
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 20:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aUrBbfehqS1H/Wv1HIzuZDj3x3gTobpk7D+6kJpLm1o=;
        b=Ghv5m1AfgqbbK/pHgG0is/JmE0B5QQign815R4T4nUe/u0HYgjZL1Gy+VXNb1lxYED
         IWU5SQPitbGqSKFJ9xYAo82Oaa0+/mvRYbiNyKzmgQ58WqL+IWYyK1fqwvqD5DsfyLof
         rZIFVzBqeh56eBCYpNSkaw74hW2kKYP3DihwM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aUrBbfehqS1H/Wv1HIzuZDj3x3gTobpk7D+6kJpLm1o=;
        b=apf5EIVUhA0bCPygHWyv/NE4f0rxvaL2UmbWl4PSGGXdRuRimotjge8HUMxFOMCmrC
         CITkE49wkyiDCXFDjzFGR55sTn9iiLjSkXDoZVgBb6QPvOniDIsB7ZyQv9zg2HlfwVtE
         KsQBAVGpwWR7BMqaXGYh5mrPuSjD2/O7vKci76yR6tfEWLNt8ARoRErC8MHJihziviAd
         X7pk0UMFWHmzJsfpmxOhW5EWj9u4lUsi9bLfooFR69Ns7vl+H4WkmUe6xriovcV+K5nI
         ytp3xodOirH+Axn3kEp0b4pxRIXOggTcTZlvCtIdjAOqTmRawC3lfkkjDm4iXsuAUI9k
         zcCg==
X-Gm-Message-State: APjAAAXHKpvNkUm7Ce1idQ1cbfD2R2g7KmupP38i2yPTbSLycRBvn+lz
        CsSKD/BtPi0eRIAfL0ONRh7gSA==
X-Google-Smtp-Source: APXvYqzwft8CPMDDs66jBAmhfAZpTqj1Hl32nRtjuU8xENQd+h/XzxSmX/mo+gY4he6MAWVH7yeDtQ==
X-Received: by 2002:a63:e44b:: with SMTP id i11mr10968207pgk.297.1567137345471;
        Thu, 29 Aug 2019 20:55:45 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l3sm3658877pjq.24.2019.08.29.20.55.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 20:55:44 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        ray.jui@broadcom.com, Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next v2 14/22] bnxt_en: Add new FW devlink_health_reporter
Date:   Thu, 29 Aug 2019 23:54:57 -0400
Message-Id: <1567137305-5853-15-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
References: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Create new FW devlink_health_reporter, to know the current health
status of FW.

Command example and output:
$ devlink health show pci/0000:af:00.0 reporter fw

pci/0000:af:00.0:
  name fw
    state healthy error 0 recover 0

 FW status: Healthy; Reset count: 1

Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 81 +++++++++++++++++++++++
 2 files changed, 84 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 6f7aa7c..a75fe16 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1368,6 +1368,7 @@ struct bnxt_fw_health {
 	u32 fw_reset_seq_regs[16];
 	u32 fw_reset_seq_vals[16];
 	u32 fw_reset_seq_delay_msec[16];
+	struct devlink_health_reporter	*fw_reporter;
 };
 
 #define BNXT_FW_HEALTH_REG_TYPE_MASK	3
@@ -1382,6 +1383,8 @@ struct bnxt_fw_health {
 #define BNXT_FW_HEALTH_WIN_BASE		0x3000
 #define BNXT_FW_HEALTH_WIN_MAP_OFF	8
 
+#define BNXT_FW_STATUS_HEALTHY		0x8000
+
 struct bnxt {
 	void __iomem		*bar0;
 	void __iomem		*bar1;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 7d9a8c4..e15d5dc 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -15,6 +15,84 @@
 #include "bnxt_vfr.h"
 #include "bnxt_devlink.h"
 
+static int bnxt_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
+				     struct devlink_fmsg *fmsg)
+{
+	struct bnxt *bp = devlink_health_reporter_priv(reporter);
+	struct bnxt_fw_health *health = bp->fw_health;
+	u32 val, health_status;
+	int rc;
+
+	if (!health || test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
+		return 0;
+
+	val = bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG);
+	health_status = val & 0xffff;
+
+	if (health_status == BNXT_FW_STATUS_HEALTHY) {
+		rc = devlink_fmsg_string_pair_put(fmsg, "FW status",
+						  "Healthy;");
+		if (rc)
+			return rc;
+	} else if (health_status < BNXT_FW_STATUS_HEALTHY) {
+		rc = devlink_fmsg_string_pair_put(fmsg, "FW status",
+						  "Not yet completed initialization;");
+		if (rc)
+			return rc;
+	} else if (health_status > BNXT_FW_STATUS_HEALTHY) {
+		rc = devlink_fmsg_string_pair_put(fmsg, "FW status",
+						  "Encountered fatal error and cannot recover;");
+		if (rc)
+			return rc;
+	}
+
+	if (val >> 16) {
+		rc = devlink_fmsg_u32_pair_put(fmsg, "Error", val >> 16);
+		if (rc)
+			return rc;
+	}
+
+	val = bnxt_fw_health_readl(bp, BNXT_FW_RESET_CNT_REG);
+	rc = devlink_fmsg_u32_pair_put(fmsg, "Reset count", val);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+static const struct devlink_health_reporter_ops bnxt_dl_fw_reporter_ops = {
+	.name = "fw",
+	.diagnose = bnxt_fw_reporter_diagnose,
+};
+
+static void bnxt_dl_fw_reporters_create(struct bnxt *bp)
+{
+	struct bnxt_fw_health *health = bp->fw_health;
+
+	if (!health)
+		return;
+
+	health->fw_reporter =
+		devlink_health_reporter_create(bp->dl, &bnxt_dl_fw_reporter_ops,
+					       0, false, bp);
+	if (IS_ERR(health->fw_reporter)) {
+		netdev_warn(bp->dev, "Failed to create FW health reporter, rc = %ld\n",
+			    PTR_ERR(health->fw_reporter));
+		health->fw_reporter = NULL;
+	}
+}
+
+static void bnxt_dl_fw_reporters_destroy(struct bnxt *bp)
+{
+	struct bnxt_fw_health *health = bp->fw_health;
+
+	if (!health)
+		return;
+
+	if (health->fw_reporter)
+		devlink_health_reporter_destroy(health->fw_reporter);
+}
+
 static const struct devlink_ops bnxt_dl_ops = {
 #ifdef CONFIG_BNXT_SRIOV
 	.eswitch_mode_set = bnxt_dl_eswitch_mode_set,
@@ -247,6 +325,8 @@ int bnxt_dl_register(struct bnxt *bp)
 
 	devlink_params_publish(dl);
 
+	bnxt_dl_fw_reporters_create(bp);
+
 	return 0;
 
 err_dl_port_unreg:
@@ -269,6 +349,7 @@ void bnxt_dl_unregister(struct bnxt *bp)
 	if (!dl)
 		return;
 
+	bnxt_dl_fw_reporters_destroy(bp);
 	devlink_port_params_unregister(&bp->dl_port, bnxt_dl_port_params,
 				       ARRAY_SIZE(bnxt_dl_port_params));
 	devlink_port_unregister(&bp->dl_port);
-- 
2.5.1

