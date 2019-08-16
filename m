Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0BA1905E5
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 18:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbfHPQc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 12:32:29 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46357 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbfHPQc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 12:32:28 -0400
Received: by mail-wr1-f66.google.com with SMTP id z1so2085812wru.13;
        Fri, 16 Aug 2019 09:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=24BWbn8DqPjln73B50K/6VPAlju0pIkRFKeVKAz9CKM=;
        b=vX4d2umdOGrV+OmmupQOlzqpgTb/UHWiJKunbrTiNhBOHM6lFZ2jaMlbj1NKwWp+m8
         cry1XXFBFJjwbOXKUrypnt/Zy5WAKLTGZ9+TLaIXpAfwfg+geIhtG3KryqoQwo+AY9KK
         iQdgkvJhsPM6harsWshTu6sbR5Nm7pyuDvAZZmPvAoM1mw/sz4/a6sZSwZkd809GXwVt
         ePfr44VXjy5ycW3Z5Z8kcvZuOAyYNnW+lo24C2SA0PN8q6YOyto0sw5QixQyjNTo4Kse
         Q6TGCHs/EwTGmVNI5J0AOwFIEtxi6S/ht98XnMYVnf7h6SeaC5yZKkA+L5kFT3W0K7N9
         za1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=24BWbn8DqPjln73B50K/6VPAlju0pIkRFKeVKAz9CKM=;
        b=IHgXLOhEi86hA1moIrh8ZUJpJdO6ySEX94u8sriVhYHHwb+L3BCHqueJu0UbPVLsYm
         yLEx6/gbOSgeFsLYL56mmtt8FSg4v0KxkmIwh44ouvO+vpmGjElMGgcbxcQDyQHW7y7d
         OBxHZ/04pBw1ImVLrwejeYP2j6qAJi/oPZncx5MAHqgoFPt3qIrJNIc/oKL3V56gg9Ie
         2BRU/ey3wdJrwhMZvgBEi4pcN1/xYNmlWcxfnga4b/r3O7EmbF3/Wn4Aoq4GlWDP/vqv
         l6HZfUBXzB3NcPdP97cdQutWw0a74u2+GH7s4DVrB0dZuVhnIzVca2QnSkrbvGeemZx7
         0cxg==
X-Gm-Message-State: APjAAAUJuZ/7hjQk3qwoX8A8QEOi+jIZXAoz/3PxUypPnY8Mj2T7qvdb
        5y9YDXsrBupQz8A6EoQmqwOoS3qhZQs=
X-Google-Smtp-Source: APXvYqyF/WQJqju4c0BbRz7Oc6baEAm8/T/BnWv6LMWFDBcCxHMPKF/PN/5WdZWAJ5U0DCodASFqnQ==
X-Received: by 2002:a5d:5591:: with SMTP id i17mr12014753wrv.280.1565973145937;
        Fri, 16 Aug 2019 09:32:25 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id d19sm11031677wrb.7.2019.08.16.09.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 09:32:25 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next 2/3] net: dsa: mv88e6xxx: extend PTP gettime function to read system clock
Date:   Fri, 16 Aug 2019 18:31:56 +0200
Message-Id: <20190816163157.25314-3-h.feurstein@gmail.com>
X-Mailer: git-send-email 2.22.1
In-Reply-To: <20190816163157.25314-1-h.feurstein@gmail.com>
References: <20190816163157.25314-1-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for the PTP_SYS_OFFSET_EXTENDED ioctl.

Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.h |  2 ++
 drivers/net/dsa/mv88e6xxx/ptp.c  | 11 +++++++----
 drivers/net/dsa/mv88e6xxx/smi.c  |  3 ++-
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 01963ee94c50..9e14dc406415 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -277,6 +277,8 @@ struct mv88e6xxx_chip {
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
index 5fc78a063843..e3b0096a9d94 100644
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

