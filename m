Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A1849D5FC
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 00:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbiAZXM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 18:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233340AbiAZXM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 18:12:56 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F61C061747
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 15:12:55 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id z7so1726053ljj.4
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 15:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=G9Hu+JeymXvWuatFDwPB/oJw84mqyQsQKnr50lHjCVs=;
        b=ZylTsiYlkM5bSFlaXvMfbJ2nPRWztPZCRUYR66IzkY1yBZig/210jDM8waw+fJrPmn
         P3icxCvofFj258zwjgD9ZqgVYYo8xSsbD62lT7GPfWN23gkpO8zFlK0njmv0btVh0SGh
         WfAf6TN3eEtrVgqhGbphOmmY3KdVtMzyrMpg1dta/RLAlJG3p/51xLGgCzQDWH79cSyF
         jsG6TDz1gnp2kdw0heMaMIxBZopmwHpX5Yp51g7vJ0N5jLAjjYT+3/yGroTjQXgoJHN0
         Wz+tDplZxqoZBxmMjMPu8xWHrR8520GYkv3m1yVLdrNH6mCdcezz7XPCcczTYlf76V+Z
         V24A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=G9Hu+JeymXvWuatFDwPB/oJw84mqyQsQKnr50lHjCVs=;
        b=7JhLKeVXee2NYu7xIoLNRoG3KGarM/iJW9muGu0C5mj3+MlMh/96Ci8Ktn+kcEyLmz
         O3QEI6yR9vh5AndaHWia5eTyk7y4LOBNOJ9DOrvr5gMvGB4llmZCDgAUDsc84p0tpDhH
         fi8a5chEgzcu/fnkxXVjgTOx12WY+lRRhaDHjvmj8mSgZjE4AqTyTUH83aqc4c06KV2w
         SI1U9UwYHkCvsNWMq+IUKpPSNNwzu14RrgUBIT2Ng9BBFo8mcq/1ZEDAougv3g2VN+yX
         XnTpggk/Vl7c2Hs/wGOtxBsjOsHGcP8mDIXVc03HCc2xPC63tVP7c2IZp2dN/HgnidWf
         B/Mg==
X-Gm-Message-State: AOAM530lBrN0//XYscVXHl4UVcUX4sE8QFVXQbJTcv5AHE50iOCOUkEL
        5HAjzpax09alTndG9KdOPFZsuA==
X-Google-Smtp-Source: ABdhPJxfwFAn/ctQGGBzoRN89vhxvau3FkI7yFI8xwhLLRtSVdrKkafz/Q0jM7lgr+1rrfDCOLqZAw==
X-Received: by 2002:a2e:bf15:: with SMTP id c21mr971797ljr.396.1643238773890;
        Wed, 26 Jan 2022 15:12:53 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id p28sm1529335lfo.79.2022.01.26.15.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 15:12:52 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] net: dsa: mv88e6xxx: Improve performance of busy bit polling
Date:   Thu, 27 Jan 2022 00:12:38 +0100
Message-Id: <20220126231239.1443128-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220126231239.1443128-1-tobias@waldekranz.com>
References: <20220126231239.1443128-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid a long delay when a busy bit is still set and has to be polled
again.

Measurements on a system with 2 Opals (6097F) and one Agate (6352)
show that even with this much tighter loop, we have about a 50% chance
of the bit being cleared on the first poll, all other accesses see the
bit being cleared on the second poll.

On a standard MDIO bus running MDC at 2.5MHz, a single access with 32
bits of preamble plus 32 bits of data takes 64*(1/2.5MHz) = 25.6us.

This means that mv88e6xxx_smi_direct_wait took 26us + CPU overhead in
the fast scenario, but 26us + 1500us + 26us + CPU overhead in the slow
case - bringing the average close to 1ms.

With this change in place, the slow case is closer to 2*26us + CPU
overhead, with the average well below 100us - a 10x improvement.

This translates to real-world winnings. On a 3-chip 20-port system,
the modprobe time drops by 88%:

Before:

root@coronet:~# time modprobe mv88e6xxx
real    0m 15.99s
user    0m 0.00s
sys     0m 1.52s

After:

root@coronet:~# time modprobe mv88e6xxx
real    0m 2.21s
user    0m 0.00s
sys     0m 1.54s

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 8 ++++----
 drivers/net/dsa/mv88e6xxx/smi.c  | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 58ca684d73f7..3566617143cf 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -86,12 +86,12 @@ int mv88e6xxx_write(struct mv88e6xxx_chip *chip, int addr, int reg, u16 val)
 int mv88e6xxx_wait_mask(struct mv88e6xxx_chip *chip, int addr, int reg,
 			u16 mask, u16 val)
 {
+	const unsigned long timeout = jiffies + msecs_to_jiffies(50);
 	u16 data;
 	int err;
-	int i;
 
 	/* There's no bus specific operation to wait for a mask */
-	for (i = 0; i < 16; i++) {
+	do {
 		err = mv88e6xxx_read(chip, addr, reg, &data);
 		if (err)
 			return err;
@@ -99,8 +99,8 @@ int mv88e6xxx_wait_mask(struct mv88e6xxx_chip *chip, int addr, int reg,
 		if ((data & mask) == val)
 			return 0;
 
-		usleep_range(1000, 2000);
-	}
+		cpu_relax();
+	} while (time_before(jiffies, timeout));
 
 	dev_err(chip->dev, "Timeout while waiting for switch\n");
 	return -ETIMEDOUT;
diff --git a/drivers/net/dsa/mv88e6xxx/smi.c b/drivers/net/dsa/mv88e6xxx/smi.c
index 282fe08db050..a59f32243e08 100644
--- a/drivers/net/dsa/mv88e6xxx/smi.c
+++ b/drivers/net/dsa/mv88e6xxx/smi.c
@@ -55,11 +55,11 @@ static int mv88e6xxx_smi_direct_write(struct mv88e6xxx_chip *chip,
 static int mv88e6xxx_smi_direct_wait(struct mv88e6xxx_chip *chip,
 				     int dev, int reg, int bit, int val)
 {
+	const unsigned long timeout = jiffies + msecs_to_jiffies(50);
 	u16 data;
 	int err;
-	int i;
 
-	for (i = 0; i < 16; i++) {
+	do {
 		err = mv88e6xxx_smi_direct_read(chip, dev, reg, &data);
 		if (err)
 			return err;
@@ -67,8 +67,8 @@ static int mv88e6xxx_smi_direct_wait(struct mv88e6xxx_chip *chip,
 		if (!!(data & BIT(bit)) == !!val)
 			return 0;
 
-		usleep_range(1000, 2000);
-	}
+		cpu_relax();
+	} while (time_before(jiffies, timeout));
 
 	return -ETIMEDOUT;
 }
-- 
2.25.1

