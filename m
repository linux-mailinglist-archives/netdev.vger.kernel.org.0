Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8248E29F1
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 07:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406906AbfJXFct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 01:32:49 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44737 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404071AbfJXFct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 01:32:49 -0400
Received: by mail-pg1-f195.google.com with SMTP id e10so13505029pgd.11
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 22:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rBnqrwfSTh2mbIWwZpd9b9hudXdXX3wV/WFEw1SJ2yw=;
        b=iFEIIPVA8uKmKnheZH9flgXxDqwNB8TvT/hAxkTujdv22+Uh6XfM9ezHaew7I99k96
         daAe9W8uerzXppOSWikLb3ZLItnfUFs6sPVd6qpJKjyJKJviLmeeSWs1+p+E7zpxFLVV
         G/7yjStwwr92QuWQ6pEQtG9JH/rLpTHuhY3eQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rBnqrwfSTh2mbIWwZpd9b9hudXdXX3wV/WFEw1SJ2yw=;
        b=PvHesu+3nPyG8zO7ZqG3lKJvcQyCvheUmUXDi7C2QBEGe2nUzvIfbxmosNeHyu9+yJ
         YZG/niQ+t8pV2TA5PlmOi+Kdd9xabsNMEDsFrNFOMlwxP0mUPFWOHoTEc8I8hqOm5++0
         bXA5frc8B10GWur6xhbQeENMh+u1xcRrcYw+gNGc8Kajn+S5mZHGfQPEIrCnnBeogXMO
         XO0pZjznsX1OI2pmN2syqj2JfjctmUEdqQR/KGNHehM2oQszhp5vKZzz/1NwiPpP2XWK
         D+K9G3hcRXyL6DnMZAJyZSaEyB4Q5dqFPW829M3l0vM3fIxNJBFYkVRVQxAv1rIdVbKi
         NR5Q==
X-Gm-Message-State: APjAAAXfSrKcd/1gm7O12QMdUleUPUN51Fj7tH0n0YJrWOtyVJmFvyIP
        Z3/K4Cn20Wj389VbQ7TvU9y5YA==
X-Google-Smtp-Source: APXvYqwd3U2zTCSot2uI8RGCQOSKmRHOYSt5GHhwBhiUSLjaZ4a33VwvtFk5iarg1jEY1M0ZUNC4gg==
X-Received: by 2002:aa7:955a:: with SMTP id w26mr15690252pfq.193.1571895168042;
        Wed, 23 Oct 2019 22:32:48 -0700 (PDT)
Received: from shitalt.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id e17sm29491331pfl.40.2019.10.23.22.32.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 22:32:47 -0700 (PDT)
From:   Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>
To:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Rajan Vaja <rajan.vaja@xilinx.com>,
        Scott Branden <scott.branden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Vikram Prakash <vikram.prakash@broadcom.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vikas Gupta <vikas.gupta@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        tee-dev@lists.linaro.org, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org,
        Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>
Subject: [PATCH V3 2/3] bnxt_en: Add support to invoke OP-TEE API to reset firmware
Date:   Thu, 24 Oct 2019 11:02:40 +0530
Message-Id: <1571895161-26487-3-git-send-email-sheetal.tigadoli@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1571895161-26487-1-git-send-email-sheetal.tigadoli@broadcom.com>
References: <1571895161-26487-1-git-send-email-sheetal.tigadoli@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

In error recovery process when firmware indicates that it is
completely down, initiate a firmware reset by calling OP-TEE API.

Cc: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 13 +++++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  3 +++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b4a8cf6..b60b24e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10581,14 +10581,23 @@ static void bnxt_fw_reset_writel(struct bnxt *bp, int reg_idx)
 static void bnxt_reset_all(struct bnxt *bp)
 {
 	struct bnxt_fw_health *fw_health = bp->fw_health;
-	int i;
+	int i, rc;
+
+	if (bp->fw_cap & BNXT_FW_CAP_ERR_RECOVER_RELOAD) {
+#ifdef CONFIG_TEE_BNXT_FW
+		rc = tee_bnxt_fw_load();
+		if (rc)
+			netdev_err(bp->dev, "Unable to reset FW rc=%d\n", rc);
+		bp->fw_reset_timestamp = jiffies;
+#endif
+		return;
+	}
 
 	if (fw_health->flags & ERROR_RECOVERY_QCFG_RESP_FLAGS_HOST) {
 		for (i = 0; i < fw_health->fw_reset_seq_cnt; i++)
 			bnxt_fw_reset_writel(bp, i);
 	} else if (fw_health->flags & ERROR_RECOVERY_QCFG_RESP_FLAGS_CO_CPU) {
 		struct hwrm_fw_reset_input req = {0};
-		int rc;
 
 		bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FW_RESET, -1, -1);
 		req.resp_addr = cpu_to_le64(bp->hwrm_cmd_kong_resp_dma_addr);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index d333589..0943715 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -25,6 +25,9 @@
 #include <net/dst_metadata.h>
 #include <net/xdp.h>
 #include <linux/dim.h>
+#ifdef CONFIG_TEE_BNXT_FW
+#include <linux/firmware/broadcom/tee_bnxt_fw.h>
+#endif
 
 struct page_pool;
 
-- 
1.9.1

