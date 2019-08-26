Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71EB79C81D
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 05:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729642AbfHZD4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 23:56:06 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37093 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729578AbfHZD4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 23:56:01 -0400
Received: by mail-pf1-f193.google.com with SMTP id y9so10499871pfl.4
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 20:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IQNYk5QByzpFJ5MabIyUE06dEsvGp9T670vua6qPKtQ=;
        b=cniOzGDSH0Z09tj4sQNmBt1Yg31eVdxI8v20o/+NyUOchsXg1GV0oPUiU7ueuHoDoM
         aRrS4BfhZJ87+z1//Xwh0WIKS4oSisMWKE0bdKRu2dD3c7hHdEBmi8/WkJaNtNSNbqJg
         6zT82LpFGLV/Dphmk81fpi5LlDyT+/uDbRePA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IQNYk5QByzpFJ5MabIyUE06dEsvGp9T670vua6qPKtQ=;
        b=jHN5MAWoLi5v+l3D3CqPH8I5lp6CgtI9dfyjiXPPVs/CvoVYdyhE2Ctjty7rovDUQT
         it4lWB8LrfaDGiN/ng9YFpAhxqJNNcMYq+m9Kw39qOok/5vsw2gZ1UWj5jPmUqLzf+dk
         Xj/DN/xSlkP/YZzg04pffvOni5TE/os2oPKIrCaGczgZQajKtoBa8yObJJCyC4O8HQje
         CT5DiUI6X+YpFduCKHTlXjZPjPO68/V7G1FIzaXwX1oQ2O+8NnPfoEqATi8Qt+6tkTWv
         KNy6+sqRTWkPDo53kHaNDxI4dRoclCXC5tMo+sNPV1OHWrcwJrXGQolQXlcDFKkv+GTi
         kZtQ==
X-Gm-Message-State: APjAAAWAk+ylJNluXMYEYodA8yjcOmkFGq1y9QiU9tbALZEpvOYkgMnY
        4S4vXLl53ckZa5KEpJCAV0AlYA==
X-Google-Smtp-Source: APXvYqyzUBL282dr7h14cODp2p/n/3r5hkTwEXypso+b0Qo/Xm5uwEiMZr/wvEJj2+SoyAp632uokg==
X-Received: by 2002:aa7:9688:: with SMTP id f8mr9009556pfk.77.1566791760479;
        Sun, 25 Aug 2019 20:56:00 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d6sm8532975pgf.55.2019.08.25.20.55.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Aug 2019 20:56:00 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        jiri@mellanox.com, ray.jui@broadcom.com
Subject: [PATCH net-next 09/14] bnxt_en: Add new FW devlink_health_reporter
Date:   Sun, 25 Aug 2019 23:55:00 -0400
Message-Id: <1566791705-20473-10-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
References: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
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

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 81 +++++++++++++++++++++++
 2 files changed, 84 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index c316de5..5d291f5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1369,6 +1369,7 @@ struct bnxt_fw_health {
 	u32 fw_reset_seq_regs[16];
 	u32 fw_reset_seq_vals[16];
 	u32 fw_reset_seq_delay_msec[16];
+	struct devlink_health_reporter	*fw_reporter;
 };
 
 #define BNXT_FW_HEALTH_REG_TYPE_MASK	3
@@ -1383,6 +1384,8 @@ struct bnxt_fw_health {
 #define BNXT_FW_HEALTH_WIN_BASE		0x3000
 #define BNXT_FW_HEALTH_WIN_MAP_OFF	8
 
+#define BNXT_FW_STATUS_HEALTHY		0x8000
+
 struct bnxt {
 	void __iomem		*bar0;
 	void __iomem		*bar1;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index c05d663..7eb1a25 100644
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
@@ -251,6 +329,8 @@ int bnxt_dl_register(struct bnxt *bp)
 
 	devlink_params_publish(dl);
 
+	bnxt_dl_fw_reporters_create(bp);
+
 	return 0;
 
 err_dl_port_unreg:
@@ -273,6 +353,7 @@ void bnxt_dl_unregister(struct bnxt *bp)
 	if (!dl)
 		return;
 
+	bnxt_dl_fw_reporters_destroy(bp);
 	devlink_port_params_unregister(&bp->dl_port, bnxt_dl_port_params,
 				       ARRAY_SIZE(bnxt_dl_port_params));
 	devlink_port_unregister(&bp->dl_port);
-- 
2.5.1

