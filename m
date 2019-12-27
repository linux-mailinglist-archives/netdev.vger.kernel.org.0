Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54D8C12B4B7
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 14:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbfL0NCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 08:02:40 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36414 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfL0NCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 08:02:39 -0500
Received: by mail-wm1-f67.google.com with SMTP id p17so8230179wma.1
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 05:02:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DVlVR0bvf4rc4hcVIRY+U0ombLfRrGnZPhbiDfWcedg=;
        b=oTgLhpSQavmYTdw5xWC+cIKtH2PRADmY9GDpEvcUoFp3mfHV/QWePfLCybF5Bzw208
         fJGAsGnRfxkjTelTgGbF0P8McKYCSbsiMceii18xnK0fqM3HRmucL+Wm88obe33Zb/67
         vorezHhqklJRarKGtzAwWtSJRwaWg+ragWurnEPUcrsiNS9y3Pud/lwSIeV2nbn4b3uB
         iw+6Ba409NdHjMD0oJKuGy3U5N/ixiIFmMnnWPKuZsqHx2tUVZDcHaLkXBdxp4z53U95
         46AAGYVN4uAHoNkyFLXv9u5DhqVHCO1CME7T1hWZ+qFrlORGQoIPo/DxeuoOrO7wKLU9
         3rAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DVlVR0bvf4rc4hcVIRY+U0ombLfRrGnZPhbiDfWcedg=;
        b=F5R1aGUiS3KpO/Uzg7yHPA2ODwfbH9M8Xm+5XVxer+wXR0xo13y/sA/lZuhZpg1tHo
         eUy/0FiQwRvqw72RM6F/vnN/SOt5kPh3F6D7u9+0ogFGso9NnAVCDdfVzvYJeHmi+r/6
         fWM448780iqkpazvl42LnCDIkOIbwJwpRL3qIGC/qU2guJUYVQX6sexhZi/MXj5S5LiM
         VzCP7bX1Q35yKxYnYl/RSEtqVz55stk6e3ysFg5d8aUjCZNmJM5ssFnnAduVF8gWBdt/
         we6XWdtYAUyHaIKUwvdhqWzEY8x+Sk8E+T+OMYipw7JBLHXsfexltqOkcsHuE4/eYSB4
         rq8w==
X-Gm-Message-State: APjAAAXNtyQrodaipW1zSiw30MDtrsJDQX2icpDlRys1+KZ/Wv4eBOOj
        UgUGsA/3LwOV0RR1PsAAL0Q=
X-Google-Smtp-Source: APXvYqz508snkrNnQ4VYLSd2DQg3QM3VAzVklVi+LxRWqLwumYjngBaqNXGts1bB1AALiHe6oev8Sg==
X-Received: by 2002:a7b:cd0a:: with SMTP id f10mr19970290wmj.56.1577451758001;
        Fri, 27 Dec 2019 05:02:38 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id i5sm34307357wrv.34.2019.12.27.05.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2019 05:02:37 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     richardcochran@gmail.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 1/3] ptp: introduce ptp_cancel_worker_sync
Date:   Fri, 27 Dec 2019 15:02:28 +0200
Message-Id: <20191227130230.21541-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191227130230.21541-1-olteanv@gmail.com>
References: <20191227130230.21541-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to effectively use the PTP kernel thread for tasks such as
timestamping packets, allow the user control over stopping it, which is
needed e.g. when the timestamping queues must be drained.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v2:
- Added stub for the case where CONFIG_PTP_1588_CLOCK=n

 drivers/ptp/ptp_clock.c          | 6 ++++++
 include/linux/ptp_clock_kernel.h | 9 +++++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index e60eab7f8a61..4f0d91a76dcb 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -371,6 +371,12 @@ int ptp_schedule_worker(struct ptp_clock *ptp, unsigned long delay)
 }
 EXPORT_SYMBOL(ptp_schedule_worker);
 
+void ptp_cancel_worker_sync(struct ptp_clock *ptp)
+{
+	kthread_cancel_delayed_work_sync(&ptp->aux_work);
+}
+EXPORT_SYMBOL(ptp_cancel_worker_sync);
+
 /* module operations */
 
 static void __exit ptp_exit(void)
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index 93cc4f1d444a..c64a1ef87240 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -243,6 +243,13 @@ int ptp_find_pin(struct ptp_clock *ptp,
 
 int ptp_schedule_worker(struct ptp_clock *ptp, unsigned long delay);
 
+/**
+ * ptp_cancel_worker_sync() - cancel ptp auxiliary clock
+ *
+ * @ptp:     The clock obtained from ptp_clock_register().
+ */
+void ptp_cancel_worker_sync(struct ptp_clock *ptp);
+
 #else
 static inline struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 						   struct device *parent)
@@ -260,6 +267,8 @@ static inline int ptp_find_pin(struct ptp_clock *ptp,
 static inline int ptp_schedule_worker(struct ptp_clock *ptp,
 				      unsigned long delay)
 { return -EOPNOTSUPP; }
+static inline void ptp_cancel_worker_sync(struct ptp_clock *ptp)
+{ }
 
 #endif
 
-- 
2.17.1

