Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B17D49FE03
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 17:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237859AbiA1Q05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 11:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234838AbiA1Q05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 11:26:57 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D50C06173B
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 08:26:56 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id z7so9775772ljj.4
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 08:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=/TiQff5wo3sO+pFFw8tQM78i8yOOCdG1QUdQMAaCrlI=;
        b=Do2Gi2DKC15Aw4E1xojPxTgGkV5ex3ur2btG97aL4HsoKMU75Fm7UiNPtsxMQ+1j24
         kmfziPNoo5ML2ZvB/9CMGQ+I7JL9d7LP/2zVGq6nqyb465w8dPPbcXpM3E5UHlLqtqOn
         e1exTLIzNhkszp9vq9EJZ7cg+9FuI+APNSk3TBpLfbXs4bn0x3dtvZLeBIBHh22V1z8C
         vg/O4SO26LWluC2kyAj6Z0cgVeKmhCedEyXfOeHvh0vmM6REEdpgxkGWDqXp3hkJ1lGI
         Q5q3N3GQBg3MphXbz/BmC4podMB5XoYSe3WljznxqNz89hKmaYqHBaRLq8dyQQoGSM6t
         uGFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=/TiQff5wo3sO+pFFw8tQM78i8yOOCdG1QUdQMAaCrlI=;
        b=sxUCUBVtlreXBmWB/sNjUgSSTOkVP1YN4QoljcoU9SLYLiCIyt+RvuizJKKCXPbCHz
         +0Mbav9ubf1TY7owJeQsWy09aHH00gNq63AwF2UZ47QyCmUPlo1kMbAsLWTqQHtpNpko
         AiVqkYdDjb6n1fsWU6ufpxJfA+pKTuwyt4vwL74h3K17mwhsoLa1pNwDHDCoaainGPIe
         x/doVStaZOrEwdBVaCiBhYz6Nil1e8M9rpZaoyIXHmyuaqpQU7kvpVl9Ik2JhzwrCyz5
         WUDERGwyC2UgqyIZbNMCMZOFt7+1B7NiMVB5l8VMZVT/SC2PQTHC80qkFQYP4txjrV8K
         nIwQ==
X-Gm-Message-State: AOAM531mZbHAaSy6P99TL1ha2jMFQMJ5MUUH/FdC1s38FnxHev5i++PJ
        VZWLqzBSnVj6S9FW24YJb0X5wQ==
X-Google-Smtp-Source: ABdhPJzSHByW4xTH8eUue4xiNcYHA0VKcrlvg+qpGX98quOT7UB+t9wN+tJ6l3foTKqOk/lYCcMzrg==
X-Received: by 2002:a05:651c:1509:: with SMTP id e9mr889498ljf.155.1643387214989;
        Fri, 28 Jan 2022 08:26:54 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v17sm1954968ljh.5.2022.01.28.08.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 08:26:54 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, David.Laight@ACULAB.COM,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 1/2] net: dsa: mv88e6xxx: Improve performance of busy bit polling
Date:   Fri, 28 Jan 2022 17:26:49 +0100
Message-Id: <20220128162650.2510062-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220128162650.2510062-1-tobias@waldekranz.com>
References: <20220128162650.2510062-1-tobias@waldekranz.com>
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
 drivers/net/dsa/mv88e6xxx/chip.c | 13 ++++++++++---
 drivers/net/dsa/mv88e6xxx/smi.c  | 11 +++++++++--
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 58ca684d73f7..1023e4549359 100644
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
@@ -99,7 +103,10 @@ int mv88e6xxx_wait_mask(struct mv88e6xxx_chip *chip, int addr, int reg,
 		if ((data & mask) == val)
 			return 0;
 
-		usleep_range(1000, 2000);
+		if (i < 2)
+			cpu_relax();
+		else
+			usleep_range(1000, 2000);
 	}
 
 	dev_err(chip->dev, "Timeout while waiting for switch\n");
diff --git a/drivers/net/dsa/mv88e6xxx/smi.c b/drivers/net/dsa/mv88e6xxx/smi.c
index 282fe08db050..728ef3f54ec5 100644
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
@@ -67,7 +71,10 @@ static int mv88e6xxx_smi_direct_wait(struct mv88e6xxx_chip *chip,
 		if (!!(data & BIT(bit)) == !!val)
 			return 0;
 
-		usleep_range(1000, 2000);
+		if (i < 2)
+			cpu_relax();
+		else
+			usleep_range(1000, 2000);
 	}
 
 	return -ETIMEDOUT;
-- 
2.25.1

