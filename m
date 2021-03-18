Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA0D340E2C
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 20:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbhCRT0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 15:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbhCRTZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 15:25:48 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE45EC06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 12:25:47 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id k8so6731801wrc.3
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 12:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=y/jDzmJtmXJqAO2HChpQw77GavIlzk/eV/H2eZFxXgY=;
        b=AcP1KBPMCck6Pcb1LU3Eze1XS9aT4VZgp19ZdQzdSM9JrgH1VgbIH83EW62cKjAmSD
         rq8/veHdzuWf2f47ehBN9lFPa7PwCjSpCWWUYkh0rH+3aqr3uqzG9dmC5+pQMpnm63wQ
         9rQnxSSjGqfX6oDG/RQgaiXU5m1ulVK+DjBHhaXPzsBdLNvpBa/PDOlWFDrdxTRhOkMa
         B1zUQvMct2bgyjyrbAL5eqIR680j4NdpdR4YJCumf8DxUU9BFd+Svq94kQ4hs0GwJ3aw
         ywiCMR+k59ulDe7tQG7op4Ae5y/0lNB7r3OFoZmU073zqHBqReva9W6n4BKX8hslBAsD
         7zjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=y/jDzmJtmXJqAO2HChpQw77GavIlzk/eV/H2eZFxXgY=;
        b=Al4jaOq6qIHMEut8LlbhL1DsFDCGwCZnfRYYWj1bVuZYHfbhq/wEaFd8BjvAf+kOL2
         j0QeyCn4U7I2qLqeaAhyksSYwtrzIXjO+iZynkMB0Dg/ckjPMsxEypAjGEFxrcyQj0rO
         otGVOni3S6O43sxuI7VvzyFNNPH1QfNGLj8lmPoKeuJ3b9K56nE4hnEXqVIlVEBKlXGp
         q7UNOcH856tX4fRoiK2O9OYhn1n94rWW+hPGFCcaV+fra9+5XX4fRNWlthwZnBuAZaCN
         UMsgW5suvSkfx/oWlkhPdZ87i5RR8doiCw9TZaDNnE4SW95FSghXpK8Advdh3asoWk2W
         GJoA==
X-Gm-Message-State: AOAM530sQSsMdwA1FK7Pkqmv0Y/Xz0hVlV2bTG3DHxRMGCZflcECfYZT
        zgGc9Z/km7UlzY1VNeEIVn44JA==
X-Google-Smtp-Source: ABdhPJyf7ONLEmz/S/ZAol/ZNEYmbJOLQnGMUPNCeJWzosTeiHKQWAIhbEXxIc1llZOuYzwRR2rcig==
X-Received: by 2002:adf:e5c4:: with SMTP id a4mr847069wrn.174.1616095546600;
        Thu, 18 Mar 2021 12:25:46 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id j30sm4576443wrj.62.2021.03.18.12.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 12:25:46 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 2/8] net: dsa: mv88e6xxx: Avoid useless attempts to fast-age LAGs
Date:   Thu, 18 Mar 2021 20:25:34 +0100
Message-Id: <20210318192540.895062-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318192540.895062-1-tobias@waldekranz.com>
References: <20210318192540.895062-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a port is a part of a LAG, the ATU will create dynamic entries
belonging to the LAG ID when learning is enabled. So trying to
fast-age those out using the constituent port will have no
effect. Unfortunately the hardware does not support move operations on
LAGs so there is no obvious way to transform the request to target the
LAG instead.

Instead we document this known limitation and at least avoid wasting
any time on it.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index f0a9423af85d..ed38b4431d74 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1479,6 +1479,13 @@ static void mv88e6xxx_port_fast_age(struct dsa_switch *ds, int port)
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
+	if (dsa_to_port(ds, port)->lag_dev)
+		/* Hardware is incapable of fast-aging a LAG through a
+		 * regular ATU move operation. Until we have something
+		 * more fancy in place this is a no-op.
+		 */
+		return;
+
 	mv88e6xxx_reg_lock(chip);
 	err = mv88e6xxx_g1_atu_remove(chip, 0, port, false);
 	mv88e6xxx_reg_unlock(chip);
-- 
2.25.1

