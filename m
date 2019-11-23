Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAAB107DB9
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 09:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfKWI0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 03:26:37 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36231 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbfKWI0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 03:26:37 -0500
Received: by mail-pf1-f194.google.com with SMTP id b19so4830233pfd.3
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 00:26:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CEEKHwN0X2Vjw7eHGh5ig2JX1Z6w8+yMLtvgY6iCPNw=;
        b=VpzG+2nej2rRDOLfwsXhAXHi0OI43wFpGYJ8qEVJN+TAuzcig+C7yxksLbFLY6QH+E
         5p3he9Lm6NxWfHptvlr4enF5vqxxViRRo1syIdZFb4e5ubZgs0o5ymlRiaMeovTb2qCx
         0lVzQ60Qu2dyDXoSAHs8VGOTsPEGGXDDckHPo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CEEKHwN0X2Vjw7eHGh5ig2JX1Z6w8+yMLtvgY6iCPNw=;
        b=s1tkDBmxx+eLFVOTquE5IFHBcZJRIjwk7eKcaUBK/9Y1J+OWeS3KY/avL8ld9+n3Bp
         1rQy4KFr+NNfyP6VdYnfaEyU24B2vUQMlPCHnewDBBdrhSGqmdZP4RGwWWTc7UH5rwLR
         e8yKDzFQ/bVI/3WC1mGkHQAt83FeVasePXNYaXQ0j27jVzmraqr03Y+3UFLUxe/nxyME
         1tvKSuKId4tLVDZ4tQM/NJxzI2y+YJAlrctvxAOB4PpJGWAAooEeuT5IpEiu/P9sENVW
         F57N2syw+P5NnoRP7slZ/TKn6cMEgK68cr0AWP4ZiX+kywRZOkBvNNl0xQbkGMbdL4au
         0Ypg==
X-Gm-Message-State: APjAAAUNw7ruc8OWgjptRYqHqx42P2GevlZyInyH/3PX7LKf2cmHoSGY
        T1jnIz8LG9Qy4LyxRtK3uQO1v1W9FfA=
X-Google-Smtp-Source: APXvYqz50jt/WsdP5avwzgEk8zPZD3h5N8mAfORkR0fgFA8tXWokutpxDwyQLcXO3iU7ff3MZNn58w==
X-Received: by 2002:a65:67c1:: with SMTP id b1mr20677965pgs.149.1574497596586;
        Sat, 23 Nov 2019 00:26:36 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p16sm573236pfn.171.2019.11.23.00.26.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 00:26:36 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 06/15] bnxt_en: Fix suspend/resume path on 57500 chips
Date:   Sat, 23 Nov 2019 03:26:01 -0500
Message-Id: <1574497570-22102-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
References: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Driver calls HWRM_FUNC_RESET firmware call while resuming the device
which clears the context memory backing store. Because of which
allocating firmware resources would eventually fail. Fix it by freeing
all context memory during suspend and reallocate the memory during resume.

Call bnxt_hwrm_queue_qportcfg() in resume path.  This firmware call
is needed on the 57500 chips so that firmware will set up the proper
queue mapping in relation to the context memory.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 69d7ab1..6a12ab5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11916,6 +11916,9 @@ static int bnxt_suspend(struct device *device)
 	}
 	bnxt_hwrm_func_drv_unrgtr(bp);
 	pci_disable_device(bp->pdev);
+	bnxt_free_ctx_mem(bp);
+	kfree(bp->ctx);
+	bp->ctx = NULL;
 	rtnl_unlock();
 	return rc;
 }
@@ -11944,6 +11947,17 @@ static int bnxt_resume(struct device *device)
 		goto resume_exit;
 	}
 
+	if (bnxt_hwrm_queue_qportcfg(bp)) {
+		rc = -ENODEV;
+		goto resume_exit;
+	}
+
+	if (bp->hwrm_spec_code >= 0x10803) {
+		if (bnxt_alloc_ctx_mem(bp)) {
+			rc = -ENODEV;
+			goto resume_exit;
+		}
+	}
 	if (BNXT_NEW_RM(bp))
 		bnxt_hwrm_func_resc_qcaps(bp, false);
 
-- 
2.5.1

