Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12FC295A2C
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 10:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729555AbfHTItD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 04:49:03 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40593 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729449AbfHTItC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 04:49:02 -0400
Received: by mail-wr1-f65.google.com with SMTP id c3so11497774wrd.7;
        Tue, 20 Aug 2019 01:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FKNrrF2xd/dx0ZsLLj4swvq6lspHhHmUFsye77oNcos=;
        b=BwZXmFPPq1Wrdn30TfGjCW+pZO0jMo5o2/+83297r1e7EizxuKfHknnyfqRB9q7ysC
         s1Nqa5GEbqJIuVTAQq6fyTz+wSPPBlmCvmzFDpfoKcOaZBqYa9cDf3ClXUY8CCY3+p1v
         Fz7IDZ6+L895F+ICBw3pNzR8zOFs7YPOkabgQJKJ4+YYSKgllqmHioyYPImGrMwG8WaZ
         TN/qH8jGKRMyG0avj8sKIWfO9dUHk92e0AmdioDwNMDrCA6HcKhIfT9Q3tEjoLhGCZBG
         yzuMmXMMMBVw78LNSyqRfAmP/aTpSVrpsKsKXxC4yDvIesxOCqghIpPmZ07cjkQaS1iL
         ijZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FKNrrF2xd/dx0ZsLLj4swvq6lspHhHmUFsye77oNcos=;
        b=T0myvxQBH12jcQt6FOr6GLGVmhdq2Fyte1FSfH3Nbq4XJbgf6kJzSq5HJFFjRv7Sh4
         6YJoQNa+QQiQJp761eAxOqr039bzMBnV0KONaq/8qtTo1xaQjsJlsAuC4Y2UF5utJEtk
         7XtP9SbnqXkWJeCEWWdY3hsgD/2rTjWCAg1KPYm6YxtCkViG3f/Hq2dCeljGCtZU9Htg
         UVTSz4WAL0CrcDKjYcglDTxYoKMKlhOmH0jNyIXKEB2GFPW+X0clVSV0ZKr2MaFT0BrP
         HDqv+FP4/2wIlavjfkl0hspn5o+6WV2KKryp845DaUYCeO7Gt5HmwMHoqV7NhrJiLpzi
         Ufcw==
X-Gm-Message-State: APjAAAVicUat6fKmxiZgVts41tl9hUYAYZT6PQXKAgZYGMh7Uh6jQpHq
        9G/wWCeiwajuOUpyZo4vBElCpwt8bXA=
X-Google-Smtp-Source: APXvYqwMRT0RtALgiYWbr/Z8mQTBee/4TnFeIXe+ZNdw3o2RLFDwI1gOyExtyBq+G2wcULEb57mxog==
X-Received: by 2002:adf:f7cd:: with SMTP id a13mr32662955wrq.165.1566290939322;
        Tue, 20 Aug 2019 01:48:59 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id s64sm36437105wmf.16.2019.08.20.01.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 01:48:58 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
X-Google-Original-From: Hubert Feurstein <hubert.feurstein@vahle.at>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next v3 3/4] net: dsa: mv88e6xxx: extend PTP gettime function to read system clock
Date:   Tue, 20 Aug 2019 10:48:32 +0200
Message-Id: <20190820084833.6019-4-hubert.feurstein@vahle.at>
X-Mailer: git-send-email 2.22.1
In-Reply-To: <20190820084833.6019-1-hubert.feurstein@vahle.at>
References: <20190820084833.6019-1-hubert.feurstein@vahle.at>
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
Changes in v3:
 - mv88e6xxx_smi_indirect_write: forward ptp_sts only on the last write
 
 drivers/net/dsa/mv88e6xxx/chip.h |  2 ++
 drivers/net/dsa/mv88e6xxx/ptp.c  | 11 +++++++----
 drivers/net/dsa/mv88e6xxx/smi.c  |  7 ++++++-
 3 files changed, 15 insertions(+), 5 deletions(-)

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
index 282fe08db050..1b5f78662158 100644
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
 
@@ -130,6 +131,7 @@ static int mv88e6xxx_smi_indirect_read(struct mv88e6xxx_chip *chip,
 static int mv88e6xxx_smi_indirect_write(struct mv88e6xxx_chip *chip,
 					int dev, int reg, u16 data)
 {
+	struct ptp_system_timestamp *ptp_sts = chip->ptp_sts;
 	int err;
 
 	err = mv88e6xxx_smi_direct_wait(chip, chip->sw_addr,
@@ -137,11 +139,14 @@ static int mv88e6xxx_smi_indirect_write(struct mv88e6xxx_chip *chip,
 	if (err)
 		return err;
 
+	chip->ptp_sts = NULL;
 	err = mv88e6xxx_smi_direct_write(chip, chip->sw_addr,
 					 MV88E6XXX_SMI_DATA, data);
 	if (err)
 		return err;
 
+	/* Capture the PTP system timestamps only on *this* write operation */
+	chip->ptp_sts = ptp_sts;
 	err = mv88e6xxx_smi_direct_write(chip, chip->sw_addr,
 					 MV88E6XXX_SMI_CMD,
 					 MV88E6XXX_SMI_CMD_BUSY |
-- 
2.22.1

