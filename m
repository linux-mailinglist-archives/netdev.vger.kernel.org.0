Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D546F14FC2A
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 08:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgBBHmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 02:42:10 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38309 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbgBBHmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 02:42:08 -0500
Received: by mail-pg1-f194.google.com with SMTP id a33so6026092pgm.5
        for <netdev@vger.kernel.org>; Sat, 01 Feb 2020 23:42:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6tAxeML856Y83b4b+ms4Rnl05601qTgj2k9HvX7imCs=;
        b=iSOuNc9OBlFdwUPUipnb7AmVvvwmj863nOON+/XdJxC9FhkQa7ZCutAffc5EoKoTJi
         dsrsB3yNZeO5wZw0bwbsKZFAakTOIpzUbyD2HHiTsBEgeMVdgIhjfUm2S3gDS6MQI6DD
         qWUHPXq7T8XMz3wjh1+CNoJWTYqcXtLs8rFvg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6tAxeML856Y83b4b+ms4Rnl05601qTgj2k9HvX7imCs=;
        b=ZOYI9GIoO63/BDvK3HvntVcd8uvpE52j07vfZI91rIlSn5+Z0YnGEdSvH6rup+88Pt
         0YEqfIkL/wzPXWPS7DGWNCSSmu5dmS831SvO8t6rs8D9SQ+DhsMC6upEc7hBOcYtASbL
         OQXFTG69dl7J6Mwt3dRC0pTMH9ZTfu0nlBI+SD2Gyk7x73+GpnpFjkOGpNEoGARSN8cT
         3JJHPgG2vI8tFcGDRpPOul+RnyIe9dqwWt8IA4JKIiCv0lWoGawGRreW2TTq7SiTs4MW
         LF3iTUmzs1SWSx+a0GLD+UxlrWJncMLj69n9+9NAeXQnimxBZ3mxHtX4skEYhYmBCKCS
         RFuA==
X-Gm-Message-State: APjAAAX9xHl8vYo1j0ff+aUUfI6l9sa87K8kyYlHH7GVwWlseISerYrF
        Htst7Bm9jGRgMXyfKAZWRqAwkui6sD4=
X-Google-Smtp-Source: APXvYqw4tJB9DewPCKnWTz9gTS//QzIQSz710AruZPHQu9BeKB0D730HSI9uz5gU+5A8F4+x0OFKjA==
X-Received: by 2002:a63:4d1b:: with SMTP id a27mr18514397pgb.352.1580629326504;
        Sat, 01 Feb 2020 23:42:06 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y21sm16223162pfm.136.2020.02.01.23.42.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Feb 2020 23:42:06 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net 3/4] bnxt_en: Fix logic that disables Bus Master during firmware reset.
Date:   Sun,  2 Feb 2020 02:41:37 -0500
Message-Id: <1580629298-20071-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580629298-20071-1-git-send-email-michael.chan@broadcom.com>
References: <1580629298-20071-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

The current logic that calls pci_disable_device() in __bnxt_close_nic()
during firmware reset is flawed.  If firmware is still alive, we're
disabling the device too early, causing some firmware commands to
not reach the firmware.

Fix it by moving the logic to bnxt_reset_close().  If firmware is
in fatal condition, we call pci_disable_device() before we free
any of the rings to prevent DMA corruption of the freed rings.  If
firmware is still alive, we call pci_disable_device() after the
last firmware message has been sent.

Fixes: 3bc7d4a352ef ("bnxt_en: Add BNXT_STATE_IN_FW_RESET state.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index a69e4662..cea6033 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9313,10 +9313,6 @@ static void __bnxt_close_nic(struct bnxt *bp, bool irq_re_init,
 	bnxt_debug_dev_exit(bp);
 	bnxt_disable_napi(bp);
 	del_timer_sync(&bp->timer);
-	if (test_bit(BNXT_STATE_IN_FW_RESET, &bp->state) &&
-	    pci_is_enabled(bp->pdev))
-		pci_disable_device(bp->pdev);
-
 	bnxt_free_skbs(bp);
 
 	/* Save ring stats before shutdown */
@@ -10102,9 +10098,16 @@ static void bnxt_reset(struct bnxt *bp, bool silent)
 static void bnxt_fw_reset_close(struct bnxt *bp)
 {
 	bnxt_ulp_stop(bp);
+	/* When firmware is fatal state, disable PCI device to prevent
+	 * any potential bad DMAs before freeing kernel memory.
+	 */
+	if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
+		pci_disable_device(bp->pdev);
 	__bnxt_close_nic(bp, true, false);
 	bnxt_clear_int_mode(bp);
 	bnxt_hwrm_func_drv_unrgtr(bp);
+	if (pci_is_enabled(bp->pdev))
+		pci_disable_device(bp->pdev);
 	bnxt_free_ctx_mem(bp);
 	kfree(bp->ctx);
 	bp->ctx = NULL;
-- 
2.5.1

