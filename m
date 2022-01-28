Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA11849F790
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 11:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiA1Kt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 05:49:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243890AbiA1Kty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 05:49:54 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B550C06173B
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 02:49:54 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id x23so11057988lfc.0
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 02:49:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=P3RVmK1/PHIT/K/vRfwQmZuyVW8oc6qkrGNE4RBfJ2s=;
        b=LYUosqZrCVV8Wc3nPps9qFzsrFbdjYOAITcmqa1/iVhhfdPpFNWOdaqFPZPt9ZnGOh
         7bLHUbwqEfJ4cdgqrjm0yACCpI2dkABzx335mERYjpJrvJ58h2HmqQz0b3t+FzUO0c6d
         WSgAKbGoNg5ykXkcG9q8BQQFxRBGxcxhSwUocDKtMyDqKO5IwcnAAN1UwlWEhugMppvs
         ZCmaTwquqawqmhdeid9ce+MfR2IKH1RGTFUr4VhKpjxL/Pmj3A75WrcIjDO1vdpHqWMS
         QzRcQQFzTBJ+mcghyCxLJlhg1tHX/2eyd5rabm425EsHG13OeppwAiEobBvAknOSpGyo
         3vLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=P3RVmK1/PHIT/K/vRfwQmZuyVW8oc6qkrGNE4RBfJ2s=;
        b=xz04awP1pv6z+pEWaw8ArppSYdmygJblVs+uIRX+iV/V0Oix2tsxsXEQKGMCK5uzUv
         p0W0TYShcfWC2xyepU97MDb1kJxEFr8Ad5GwYY4GujZe9hNJzqISmbcwdSZ925nU9O9F
         A084uL8OPzT+ENn/PjpHY2SshmVerFoR2dHyCije9QnPVTiCY2VzyoeCYu6FhWqjyFwu
         tV6/0jxnmTpXpRmO0h6vzhvRfYXQzF82cwJps4vnVhD9BTfjbcZvFwbsEneIpJX9oCoC
         n4o7Mp1YBP+xt1DHVOV8m9Ofwe5DkS7rLBFQUEki12oMzRmQZsqzKwMjcH9lql/9/pF0
         LFWw==
X-Gm-Message-State: AOAM53382+KmbzvP8xq2XSfdZevh2uWHyPVJaKKDyB35OhfYkK831qBe
        NI+UZHLEjh8et4vRCReeyOvdnQ==
X-Google-Smtp-Source: ABdhPJzIV/VTGbhlSzkuNYaYy5pxDnHyHZ1g/VR9w+3doTyseuzu+bKuwXrxMAXHtImqyk/2k2W7jg==
X-Received: by 2002:a19:8c19:: with SMTP id o25mr5632962lfd.300.1643366992489;
        Fri, 28 Jan 2022 02:49:52 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v29sm1931347ljv.72.2022.01.28.02.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 02:49:52 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 1/2] net: dsa: mv88e6xxx: Improve performance of busy bit polling
Date:   Fri, 28 Jan 2022 11:49:37 +0100
Message-Id: <20220128104938.2211441-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220128104938.2211441-1-tobias@waldekranz.com>
References: <20220128104938.2211441-1-tobias@waldekranz.com>
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
 drivers/net/dsa/mv88e6xxx/chip.c | 10 +++++++---
 drivers/net/dsa/mv88e6xxx/smi.c  |  8 ++++++--
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 58ca684d73f7..de8a568a8c53 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -86,12 +86,16 @@ int mv88e6xxx_write(struct mv88e6xxx_chip *chip, int addr, int reg, u16 val)
 int mv88e6xxx_wait_mask(struct mv88e6xxx_chip *chip, int addr, int reg,
 			u16 mask, u16 val)
 {
+	const unsigned long timeout = jiffies + msecs_to_jiffies(50);
 	u16 data;
 	int err;
 	int i;
 
-	/* There's no bus specific operation to wait for a mask */
-	for (i = 0; i < 16; i++) {
+	/* There's no bus specific operation to wait for a mask. Even
+	 * if the initial poll takes longer than 50ms, always do at
+	 * least one more attempt.
+	 */
+	for (i = 0; time_before(jiffies, timeout) || (i < 2); i++) {
 		err = mv88e6xxx_read(chip, addr, reg, &data);
 		if (err)
 			return err;
@@ -99,7 +103,7 @@ int mv88e6xxx_wait_mask(struct mv88e6xxx_chip *chip, int addr, int reg,
 		if ((data & mask) == val)
 			return 0;
 
-		usleep_range(1000, 2000);
+		cpu_relax();
 	}
 
 	dev_err(chip->dev, "Timeout while waiting for switch\n");
diff --git a/drivers/net/dsa/mv88e6xxx/smi.c b/drivers/net/dsa/mv88e6xxx/smi.c
index 282fe08db050..466d2aaa9fcb 100644
--- a/drivers/net/dsa/mv88e6xxx/smi.c
+++ b/drivers/net/dsa/mv88e6xxx/smi.c
@@ -55,11 +55,15 @@ static int mv88e6xxx_smi_direct_write(struct mv88e6xxx_chip *chip,
 static int mv88e6xxx_smi_direct_wait(struct mv88e6xxx_chip *chip,
 				     int dev, int reg, int bit, int val)
 {
+	const unsigned long timeout = jiffies + msecs_to_jiffies(50);
 	u16 data;
 	int err;
 	int i;
 
-	for (i = 0; i < 16; i++) {
+	/* Even if the initial poll takes longer than 50ms, always do
+	 * at least one more attempt.
+	 */
+	for (i = 0; time_before(jiffies, timeout) || (i < 2); i++) {
 		err = mv88e6xxx_smi_direct_read(chip, dev, reg, &data);
 		if (err)
 			return err;
@@ -67,7 +71,7 @@ static int mv88e6xxx_smi_direct_wait(struct mv88e6xxx_chip *chip,
 		if (!!(data & BIT(bit)) == !!val)
 			return 0;
 
-		usleep_range(1000, 2000);
+		cpu_relax();
 	}
 
 	return -ETIMEDOUT;
-- 
2.25.1

