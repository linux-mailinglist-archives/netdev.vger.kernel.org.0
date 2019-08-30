Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB32AA2DB2
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbfH3Dz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:55:56 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:47006 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728147AbfH3Dzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 23:55:53 -0400
Received: by mail-pg1-f196.google.com with SMTP id m3so2778997pgv.13
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 20:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HJKJX8EBRgXPK0U4jpE/zBr1WTUyEgEbGQ/llWWkI3g=;
        b=eh1BzphLO/Pskt7ogOyjAzS0nIRnShT7ugs9CMRTyu9nN8kCMmG8upZCjO/kCKhkzt
         uDO3tjkoh7WQhpPwloqxZ3P4fClUsY+qcIjIDMQfACqN54C8ftRrQAQ+80/DvL8X16xA
         mVU9lD7LhBMb3X8g4EAR+SPT9cpfQ/9GFDhWo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HJKJX8EBRgXPK0U4jpE/zBr1WTUyEgEbGQ/llWWkI3g=;
        b=rUinl71i9FRZutqYMFmZp18viL10nfNmj9KRup+/hbCTop5jUpzS3NC7p0pMVWWUVk
         cUi/p5QnrEiRTD0IQgm8slCPJCav6i/G/A6mn2e6eNf2Za9Ts+oRXug9Fjw9S6AC1wWe
         j6dg14nhKV1pGukFgrbVR0/r3QwvpRQ0OfbpaLRmEUYzkLLb1SoNPcCKwNilWpb7bV5d
         tG6uKrAphX/mlTHFfNsV/uAYf04ZB7pAt0qAv/nNmIrrqW+mmBJ5qlu940mZ/1KQ/Pes
         cBPyCS/4ETSG5y808nyz4hZqCX/ipZ6Y+wGBApgv3Jq6OFqqcDVyoqIjKOoHnfbaZXYh
         kXBQ==
X-Gm-Message-State: APjAAAVKs2vJj4XdIV8oa4PKsU3wirvHLyWpS4kGhDFbRPzZTSZtkriK
        e/VPCmlD1R+e1AbKRgG/Wrl98A==
X-Google-Smtp-Source: APXvYqzpJH7tVsOJd5WL1zx3X0pUtNCIpgonqe+C1hoERgF9o1HgQfdG3kcLosHIKFV1bYpC2VN94g==
X-Received: by 2002:a17:90a:17aa:: with SMTP id q39mr13471453pja.106.1567137352602;
        Thu, 29 Aug 2019 20:55:52 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l3sm3658877pjq.24.2019.08.29.20.55.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 20:55:52 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        ray.jui@broadcom.com
Subject: [PATCH net-next v2 21/22] bnxt_en: Add bnxt_fw_exception() to handle fatal firmware errors.
Date:   Thu, 29 Aug 2019 23:55:04 -0400
Message-Id: <1567137305-5853-22-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
References: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This call will handle fatal firmware errors by forcing a reset on the
firmware.  The master function driver will carry out the forced reset.
The sequence will go through the same bnxt_fw_reset_task() workqueue.
This fatal reset differs from the non-fatal reset at the beginning
stages.  From the BNXT_FW_RESET_STATE_ENABLE_DEV state onwards where
the firmware is coming out of reset, it is practically identical to the
non-fatal reset.

The next patch will add the periodic heartbeat check and the devlink
reporter to report the fatal event and to initiate the bnxt_fw_exception()
call.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 44 +++++++++++++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 45 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 51cf679..5c7379e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10003,6 +10003,40 @@ static void bnxt_fw_reset_close(struct bnxt *bp)
 	bp->ctx = NULL;
 }
 
+/* rtnl_lock is acquired before calling this function */
+static void bnxt_force_fw_reset(struct bnxt *bp)
+{
+	struct bnxt_fw_health *fw_health = bp->fw_health;
+	u32 wait_dsecs;
+
+	if (!test_bit(BNXT_STATE_OPEN, &bp->state) ||
+	    test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
+		return;
+
+	set_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
+	bnxt_fw_reset_close(bp);
+	wait_dsecs = fw_health->master_func_wait_dsecs;
+	if (fw_health->master) {
+		if (fw_health->flags & ERROR_RECOVERY_QCFG_RESP_FLAGS_CO_CPU)
+			wait_dsecs = 0;
+		bp->fw_reset_state = BNXT_FW_RESET_STATE_RESET_FW;
+	} else {
+		bp->fw_reset_timestamp = jiffies + wait_dsecs * HZ / 10;
+		wait_dsecs = fw_health->normal_func_wait_dsecs;
+		bp->fw_reset_state = BNXT_FW_RESET_STATE_ENABLE_DEV;
+	}
+	bp->fw_reset_max_dsecs = fw_health->post_reset_max_wait_dsecs;
+	bnxt_queue_fw_reset_work(bp, wait_dsecs * HZ / 10);
+}
+
+void bnxt_fw_exception(struct bnxt *bp)
+{
+	set_bit(BNXT_STATE_FW_FATAL_COND, &bp->state);
+	bnxt_rtnl_lock_sp(bp);
+	bnxt_force_fw_reset(bp);
+	bnxt_rtnl_unlock_sp(bp);
+}
+
 void bnxt_fw_reset(struct bnxt *bp)
 {
 	int rc;
@@ -10506,6 +10540,16 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		return;
 	}
 	case BNXT_FW_RESET_STATE_ENABLE_DEV:
+		if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state) &&
+		    bp->fw_health) {
+			u32 val;
+
+			val = bnxt_fw_health_readl(bp,
+						   BNXT_FW_RESET_INPROG_REG);
+			if (val)
+				netdev_warn(bp->dev, "FW reset inprog %x after min wait time.\n",
+					    val);
+		}
 		clear_bit(BNXT_STATE_FW_FATAL_COND, &bp->state);
 		if (pci_enable_device(bp->pdev)) {
 			netdev_err(bp->dev, "Cannot re-enable PCI device\n");
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index f3a6aad..3459b2a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1982,6 +1982,7 @@ int bnxt_open_nic(struct bnxt *, bool, bool);
 int bnxt_half_open_nic(struct bnxt *bp);
 void bnxt_half_close_nic(struct bnxt *bp);
 int bnxt_close_nic(struct bnxt *, bool, bool);
+void bnxt_fw_exception(struct bnxt *bp);
 void bnxt_fw_reset(struct bnxt *bp);
 int bnxt_check_rings(struct bnxt *bp, int tx, int rx, bool sh, int tcs,
 		     int tx_xdp);
-- 
2.5.1

