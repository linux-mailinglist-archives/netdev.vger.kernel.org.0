Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31762DABA6
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 14:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502251AbfJQMBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 08:01:46 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54455 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502237AbfJQMBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 08:01:41 -0400
Received: by mail-wm1-f67.google.com with SMTP id p7so2267773wmp.4
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 05:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rBnqrwfSTh2mbIWwZpd9b9hudXdXX3wV/WFEw1SJ2yw=;
        b=YXPnsMjKQyf8JYK0M4k0KOdyEWa1AMAmiDYLNlKXmtX/pwgtbFV2kT3BgtWZXFaJWm
         QboEGQHvToLotMwSll1BfBlLHNTm9atHIsl4LVjub+12SS8qdBgMfGSdLVTzDMc0U0OS
         T0iDaKu9JVuF39SdlZMs4CvAzIS7P1m36IKps=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rBnqrwfSTh2mbIWwZpd9b9hudXdXX3wV/WFEw1SJ2yw=;
        b=A/mhLeDZO/rkY8P+A1c1HKLSG9/iMzIQx0uh0eDY35LSIxXeJ9vLz6XJBm5ImTje82
         G2QIkxwKoGF3bvToqPKizuCGDZgKg1+ySXyl0+H7Q6rcotKJzk26PmVa0MTPx+hiDIwN
         V+nVJ7AcPw/tkS0evdnawgl/Cp5k5UBrIjsI5UFsM6coxAEeb7UoSEJVFqC0cbWTOcgv
         UFx/sSW5QGp0R8vIeCxgO/j9XswyjskEfklf/kS7Uq2zu9eQuIS77rR/K1ud/hOa1Urz
         +7i6cgCSJ6pupBBJTMEuKm/l6Xou78AI2Vw/ViidAPoXWNTzqHnPuM3pzMLww5MWYP2K
         +MZA==
X-Gm-Message-State: APjAAAWxAtoSLRhhVL9rIYg0FO9BbXQVflXxcyEJrfdB8EyCmHpVWczJ
        ahCmwliCbJJL+oPPEtU6RvX+vw==
X-Google-Smtp-Source: APXvYqx23GT/npHp/uYWt+AJRmhdQoQHvzH7clYBCIlLhux531SFUjxNmmlmWEatrMH9VYlmXtflMA==
X-Received: by 2002:a7b:c849:: with SMTP id c9mr2481040wml.70.1571313698937;
        Thu, 17 Oct 2019 05:01:38 -0700 (PDT)
Received: from shitalt.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id y1sm2317949wrw.6.2019.10.17.05.01.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 17 Oct 2019 05:01:38 -0700 (PDT)
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
Subject: [PATCH V2 2/3] bnxt_en: Add support to invoke OP-TEE API to reset firmware
Date:   Thu, 17 Oct 2019 17:31:21 +0530
Message-Id: <1571313682-28900-3-git-send-email-sheetal.tigadoli@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1571313682-28900-1-git-send-email-sheetal.tigadoli@broadcom.com>
References: <1571313682-28900-1-git-send-email-sheetal.tigadoli@broadcom.com>
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

