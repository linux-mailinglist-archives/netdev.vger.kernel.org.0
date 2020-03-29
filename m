Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3945196DFE
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 16:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgC2OzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 10:55:14 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:39652 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727488AbgC2OzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 10:55:14 -0400
Received: by mail-pj1-f65.google.com with SMTP id z3so5660224pjr.4
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 07:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5hqpcgBBzNxJeuhkLEnX8dVIZl2yk0UtG/4+R3SGmY0=;
        b=GN9QncS3nxUMMgSZkgk4pYNRlVy8X28PA+wRfLfqQ4O7cexOy0IsWtusI9aow7rg6v
         WdalzpGXCFb6Nu6W9DrUWQcnFMAq0RRy7j0k2sfKZ7CI3KYTbBcg2owVb8byv69E4T8R
         ktFo+H+lHK/RuQuOewZDE8eDXC9B74iWuRYrgnq8rMwmhrmJZq7w4wQSo1QWqnGFj1vG
         1R+oCPUmt0uRHYpxXr1VRC6FwN+PL7O5awv3VDRL4CMpHmpmgFZ/k9mlOKpi3xDv2f34
         FVAataGeKp7teJY9oo6gDmVljBn4jel0UrfJLfWZHtBO0KQqRoYD5XeCL8v77nD0YRsE
         4PWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5hqpcgBBzNxJeuhkLEnX8dVIZl2yk0UtG/4+R3SGmY0=;
        b=R6d/8z4fCgM+ML1NQcFum45Ru7lxOWnL37YIz1/mookiKCw14HsZfUpeStYLOu8J51
         /zK7zJSJk+cxeqQcu3E48E0hLd89KEEyDR+9aCcW6ZyezTzIPOvrPpIkqktowMyWJ0ze
         KNlkuoFGIXONA+Nb4o+PGbE55z2J7D/9ikSb8dWMdJl7CldqZ936uJXtCg8/JyBEddfm
         67CLKFlI+QAeG8AR8N72LYPcSVKK1Gsihd75XFS7i9RJgt8UiTTqclrUqas8a+xXEJs5
         F6G/T36d0i6VBsAHrV7bDkGELzJIn+SZ8/iidyKPwc5QDSm9t5IPJILM76GmL4s3uEPE
         2RZA==
X-Gm-Message-State: ANhLgQ1Kw0zeU0iRFNplXKXhL9+KjwNgb8bzIgsJQ5oxSDmETz3a/0fM
        2xOI1SPD6d+G8W0/rdfrlBOIxCsJ
X-Google-Smtp-Source: ADFU+vtDn17bs5z1wpBMdaTWayPZJ8VCnOrg6+MzFJotRar53pFaum6hItt1eVfOg5lY0+EuMm837g==
X-Received: by 2002:a17:90a:9408:: with SMTP id r8mr11079917pjo.15.1585493711601;
        Sun, 29 Mar 2020 07:55:11 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id v4sm2178562pfb.31.2020.03.29.07.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 07:55:11 -0700 (PDT)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, Yangbo Lu <yangbo.lu@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next V2] ptp: Avoid deadlocks in the programmable pin code.
Date:   Sun, 29 Mar 2020 07:55:10 -0700
Message-Id: <20200329145510.2803-1-richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PTP Hardware Clock (PHC) subsystem offers an API for configuring
programmable pins.  User space sets or gets the settings using ioctls,
and drivers verify dialed settings via a callback.  Drivers may also
query pin settings by calling the ptp_find_pin() method.

Although the core subsystem protects concurrent access to the pin
settings, the implementation places illogical restrictions on how
drivers may call ptp_find_pin().  When enabling an auxiliary function
via the .enable(on=1) callback, drivers may invoke the pin finding
method, but when disabling with .enable(on=0) drivers are not
permitted to do so.  With the exception of the mv88e6xxx, all of the
PHC drivers do respect this restriction, but still the locking pattern
is both confusing and unnecessary.

This patch changes the locking implementation to allow PHC drivers to
freely call ptp_find_pin() from their .enable() and .verify()
callbacks.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Reported-by: Yangbo Lu <yangbo.lu@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/dp83640.c        |  2 +-
 drivers/ptp/ptp_chardev.c        |  9 +++++++++
 drivers/ptp/ptp_clock.c          | 17 +++++++++++++++--
 include/linux/ptp_clock_kernel.h | 19 +++++++++++++++++++
 4 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index ac72a324fcd1..415c27310982 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -628,7 +628,7 @@ static void recalibrate(struct dp83640_clock *clock)
 	u16 cal_gpio, cfg0, evnt, ptp_trig, trigger, val;
 
 	trigger = CAL_TRIGGER;
-	cal_gpio = 1 + ptp_find_pin(clock->ptp_clock, PTP_PF_PHYSYNC, 0);
+	cal_gpio = 1 + ptp_find_pin_unlocked(clock->ptp_clock, PTP_PF_PHYSYNC, 0);
 	if (cal_gpio < 1) {
 		pr_err("PHY calibration pin not available - PHY is not calibrated.");
 		return;
diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index 9d72ab593f13..93d574faf1fe 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -175,7 +175,10 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		}
 		req.type = PTP_CLK_REQ_EXTTS;
 		enable = req.extts.flags & PTP_ENABLE_FEATURE ? 1 : 0;
+		if (mutex_lock_interruptible(&ptp->pincfg_mux))
+			return -ERESTARTSYS;
 		err = ops->enable(ops, &req, enable);
+		mutex_unlock(&ptp->pincfg_mux);
 		break;
 
 	case PTP_PEROUT_REQUEST:
@@ -206,7 +209,10 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		}
 		req.type = PTP_CLK_REQ_PEROUT;
 		enable = req.perout.period.sec || req.perout.period.nsec;
+		if (mutex_lock_interruptible(&ptp->pincfg_mux))
+			return -ERESTARTSYS;
 		err = ops->enable(ops, &req, enable);
+		mutex_unlock(&ptp->pincfg_mux);
 		break;
 
 	case PTP_ENABLE_PPS:
@@ -217,7 +223,10 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 			return -EPERM;
 		req.type = PTP_CLK_REQ_PPS;
 		enable = arg ? 1 : 0;
+		if (mutex_lock_interruptible(&ptp->pincfg_mux))
+			return -ERESTARTSYS;
 		err = ops->enable(ops, &req, enable);
+		mutex_unlock(&ptp->pincfg_mux);
 		break;
 
 	case PTP_SYS_OFFSET_PRECISE:
diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index ac1f2bf9e888..acabbe72e55e 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -348,7 +348,6 @@ int ptp_find_pin(struct ptp_clock *ptp,
 	struct ptp_pin_desc *pin = NULL;
 	int i;
 
-	mutex_lock(&ptp->pincfg_mux);
 	for (i = 0; i < ptp->info->n_pins; i++) {
 		if (ptp->info->pin_config[i].func == func &&
 		    ptp->info->pin_config[i].chan == chan) {
@@ -356,12 +355,26 @@ int ptp_find_pin(struct ptp_clock *ptp,
 			break;
 		}
 	}
-	mutex_unlock(&ptp->pincfg_mux);
 
 	return pin ? i : -1;
 }
 EXPORT_SYMBOL(ptp_find_pin);
 
+int ptp_find_pin_unlocked(struct ptp_clock *ptp,
+			  enum ptp_pin_function func, unsigned int chan)
+{
+	int result;
+
+	mutex_lock(&ptp->pincfg_mux);
+
+	result = ptp_find_pin(ptp, func, chan);
+
+	mutex_unlock(&ptp->pincfg_mux);
+
+	return result;
+}
+EXPORT_SYMBOL(ptp_find_pin_unlocked);
+
 int ptp_schedule_worker(struct ptp_clock *ptp, unsigned long delay)
 {
 	return kthread_mod_delayed_work(ptp->kworker, &ptp->aux_work, delay);
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index c64a1ef87240..121a7eda4593 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -223,6 +223,12 @@ extern s32 scaled_ppm_to_ppb(long ppm);
 /**
  * ptp_find_pin() - obtain the pin index of a given auxiliary function
  *
+ * The caller must hold ptp_clock::pincfg_mux.  Drivers do not have
+ * access to that mutex as ptp_clock is an opaque type.  However, the
+ * core code acquires the mutex before invoking the driver's
+ * ptp_clock_info::enable() callback, and so drivers may call this
+ * function from that context.
+ *
  * @ptp:    The clock obtained from ptp_clock_register().
  * @func:   One of the ptp_pin_function enumerated values.
  * @chan:   The particular functional channel to find.
@@ -233,6 +239,19 @@ extern s32 scaled_ppm_to_ppb(long ppm);
 int ptp_find_pin(struct ptp_clock *ptp,
 		 enum ptp_pin_function func, unsigned int chan);
 
+/**
+ * ptp_find_pin_unlocked() - wrapper for ptp_find_pin()
+ *
+ * This function acquires the ptp_clock::pincfg_mux mutex before
+ * invoking ptp_find_pin().  Instead of using this function, drivers
+ * should most likely call ptp_find_pin() directly from their
+ * ptp_clock_info::enable() method.
+ *
+ */
+
+int ptp_find_pin_unlocked(struct ptp_clock *ptp,
+			  enum ptp_pin_function func, unsigned int chan);
+
 /**
  * ptp_schedule_worker() - schedule ptp auxiliary work
  *
-- 
2.20.1

