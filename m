Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAAC1F8B61
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 01:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgFNX5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 19:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbgFNX5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 19:57:40 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DEEC05BD43
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 16:57:39 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id p20so15466307ejd.13
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 16:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jf/A/gK1QRhm6wRIfmSgoY2GZmGZiq12N5Yg+cGRqxY=;
        b=Lw9uAnmQzSU/8TRu5uq9R7J6xInS453KNN7BKcAvYEBVWKyyZ6aUUIJ8P3ascgJx7F
         +iVpAOwBYodDheI/M+KKVlBARL0Y4WTOwonuI3EKpE18XKXsAaqRUWt9fkUYtEJu0Lrw
         Idz0ZYng9bWHk0wsx96UT/rpBnIsZLPGD93UA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jf/A/gK1QRhm6wRIfmSgoY2GZmGZiq12N5Yg+cGRqxY=;
        b=C8CZ9odN0IDypsrMvkIeZVEL4IEC2vfuXTNxBbALBETpKUTQqHsLw9oFVnmdmu269h
         6yUfye3GJqvTRN+E8Kqhc3WFWZHg7X/vyFaAFGmAYOHqmx0gEcBEoyft3HZg9qorWl2c
         a77Cg59OuHdjIla0MudvGBR8EhMghmqaI6vsz38qxiF0RLyvkTsDEW3oLWZIYORrJK5j
         5ZdUlWoly8E5gL/ts1S8HNXAZj9yAzxrXQjvRR/Pem0VoSLBKHQWmMfHhjGPFo8SOULI
         LOZhiNjQ5il/g6EtvNXa19ajujD3eGVl2Oy8DDIoeBEBtYOHE2RW1CaeZAKa8s7TlCIt
         rzuw==
X-Gm-Message-State: AOAM530HIVOPsPrRjd/bEWtcut1RknNutgPvTATYP0slQAFMo1pNLeo/
        hwtjIcZl3w3CYsE8rU0TLlQbHg==
X-Google-Smtp-Source: ABdhPJxORu3aEyq2icGKBdRtsbWWeen3fXhJecv3nrHaYexnB0D8F/4epMTZeFRbmeEgyq4F9ROnhQ==
X-Received: by 2002:a17:906:b817:: with SMTP id dv23mr22782476ejb.185.1592179058475;
        Sun, 14 Jun 2020 16:57:38 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gj10sm7891398ejb.61.2020.06.14.16.57.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Jun 2020 16:57:38 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/4] bnxt_en: Fix AER reset logic on 57500 chips.
Date:   Sun, 14 Jun 2020 19:57:09 -0400
Message-Id: <1592179030-4533-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592179030-4533-1-git-send-email-michael.chan@broadcom.com>
References: <1592179030-4533-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

AER reset should follow the same steps as suspend/resume.  We need to
free context memory during AER reset and allocate new context memory
during recovery by calling bnxt_hwrm_func_qcaps().  We also need
to call bnxt_reenable_sriov() to restore the VFs.

Fixes: bae361c54fb6 ("bnxt_en: Improve AER slot reset.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 0d97f47..47b45ea 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12196,6 +12196,9 @@ static pci_ers_result_t bnxt_io_error_detected(struct pci_dev *pdev,
 		bnxt_close(netdev);
 
 	pci_disable_device(pdev);
+	bnxt_free_ctx_mem(bp);
+	kfree(bp->ctx);
+	bp->ctx = NULL;
 	rtnl_unlock();
 
 	/* Request a slot slot reset. */
@@ -12229,12 +12232,16 @@ static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
 		pci_set_master(pdev);
 
 		err = bnxt_hwrm_func_reset(bp);
-		if (!err && netif_running(netdev))
-			err = bnxt_open(netdev);
-
-		if (!err)
-			result = PCI_ERS_RESULT_RECOVERED;
+		if (!err) {
+			err = bnxt_hwrm_func_qcaps(bp);
+			if (!err && netif_running(netdev))
+				err = bnxt_open(netdev);
+		}
 		bnxt_ulp_start(bp, err);
+		if (!err) {
+			bnxt_reenable_sriov(bp);
+			result = PCI_ERS_RESULT_RECOVERED;
+		}
 	}
 
 	if (result != PCI_ERS_RESULT_RECOVERED) {
-- 
1.8.3.1

