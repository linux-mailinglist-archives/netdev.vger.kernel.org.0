Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEE67EA155
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 17:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbfJ3QBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 12:01:10 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39328 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728434AbfJ3Pyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 11:54:46 -0400
Received: by mail-wm1-f68.google.com with SMTP id g19so2737605wmh.4
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 08:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1b/PjoEJ3+h+SBh6G5LSt0fwIln3xfl7/abE1bFQX1U=;
        b=hzrosYqSyPDygsna85h8qSrUmUaQQxMkX5BA098fJ6vDLGNeTe4eqqS0Yy3jBSOVtU
         yi7+0L13abxGIkDRQBOEgU7GdtxmdESHz+6KLsloe65u6oPwjmoLHEVN6T4EuRTryQfL
         y7lk5lyyh2Rim0xK+TCKTlVwj7Asgp17IIy8s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1b/PjoEJ3+h+SBh6G5LSt0fwIln3xfl7/abE1bFQX1U=;
        b=OeNOLLC1ZnNsHauDPz0gA18XicLkv4rDyRQHBHCEZtq08zTO0fNg+UJnsmLC28gHld
         N+TwK4ZcYMDwnRQLNJaCu5lWNYTUcLXuWhCztEi7ZdNxquSSHOoQ+I+nk4Z0lXgzWDkZ
         jdN9CeQcFsMSQbIqmTjwsLRV2IzeqF/QTVyIC4iypFptWTm7kI1Jwihou2qtxwnG4p4B
         MD2jSElVx9jrE7ColBSidClczaV50HBJDUCE4aEqR1j2geoLJkdCaD7jf51YpRTR9IFk
         byzoEpuQn5okGux1M/3NdC+ZYP0UJ/oCfYJQYDOXYy2kUZYeaYO2QUfxVWUijuVXeX8N
         TyEA==
X-Gm-Message-State: APjAAAVEnu9lSEhtiHC15kWDpUmuPrnJpV4+C6qELDsxJuvBNB1XosDw
        gSDn2pOn/8I0fr19WkU7ufOMzg==
X-Google-Smtp-Source: APXvYqwTXl2Q1WUFHg7qhZXHybLGgpjxpJN/y8w39Em85vfeW8+DSA1Q4Ev7vK/bL1ZYJYTV+ebZhg==
X-Received: by 2002:a1c:7719:: with SMTP id t25mr174595wmi.56.1572450884321;
        Wed, 30 Oct 2019 08:54:44 -0700 (PDT)
Received: from shitalt.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id g184sm499931wma.8.2019.10.30.08.54.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 30 Oct 2019 08:54:43 -0700 (PDT)
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
Subject: [PATCH net-next V4 2/3] bnxt_en: Add support to invoke OP-TEE API to reset firmware
Date:   Wed, 30 Oct 2019 21:24:23 +0530
Message-Id: <1572450864-16761-3-git-send-email-sheetal.tigadoli@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1572450864-16761-1-git-send-email-sheetal.tigadoli@broadcom.com>
References: <1572450864-16761-1-git-send-email-sheetal.tigadoli@broadcom.com>
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
index 8cdf71f8824d..c24caaaf05ca 100644
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
index d333589811a5..09437150f818 100644
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
2.17.1

