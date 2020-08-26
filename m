Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C83252674
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 07:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgHZFJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 01:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbgHZFJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 01:09:12 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC7BC061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 22:09:11 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id w13so428901wrk.5
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 22:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XHaGhsqTt5ZjagXMlpNlu3cCee8flkdStPbXbpx2+yI=;
        b=YiPte4klZ9UIaYO6nJEX2vN3HMIEjj73J1TuCvX+9R2vJE9/tbsi3WBrxPGIvu/X3B
         T576ZA4atgHIZV2BMBAoafOzPT8bCdAMpnf9KFiOHwv1hsX1DgfdmDi1EnteLCVo5Caf
         ixC9GjqjMsSFfHUHj/cUp6oZVmA53UANK0Mc0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XHaGhsqTt5ZjagXMlpNlu3cCee8flkdStPbXbpx2+yI=;
        b=S7uAHI94d6SQ+Mz2w7nC3IjPB88rMX5qtqn5V/JvinxQM0PHylC7A7PM4C0OCfi67j
         m6FbDbC3SP7uswN8Y8LfLXPWZoWd/M4BbBhf+NWyFqK/6gnWh1cKCWXildQGSP64wdfM
         q4qo3xaAjgFaD2rr8KhMUrbAyKgwR6mvXKiPBwt9Utb3/XIDc/ZmJwMiTTdcPQTiD94m
         pkaPo1hjjjkw9+n0S/N6WUmnzWxENWWg5hCtIc8BRs4AlDxK/Ne72bMvBrQ2tzeMB8eG
         9NiERUf8qt9yRqs6ZLaRswNmv2dhIHanYW+D0oK/stPcNm/sKTNQdqUtn6fjUUBH4yZU
         8qTg==
X-Gm-Message-State: AOAM533vQDq7zqoZk8RSNrU9uO1rFOz5UeL0gtCL8cMFBPbEj66xD/ug
        RZ43V2fmzW+xM+pl8HahauyRiQ==
X-Google-Smtp-Source: ABdhPJxsYpS/nDg2xPEInyUUN+OPc7ONDzMVE8kVg2/08ratQD2iPMxbEZ4T1cFFq78qB+VIQ4Ppag==
X-Received: by 2002:a5d:6a83:: with SMTP id s3mr13245899wru.125.1598418549835;
        Tue, 25 Aug 2020 22:09:09 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q12sm2825832wrm.39.2020.08.25.22.09.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2020 22:09:09 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 5/8] bnxt_en: Fix possible crash in bnxt_fw_reset_task().
Date:   Wed, 26 Aug 2020 01:08:36 -0400
Message-Id: <1598418519-20168-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1598418519-20168-1-git-send-email-michael.chan@broadcom.com>
References: <1598418519-20168-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bnxt_fw_reset_task() is run from a delayed workqueue.  The current
code is not cancelling the workqueue in the driver's .remove()
method and it can potentially crash if the device is removed with
the workqueue still pending.

The fix is to clear the BNXT_STATE_IN_FW_RESET flag and then cancel
the delayed workqueue in bnxt_remove_one().  bnxt_queue_fw_reset_work()
also needs to check that this flag is set before scheduling.  This
will guarantee that no rescheduling will be done after it is cancelled.

Fixes: 230d1f0de754 ("bnxt_en: Handle firmware reset.")
Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4389a74..d6f3592 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1141,6 +1141,9 @@ static int bnxt_discard_rx(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 
 static void bnxt_queue_fw_reset_work(struct bnxt *bp, unsigned long delay)
 {
+	if (!(test_bit(BNXT_STATE_IN_FW_RESET, &bp->state)))
+		return;
+
 	if (BNXT_PF(bp))
 		queue_delayed_work(bnxt_pf_wq, &bp->fw_reset_task, delay);
 	else
@@ -1157,10 +1160,12 @@ static void bnxt_queue_sp_work(struct bnxt *bp)
 
 static void bnxt_cancel_sp_work(struct bnxt *bp)
 {
-	if (BNXT_PF(bp))
+	if (BNXT_PF(bp)) {
 		flush_workqueue(bnxt_pf_wq);
-	else
+	} else {
 		cancel_work_sync(&bp->sp_task);
+		cancel_delayed_work_sync(&bp->fw_reset_task);
+	}
 }
 
 static void bnxt_sched_reset(struct bnxt *bp, struct bnxt_rx_ring_info *rxr)
@@ -11761,6 +11766,7 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 	unregister_netdev(dev);
 	bnxt_dl_unregister(bp);
 	bnxt_shutdown_tc(bp);
+	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
 	bnxt_cancel_sp_work(bp);
 	bp->sp_event = 0;
 
-- 
1.8.3.1

