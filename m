Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A21F09C821
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 05:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729627AbfHZD4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 23:56:05 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43135 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729576AbfHZDz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 23:55:58 -0400
Received: by mail-pf1-f195.google.com with SMTP id v12so10866156pfn.10
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 20:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WdDkuDBDhOLmt27sLozhcSRqwndp9kN11nW4PrPeyxM=;
        b=Z0jX0pvmC+o6ahyyS1FSEDY8XbFHT62OWZwLHBmpMOYU5t3N6MzFoJjcuj4liStdca
         TPvRcw0u8Y227p5dMEqk1+LnUi30GKw2PShn3puq1Aakjem9Jd60AU+URSyPSaffzEui
         jut5VnYxUzpLImito/6KZhrPgLN9VpRKy0Vw4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WdDkuDBDhOLmt27sLozhcSRqwndp9kN11nW4PrPeyxM=;
        b=ewEFhevNrJk6SwiWLtTm/Esvu82O1ljPaKWW2Rqu7tRv9yRJrVWJQArf40w2BihO5u
         2d/B3i/Jo9YOsxcp+xZR7puVRws92nMILxysZWJgGJSt1M6NcY32kMj6UONxRJNPS77B
         h8zZYkq79/563G6/ceQc3gLpz15Hp7LAQ1swiHOODSN5sblCWdn6v04nM+h376jwMiKo
         Fqabacaxbcy7UjS+vmdog1M6K3nbAechttcJV07TMMt+pnC4ex6aFr6/EHmmOdTxzLu9
         WSx9O0Xc4A4afLe/EcRbCaJPMvq1O5/U+/KMyhp27QtDSabh/BS/HL9jEPer+YEb1tH3
         TeBA==
X-Gm-Message-State: APjAAAW+B7oRKV44D1OzcDJUpRMY1vqq0cIPgSoIZDcIJoJ+NJ398ukX
        yaLcIZH637KAAo83jx2aHv/I+w==
X-Google-Smtp-Source: APXvYqwA8YLBzrAQP+TFwF1u0U3LdAOa7mwI+WnVri+dV6nwR4fUku2sbsBBu1jFLNJPCs65xi4M8g==
X-Received: by 2002:a63:6c02:: with SMTP id h2mr15267331pgc.61.1566791757493;
        Sun, 25 Aug 2019 20:55:57 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d6sm8532975pgf.55.2019.08.25.20.55.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Aug 2019 20:55:57 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        jiri@mellanox.com, ray.jui@broadcom.com
Subject: [PATCH net-next 06/14] bnxt_en: Pre-map the firmware health monitoring registers.
Date:   Sun, 25 Aug 2019 23:54:57 -0400
Message-Id: <1566791705-20473-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
References: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pre-map the GRC registers for periodic firmware health monitoring.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 29 +++++++++++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  6 ++++++
 2 files changed, 35 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index ef43f9e..9ab5024 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6936,6 +6936,33 @@ static int bnxt_hwrm_cfa_adv_flow_mgnt_qcaps(struct bnxt *bp)
 	return rc;
 }
 
+static int bnxt_map_fw_health_regs(struct bnxt *bp)
+{
+	struct bnxt_fw_health *fw_health = bp->fw_health;
+	u32 reg_base = 0xffffffff;
+	int i;
+
+	/* Only pre-map the monitoring GRC registers using window 3 */
+	for (i = 0; i < 4; i++) {
+		u32 reg = fw_health->regs[i];
+
+		if (BNXT_FW_HEALTH_REG_TYPE(reg) != BNXT_FW_HEALTH_REG_TYPE_GRC)
+			continue;
+		if (reg_base == 0xffffffff)
+			reg_base = reg & BNXT_GRC_BASE_MASK;
+		if ((reg & BNXT_GRC_BASE_MASK) != reg_base)
+			return -ERANGE;
+		fw_health->mapped_regs[i] = BNXT_FW_HEALTH_WIN_BASE +
+					    (reg & BNXT_GRC_OFFSET_MASK);
+	}
+	if (reg_base == 0xffffffff)
+		return 0;
+
+	writel(reg_base, bp->bar0 + BNXT_GRCPF_REG_WINDOW_BASE_OUT +
+			 BNXT_FW_HEALTH_WIN_MAP_OFF);
+	return 0;
+}
+
 static int bnxt_hwrm_error_recovery_qcfg(struct bnxt *bp)
 {
 	struct hwrm_error_recovery_qcfg_output *resp = bp->hwrm_cmd_resp_addr;
@@ -7001,6 +7028,8 @@ static int bnxt_hwrm_error_recovery_qcfg(struct bnxt *bp)
 	}
 err_recovery_out:
 	mutex_unlock(&bp->hwrm_cmd_lock);
+	if (!rc)
+		rc = bnxt_map_fw_health_regs(bp);
 	if (rc)
 		bp->fw_cap &= ~BNXT_FW_CAP_ERROR_RECOVERY;
 	return rc;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 741ae68..6053dfd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1217,6 +1217,9 @@ struct bnxt_test_info {
 #define BNXT_GRCPF_REG_KONG_COMM		0xA00
 #define BNXT_GRCPF_REG_KONG_COMM_TRIGGER	0xB00
 
+#define BNXT_GRC_BASE_MASK			0xfffff000
+#define BNXT_GRC_OFFSET_MASK			0x00000ffc
+
 struct bnxt_tc_flow_stats {
 	u64		packets;
 	u64		bytes;
@@ -1368,6 +1371,9 @@ struct bnxt_fw_health {
 #define BNXT_FW_HEALTH_REG_TYPE(reg)	((reg) & BNXT_FW_HEALTH_REG_TYPE_MASK)
 #define BNXT_FW_HEALTH_REG_OFF(reg)	((reg) & ~BNXT_FW_HEALTH_REG_TYPE_MASK)
 
+#define BNXT_FW_HEALTH_WIN_BASE		0x3000
+#define BNXT_FW_HEALTH_WIN_MAP_OFF	8
+
 struct bnxt {
 	void __iomem		*bar0;
 	void __iomem		*bar1;
-- 
2.5.1

