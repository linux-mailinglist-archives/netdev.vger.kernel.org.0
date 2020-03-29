Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8897C196A85
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 03:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgC2Bfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 21:35:36 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33208 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727718AbgC2Bfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 21:35:36 -0400
Received: by mail-pf1-f196.google.com with SMTP id j1so6710733pfe.0
        for <netdev@vger.kernel.org>; Sat, 28 Mar 2020 18:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kd/CEQbRmLQTVs6OYQN8+CtL+6XVbUHR7Fagytwgcd8=;
        b=KxzlK1OCtH3ggOSMWV7crLi6hN2qTWBqI1e8LwEl1TRO0w5ab0wyVxbEh0ezKLwhsT
         KSOJu9B0tgOQ1xnoceV9HNpul5VPjo5/OLaicq0aWrbMtY3U8nEcRIQcD9PfHvrc5sOT
         1qMliXdw4b3PEC0oVFJgTB8oOsY36Daf6gD0jBZ1VKV8W/4kd4XXZl2wqM3fIZQees5P
         viqvKuhDOh+klsPY7uW+wLsRw7EYTV7q2EB6RV483WCM7ddWRIKVnscf7zKv4Nu/tMUP
         OGKZb4L+8o7fsceLDFv2bK16kAgFqgEhcYPCKZnyXl8QaNFElKEfc9OF0fQAxXVgZRER
         +EYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kd/CEQbRmLQTVs6OYQN8+CtL+6XVbUHR7Fagytwgcd8=;
        b=cUIsgggTGP+7bHf6ylB//oJlW713PfF5t23tMwWH2GMyxIzZ+7cDnzHSVNuXBUmqRw
         fTecsk7O+ftuH0x/Xrg9jJPlMLrHf1toto7I5PAr14rXlviWSlSiLB/qSsb6unZIIlTy
         470C8Fs/0/j6z500U6Tcgv9OBWZUuVZAKSH/L3fLtnUv6PQ/6KmVeLp8APsw2rdlvpfQ
         ukpQEkhQf6L+ANCRDAyxcHqdSfHYKe4fEXjiqulA8/03C7naCrDNCc4Wo3e3UseHSm6L
         L2RMdJQsQGI0yujmrmWCokqx6PuHJuhk7+QosfuqLqe+f6iQnCq90Nq3zSJK8+BJhh3t
         YkwA==
X-Gm-Message-State: ANhLgQ3+j33xid8PUKf6th0POWkTPf/cjEHg6jR1ljoFBjgEmTNKFZCi
        5DVfPSgqZJJpxvRjsB9TnnvnqT0D
X-Google-Smtp-Source: ADFU+vsqLo4ZGqYvwHnRUUSvnl3du7KvppCieuro+Md71AE8PIML3YT0S6IglkZWkZHLY0GAyP1o3A==
X-Received: by 2002:aa7:9888:: with SMTP id r8mr6554538pfl.293.1585445733072;
        Sat, 28 Mar 2020 18:35:33 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id z37sm6627321pgl.68.2020.03.28.18.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2020 18:35:32 -0700 (PDT)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH net-next 1/1] ptp: Avoid deadlocks in the programmable pin code.
Date:   Sat, 28 Mar 2020 18:35:30 -0700
Message-Id: <2f3ba828505cb3e8f9dc8a7b6c5a58a51a80cd90.1585445576.git.richardcochran@gmail.com>
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
index c64a1ef87240..114807e7abdd 100644
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
+ * This function aquires the ptp_clock::pincfg_mux mutex before
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

