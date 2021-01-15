Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB492F7ABD
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 13:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387950AbhAOMyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 07:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387774AbhAOMyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 07:54:02 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A8CC0613D3
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 04:53:22 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id a12so12975319lfl.6
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 04:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=WXU6LCbjZRUNTxHkJgA2g+DcMl+jPYZ0Dxof4MXGYZo=;
        b=URKxTnCYMpCpebyvgZMl3kwMq/blOJQ4i+PbMvLN2jjxPWAFtO5ZdJmErXo1NdJsLV
         b0PZ6hcKjUux5K9pJDV1URdUDoaqFj17ZM9dfQEQ+eC+DqgPpT3Q3KiGWblZQ0yVJXIs
         K3VjTS1ZTv5dUfRhFiogY3rPiy1a+YFlVZihr3gFKljzpavX44m8tmUkSoMlh4kMrua4
         Q/DgHBC473O2X2fXyS2GPI+DMeC/MKISY45AknBTpWmLjTzvW/zUW3aZbLKd7JZNq/cZ
         FJ9KJN2w5lbFs/GeRYAaVj0C7ky/0OLz/SE8LggWdc2jDMI2n+vaeNJA0o3Ry9FjPRBN
         EfzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=WXU6LCbjZRUNTxHkJgA2g+DcMl+jPYZ0Dxof4MXGYZo=;
        b=LFvcSUKRhJoQ3MR+nJS27zsTMALnO0/Y9xjJonziXLGbmzMeifMMu8ft/kvw8rW16x
         Q5oapjODNarM2m1G00Fiz4i2BRfsx20C2S781Zb9pN3iFMJNQLG2s5yx9fnH0MYxo38A
         XpggFClgAYs2T+qqpGXMZoRg+zmCFuKu5+Y/ArWazNCknkHEZrg03ezpsKrSQTp+9dY3
         lzsVvPS7w4hnlVb3xb5EuftaWYuP8rgKXODGaflP21NyopCXn3K9OhqS/GKdIzAXY3il
         R1cXWCZLcgPdWZ7rhIxYUWEEznL/GrZYTqHoJzFTuT/Nb3X2HVKdOY17pAzMCqsHOnkm
         8pyg==
X-Gm-Message-State: AOAM531BZlTzMQTxWli7BdWexsDVJFNlKKjdgPViI35oyfbH26RE7sFY
        5ZWXh0+Cp9Ic/SwTQO79Hrt6HQ==
X-Google-Smtp-Source: ABdhPJw5SiR/eDBuGwhx6OQevAXl6COMRWnLGLUQnEjYHgxCdUtujgkflpxpNHNKrBo56geH3reXag==
X-Received: by 2002:a19:6b19:: with SMTP id d25mr5730120lfa.282.1610715200615;
        Fri, 15 Jan 2021 04:53:20 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id u22sm892590lfu.46.2021.01.15.04.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 04:53:20 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 2/2] net: dsa: mv88e6xxx: Only allow LAG offload on supported hardware
Date:   Fri, 15 Jan 2021 13:52:59 +0100
Message-Id: <20210115125259.22542-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210115125259.22542-1-tobias@waldekranz.com>
References: <20210115125259.22542-1-tobias@waldekranz.com>
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are chips that do have Global 2 registers, and therefore trunk
mapping/mask tables are not available. Refuse the offload as early as
possible on those devices.

Fixes: 57e661aae6a8 ("net: dsa: mv88e6xxx: Link aggregation support")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 6 +++++-
 drivers/net/dsa/mv88e6xxx/chip.h | 5 +++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index dcb1726b68cc..91286d7b12c7 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5385,9 +5385,13 @@ static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
 				      struct net_device *lag,
 				      struct netdev_lag_upper_info *info)
 {
+	struct mv88e6xxx_chip *chip = ds->priv;
 	struct dsa_port *dp;
 	int id, members = 0;
 
+	if (!mv88e6xxx_has_lag(chip))
+		return false;
+
 	id = dsa_lag_id(ds->dst, lag);
 	if (id < 0 || id >= ds->num_lag_ids)
 		return false;
@@ -5727,7 +5731,7 @@ static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
 	 * 5-bit port mode, which we do not support. 640k^W16 ought to
 	 * be enough for anyone.
 	 */
-	ds->num_lag_ids = 16;
+	ds->num_lag_ids = mv88e6xxx_has_lag(chip) ? 16 : 0;
 
 	dev_set_drvdata(dev, ds);
 
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 3543055bcb51..788b3f585ef3 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -662,6 +662,11 @@ static inline bool mv88e6xxx_has_pvt(struct mv88e6xxx_chip *chip)
 	return chip->info->pvt;
 }
 
+static inline bool mv88e6xxx_has_lag(struct mv88e6xxx_chip *chip)
+{
+	return !!chip->info->global2_addr;
+}
+
 static inline unsigned int mv88e6xxx_num_databases(struct mv88e6xxx_chip *chip)
 {
 	return chip->info->num_databases;
-- 
2.17.1

