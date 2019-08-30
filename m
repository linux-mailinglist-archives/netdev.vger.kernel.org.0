Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 685B1A2DBA
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbfH3D4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:56:13 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34696 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728023AbfH3Dzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 23:55:43 -0400
Received: by mail-pl1-f193.google.com with SMTP id d3so2696477plr.1
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 20:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Q/O4db9+8emUXEviywcxeUw0AdfoqL58y6PWsWFmtr8=;
        b=e/TWDq5MvoCs9M7X4JW8vUtuc/qvF01+D7HS2k9F2+znOThuGcqAqzw4thxYi7Hlhx
         ZYhbpWeVnUM2QhPmjuEfy9Uf9I8wwRXJD8nUjizuLJQ3tw+/oeh7sHPzVWLFdl3BsTRE
         uwEXLE1JcZ5VTL3AsaX0iOt05aA7PGtuGE3Jk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Q/O4db9+8emUXEviywcxeUw0AdfoqL58y6PWsWFmtr8=;
        b=n45jfOonSH3vFL2wYEofXfM4wRLTFUKnXXkOx3N05i/orwHYDAdQGeGNSmliAlIAhc
         4ezL+p+24tuGAbT3sF1nlFKuE1fhXXwQxz1fhrLVQeOls1YR7IXW5NuQzKPfI9j2TuHX
         +mBPq86o0JonCKI1tpi5c7R9/ai9KfAsomEHGaHSWh8E6XpVGVkzbor5pEkenQFLzLWN
         dekqnVczO/ElMQamPdUxorxRq3VmpnUZdE1q27P4NC+lS1uUzHhGQpNWg3v5ia3ScqWC
         jrlbm82kWyC7zCss97yAjJrlPC809ZQmU+DojqMRW9pQt/8bmN1dOyrZbOv51X/GkeMO
         lHpA==
X-Gm-Message-State: APjAAAXypPigj8d+F0/H4ePv++gzxLhbN2aBh07Vm+iMAX8j3KWQK1Jj
        QRPUO8/GbA1YwwbKLIuT5vreKw==
X-Google-Smtp-Source: APXvYqwvsQuI1grhCfHqTvLl0lm3UV26s3yyDYXyCYLxV1vDMnJU2e2m1SH2YS9CxudHfhXq27HLGA==
X-Received: by 2002:a17:902:a606:: with SMTP id u6mr13469015plq.224.1567137342445;
        Thu, 29 Aug 2019 20:55:42 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l3sm3658877pjq.24.2019.08.29.20.55.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 20:55:42 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        ray.jui@broadcom.com
Subject: [PATCH net-next v2 11/22] bnxt_en: Pre-map the firmware health monitoring registers.
Date:   Thu, 29 Aug 2019 23:54:54 -0400
Message-Id: <1567137305-5853-12-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
References: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
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
index 825a7f9..8ec41d6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6950,6 +6950,33 @@ static int bnxt_hwrm_cfa_adv_flow_mgnt_qcaps(struct bnxt *bp)
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
@@ -7013,6 +7040,8 @@ static int bnxt_hwrm_error_recovery_qcfg(struct bnxt *bp)
 	}
 err_recovery_out:
 	mutex_unlock(&bp->hwrm_cmd_lock);
+	if (!rc)
+		rc = bnxt_map_fw_health_regs(bp);
 	if (rc)
 		bp->fw_cap &= ~BNXT_FW_CAP_ERROR_RECOVERY;
 	return rc;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index ce535e5..78fd585 100644
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

