Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 321DF1D5B85
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 23:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgEOV3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 17:29:08 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41786 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727922AbgEOV3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 17:29:06 -0400
Received: by mail-pf1-f194.google.com with SMTP id 23so1592660pfy.8;
        Fri, 15 May 2020 14:29:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+C5HUmb0IVN2XUMtCx+958ASlteYAzKSr3n9xtQKd1o=;
        b=sjmJt+iGDzcAx/sJoynK2092IRpplkRBFKvE8SzJoTImgURQwF1+95B0lH32YGTQlx
         Nkxj0LdLaMogM/jD1n716idtha6ExL6H7iFa9vX/Bw639xmKZ4CJBBaHNMIipt3qT9Ue
         F99d/3wd8fCdZfeNJSIx6tUe/PSsCXxY2Qp+BkDuqX+9Qs4qJYfQl+eM+fyvk+ybOeVU
         wSIjtT2JQgIWjvjqcFZ2AYT0bBcQj363PxClrk2P3EY20eCf24ZYdkQvfO0lgw7fXrza
         SLI7FEHFO7Uer02fGPHdSG73D50AEQY24TDXAcMT1QqO/jI7C+qtQ5UEvu01h/Vtd9yD
         x8mw==
X-Gm-Message-State: AOAM531+lkF3zUHdQpy7F465dWKz5qwkXKyTRF1smhzUdS2OXu2N3dw7
        1nwCJXQRHUhdtzB+dENzks0=
X-Google-Smtp-Source: ABdhPJx5aHzvT/Yod67FCxrd/rYpeLz+YvwfHeXEiG+n38C/BUT1hIQZlmj9K6EmCO5IWEzJJXgtBQ==
X-Received: by 2002:a63:ef05:: with SMTP id u5mr4866245pgh.237.1589578144777;
        Fri, 15 May 2020 14:29:04 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id e18sm2688831pfh.75.2020.05.15.14.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 14:28:56 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 33D1942349; Fri, 15 May 2020 21:28:50 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     jeyu@kernel.org
Cc:     akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: [PATCH v2 12/15] ath10k: use new module_firmware_crashed()
Date:   Fri, 15 May 2020 21:28:43 +0000
Message-Id: <20200515212846.1347-13-mcgrof@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20200515212846.1347-1-mcgrof@kernel.org>
References: <20200515212846.1347-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes use of the new module_firmware_crashed() to help
annotate when firmware for device drivers crash. When firmware
crashes devices can sometimes become unresponsive, and recovery
sometimes requires a driver unload / reload and in the worst cases
a reboot.

Using a taint flag allows us to annotate when this happens clearly.

Cc: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org
Cc: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/net/wireless/ath/ath10k/pci.c  | 2 ++
 drivers/net/wireless/ath/ath10k/sdio.c | 2 ++
 drivers/net/wireless/ath/ath10k/snoc.c | 1 +
 3 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 1d941d53fdc9..6bd0f3b518b9 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1767,6 +1767,7 @@ static void ath10k_pci_fw_dump_work(struct work_struct *work)
 		scnprintf(guid, sizeof(guid), "n/a");
 
 	ath10k_err(ar, "firmware crashed! (guid %s)\n", guid);
+	module_firmware_crashed();
 	ath10k_print_driver_info(ar);
 	ath10k_pci_dump_registers(ar, crash_data);
 	ath10k_ce_dump_registers(ar, crash_data);
@@ -2837,6 +2838,7 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar,
 	if (ret) {
 		if (ath10k_pci_has_fw_crashed(ar)) {
 			ath10k_warn(ar, "firmware crashed during chip reset\n");
+			module_firmware_crashed();
 			ath10k_pci_fw_crashed_clear(ar);
 			ath10k_pci_fw_crashed_dump(ar);
 		}
diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index e2aff2254a40..d34ad289380f 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -794,6 +794,7 @@ static int ath10k_sdio_mbox_proc_dbg_intr(struct ath10k *ar)
 
 	/* TODO: Add firmware crash handling */
 	ath10k_warn(ar, "firmware crashed\n");
+	module_firmware_crashed();
 
 	/* read counter to clear the interrupt, the debug error interrupt is
 	 * counter 0.
@@ -915,6 +916,7 @@ static int ath10k_sdio_mbox_proc_cpu_intr(struct ath10k *ar)
 	if (cpu_int_status & MBOX_CPU_STATUS_ENABLE_ASSERT_MASK) {
 		ath10k_err(ar, "firmware crashed!\n");
 		queue_work(ar->workqueue, &ar->restart_work);
+		module_firmware_crashed();
 	}
 	return ret;
 }
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 354d49b1cd45..7cfc123c345c 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1451,6 +1451,7 @@ void ath10k_snoc_fw_crashed_dump(struct ath10k *ar)
 		scnprintf(guid, sizeof(guid), "n/a");
 
 	ath10k_err(ar, "firmware crashed! (guid %s)\n", guid);
+	module_firmware_crashed();
 	ath10k_print_driver_info(ar);
 	ath10k_msa_dump_memory(ar, crash_data);
 	mutex_unlock(&ar->dump_mutex);
-- 
2.26.2

