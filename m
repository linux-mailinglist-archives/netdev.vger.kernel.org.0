Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69973D7C6A
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 19:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbhG0Rnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 13:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbhG0Rnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 13:43:45 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1805BC061757
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 10:43:45 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id i1so16605596plr.9
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 10:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lAgM0C3Ib8PZKXvR7JBagHFKelvNn/rbZOCkYbxtxKg=;
        b=u1hvwEKPLyxLCVGlsaZXDUYrq+mh4FSwTM7FwhkMK5/Rk7z2rHGh2a38TiXUTmqonE
         GZKYag450H5574uOCQ5qLgps6giJ42T/MN+bwg19HfN/jMIsOIoOa6Ts/DhzUCslH3o0
         fxydd2PHm2ElsT92wsJe89DYsHtl7XF+F4XmUS358tO2MvqRiVXVE9IjzQpoAFDsBCY5
         Tm4sTK/FvblqmS1wOnmFjPDejwEaZPDSmqcAs3hiBCqoy1CiM7iw9RjsKbb33j24OkPK
         IUKcIjoH3fmqEf/LREGMy0xy5Pr/cATk0Fic15hCw3VEbabEhAarIyRJV4McAyVDqBqf
         nZJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lAgM0C3Ib8PZKXvR7JBagHFKelvNn/rbZOCkYbxtxKg=;
        b=l5FPWIw5i6HFBwPPOzTh/jRaXac46FuhBucBq1LqBA2bq/pifQQbaQ5FL1173ge1r5
         iZXGT/4bLmpRvjaiThCnjIlU2I1JeWWWP+77H9l6LFTqE5D4AwR+Pc78ZY66ELxsEiwX
         FWnli06tXHPGazlb6CHS30l/C8ImjxKupFGrI8ex2Op4tNmW4BRDvP0XtiC27VghYJ9c
         JiDuwCqcHWx597iIEDv+0iaVhgj3FbyYyJGSduZSdTFz8qX+RsBEpkf+Zlb6u01QO2Wj
         0lZvMXK2176+E8mh3lP9l0dHvvRYs6tK8/l6EkvAnjEVpnKDpjz2sa7UHsLbhJcM1fgN
         W3RA==
X-Gm-Message-State: AOAM533lCX985d/0uWdE3DIHGzUVle+UybKgpMM4+A5Q4Jh+TStdo1f0
        iYadeI7Ox7o1v9q56ou4TLlwxA==
X-Google-Smtp-Source: ABdhPJwWaaR7/qa0PuApLxNI2FPGb8/zLIOJkPWbAG3Y2/uEo6D+nUIkoBC0UaWk6NV99dVdTCt/fw==
X-Received: by 2002:a65:645a:: with SMTP id s26mr516724pgv.270.1627407824453;
        Tue, 27 Jul 2021 10:43:44 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id t9sm4671944pgc.81.2021.07.27.10.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 10:43:44 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 02/10] ionic: monitor fw status generation
Date:   Tue, 27 Jul 2021 10:43:26 -0700
Message-Id: <20210727174334.67931-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727174334.67931-1-snelson@pensando.io>
References: <20210727174334.67931-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The top 4 bits of the fw_status in dev_info_regs is reserved
for the status generation.  This generation number is an
arbitrary value defined when firmware starts up.  If the FW
is killed/crashed/stopped and then restarted, it will create
a different generation number.  With this mechanism, the host
driver can detect that the FW has crashed and restarted, and
the driver can then take steps to re-initialize its connection.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_dev.c   | 28 +++++++++++++++++--
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  1 +
 .../net/ethernet/pensando/ionic/ionic_if.h    |  5 +++-
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 1dfe962e22e0..9aac647290f7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -106,6 +106,8 @@ int ionic_dev_setup(struct ionic *ionic)
 	idev->last_fw_hb = 0;
 	idev->fw_hb_ready = true;
 	idev->fw_status_ready = true;
+	idev->fw_generation = IONIC_FW_STS_F_GENERATION &
+			      ioread8(&idev->dev_info_regs->fw_status);
 
 	mod_timer(&ionic->watchdog_timer,
 		  round_jiffies(jiffies + ionic->watchdog_period));
@@ -121,7 +123,9 @@ int ionic_heartbeat_check(struct ionic *ionic)
 {
 	struct ionic_dev *idev = &ionic->idev;
 	unsigned long check_time, last_check_time;
-	bool fw_status_ready, fw_hb_ready;
+	bool fw_status_ready = true;
+	bool fw_hb_ready;
+	u8 fw_generation;
 	u8 fw_status;
 	u32 fw_hb;
 
@@ -140,9 +144,29 @@ int ionic_heartbeat_check(struct ionic *ionic)
 
 	/* firmware is useful only if the running bit is set and
 	 * fw_status != 0xff (bad PCI read)
+	 * If fw_status is not ready don't bother with the generation.
 	 */
 	fw_status = ioread8(&idev->dev_info_regs->fw_status);
-	fw_status_ready = (fw_status != 0xff) && (fw_status & IONIC_FW_STS_F_RUNNING);
+
+	if (fw_status == 0xff || !(fw_status & IONIC_FW_STS_F_RUNNING)) {
+		fw_status_ready = false;
+	} else {
+		fw_generation = fw_status & IONIC_FW_STS_F_GENERATION;
+		if (idev->fw_generation != fw_generation) {
+			dev_info(ionic->dev, "FW generation 0x%02x -> 0x%02x\n",
+				 idev->fw_generation, fw_generation);
+
+			idev->fw_generation = fw_generation;
+
+			/* If the generation changed, the fw status is not
+			 * ready so we need to trigger a fw-down cycle.  After
+			 * the down, the next watchdog will see the fw is up
+			 * and the generation value stable, so will trigger
+			 * the fw-up activity.
+			 */
+			fw_status_ready = false;
+		}
+	}
 
 	/* is this a transition? */
 	if (fw_status_ready != idev->fw_status_ready) {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index c25cf9b744c5..8945aeda1b4c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -143,6 +143,7 @@ struct ionic_dev {
 	u32 last_fw_hb;
 	bool fw_hb_ready;
 	bool fw_status_ready;
+	u8 fw_generation;
 
 	u64 __iomem *db_pages;
 	dma_addr_t phy_db_pages;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index 0478b48d9895..278610ed7227 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -2936,6 +2936,8 @@ struct ionic_hwstamp_regs {
  * @asic_type:       Asic type
  * @asic_rev:        Asic revision
  * @fw_status:       Firmware status
+ *			bit 0   - 1 = fw running
+ *			bit 4-7 - 4 bit generation number, changes on fw restart
  * @fw_heartbeat:    Firmware heartbeat counter
  * @serial_num:      Serial number
  * @fw_version:      Firmware version
@@ -2949,7 +2951,8 @@ union ionic_dev_info_regs {
 		u8     version;
 		u8     asic_type;
 		u8     asic_rev;
-#define IONIC_FW_STS_F_RUNNING	0x1
+#define IONIC_FW_STS_F_RUNNING		0x01
+#define IONIC_FW_STS_F_GENERATION	0xF0
 		u8     fw_status;
 		u32    fw_heartbeat;
 		char   fw_version[IONIC_DEVINFO_FWVERS_BUFLEN];
-- 
2.17.1

