Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C4E36B69B
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 18:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234231AbhDZQSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 12:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234124AbhDZQSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 12:18:23 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD23C061574
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 09:17:40 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id j4so49654331lfp.0
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 09:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=UQt5LkmsM4qullOzCTCJ9P0dsTZp1F5rxXWORxcxMTI=;
        b=Bl41hpDpokgxvI+xW76HD1QEl/RR22mG80UUKJo8iE52Biv1GOu61IoojFcC9y2gOC
         ZNsD9PPOWKIZGCKx7UjgEGxKmprcp3PKByL97VIxd4J5PRQkI6ghQvC+hKDHexd0ZNtc
         SJntJ1O6P4xTUfldNVyG59v38I3eQOHiKpu8PiMQTtY5nSP+cRlPJK6k7mV2dmiivaQi
         xlYvscs6Tghj5j7puOI7wTQizY9M9FdSNZZmAkIyKU+Lr/wDhvaguYByBbDGRQm9Cv+Z
         knGOsyLe3sR01aVaiSsssK3oi3mMfyReSs1hvJR8huP/FIwgCMOcB9ACfZtk7qMGRJ6h
         pKwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=UQt5LkmsM4qullOzCTCJ9P0dsTZp1F5rxXWORxcxMTI=;
        b=s19CPSbsTXaP3GKW1g4rAn6qyRlr2wDS35EzgjG6D4wV1YTLTEwO5/x95+DcPYPDKq
         agPK2DyQzyT0T0GSQy/epEUmC9AqOH0zLuicrG8l98Z3N/pTnDxXj1HFG4f+6puye3vU
         SEwktmeTLeGN3gD4i89advYUSwXW4Bv8IQZfPSL/kZC0tVROfmULhDBD2TnKhSoSwZ0T
         TpX29Ohd9YPjV77QoB7bc6DUE+N9ASkzOHFNJd9i9zWJowxdVgoeTRDiWdwkZj/qS66J
         BcEIj64U1x99UozTAh6X/brzbV0JBXhSOd6VN8+pmroP2/YnoJ8fUkFvXxx+7zhymAsj
         h2dg==
X-Gm-Message-State: AOAM533V3kf9/nQ3SmyHCQGIQEPGkGyd3WIj4fNWVcuCZG8YBcaTU6oI
        R+p5qnxHhGrw7UjlTvgRECoNmw==
X-Google-Smtp-Source: ABdhPJxHcsKLHpxVruwUMbHrkaPPEfZMi8lzQ51zwjLuEHhPnFLfmnS8uOXNJMtrA603L6ZOJB5Cig==
X-Received: by 2002:ac2:533b:: with SMTP id f27mr13680402lfh.244.1619453858477;
        Mon, 26 Apr 2021 09:17:38 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id c13sm46326ljf.120.2021.04.26.09.17.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 09:17:37 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net-next] net: dsa: mv88e6xxx: Fix 6095/6097/6185 ports in non-SERDES CMODE
Date:   Mon, 26 Apr 2021 18:17:34 +0200
Message-Id: <20210426161734.1735032-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The .serdes_get_lane op used the magic value 0xff to indicate a valid
SERDES lane and 0 signaled that a non-SERDES mode was set on the port.

Unfortunately, "0" is also a valid lane ID, so even when these ports
where configured to e.g. RGMII the driver would set them up as SERDES
ports.

- Replace 0xff with 0 to indicate a valid lane ID. The number is on
  the one hand just as arbitrary, but it is at least the first valid one
  and therefore less of a surprise.

- Follow the other .serdes_get_lane implementations and return -ENODEV
  in the case where no SERDES is assigned to the port.

Fixes: f5be107c3338 ("net: dsa: mv88e6xxx: Support serdes ports on MV88E6097/6095/6185")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 470856bcd2f3..e4fbef81bc52 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -443,15 +443,15 @@ int mv88e6185_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 int mv88e6185_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 {
 	/* There are no configurable serdes lanes on this switch chip but we
-	 * need to return non-zero so that callers of
+	 * need to return a non-negative lane number so that callers of
 	 * mv88e6xxx_serdes_get_lane() know this is a serdes port.
 	 */
 	switch (chip->ports[port].cmode) {
 	case MV88E6185_PORT_STS_CMODE_SERDES:
 	case MV88E6185_PORT_STS_CMODE_1000BASE_X:
-		return 0xff;
-	default:
 		return 0;
+	default:
+		return -ENODEV;
 	}
 }
 
-- 
2.25.1

