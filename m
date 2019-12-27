Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC87412B0A9
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 03:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbfL0CiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 21:38:12 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40116 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbfL0CiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 21:38:12 -0500
Received: by mail-wr1-f67.google.com with SMTP id c14so24962050wrn.7
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 18:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yhXVt0sep+u2qUcFNbPBuHMjtSW7sIjKtaxfP9ekmAg=;
        b=crA2cNqPxtuMNHjhZ+QT04NwV/GzsxepPkzbjeYRvoO48laXZL45eMZpzVWXsCVeNc
         iLzEehmQ1qZCH2Q6/9FQgQYNGPKdCT2V5PeuKW9n60xBpH1RaixiSi6njkVplIcaHyTf
         SFFRpsjV8ejaVmwPYM133xpOkTKggwArnDhXExXIOPJxTItLJibSr6CqZjyLEDZJUud7
         W884Usw/xm3NOMYaAJYld4KSk/whXRh2XtRchKgpuwkIPHEGKXlKW4Mxg6UDILOcf3QR
         cx3S5fBzdvG6saG4cwe38t9Nppt9SxOF/IwW//5BuE6/dWcqDfEY9bd/G+e/ZHS35Iz9
         kmog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yhXVt0sep+u2qUcFNbPBuHMjtSW7sIjKtaxfP9ekmAg=;
        b=P+f8ZFBtgY4dfWRV/+9pePVgMszlei8AZWL/v7/Cdc6LfpKe6RRydHHjhg9IJ/MyOo
         RwkAJd/pctFtPlMnq4lMsixJqsKCQsX2njrQYGrZ/wzhjIsALEJPGqqcPUQWhBWvtVzI
         XuPEqw34gZGdixBElgviDphaoOdrSd5MzByjP2WFIRs9d7ZcRtZ05RDsSTkQmEuK0EuZ
         4Eyk38YLOffqf1i6cQ/GuRdgpUDM0pRZVT9SxhnjdCs+8TwiiE7S3RCpQB1gkJsbSkXG
         GaPVwECbIW5flNYxsoS0fy7DmrzWUuUHCc5Bme6YFqJliJYiYGe90HbIcSj8rj5kE7gU
         XNtw==
X-Gm-Message-State: APjAAAWfQes+uw/D8W6I8mi/ZTh1luvtMDC25YvlysOxlTDPGyht7iKQ
        1APAMRvK5Z4bV/0ACsyDZFpz31s/
X-Google-Smtp-Source: APXvYqx6/sRj5OpQjDQEi0z5Y9+pkI0t01YxOHc9Af0aMXp6peIJa/YRIVi/Gl8c1fQkh8RcNAYhfA==
X-Received: by 2002:a5d:46c1:: with SMTP id g1mr46947712wrs.200.1577414289873;
        Thu, 26 Dec 2019 18:38:09 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id k7sm9718714wmi.19.2019.12.26.18.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 18:38:09 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     richardcochran@gmail.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 1/3] ptp: introduce ptp_cancel_worker_sync
Date:   Fri, 27 Dec 2019 04:37:48 +0200
Message-Id: <20191227023750.12559-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191227023750.12559-1-olteanv@gmail.com>
References: <20191227023750.12559-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to effectively use the PTP kernel thread for tasks such as
timestamping packets, allow the user control over stopping it, which is
needed e.g. when the timestamping queues must be drained.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/ptp/ptp_clock.c          | 6 ++++++
 include/linux/ptp_clock_kernel.h | 7 +++++++
 2 files changed, 13 insertions(+)

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
index 93cc4f1d444a..083e32a5e456 100644
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
-- 
2.17.1

