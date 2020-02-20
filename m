Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFFB9166A58
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 23:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbgBTW0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 17:26:53 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42674 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727845AbgBTW0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 17:26:52 -0500
Received: by mail-pg1-f195.google.com with SMTP id w21so2620024pgl.9
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 14:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VTFminQ7M9DDGDd+33Oip3FU9AK4lbeFDoRrHxOCkwA=;
        b=iPkC8dXwjgWUkjSKORhVB8s3rwHYYC3J2YIonNkNf5Ymo5eDwKoXY7iGdvFaBxd3W0
         upWT/pml7M3hUCALxhH0GTDjBDUdBFN1A7dF4dFgc2zj5kKO8kCmtVqU5+v47r6ycvu0
         orVodJKsezgl4q56s6k2WPtRm+RR0sZbIKC3w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VTFminQ7M9DDGDd+33Oip3FU9AK4lbeFDoRrHxOCkwA=;
        b=Eg2EBWuGyowcIHeEEdxAbXWUg+8QGquk1F6KmAu7es+OC59uRMn6KsLZXNTZMc0qj6
         X7Nt9wqrSHVLYalTzXWkCYMM6AuzHZNvO0FGLjzYbyfFXvDZF5SitD1jWvhNwBq2SDYV
         9Me/UZC93KLM8gQeY1uKjAQmUpeOQj9m2AL3vsZuacCsfn52VwpTBptUEh2V7tThXG5I
         1nj0KuxTZZKiWQnZ7a+e6kL8ultkuN+PI48aTwoj4pRrixlGs4eOPsEOEiNuxYbXiSMx
         VsDJrkhiEnRymzvIreKeQUoPYm/9XCnkvDNN2TBuTIBnEg87hMcLqDZ+N/IxHPyksgbn
         f2JA==
X-Gm-Message-State: APjAAAVF6maYRF3+QAi3MCgV1HZ39SG3K7Z1pee6J0jxYslPBAH1ZZhy
        yZuRxFIqzMSmeHp34U9pmv2H9w==
X-Google-Smtp-Source: APXvYqwtEebu0sSfbtAxLN+MrZYcUYmZ3m7yTN3dIJ+I3Mo3iIQ+Q+WVGQxE7XMVBNMjLtF7T9cBmg==
X-Received: by 2002:a63:7254:: with SMTP id c20mr32320384pgn.75.1582237611727;
        Thu, 20 Feb 2020 14:26:51 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c26sm607831pfj.8.2020.02.20.14.26.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Feb 2020 14:26:51 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net 1/2] bnxt_en: Improve device shutdown method.
Date:   Thu, 20 Feb 2020 17:26:34 -0500
Message-Id: <1582237595-10503-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1582237595-10503-1-git-send-email-michael.chan@broadcom.com>
References: <1582237595-10503-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Especially when bnxt_shutdown() is called during kexec, we need to
disable MSIX and disable Bus Master to completely quiesce the device.
Make these 2 calls unconditionally in the shutdown method.

Fixes: c20dc142dd7b ("bnxt_en: Disable bus master during PCI shutdown and driver unload.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 597e6fd..2ad007e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11983,10 +11983,10 @@ static void bnxt_shutdown(struct pci_dev *pdev)
 		dev_close(dev);
 
 	bnxt_ulp_shutdown(bp);
+	bnxt_clear_int_mode(bp);
+	pci_disable_device(pdev);
 
 	if (system_state == SYSTEM_POWER_OFF) {
-		bnxt_clear_int_mode(bp);
-		pci_disable_device(pdev);
 		pci_wake_from_d3(pdev, bp->wol);
 		pci_set_power_state(pdev, PCI_D3hot);
 	}
-- 
2.5.1

