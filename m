Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80920A2DAF
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbfH3Dzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:55:51 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45876 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728063AbfH3Dzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 23:55:45 -0400
Received: by mail-pg1-f194.google.com with SMTP id o13so2784510pgp.12
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 20:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=i/9u00VhKceyeGjTJrjWnx0M92EAlaX42Z2vv3zKNu4=;
        b=DI8Upsgrdog+vyYkWBlhJzsIIUD2l2QdGaHYMs03hVnpcvDYhbeOHx6g2WOwL6FcJ5
         aeeRNN3TElvvgKVq0L2j7JAyiPkVhROUOL/DWdF2qG7lTkzlGYwaE502QV8WCUe7bAQd
         6TCHGHgb67z4FM3c+S5mbzHRekDiJsPacl2WI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=i/9u00VhKceyeGjTJrjWnx0M92EAlaX42Z2vv3zKNu4=;
        b=udvlW2+wZn+WdvzcjqG93qIj2Uyslre3+BYrufjGulpK4RX0hTIr3N5PlE/eXLGytj
         bQpu0WKcIN3rNoQ8VOHGOfU7BhZA5yPsNgpZCsT7FG5HZiJWHnzkAxlrlTFPiyZspVgy
         yJEyU1qu+xKzRaQDuYzi9k+J8g1kvpoCnoU82fwIOTZ15t5WBMh+9XgOo8kW5TooP1/+
         MrpKhHsxI22XH92W6WNg6FLZhqxVXeTcwDqGcXxITwtK8D0zS0gitk14kAXQaYdKkfDb
         7FjlFUlI2rK5tMYa/c0raHuYqPRBk4v1ahGdNX67iHPKRkD0tKnDPpBKkcCAS7i3Dow5
         51Eg==
X-Gm-Message-State: APjAAAUfUJsCpNsMGpAqOAZS7MWFJZznybRb3wtRTtNhV1WDzaxVIP/C
        f7x2MEnX7y/b5rjrIm/Gm3O/3w==
X-Google-Smtp-Source: APXvYqxGmAtXMQ5KLu1y/Sm0XtCzQw0is3M7h3DJT8mS4ysd24OLwwDzpfPQQcvf6c92guAO7ULEgA==
X-Received: by 2002:a17:90a:b108:: with SMTP id z8mr13606934pjq.108.1567137344459;
        Thu, 29 Aug 2019 20:55:44 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l3sm3658877pjq.24.2019.08.29.20.55.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 20:55:43 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        ray.jui@broadcom.com
Subject: [PATCH net-next v2 13/22] bnxt_en: Add BNXT_STATE_IN_FW_RESET state.
Date:   Thu, 29 Aug 2019 23:54:56 -0400
Message-Id: <1567137305-5853-14-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
References: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new flag will be set in subsequent patches when firmware is
going through reset.  If bnxt_close() is called while the new flag
is set, the FW reset sequence will have to be aborted because the
NIC is prematurely closed before FW reset has completed.  We also
reject SRIOV configurations while FW reset is in progress.

v2: No longer drop rtnl_lock() in close and wait for FW reset to complete.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c       | 20 ++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h       |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c |  5 +++++
 3 files changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 27fc047..4caacab 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8716,6 +8716,10 @@ static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 	if (flags & FUNC_DRV_IF_CHANGE_RESP_FLAGS_HOT_FW_RESET_DONE)
 		fw_reset = true;
 
+	if (test_bit(BNXT_STATE_IN_FW_RESET, &bp->state) && !fw_reset) {
+		netdev_err(bp->dev, "RESET_DONE not set during FW reset.\n");
+		return -ENODEV;
+	}
 	if (resc_reinit || fw_reset) {
 		if (fw_reset) {
 			rc = bnxt_fw_init_one(bp);
@@ -9226,6 +9230,10 @@ static void __bnxt_close_nic(struct bnxt *bp, bool irq_re_init,
 	bnxt_debug_dev_exit(bp);
 	bnxt_disable_napi(bp);
 	del_timer_sync(&bp->timer);
+	if (test_bit(BNXT_STATE_IN_FW_RESET, &bp->state) &&
+	    pci_is_enabled(bp->pdev))
+		pci_disable_device(bp->pdev);
+
 	bnxt_free_skbs(bp);
 
 	/* Save ring stats before shutdown */
@@ -9242,6 +9250,18 @@ int bnxt_close_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 {
 	int rc = 0;
 
+	if (test_bit(BNXT_STATE_IN_FW_RESET, &bp->state)) {
+		/* If we get here, it means firmware reset is in progress
+		 * while we are trying to close.  We can safely proceed with
+		 * the close because we are holding rtnl_lock().  Some firmware
+		 * messages may fail as we proceed to close.  We set the
+		 * ABORT_ERR flag here so that the FW reset thread will later
+		 * abort when it gets the rtnl_lock() and sees the flag.
+		 */
+		netdev_warn(bp->dev, "FW reset in progress during close, FW reset will be aborted\n");
+		set_bit(BNXT_STATE_ABORT_ERR, &bp->state);
+	}
+
 #ifdef CONFIG_BNXT_SRIOV
 	if (bp->sriov_cfg) {
 		rc = wait_event_interruptible_timeout(bp->sriov_cfg_wait,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index eb55519..6f7aa7c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1605,6 +1605,7 @@ struct bnxt {
 #define BNXT_STATE_IN_SP_TASK	1
 #define BNXT_STATE_READ_STATS	2
 #define BNXT_STATE_FW_RESET_DET 3
+#define BNXT_STATE_IN_FW_RESET	4
 #define BNXT_STATE_ABORT_ERR	5
 
 	struct bnxt_irq	*irq_tbl;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index ac890ca..4aacfc3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -828,6 +828,11 @@ int bnxt_sriov_configure(struct pci_dev *pdev, int num_vfs)
 		rtnl_unlock();
 		return 0;
 	}
+	if (test_bit(BNXT_STATE_IN_FW_RESET, &bp->state)) {
+		netdev_warn(dev, "Reject SRIOV config request when FW reset is in progress\n");
+		rtnl_unlock();
+		return 0;
+	}
 	bp->sriov_cfg = true;
 	rtnl_unlock();
 
-- 
2.5.1

