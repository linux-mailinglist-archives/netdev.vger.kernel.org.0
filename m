Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8A2340E2F
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 20:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbhCRT02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 15:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbhCRTZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 15:25:51 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D7EC06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 12:25:51 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id e9so6738814wrw.10
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 12:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=QZ+BmjWfdM0TaLrjQBL3VVczhh71klPVNAd/B6Z/d/E=;
        b=oZRszZh708TywdWKoT9dYHSwsPOizUQJlWXqlJSV2Yf/KWhxAo/LO0a//IKwA5cQdb
         IOfZTahkkSP6V7toUsLBhYJLPnPVFw+4AqUwi4gDzE2l1Apx91ExS6fAqWn953QzN2Z8
         urocdEDCJVPneCi9PpGMxHFKUj5JCK/FEsYSq3gG0f77a0yd8vVLeNmdorHkDPhVypE4
         tTsJV/KsO1RxljJ8ZDZkQBpBa2h31P/DCFFur3vDZAgeM7iQaEEw5Zx79M6BlFUA8yhN
         5hLYtMII9SDbhzUbwXVqWDiKHQoCchaXV7SCVqlJThtAYDzn7ICd6ekPHfU81aVXbmox
         vqug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=QZ+BmjWfdM0TaLrjQBL3VVczhh71klPVNAd/B6Z/d/E=;
        b=LRgttiY1MBzx0Z3y5VTSwu32oRY3nQ5m6CxH1BVbARYtQvo9t01ihkeiD0A+X9hdWt
         mkAHqzO2hvfOtL/llP/ATZHmeRofkDmUeIHsf/D48zIOHOfvWlELjZqHeGDmjz4CXf8I
         duXDO7DWqF32FxfyDLrc8ffTApHjpffBC2zrxQjhxo2GJ+Rztx7Closb2MCfaKJ5ZEm1
         L3LcR2q/nx87qOFzhFFnNc2Ez/RLiT9Pzux5DT+lq+NY1q0AOJRLjX/APgTUDIl+b1b3
         LhIHYiZ+7wiKbnDvfsTipo5sHF4g0CfATHi+yU419jC+Wv6Z3Thp2VGxTVIXumKDAYDS
         8Qig==
X-Gm-Message-State: AOAM533Tjx7DcbZNkoAhEd8yrbsd4UNV4OF4GKax7v6T3XEK40JVJMif
        ubxY4gbLG8Nmw9hCzM5tZLdG6Q==
X-Google-Smtp-Source: ABdhPJznYX9RkbhQyYd0cr4VcfItXggLpZOExwvNuEJwv9rAsP+bpot0u+5V3U2HYNKAra71nldUEw==
X-Received: by 2002:adf:f4c1:: with SMTP id h1mr810896wrp.71.1616095550160;
        Thu, 18 Mar 2021 12:25:50 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id j30sm4576443wrj.62.2021.03.18.12.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 12:25:49 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 6/8] net: dsa: mv88e6xxx: Flood all traffic classes on standalone ports
Date:   Thu, 18 Mar 2021 20:25:38 +0100
Message-Id: <20210318192540.895062-7-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318192540.895062-1-tobias@waldekranz.com>
References: <20210318192540.895062-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In accordance with the comment in dsa_port_bridge_leave, standalone
ports shall be configured to flood all types of traffic. This change
aligns the mv88e6xxx driver with that policy.

Previously a standalone port would initially not egress any unknown
traffic, but after joining and then leaving a bridge, it would.

This does not matter that much since we only ever send FROM_CPUs on
standalone ports, but it seems prudent to make sure that the initial
values match those that are applied after a bridging/unbridging cycle.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 17578f774683..587959b78c7f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2489,19 +2489,15 @@ static int mv88e6xxx_setup_message_port(struct mv88e6xxx_chip *chip, int port)
 
 static int mv88e6xxx_setup_egress_floods(struct mv88e6xxx_chip *chip, int port)
 {
-	struct dsa_switch *ds = chip->ds;
-	bool flood;
 	int err;
 
-	/* Upstream ports flood frames with unknown unicast or multicast DA */
-	flood = dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port);
 	if (chip->info->ops->port_set_ucast_flood) {
-		err = chip->info->ops->port_set_ucast_flood(chip, port, flood);
+		err = chip->info->ops->port_set_ucast_flood(chip, port, true);
 		if (err)
 			return err;
 	}
 	if (chip->info->ops->port_set_mcast_flood) {
-		err = chip->info->ops->port_set_mcast_flood(chip, port, flood);
+		err = chip->info->ops->port_set_mcast_flood(chip, port, true);
 		if (err)
 			return err;
 	}
-- 
2.25.1

