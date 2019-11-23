Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37517107DB6
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 09:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfKWI0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 03:26:30 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38023 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfKWI0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 03:26:30 -0500
Received: by mail-pf1-f195.google.com with SMTP id c13so4821550pfp.5
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 00:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=URb/e3h60Ba58HfCg570peP5xkRklD4hJL1Zuu444b8=;
        b=L48tPyPHPBLUljfWaVtHGsW3mrKMGxkvtKDmtnFxR5f6LtcfjsvpB9kC6qK7pSwpv9
         7cp2Oi1rnwS6fMQFNCy3MCaqFgKwiatrdbkx3U2EWJjZE56eLCj/gbt9ANidReOtrqzM
         U+b5GP29364aNtmCymR5aj/Akbvws7EaNUvmU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=URb/e3h60Ba58HfCg570peP5xkRklD4hJL1Zuu444b8=;
        b=s6JxV51wQwZZyNNudLQb68YLYY24qQzzAh1rUHxouzMA4TPDz7Cqu5gcIcrDovka2G
         MWafiVFBZbJgXwvJH4qVW4sS/9Zrn/WADMTPAm0K7hBXeABGIPt2brnjQw4196fy+gq5
         vYxWc1HZjdxUmMumO0bRDuqAWlAviKZ/WXy4RjD7TpmFwyEDzL17vYaE2zfwRea1tBve
         9bc5sDhO6Nc4/Q4aKQNsHOGxStigSxBMaVYXpFcrWWHdYB1+QQcAa9jZfZ/Re9C10OOr
         t1/cMnDNw5jsY7/7Y3TP2Fy7xgmotnWE27cR3fKSiR3KxLOwsiRQaWAA3s1KNdfrQYWN
         4fbg==
X-Gm-Message-State: APjAAAXsY3tO3duyUbINtzuAVGcrIUx/r0GNFvoSk03YTbVegoCqwiuC
        0J80hg4R5HatZ79PO41jzhOJAg==
X-Google-Smtp-Source: APXvYqwNZdLbmybhgSSiS7lr4cAl7yWBSQm9ajwlXhyFfYIBIrNJfeipxSITLy2vLe2n/2zAFBl1ag==
X-Received: by 2002:a62:5807:: with SMTP id m7mr2496198pfb.180.1574497589985;
        Sat, 23 Nov 2019 00:26:29 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p16sm573236pfn.171.2019.11.23.00.26.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 00:26:29 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 03/15] bnxt_en: Do driver unregister cleanup in bnxt_init_one() failure path.
Date:   Sat, 23 Nov 2019 03:25:58 -0500
Message-Id: <1574497570-22102-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
References: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

In the bnxt_init_one() failure path, if the driver has already called
firmware to register the driver, it is not undoing the driver
registration.  Add this missing step to unregister for correctness,
so that the firmware knows that the driver has unloaded.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 13 ++++++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 14b6104..464e8bd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4483,9 +4483,12 @@ static int bnxt_hwrm_func_drv_rgtr(struct bnxt *bp)
 
 	mutex_lock(&bp->hwrm_cmd_lock);
 	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	if (!rc && (resp->flags &
-		    cpu_to_le32(FUNC_DRV_RGTR_RESP_FLAGS_IF_CHANGE_SUPPORTED)))
-		bp->fw_cap |= BNXT_FW_CAP_IF_CHANGE;
+	if (!rc) {
+		set_bit(BNXT_STATE_DRV_REGISTERED, &bp->state);
+		if (resp->flags &
+		    cpu_to_le32(FUNC_DRV_RGTR_RESP_FLAGS_IF_CHANGE_SUPPORTED))
+			bp->fw_cap |= BNXT_FW_CAP_IF_CHANGE;
+	}
 	mutex_unlock(&bp->hwrm_cmd_lock);
 	return rc;
 }
@@ -4494,6 +4497,9 @@ static int bnxt_hwrm_func_drv_unrgtr(struct bnxt *bp)
 {
 	struct hwrm_func_drv_unrgtr_input req = {0};
 
+	if (!test_and_clear_bit(BNXT_STATE_DRV_REGISTERED, &bp->state))
+		return 0;
+
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_DRV_UNRGTR, -1, -1);
 	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 }
@@ -11864,6 +11870,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	bnxt_clear_int_mode(bp);
 
 init_err_pci_clean:
+	bnxt_hwrm_func_drv_unrgtr(bp);
 	bnxt_free_hwrm_short_cmd_req(bp);
 	bnxt_free_hwrm_resources(bp);
 	bnxt_free_ctx_mem(bp);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index e07311e..a38664eef 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1646,6 +1646,7 @@ struct bnxt {
 #define BNXT_STATE_IN_FW_RESET	4
 #define BNXT_STATE_ABORT_ERR	5
 #define BNXT_STATE_FW_FATAL_COND	6
+#define BNXT_STATE_DRV_REGISTERED	7
 
 	struct bnxt_irq	*irq_tbl;
 	int			total_irqs;
-- 
2.5.1

