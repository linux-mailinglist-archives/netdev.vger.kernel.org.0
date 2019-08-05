Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD9EB81425
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 10:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbfHEI1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 04:27:12 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39668 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfHEI1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 04:27:12 -0400
Received: by mail-wr1-f66.google.com with SMTP id x4so30283864wrt.6;
        Mon, 05 Aug 2019 01:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rictj+Qm0LQXHqbH3hWSwYOizIiK+569WyJPDSyU/rM=;
        b=TEzxLHotZ82D7MoMvuzxjcA7V/ypQNIEGXEpcjDgnhivRGAZWKNeU/ZSSg5e+FVpjF
         //f86yV6Q8sV795KeRHK0ntbgbuq0TNP1Ln2bEt1E71EuGXu+8+8EKEWZzPVBwrVPzeg
         3MTcijUcrpgueLJd21mwEfYDRMiy+3mq8Z+lzBD3lQJPA/OHWhq+X/OPwJE2Kc3SCe5O
         cBlOjDCI2v3VD32QFFaptomk4CxQFG9Jt/IBuXvA4l1wMmRIjolYZYztI2pnxD2CgWBC
         /4XeOik586yrwDztDzma+84oR0uPqCD6QSkxxlv/pf3M7VDW20owOZ/HJEoXlbn0DySQ
         r/6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rictj+Qm0LQXHqbH3hWSwYOizIiK+569WyJPDSyU/rM=;
        b=rZy7ovCymIr6uYUyS1A6o5phO5HLUdUX5AaxBDXgppiAYzNFJgbhgX0PtwUfICY0QE
         zA/xWQhRo5mi1AQ+2zIaXdHrcQ4nFvv3fYvRZuAHRoeDAExbyLrvZ7C5EeOzh5nBgDQV
         Sx0Ch7ypDx5mG0tqN4xpTtyvA7YmpUeQyAkc2eeo2ODGAVkwujLsd7pyhbUtHpErAeNc
         5YYhFS0qwWB8ieoYWxeQQvWvhTeLypw72JdnrBF7tP6py8+1jeCj5jwIOFkNZ7s+vEK/
         CRXQBjfN9YtBeENYqtJllaV4jvjJLEldMpmqqz+X3PMuiHQaqhaTV99l5YbIBMG69o6M
         CP+A==
X-Gm-Message-State: APjAAAXdJ6+ZnGpHCeGRM39Ptfzt5VYQK6JB78sphi/xQKkgolCFrBVx
        6q/tnMNxdqbD+hsW+CaqhxTsVvSP
X-Google-Smtp-Source: APXvYqyDBattDjWc9UlHZrsEouI7PMUtB7vqKfXzRoEKLK2QuJpNk9k6BaZpThCCD+FSuRkGJpE04g==
X-Received: by 2002:adf:e343:: with SMTP id n3mr122890130wrj.103.1564993629831;
        Mon, 05 Aug 2019 01:27:09 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id w23sm90645706wmi.45.2019.08.05.01.27.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 01:27:09 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
X-Google-Original-From: Hubert Feurstein <hubert.feurstein@vahle.at>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next v2] net: dsa: mv88e6xxx: extend PTP gettime function to read system clock
Date:   Mon,  5 Aug 2019 10:26:42 +0200
Message-Id: <20190805082642.12873-1-hubert.feurstein@vahle.at>
X-Mailer: git-send-email 2.22.0
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
 drivers/net/dsa/mv88e6xxx/ptp.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/ptp.c b/drivers/net/dsa/mv88e6xxx/ptp.c
index 073cbd0bb91b..2ebc7db0fd4a 100644
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
+	ptp_read_system_prets(sts);
 	ns = timecounter_read(&chip->tstamp_tc);
+	ptp_read_system_postts(sts);
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
-- 
2.22.0

