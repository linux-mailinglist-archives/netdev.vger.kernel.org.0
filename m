Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF6294BBA
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 19:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbfHSR26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 13:28:58 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34042 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbfHSR2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 13:28:44 -0400
Received: by mail-wm1-f66.google.com with SMTP id e8so511712wme.1;
        Mon, 19 Aug 2019 10:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N4+pf5d7pVmnBlivGuHqKTTW2Rfxav1QD4GVn+SGku8=;
        b=rB+i0qylgMJQS7W6tIapfGXnwknLUgZSuLbNMFUO5e0mY9mi6LehXLYeQ7C3mPriH4
         whXcuu7eAGt49zKShHlAgvFJ1XRBIiVz0kt46A8CXx2vZGTvbHHlfBIqPaPL65RQIyVR
         oSQhSq1QYb+sCIQht0/6YvF8jFqusSUf9CqGKcmpJkxzuznHJXTz8vKfK93dXq9wtSFa
         Tla2r5lNdRX9kqJRK8yFbc5WuRQws497J6xZM5QSCo0x61ZY93qkbiUhDOT6IEyeTweh
         iqFU76VYUaFuhL0tvdGfV6qUh4yuMGiYUcYlgCLseza4NiVq/5mIVi/b15a8oqx/CQiG
         5ygw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N4+pf5d7pVmnBlivGuHqKTTW2Rfxav1QD4GVn+SGku8=;
        b=WmSc7QzqcD9mFCqcmUmhXLYA9ZY9jFrMq+55iRUUGM4Jj6NJHtXaHLYFL2qSvnVz26
         ElhXa99gEBVGQDc6xD/j5ZKTsHybNQZpwojyyMbXT8xG7Wtrnr30oR78UWDYVuQnYhoL
         ILvFiz73gE9DmBlfhPxzD75ZI2K5GY/0d12Nf5j15pkI6oITTDYQpt9NgXaOKsB9NAPL
         o6wIkTbSlqLO5ZcN4w6oKYrFjiqIp9vkaVaz5/VexIHZF8xmSKPPH4UPDsQTPg4lxUga
         1i+kvh7D4jR7+rziuwmU3hIOsgwW2PF9tkgeJ0ScIQXviVPe6s8ROAxNjIDpEoCTDUa7
         IkCw==
X-Gm-Message-State: APjAAAWP6SH6GmTp27k9I0Zafz1aJlHO5d/26lcjTqAOJSaneFp3Qv/n
        glYTy65kl+mmgJqd3vVk67kgurMqhzs=
X-Google-Smtp-Source: APXvYqy73eiSXTGbmsnpMG7uHCQEtftllyD/DExkUuGM5RhQ4eFmkuRfv24N/mORrnN11uzM7J/z+A==
X-Received: by 2002:a1c:9ec5:: with SMTP id h188mr21805675wme.176.1566235722008;
        Mon, 19 Aug 2019 10:28:42 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id c15sm41983879wrb.80.2019.08.19.10.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 10:28:41 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
X-Google-Original-From: Hubert Feurstein <hubert.feurstein@vahle.at>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next v2 3/4] net: dsa: mv88e6xxx: extend PTP gettime function to read system clock
Date:   Mon, 19 Aug 2019 19:28:26 +0200
Message-Id: <20190819172827.9550-4-hubert.feurstein@vahle.at>
X-Mailer: git-send-email 2.22.1
In-Reply-To: <20190819172827.9550-1-hubert.feurstein@vahle.at>
References: <20190819172827.9550-1-hubert.feurstein@vahle.at>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hubert Feurstein <h.feurstein@gmail.com>

This adds support for the PTP_SYS_OFFSET_EXTENDED ioctl.

Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.h |  2 ++
 drivers/net/dsa/mv88e6xxx/ptp.c  | 11 +++++++----
 drivers/net/dsa/mv88e6xxx/smi.c  |  3 ++-
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index a406be2f5652..1bfde0d8a5a3 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -275,6 +275,8 @@ struct mv88e6xxx_chip {
 	struct ptp_clock_info	ptp_clock_info;
 	struct delayed_work	tai_event_work;
 	struct ptp_pin_desc	pin_config[MV88E6XXX_MAX_GPIO];
+	struct ptp_system_timestamp *ptp_sts;
+
 	u16 trig_config;
 	u16 evcap_config;
 	u16 enable_count;
diff --git a/drivers/net/dsa/mv88e6xxx/ptp.c b/drivers/net/dsa/mv88e6xxx/ptp.c
index 073cbd0bb91b..cf6e52ee9e0a 100644
--- a/drivers/net/dsa/mv88e6xxx/ptp.c
+++ b/drivers/net/dsa/mv88e6xxx/ptp.c
@@ -235,14 +235,17 @@ static int mv88e6xxx_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	return 0;
 }
 
-static int mv88e6xxx_ptp_gettime(struct ptp_clock_info *ptp,
-				 struct timespec64 *ts)
+static int mv88e6xxx_ptp_gettimex(struct ptp_clock_info *ptp,
+				  struct timespec64 *ts,
+				  struct ptp_system_timestamp *sts)
 {
 	struct mv88e6xxx_chip *chip = ptp_to_chip(ptp);
 	u64 ns;
 
 	mv88e6xxx_reg_lock(chip);
+	chip->ptp_sts = sts;
 	ns = timecounter_read(&chip->tstamp_tc);
+	chip->ptp_sts = NULL;
 	mv88e6xxx_reg_unlock(chip);
 
 	*ts = ns_to_timespec64(ns);
@@ -426,7 +429,7 @@ static void mv88e6xxx_ptp_overflow_check(struct work_struct *work)
 	struct mv88e6xxx_chip *chip = dw_overflow_to_chip(dw);
 	struct timespec64 ts;
 
-	mv88e6xxx_ptp_gettime(&chip->ptp_clock_info, &ts);
+	mv88e6xxx_ptp_gettimex(&chip->ptp_clock_info, &ts, NULL);
 
 	schedule_delayed_work(&chip->overflow_work,
 			      MV88E6XXX_TAI_OVERFLOW_PERIOD);
@@ -472,7 +475,7 @@ int mv88e6xxx_ptp_setup(struct mv88e6xxx_chip *chip)
 	chip->ptp_clock_info.max_adj    = MV88E6XXX_MAX_ADJ_PPB;
 	chip->ptp_clock_info.adjfine	= mv88e6xxx_ptp_adjfine;
 	chip->ptp_clock_info.adjtime	= mv88e6xxx_ptp_adjtime;
-	chip->ptp_clock_info.gettime64	= mv88e6xxx_ptp_gettime;
+	chip->ptp_clock_info.gettimex64	= mv88e6xxx_ptp_gettimex;
 	chip->ptp_clock_info.settime64	= mv88e6xxx_ptp_settime;
 	chip->ptp_clock_info.enable	= ptp_ops->ptp_enable;
 	chip->ptp_clock_info.verify	= ptp_ops->ptp_verify;
diff --git a/drivers/net/dsa/mv88e6xxx/smi.c b/drivers/net/dsa/mv88e6xxx/smi.c
index 282fe08db050..abedd04ff2ae 100644
--- a/drivers/net/dsa/mv88e6xxx/smi.c
+++ b/drivers/net/dsa/mv88e6xxx/smi.c
@@ -45,7 +45,8 @@ static int mv88e6xxx_smi_direct_write(struct mv88e6xxx_chip *chip,
 {
 	int ret;
 
-	ret = mdiobus_write_nested(chip->bus, dev, reg, data);
+	ret = mdiobus_write_sts_nested(chip->bus, dev, reg, data,
+				       chip->ptp_sts);
 	if (ret < 0)
 		return ret;
 
-- 
2.22.1

