Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB50EAD26
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 11:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfJaKJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 06:09:02 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46165 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727480AbfJaKJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 06:09:00 -0400
Received: by mail-wr1-f67.google.com with SMTP id n15so5499288wrw.13
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 03:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1b/PjoEJ3+h+SBh6G5LSt0fwIln3xfl7/abE1bFQX1U=;
        b=UEM+IQJNCIRkC+Zz26kydgCfcVSwtF8Sd742PhPGZYJ2EEjU2WLKAgZojPv2WPsVby
         e+y1oSgRNd+jPfiLxIVNc8TWj2ePd7zfp1wsNpsKrqFn8MqGNkNnVFhH4Koi6996tsoV
         yABReLlbrhd0UObtjrntiW2ZH4PrVilWXUYec=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1b/PjoEJ3+h+SBh6G5LSt0fwIln3xfl7/abE1bFQX1U=;
        b=eYSNEiW86q+0fJug1x6RIC8jIuSLJLshteR3y5HD2zh1Hq/KTWh4dXsKQbiE9pQgAL
         kwNHUs6HzqLJ2MBfZqX1Z7TsEdTERo1qDWaKtC+7a89ZjofFXw9IroLCMKO/+s7AYg/k
         7xjlnv4QF5uZpPu6DdJ78HDmNU3eAgxoNSqqe1zayZ4eLE6vEOgffyNymDR8cNavk1X9
         BANgn56Ad6heu8lZrgBALvUp0Lv+CicnnTU0nashs9eY9Nroufv/TB3eiE/9Kwpmx0nj
         6iLSxznmUVWudFbBxyQdfCYINh+S8MESfT5ncfIWgOFYWZ4sUrsHelptALklK5JMNaP8
         71DQ==
X-Gm-Message-State: APjAAAUHOj9AL5ytfi3MHXsYuNaB6YcjyLlyTRP6ezFNdBhdhGsHAwtO
        bSAYg2CRl3xWJw9f+6Xeezfn4A==
X-Google-Smtp-Source: APXvYqwqeMLgZTiv2t/y7ulQTNl2LeGGoGdpvP9Wm3tZW+ENEK6kwM0/MIefJnaXXNAu8b7E1Fq/Pg==
X-Received: by 2002:adf:ea8d:: with SMTP id s13mr3799182wrm.366.1572516538705;
        Thu, 31 Oct 2019 03:08:58 -0700 (PDT)
Received: from shitalt.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id w8sm3719609wrr.44.2019.10.31.03.08.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 31 Oct 2019 03:08:57 -0700 (PDT)
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
Subject: [PATCH net-next V5 2/3] bnxt_en: Add support to invoke OP-TEE API to reset firmware
Date:   Thu, 31 Oct 2019 15:38:51 +0530
Message-Id: <1572516532-5977-3-git-send-email-sheetal.tigadoli@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1572516532-5977-1-git-send-email-sheetal.tigadoli@broadcom.com>
References: <1572516532-5977-1-git-send-email-sheetal.tigadoli@broadcom.com>
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

