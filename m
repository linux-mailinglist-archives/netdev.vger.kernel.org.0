Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 213E2107DB8
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 09:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfKWI0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 03:26:35 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:40478 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbfKWI0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 03:26:35 -0500
Received: by mail-pj1-f68.google.com with SMTP id ep1so4214184pjb.7
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 00:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=D8xEbQZ+IOLV2uefkd0EqzXQTKGdY3oW8wEMZbOscGI=;
        b=FkLVKDvsOhjH6Hp7Ge8kCpLFGisWj8nY7tsPdyfyPGGOZvoINS0tmYbxxki5/X8+wm
         DK2EA+EAtEgKlfs/fyFTfdA81jkPmWiWqA1zimqJojrAi2MZhFcBoVzIez5ib1Xzh1xW
         dq195tLuD6tNxFpnCSd49r6w4hQKrICpB4zgg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=D8xEbQZ+IOLV2uefkd0EqzXQTKGdY3oW8wEMZbOscGI=;
        b=lO9PbhUC+Klbno7GShUX4vQjCfKsBj9CaOzOuW/ZVujJdz+to6WwpqtQXt/jIPiOVm
         72l4bauQ5hbSfe2fvV5VSkrT6k4syEFrI7Skq061Lzfrzsh2xh2gyEnD88jsfZl3GuIK
         lmtL3DRucaqfG6mA1G0WLUWccC6LOEsQP/bTIjDtte69JOE06WMGHj/83QYU2IVdoh9X
         avWXKAb88mPJTSqazKL29ULNVHoQt3mHse06vFHyfm6iaaTf25eLdmf1NUZYhZ5q8e0J
         TpAbyB8dvjigRIBVFaampQaV9og34eoj5MQ/nMtlQVa6b5stVU2OQI6YIsWZ0Xov6oK0
         zauQ==
X-Gm-Message-State: APjAAAV/AhCmE5qxLJRgqBGNykjkOsRR2JhndXBzSa/OVSZ5Qqi+3slx
        4jT1NjDatxbVIe2NoOXk+BS9LQ==
X-Google-Smtp-Source: APXvYqygWQLmz/k+dOVMLC02cfKy+F4VsxpmkBaXmRkG7VmyGHnxFdjAZjauGBVF1jBpyr1bo0Hdsw==
X-Received: by 2002:a17:90b:14d:: with SMTP id em13mr24029930pjb.20.1574497594459;
        Sat, 23 Nov 2019 00:26:34 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p16sm573236pfn.171.2019.11.23.00.26.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 00:26:34 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 05/15] bnxt_en: Send FUNC_RESOURCE_QCAPS command in bnxt_resume()
Date:   Sat, 23 Nov 2019 03:26:00 -0500
Message-Id: <1574497570-22102-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
References: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

After driver unregister, firmware is erasing the information that
driver supports new resource management. Send FUNC_RESOURCE_QCAPS
command to inform the firmware that driver supports new resource
management while resuming from hibernation.  Otherwise, we fallback
to the older resource allocation scheme.

Also, move driver register after sending FUNC_RESOURCE_QCAPS command
to be consistent with the normal initialization sequence.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f627741..69d7ab1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11934,8 +11934,7 @@ static int bnxt_resume(struct device *device)
 		goto resume_exit;
 	}
 	pci_set_master(bp->pdev);
-	if (bnxt_hwrm_ver_get(bp) ||
-	    bnxt_hwrm_func_drv_rgtr(bp, NULL, 0, false)) {
+	if (bnxt_hwrm_ver_get(bp)) {
 		rc = -ENODEV;
 		goto resume_exit;
 	}
@@ -11944,6 +11943,15 @@ static int bnxt_resume(struct device *device)
 		rc = -EBUSY;
 		goto resume_exit;
 	}
+
+	if (BNXT_NEW_RM(bp))
+		bnxt_hwrm_func_resc_qcaps(bp, false);
+
+	if (bnxt_hwrm_func_drv_rgtr(bp, NULL, 0, false)) {
+		rc = -ENODEV;
+		goto resume_exit;
+	}
+
 	bnxt_get_wol_settings(bp);
 	if (netif_running(dev)) {
 		rc = bnxt_open(dev);
-- 
2.5.1

