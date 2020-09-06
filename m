Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF6E25EC34
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 04:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728726AbgIFCz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 22:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728400AbgIFCzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 22:55:51 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCF1C061575
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 19:55:51 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id a8so2915064plm.2
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 19:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CEP28nOtEo0ciAPmv7dW3hQUWMcebI/be1qrrf2Ssm0=;
        b=NFefUQ6ia05ontLqp8ekY/q/TyERKr6WLpdRgIaCoDJmRgUF46UQzkUoS5lEwvaroq
         qO42xRbFR+3jSmdTcccP/0dvq8cxRQXLNZlvsvcFM6Q6AC3AHq+G6JC3SRXQQBMDvrPT
         7z0qDnjWX1bVd/benY1UVAuDoUZ6RQoBUKPAY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CEP28nOtEo0ciAPmv7dW3hQUWMcebI/be1qrrf2Ssm0=;
        b=qvfXtFMMjVfh2XQb8FB5KgGgaSbyk7u+hEgNpJGQkPR47XCROZM/X3eJ8WEEAWU07L
         rEKALGQm4M1mAw/2UsN+DVZI44Q5ApAG2FpnaU8ajJtL7CsZynI2tsbxnO7LkXZl4Ku0
         GCkPyNsguL2/tqejdNWWB6Unt0hacFRkp7JW4GVevJqZ7gOi4jJXcN5ksBMzIXj+Kgte
         x4l3mO/HnXZW/YuVdzEVp26iwdSZFldeYBjET55nJDBWfIUu01RRgsUNfzL7NYOhshrU
         AekKY6mKdwKXStGkAzQY+hwyNfqnqT0MRd10a7tIkXk00UIIVYa38rYZ585+5aKSxa7R
         V1Kg==
X-Gm-Message-State: AOAM5316zblqUSeU72hK0f/39+0lK+Thz4Fds7R/EbLfn+f68LoHUXCG
        W1NH5RaWas3n2xlafBZ4oys2gQ==
X-Google-Smtp-Source: ABdhPJw39c5g+ha7dPzSF2We4+Y35Yqrli5Qw/NecAdriG2bi3MN2TUsM7TLUaTgOWHpG2OD+e6Nww==
X-Received: by 2002:a17:90b:3891:: with SMTP id mu17mr14239860pjb.160.1599360950865;
        Sat, 05 Sep 2020 19:55:50 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h5sm1346959pgn.75.2020.09.05.19.55.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Sep 2020 19:55:50 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net 2/2] bnxt_en: Fix NULL ptr dereference crash in bnxt_fw_reset_task()
Date:   Sat,  5 Sep 2020 22:55:37 -0400
Message-Id: <1599360937-26197-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1599360937-26197-1-git-send-email-michael.chan@broadcom.com>
References: <1599360937-26197-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

bnxt_fw_reset_task() which runs from a workqueue can race with
bnxt_remove_one().  For example, if firmware reset and VF FLR are
happening at about the same time.

bnxt_remove_one() already cancels the workqueue and waits for it
to finish, but we need to do this earlier before the devlink
reporters are destroyed.  This will guarantee that
the devlink reporters will always be valid when bnxt_fw_reset_task()
is still running.

Fixes: b148bb238c02 ("bnxt_en: Fix possible crash in bnxt_fw_reset_task().")
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 619eb55..8eb73fe 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11779,6 +11779,10 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 	if (BNXT_PF(bp))
 		bnxt_sriov_disable(bp);
 
+	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
+	bnxt_cancel_sp_work(bp);
+	bp->sp_event = 0;
+
 	bnxt_dl_fw_reporters_destroy(bp, true);
 	if (BNXT_PF(bp))
 		devlink_port_type_clear(&bp->dl_port);
@@ -11786,9 +11790,6 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 	unregister_netdev(dev);
 	bnxt_dl_unregister(bp);
 	bnxt_shutdown_tc(bp);
-	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
-	bnxt_cancel_sp_work(bp);
-	bp->sp_event = 0;
 
 	bnxt_clear_int_mode(bp);
 	bnxt_hwrm_func_drv_unrgtr(bp);
-- 
1.8.3.1

